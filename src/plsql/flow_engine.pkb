/* 
-- Flows for APEX - flow_engine.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created  11-Sep-2020  Richard Allen (Flowquest)
-- Modified 30-May-2022  Moritz Klein (MT AG)
--
*/
create or replace package body flow_engine
as 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  function flow_get_matching_link_object
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , pi_dgrm_id      in flow_diagrams.dgrm_id%type 
  , pi_link_bpmn_id in flow_objects.objt_name%type
  ) return varchar2
  is 
      l_matching_catch_event  flow_objects.objt_bpmn_id%type;
  begin 
      select catch_objt.objt_bpmn_id
        into l_matching_catch_event
        from flow_objects catch_objt
        join flow_objects throw_objt
          on catch_objt.objt_name = throw_objt.objt_name
          and catch_objt.objt_dgrm_id = throw_objt.objt_dgrm_id
          and catch_objt.objt_objt_id = throw_objt.objt_objt_id
        where throw_objt.objt_dgrm_id = pi_dgrm_id
          and throw_objt.objt_bpmn_id = pi_link_bpmn_id
          and catch_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_link_event_definition
          and throw_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_link_event_definition
          and catch_objt.objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event        
          and throw_objt.objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_throw_event   
          ;
      return l_matching_catch_event;
  exception
    when no_data_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => p_subflow_id
        , pi_message_key => 'link-no-catch'
        , p0 => pi_link_bpmn_id
        );
        return null;
        -- $F4AMESSAGE 'link-no-catch' || 'Unable to find matching link catch event named %0.'  
    when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => p_subflow_id
        , pi_message_key => 'link-too-many-catches'
        , p0 => pi_link_bpmn_id
        );
        return null;
        -- $F4AMESSAGE 'link-too-many-catches' || 'More than one matching link catch event named %0.'  
  end flow_get_matching_link_object;

procedure flow_process_link_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
is 
    l_next_objt      flow_objects.objt_bpmn_id%type;
begin 
    apex_debug.enter 
    ( 'flow_process_link_event'
    , 'Process', p_process_id
    , 'Subflow', p_subflow_id
    );
    -- find matching link catching event and step to it
    l_next_objt := flow_get_matching_link_object 
      ( p_process_id    => p_process_id
      , p_subflow_id    => p_subflow_id
      , pi_dgrm_id      => p_step_info.dgrm_id
      , pi_link_bpmn_id => p_step_info.target_objt_ref
      );
  
    -- proceed if link found cleanly
    if not flow_globals.get_step_error then
      -- update current step info before logging
      update flow_subflows sbfl
          set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- log throw event as complete
      flow_logging.log_step_completion   
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_completed_object => p_step_info.target_objt_ref
      );
      -- jump into matching catch event
      update flow_subflows sbfl
      set   sbfl.sbfl_current = l_next_objt
          , sbfl.sbfl_last_completed = p_step_info.target_objt_ref
          , sbfl.sbfl_became_current = systimestamp 
          , sbfl.sbfl_last_update = systimestamp
          , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
      where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- pass the step_key through unchanged & use on the receiving ICE
      flow_complete_step
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_step_key   => p_sbfl_info.sbfl_step_key
      );
    else
      apex_debug.error(p_message  => 'error finding matching link object found');    
    end if;
end flow_process_link_event;


/*
============================================================================================
  B P M N   O B J E C T   P R O C E S S O R S 
============================================================================================
*/

  procedure process_endEvent
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_sbfl_context_par      flow_types_pkg.t_subflow_context;  
    -- l_boundary_event        flow_objects.objt_bpmn_id%type;
    -- l_subproc_objt          flow_objects.objt_bpmn_id%type;
    l_exit_type             flow_objects.objt_sub_tag_name%type default null;
    l_remaining_subflows    number;
    l_process_end_status    flow_processes.prcs_status%type;
    -- l_parent_step_key       flow_subflows.sbfl_step_key%type;
    l_calling_subflow       flow_subflows.sbfl_id%type;   -- expected temporary variable
  begin
    apex_debug.enter 
    ( 'process_endEvent'
    , 'Process', p_process_id
    , 'Subflow', p_subflow_id
    );
    --next step can be either end of process, end of a call activity, or a sub-process returning to its parent
    -- get parent subflow
    l_sbfl_context_par := flow_engine_util.get_subprocess_parent_subflow
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_current    => p_sbfl_info.sbfl_current
      );
    -- update the subflow before logging
     update flow_subflows sbfl
        set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
          , sbfl.sbfl_current = p_step_info.target_objt_ref
          , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_completed  
          , sbfl.sbfl_last_update = systimestamp 
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- log the current endEvent as completed
    flow_logging.log_step_completion
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_completed_object => p_step_info.target_objt_ref
      );  
    -- process any variable expressions in the onEvent set
    flow_expressions.process_expressions
    ( pi_objt_id     => p_step_info.target_objt_id
    , pi_set         => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id     => p_process_id
    , pi_sbfl_id     => p_subflow_id
    , pi_var_scope   => p_sbfl_info.sbfl_scope
    , pi_expr_scope  => p_sbfl_info.sbfl_scope
    );

    if p_sbfl_info.sbfl_calling_sbfl = 0 then   
      -- in a top level process on the starting diagram
      apex_debug.info 
      ( p_message => 'Next Step is Process End %0'
      , p0        => p_step_info.target_objt_ref 
      );
      -- check for Terminate sub-Event
      if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition then
        -- get desired process status after termination from model
        select coalesce( objt.objt_attributes."processStatus", flow_constants_pkg.gc_prcs_status_completed )
          into l_process_end_status
          from flow_objects objt
         where objt.objt_id = p_step_info.target_objt_id
        ;
        -- terminate the main level
        flow_engine_util.terminate_level
        ( 
          p_process_id     => p_process_id
        , p_process_level  => p_sbfl_info.sbfl_process_level
        );
      elsif p_step_info.target_objt_subtag is null then
        -- top process level but not a terminate end...
        flow_engine_util.subflow_complete
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );
        l_process_end_status := flow_constants_pkg.gc_prcs_status_completed;
      end if;

      -- check if there are ANY remaining subflows.  If not, close process
      select count(*)
        into l_remaining_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id;
      
      if l_remaining_subflows = 0 then 

        update flow_processes prcs 
           set prcs.prcs_status = l_process_end_status
             , prcs.prcs_last_update = systimestamp
         where prcs.prcs_id = p_process_id
        ;
        -- log the completion
        flow_logging.log_instance_event
        ( p_process_id => p_process_id
        , p_event      => l_process_end_status
        );
        apex_debug.info 
        ( p_message => 'Process Completed with %1 Status: Process %0  '
        , p0        => p_process_id
        , p1        => l_process_end_status
        );

      end if;
    else  
      -- in a lower process level (subProcess or CallActivity on another diagram) - process the Process Level endEvent (ouch)
      flow_subprocesses.process_process_level_endEvent
        ( p_process_id        => p_process_id
        , p_subflow_id        => p_subflow_id
        , p_sbfl_info         => p_sbfl_info
        , p_step_info         => p_step_info
        , p_sbfl_context_par  => l_sbfl_context_par
        );
    end if; 
  end process_endEvent;

  procedure process_intermediateCatchEvent
  ( p_sbfl_info  in flow_subflows%rowtype
  , p_step_info  in flow_types_pkg.flow_step_info
  )
  is 
  begin
    -- then we make everything behave like a simple activity unless specifically supported
    -- currently only supports timer and without checking its type is timer
    -- but this will have a case type = timer, emailReceive. ....
    -- this is currently just a stub.
    apex_debug.enter
    ( 'process_IntermediateCatchEvent'
    , 'p_step_info.target_objt_ref', p_step_info.target_objt_ref
    );

    if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_timer_event_definition then
      -- we have a timer.  Set status to waiting and schedule the timer.
      update flow_subflows sbfl
         set sbfl.sbfl_current = p_step_info.target_objt_ref
           , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
           , sbfl.sbfl_last_update = systimestamp
           , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
       where sbfl.sbfl_id = p_sbfl_info.sbfl_id
         and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
      ;
      flow_timers_pkg.start_timer
      ( 
        pi_prcs_id  => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id  => p_sbfl_info.sbfl_id
      , pi_step_key => p_sbfl_info.sbfl_step_key
      );
    else
      -- not a timer.  Just set it to running for now.  (other types to be implemented later)
      -- this includes bpmn:linkEventDefinition which should come here
      update flow_subflows sbfl
         set sbfl.sbfl_current = p_step_info.target_objt_ref
           , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
           , sbfl.sbfl_last_update = systimestamp
           , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
       where sbfl.sbfl_id = p_sbfl_info.sbfl_id
         and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
      ;
    end if;
  end process_intermediateCatchEvent;

  procedure process_intermediateThrowEvent
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_par_sbfl            flow_types_pkg.t_subflow_context;
    l_injected_step_key   flow_subflows.sbfl_step_key%type;
    l_is_interrupting     boolean;
  begin
    -- currently  supports none, link, and escalation Intermediate throw event 
    -- but this might later have other case type =  message throw, etc. ....
    apex_debug.enter 
    ( 'process_IntermediateThrowEvent'
    , 'p_step_info.target_objt_ref', p_step_info.target_objt_ref
    );
    -- process on-event expressions for the ITE
    flow_expressions.process_expressions
    ( pi_objt_id      => p_step_info.target_objt_id  
    , pi_set          => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
    , pi_sbfl_id      => p_sbfl_info.sbfl_id
    , pi_var_scope    => p_sbfl_info.sbfl_scope
    , pi_expr_scope   => p_sbfl_info.sbfl_scope
    );

    if p_step_info.target_objt_subtag is null then
      -- a none event.  Make the ITE the current event then just call flow_complete_step.  
      update flow_subflows sbfl
      set   sbfl.sbfl_current = p_step_info.target_objt_ref
          , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
          , sbfl.sbfl_last_update = systimestamp
          , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
      where sbfl.sbfl_id = p_sbfl_info.sbfl_id
          and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
      ;
      flow_complete_step
      ( p_process_id => p_sbfl_info.sbfl_prcs_id
      , p_subflow_id => p_sbfl_info.sbfl_id
      , p_step_key   => p_sbfl_info.sbfl_step_key
      );
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_link_event_definition then
      flow_process_link_event
      ( p_process_id => p_sbfl_info.sbfl_prcs_id
      , p_subflow_id => p_sbfl_info.sbfl_id
      , p_sbfl_info  => p_sbfl_info
      , p_step_info  => p_step_info
      );   
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition then
      -- make the ITE the current step
      update  flow_subflows sbfl
          set sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_sbfl_info.sbfl_id
          and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
      ;
      -- find the subProcess event in the parent level
      l_par_sbfl := flow_engine_util.get_subprocess_parent_subflow
      ( p_process_id => p_sbfl_info.sbfl_prcs_id
      , p_subflow_id => p_sbfl_info.sbfl_id
      , p_current => p_step_info.target_objt_ref
      );
      -- escalate it to the boundary Event
      flow_boundary_events.process_escalation
      ( pi_sbfl_info        => p_sbfl_info
      , pi_step_info        => p_step_info
      , pi_par_sbfl         => l_par_sbfl.sbfl_id
      , pi_source_type      => flow_constants_pkg.gc_bpmn_intermediate_throw_event
      , po_step_key         => l_injected_step_key
      , po_is_interrupting  => l_is_interrupting
      ); 

    else 
      --- other type of intermediateThrowEvent that is not currently supported
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_info.sbfl_id
      , pi_message_key => 'ITE-unsupported-type'
      , p0 => p_sbfl_info.sbfl_current
      );
      -- $F4AMESSAGE 'ITE-unsupported-type' || 'Currently unsupported type of Intermediate Throw Event encountered at %0 .'  
    end if;
end process_intermediateThrowEvent;


/* 
================================================================================
   E V E N T   H A N D L I N G 
================================================================================
*/

procedure handle_event_gateway_event
  ( p_process_id         in flow_processes.prcs_id%type
  , p_parent_subflow_id  in flow_subflows.sbfl_id%type
  , p_cleared_subflow_id in flow_subflows.sbfl_id%type
  )
is 
    l_forward_route         flow_connections.conn_id%type;
    l_current_object        flow_subflows.sbfl_current%type;
    l_child_starting_object flow_subflows.sbfl_starting_object%type;
    l_parent_sbfl           flow_subflows.sbfl_id%type;
    l_timestamp             flow_subflows.sbfl_became_current%type;
    l_forward_step_key      flow_subflows.sbfl_step_key%type;
    l_return                varchar2(50);
begin
    -- called from any event that has cleared (so expired timer, received message or signal, etc) to move eBG forwards
    -- procedure has to:
    -- - check that gateway has not already been cleared by another event
    -- - resume the incoming subflow on the path of the first event to occur and call next_step
    -- - stop / terminate all of the child subflows that were created to wait for other events
    -- - including making sure any timers, message receivers, etc., are cleared up.

    -- note that if this is called from a timer, you might not be in an APEX session so might not get debug
    apex_debug.enter
    ( 'handle_event_gateway_event' 
    , 'p_process_id', p_process_id
    , 'parent_subflow', p_parent_subflow_id
    , 'p_cleared_subflow_id', p_cleared_subflow_id
    );
    begin
      select sbfl.sbfl_id
        into l_parent_sbfl
        from flow_subflows sbfl
       where sbfl.sbfl_id = p_parent_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          ;
    exception
       when no_data_found then
        -- gateway aready cleared
         raise; 
    end;
    -- make the incoming (main) (split) parent subflow proceed along the path of the cleared event.clear(
    
     select conn.conn_id
          , sbfl.sbfl_current
          , sbfl.sbfl_starting_object
       into l_forward_route
          , l_current_object
          , l_child_starting_object
       from flow_objects objt
       join flow_subflows sbfl 
         on sbfl.sbfl_current = objt.objt_bpmn_id
        and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
       join flow_connections conn 
         on conn.conn_src_objt_id = objt.objt_id
        and conn.conn_dgrm_id = sbfl.sbfl_dgrm_id
      where sbfl.sbfl_id = p_cleared_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
        and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
          ; 
    -- generate a step key & insert in the update...use later
    l_timestamp := systimestamp;
    l_forward_step_key := flow_engine_util.step_key ( pi_sbfl_id   => p_parent_subflow_id
                                                    , pi_current => l_current_object
                                                    , pi_became_current => l_timestamp 
                                                    );

     update flow_subflows sbfl
        set sbfl_status = flow_constants_pkg.gc_sbfl_status_running
          , sbfl_current = l_current_object
          , sbfl_last_completed = l_child_starting_object
          , sbfl_last_update = l_timestamp
          , sbfl_became_current = l_timestamp
          , sbfl_step_key = l_forward_step_key
      where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_parent_subflow_id
        and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          ;
    -- now clear up all of the sibling subflows
    begin
      for child_subflows in (
        select sbfl.sbfl_id
             , sbfl.sbfl_current
             , objt.objt_sub_tag_name
          from flow_subflows sbfl
          join flow_objects objt 
            on objt.objt_bpmn_id = sbfl.sbfl_current
           and objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
         where sbfl.sbfl_sbfl_id = p_parent_subflow_id
           and sbfl.sbfl_starting_object = l_child_starting_object
           and sbfl.sbfl_prcs_id = p_process_id
      )
      loop
        -- clean up any event handlers (timers, etc.) (add more here when supporting messageEvent, SignalEvent, etc.)
        if child_subflows.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then
          flow_timers_pkg.terminate_timer
            ( pi_prcs_id => p_process_id
            , pi_sbfl_id => child_subflows.sbfl_id
            , po_return_code => l_return
            );
        end if;
        -- delete the completed subflow and log it as complete
            
        delete
          from flow_subflows sbfl
         where sbfl.sbfl_prcs_id = p_process_id
           and sbfl.sbfl_id = child_subflows.sbfl_id
            ;
        -- logging - tbd
      end loop;
    end;  -- cleanup block
    -- now step forward on the forward path
    flow_complete_step           
    ( p_process_id => p_process_id
    , p_subflow_id => p_parent_subflow_id
    , p_step_key   => l_forward_step_key
    , p_forward_route => null
    );
end handle_event_gateway_event;

procedure handle_intermediate_catch_event
  ( p_process_id   in flow_processes.prcs_id%type
  , p_subflow_id   in flow_subflows.sbfl_id%type
  , p_step_key     in flow_subflows.sbfl_step_key%type
  , p_current_objt in flow_subflows.sbfl_current%type
  ) 
is
  l_sbfl_scope    flow_subflows.sbfl_scope%type;
begin
  apex_debug.enter
  ( 'handle_intermediate_catch_event'
  , 'Subflow', p_subflow_id
  , 'Step Key', p_step_key
  );
  update flow_subflows sbfl 
     set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
       , sbfl.sbfl_last_update = systimestamp
   where sbfl.sbfl_prcs_id = p_process_id
     and sbfl.sbfl_id = p_subflow_id
  returning sbfl_scope into l_sbfl_scope
  ;
  --  process any variable expressions in the OnEvent set
  flow_expressions.process_expressions
  ( pi_objt_bpmn_id => p_current_objt  
  , pi_set          => flow_constants_pkg.gc_expr_set_on_event
  , pi_prcs_id      => p_process_id
  , pi_sbfl_id      => p_subflow_id
  , pi_var_scope    => l_sbfl_scope
  , pi_expr_scope   => l_sbfl_scope
  );
  -- test for any errors so far 
  if flow_globals.get_step_error then 
    -- has step errors from expressions
    flow_errors.set_error_status
    ( pi_prcs_id => p_process_id
    , pi_sbfl_id => p_subflow_id
    );
  else
    -- move onto next step
    flow_complete_step 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_step_key   => p_step_key
    , p_forward_route => null
    );
  end if;  
end handle_intermediate_catch_event;

procedure create_repeat_subflow 
  ( p_process_id      in flow_processes.prcs_id%type
  , p_last_subflow_id in flow_subflows.sbfl_id%type
  , p_timr_id         in flow_timers.timr_id%type default null
  , p_next_run        in flow_timers.timr_run%type default null
  )
is
  l_new_subflow_context  flow_types_pkg.t_subflow_context;
  l_last_subflow         flow_subflows%rowtype;
begin
  select * 
    into l_last_subflow
    from flow_subflows
   where sbfl_id = p_last_subflow_id
     and sbfl_prcs_id = p_process_id
  ;

  l_new_subflow_context := flow_engine_util.subflow_start
          (
            p_process_id      => p_process_id
          , p_parent_subflow  => l_last_subflow.sbfl_sbfl_id
          , p_starting_object => l_last_subflow.sbfl_starting_object
          , p_current_object  => l_last_subflow.sbfl_starting_object
          , p_route           => 'from boundary event - run '||to_char(p_next_run)
          , p_last_completed  => l_last_subflow.sbfl_last_completed
          , p_status          => flow_constants_pkg.gc_sbfl_status_waiting_timer
          , p_parent_sbfl_proc_level => l_last_subflow.sbfl_process_level
          , p_dgrm_id                => l_last_subflow.sbfl_dgrm_id
          );

  flow_timers_pkg.start_timer
  ( pi_prcs_id  => p_process_id
  , pi_sbfl_id  => l_new_subflow_context.sbfl_id
  , pi_step_key => l_new_subflow_context.step_key
  , pi_timr_id  => p_timr_id
  , pi_run      => p_next_run
  );

  if not flow_globals.get_step_error then 
      -- set timer flag on child (Self, Noninterrupting, Timer)
      update flow_subflows sbfl
          set sbfl.sbfl_has_events = sbfl.sbfl_has_events||':SNT'
        where sbfl.sbfl_id = l_new_subflow_context.sbfl_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
  end if;
    
end create_repeat_subflow;

procedure flow_handle_event
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_step_key   in flow_subflows.sbfl_step_key%type
  , p_timr_id    in flow_timers.timr_id%type default null
  , p_run        in flow_timers.timr_run%type default null
  ) 
is
  l_parent_subflow        flow_subflows.sbfl_id%type;
  l_prev_objt_tag_name    flow_objects.objt_tag_name%type;
  l_curr_objt_tag_name    flow_objects.objt_tag_name%type;
  l_sbfl_current          flow_subflows.sbfl_current%type;
begin
  -- currently handles callbacks from flow_timers when a timer fires
  apex_debug.enter 
  ( 'flow_handle_event'
  , 'subflow_id', p_subflow_id
  , 'process_id', p_process_id
  );
  -- look at current event to check if it is a startEvent.  (this also has no previous event!)
  -- if not, examine previous event on the subflow to determine if it was eventBasedGateway (eBG)
  -- an intermediateCatchEvent (iCE) following an eBG will always have exactly 1 input (from the eBG)
  -- an independant iCE (not following an eBG) can have >1 inputs
  -- so look for preceding eBG.  If previous event not eBG or there are multiple prev events, it did not follow an eBG.

  -- set context for scripts and variable expressions
  flow_globals.set_context
  ( pi_prcs_id  => p_process_id
  , pi_sbfl_id  => p_subflow_id
  , pi_step_key => p_step_key
  , pi_scope    => flow_engine_util.get_scope (p_process_id => p_process_id, p_subflow_id => p_subflow_id)
  );
  flow_globals.set_is_recursive_step (p_is_recursive_step => true);
  -- initialise step_had_error flag
  flow_globals.set_step_error ( p_has_error => false);


  -- lock subflow containing event
  if flow_engine_util.lock_subflow(p_subflow_id) then
    -- subflow_locked
    select curr_objt.objt_tag_name
         , sbfl.sbfl_sbfl_id
         , sbfl.sbfl_current
      into l_curr_objt_tag_name
         , l_parent_subflow
         , l_sbfl_current
      from flow_objects curr_objt 
      join flow_subflows sbfl 
        on sbfl.sbfl_current = curr_objt.objt_bpmn_id
       and sbfl.sbfl_dgrm_id = curr_objt.objt_dgrm_id
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
        ;

    if l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_start_event then
      -- startEvent with associated event.
      handle_intermediate_catch_event -- startEvent behaves same as ICE
      (
        p_process_id   => p_process_id
      , p_subflow_id   => p_subflow_id
      , p_step_key     => p_step_key
      , p_current_objt => l_sbfl_current
      );
     elsif l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event then
      -- if a repeating cycle timer, start next cycle before handling
      if p_timr_id is not null and p_run is not null then
        create_repeat_subflow 
        ( p_process_id      => p_process_id
        , p_last_subflow_id => p_subflow_id
        , p_timr_id         => p_timr_id
        , p_next_run        => p_run + 1
        );
      end if;
      -- Non-Interrupting Timer Boundary Event has required functionality same as iCE currently
      handle_intermediate_catch_event 
      (
        p_process_id   => p_process_id
      , p_subflow_id   => p_subflow_id
      , p_step_key     => p_step_key
      , p_current_objt => l_sbfl_current
      );
    elsif l_curr_objt_tag_name in ( flow_constants_pkg.gc_bpmn_subprocess
                                  , flow_constants_pkg.gc_bpmn_task 
                                  , flow_constants_pkg.gc_bpmn_usertask
                                  , flow_constants_pkg.gc_bpmn_manualtask
                                  , flow_constants_pkg.gc_bpmn_call_activity
                                  )   -- add any objects that can support timer boundary events here
          -- if any of these events have a timer on them, it must be an interrupting timer.
          -- because non-interupting timers are set on the boundary event itself
    then
      -- we have an interrupting timer boundary event
      flow_boundary_events.handle_interrupting_timer 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );
    else
      -- we need to look at previous step to see if this follows an eventBasedGateway...
      begin
        select prev_objt.objt_tag_name
          into l_prev_objt_tag_name
          from flow_connections conn 
          join flow_objects curr_objt 
            on conn.conn_tgt_objt_id = curr_objt.objt_id 
           and conn.conn_dgrm_id = curr_objt.objt_dgrm_id
          join flow_objects prev_objt 
            on conn.conn_src_objt_id = prev_objt.objt_id
           and conn.conn_dgrm_id = prev_objt.objt_dgrm_id
          join flow_subflows sbfl
            on sbfl.sbfl_dgrm_id = conn.conn_dgrm_id 
         where sbfl.sbfl_id = p_subflow_id
           and curr_objt.objt_bpmn_id = l_sbfl_current
            ;
      exception
        when too_many_rows then
            l_prev_objt_tag_name := 'other';
      end;
      if  l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event   
          and l_prev_objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_event_based then
        -- we have an eventBasedGateway
        handle_event_gateway_event 
        (
          p_process_id => p_process_id
        , p_parent_subflow_id => l_parent_subflow
        , p_cleared_subflow_id => p_subflow_id
        );
      elsif l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event then
        -- independant iCE not following an eBG
        -- set subflow status to running and call flow_complete_step
        handle_intermediate_catch_event 
        (
          p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_step_key   => p_step_key
        , p_current_objt => l_sbfl_current
        );
      end if;
    end if;
  end if; -- sbfl locked
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id  => p_process_id
    , pi_sbfl_id  => p_subflow_id
    , pi_message_key  => 'eng_handle_event_int'
    , p0  => p_process_id
    , p1  => p_subflow_id 
    , p2  => 'flow_handle_event'
    , p3  => l_curr_objt_tag_name
    , p4  => l_sbfl_current
    );
      -- $F4AMESSAGE 'eng_handle_event_int' || 'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'

end flow_handle_event;

/************************************************************************************************************
****
****                       SUBFLOW  NEXT_STEP
****
*************************************************************************************************************/

procedure finish_current_step
( p_sbfl_rec          in flow_subflows%rowtype
, p_current_step_tag  in flow_objects.objt_tag_name%type
, p_log_as_completed  in boolean default true
)
is
begin
  -- runs all of the post-step operations for the old current task (handling post- expressionsa, releasing reservations, etc.)
  apex_debug.enter 
  ( 'finish_current_step'
  , 'Process ID',  p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID', p_sbfl_rec.sbfl_id
  );
  -- evaluate and set any post-step variable expressions on the last object
  if p_current_step_tag in 
  ( flow_constants_pkg.gc_bpmn_task, flow_constants_pkg.gc_bpmn_usertask, flow_constants_pkg.gc_bpmn_servicetask
  , flow_constants_pkg.gc_bpmn_manualtask, flow_constants_pkg.gc_bpmn_scripttask, flow_constants_pkg.gc_bpmn_businessruletask )
  then 
    flow_expressions.process_expressions
      ( pi_objt_bpmn_id   => p_sbfl_rec.sbfl_current
      , pi_set            => flow_constants_pkg.gc_expr_set_after_task
      , pi_prcs_id        => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_rec.sbfl_id
      , pi_var_scope      => p_sbfl_rec.sbfl_scope
      , pi_expr_scope     => p_sbfl_rec.sbfl_scope
    );
  end if;
  -- clean up any boundary events left over from the previous activity
  if (p_current_step_tag in ( flow_constants_pkg.gc_bpmn_subprocess
                            , flow_constants_pkg.gc_bpmn_call_activity
                            , flow_constants_pkg.gc_bpmn_task
                            , flow_constants_pkg.gc_bpmn_usertask
                            , flow_constants_pkg.gc_bpmn_manualtask
                            ) -- boundary event attachable types
      and p_sbfl_rec.sbfl_has_events is not null )            -- subflow has events attached
  then
      -- 
      apex_debug.info 
      ( p_message => 'boundary event cleanup triggered for subflow %0'
      , p0        => p_sbfl_rec.sbfl_id
      );
      flow_boundary_events.unset_boundary_timers 
      ( p_process_id => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id => p_sbfl_rec.sbfl_id);
  end if;

  if p_log_as_completed then
    -- log current step as completed before releasing the reservation
    flow_logging.log_step_completion   
    ( p_process_id        => p_sbfl_rec.sbfl_prcs_id
    , p_subflow_id        => p_sbfl_rec.sbfl_id
    , p_completed_object  => p_sbfl_rec.sbfl_current
    );
  end if;
  -- release subflow reservation
  if p_sbfl_rec.sbfl_reservation is not null then
    flow_reservations.release_step
    ( p_process_id        => p_sbfl_rec.sbfl_prcs_id
    , p_subflow_id        => p_sbfl_rec.sbfl_id
    , p_called_internally => true
    );
  end if;

  apex_debug.info
  ( p_message => 'Post Step Operations completed for current step %1 on subflow %0.'
  , p0        => p_sbfl_rec.sbfl_id
  , p1        => p_sbfl_rec.sbfl_current
  );

end finish_current_step;

function get_next_step_info
( p_process_id        in flow_processes.prcs_id%type
, p_subflow_id        in flow_subflows.sbfl_id%type
, p_forward_route     in flow_connections.conn_bpmn_id%type default null
) return flow_types_pkg.flow_step_info
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_step_info             flow_types_pkg.flow_step_info;
 -- l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.enter 
  ( 'get_next_step_info'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  );
-- Find next subflow step
  begin
    select sbfl.sbfl_dgrm_id
         , objt_source.objt_tag_name
         , objt_source.objt_id
         , conn.conn_tgt_objt_id
         , objt_target.objt_bpmn_id
         , objt_target.objt_tag_name    
         , objt_target.objt_sub_tag_name
         , objt_lane.objt_bpmn_id
         , objt_lane.objt_name
      into l_step_info
      from flow_connections conn
      join flow_objects objt_source
        on conn.conn_src_objt_id = objt_source.objt_id
       and conn.conn_dgrm_id = objt_source.objt_dgrm_id
      join flow_objects objt_target
        on conn.conn_tgt_objt_id = objt_target.objt_id
       and conn.conn_dgrm_id = objt_target.objt_dgrm_id
      join flow_subflows sbfl
        on sbfl.sbfl_current = objt_source.objt_bpmn_id 
       and sbfl.sbfl_dgrm_id = conn.conn_dgrm_id
 left join flow_objects objt_lane
        on objt_target.objt_objt_lane_id = objt_lane.objt_id
       and objt_target.objt_dgrm_id = objt_lane.objt_dgrm_id
     where conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_bpmn_id like nvl2( p_forward_route, p_forward_route, '%' )
       and sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
    ;
  exception
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => p_subflow_id
      , pi_message_key    => 'no_next_step_found'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'no_next_step_found' || 'No Next Step Found on subflow %0.  Check your process diagram.'
    when too_many_rows then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => p_subflow_id
      , pi_message_key    => 'more_than_1_forward_path'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'more_than_1_forward_path' || 'More than 1 forward path found when only 1 allowed.'
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id  => p_process_id
      , pi_sbfl_id  => p_subflow_id
      , pi_message_key  => 'eng_handle_event_int'
      , p0  => p_process_id
      , p1  => p_subflow_id 
      , p2  => 'get_next_step_info'
      , p3  => null
      , p4  => null
      );
      -- $F4AMESSAGE 'eng_handle_event_int' || 'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'
  end;
  return l_step_info;
end get_next_step_info;

function get_restart_step_info
( p_process_id        in flow_processes.prcs_id%type
, p_subflow_id        in flow_subflows.sbfl_id%type
, p_current_bpmn_id   in flow_objects.objt_bpmn_id%type
) return flow_types_pkg.flow_step_info
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_step_info             flow_types_pkg.flow_step_info;
begin
  -- used to set up the current step for restarting when a subflow has status = error
  apex_debug.enter 
  ( 'get_restart_step_info'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  );
-- Find next subflow step
  begin
    select sbfl.sbfl_dgrm_id
         , null 
         , null
         , objt_current.objt_id
         , objt_current.objt_bpmn_id
         , objt_current.objt_tag_name    
         , objt_current.objt_sub_tag_name
         , objt_lane.objt_bpmn_id
         , objt_lane.objt_name
      into l_step_info
      from flow_objects objt_current
      join flow_subflows sbfl
        on sbfl.sbfl_current = objt_current.objt_bpmn_id 
       and sbfl.sbfl_dgrm_id = objt_current.objt_dgrm_id
 left join flow_objects objt_lane
        on objt_current.objt_objt_lane_id = objt_lane.objt_id
       and objt_current.objt_dgrm_id = objt_lane.objt_dgrm_id
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_current = p_current_bpmn_id
    ;
    return l_step_info;
  exception
  when no_data_found then
    flow_errors.handle_general_error
    ( pi_message_key => 'restart-no-error'
    );
    -- $F4AMESSAGE 'restart-no-error' || 'No Current Error Found.  Check your process diagram.'  
  when too_many_rows then
    flow_errors.handle_general_error
    ( pi_message_key => 'more_than_1_forward_path'
    );
    -- $F4AMESSAGE 'more_than_1_forward_path' || 'More than 1 forward path found when only 1 allowed.'      
  end;
end get_restart_step_info;

procedure restart_failed_timer_step
( p_sbfl_rec    in flow_subflows%rowtype
, p_step_info   in flow_types_pkg.flow_step_info
)
is
begin
  -- if an event with timer fails when the timer fires, we restart it by ignoring the timer
  -- and immediately running the on-event variable set and then moving forwards on the subflow
  apex_debug.enter 
  ( 'restart_failed_timer_step'
  , 'Process ID',  p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID', p_sbfl_rec.sbfl_id
  );

  apex_debug.info 
  ( p_message => 'Restart Timer Step - Target object: %s.  More info at APP_TRACE level.'
  , p0        => coalesce(p_step_info.target_objt_tag, '!NULL!') 
  );
  apex_debug.trace
  ( p_message => 'Restart Timer Info - dgrm_id : %0, source_objt_tag : %1, target_objt_id : %2, target_objt_ref : %3'
  , p0  => p_step_info.dgrm_id
  , p1  => p_step_info.source_objt_tag
  , p2  => p_step_info.target_objt_id
  , p3  => p_step_info.target_objt_ref
  );
  apex_debug.trace
  ( p_message => 'Timer Step Info - target_objt_tag : %0, target_objt_subtag : %1'
  , p0 => p_step_info.target_objt_tag
  , p1 => p_step_info.target_objt_subtag
  );
  apex_debug.trace
  ( p_message => 'Runing Step Context - sbfl_id : %0, sbfl_last_completed : %1, sbfl_prcs_id : %2'
  , p0 => p_sbfl_rec.sbfl_id
  , p1 => p_sbfl_rec.sbfl_last_completed
  , p2 => p_sbfl_rec.sbfl_prcs_id
  );   
  --  Set status to waiting and reschedule the timer with current time.
      update flow_subflows sbfl
         set sbfl.sbfl_last_update = systimestamp
           , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
       where sbfl.sbfl_id = p_sbfl_rec.sbfl_id
         and sbfl.sbfl_prcs_id = p_sbfl_rec.sbfl_prcs_id
      ;
      flow_timers_pkg.reschedule_timer
      ( 
        p_process_id       => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id      => p_sbfl_rec.sbfl_id
      , p_step_key     => p_sbfl_rec.sbfl_step_key
      , p_is_immediate  => true
      , p_comment       => 'Restart Immediate Broken Timer'
      );
  /*-- evaluate and set any on-event variable expressions from the timer object
  flow_expressions.process_expressions
    ( pi_objt_id     => p_step_info.target_objt_id
    , pi_set         => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
    , pi_sbfl_id     => p_sbfl_rec.sbfl_id
    , pi_var_scope   => p_sbfl_rec.sbfl_scope
    , pi_expr_scope  => p_sbfl_rec.sbfl_scope
  );
  -- test for any errors
  if flow_globals.get_step_error then
    -- has step errors from expressions
    flow_errors.set_error_status
    ( pi_prcs_id => p_sbfl_rec.sbfl_prcs_id
    , pi_sbfl_id => p_sbfl_rec.sbfl_id
    );
  else
  /*  -- step forward onto next step
    flow_complete_step
    ( p_process_id => p_sbfl_rec.sbfl_prcs_id
    , p_subflow_id => p_sbfl_rec.sbfl_id
    , p_step_key   => p_sbfl_rec.sbfl_step_key
    );
    -- reschedule  timer to fire in next step cycle


  end if;*/

end restart_failed_timer_step;

procedure run_step
( p_sbfl_rec          in flow_subflows%rowtype
, p_step_info         in flow_types_pkg.flow_step_info
)
is

begin
  apex_debug.enter 
  ( 'run_step'
  , 'Process ID',  p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID', p_sbfl_rec.sbfl_id
  );

  apex_debug.info 
  ( p_message => 'Running Step - Target object: %s.  More info at APP_TRACE level.'
  , p0        => coalesce(p_step_info.target_objt_tag, '!NULL!') 
  );
  apex_debug.trace
  ( p_message => 'Running Step Info - dgrm_id : %0, source_objt_tag : %1, target_objt_id : %2, target_objt_ref : %3'
  , p0  => p_step_info.dgrm_id
  , p1  => p_step_info.source_objt_tag
  , p2  => p_step_info.target_objt_id
  , p3  => p_step_info.target_objt_ref
  );
  apex_debug.trace
  ( p_message => 'Running Step Info - target_objt_tag : %0, target_objt_subtag : %1'
  , p0 => p_step_info.target_objt_tag
  , p1 => p_step_info.target_objt_subtag
  );
  apex_debug.trace
  ( p_message => 'Runing Step Context - sbfl_id : %0, sbfl_last_completed : %1, sbfl_prcs_id : %2'
  , p0 => p_sbfl_rec.sbfl_id
  , p1 => p_sbfl_rec.sbfl_last_completed
  , p2 => p_sbfl_rec.sbfl_prcs_id
  );    

  -- evaluate and set any pre-step variable expressions on the next object
  if p_step_info.target_objt_tag in 
  ( flow_constants_pkg.gc_bpmn_task, flow_constants_pkg.gc_bpmn_usertask, flow_constants_pkg.gc_bpmn_servicetask
  , flow_constants_pkg.gc_bpmn_manualtask, flow_constants_pkg.gc_bpmn_scripttask, flow_constants_pkg.gc_bpmn_businessruletask )
  then 
    flow_expressions.process_expressions
      ( pi_objt_id     => p_step_info.target_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_before_task
      , pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_var_scope   => p_sbfl_rec.sbfl_scope
      , pi_expr_scope  => p_sbfl_rec.sbfl_scope
    );
  elsif p_step_info.target_objt_tag in 
  ( flow_constants_pkg.gc_bpmn_start_event, flow_constants_pkg.gc_bpmn_end_event 
  , flow_constants_pkg.gc_bpmn_intermediate_throw_event, flow_constants_pkg.gc_bpmn_intermediate_catch_event
  , flow_constants_pkg.gc_bpmn_boundary_event )
  then
    flow_expressions.process_expressions
      ( pi_objt_id     => p_step_info.target_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_before_event
      , pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_var_scope   => p_sbfl_rec.sbfl_scope
      , pi_expr_scope  => p_sbfl_rec.sbfl_scope
    );
  end if;

  case (p_step_info.target_objt_tag)
    when flow_constants_pkg.gc_bpmn_end_event then  --next step is either end of process or sub-process returning to its parent
      flow_engine.process_endEvent
      ( p_process_id => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id => p_sbfl_rec.sbfl_id
      , p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_gateway_exclusive then
      flow_gateways.process_exclusiveGateway
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_gateway_inclusive then
      flow_gateways.process_para_incl_Gateway
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_gateway_parallel then
      flow_gateways.process_para_incl_Gateway
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_subprocess then
      flow_subprocesses.process_subProcess
      ( p_process_id => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id => p_sbfl_rec.sbfl_id
      , p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_call_activity then
      flow_call_activities.process_callActivity
      ( p_process_id => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id => p_sbfl_rec.sbfl_id
      , p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when flow_constants_pkg.gc_bpmn_gateway_event_based then
      flow_gateways.process_eventBasedGateway
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_catch_event then 
      flow_engine.process_intermediateCatchEvent
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_throw_event then 
      flow_engine.process_intermediateThrowEvent
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      ); 
    when  flow_constants_pkg.gc_bpmn_task then 
      flow_tasks.process_task
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_usertask then
      flow_tasks.process_userTask
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_scripttask then 
      flow_tasks.process_scriptTask
      (p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_manualtask then 
      flow_tasks.process_manualTask
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_servicetask then 
      flow_tasks.process_serviceTask
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_businessruletask then 
      flow_tasks.process_businessRuleTask
         ( p_sbfl_info => p_sbfl_rec
         , p_step_info => p_step_info
         );
    end case;

  exception
    when case_not_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_message_key => 'engine-unsupported-object'
      , p0 => p_step_info.target_objt_tag
      );
      -- $F4AMESSAGE 'engine-unsupported-object' || 'Model Error: Process BPMN model next step uses unsupported object %0'  
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_message_key => 'no_next_step_found'
      , p0 => p_sbfl_rec.sbfl_id
      );
      -- $F4AMESSAGE 'no_next_step_found' || 'No Next Step Found on subflow %0.  Check your process diagram.'  
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      null;
  -- let error run back to run_step
end run_step;


procedure flow_complete_step
( p_process_id        in flow_processes.prcs_id%type
, p_subflow_id        in flow_subflows.sbfl_id%type 
, p_step_key          in flow_subflows.sbfl_step_key%type default null
, p_forward_route     in flow_connections.conn_bpmn_id%type default null
, p_log_as_completed  in boolean default true
, p_recursive_call    in boolean default true
)
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_step_info             flow_types_pkg.flow_step_info;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_timestamp             flow_subflows.sbfl_became_current%type;
  l_step_key              flow_subflows.sbfl_step_key%type;
 -- l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.enter 
  ( 'flow_complete_step'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  , 'Supplied Step Key', p_step_key
  , 'recursive_call', case when p_recursive_call then 
                                                    'true' 
                                                 else 
                                                    'false' 
                                                 end
  );
  flow_globals.set_is_recursive_step (p_is_recursive_step => p_recursive_call);
  -- Get current object and current subflow info and lock it
  l_sbfl_rec := flow_engine_util.get_subflow_info 
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_lock_process => false 
  , p_lock_subflow => true
  );

  -- check step key is valid
  if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                    , pi_sbfl_id  => p_subflow_id
                                    , pi_step_key_supplied  => p_step_key
                                    , pi_step_key_required  => l_sbfl_rec.sbfl_step_key) then 
    -- step key is valid 
    -- if subflow has any associated non-interrupting timers on current object, lock the subflows and timers
    -- (other boundary event types only create a subflow when they fire)
    if l_sbfl_rec.sbfl_has_events like '%:CNT%' then 
      flow_boundary_events.lock_child_boundary_timers
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_parent_objt_bpmn_id => l_sbfl_rec.sbfl_current 
      ); 
    end if;
    -- lock associated timers for interrupting boundary events
    if l_sbfl_rec.sbfl_has_events like '%:S_T%' then 
      flow_timers_pkg.lock_timer(p_process_id, p_subflow_id);
    end if;

    -- Find next subflow step
    l_step_info := get_next_step_info 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_forward_route => p_forward_route
    );
 
    if not flow_globals.get_step_error then
      -- complete the current step by doing the post-step operations
      finish_current_step
      ( p_sbfl_rec => l_sbfl_rec
      , p_current_step_tag => l_step_info.source_objt_tag
      , p_log_as_completed => p_log_as_completed
      );
    else
      rollback;
      if p_recursive_call then
        -- set error status on instance and subflow
        flow_errors.set_error_status
        ( pi_prcs_id => p_process_id
        , pi_sbfl_id => p_subflow_id
        );
      end if;
      apex_debug.info
      ( p_message => 'Subflow %0 : Step End Rollback due to earlier Error on Step %1'
      , p0        => p_subflow_id
      , p1        => l_sbfl_rec.sbfl_current
      );      

    end if;
  end if; -- step key valid

  -- end of post-step operations for previous step
  if flow_globals.get_step_error then
    rollback;
    if p_recursive_call then
      -- set error status on instance and subflow
      flow_errors.set_error_status
      ( pi_prcs_id => p_process_id
      , pi_sbfl_id => p_subflow_id
      );
    end if;
    apex_debug.info
    ( p_message => 'Subflow %0 : Step End Rollback due to earlier Error on Step %1'
    , p0        => p_subflow_id
    , p1        => l_sbfl_rec.sbfl_current
    );
  else
    l_timestamp := systimestamp;
    l_step_key  := flow_engine_util.step_key ( pi_sbfl_id         => p_subflow_id
                                             , pi_current         => l_step_info.target_objt_ref
                                             , pi_became_current  => l_timestamp
                                             );
    -- update subflow with step completed, and prepare for next step before committing
    update flow_subflows sbfl
      set sbfl.sbfl_current = l_step_info.target_objt_ref
        , sbfl.sbfl_last_completed = l_sbfl_rec.sbfl_current
        , sbfl.sbfl_became_current = l_timestamp
        , sbfl.sbfl_step_key = l_step_key
        , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        , sbfl.sbfl_work_started = null
        , sbfl.sbfl_last_update = l_timestamp
        , sbfl.sbfl_lane      = coalesce( l_step_info.target_objt_lane     , sbfl.sbfl_lane     , null)
        , sbfl.sbfl_lane_name = coalesce( l_step_info.target_objt_lane_name, sbfl.sbfl_lane_name, null)
    where sbfl.sbfl_prcs_id = p_process_id
      and sbfl.sbfl_id = p_subflow_id
    ;
    commit;

    apex_debug.info
    ( p_message => 'Subflow %0 : Step End Committed for step %1'
    , p0        => p_subflow_id
    , p1        => l_sbfl_rec.sbfl_current
    );
  

    -- start of pre-phase for next step
    -- reset step_had_error flag
    flow_globals.set_step_error ( p_has_error => false);
    -- now into next step so is not part of users current step
    flow_globals.set_is_recursive_step (p_is_recursive_step => true);
    apex_debug.info ( p_message => 'Step now counted as recursive');
    -- relock subflow
    l_sbfl_rec := flow_engine_util.get_subflow_info 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_lock_process => false
    , p_lock_subflow => true
    );
    run_step 
    ( p_sbfl_rec => l_sbfl_rec
    , p_step_info => l_step_info 
    );
    -- Commit transaction before returning
    if flow_globals.get_step_error then
      rollback;
 
      -- set error status on instance and subflow
      flow_errors.set_error_status
      ( pi_prcs_id => p_process_id
      , pi_sbfl_id => p_subflow_id
      );
      commit;
 
      apex_debug.info
      ( p_message => 'Subflow %0 : Step End Rollback due to earlier Error.  (Error Status Just Committed.)'
      , p0        => p_subflow_id
      );
      
    else
      commit;

      apex_debug.info
      ( p_message => 'Subflow %0 : Step End Committed'
      , p0        => p_subflow_id
      );
    end if;
  end if;
  end flow_complete_step;

  procedure start_step -- just (optionally) records the start time gpr work on the current step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type default null
    , p_called_internally  in boolean default false
    )
  is
    l_existing_start       flow_subflows.sbfl_work_started%type;
  begin
    apex_debug.enter
    ( 'start_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    , 'Step Key', p_step_key
    );
    -- subflow should already be locked when calling internally
    if not p_called_internally then 
      -- lock  subflow if called externally
      select sbfl_work_started
        into l_existing_start
        from flow_subflows sbfl 
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         for update of sbfl_work_started wait 3
      ;
    end if;
    -- check the step key
    if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                      , pi_sbfl_id  => p_subflow_id
                                      , pi_step_key_supplied  => p_step_key
                                      ) 
    then 
      -- set the start time if null
      if l_existing_start is null then
        update flow_subflows sbfl
          set sbfl_work_started = systimestamp
        where sbfl_prcs_id = p_process_id
          and sbfl_id = p_subflow_id
        ;
        -- commit reservation if this is an external call
        if not p_called_internally then 
          commit;
        end if;
      end if;
    end if;
  exception
    when no_data_found then
      flow_errors.handle_general_error
      ( pi_message_key => 'startwork-sbfl-not-found'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'startwork-sbfl-not-found' || 'Start Work time recording unsuccessful.  Subflow %0 in Process %1 not found.'  
    when lock_timeout then
      flow_errors.handle_general_error
      ( pi_message_key => 'timeout_locking_subflow'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'timeout_locking_subflow' || 'Unable to lock subflow %0 as currently locked by another user.  Try again later.'        
  end start_step;

procedure restart_step
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_step_key            in flow_subflows.sbfl_step_key%type default null
  , p_comment             in flow_instance_event_log.lgpr_comment%type default null
  )
is 
  l_sbfl_rec            flow_subflows%rowtype;
  l_step_info           flow_types_pkg.flow_step_info;
  l_num_error_subflows  number;
begin 
  apex_debug.enter 
  ( 'flow_restart_step'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  );
  flow_globals.set_is_recursive_step (p_is_recursive_step => true);
   -- reset step_had_error flag
  flow_globals.set_step_error ( p_has_error => false);

  -- lock the process and subflow
  l_sbfl_rec := flow_engine_util.get_subflow_info 
                ( p_process_id => p_process_id
                , p_subflow_id => p_subflow_id
                , p_lock_process => true
                , p_lock_subflow => true
                );
  -- check subflow current task is in error status
  if l_sbfl_rec.sbfl_status <> flow_constants_pkg.gc_sbfl_status_error then 
      flow_errors.handle_general_error
      ( pi_message_key => 'restart-no-error'
      );
      -- $F4AMESSAGE 'restart-no-error' || 'No Current Error Found.  Check your process diagram.'  
  end if;
  
  if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                    , pi_sbfl_id  => p_subflow_id
                                    , pi_step_key_supplied  => p_step_key
                                    ) 
  then 
    -- valid step key was supplied
    -- set up step context
    l_step_info :=  get_restart_step_info
                    ( p_process_id => p_process_id
                    , p_subflow_id => p_subflow_id
                    , p_current_bpmn_id => l_sbfl_rec.sbfl_current
                    );
    -- set subflow status to running
    update flow_subflows sbfl
       set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
         , sbfl_last_update = systimestamp
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
    ;
    -- log the restart
    flow_logging.log_instance_event
    ( p_process_id    => p_process_id
    , p_event         => flow_constants_pkg.gc_prcs_event_restart_step
    , p_objt_bpmn_id  => l_sbfl_rec.sbfl_current
    , p_comment       => 'restart step '||l_sbfl_rec.sbfl_current||'. Comment: '||p_comment
    );
    -- see if instance can be reset to running
    select count(sbfl_id)
      into l_num_error_subflows
      from flow_subflows sbfl 
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_error 
    ;
    if l_num_error_subflows = 0 then
      update flow_processes prcs
         set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
       where prcs.prcs_id = p_process_id
      ;
      flow_logging.log_instance_event
      ( p_process_id    => p_process_id
      , p_objt_bpmn_id  => l_sbfl_rec.sbfl_current
      , p_event         => flow_constants_pkg.gc_prcs_status_running
      );
    end if;

    if l_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_timer_event_definition then
      -- restart object contains a timer.  run var exps and step forward immediately
      restart_failed_timer_step
      ( p_sbfl_rec => l_sbfl_rec
      , p_step_info => l_step_info
      );
    else
      -- all other object types.  restart current task
      run_step 
      ( p_sbfl_rec => l_sbfl_rec
      , p_step_info => l_step_info
      );
    end if;
  end if;  -- valid step key

  -- commit or rollback based on errors
  if flow_globals.get_step_error then
    rollback;
  else
    commit;
  end if;
end restart_step;

end flow_engine;
/

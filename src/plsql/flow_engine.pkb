create or replace package body flow_engine as 
/* 
-- Flows for APEX - flow_engine.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
-- (c) Copyright Flowquest Limited. 2024.
--
-- Created  11-Sep-2020  Richard Allen (Flowquest)
-- Modified 30-May-2022  Moritz Klein (MT AG)
-- Modified 09-Jan-2024  Richard Allen, Flowquest Ltd
--
*/

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  e_feature_requires_ee exception;

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
            , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
            , sbfl.sbfl_last_update    = systimestamp
            , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
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
      set   sbfl.sbfl_current        = l_next_objt
          , sbfl.sbfl_last_completed = p_step_info.target_objt_ref
          , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
          , sbfl.sbfl_became_current = systimestamp 
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
      where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- pass the step_key through unchanged and use on the receiving ICE
      flow_complete_step
      ( p_process_id      => p_process_id
      , p_subflow_id      => p_subflow_id
      , p_step_key        => p_sbfl_info.sbfl_step_key
      , p_matching_object => p_step_info.target_objt_ref
      );
    else
      apex_debug.error(p_message  => 'error finding matching link object found');    
    end if;
end flow_process_link_event;

--============================================================================================
--  B P M N   O B J E C T   P R O C E S S O R S 
--============================================================================================


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
    -- process any variable expressions in the onEvent set
    flow_expressions.process_expressions
    ( pi_objt_id     => p_step_info.target_objt_id
    , pi_set         => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id     => p_process_id
    , pi_sbfl_id     => p_subflow_id
    , pi_step_key    => p_sbfl_info.sbfl_step_key
    , pi_var_scope   => p_sbfl_info.sbfl_scope
    , pi_expr_scope  => p_sbfl_info.sbfl_scope
    );
    -- check for message throw end Event
    if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_message_event_definition then
      $IF flow_apex_env.ee $THEN
        flow_message_util_ee.end_event_send_message
        ( p_sbfl_info  => p_sbfl_info
        , p_step_info  => p_step_info
        ); 
      $ELSE
        raise e_feature_requires_ee;
      $END 
    end if;

    -- update the subflow before logging
     update flow_subflows sbfl
        set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
          , sbfl.sbfl_current        = p_step_info.target_objt_ref
          , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_completed  
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- log the current endEvent as completed
    flow_logging.log_step_completion
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_completed_object => p_step_info.target_objt_ref
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
      else 
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
           set prcs.prcs_status         = l_process_end_status
             , prcs.prcs_last_update    = systimestamp
             , prcs.prcs_complete_ts    = systimestamp
             , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                    , sys_context('userenv','os_user')
                                                    , sys_context('userenv','session_user')
                                                    )  
         where prcs.prcs_id = p_process_id
        ;
        -- log the completion
        flow_logging.log_instance_event
        ( p_process_id => p_process_id
        , p_event      => l_process_end_status
        , p_event_level => flow_constants_pkg.gc_logging_level_major_events
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
    l_new_status        flow_subflows.sbfl_status%type;
    l_msg_sub           flow_message_flow.t_subscription_details;
    l_msub_id           flow_message_subscriptions.msub_id%type;
  begin
    -- then we make everything behave like a simple activity unless specifically supported
    -- currently only supports timer and without checking its type is timer
    -- but this will have a case type = timer, emailReceive. ....
    -- this is currently just a stub.
    apex_debug.enter
    ( 'process_IntermediateCatchEvent'
    , 'p_step_info.target_objt_ref', p_step_info.target_objt_ref
    );

    case p_step_info.target_objt_subtag 
    when flow_constants_pkg.gc_bpmn_timer_event_definition then
      -- we have a timer.  Set status to waiting and schedule the timer.
      l_new_status  := flow_constants_pkg.gc_sbfl_status_waiting_timer;

      flow_timers_pkg.start_timer
      ( 
        pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id      => p_sbfl_info.sbfl_id
      , pi_step_key     => p_sbfl_info.sbfl_step_key
      , pi_callback     => flow_constants_pkg.gc_bpmn_intermediate_catch_event
      );
    when flow_constants_pkg.gc_bpmn_message_event_definition then    
      -- message catch event
      l_new_status  := flow_constants_pkg.gc_sbfl_status_waiting_message;

      l_msg_sub            := flow_message_util.get_msg_subscription_details
                              ( p_msg_object_bpmn_id      => p_step_info.target_objt_ref
                              , p_dgrm_id                 => p_sbfl_info.sbfl_dgrm_id
                              , p_sbfl_info               => p_sbfl_info
                              );
      l_msg_sub.callback  := flow_constants_pkg.gc_bpmn_intermediate_catch_event;

      -- create subscription for the awaited message 
      l_msub_id := flow_message_flow.subscribe ( p_subscription_details => l_msg_sub);
    else
      -- not a timer.  Just set it to running for now.  (other types to be implemented later)
      -- this includes bpmn:linkEventDefinition which should come here
      l_new_status  := flow_constants_pkg.gc_sbfl_status_running;
    end case;

    update flow_subflows sbfl
       set sbfl.sbfl_current        = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
         , sbfl.sbfl_status         = l_new_status
         , sbfl.sbfl_last_update    = systimestamp
         , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                               , sys_context('userenv','os_user')
                                               , sys_context('userenv','session_user')
                                               )  
     where sbfl.sbfl_id = p_sbfl_info.sbfl_id
       and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
    ;
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
    , pi_step_key     => p_sbfl_info.sbfl_step_key
    , pi_var_scope    => p_sbfl_info.sbfl_scope
    , pi_expr_scope   => p_sbfl_info.sbfl_scope
    );

    if p_step_info.target_objt_subtag is null then
      -- a none event.  Make the ITE the current event then just call flow_complete_step.  
      update flow_subflows sbfl
      set   sbfl.sbfl_current        = p_step_info.target_objt_ref
          , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
          , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
      where sbfl.sbfl_id      = p_sbfl_info.sbfl_id
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
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_message_event_definition then
      flow_message_flow.send_message
      ( p_sbfl_info  => p_sbfl_info
      , p_step_info  => p_step_info
      );
      flow_complete_step
      ( p_process_id => p_sbfl_info.sbfl_prcs_id
      , p_subflow_id => p_sbfl_info.sbfl_id
      , p_step_key   => p_sbfl_info.sbfl_step_key
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
    -- generate a step key and insert in the update...use later

    l_forward_step_key := flow_engine_util.step_key ( pi_sbfl_id   => p_parent_subflow_id
                                                    , pi_current => l_current_object
                                                    );
    l_timestamp := systimestamp;

     update flow_subflows sbfl
        set sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
          , sbfl_current        = l_current_object
          , sbfl_last_completed = l_child_starting_object
          , sbfl_became_current = l_timestamp
          , sbfl_step_key       = l_forward_step_key
          , sbfl_last_update    = l_timestamp 
          , sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                           , sys_context('userenv','os_user')
                                           , sys_context('userenv','session_user')
                                           )  
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
     set sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
       , sbfl.sbfl_last_update    = systimestamp
       , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                             , sys_context('userenv','os_user')
                                             , sys_context('userenv','session_user')
                                             )  
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
  , pi_step_key     => p_step_key
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
  ( pi_prcs_id      => p_process_id
  , pi_sbfl_id      => l_new_subflow_context.sbfl_id
  , pi_step_key     => l_new_subflow_context.step_key
  , pi_callback     => flow_constants_pkg.gc_bpmn_intermediate_catch_event
  , pi_callback_par => 'non-interrupting' 
  , pi_timr_id      => p_timr_id
  , pi_run          => p_next_run
  );

  if not flow_globals.get_step_error then 
      -- set timer flag on child (Self, Noninterrupting, Timer)
      update flow_subflows sbfl
          set sbfl.sbfl_has_events     = sbfl.sbfl_has_events||':SNT'
            , sbfl.sbfl_last_update    = systimestamp
            , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
        where sbfl.sbfl_id = l_new_subflow_context.sbfl_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
  end if;
    
end create_repeat_subflow;

procedure timer_callback
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_step_key   in flow_subflows.sbfl_step_key%type
  , p_timr_id    in flow_timers.timr_id%type default null
  , p_run        in flow_timers.timr_run%type default null
  , p_callback      in flow_timers.timr_callback%type default null
  , p_callback_par  in flow_timers.timr_callback_par%type default null
  , p_event_type    in flow_objects.objt_sub_tag_name%type
  ) 
is
  l_parent_subflow          flow_subflows.sbfl_id%type;
  l_prev_objt_tag_name      flow_objects.objt_tag_name%type;
  l_curr_objt_tag_name      flow_objects.objt_tag_name%type;
  l_curr_objt_sub_tag_name  flow_objects.objt_sub_tag_name%type;
  l_sbfl_current            flow_subflows.sbfl_current%type;
  l_follows_ebg             flow_subflows.sbfl_is_following_ebg%type;
begin
  -- currently handles callbacks from flow_timers and flow_message_flow when a timer fires / message is received
  apex_debug.enter 
  ( 'flow_handle_event'
  , 'subflow_id',     p_subflow_id
  , 'process_id',     p_process_id
  , 'event_type',     p_event_type
  , 'p_callback',     p_callback
  , 'p_callback_par', p_callback_par
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
         , curr_objt.objt_sub_tag_name
         , sbfl.sbfl_sbfl_id
         , sbfl.sbfl_current
         , sbfl.sbfl_is_following_ebg
      into l_curr_objt_tag_name
         , l_curr_objt_sub_tag_name
         , l_parent_subflow
         , l_sbfl_current
         , l_follows_ebg
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
    elsif l_curr_objt_tag_name in ( flow_constants_pkg.gc_bpmn_subProcess
                                  , flow_constants_pkg.gc_bpmn_task 
                                  , flow_constants_pkg.gc_bpmn_userTask
                                  , flow_constants_pkg.gc_bpmn_manualTask
                                  , flow_constants_pkg.gc_bpmn_call_activity
                                  , flow_constants_pkg.gc_bpmn_receiveTask
                                  )   -- add any objects that can support timer boundary events here
          -- if any of these events have a timer on them, it must be an interrupting timer.
          -- because non-interupting timers are set on the boundary event itself
      then
      -- we have an interrupting timer boundary event
      flow_boundary_events.handle_interrupting_boundary_event
      ( p_process_id      => p_process_id
      , p_subflow_id      => p_subflow_id
      , p_event_type      => p_event_type
      , p_boundary_object => p_callback_par
      );
    elsif l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event  then 
      -- we need to look at previous step to see if this follows an eventBasedGateway...
      case l_follows_ebg 
      when 'Y' then
        -- we have an eventBasedGateway
        handle_event_gateway_event 
        (
          p_process_id => p_process_id
        , p_parent_subflow_id => l_parent_subflow
        , p_cleared_subflow_id => p_subflow_id
        );
      else 
        -- independant iCE not following an eBG
        -- set subflow status to running and call flow_complete_step
        handle_intermediate_catch_event 
        (
          p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_step_key   => p_step_key
        , p_current_objt => l_sbfl_current
        );
      end case;
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

end timer_callback;

/************************************************************************************************************
****
****                       SUBFLOW  NEXT_STEP
****
*************************************************************************************************************/

function finish_current_step
( p_sbfl_rec                     in flow_subflows%rowtype
, p_log_as_completed             in boolean default true
, p_reset_step_key               in boolean default false
, p_force_next_step              in boolean default false
, p_execute_variable_expressions in boolean default true  -- only false for force next step
, p_matching_object              in flow_objects.objt_bpmn_id%type default null -- only for closing parallel and inclusive gateways and link events
) return flow_types_pkg.t_iteration_status
is
  l_current_step_tag      flow_objects.objt_tag_name%type;
  l_iteration_status      flow_types_pkg.t_iteration_status;
begin
  -- runs all of the post-step operations for the old current task (handling post- expressionsa, releasing reservations, etc.)
  apex_debug.enter 
  ( 'finish_current_step'
  , 'Process ID',  p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID', p_sbfl_rec.sbfl_id
  , 'Current Step', p_sbfl_rec.sbfl_current
  , 'p_reset_step_key', case p_reset_step_key 
                        when true then 'True' 
                        when false then 'False' 
                        else 'null' end
  , 'p_force_next_step', case p_force_next_step 
                        when true then 'True' 
                        when false then 'False' 
                        else 'null' end
  , 'p_execute_variable_expressions', case p_execute_variable_expressions 
                                      when true then 'True' 
                                      when false then 'False' 
                                      else 'null' end
  );


  l_current_step_tag := flow_engine_util.get_object_tag (p_sbfl_info => p_sbfl_rec);

  if p_execute_variable_expressions then

    -- evaluate and set any post-step variable expressions on the last object
    -- only not executed if the next step is forced and flag set to false
    if l_current_step_tag in 
    ( flow_constants_pkg.gc_bpmn_task, flow_constants_pkg.gc_bpmn_usertask, flow_constants_pkg.gc_bpmn_servicetask
    , flow_constants_pkg.gc_bpmn_manualtask, flow_constants_pkg.gc_bpmn_scripttask, flow_constants_pkg.gc_bpmn_businessruletask 
    , flow_constants_pkg.gc_bpmn_sendtask , flow_constants_pkg.gc_bpmn_receivetask )
    and p_sbfl_rec.sbfl_iteration_type is null 
    then 
      flow_expressions.process_expressions
        ( pi_objt_bpmn_id   => p_sbfl_rec.sbfl_current
        , pi_set            => flow_constants_pkg.gc_expr_set_after_task
        , pi_prcs_id        => p_sbfl_rec.sbfl_prcs_id
        , pi_sbfl_id        => p_sbfl_rec.sbfl_id
        , pi_step_key       => p_sbfl_rec.sbfl_step_key
        , pi_var_scope      => p_sbfl_rec.sbfl_scope
        , pi_expr_scope     => p_sbfl_rec.sbfl_scope
      );
    end if;

  end if;
  -- clean up any boundary events left over from the previous activity
  if (l_current_step_tag in ( flow_constants_pkg.gc_bpmn_subprocess
                            , flow_constants_pkg.gc_bpmn_call_activity
                            , flow_constants_pkg.gc_bpmn_task
                            , flow_constants_pkg.gc_bpmn_usertask
                            , flow_constants_pkg.gc_bpmn_manualtask
                            , flow_constants_pkg.gc_bpmn_receivetask
                            ) -- boundary event attachable types
      and p_sbfl_rec.sbfl_has_events is not null )            -- subflow has events attached
  then
      -- 
      apex_debug.info 
      ( p_message => 'boundary event cleanup triggered for subflow %0'
      , p0        => p_sbfl_rec.sbfl_id
      );
      flow_boundary_events.unset_boundary_events 
      ( p_process_id => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id => p_sbfl_rec.sbfl_id);
  end if;

  if p_sbfl_rec.sbfl_loop_counter is not null then
    case p_sbfl_rec.sbfl_iteration_type
    when flow_constants_pkg.gc_iteration_sequential then
      l_iteration_status := flow_iteration.sequential_complete_step (p_sbfl_info => p_sbfl_rec);
    when flow_constants_pkg.gc_iteration_loop then 
     if not p_reset_step_key then
        -- skip complete_step on the step after loop_init has run...
        l_iteration_status := flow_iteration.loop_complete_step (p_sbfl_info => p_sbfl_rec); 
     end if;
    else 
      null;   
    end case;
  end if;

  if p_log_as_completed then
    -- log current step as completed before releasing the reservation
    flow_logging.log_step_completion   
    ( p_process_id        => p_sbfl_rec.sbfl_prcs_id
    , p_subflow_id        => p_sbfl_rec.sbfl_id
    , p_completed_object  => p_sbfl_rec.sbfl_current
    , p_iteration_status  => l_iteration_status
    , p_matching_object   => case l_current_step_tag
                              when flow_constants_pkg.gc_bpmn_gateway_inclusive then p_matching_object
                              when flow_constants_pkg.gc_bpmn_gateway_parallel  then p_matching_object
                              when flow_constants_pkg.gc_bpmn_intermediate_catch_event then p_matching_object
                              else null end
    , p_notes             => case p_force_next_step
                              when true then 'Step Completion was Forced. Variable Expressions were not executed.'
                              else null end
    );
    flow_logging.log_step_event
    ( p_sbfl_rec        => p_sbfl_rec
    , p_event           => case p_force_next_step
                              when true then flow_constants_pkg.gc_step_event_error_forced
                              else flow_constants_pkg.gc_step_event_completed end
    , p_event_level     => case p_force_next_step
                              when true then flow_constants_pkg.gc_logging_level_abnormal_events
                              else flow_constants_pkg.gc_logging_level_major_events end
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
  ( p_message => 'Post Step Operations completed for current step %1 on subflow %0. Iteration Complete: %2'
  , p0        => p_sbfl_rec.sbfl_id
  , p1        => p_sbfl_rec.sbfl_current
  , p2        => case l_iteration_status.is_complete when true then 'True' when false then 'False' else 'Null' end
  );
  return l_iteration_status;
end finish_current_step;

function get_step_info
( p_sbfl_rec                in flow_subflows%rowtype
, p_forward_route           in flow_connections.conn_bpmn_id%type default null
, p_is_restart              in boolean default false
, p_iteration_is_complete   in boolean default false
, p_previous_step           in flow_objects.objt_bpmn_id%type default null
) return flow_types_pkg.flow_step_info
is
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_step_info             flow_types_pkg.flow_step_info;
  l_iteration_type        varchar2(10);
begin
  apex_debug.enter 
  ( 'get_step_info'
  , 'Process ID',    p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID',    p_sbfl_rec.sbfl_id
  , 'Restart',       case p_is_restart when true then 'True' else 'False' end
  , 'Forward Route', p_forward_route
  , 'Iteration Complete', case p_iteration_is_complete when true then 'True' else 'False' end
  , 'Loop Counter', p_sbfl_rec.sbfl_loop_counter
  );
  begin
    case
    when ( p_sbfl_rec.sbfl_iteration_type is null and not p_is_restart )  -- usual next step case
      or ( p_sbfl_rec.sbfl_iteration_type in ( flow_constants_pkg.gc_iteration_sequential 
                                             , flow_constants_pkg.gc_iteration_loop)
           and p_iteration_is_complete
           and p_sbfl_rec.sbfl_loop_counter is null) -- current step is final sequential or loop iteration
    then
      -- Find next subflow step
      -- rewritten original LEFT JOIN query because of database 23.3 bug 35862529 (fixed db 23.4) which returns incorrect values on left join when including json attributes
      -- workaround - remove json columns from select list and query separately if lane_bpmn_is is not null
      apex_debug.message ('Getting next step using standard query...');
      select p_sbfl_rec.sbfl_dgrm_id
           , objt_source.objt_tag_name
           , objt_source.objt_id
           , conn.conn_tgt_objt_id
           , objt_target.objt_name
           , objt_target.objt_bpmn_id
           , objt_target.objt_tag_name   
           , null 
           , objt_target.objt_sub_tag_name
           , objt_lane.objt_bpmn_id
           , objt_lane.objt_name
           , null -- objt_lane.objt_attributes."apex"."isRole"
           , null -- objt_lane.objt_attributes."apex"."role"
           , objt_target.objt_attributes
           , null
           , null
        into l_step_info
        from flow_connections conn
        join flow_objects objt_source
          on conn.conn_src_objt_id = objt_source.objt_id
         and conn.conn_dgrm_id     = objt_source.objt_dgrm_id
        join flow_objects objt_target
          on conn.conn_tgt_objt_id = objt_target.objt_id
         and conn.conn_dgrm_id     = objt_target.objt_dgrm_id
        left 
        join flow_objects objt_lane
          on objt_target.objt_objt_lane_id = objt_lane.objt_id
         and objt_target.objt_dgrm_id      = objt_lane.objt_dgrm_id
       where conn.conn_tag_name  = flow_constants_pkg.gc_bpmn_sequence_flow
         and ( p_forward_route is null
               OR  ( p_forward_route is not null AND conn.conn_bpmn_id = p_forward_route )
             )
         and conn.conn_dgrm_id        = p_sbfl_rec.sbfl_dgrm_id
         and objt_source.objt_bpmn_id = coalesce (p_previous_step, p_sbfl_rec.sbfl_current)
      ;
    else
      apex_debug.message ('Getting next step using restart and iteration query...');
      select p_sbfl_rec.sbfl_dgrm_id
           , null 
           , null
           , objt_current.objt_id
           , objt_current.objt_name
           , objt_current.objt_bpmn_id
           , objt_current.objt_tag_name  
           , null  
           , objt_current.objt_sub_tag_name
           , objt_lane.objt_bpmn_id
           , objt_lane.objt_name
           , null -- objt_lane.objt_attributes."apex"."isRole"
           , null -- objt_lane.objt_attributes."apex"."role"
           , objt_current.objt_attributes
           , null
           , null
        into l_step_info
        from flow_objects objt_current
        left 
        join flow_objects objt_lane
          on objt_current.objt_objt_lane_id = objt_lane.objt_id
         and objt_current.objt_dgrm_id      = objt_lane.objt_dgrm_id
       where objt_current.objt_bpmn_id = p_sbfl_rec.sbfl_current
         and objt_current.objt_dgrm_id = p_sbfl_rec.sbfl_dgrm_id
      ;
    end case;

    if l_step_info.target_objt_lane is not null then
      begin
        -- workaround for database 23.3 bug 35862529 
        select lane.objt_attributes."apex"."isRole"
             , lane.objt_attributes."apex"."role"
          into l_step_info.target_objt_lane_isRole
             , l_step_info.target_objt_lane_role
          from flow_objects lane
         where lane.objt_bpmn_id  = l_step_info.target_objt_lane
           and lane.objt_dgrm_id  = l_step_info.dgrm_id
        ;
      exception
        when no_data_found then 
          apex_debug.message 
          ( p_message => '-- Lane %0 json attributes data not found'
          , p0 => l_step_info.target_objt_lane
          );
          raise;
      end;
    end if;

    if l_step_info.target_objt_attributes is not null then
      l_step_info.target_objt_iteration := flow_engine_util.get_iteration_type (l_step_info);
      if l_step_info.target_objt_iteration is not null then
        flow_iteration.add_iteration_to_step_info 
        ( p_step_info             => l_step_info
        , p_sbfl_rec              => p_sbfl_rec
        , p_iteration_is_complete => p_iteration_is_complete
        );
      end if;
    end if;

    if l_step_info.target_objt_treat_as_tag is not null then
      apex_debug.message (p_message => '--treat as tag set to %0',
      p0 => l_step_info.target_objt_treat_as_tag);
    end if;

  exception
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_rec.sbfl_id
      , pi_message_key    => 'no_next_step_found'
      , p0 => p_sbfl_rec.sbfl_id
      );
      -- $F4AMESSAGE 'no_next_step_found' || 'No Next Step Found on subflow %0.  Check your process diagram.'
    when too_many_rows then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_rec.sbfl_id
      , pi_message_key    => 'more_than_1_forward_path'
      , p0 => p_sbfl_rec.sbfl_id
      );
      -- $F4AMESSAGE 'more_than_1_forward_path' || 'More than 1 forward path found when only 1 allowed.'
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id  => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id  => p_sbfl_rec.sbfl_id
      , pi_message_key  => 'eng_handle_event_int'
      , p0  => p_sbfl_rec.sbfl_prcs_id
      , p1  => p_sbfl_rec.sbfl_id
      , p2  => 'get_step_info'
      , p3  => null
      , p4  => null
      );
      -- $F4AMESSAGE 'eng_handle_event_int' || 'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'
  end;
  return l_step_info;
end get_step_info;

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
         set sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_waiting_timer
           , sbfl.sbfl_last_update    = systimestamp
           , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                 , sys_context('userenv','os_user')
                                                 , sys_context('userenv','session_user')
                                                 )  
       where sbfl.sbfl_id = p_sbfl_rec.sbfl_id
         and sbfl.sbfl_prcs_id = p_sbfl_rec.sbfl_prcs_id
      ;
      flow_timers_pkg.reschedule_timer
      ( 
        p_process_id          => p_sbfl_rec.sbfl_prcs_id
      , p_subflow_id          => p_sbfl_rec.sbfl_id
      , p_step_key            => p_sbfl_rec.sbfl_step_key
      , p_restart_immediate   => true
      , p_is_immediate        => true
      , p_comment             => 'Restart Immediate Broken Timer'
      );

end restart_failed_timer_step;

procedure run_step
( p_sbfl_rec              in flow_subflows%rowtype
, p_step_info             in flow_types_pkg.flow_step_info
, p_iteration_is_complete in boolean default false
)
is
  l_iteration_status        flow_types_pkg.t_iteration_status;
  l_iteration_is_complete   boolean;
begin
  apex_debug.enter 
  ( 'run_step'
  , 'Process ID',  p_sbfl_rec.sbfl_prcs_id
  , 'Subflow ID', p_sbfl_rec.sbfl_id
  , 'Loop Counter', p_sbfl_rec.sbfl_loop_counter
  , 'SBFL Iteration Type', p_sbfl_rec.sbfl_iteration_type
  , 'Step Iteration Type', p_step_info.target_objt_iteration
  , 'iteration_is_complete' , case p_iteration_is_complete when true then 'True' when false then 'False' else 'null' end
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
  ( p_message => 'Running Step Info - target_objt_tag : %0 (treat like %2 ), target_objt_subtag : %1, iteration: %3 (loop: %4), iter_id: %5, iobj_id: %6 iteration var %7'
  , p0 => p_step_info.target_objt_tag
  , p1 => p_step_info.target_objt_subtag
  , p2 => coalesce (p_step_info.target_objt_treat_as_tag, p_step_info.target_objt_tag)
  , p3 => nvl ( p_step_info.target_objt_iteration, 'None')
  , p4 => p_sbfl_rec.sbfl_loop_counter
  , p5 => p_sbfl_rec.sbfl_iter_id
  , p6 => p_sbfl_rec.sbfl_iobj_id
  , p7 => p_sbfl_rec.sbfl_iteration_var
  );
  apex_debug.trace
  ( p_message => 'Running Step Context - sbfl_id : %0, sbfl_last_completed : %1, sbfl_prcs_id : %2'
  , p0 => p_sbfl_rec.sbfl_id
  , p1 => p_sbfl_rec.sbfl_last_completed
  , p2 => p_sbfl_rec.sbfl_prcs_id
  );    

  -- log step as current
  flow_logging.log_step_event
  ( p_sbfl_rec    => p_sbfl_rec
  , p_event       => flow_constants_pkg.gc_step_event_became_current
  , p_event_level => flow_constants_pkg.gc_logging_level_major_events
  );
  -- TODO - consider moving this into flow_tasks when you have priority, due on, reservation data...

  -- evaluate and set any pre-step variable expressions on the next object
  if p_step_info.target_objt_tag in 
  ( flow_constants_pkg.gc_bpmn_task, flow_constants_pkg.gc_bpmn_usertask, flow_constants_pkg.gc_bpmn_servicetask
  , flow_constants_pkg.gc_bpmn_manualtask, flow_constants_pkg.gc_bpmn_scripttask, flow_constants_pkg.gc_bpmn_businessruletask 
  , flow_constants_pkg.gc_bpmn_sendtask , flow_constants_pkg.gc_bpmn_receivetask )
  and p_sbfl_rec.sbfl_loop_counter is null
  then 
    flow_expressions.process_expressions
      ( pi_objt_id     => p_step_info.target_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_before_task
      , pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_step_key    => p_sbfl_rec.sbfl_step_key
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
      , pi_step_key    => p_sbfl_rec.sbfl_step_key
      , pi_var_scope   => p_sbfl_rec.sbfl_scope
      , pi_expr_scope  => p_sbfl_rec.sbfl_scope
    );
  end if;

  l_iteration_is_complete := p_iteration_is_complete;
  if l_iteration_is_complete is null then
    l_iteration_is_complete := false;
  end if;

  apex_debug.message (p_message => 'run step --> start iterated step? Loop Counter %0 Iter_complete %1 iter_type %2'
  , p0 => p_sbfl_rec.sbfl_loop_counter
  , p1 => case l_iteration_is_complete when true then 'True' when false then 'False' else 'null' end
  , p2 => p_sbfl_rec.sbfl_iteration_type
  );

  if  ( p_sbfl_rec.sbfl_loop_counter is not null 
        and l_iteration_is_complete != true)  then
    case p_sbfl_rec.sbfl_iteration_type 
    when flow_constants_pkg.gc_iteration_sequential then
      apex_debug.message (p_message => 'run step --> calling sequential start step');
      flow_iteration.sequential_start_step ( p_sbfl_info => p_sbfl_rec);
    when flow_constants_pkg.gc_iteration_loop then
      apex_debug.message (p_message => 'run step --> calling loop start step');
      flow_iteration.loop_start_step ( p_sbfl_info => p_sbfl_rec);   
    else
      null;
    end case;   
  end if;

  case coalesce (p_step_info.target_objt_treat_as_tag, p_step_info.target_objt_tag)
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
    when  flow_constants_pkg.gc_bpmn_sendtask then 
      flow_tasks.process_sendTask
      ( p_sbfl_info => p_sbfl_rec
      , p_step_info => p_step_info
      );
    when  flow_constants_pkg.gc_bpmn_receivetask then 
      flow_tasks.process_receiveTask
         ( p_sbfl_info => p_sbfl_rec
         , p_step_info => p_step_info
         );
    when flow_constants_pkg.gc_iteration_sequential then
      l_iteration_status := flow_iteration.sequential_init
         ( p_sbfl_info => p_sbfl_rec
         , p_step_info => p_step_info
         );
    when flow_constants_pkg.gc_iteration_loop then
      l_iteration_status := flow_iteration.loop_init
         ( p_sbfl_info => p_sbfl_rec
         , p_step_info => p_step_info
         );
    when 'sequentialIterationClose' then
      flow_iteration.sequential_close_iteration
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
    when e_feature_requires_ee then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_sbfl_rec.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_rec.sbfl_id
      , pi_message_key => 'feature-requires-ee'
      );
      -- $F4AMESSAGE 'no_next_step_found' || 'Processing this feature requires licensing Flows for APEX Enterprise Edition.' 
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      null;
  -- let error run back to run_step
end run_step;


procedure flow_complete_step
( p_process_id                   in flow_processes.prcs_id%type
, p_subflow_id                   in flow_subflows.sbfl_id%type 
, p_step_key                     in flow_subflows.sbfl_step_key%type default null
, p_forward_route                in flow_connections.conn_bpmn_id%type default null
, p_log_as_completed             in boolean default true
, p_reset_step_key               in boolean default false -- only set for initial call after splitting parallel iteration
, p_recursive_call               in boolean default true
, p_force_next_step              in boolean default false
, p_execute_variable_expressions in boolean default true
, p_matching_object              in flow_objects.objt_bpmn_id%type default null  -- only set when current object is a closing parallel or inclusive gateway or link
)
is
  l_sbfl_rec                  flow_subflows%rowtype;
  l_step_info                 flow_types_pkg.flow_step_info;
  l_dgrm_id                   flow_diagrams.dgrm_id%type;
  l_timestamp                 flow_subflows.sbfl_became_current%type;
  l_step_key                  flow_subflows.sbfl_step_key%type;
  l_previous_step             flow_objects.objt_bpmn_id%type;  
  l_new_status                flow_subflows.sbfl_status%type;
  l_next_loop_counter         number;
  l_existing_iter_id          flow_iterations.iter_id%type;
  l_existing_iobj_id          flow_iterated_objects.iobj_id%type;
  l_next_iter_id              flow_iterations.iter_id%type;
  l_next_iobj_id              flow_iterated_objects.iobj_id%type;
  l_total_loop_instances      number;
  l_iteration_status          flow_types_pkg.t_iteration_status;
  l_iter_info                 flow_types_pkg.t_iteration_status;
  l_next_step_confirmed       boolean := false;
 -- l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.enter 
  ( 'flow_complete_step'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  , 'Supplied Step Key', p_step_key
  , 'recursive_call', case when p_recursive_call then 'true'  else 'false'  end
  , 'reset_step_key', case when p_reset_step_key then 'true'  else 'false'  end
  , 'forced_next_step', case when p_force_next_step then 'true'  else 'false'  end
  , 'execute_var_exps', case when p_execute_variable_expressions then 'true'  
                             else 'false'  end
  );
  flow_globals.set_is_recursive_step (p_is_recursive_step => p_recursive_call);
  -- Get current object and current subflow info and lock it
  l_sbfl_rec := flow_engine_util.get_subflow_info 
                ( p_process_id   => p_process_id
                , p_subflow_id   => p_subflow_id
                , p_lock_process => false 
                , p_lock_subflow => true
                );

  -- check step key is valid
  if flow_engine_util.step_key_valid( pi_prcs_id            => p_process_id
                                    , pi_sbfl_id            => p_subflow_id
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

    -- complete the current step by doing the post-step operations
    l_iteration_status  :=  finish_current_step
                            ( p_sbfl_rec                     => l_sbfl_rec
                            , p_log_as_completed             => p_log_as_completed
                            , p_reset_step_key               => p_reset_step_key
                            , p_force_next_step              => p_force_next_step
                            , p_execute_variable_expressions => p_execute_variable_expressions
                            , p_matching_object              => p_matching_object
                            );

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
      l_previous_step := l_sbfl_rec.sbfl_current;
        --
        -- if next step is an iteration over a collection, check that the collection has members before confirming 
        -- it is the next step.  If not, step forward again by picking the next step
        -- start by finding the next subflow step
        l_step_info := get_step_info  ( p_sbfl_rec              => l_sbfl_rec
                                      , p_forward_route         => p_forward_route
                                      , p_iteration_is_complete => l_iteration_status.is_complete
                                      , p_previous_step         => l_previous_step
                                      );  
        -- get next step key
        l_step_info.target_objt_step_key  := flow_engine_util.step_key ( pi_sbfl_id         => p_subflow_id
                                                                  , pi_current         => l_step_info.target_objt_ref
                                                                  );
        -- control iteration progression
        l_existing_iter_id        := l_sbfl_rec.sbfl_iter_id;
        l_existing_iobj_id        := l_sbfl_rec.sbfl_iobj_id;
        case l_step_info.target_objt_iteration 
        when flow_constants_pkg.gc_iteration_sequential then
          if l_sbfl_rec.sbfl_current != l_step_info.target_objt_ref
          then
--            -- next step is a new sequential iteration
--            -- sequential iteration info is set when iteration subflows are create
            null;                                                           
          elsif p_reset_step_key then
            -- the next step is the iterating object (not the 2nd phase of sequential init)
            -- so reset the step key in the iteration array
            apex_debug.message ('call from flow_engine...');
            l_next_loop_counter    := 1;
            l_total_loop_instances := l_sbfl_rec.sbfl_loop_total_instances;
            l_next_iobj_id         := l_existing_iobj_id;
            l_next_step_confirmed  := true;
            l_next_iter_id := flow_iteration.get_iteration_id ( p_prcs_id      => p_process_id
                                                              , p_iobj_id      => l_next_iobj_id
                                                              , p_loop_counter => l_next_loop_counter
                                                              );                                                         
          elsif l_sbfl_rec.sbfl_loop_counter is not null then
            if l_step_info.target_objt_treat_as_tag = 'sequentialIterationClose' then
              -- this is the extra 'closing gateway' step that we add to close the iteration subflow & return
              -- processing back to the parent subflow.
              null;
            else
            -- loop counter has value - so sequentia iteration is in progress
            -- next step is the next sequential iteration of an existing iteration
            l_next_loop_counter    := l_sbfl_rec.sbfl_loop_counter +1;
            l_total_loop_instances := l_sbfl_rec.sbfl_loop_total_instances;
            l_next_iobj_id         := l_existing_iobj_id;

            l_next_iter_id := flow_iteration.get_iteration_id ( p_prcs_id      => p_process_id
                                                               , p_iobj_id      => l_next_iobj_id
                                                               , p_loop_counter => l_next_loop_counter
                                                               );  
            end if;
          else
            null;
          end if; -- loop counter
        when flow_constants_pkg.gc_iteration_parallel then
          if p_reset_step_key then
            -- the next step is the iterating object (not the 2nd phase ogf the implicit parallel gateway)
            -- so reset the step key in the iteration array
            apex_debug.message ('call from flow_engine...');
            flow_iteration.set_iteration_status
            ( pi_prcs_id        => p_process_id
            , pi_loop_counter   => l_sbfl_rec.sbfl_loop_counter
            , pi_new_status     => flow_constants_pkg.gc_iteration_status_running 
            , pi_step_key       => l_step_info.target_objt_step_key
            , pi_scope          => l_sbfl_rec.sbfl_iteration_var_scope
            , pi_prov_var_name  => l_sbfl_rec.sbfl_iteration_var
            , pi_iobj_id        => l_sbfl_rec.sbfl_iobj_id
            );
          end if;
          l_next_loop_counter := l_sbfl_rec.sbfl_loop_counter;
          l_total_loop_instances := l_sbfl_rec.sbfl_loop_total_instances;

          l_next_iobj_id         := l_existing_iobj_id;
          l_next_iter_id         := l_existing_iter_id;

        when flow_constants_pkg.gc_iteration_loop then
          if l_sbfl_rec.sbfl_current != l_step_info.target_objt_ref then
            -- next step is a new bpmn loop 
            -- for loop iteration we use the original subflow for the iterands so need 
            -- to set loop info on the original subflow. 
            -- loop iteration info is set when iteration subflows are created
            null;
          elsif p_reset_step_key then
            -- the next step is the iterating object (not the 2nd phase of sequential init)
            -- so reset the step key in the iteration array
            apex_debug.message ('call from flow_engine...');
            l_next_loop_counter    := 1;
            l_total_loop_instances := 1;
            l_next_iobj_id         := l_existing_iobj_id;
         
          elsif l_sbfl_rec.sbfl_loop_counter is not null then
            if l_step_info.target_objt_treat_as_tag = 'sequentialIterationClose' then
              -- this is the extra 'closing gateway' step that we add to close the iteration subflow & return
              -- processing back to the parent subflow.
              null;
            else
              -- loop counter has value - so sequentia iteration is in progress
              -- next step is the next sequential iteration of an existing iteration
              l_next_loop_counter    := l_sbfl_rec.sbfl_loop_counter +1;
              l_total_loop_instances := l_sbfl_rec.sbfl_loop_total_instances +1;
              l_next_iobj_id         := l_existing_iobj_id;

              -- create new iteration and extend the iteration array

              l_next_iter_id := flow_iteration.get_iteration_id ( p_prcs_id      => p_process_id
                                                                 , p_iobj_id      => l_next_iobj_id
                                                                 , p_loop_counter => l_next_loop_counter
                                                                 );  
            end if; --treat as tag
          end if; -- loop counter
        else 
          apex_debug.message (p_message => 'next step not an iteration or loop');
          -- next step is not an iteration or loop 
          l_next_loop_counter := null;
          l_total_loop_instances := l_sbfl_rec.sbfl_loop_total_instances; 
          l_next_step_confirmed  := true;
          l_next_iter_id := l_existing_iter_id;
        end case; -- iteration type
    end if; -- step error
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

    -- think about adding a check here if suspended and ee and certain object types
    -- will test using a case statement in the update of sbfl_status...
    l_new_status := case l_sbfl_rec.sbfl_status
                    when flow_constants_pkg.gc_sbfl_status_suspended then flow_constants_pkg.gc_sbfl_status_restart_on_resume
                    else flow_constants_pkg.gc_sbfl_status_running
                    end; 

    -- update subflow with step completed, and prepare for next step before committing
    update flow_subflows sbfl
      set sbfl.sbfl_current             = l_step_info.target_objt_ref
        , sbfl.sbfl_last_completed      = l_sbfl_rec.sbfl_current
        , sbfl.sbfl_became_current      = l_timestamp
        , sbfl.sbfl_step_key            = l_step_info.target_objt_step_key
        , sbfl.sbfl_status              = l_new_status
        , sbfl.sbfl_work_started        = null
        , sbfl.sbfl_potential_users     = null
        , sbfl.sbfl_potential_groups    = null
        , sbfl.sbfl_excluded_users      = null
        , sbfl.sbfl_apex_task_id        = null
        , sbfl.sbfl_lane                = coalesce( l_step_info.target_objt_lane       , sbfl.sbfl_lane        , null)
        , sbfl.sbfl_lane_name           = coalesce( l_step_info.target_objt_lane_name  , sbfl.sbfl_lane_name   , null)
        , sbfl.sbfl_lane_isRole         = coalesce( l_step_info.target_objt_lane_isRole, sbfl.sbfl_lane_isRole , null)
        , sbfl.sbfl_lane_role           = case l_step_info.target_objt_lane_isRole
                                          when 'true' then l_step_info.target_objt_lane_role
                                          when 'false' then null
                                          else coalesce( sbfl.sbfl_lane_role   , null)
                                          end
        , sbfl.sbfl_iter_id             = coalesce(l_next_iter_id, sbfl.sbfl_iter_id)
        , sbfl.sbfl_iobj_id             = l_next_iobj_id                                  
        , sbfl.sbfl_loop_counter        = l_next_loop_counter
        , sbfl.sbfl_iteration_type      = l_step_info.target_objt_iteration
        , sbfl.sbfl_loop_total_instances
                                        = coalesce(l_total_loop_instances, sbfl.sbfl_loop_total_instances)
        , sbfl.sbfl_iteration_var       = l_iteration_status.iteration_var
        , sbfl.sbfl_iteration_var_scope = l_iteration_status.var_scope
        , sbfl.sbfl_last_update         = l_timestamp
        , sbfl.sbfl_last_update_by      = coalesce ( sys_context('apex$session','app_user') 
                                                 , sys_context('userenv','os_user')
                                                 , sys_context('userenv','session_user')
                                                 )  
    where sbfl.sbfl_prcs_id = p_process_id
      and sbfl.sbfl_id = p_subflow_id
    ;
    commit;

    apex_debug.info
    ( p_message => 'Subflow %0 : Step End Committed for step %1.  New Sbfl Status %3'
    , p0        => p_subflow_id
    , p1        => l_sbfl_rec.sbfl_current
    , p2        => case l_sbfl_rec.sbfl_loop_counter 
                        when null then ''
                        else ' ['||l_sbfl_rec.sbfl_loop_counter ||']'
                        end
    , p3        => l_new_status
    );
  
    if l_new_status = flow_constants_pkg.gc_sbfl_status_running then
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

      -- Run the step
      run_step 
      ( p_sbfl_rec                => l_sbfl_rec
      , p_step_info               => l_step_info 
      , p_iteration_is_complete   => l_iteration_status.is_complete
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
      end if;  -- step error
    end if; -- status = running
  end if;
  end flow_complete_step;

  procedure start_step -- just (optionally) records the start time of work on the current step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type default null
    , p_called_internally  in boolean default false
    )
  is
    l_existing_start       flow_subflows.sbfl_work_started%type;
    l_sbfl_rec             flow_subflows%rowtype;
  begin
    apex_debug.enter
    ( 'start_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    , 'Step Key', p_step_key
    );
    -- subflow should already be locked when calling internally
    l_sbfl_rec := flow_engine_util.get_subflow_info 
                  ( p_process_id   => p_process_id
                  , p_subflow_id   => p_subflow_id
                  , p_lock_subflow => not p_called_internally
                  );
    -- check the step key
    if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                      , pi_sbfl_id  => p_subflow_id
                                      , pi_step_key_supplied  => p_step_key
                                      , pi_step_key_required  => l_sbfl_rec.sbfl_step_key
                                      ) 
    then 
      -- set the start time if null (will happen first time work started)
      if l_existing_start is null then
        update flow_subflows sbfl
           set sbfl_work_started        = systimestamp
             , sbfl.sbfl_last_update    = systimestamp
             , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                   , sys_context('userenv','os_user')
                                                   , sys_context('userenv','session_user')
                                                   )  
        where sbfl_prcs_id = p_process_id
          and sbfl_id = p_subflow_id
        ;
      end if;
      -- log the start
      flow_logging.log_step_event 
      ( p_sbfl_rec    => l_sbfl_rec
      , p_event       => flow_constants_pkg.gc_step_event_work_started
      , p_event_level => flow_constants_pkg.gc_logging_level_detailed
      );
      -- commit reservation if this is an external call
      if not p_called_internally then 
        commit;
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

  procedure pause_step -- just (optionally) records the pause time of work on the current step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type default null
    , p_called_internally  in boolean default false
    )
  is
    l_existing_start       flow_subflows.sbfl_work_started%type;
    l_sbfl_rec             flow_subflows%rowtype;
  begin
    apex_debug.enter
    ( 'start_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    , 'Step Key', p_step_key
    );
    -- subflow should already be locked when calling internally
    l_sbfl_rec := flow_engine_util.get_subflow_info 
                  ( p_process_id   => p_process_id
                  , p_subflow_id   => p_subflow_id
                  , p_lock_subflow => not p_called_internally
                  );
    -- check the step key
    if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                      , pi_sbfl_id  => p_subflow_id
                                      , pi_step_key_supplied  => p_step_key
                                      , pi_step_key_required  => l_sbfl_rec.sbfl_step_key
                                      ) 
    then 
      -- set the pause time - requires the step to have already started work
      if l_sbfl_rec.sbfl_work_started is not null then
        -- log the pause
        flow_logging.log_step_event 
        ( p_sbfl_rec    => l_sbfl_rec
        , p_event       => flow_constants_pkg.gc_step_event_work_paused
        , p_event_level => flow_constants_pkg.gc_logging_level_detailed
        );
        -- commit pause if this is an external call
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
end pause_step;

procedure restart_step
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_step_key            in flow_subflows.sbfl_step_key%type default null
  , p_comment             in flow_instance_event_log.lgpr_comment%type default null
  , p_check_for_error     in boolean default true
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

  if p_check_for_error then
    -- called externally to restart an errored step (legacy)
    -- i.e., not being called to restart a process from a specific step
    -- check subflow current task is in error status
    if l_sbfl_rec.sbfl_status <> flow_constants_pkg.gc_sbfl_status_error then 
        flow_errors.handle_general_error
        ( pi_message_key => 'restart-no-error'
        );
        -- $F4AMESSAGE 'restart-no-error' || 'No Current Error Found.  Check your process diagram.'  
    end if;
  end if;
  
  if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                    , pi_sbfl_id  => p_subflow_id
                                    , pi_step_key_supplied  => p_step_key
                                    , pi_step_key_required  => l_sbfl_rec.sbfl_step_key
                                    ) 
  then 
    -- valid step key was supplied
    -- set up step context
    l_step_info :=  get_step_info
                    ( p_sbfl_rec        => l_sbfl_rec
                    , p_is_restart      => true
                    );
    -- set subflow status to running
    update flow_subflows sbfl
       set sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
         , sbfl.sbfl_last_update    = systimestamp
         , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                               , sys_context('userenv','os_user')
                                               , sys_context('userenv','session_user')
                                               )  
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id      = p_subflow_id
    ;
    -- log the restart (now a step level event)
    flow_logging.log_step_event 
    ( p_sbfl_rec    => l_sbfl_rec
    , p_event       => case p_check_for_error
                       when true then 
                         flow_constants_pkg.gc_step_event_error_restart
                       else 
                         flow_constants_pkg.gc_step_event_resumed
                       end
    , p_event_level => flow_constants_pkg.gc_logging_level_abnormal_events
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
           , prcs.prcs_was_altered = 'Y'
           , prcs.prcs_last_update = systimestamp
           , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
       where prcs.prcs_id = p_process_id
      ;
      flow_logging.log_instance_event
      ( p_process_id    => p_process_id
      , p_objt_bpmn_id  => l_sbfl_rec.sbfl_current
      , p_event         => flow_constants_pkg.gc_prcs_status_running
      , p_event_level   => flow_constants_pkg.gc_logging_level_abnormal_events
      );
    else
      -- mark instance as altered anyhow
      flow_instances.set_was_altered (p_process_id => p_process_id);
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

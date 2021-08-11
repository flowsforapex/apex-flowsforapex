create or replace package body flow_engine
as 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

function flow_get_matching_link_object
( pi_dgrm_id     in flow_diagrams.dgrm_id%type 
, pi_link_bpmn_id   in flow_objects.objt_name%type
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
      apex_error.add_error
      ( p_message => 'Unable to find matching link catch event named '||pi_link_bpmn_id||' .'
      , p_display_location => apex_error.c_on_error_page
      );
   when too_many_rows then
      apex_error.add_error
      ( p_message => 'More than one matching link catch event named '||pi_link_bpmn_id||' .'
      , p_display_location => apex_error.c_on_error_page
      );   
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
    -- find matching link catching event and step to it
    l_next_objt := flow_get_matching_link_object 
      ( pi_dgrm_id => p_step_info.dgrm_id
      , pi_link_bpmn_id => p_step_info.target_objt_ref
      );
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
    flow_complete_step
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
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
    l_sbfl_id_par           flow_subflows.sbfl_id%type;  
    l_boundary_event        flow_objects.objt_bpmn_id%type;
    l_subproc_objt          flow_objects.objt_bpmn_id%type;
    l_exit_type             flow_objects.objt_sub_tag_name%type default null;
    l_remaining_subflows    number;
  begin
    apex_debug.enter 
    ( 'process_endEvent'
    , 'Process', p_process_id
    , 'Subflow', p_subflow_id
    );
    --next step can be either end of process or sub-process returning to its parent
    -- get parent subflow
    l_sbfl_id_par := flow_engine_util.get_subprocess_parent_subflow
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_current    => p_sbfl_info.sbfl_current
      );
    -- update the subflow before logging
     update flow_subflows sbfl
        set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
          , sbfl.sbfl_current = p_step_info.target_objt_ref
          , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_completed  
          , sbfl.sbfl_work_started = systimestamp
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

    if p_sbfl_info.sbfl_process_level = 0 then   
      -- in a top level process
      apex_debug.info 
      ( p_message => 'Next Step is Process End %0'
      , p0        => p_step_info.target_objt_ref 
      );
      -- check for Terminate sub-Event
      if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition then
        flow_engine_util.terminate_level
        ( 
          p_process_id     => p_process_id
        , p_process_level  => p_sbfl_info.sbfl_process_level
        );
      elsif p_step_info.target_objt_subtag is null then
        flow_engine_util.subflow_complete
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );
      end if;
      -- check if there are ANY remaining subflows.  If not, close process
      select count(*)
        into l_remaining_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id;
      
      if l_remaining_subflows = 0 then 
        -- No remaining subflows so process has completed
        update flow_processes prcs 
           set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_completed
             , prcs.prcs_last_update = systimestamp
         where prcs.prcs_id = p_process_id
        ;
        -- log the completion
        flow_logging.log_instance_event
        ( p_process_id => p_process_id
        , p_event      => flow_constants_pkg.gc_prcs_event_completed
        );
        apex_debug.info 
        ( p_message => 'Process Completed: Process %0'
        , p0        => p_process_id 
        );
      end if;
    else  
      -- in a sub-process
      apex_debug.info
      ( p_message => 'Next Step is Sub-Process End %0 of type %1 . Parent Subflow : %2'
      , p0        => p_step_info.target_objt_ref
      , p1        => p_step_info.target_objt_subtag
      , p2        => l_sbfl_id_par
      ); 
      if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_error_event_definition then
        -- error exit event - return to errorBoundaryEvent if it exists and if not to normal exit
        begin
          select boundary_objt.objt_bpmn_id
               , subproc_objt.objt_bpmn_id
            into l_boundary_event
               , l_subproc_objt
            from flow_objects boundary_objt
            join flow_objects subproc_objt
              on subproc_objt.objt_bpmn_id = boundary_objt.objt_attached_to
            join flow_subflows par_sbfl
              on par_sbfl.sbfl_current = subproc_objt.objt_bpmn_id
            join flow_processes prcs 
              on par_sbfl.sbfl_prcs_id = prcs.prcs_id
             and prcs.prcs_dgrm_id = boundary_objt.objt_dgrm_id
             and prcs.prcs_dgrm_id = subproc_objt.objt_dgrm_id
           where par_sbfl.sbfl_id = l_sbfl_id_par
             and par_sbfl.sbfl_prcs_id = p_process_id
             and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_error_event_definition
          ;
          -- first remove any non-interrupting timers that are on the parent event
          flow_boundary_events.unset_boundary_timers (p_process_id, l_sbfl_id_par);
          -- set current event on parent process to the error Boundary Event
          update flow_subflows sbfl
          set sbfl.sbfl_current = l_boundary_event
            , sbfl.sbfl_last_completed = l_subproc_objt  -- is this done in next_step?
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
          where sbfl.sbfl_id = l_sbfl_id_par
            and sbfl.sbfl_prcs_id = p_process_id
            ;
        exception
          when no_data_found then
            -- error exit with no Boundary Event specified -- return to normal exit
            l_boundary_event := null;
          when too_many_rows then
            apex_error.add_error
              ( p_message => 'More than one error boundaryEvent found on sub process '||l_subproc_objt||'.'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
        -- stop processing in sub process and all children
        flow_engine_util.terminate_level
        ( p_process_id => p_process_id
        , p_process_level => p_sbfl_info.sbfl_process_level
        );

      elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition then
        -- stop processing in sub process and all children
        flow_engine_util.terminate_level
        ( p_process_id    => p_process_id
        , p_process_level => p_sbfl_info.sbfl_process_level
        ); 
      elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition then
        -- this can be interrupting or non-interupting
        flow_boundary_events.process_boundary_event
        ( p_process_id    => p_process_id
        , p_subflow_id    => p_subflow_id
        , p_step_info     => p_step_info
        , p_par_sbfl      => l_sbfl_id_par
        , p_process_level => p_sbfl_info.sbfl_process_level
        );
      elsif p_step_info.target_objt_subtag is null then 
        -- normal end event
        flow_engine_util.subflow_complete
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );

      end if;
      -- check if there are ANY remaining subflows in the subProcess.  If not, close process
      select count(*)
        into l_remaining_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_process_level = p_sbfl_info.sbfl_process_level;
        
      if l_remaining_subflows = 0 then 
        -- No remaining subflows so subprocess has completed - return to parent and do next step
        flow_complete_step 
        ( p_process_id => p_process_id
        , p_subflow_id => l_sbfl_id_par
        );  
        apex_debug.info ('SubProcess Completed: Process level %0', p_sbfl_info.sbfl_process_level );

      end if;
    end if; 
  end process_endEvent;

  procedure process_subProcess
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_target_objt_sub        flow_objects.objt_bpmn_id%type; --target object in subprocess
    l_sbfl_id_sub            flow_subflows.sbfl_id%type;   
  begin
    apex_debug.enter 
    ( 'process_subprocess'
    , 'object', p_step_info.target_objt_tag 
    );
    begin
       select objt.objt_bpmn_id
         into l_target_objt_sub
         from flow_objects objt
        where objt.objt_objt_id  = p_step_info.target_objt_id
          and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event  
          and objt.objt_dgrm_id  = p_step_info.dgrm_id
       ;
    exception
      when no_data_found then
        apex_error.add_error
        ( p_message => 'Unable to find Sub-Process Start Event.'
        , p_display_location => apex_error.c_on_error_page
        );
      when too_many_rows then
        apex_error.add_error
        ( p_message => 'More than one Sub-Process Start found..'
        , p_display_location => apex_error.c_on_error_page
        );
    end;
    -- start subflow for the sub-process
    l_sbfl_id_sub := 
      flow_engine_util.subflow_start
      ( p_process_id => p_process_id
      , p_parent_subflow => p_subflow_id
      , p_starting_object => p_step_info.target_objt_ref -- parent subProc activity
      , p_current_object => l_target_objt_sub -- subProc startEvent
      , p_route => 'sub main'
      , p_last_completed => p_sbfl_info.sbfl_last_completed -- previous activity on parent proc
      , p_parent_sbfl_proc_level => null
      , p_new_proc_level => true
      , p_dgrm_id => p_sbfl_info.sbfl_dgrm_id
      );

    -- Always do all updates to data first before performing any next step.
    -- Reason: A subflow could immediately disappear if we're stepping through it completly.
    -- update parent subflow
    update flow_subflows sbfl
    set   sbfl.sbfl_current = p_step_info.target_objt_ref -- parent subProc Activity
        , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
        , sbfl.sbfl_last_update = systimestamp
        , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
    where sbfl.sbfl_id = p_subflow_id
      and sbfl.sbfl_prcs_id = p_process_id
    ;  
    -- set boundaryEvent Timers, if any
    flow_boundary_events.set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );     

    -- step into sub_process
    flow_complete_step   
    ( p_process_id => p_process_id
    , p_subflow_id => l_sbfl_id_sub
    , p_forward_route => null
    );
  end process_subProcess; 

  procedure process_intermediateCatchEvent
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_sbfl_info  in flow_subflows%rowtype
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
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      flow_timers_pkg.start_timer
      ( 
        pi_prcs_id => p_process_id
      , pi_sbfl_id => p_subflow_id
      );
    else
      -- not a timer.  Just set it to running for now.  (other types to be implemented later)
      -- this includes bpmn:linkEventDefinition which should come here
      update flow_subflows sbfl
         set sbfl.sbfl_current = p_step_info.target_objt_ref
           , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
           , sbfl.sbfl_last_update = systimestamp
           , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    end if;
  end process_intermediateCatchEvent;

  procedure process_intermediateThrowEvent
  ( 
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_par_sbfl    flow_subflows.sbfl_id%type;
  begin
    -- currently only supports none Intermediate throw event (used as a process state marker)
    -- but this might later have a case type = timer, message, etc. ....
    apex_debug.enter 
    ('process_IntermediateThrowEvent'
    , 'p_step_info.target_objt_ref', p_step_info.target_objt_ref
    );

    if p_step_info.target_objt_subtag is null then
      -- a none event.  Make the ITE the current event then just call flow_complete_step.  
      update flow_subflows sbfl
      set   sbfl.sbfl_current = p_step_info.target_objt_ref
          , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
          , sbfl.sbfl_last_update = systimestamp
          , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
      where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
      flow_complete_step
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_link_event_definition then
      flow_process_link_event
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_sbfl_info  => p_sbfl_info
      , p_step_info  => p_step_info
      );   
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition then
      -- make the ITE the current event
      update  flow_subflows sbfl
          set sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- get the subProcess event in the parent level
      l_par_sbfl := flow_engine_util.get_subprocess_parent_subflow
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_current => p_step_info.target_objt_ref
      );
      -- escalate it to the boundary Event
      flow_boundary_events.process_boundary_event
      ( p_process_id    => p_process_id
      , p_subflow_id    => p_subflow_id
      , p_step_info     => p_step_info
      , p_par_sbfl      => l_par_sbfl
      , p_process_level => p_sbfl_info.sbfl_process_level
      );  
    else 
      --- other type of intermediateThrowEvent that is not currently supported
      apex_error.add_error
          ( p_message => 'Currently unsupported type of Intermediate Throw Event encountered at '||p_sbfl_info.sbfl_current||' .'
          , p_display_location => apex_error.c_on_error_page
          );
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
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_parent_sbfl           flow_subflows.sbfl_id%type;
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
    l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );
     select conn.conn_id
          , sbfl.sbfl_current
          , sbfl.sbfl_starting_object
       into l_forward_route
          , l_current_object
          , l_child_starting_object
       from flow_objects objt
       join flow_subflows sbfl 
         on sbfl.sbfl_current = objt.objt_bpmn_id
       join flow_processes prcs
         on sbfl.sbfl_prcs_id = prcs.prcs_id
        and prcs.prcs_dgrm_id = objt.objt_dgrm_id
       join flow_connections conn 
         on conn.conn_src_objt_id = objt.objt_id
        and conn.conn_dgrm_id = prcs.prcs_dgrm_id
      where sbfl.sbfl_id = p_cleared_subflow_id
        and prcs.prcs_id = p_process_id
        and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
          ;
     update flow_subflows sbfl
        set sbfl_status = flow_constants_pkg.gc_sbfl_status_running
          , sbfl_current = l_current_object
          , sbfl_last_completed = l_child_starting_object
          , sbfl_last_update = systimestamp
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
            on sbfl.sbfl_current = objt.objt_bpmn_id
          join flow_processes prcs
            on sbfl.sbfl_prcs_id = prcs.prcs_id
           and objt.objt_dgrm_id = prcs.prcs_dgrm_id
         where sbfl.sbfl_sbfl_id = p_parent_subflow_id
           and sbfl.sbfl_starting_object = l_child_starting_object
           and objt.objt_dgrm_id = l_dgrm_id
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
    , p_forward_route => null
    );
end handle_event_gateway_event;

procedure handle_intermediate_catch_event
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) 
is
begin
  apex_debug.enter('handle_intermediate_catch_event', 'Subflow', p_subflow_id);
  update flow_subflows sbfl 
      set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        , sbfl.sbfl_last_update = systimestamp
    where sbfl.sbfl_prcs_id = p_process_id
      and sbfl.sbfl_id = p_subflow_id
        ;
  flow_complete_step 
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_forward_route => null
  );
end handle_intermediate_catch_event;

procedure flow_handle_event
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) 
is
  l_parent_subflow        flow_subflows.sbfl_id%type;
  l_prev_objt_tag_name    flow_objects.objt_tag_name%type;
  l_curr_objt_tag_name    flow_objects.objt_tag_name%type;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_sbfl_current          flow_subflows.sbfl_current%type;
begin
  apex_debug.enter 
  ( 'flow_handle_event'
  , 'Subflow', p_subflow_id
  );
  -- look at current event to check if it is a startEvent.  (this also has no previous event!)
  -- if not, examine previous event on the subflow to determine if it was eventBasedGateway (eBG)
  -- an intermediateCatchEvent (iCE) following an eBG will always have exactly 1 input (from the eBG)
  -- an independant iCE (not following an eBG) can have >1 inputs
  -- so look for preceding eBG.  If previous event not eBG or there are multiple prev events, it did not follow an eBG.
  l_dgrm_id := flow_engine_util.get_dgrm_id (p_prcs_id => p_process_id);

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
      join flow_processes prcs
        on prcs.prcs_id = sbfl.sbfl_prcs_id
       and prcs_dgrm_id = curr_objt.objt_dgrm_id
     where sbfl.sbfl_id = p_subflow_id
       and prcs.prcs_id = p_process_id
        ;

    if l_curr_objt_tag_name in ( flow_constants_pkg.gc_bpmn_start_event   -- startEvent with associated event.
                               , flow_constants_pkg.gc_bpmn_boundary_event  ) then
      -- required functionality same as iCE currently
      handle_intermediate_catch_event 
      (
        p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );
    elsif l_curr_objt_tag_name in ( flow_constants_pkg.gc_bpmn_subprocess
                                  , flow_constants_pkg.gc_bpmn_task 
                                  , flow_constants_pkg.gc_bpmn_usertask
                                  , flow_constants_pkg.gc_bpmn_manualtask
                                  )   -- add any objects that can support timer boundary events here
    then
      flow_boundary_events.handle_interrupting_boundary_event 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );
    else
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
         where conn.conn_dgrm_id = l_dgrm_id
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
        );
      end if;
    end if;
  end if; -- sbfl locked
end flow_handle_event;

/************************************************************************************************************
****
****                       SUBFLOW  NEXT_STEP
****
*************************************************************************************************************/


procedure flow_complete_step
( p_process_id        in flow_processes.prcs_id%type
, p_subflow_id        in flow_subflows.sbfl_id%type
, p_forward_route     in flow_connections.conn_bpmn_id%type default null
, p_log_as_completed  in boolean default true
)
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_step_info             flow_types_pkg.flow_step_info;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
 -- l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.enter 
  ( 'flow_complete_step'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  );
  --l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );
  -- Get current object and current subflow info and lock it
  l_sbfl_rec := flow_engine_util.get_and_lock_subflow_info 
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  );
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
  begin
    select sbfl.sbfl_dgrm_id
         , objt_source.objt_tag_name
         , objt_source.objt_id
         , conn.conn_tgt_objt_id
         , objt_target.objt_bpmn_id
         , objt_target.objt_tag_name    
         , objt_target.objt_sub_tag_name
      into l_step_info
      from flow_connections conn
      join flow_objects objt_source
        on conn.conn_src_objt_id = objt_source.objt_id
       and conn.conn_dgrm_id = objt_source.objt_dgrm_id
      join flow_objects objt_target
        on conn.conn_tgt_objt_id = objt_target.objt_id
       and conn.conn_dgrm_id = objt_target.objt_dgrm_id
--      join flow_processes prcs
--        on prcs.prcs_dgrm_id = conn.conn_dgrm_id
      join flow_subflows sbfl
        on sbfl.sbfl_current = objt_source.objt_bpmn_id 
       and sbfl.sbfl_dgrm_id = conn.conn_dgrm_id
--       and sbfl.sbfl_prcs_id = prcs.prcs_id
     where /*conn.conn_dgrm_id = l_dgrm_id
       and */conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_bpmn_id like nvl2( p_forward_route, p_forward_route, '%' )
       and sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
    ;
  exception
  when no_data_found then
    apex_error.add_error
    ( p_message => 'No Next Step Found.  Check your process diagram.'
    , p_display_location => apex_error.c_on_error_page
    );
  when too_many_rows then
    apex_error.add_error
    ( p_message => 'More than 1 forward path found when only 1 allowed'
    , p_display_location => apex_error.c_on_error_page
    );
  end;


  -- clean up any boundary events left over from the previous activity
  if (l_step_info.source_objt_tag in ( flow_constants_pkg.gc_bpmn_subprocess
                                     , flow_constants_pkg.gc_bpmn_task
                                     , flow_constants_pkg.gc_bpmn_usertask
                                     , flow_constants_pkg.gc_bpmn_manualtask
                                    ) -- boundary event attachable types
      and l_sbfl_rec.sbfl_has_events is not null )            -- subflow has events attached
  then
      -- 
      apex_debug.info 
      ( p_message => 'boundary event cleanup triggered for subflow %0'
      , p0        => p_subflow_id
      );
      flow_boundary_events.unset_boundary_timers (p_process_id, p_subflow_id);
  end if;
  if p_log_as_completed then
    -- log current step as completed before loosing the reservation
    flow_logging.log_step_completion   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => l_sbfl_rec.sbfl_current
    );
  end if;
  -- release subflow reservation
  if l_sbfl_rec.sbfl_reservation is not null then
    flow_reservations.release_step
    ( p_process_id        => p_process_id
    , p_subflow_id        => p_subflow_id
    , p_called_internally => true
    );
  end if;

  
  -- end of post- phase for previous step
  commit;
  apex_debug.info
  ( p_message => 'End of Post Phase (committed) for current step %1 on subflow %0. Moving onto Pre-Phase of Next Step'
  , p0        => p_subflow_id
  , p1        => l_sbfl_rec.sbfl_current
  );

  -- start of pre-phase for next step

  -- relock subflow
  l_sbfl_rec := flow_engine_util.get_and_lock_subflow_info 
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  );
  l_sbfl_rec.sbfl_last_completed := l_sbfl_rec.sbfl_current;

  apex_debug.info 
  ( p_message => 'Next Step - Target object: %s.  More info at APP_TRACE level.'
  , p0        => coalesce(l_step_info.target_objt_tag, '!NULL!') 
  );
  apex_debug.trace
  ( p_message => 'Next Step Info - dgrm_id : %0, source_objt_tag : %1, target_objt_id : %2, target_objt_ref : %3'
  , p0  => l_step_info.dgrm_id
  , p1  => l_step_info.source_objt_tag
  , p2  => l_step_info.target_objt_id
  , p3  => l_step_info.target_objt_ref
  );
  apex_debug.trace
  ( p_message => 'Next Step Info - target_objt_tag : %0, target_objt_subtag : %1'
  , p0 => l_step_info.target_objt_tag
  , p1 => l_step_info.target_objt_subtag
  );
  apex_debug.trace
  ( p_message => 'Next Step Context - sbfl_id : %0, sbfl_last_completed : %1, sbfl_prcs_id : %2'
  , p0 => l_sbfl_rec.sbfl_id
  , p1 => l_sbfl_rec.sbfl_last_completed
  , p2 => l_sbfl_rec.sbfl_prcs_id
  );    

  case (l_step_info.target_objt_tag)
    when flow_constants_pkg.gc_bpmn_end_event then  --next step is either end of process or sub-process returning to its parent
      flow_engine.process_endEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_exclusive then
      flow_gateways.process_exclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_inclusive then
      flow_gateways.process_para_incl_Gateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_parallel then
      flow_gateways.process_para_incl_Gateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_subprocess then
      flow_engine.process_subProcess
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_event_based then
        flow_gateways.process_eventBasedGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_catch_event then 
        flow_engine.process_intermediateCatchEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_throw_event then 
        flow_engine.process_intermediateThrowEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_task then 
        flow_tasks.process_task
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_usertask then
        flow_tasks.process_userTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_scripttask then 
        flow_tasks.process_scriptTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_manualtask then 
        flow_tasks.process_manualTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_servicetask then 
    flow_tasks.process_scriptTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    end case;
    -- Commit transaction before returning
    commit;
  exception
    when case_not_found then
      apex_error.add_error
      ( p_message => 'Process Model Error: Process BPMN model next step uses unsupported object: '||l_step_info.target_objt_tag
      , p_display_location => apex_error.c_on_error_page
      );
    when no_data_found then
      apex_error.add_error
      ( p_message => 'Next step does not exist. Please check your process diagram.'
      , p_display_location => apex_error.c_on_error_page
      );
    when flow_plsql_runner_pkg.e_plsql_script_failed then
    /*
      apex_error.add_error
      (
        p_message => 'PL/SQL Call Error: The given PL/SQL code did not execute successfully.'
      , p_display_location => apex_error.c_on_error_page
      );
    */
    null;
  end flow_complete_step;

  procedure start_step -- just (optionally) records the start time gpr work on the current step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_called_internally  in boolean default false
    )
  is
    l_existing_start       flow_subflows.sbfl_work_started%type;
  begin
    apex_debug.enter
    ( 'start_step'
    , 'Subflow ', p_subflow_id
    , 'Process ', p_process_id 
    );
    -- subflow should already be locked when calling internally
    if not p_called_internally then 
      -- lock  subflow if called externally
      select sbfl_work_started
        into l_existing_start
        from flow_subflows sbfl 
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         for update of sbfl_work_started wait 2
      ;
    end if;
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

  exception
    when no_data_found then
      apex_error.add_error
      ( p_message => 'Start Work time recording unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
    when lock_timeout then
        apex_error.add_error
        ( p_message => 'Subflow '||p_subflow_id||' currently locked by another user.  Try to start your task later.'
        , p_display_location => apex_error.c_on_error_page
        );
  end start_step;

end flow_engine;
/

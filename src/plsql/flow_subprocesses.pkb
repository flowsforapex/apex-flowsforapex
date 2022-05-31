/* 
-- Flows for APEX - flow_subprocesses.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 22-Feb-2022   Richard Allen - Refactor SubProcess code from flow_engine
--
*/

create or replace package body flow_subprocesses
as

/* -----------------------------------------------------------------------------
--
--  process_process_level_endEvent
--
--  handles endEvents that complete a process level, e.g., subProcesses and callActivities
--
--------------------------------------------------------------------------------
*/

  procedure process_process_level_endEvent
    ( p_process_id        in flow_processes.prcs_id%type
    , p_subflow_id        in flow_subflows.sbfl_id%type
    , p_sbfl_info         in flow_subflows%rowtype
    , p_step_info         in flow_types_pkg.flow_step_info
    , p_sbfl_context_par  in flow_types_pkg.t_subflow_context
    )
  is
    l_boundary_event        flow_objects.objt_bpmn_id%type;
    l_subproc_objt          flow_objects.objt_bpmn_id%type;
    l_remaining_subflows    number;
    l_parent_step_key       flow_subflows.sbfl_step_key%type;
    l_end_is_interrupted    boolean;  
    l_par_objt_type         flow_objects.objt_tag_name%type;
    l_par_dgrm_id           flow_diagrams.dgrm_id%type;
    l_par_objt_id           flow_objects.objt_id%type;
  begin
    apex_debug.enter
      ( 'Process Level End Event'
      , 'End Event'       , p_step_info.target_objt_ref
      , 'Event Type'      , p_step_info.target_objt_subtag
      , 'Parent Event'    , p_sbfl_context_par.sbfl_id
      , 'Parent Step Key' , p_sbfl_context_par.step_key
      ); 
    if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_error_event_definition then
      -- error exit event - return to errorBoundaryEvent if it exists and if not to normal exit
      begin
        select boundary_objt.objt_bpmn_id
             , subproc_objt.objt_bpmn_id
             , par_sbfl.sbfl_step_key
          into l_boundary_event
             , l_subproc_objt
             , l_parent_step_key
          from flow_objects boundary_objt
          join flow_objects subproc_objt
            on subproc_objt.objt_bpmn_id = boundary_objt.objt_attached_to 
           and subproc_objt.objt_dgrm_id = boundary_objt.objt_dgrm_id
          join flow_subflows par_sbfl
            on par_sbfl.sbfl_current = subproc_objt.objt_bpmn_id
           and par_sbfl.sbfl_dgrm_id = subproc_objt.objt_dgrm_id
         where par_sbfl.sbfl_id = p_sbfl_context_par.sbfl_id
           and par_sbfl.sbfl_prcs_id = p_process_id
           and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_error_event_definition
        ;
        -- first remove any non-interrupting timers that are on the parent event
        flow_boundary_events.unset_boundary_timers (p_process_id, p_sbfl_context_par.sbfl_id);
        -- set current event on parent process to the error Boundary Event
        update flow_subflows sbfl
        set sbfl.sbfl_current = l_boundary_event
          , sbfl.sbfl_last_completed = l_subproc_objt  -- is this done in next_step?
          , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_sbfl_context_par.sbfl_id
          and sbfl.sbfl_prcs_id = p_process_id
          ;
        -- execute the on-event expressions for the boundary event
        flow_expressions.process_expressions
        ( pi_objt_bpmn_id => l_boundary_event  
        , pi_set          => flow_constants_pkg.gc_expr_set_on_event
        , pi_prcs_id      => p_process_id
        , pi_sbfl_id      => p_sbfl_context_par.sbfl_id
        , pi_var_scope    => p_sbfl_context_par.scope
        , pi_expr_scope   => p_sbfl_context_par.scope        
        );
        l_end_is_interrupted := true;

      exception
        when no_data_found then
          -- error exit with no Boundary Event specified -- return to normal exit
          l_end_is_interrupted := true;
        when too_many_rows then
          flow_errors.handle_instance_error
          ( pi_prcs_id     => p_process_id
          , pi_sbfl_id     => p_subflow_id
          , pi_message_key => 'boundary-event-too-many'
          , p0 => 'error'
          );
          -- $F4AMESSAGE 'boundary-event-too-many' || 'More than one %0 boundaryEvent found on sub process.'  
      end;
      -- stop processing in process level and all its children levels
      flow_engine_util.terminate_level
      ( p_process_id => p_process_id
      , p_process_level => p_sbfl_info.sbfl_process_level
      );
      -- normal end processing will be ignored but we neeed to step forward on the parent
      flow_engine.flow_complete_step 
      ( p_process_id        => p_process_id
      , p_subflow_id        => p_sbfl_context_par.sbfl_id
      , p_step_key          => p_sbfl_context_par.step_key
      , p_log_as_completed  => false
      );
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition then
      -- sub process terminate end
      -- stop processing in sub process and all children
      flow_engine_util.terminate_level
      ( p_process_id    => p_process_id
      , p_process_level => p_sbfl_info.sbfl_process_level
      ); 
      l_end_is_interrupted := true;
      -- normal end processing will be ignored but we neeed to step forward on the parent
      flow_engine.flow_complete_step 
      ( p_process_id  => p_process_id
      , p_subflow_id  => p_sbfl_context_par.sbfl_id
      , p_step_key  => p_sbfl_context_par.step_key
      , p_log_as_completed  => false
      );
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition then
      -- sub process escalation end
      -- this can be interrupting or non-interupting
      flow_boundary_events.process_escalation
      ( pi_sbfl_info        => p_sbfl_info
      , pi_step_info        => p_step_info
      , pi_par_sbfl         => p_sbfl_context_par.sbfl_id
      , pi_source_type      => flow_constants_pkg.gc_bpmn_end_event
      , po_step_key         => l_parent_step_key
      , po_is_interrupting  => l_end_is_interrupted
      );
    elsif p_step_info.target_objt_subtag is null then 
      -- sub process - normal end event
      flow_engine_util.subflow_complete
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );
      l_end_is_interrupted := false;
    end if;

    if not l_end_is_interrupted then
      -- normal process level processing.  
      -- check if there are ANY remaining subflows in the process level.  
      -- If none, close process level
      select count(*)
        into l_remaining_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_process_level = p_sbfl_info.sbfl_process_level;

      if l_remaining_subflows = 0 then 
        -- No remaining subflows so process level has completed 
        select objt.objt_tag_name
             , par_sbfl.sbfl_dgrm_id
             , objt.objt_id
          into l_par_objt_type
             , l_par_dgrm_id
             , l_par_objt_id
          from flow_objects objt
          join flow_subflows par_sbfl
            on par_sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
           and par_sbfl.sbfl_current = objt.objt_bpmn_id
         where par_sbfl.sbfl_id = p_sbfl_context_par.sbfl_id
        ;
        if l_par_objt_type = flow_constants_pkg.gc_bpmn_call_activity then
          -- map outVariables expressions for call return (variables in calling scope, expressions in called scope)
          -- note: outVariable processing only occurs if the callActivit has a non-interrupted return
          flow_expressions.process_expressions
          ( pi_objt_id      => l_par_objt_id
          , pi_set          => flow_constants_pkg.gc_expr_set_out_variables
          , pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_sbfl_context_par.sbfl_id   
          , pi_var_scope    => p_sbfl_context_par.scope
          , pi_expr_scope   => p_sbfl_info.sbfl_scope
          );        
        end if;
        -- return to parent level and do next step
        apex_debug.info ('Process Level Completed: Process level %0', p_sbfl_info.sbfl_process_level );
        flow_engine.flow_complete_step 
        ( p_process_id => p_process_id
        , p_subflow_id => p_sbfl_context_par.sbfl_id
        , p_step_key   => p_sbfl_context_par.step_key
        );  
      end if;
    end if;
  end process_process_level_endEvent;

  procedure process_subProcess
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_target_objt_sub        flow_objects.objt_bpmn_id%type; --target object in subprocess
    l_sbfl_context_sub       flow_types_pkg.t_subflow_context;   
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
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => p_subflow_id
        , pi_message_key => 'subProcess-no-start'
        );
      -- $F4AMESSAGE 'subProcess-no-start' || 'Unable to find Sub-Process Start Event.'  
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => p_subflow_id
        , pi_message_key => 'subProcess-too-many-starts'
        );
        -- $F4AMESSAGE 'subProcess-too-many-starts' || 'More than one Sub-Process Start found.'  
    end;
    -- start subflow for the sub-process
    l_sbfl_context_sub := 
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

    -- Always do all updates to parent data first before performing any next step in the children.
    -- Reason: A subflow could immediately disappear if we're stepping through it completely.
    -- check for any errors on the step
    if not flow_globals.get_step_error then 
      -- set boundaryEvent Timers, if any
      flow_boundary_events.set_boundary_timers 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );  
      if not flow_globals.get_step_error then 
        -- Check again, then Update parent subflow
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref -- parent subProc Activity
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;  
      
        -- run on-event expressions for child startEvent
        flow_expressions.process_expressions
        ( pi_objt_bpmn_id => l_target_objt_sub  
        , pi_set          => flow_constants_pkg.gc_expr_set_on_event
        , pi_prcs_id      => p_process_id
        , pi_sbfl_id      => l_sbfl_context_sub.sbfl_id
        , pi_var_scope    => l_sbfl_context_sub.scope
        , pi_expr_scope   => l_sbfl_context_sub.scope
        );

        if not flow_globals.get_step_error then 

          -- check again for any errors from expressions before stepping into sub_process
          flow_engine.flow_complete_step   
          ( p_process_id    => p_process_id
          , p_subflow_id    => l_sbfl_context_sub.sbfl_id
          , p_step_key      => l_sbfl_context_sub.step_key
          , p_forward_route => null
          );
        end if;
      end if;
    end if;
  end process_subProcess; 

end flow_subprocesses;
/





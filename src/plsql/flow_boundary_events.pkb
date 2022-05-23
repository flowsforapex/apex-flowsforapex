create or replace package body flow_boundary_events
is 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  procedure set_boundary_timers
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  )
  is 
    l_new_non_int_timer_sbfl  flow_types_pkg.t_subflow_context;
    l_parent_tag              varchar2(50);
  begin
    apex_debug.enter 
    ( 'set_boundary_timers'
    , 'subflow', p_subflow_id
    );
    begin
      for boundary_timers in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_interrupting as objt_interrupting
             , sbfl.sbfl_process_level as sbfl_process_level
             , sbfl.sbfl_dgrm_id as sbfl_dgrm_id
             , sbfl.sbfl_current as parent_current_object
             , objt.objt_id as objt_id
             , sbfl.sbfl_scope as sbfl_scope
          from flow_objects objt
          join flow_subflows sbfl 
            on sbfl.sbfl_current = objt.objt_attached_to
           and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event  
           and objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
           and sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        )
      loop
        case boundary_timers.objt_interrupting
        when 1 then
          -- process any before-event variable expressions on the starting object
          flow_expressions.process_expressions
          ( pi_objt_id     => boundary_timers.objt_id 
          , pi_set         => flow_constants_pkg.gc_expr_set_before_event
          , pi_prcs_id     => p_process_id
          , pi_sbfl_id     => p_subflow_id
          , pi_var_scope   => boundary_timers.sbfl_scope
          , pi_expr_scope  => boundary_timers.sbfl_scope
          );
          -- test for any step errors
          if not flow_globals.get_step_error then 
            -- interupting timer.  set timer on current object in current subflow
            flow_timers_pkg.start_timer
            ( pi_prcs_id => p_process_id
            , pi_sbfl_id => p_subflow_id
            );
            l_parent_tag := ':SIT';  -- (Self, Interrupting, Timer)
          end if;
        when 0 then
          -- non-interupting timer.  create child subflow starting at boundary event and start timer
          l_new_non_int_timer_sbfl := flow_engine_util.subflow_start
          ( p_process_id => p_process_id
          , p_parent_subflow => p_subflow_id
          , p_starting_object => boundary_timers.objt_bpmn_id
          , p_current_object => boundary_timers.objt_bpmn_id
          , p_route => 'from boundary event - run 1'
          , p_last_completed => boundary_timers.parent_current_object 
          , p_status => flow_constants_pkg.gc_sbfl_status_waiting_timer
          , p_parent_sbfl_proc_level => boundary_timers.sbfl_process_level
          , p_new_proc_level => false
          , p_dgrm_id => boundary_timers.sbfl_dgrm_id
          );
 
          -- process any before-event variable expressions on the starting object
          flow_expressions.process_expressions
          ( pi_objt_id     => boundary_timers.objt_id
          , pi_set         => flow_constants_pkg.gc_expr_set_before_event
          , pi_prcs_id     => p_process_id
          , pi_sbfl_id     => l_new_non_int_timer_sbfl.sbfl_id
          , pi_var_scope   => boundary_timers.sbfl_scope
          , pi_expr_scope  => boundary_timers.sbfl_scope
          );
          -- test for any step errors
          if not flow_globals.get_step_error then 
            flow_timers_pkg.start_timer
            ( pi_prcs_id  => p_process_id
            , pi_sbfl_id  => l_new_non_int_timer_sbfl.sbfl_id
            , pi_step_key => l_new_non_int_timer_sbfl.step_key
            );
            -- test again for any step errors
            if not flow_globals.get_step_error then 
              -- set timer flag on child (Self, Noninterrupting, Timer)
              update flow_subflows sbfl
                  set sbfl.sbfl_has_events = sbfl.sbfl_has_events||':SNT'
                where sbfl.sbfl_id = l_new_non_int_timer_sbfl.sbfl_id
                  and sbfl.sbfl_prcs_id = p_process_id
              ;
              l_parent_tag := ':CNT';  -- (Child, Noninterrupting, Timer)
            end if;
          end if;
        end case;
        --- set timer flag on parent (it can get more than 1)
        update flow_subflows sbfl
          set sbfl.sbfl_has_events = sbfl.sbfl_has_events||l_parent_tag
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;
      end loop;
    exception
      when no_data_found then
        return;
    end;
  end set_boundary_timers;

  procedure unset_boundary_timers
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  )
  is 
    l_non_int_timer_sbfl  flow_subflows.sbfl_id%type;
    l_return_code         number;
  begin
    apex_debug.enter 
    ( 'unset_boundary_timers'
    , 'subflow', p_subflow_id
    );
    begin
      for boundary_timers in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_interrupting as objt_interrupting
          from flow_objects objt
          join flow_subflows sbfl 
            on sbfl.sbfl_current = objt.objt_attached_to
           and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event  
           and objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
           and sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        )
      loop
        case boundary_timers.objt_interrupting
        when 1 then
          -- interupting timer.  terminate timer on current object in current subflow
          flow_timers_pkg.terminate_timer
          ( pi_prcs_id => p_process_id
          , pi_sbfl_id => p_subflow_id
          , po_return_code => l_return_code
          );
        when 0 then
          -- non-interupting timer.  find child subflow starting at boundary event and delete if not yet fired
          -- timer will delete cascade
          delete from flow_subflows
          where sbfl_starting_object = boundary_timers.objt_bpmn_id
          and sbfl_sbfl_id = p_subflow_id
          and sbfl_prcs_id = p_process_id
          and sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
          ;
        end case;
      end loop;
      -- remove the event flags from the subflow
      update flow_subflows sbfl
         set sbfl_has_events = ''
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    exception
      when no_data_found then
        return;
    end;
  end unset_boundary_timers;

  procedure lock_child_boundary_timers
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_parent_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  ) 
  is 
    cursor c is 
        select child_sbfl.sbfl_id, child_timr.timr_id
          from flow_subflows child_sbfl
          join flow_timers child_timr
            on child_timr.timr_prcs_id = child_sbfl.sbfl_prcs_id
           and child_timr.timr_sbfl_id = child_sbfl.sbfl_id
         where child_sbfl.sbfl_starting_object = p_parent_objt_bpmn_id 
           and child_sbfl.sbfl_current = p_parent_objt_bpmn_id 
           and child_sbfl.sbfl_prcs_id = p_process_id
           and child_sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
         order by child_sbfl.sbfl_id
        for update of child_sbfl.sbfl_id, child_timr.timr_id wait 3;
  begin 
    open c;
    close c;
  exception 
    when lock_timeout then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_sbfl_id     => p_subflow_id
      , pi_message_key => 'boundary-event-child-lock-to'
      , p0             => p_subflow_id
      );
      -- $F4AMESSAGE 'boundary-event-child-lock-to' || 'Child Boundary Subflows or Timers of %0 currently locked by another user.  Retry your transaction later.'  
  end lock_child_boundary_timers; 

  procedure handle_interrupting_timer
    ( p_process_id in flow_processes.prcs_id%type
    , p_subflow_id in flow_subflows.sbfl_id%type
    ) 
      -- used for InterruptingTimer events, called by flow_engine.flow_handle_event
  is
    l_boundary_objt_bpmn_id  flow_objects.objt_bpmn_id%type;
    l_parent_objt_tag        flow_objects.objt_tag_name%type;
    l_parent_objt_bpmn_id    flow_objects.objt_bpmn_id%type;
    l_child_process_level    flow_subflows.sbfl_process_level%type; 
    l_step_key               flow_subflows.sbfl_step_key%type;
    l_timestamp              flow_subflows.sbfl_became_current%type;
    l_scope                  flow_subflows.sbfl_scope%type;
  begin
    apex_debug.enter 
    ( 'handle_interrupting_timer'
    , 'subflow', p_subflow_id
    );
    select boundary_objt.objt_bpmn_id
         , main_objt.objt_tag_name
         , main_objt.objt_bpmn_id
         , sbfl.sbfl_scope
      into l_boundary_objt_bpmn_id
         , l_parent_objt_tag
         , l_parent_objt_bpmn_id
         , l_scope
      from flow_subflows sbfl
      join flow_objects main_objt
        on main_objt.objt_bpmn_id = sbfl.sbfl_current
       and main_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
      join flow_objects boundary_objt
        on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
       and boundary_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
       and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
       and boundary_objt.objt_interrupting = 1
        ;
    if l_parent_objt_tag in ( flow_constants_pkg.gc_bpmn_subprocess
                            , flow_constants_pkg.gc_bpmn_call_activity )
    then
       -- if the boundary event is on a subprocess or call activity (rather than a task type), terminate the subprocess level
       -- find the process level inside the subprocess and then stop all processing at that level and below
      select distinct sbfl.sbfl_process_level
        into l_child_process_level
        from flow_subflows sbfl
       where sbfl.sbfl_sbfl_id = p_subflow_id
       ;
       if l_child_process_level is not null 
       then 
          flow_engine_util.terminate_level
          ( p_process_id    => p_process_id
          , p_process_level => l_child_process_level
          );
       end if;
    end if;
    -- clean up any other boundary timers on the object
    flow_boundary_events.unset_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );
    -- generate a step key & insert in the update...use later
    l_timestamp := systimestamp;
    l_step_key := flow_engine_util.step_key ( pi_sbfl_id   => p_subflow_id
                                            , pi_current => l_boundary_objt_bpmn_id
                                            , pi_became_current => l_timestamp 
                                            );
    -- switch processing onto boundaryEvent path and do next step
    update flow_subflows sbfl
       set sbfl.sbfl_current = l_boundary_objt_bpmn_id
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
         , sbfl.sbfl_last_completed = l_parent_objt_bpmn_id
         , sbfl.sbfl_became_current = l_timestamp
         , sbfl.sbfl_step_key = l_step_key
         , sbfl.sbfl_last_update = l_timestamp 
     where sbfl.sbfl_id = p_subflow_id 
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- process on-event variable expressions for the boundary event
    flow_expressions.process_expressions
    ( pi_objt_bpmn_id => l_boundary_objt_bpmn_id  
    , pi_set          => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id      => p_process_id
    , pi_sbfl_id      => p_subflow_id
    , pi_var_scope    => l_scope
    , pi_expr_scope   => l_scope
    );
    -- test for errors
    if flow_globals.get_step_error then 
      -- has step errors from expressions - set error status
      flow_errors.set_error_status
      ( pi_prcs_id => p_process_id
      , pi_sbfl_id => p_subflow_id
      );
    else
      -- If not, step off on new path...
      flow_engine.flow_complete_step 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id 
      , p_step_key => l_step_key
      );
    end if;

  end handle_interrupting_timer;

  procedure get_boundary_event
  ( pi_dgrm_id                  in  flow_diagrams.dgrm_id%type
  , pi_throw_objt_bpmn_id       in  flow_objects.objt_bpmn_id%type
  , pi_par_sbfl                 in  flow_subflows.sbfl_id%type
  , pi_sub_tag_name             in  flow_objects.objt_sub_tag_name%type 
  , po_boundary_objt            out flow_objects.objt_bpmn_id%type
  , po_is_interrupting          out boolean
  , po_par_sbfl_scope           out flow_subflows.sbfl_scope%type
  )
  is 
    l_process_id    flow_processes.prcs_id%type;
      l_interrupting  flow_objects.objt_interrupting%type;
  begin
    -- in later release if named errors and escalations are supported, change this to look for specific event
    select boundary_objt.objt_bpmn_id
         , boundary_objt.objt_interrupting
         , parent_sbfl.sbfl_prcs_id
         , parent_sbfl.sbfl_scope
      into po_boundary_objt
         , l_interrupting
         , l_process_id
         , po_par_sbfl_scope
      from flow_objects boundary_objt
      join flow_subflows parent_sbfl
        on parent_sbfl.sbfl_current = boundary_objt.objt_attached_to
       and parent_sbfl.sbfl_dgrm_id = boundary_objt.objt_dgrm_id
     where parent_sbfl.sbfl_id = pi_par_sbfl
       and boundary_objt.objt_sub_tag_name = pi_sub_tag_name
    ;
    if l_interrupting = 1 then
      po_is_interrupting := true;
    else
      po_is_interrupting := false;
    end if;
  exception
    when no_data_found then
        -- no boundary event found -- returned flow should continue from normal return
        if pi_sub_tag_name in (flow_constants_pkg.gc_bpmn_error_event_definition) then
           po_is_interrupting := true;
        else 
           po_is_interrupting := false;
        end if;
    when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => l_process_id
        , pi_sbfl_id     => pi_par_sbfl
        , pi_message_key => 'boundary-event-too-many'
        , p0 => pi_sub_tag_name
        );
        -- $F4AMESSAGE 'boundary-event-too-many' || 'More than one %0 boundaryEvent found on sub process.'  
  end get_boundary_event;

  procedure process_escalation
    ( pi_sbfl_info        in  flow_subflows%rowtype
    , pi_step_info        in  flow_types_pkg.flow_step_info
    , pi_par_sbfl         in  flow_subflows.sbfl_id%type
    , pi_source_type      in  flow_types_pkg.t_bpmn_id
    , po_step_key         out flow_subflows.sbfl_step_key%type
    , po_is_interrupting  out boolean
    )
  is 
    l_boundary_event        flow_objects.objt_bpmn_id%type;
    l_interrupting          flow_objects.objt_interrupting%type;
    l_new_sbfl              flow_types_pkg.t_subflow_context;
    l_parent_processs_level flow_subflows.sbfl_process_level%type;
    l_parent_sbfl_scope     flow_subflows.sbfl_scope%type;
    l_parent_dgrm_id        flow_diagrams.dgrm_id%type;
    l_parent_step_key       flow_subflows.sbfl_step_key%type;
    l_timestamp             flow_subflows.sbfl_became_current%type;
    l_step_key              flow_subflows.sbfl_step_key%type;
  begin 
    apex_debug.enter 
    ( 'process_escalation'
    , 'subflow', pi_sbfl_info.sbfl_id
    );
    -- called to process an escallation from an Escalation ITE or an Escalation End Event
    -- both can be Interrupting or Non interrupting
    --
    -- set the throwing event to completed
/*    flow_logging.log_step_completion   
    ( p_process_id => pi_sbfl_info.sbfl_prcs_id
    , p_subflow_id => pi_sbfl_info.sbfl_id
    , p_completed_object => pi_step_info.target_objt_ref
    );  */
    -- find matching boundary event of its type
    get_boundary_event
    ( pi_dgrm_id            => pi_step_info.dgrm_id
    , pi_throw_objt_bpmn_id => pi_step_info.target_objt_ref
    , pi_par_sbfl           => pi_par_sbfl
    , pi_sub_tag_name       => pi_step_info.target_objt_subtag
    , po_boundary_objt      => l_boundary_event
    , po_is_interrupting    => po_is_interrupting
    , po_par_sbfl_scope     => l_parent_sbfl_scope
    );
    if l_boundary_event is null then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id     => pi_sbfl_info.sbfl_id
      , pi_message_key => 'boundary-event-no-catch-found'
      , p0 => pi_step_info.target_objt_subtag
      );
      -- $F4AMESSAGE 'boundary-event-no-catch-found' || 'No boundaryEvent of type %0 found to catch event.'  
    end if;

    if po_is_interrupting then
      -- interrupting escalation event
      if pi_source_type = flow_constants_pkg.gc_bpmn_intermediate_throw_event then 
        -- set the throwing event to completed if an ITE
        flow_logging.log_step_completion   
        ( p_process_id => pi_sbfl_info.sbfl_prcs_id
        , p_subflow_id => pi_sbfl_info.sbfl_id
        , p_completed_object => pi_step_info.target_objt_ref
        );  
      end if;
      -- first remove any non-interrupting timers that are on the parent event
      unset_boundary_timers (pi_sbfl_info.sbfl_prcs_id, pi_par_sbfl);
      -- stop processing in process level and all lower (child) levels
      flow_engine_util.terminate_level
      ( p_process_id => pi_sbfl_info.sbfl_prcs_id
      , p_process_level => pi_sbfl_info.sbfl_process_level
      );        
      -- generate a step key & insert in the update...use later
      l_timestamp := systimestamp;
      l_step_key := flow_engine_util.step_key ( pi_sbfl_id   => pi_par_sbfl --p_sbfl_info.sbfl_id
                                              , pi_current => l_boundary_event
                                              , pi_became_current => l_timestamp 
                                              );                       
      -- set parent subflow to boundary event and do flow_complete_step
      update flow_subflows sbfl
          set sbfl.sbfl_current = l_boundary_event
            , sbfl.sbfl_last_completed = pi_step_info.target_objt_ref 
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
            , sbfl.sbfl_became_current = l_timestamp
            , sbfl.sbfl_step_key = l_step_key
            , sbfl_last_update = l_timestamp
        where sbfl.sbfl_id = pi_par_sbfl
          and sbfl.sbfl_prcs_id = pi_sbfl_info.sbfl_prcs_id
      ;
      -- process on-event expressions for boundary event
      flow_expressions.process_expressions
      ( pi_objt_bpmn_id => l_boundary_event  
      , pi_set          => flow_constants_pkg.gc_expr_set_on_event
      , pi_prcs_id      => pi_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id      => pi_par_sbfl
      , pi_var_scope    => l_parent_sbfl_scope
      , pi_expr_scope   => l_parent_sbfl_scope
      );

        flow_engine.flow_complete_step
        ( p_process_id => pi_sbfl_info.sbfl_prcs_id
        , p_subflow_id => pi_par_sbfl
        , p_step_key   => l_step_key
        ); 

    else  --( = not po_is_interrupting)
      -- non interrupting.  
      select par_sbfl.sbfl_process_level
           , par_sbfl.sbfl_dgrm_id
        into l_parent_processs_level 
           , l_parent_dgrm_id
        from flow_subflows par_sbfl
        where par_sbfl.sbfl_id = pi_par_sbfl
          and par_sbfl.sbfl_prcs_id = pi_sbfl_info.sbfl_prcs_id
          ;

      -- fork first, then procced on main, then step off on child

      -- start new subflow starting at the boundary event and step to next task
      l_new_sbfl := flow_engine_util.subflow_start
      ( p_process_id => pi_sbfl_info.sbfl_prcs_id
      , p_parent_subflow => pi_par_sbfl
      , p_starting_object => l_boundary_event
      , p_current_object => l_boundary_event
      , p_route => 'from '||l_boundary_event
      , p_last_completed => pi_step_info.target_objt_ref -- even thou it hasnt yet completed 
      , p_status => flow_constants_pkg.gc_sbfl_status_running
      , p_parent_sbfl_proc_level => l_parent_processs_level
      , p_new_proc_level => false
      , p_dgrm_id => l_parent_dgrm_id
      );
      
      apex_debug.message
      (
        p_message => 'process_boundary_event.  target_objt_tag :'||pi_step_info.target_objt_subtag
      , p_level => 3
      );
      -- process on-event expressions for boundary event
      flow_expressions.process_expressions
      ( pi_objt_bpmn_id => l_boundary_event  
      , pi_set          => flow_constants_pkg.gc_expr_set_on_event
      , pi_prcs_id      => pi_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id      => l_new_sbfl.sbfl_id
      , pi_var_scope    => l_parent_sbfl_scope
      , pi_expr_scope   => l_parent_sbfl_scope
      );     

      if not flow_globals.get_step_error then


        if pi_source_type = flow_constants_pkg.gc_bpmn_intermediate_throw_event  
        then 
            -- do next_step on triggering subflow if an ITE 
            flow_engine.flow_complete_step 
            ( p_process_id => pi_sbfl_info.sbfl_prcs_id
            , p_subflow_id => pi_sbfl_info.sbfl_id 
            , p_step_key   => pi_sbfl_info.sbfl_step_key
            );
        elsif pi_source_type = flow_constants_pkg.gc_bpmn_end_event  
        then
            -- normal end event
            flow_engine_util.subflow_complete
            ( p_process_id => pi_sbfl_info.sbfl_prcs_id
            , p_subflow_id => pi_sbfl_info.sbfl_id
            );
        end if;

        -- step forward from boundary event
        flow_engine.flow_complete_step 
        ( p_process_id => pi_sbfl_info.sbfl_prcs_id
        , p_subflow_id => l_new_sbfl.sbfl_id
        , p_step_key   => l_new_sbfl.step_key
        );
      else
        -- set error status on instance and subflow
        flow_errors.set_error_status
        ( pi_prcs_id => pi_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id => pi_sbfl_info.sbfl_id
        );
      end if;
    end if;
  end process_escalation;


end flow_boundary_events;
/

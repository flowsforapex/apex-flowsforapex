create or replace package body flow_boundary_events
is 

/* -- Flows for APEX - flow_boundary_events.pkb
--
-- (c) Copyright Flowquest Ltd and / or its affiliates, 2021-2025
--
-- Created  22-Feb-2021   Richard Allen - 
-- Modified 15-Jun-2022   Moritz Klein (MT AG)
-- Modified 02-Apr-2025   Richard Allen (Flowquest)
*/


  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  procedure set_boundary_events
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  )
  is 
    l_new_non_int_event_sbfl      flow_types_pkg.t_subflow_context;
    l_new_non_int_event_sbfl_info flow_subflows%rowtype;
    l_subscription_detail         flow_message_flow.t_subscription_details;
    l_status                      flow_subflows.sbfl_status%type;
    l_parent_tag                  varchar2(50);
    l_child_tag                   varchar2(50);
    l_msg_sub                     flow_message_subscriptions.msub_id%type;
  begin
    apex_debug.enter 
    ( 'set_boundary_events'
    , 'subflow', p_subflow_id
    );
    begin
      for boundary_events in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_sub_tag_name as objt_sub_tag_name
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
           and objt.objt_sub_tag_name in ( flow_constants_pkg.gc_bpmn_timer_event_definition
                                         , flow_constants_pkg.gc_bpmn_message_event_definition )
           and sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        )
      loop
        apex_debug.message 
        ( p_message => 'Boundary Event found.  ID: %0 SubTag:  %1  Interupting: %2'
        , p0 => boundary_events.objt_bpmn_id
        , p1 => boundary_events.objt_sub_tag_name
        , p2 => boundary_events.objt_interrupting
        );
        case boundary_events.objt_interrupting
        when 1 then
          -- process any before-event variable expressions on the starting object
          flow_expressions.process_expressions
          ( pi_objt_id     => boundary_events.objt_id 
          , pi_set         => flow_constants_pkg.gc_expr_set_before_event
          , pi_prcs_id     => p_process_id
          , pi_sbfl_id     => p_subflow_id
          , pi_step_key    => null
          , pi_var_scope   => boundary_events.sbfl_scope
          , pi_expr_scope  => boundary_events.sbfl_scope
          );
          -- test for any step errors
          if not flow_globals.get_step_error then 
            case boundary_events.objt_sub_tag_name
            when flow_constants_pkg.gc_bpmn_timer_event_definition then
              -- interupting timer.  set timer on current object in current subflow
              flow_timers_pkg.start_timer
              ( pi_prcs_id      => p_process_id
              , pi_sbfl_id      => p_subflow_id
              , pi_callback     => flow_constants_pkg.gc_bpmn_boundary_event
              , pi_callback_par => 'interrupting'
              );
              l_parent_tag := ':SIT';  -- (Self, Interrupting, Timer)
            when flow_constants_pkg.gc_bpmn_message_event_definition then
              -- interupting message.  set message subscription on current object in current subflow
              l_subscription_detail := flow_message_util.get_msg_subscription_details ( p_msg_object_bpmn_id  => boundary_events.objt_bpmn_id
                                                                                      , p_dgrm_id  => boundary_events.sbfl_dgrm_id
                                                                                      , p_sbfl_info  => p_sbfl_info
                                                                                      );
              l_subscription_detail.callback     := flow_constants_pkg.gc_bpmn_boundary_event;
              l_subscription_detail.callback_par := boundary_events.objt_bpmn_id;
              l_msg_sub := flow_message_flow.subscribe ( p_subscription_details  => l_subscription_detail);
  
              l_parent_tag := ':SIM';  -- (Self, Interrupting, Message)
            end case;
          end if;
        when 0 then
            case boundary_events.objt_sub_tag_name
            when flow_constants_pkg.gc_bpmn_timer_event_definition   then 
              l_status      := flow_constants_pkg.gc_sbfl_status_waiting_timer;
              l_child_tag   := ':SNT';  -- (Self, Non-Interrupting, Timer)
              l_parent_tag  := ':CNT';  -- (Child, Non-Interrupting, Timer)
            when flow_constants_pkg.gc_bpmn_message_event_definition then 
              l_status := flow_constants_pkg.gc_sbfl_status_waiting_message;
              l_child_tag   := ':SNM';  -- (Self, Non-Interrupting, Message)  
              l_parent_tag  := ':CNM';  -- (Child, Non-U=Interrupting, Message)            
            end case;

          -- non-interupting event.  create child subflow starting at boundary event and start timer/subscribe message / etc
          l_new_non_int_event_sbfl := flow_engine_util.subflow_start
          ( p_process_id => p_process_id
          , p_parent_subflow => p_subflow_id
          , p_starting_object => boundary_events.objt_bpmn_id
          , p_current_object => boundary_events.objt_bpmn_id
          , p_route => 'from boundary event - run 1'
          , p_last_completed => boundary_events.parent_current_object 
          , p_status => l_status
          , p_parent_sbfl_proc_level => boundary_events.sbfl_process_level
          , p_new_proc_level => false
          , p_dgrm_id => boundary_events.sbfl_dgrm_id
          );
 
          -- process any before-event variable expressions on the starting object
          flow_expressions.process_expressions
          ( pi_objt_id     => boundary_events.objt_id
          , pi_set         => flow_constants_pkg.gc_expr_set_before_event
          , pi_prcs_id     => p_process_id
          , pi_sbfl_id     => l_new_non_int_event_sbfl.sbfl_id
          , pi_step_key    => l_new_non_int_event_sbfl.step_key
          , pi_var_scope   => boundary_events.sbfl_scope
          , pi_expr_scope  => boundary_events.sbfl_scope
          );
          -- test for any step errors
          if not flow_globals.get_step_error then 
            case boundary_events.objt_sub_tag_name
            when flow_constants_pkg.gc_bpmn_timer_event_definition then
              -- non-interrupting timer - start timer on event subflow
              flow_timers_pkg.start_timer
              ( pi_prcs_id      => p_process_id
              , pi_sbfl_id      => l_new_non_int_event_sbfl.sbfl_id
              , pi_step_key     => l_new_non_int_event_sbfl.step_key
              , pi_callback     => flow_constants_pkg.gc_bpmn_boundary_event
              , pi_callback_par => 'non-interrupting'                -----  RA NOTE  move to constants_pkg
              );
            when flow_constants_pkg.gc_bpmn_message_event_definition then
              -- non-interupting message.  set message subscription on event subflow
              select *
                into l_new_non_int_event_sbfl_info
                from flow_subflows
               where sbfl_id = l_new_non_int_event_sbfl.sbfl_id;

              l_subscription_detail := flow_message_util.get_msg_subscription_details ( p_msg_object_bpmn_id  => boundary_events.objt_bpmn_id
                                                                                      , p_dgrm_id             => boundary_events.sbfl_dgrm_id
                                                                                      , p_sbfl_info           => l_new_non_int_event_sbfl_info
                                                                                      );  
              l_subscription_detail.callback      := flow_constants_pkg.gc_bpmn_boundary_event;
              l_subscription_detail.callback_par  := boundary_events.objt_bpmn_id;
              l_msg_sub := flow_message_flow.subscribe(p_subscription_details  => l_subscription_detail);
            end case;

            -- test again for any step errors
            if not flow_globals.get_step_error then 
              -- set timer flag on child (Self, Noninterrupting, Timer)
              update flow_subflows sbfl
                  set sbfl.sbfl_has_events      = sbfl.sbfl_has_events||l_child_tag
                    , sbfl.sbfl_last_update     = systimestamp
                    , sbfl.sbfl_last_update_by  = coalesce ( sys_context('apex$session','app_user') 
                                                           , sys_context('userenv','os_user')
                                                           , sys_context('userenv','session_user')
                                                           )  
                where sbfl.sbfl_id = l_new_non_int_event_sbfl.sbfl_id
                  and sbfl.sbfl_prcs_id = p_process_id
              ;
            end if;
          end if;
        end case;
        --- set timer flag on parent (it can get more than 1)
        update flow_subflows sbfl
          set sbfl.sbfl_has_events      = sbfl.sbfl_has_events||l_parent_tag
            , sbfl.sbfl_last_update     = systimestamp
            , sbfl.sbfl_last_update_by  = coalesce ( sys_context('apex$session','app_user') 
                                                   , sys_context('userenv','os_user')
                                                   , sys_context('userenv','session_user')
                                                   )  
        where sbfl.sbfl_id      = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;
      end loop;
    exception
      when no_data_found then
        return;
    end;
  end set_boundary_events;

  procedure unset_boundary_events
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  )
  is 
    l_non_int_timer_sbfl  flow_subflows.sbfl_id%type;
    l_return_code         number;
  begin
    apex_debug.enter 
    ( 'unset_boundary_events'
    , 'subflow', p_subflow_id
    );
    begin
      for boundary_events in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_interrupting as objt_interrupting
          from flow_objects objt
          join flow_subflows sbfl 
            on sbfl.sbfl_current = objt.objt_attached_to
           and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event  
           and objt.objt_sub_tag_name in ( flow_constants_pkg.gc_bpmn_timer_event_definition
                                         , flow_constants_pkg.gc_bpmn_message_event_definition )
           and sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        )
      loop
        case boundary_events.objt_interrupting
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
          where sbfl_starting_object = boundary_events.objt_bpmn_id
          and sbfl_sbfl_id = p_subflow_id
          and sbfl_prcs_id = p_process_id
          and sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
          ;
        end case;
      end loop;
      -- remove the event flags from the subflow
      update flow_subflows sbfl
         set sbfl_has_events      = ''
           , sbfl_last_update     = systimestamp
           , sbfl_last_update_by  = coalesce ( sys_context('apex$session','app_user') 
                                             , sys_context('userenv','os_user')
                                             , sys_context('userenv','session_user')
                                             )  
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    exception
      when no_data_found then
        return;
    end;
  end unset_boundary_events;

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

  procedure handle_interrupting_boundary_event
    ( p_process_id      in flow_processes.prcs_id%type
    , p_subflow_id      in flow_subflows.sbfl_id%type
    , p_event_type      in flow_objects.objt_sub_tag_name%type
    , p_boundary_object in flow_objects.objt_bpmn_id%type default null
    ) 
      -- used for Interrupting Timer   Boundary events, called by flow_engine.timer_callback
      -- used for Interrupting Message Boundary events, called by flow_message_flow.receive_message
  is
    l_boundary_objt_bpmn_id  flow_objects.objt_bpmn_id%type;
    l_parent_objt_tag        flow_objects.objt_tag_name%type;
    l_parent_objt_bpmn_id    flow_objects.objt_bpmn_id%type;
    l_child_process_level    flow_subflows.sbfl_process_level%type; 
    l_step_key               flow_subflows.sbfl_step_key%type;
    l_timestamp              flow_subflows.sbfl_became_current%type;
    l_scope                  flow_subflows.sbfl_scope%type;
    l_sbfl_rec               flow_subflows%rowtype;
    l_apex_business_admin    flow_subflows.sbfl_apex_business_admin%type;
    l_apex_task_id           flow_subflows.sbfl_apex_task_id%type;
  begin
    apex_debug.enter 
    ( 'handle_interrupting_boundary_event'
    , 'subflow', p_subflow_id
    , 'event type', p_event_type
    , 'boundary object',p_boundary_object
    );
    -- we are migrating boundary event callback structure over next few releases but will handle old and new way
    -- result will be to allow multiple boundary events of the same type on an object
    if p_boundary_object is null or p_boundary_object in ('interrupting', 'non-interrupting') then 
      -- old style - should be only one event of type on parent
      select boundary_objt.objt_bpmn_id
           , main_objt.objt_tag_name
           , main_objt.objt_bpmn_id
           , sbfl.sbfl_scope
           , sbfl.sbfl_apex_business_admin
           , sbfl.sbfl_apex_task_id
        into l_boundary_objt_bpmn_id
           , l_parent_objt_tag
           , l_parent_objt_bpmn_id
           , l_scope
           , l_apex_business_admin
           , l_apex_task_id
        from flow_subflows sbfl
        join flow_objects main_objt
          on main_objt.objt_bpmn_id = sbfl.sbfl_current
         and main_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
        join flow_objects boundary_objt
          on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
         and boundary_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         and boundary_objt.objt_sub_tag_name = p_event_type
         and boundary_objt.objt_interrupting = 1
          ;
    else
      -- newstyle - event callback contained a bpmn id of the object to callback
      select boundary_objt.objt_bpmn_id
           , main_objt.objt_tag_name
           , main_objt.objt_bpmn_id
           , sbfl.sbfl_scope
           , sbfl.sbfl_apex_business_admin
           , sbfl.sbfl_apex_task_id
        into l_boundary_objt_bpmn_id
           , l_parent_objt_tag
           , l_parent_objt_bpmn_id
           , l_scope
           , l_apex_business_admin
           , l_apex_task_id
        from flow_subflows sbfl
        join flow_objects main_objt
          on main_objt.objt_bpmn_id = sbfl.sbfl_current
         and main_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
        join flow_objects boundary_objt
          on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
         and boundary_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
         and boundary_objt.objt_bpmn_id = p_boundary_object
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         and boundary_objt.objt_sub_tag_name = p_event_type
         and boundary_objt.objt_interrupting = 1
          ;
    end if;

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
    -- clean up any other boundary events on the object
    flow_boundary_events.unset_boundary_events 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );
    -- clean up any subscriptions for message events on the object
    flow_message_util.cancel_subscription
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );
    -- log the step interruption on the interupted object
    flow_logging.log_step_event
    ( p_process_id       => p_process_id
    , p_subflow_id       => p_subflow_id
    , p_event            => flow_constants_pkg.gc_step_event_interrupted
    , p_event_level      => flow_constants_pkg.gc_logging_level_routine
    , p_comment          => 'Interrupted by Boundary Event '||l_boundary_objt_bpmn_id
    );
    -- clean up any APEX Human Tasks started for the interrupted object
    if ( l_parent_objt_tag = flow_constants_pkg.gc_bpmn_usertask 
       and  l_apex_task_id is not null ) then
      flow_usertask_pkg.cancel_apex_task
      ( p_process_id            => p_process_id
      , p_subflow_id            => p_subflow_id
      , p_objt_bpmn_id          => l_parent_objt_bpmn_id
      , p_apex_task_id          => l_apex_task_id
      , p_apex_business_admin   => l_apex_business_admin
      );
    end if;
    -- generate a step key & insert in the update...use later
    l_timestamp := systimestamp;
    l_step_key := flow_engine_util.step_key ( pi_sbfl_id   => p_subflow_id
                                            , pi_current => l_boundary_objt_bpmn_id
                                            , pi_became_current => l_timestamp 
                                            );
    -- switch processing onto boundaryEvent path and do next step
    update flow_subflows sbfl
       set sbfl.sbfl_current        = l_boundary_objt_bpmn_id
         , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
         , sbfl.sbfl_apex_task_id   = null
         , sbfl.sbfl_apex_business_admin = null
         , sbfl.sbfl_last_completed = l_parent_objt_bpmn_id
         , sbfl.sbfl_became_current = l_timestamp
         , sbfl.sbfl_step_key       = l_step_key
         , sbfl.sbfl_last_update    = l_timestamp 
         , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                               , sys_context('userenv','os_user')
                                               , sys_context('userenv','session_user')
                                               )  
     where sbfl.sbfl_id = p_subflow_id 
       and sbfl.sbfl_prcs_id = p_process_id
    ;
 
    -- process on-event variable expressions for the boundary event
    flow_expressions.process_expressions
    ( pi_objt_bpmn_id => l_boundary_objt_bpmn_id  
    , pi_set          => flow_constants_pkg.gc_expr_set_on_event
    , pi_prcs_id      => p_process_id
    , pi_sbfl_id      => p_subflow_id
    , pi_step_key     => l_step_key
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

  end handle_interrupting_boundary_event;

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
      unset_boundary_events (pi_sbfl_info.sbfl_prcs_id, pi_par_sbfl);
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
          set sbfl.sbfl_current         = l_boundary_event
            , sbfl.sbfl_last_completed  = pi_step_info.target_objt_ref 
            , sbfl.sbfl_status          = flow_constants_pkg.gc_sbfl_status_running
            , sbfl.sbfl_became_current  = l_timestamp
            , sbfl.sbfl_step_key        = l_step_key
            , sbfl.sbfl_last_update     = l_timestamp
            , sbfl.sbfl_last_update_by  = coalesce ( sys_context('apex$session','app_user') 
                                                   , sys_context('userenv','os_user')
                                                   , sys_context('userenv','session_user')
                                                   )  
        where sbfl.sbfl_id = pi_par_sbfl
          and sbfl.sbfl_prcs_id = pi_sbfl_info.sbfl_prcs_id
      ;
      -- process on-event expressions for boundary event
      flow_expressions.process_expressions
      ( pi_objt_bpmn_id => l_boundary_event  
      , pi_set          => flow_constants_pkg.gc_expr_set_on_event
      , pi_prcs_id      => pi_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id      => pi_par_sbfl
      , pi_step_key     => l_step_key
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
      , pi_step_key     => l_new_sbfl.step_key
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

  procedure handle_task_error_boundary_event
  ( pi_sbfl_info        in  flow_subflows%rowtype
  )
  is
    l_boundary_event_bpmn_id         flow_objects.objt_bpmn_id%type;
    l_boundary_event_is_interrupting boolean;
    l_boundary_event_scope           flow_subflows.sbfl_scope%type;
  begin
    apex_debug.enter  
    ( 'handle_task_error_boundary_event'
    , 'current object: ', pi_sbfl_info.sbfl_current
    );

    get_boundary_event 
    ( pi_dgrm_id            => pi_sbfl_info.sbfl_dgrm_id
    , pi_throw_objt_bpmn_id => pi_sbfl_info.sbfl_current
    , pi_par_sbfl           => pi_sbfl_info.sbfl_id
    , pi_sub_tag_name       => flow_constants_pkg.gc_bpmn_error_event_definition
    , po_boundary_objt      => l_boundary_event_bpmn_id
    , po_is_interrupting    => l_boundary_event_is_interrupting
    , po_par_sbfl_scope     => l_boundary_event_scope
    );
    apex_debug.message
    ( p_message => 'Interrupting Error Boundary Event found: %0'  
    , p0        => l_boundary_event_bpmn_id
    );
    -- handle the error event
    handle_interrupting_boundary_event
    ( p_process_id      => pi_sbfl_info.sbfl_prcs_id
    , p_subflow_id      => pi_sbfl_info.sbfl_id
    , p_event_type      => flow_constants_pkg.gc_bpmn_error_event_definition
    , p_boundary_object => l_boundary_event_bpmn_id
    );
  end handle_task_error_boundary_event;

end flow_boundary_events;
/

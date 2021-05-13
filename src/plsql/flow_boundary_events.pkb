create or replace package body flow_boundary_events
is 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  procedure set_boundary_timers
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  )
  is 
    l_new_non_int_timer_sbfl  flow_subflows.sbfl_id%type;
    l_parent_tag              varchar2(50);
  begin
    begin
      for boundary_timers in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_interrupting as objt_interrupting
             , sbfl.sbfl_process_level as sbfl_process_level
          from flow_objects objt
          join flow_subflows sbfl 
            on sbfl.sbfl_current = objt.objt_attached_to
          join flow_processes prcs 
            on prcs.prcs_id = sbfl.sbfl_prcs_id
           and prcs.prcs_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event  
           and objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
           and sbfl.sbfl_id = p_subflow_id
           and prcs.prcs_id = p_process_id
        )
      loop
        case boundary_timers.objt_interrupting
        when 1 then
          -- interupting timer.  set timer on current object in current subflow
          flow_timers_pkg.start_timer
          ( pi_prcs_id => p_process_id
          , pi_sbfl_id => p_subflow_id
          );
          l_parent_tag := ':SIT';  -- (Self, Interrupting, Timer)
        when 0 then
          -- non-interupting timer.  create child subflow starting at boundary event and start timer
          l_new_non_int_timer_sbfl := flow_engine_util.subflow_start
          ( p_process_id => p_process_id
          , p_parent_subflow => p_subflow_id
          , p_starting_object => boundary_timers.objt_bpmn_id
          , p_current_object => boundary_timers.objt_bpmn_id
          , p_route => 'boundary_timer'
          , p_last_completed => null 
          , p_status => flow_constants_pkg.gc_sbfl_status_waiting_timer
          , p_parent_sbfl_proc_level => boundary_timers.sbfl_process_level
          , p_new_proc_level => false
          );

          flow_timers_pkg.start_timer
          ( pi_prcs_id => p_process_id
          , pi_sbfl_id => l_new_non_int_timer_sbfl
          );
          -- set timer flag on child (Self, Noninterrupting, Timer)
          update flow_subflows sbfl
              set sbfl.sbfl_has_events = sbfl.sbfl_has_events||':SNT'
            where sbfl.sbfl_id = l_new_non_int_timer_sbfl
              and sbfl.sbfl_prcs_id = p_process_id
          ;
          l_parent_tag := ':CNT';  -- (Child, Noninterrupting, Timer)
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
    begin
      for boundary_timers in 
        (
        select objt.objt_bpmn_id as objt_bpmn_id 
             , objt.objt_interrupting as objt_interrupting
          from flow_objects objt
          join flow_subflows sbfl 
            on sbfl.sbfl_current = objt.objt_attached_to
          join flow_processes prcs 
            on prcs.prcs_id = sbfl.sbfl_prcs_id
           and prcs.prcs_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_boundary_event  
           and objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
           and sbfl.sbfl_id = p_subflow_id
           and prcs.prcs_id = p_process_id
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
    exception
      when no_data_found then
        return;
    end;
  end unset_boundary_timers;

  procedure lock_child_boundary_timer_subflows
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_parent_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  ) 
  is 
    cursor c is 
        select child_sbfl.sbfl_id
          from flow_subflows child_sbfl
         where child_sbfl.sbfl_starting_object = p_parent_objt_bpmn_id 
           and child_sbfl.sbfl_current = p_parent_objt_bpmn_id 
           and sbfl_prcs_id = p_process_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_timer
         order by child_sbfl.sbfl_id
        for update of child_sbfl.sbfl_id;
  begin 
    open c;
    close c;
  exception 
    when lock_timeout then
      apex_error.add_error
      ( p_message => 'Child Boundary Subflows of '||p_subflow_id||' currently locked by another user.  Retry your transaction later.'
      , p_display_location => apex_error.c_on_error_page
      );
  end lock_child_boundary_timer_subflows; 

end flow_boundary_events;
/
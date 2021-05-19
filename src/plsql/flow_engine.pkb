create or replace package body flow_engine
as 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

procedure flow_start_process
( p_process_id    in flow_processes.prcs_id%type
)
is
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_objt_bpmn_id          flow_objects.objt_bpmn_id%type;
    l_objt_sub_tag_name     flow_objects.objt_sub_tag_name%type;
    l_main_subflow_id       flow_subflows.sbfl_id%type;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
    cursor c_prcs_lock is 
      select prcs.prcs_id
        from flow_processes prcs
       where prcs.prcs_id = p_process_id
      for update of prcs.prcs_id wait 2;
begin
    l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );
    begin
        -- called from flow_api_pkg.flow_start (only)
        -- get the object to start with
        select objt.objt_bpmn_id
             , objt.objt_sub_tag_name
          into l_objt_bpmn_id
             , l_objt_sub_tag_name
          from flow_objects objt
          join flow_objects parent
            on objt.objt_objt_id = parent.objt_id
         where objt.objt_dgrm_id = l_dgrm_id
           and parent.objt_dgrm_id = l_dgrm_id
           and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event  
           and parent.objt_tag_name = flow_constants_pkg.gc_bpmn_process
        ;
    exception
        when too_many_rows then
            apex_error.add_error
            ( p_message => 'You have multiple starting events defined. Make sure your diagram has only one starting event.'
            , p_display_location => apex_error.c_on_error_page
            );
        when no_data_found then
            apex_error.add_error
            ( p_message => 'No starting event was defined.'
            , p_display_location => apex_error.c_on_error_page
            );
    end;
    -- lock the process
    open c_prcs_lock;
    -- mark process as running
    update flow_processes prcs
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
         , prcs.prcs_last_update = systimestamp
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;    
    -- check if start has a timer?  
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
    then 
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_waiting_timer;
    else
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_running;
    end if;

    l_main_subflow_id := flow_engine_util.subflow_start 
      ( p_process_id => p_process_id
      , p_parent_subflow => null
      , p_starting_object => l_objt_bpmn_id
      , p_current_object => l_objt_bpmn_id
      , p_route => 'main'
      , p_last_completed => null
      , p_status => l_new_subflow_status 
      , p_parent_sbfl_proc_level => 0 
      , p_new_proc_level => false
      );
    -- commit the subflow creation
    commit;
    -- check startEvent sub type for timer or (later releases) other sub types
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
    then 
      -- eventStart must be delayed with the timer 
      flow_timers_pkg.start_timer(
          pi_prcs_id => p_process_id
        , pi_sbfl_id => l_main_subflow_id
      );
    elsif l_objt_sub_tag_name is null
    then
      -- plain startEvent, step into first step
      flow_complete_step  
      ( p_process_id => p_process_id
      , p_subflow_id => l_main_subflow_id
      , p_forward_route => null
      );
    else 
        apex_error.add_error
        ( p_message => 'You have an unsupported starting event type. Only None (standard) Start Event and Timer Start Event are currently supported.'
        , p_display_location => apex_error.c_on_error_page
        );
    end if;
end flow_start_process;

/*procedure flow_set_boundary_timers
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
)
is 
  l_new_non_int_timer_sbfl  flow_subflows.sbfl_id%type;
begin
  begin
    for boundary_timers in (
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
        when 0 then
            -- non-interupting timer.  create child subflow starting at boundary event and start timer
            l_new_non_int_timer_sbfl := flow_engine_util.subflow_start
            ( p_process_id => p_process_id
            , p_parent_subflow => p_subflow_id
            , p_starting_object => boundary_timers.objt_bpmn_id
            , p_current_object => boundary_timers.objt_bpmn_id
            , p_route => 'bounday_timer'
            , p_last_completed => null 
            , p_status => flow_constants_pkg.gc_sbfl_status_waiting_timer
            , p_parent_sbfl_proc_level => boundary_timers.sbfl_process_level
            , p_new_proc_level => false
            );
            flow_timers_pkg.start_timer
            ( pi_prcs_id => p_process_id
            , pi_sbfl_id => l_new_non_int_timer_sbfl
            );
            -- set timer flag on child
            update flow_subflows sbfl
              set sbfl.sbfl_has_events = sbfl.sbfl_has_events||'T'
            where sbfl.sbfl_id = l_new_non_int_timer_sbfl
              and sbfl.sbfl_prcs_id = p_process_id
            ;
        end case;
        --- set timer flag on parent (it can get more than 1)
        update flow_subflows sbfl
           set sbfl.sbfl_has_events = sbfl.sbfl_has_events||'T'
         where sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        ;
    end loop;
  exception
    when no_data_found then
      return;
  end;
end flow_set_boundary_timers;

procedure flow_unset_boundary_timers
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
)
is 
  l_non_int_timer_sbfl  flow_subflows.sbfl_id%type;
  l_return_code         number;
begin
  begin
    for boundary_timers in (
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
end flow_unset_boundary_timers;*/

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
    -- log throw event as complete
   flow_engine_util.log_step_completion   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => p_step_info.target_objt_ref
    );
    -- jump into matching catch event
    update flow_subflows sbfl
    set   sbfl.sbfl_current = l_next_objt
        , sbfl.sbfl_last_completed = p_step_info.target_objt_ref
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

/*procedure flow_get_boundary_event
  ( pi_dgrm_id                  in  flow_diagrams.dgrm_id%type
  , pi_throw_objt_bpmn_id       in  flow_objects.objt_bpmn_id%type
  , pi_par_sbfl                 in  flow_subflows.sbfl_id%type
  , pi_sub_tag_name             in  flow_objects.objt_sub_tag_name%type 
  , po_boundary_objt            out flow_objects.objt_bpmn_id%type
  , po_interrupting             out flow_objects.objt_interrupting%type
  )
is 
begin
    -- in later release if named errors and escalations are supported, change this to look for specific event
    select boundary_objt.objt_bpmn_id
         , boundary_objt.objt_interrupting
      into po_boundary_objt
         , po_interrupting
      from flow_objects boundary_objt
      join flow_subflows parent_sbfl
        on parent_sbfl.sbfl_current = boundary_objt.objt_attached_to
      join flow_processes prcs
        on prcs.prcs_id = parent_sbfl.sbfl_prcs_id
       and prcs.prcs_dgrm_id = boundary_objt.objt_dgrm_id
     where parent_sbfl.sbfl_id = pi_par_sbfl
       and boundary_objt.objt_sub_tag_name = pi_sub_tag_name
       and boundary_objt.objt_dgrm_id = pi_dgrm_id
        ;
exception
  when no_data_found then
      -- no boundary event found -- returned flow should continue from normal return
      po_boundary_objt := null;
      if pi_sub_tag_name in (flow_constants_pkg.gc_bpmn_error_event_definition) then
         po_interrupting := 1;
      else 
         po_interrupting := 0;
      end if;
  when too_many_rows then
      apex_error.add_error
      ( p_message => 'More than one '||pi_sub_tag_name||' boundaryEvent found on sub process.'
      , p_display_location => apex_error.c_on_error_page
      );
end flow_get_boundary_event;


procedure flow_process_boundary_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_info     in flow_types_pkg.flow_step_info
  , p_par_sbfl      in flow_subflows.sbfl_id%type
  )
is 
    l_next_objt             flow_objects.objt_bpmn_id%type;
    l_interrupting          flow_objects.objt_interrupting%type;
    l_new_sbfl              flow_subflows.sbfl_id%type;
    l_parent_processs_level flow_subflows.sbfl_process_level%type;
begin 
    -- set the throwing event to completed
   flow_engine_util.log_step_completion   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => p_step_info.target_objt_ref
    );
    -- find matching boundary event of its type
    flow_get_boundary_event
      ( pi_dgrm_id => p_step_info.dgrm_id
      , pi_throw_objt_bpmn_id => p_step_info.target_objt_ref
      , pi_par_sbfl => p_par_sbfl
      , pi_sub_tag_name => p_step_info.target_objt_subtag
      , po_boundary_objt => l_next_objt
      , po_interrupting => l_interrupting
      );
    If l_next_objt is null then
        apex_error.add_error
            ( p_message => 'No boundaryEvent of type '||p_step_info.target_objt_subtag||' found to catch event.'
            , p_display_location => apex_error.c_on_error_page
            );
    end if;
    if l_interrupting = 1 then
        -- first remove any non-interrupting timers that are on the parent event
        flow_unset_boundary_timers (p_process_id, p_par_sbfl);
        -- stop processing in sub process and all children
        flow_engine_util.flow_terminate_level
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );        
        -- set parent subflow to boundary event and do flow_complete_step
        update flow_subflows sbfl
          set sbfl.sbfl_current = l_next_objt
            , sbfl.sbfl_last_completed = p_step_info.target_objt_ref 
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
          where sbfl.sbfl_id = p_par_sbfl
            and sbfl.sbfl_prcs_id = p_process_id
            ;
        if p_step_info.target_objt_tag = flow_constants_pkg.gc_bpmn_intermediate_throw_event  
        then 
          flow_complete_step
          ( p_process_id => p_process_id
          , p_subflow_id => p_par_sbfl
          ); 
        end if;

    else 
        -- non interrupting.  
        select par_sbfl.sbfl_process_level
          into l_parent_processs_level 
          from flow_subflows par_sbfl
         where par_sbfl.sbfl_id = p_par_sbfl
           and par_sbfl.sbfl_prcs_id = p_process_id
           ;
        -- start new subflow starting at the boundary event and step to next task
        l_new_sbfl := flow_engine_util.subflow_start
        ( p_process_id => p_process_id
        , p_parent_subflow => p_par_sbfl
        , p_starting_object => l_next_objt
        , p_current_object => l_next_objt
        , p_route => 'from '||l_next_objt
        , p_last_completed => null 
        , p_status => flow_constants_pkg.gc_sbfl_status_running
        , p_parent_sbfl_proc_level => l_parent_processs_level
        , p_new_proc_level => false
        );
        flow_complete_step 
        ( p_process_id => p_process_id
        , p_subflow_id => l_new_sbfl
        );
        apex_debug.message(p_message => 'process_boundary_event.  target_objt_tag :'||p_step_info.target_objt_subtag, p_level => 3) ;
    
        if p_step_info.target_objt_tag = flow_constants_pkg.gc_bpmn_intermediate_throw_event  
        then 
            -- do next_step on triggering subflow if an ITE 
            flow_complete_step 
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );
        elsif p_step_info.target_objt_tag = flow_constants_pkg.gc_bpmn_end_event  
        then
            -- normal end event
            flow_engine_util.subflow_complete
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );
        end if;
    end if;
end flow_process_boundary_event;*/

/*
============================================================================================
  B P M N   O B J E C T   P R O C E S S O R S 
============================================================================================
*/

/*procedure process_task
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
is
begin
   apex_debug.message(p_message => 'Begin process_task for object: '||p_step_info.target_objt_tag, p_level => 3) ;
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;

      -- set boundaryEvent Timers, if any
      flow_set_boundary_timers 
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );  
end process_task;*/


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
    --next step can be either end of process or sub-process returning to its parent
    -- get parent subflow
    l_sbfl_id_par := flow_engine_util.get_subprocess_parent_subflow
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_current    => p_sbfl_info.sbfl_current
            );
    -- log the current endEvent as completed
   flow_engine_util.log_step_completion
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_completed_object => p_step_info.target_objt_ref
            );  

    if p_sbfl_info.sbfl_process_level = 0
    then   
        -- in a top level process
        apex_debug.message(p_message => 'Next Step is Process End '||p_step_info.target_objt_ref, p_level => 4) ;
        -- check for Terminate sub-Event
        if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition
        then
              flow_engine_util.flow_terminate_level(p_process_id, p_subflow_id);

        elsif p_step_info.target_objt_subtag is null
        then
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
        
        if l_remaining_subflows = 0 
        then 
            -- No remaining subflows so process has completed
            update flow_processes prcs 
               set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_completed
                 , prcs.prcs_last_update = systimestamp
             where prcs.prcs_id = p_process_id;

            apex_debug.message(p_message => 'Process Completed: Process '||p_process_id, p_level => 4) ;
        end if;
    else  
        -- in a sub-process
        apex_debug.message
        (p_message => 'Next Step is Sub-Process End '||p_step_info.target_objt_ref||
                      ' of type '||p_step_info.target_objt_subtag||
                      ' Resuming Parent Subflow : '||l_sbfl_id_par, p_level => 4
        ); 

        if p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_error_event_definition
        then
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
            flow_engine_util.flow_terminate_level
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );

        elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition
        then
            -- stop processing in sub process and all children
            flow_engine_util.flow_terminate_level
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            ); 
        elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition
        then
            -- this can be interrupting or non-interupting
            flow_boundary_events.process_boundary_event
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_step_info => p_step_info
            , p_par_sbfl => l_sbfl_id_par
            );
        elsif p_step_info.target_objt_subtag is null -- Normal End
        then 
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
        
        if l_remaining_subflows = 0 
        then 
            -- No remaining subflows so subprocess has completed - return to parent and do next step
            flow_complete_step 
            ( p_process_id => p_process_id
            , p_subflow_id => l_sbfl_id_par
            );  
            apex_debug.message(p_message => 'SubProcess Completed: Process level '||p_sbfl_info.sbfl_process_level, p_level => 4) ;

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
    apex_debug.message(p_message => 'Begin process_subprocess for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    begin
       select objt.objt_bpmn_id
         into l_target_objt_sub
         from flow_objects objt
        where objt.objt_objt_id  = p_step_info.target_objt_id
          and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event  
          and objt.objt_dgrm_id  = p_step_info.dgrm_id
       ;
    exception
         when NO_DATA_FOUND  
         then
             apex_error.add_error
             ( p_message => 'Unable to find Sub-Process Start Event.'
             , p_display_location => apex_error.c_on_error_page
             );
         when TOO_MANY_ROWS
         then
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
    apex_debug.info
    (
      p_message => 'Begin process_IntermediateCatchEvent %s'
    , p0        => p_step_info.target_objt_ref
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
           , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
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
    apex_debug.message(p_message => 'Begin process_IntermediateThrowEvent '||p_step_info.target_objt_ref, p_level => 4) ;

    if p_step_info.target_objt_subtag is null
    then
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
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_link_event_definition
    then
        flow_process_link_event
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_step_info => p_step_info
        );   
    elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition
    then
        -- make the ITE the current event
        update flow_subflows sbfl
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
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_step_info => p_step_info
        , p_par_sbfl => l_par_sbfl
        );  
    else 
        --- other type of intermediateThrowEvent that is not currently supported
        apex_error.add_error
            ( p_message => 'Currently unsupported type of Intermediate Throw Event encountered at '||p_sbfl_info.sbfl_current||' .'
            , p_display_location => apex_error.c_on_error_page
            );
    end if;
end process_intermediateThrowEvent;

/*procedure process_userTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
is 
begin
    -- current implementation is limited to one userTask type, which is to run a user defined APEX page
    -- future userTask types could include parameterised, standarised template pages , e.g., for approvals??  template scripts ??
    -- current implementation is implemented via the process inbox view.  
    apex_debug.message(p_message => 'Begin process_userTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
    set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = systimestamp
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- set boundaryEvent Timers, if any
    flow_set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
end process_userTask;

  procedure process_scriptTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.info
    (
      p_message => 'Begin process_scriptTask for object: %s'
    , p0        => p_step_info.target_objt_tag
    );
    -- current implementation is limited to one scriptTask type, which is to run a user defined PL/SQL script
    -- future scriptTask types could include standarised template scripts ??
    -- current implementation is limited to synchronous script execution (i.e., script is run as part of Flows for APEX process)
    -- future implementations could include async scriptTasks, where script execution is queued.
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = systimestamp
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;

    flow_plsql_runner_pkg.run_task_script(
      pi_prcs_id => p_process_id
    , pi_sbfl_id => p_subflow_id
    , pi_objt_id => p_step_info.target_objt_id
    );

    flow_complete_step ( p_process_id => p_process_id, p_subflow_id => p_subflow_id );

  exception
    when flow_plsql_runner_pkg.e_plsql_call_failed then
      rollback;
      raise flow_plsql_runner_pkg.e_plsql_call_failed;
  end process_scriptTask;

  procedure process_serviceTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.message
    (
      p_message => 'Begin process_serviceTask for object: %s'
    , p0        => p_step_info.target_objt_tag
    , p_level   => apex_debug.c_log_level_app_enter
    );

    update flow_subflows sbfl
    set   sbfl.sbfl_current = p_step_info.target_objt_ref
        , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
        , sbfl.sbfl_last_update = systimestamp
        , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
    where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- current implementation is limited to one serviceTask type, which is for apex message template sent from user defined PL/SQL script
    -- future serviceTask types could include text message, tweet, AOP document via email, etc.
    -- current implementation is limited to synchronous email send (i.e., email sent as part of Flows for APEX process).
    -- future implementations could include async serviceTask, where message generation is queued, or non-email services

    flow_plsql_runner_pkg.run_task_script(
      pi_prcs_id => p_process_id
    , pi_sbfl_id => p_subflow_id
    , pi_objt_id => p_step_info.target_objt_id
    );

    flow_complete_step ( p_process_id => p_process_id, p_subflow_id => p_subflow_id );

  exception
    when others then
      rollback;
      raise flow_plsql_runner_pkg.e_plsql_call_failed;
  end process_serviceTask;

  procedure process_manualTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.message(p_message => 'Begin process_manualTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = systimestamp
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- current implementation of manualTask performs exactly like a standard Task, without attached boundary timers
    -- future implementation could include auto-call of an APEX page telling you what the manual task is and providing information about it?

    -- set boundaryEvent Timers, if any
    flow_set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
  end process_manualTask;*/

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
    apex_debug.message(p_message => 'Begin handle_event_gateway_event', p_level => 3) ;
    -- called from any event that has cleared (so expired timer, received message or signal, etc) to move eBG forwards
    -- procedure has to:
    -- - check that gateway has not already been cleared by another event
    -- - resume the incoming subflow on the path of the first event to occur and call next_step
    -- - stop / terminate all of the child subflows that were created to wait for other events
    -- - including making sure any timers, message receivers, etc., are cleared up.

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
          if child_subflows.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
          then
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
      apex_debug.message(p_message => 'Begin handle_intermediate_catch_event', p_level => 3) ;
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

/*procedure handle_interrupting_boundary_event
     ( p_process_id in flow_processes.prcs_id%type
     , p_subflow_id in flow_subflows.sbfl_id%type
    ) 
is
  l_boundary_objt_bpmn_id  flow_objects.objt_bpmn_id%type;
  l_parent_objt_tag        flow_objects.objt_tag_name%type;
  l_parent_objt_bpmn_id    flow_objects.objt_bpmn_id%type;
  l_child_sbfl             flow_subflows.sbfl_id%type;
begin
    select boundary_objt.objt_bpmn_id
         , main_objt.objt_tag_name
         , main_objt.objt_bpmn_id
      into l_boundary_objt_bpmn_id
         , l_parent_objt_tag
         , l_parent_objt_bpmn_id
      from flow_subflows sbfl
      join flow_processes prcs
        on prcs.prcs_id = sbfl.sbfl_prcs_id
      join flow_objects main_objt
        on main_objt.objt_bpmn_id = sbfl.sbfl_current
       and main_objt.objt_dgrm_id = prcs.prcs_dgrm_id
      join flow_objects boundary_objt
        on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
       and boundary_objt.objt_dgrm_id = prcs.prcs_dgrm_id
     where sbfl.sbfl_id = p_subflow_id
       and prcs.prcs_id = p_process_id
       and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
       and boundary_objt.objt_interrupting = 1
        ;
    if l_parent_objt_tag = flow_constants_pkg.gc_bpmn_subprocess
    then
       -- find a child subprocess and then stop all processing at that level and below
      select sbfl.sbfl_id
        into l_child_sbfl
        from flow_subflows sbfl
       where sbfl.sbfl_sbfl_id = p_subflow_id
         and rownum = 1
       ;
       if l_child_sbfl is not null 
       then 
          flow_engine_util.flow_terminate_level
          ( p_process_id => p_process_id
          , p_subflow_id => l_child_sbfl
          );
       end if;
    end if;
    -- clean up any other boundary timers on the object
    flow_boundary_events.unset_boundary_timers (p_process_id, p_subflow_id);
    -- switch processing onto boundaryEvent path and do next step
    update flow_subflows sbfl
       set sbfl.sbfl_current = l_boundary_objt_bpmn_id
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
         , sbfl.sbfl_last_completed = l_parent_objt_bpmn_id
         , sbfl.sbfl_last_update = systimestamp 
     where sbfl.sbfl_id = p_subflow_id 
       and sbfl.sbfl_prcs_id = p_process_id
         ;
     flow_complete_step (p_process_id, p_subflow_id);

end handle_interrupting_boundary_event;*/

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
  apex_debug.message(p_message => 'Begin flow_handle_event', p_level => 3) ;
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
****                       SUBFLOW FUNCTIONS (START, NEXT_STEP, STOP,  DELETE)
****
*************************************************************************************************************/


procedure flow_complete_step
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_forward_route in flow_connections.conn_bpmn_id%type default null
)
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_step_info             flow_types_pkg.flow_step_info;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
 -- l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.message
  (
    p_message => 'Begin flow_complete_step using Process ID %s and Subflow ID %s'
  , p0        => p_process_id
  , p1        => p_subflow_id
  , p_level   => 3
  );
  l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );
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
    select l_dgrm_id
         , objt_source.objt_tag_name
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
      join flow_processes prcs
        on prcs.prcs_dgrm_id = conn.conn_dgrm_id
      join flow_subflows sbfl
        on sbfl.sbfl_current = objt_source.objt_bpmn_id 
       and sbfl.sbfl_prcs_id = prcs.prcs_id
     where conn.conn_dgrm_id = l_dgrm_id
       and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_bpmn_id like nvl2( p_forward_route, p_forward_route, '%' )
       and prcs.prcs_id = p_process_id
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
      apex_debug.message(p_message => 'boundary event cleanup triggered for subflow '||p_subflow_id, p_level => 4) ;
      flow_boundary_events.unset_boundary_timers (p_process_id, p_subflow_id);
  end if;
  -- release subflow reservation
  if l_sbfl_rec.sbfl_reservation is not null then
    flow_reservations.release_step
    ( p_process_id        => p_process_id
    , p_subflow_id        => p_subflow_id
    , p_called_internally => true
    );
  end if;

  -- log current step as completed
 flow_engine_util.log_step_completion   
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_completed_object => l_sbfl_rec.sbfl_current
  );
  
  -- end of post- phase for previous step
  commit;
  apex_debug.message(p_message => 'End of -post phase (committed) on subflow '||p_subflow_id||'. Moving onto Next Step Pre-Phase', p_level => 4) ;

  -- start of pre-phase for next step

  -- relock subflow
  l_sbfl_rec := flow_engine_util.get_and_lock_subflow_info 
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  );
  l_sbfl_rec.sbfl_last_completed := l_sbfl_rec.sbfl_current;

  apex_debug.message(p_message => 'Before CASE %s', p0 => coalesce(l_step_info.target_objt_tag, '!NULL!'), p_level => 3);
  apex_debug.message(p_message => 'Before CASE : l_step_info.dgrm_id : ' || l_step_info.dgrm_id, p_level => 4) ;
  apex_debug.message(p_message => 'Before CASE : l_step_info.source_objt_tag : ' || l_step_info.source_objt_tag, p_level => 4) ;
  apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_id : ' || l_step_info.target_objt_id, p_level => 4) ;
  apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_ref : ' || l_step_info.target_objt_ref, p_level => 4) ;
  apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_tag : ' || l_step_info.target_objt_tag, p_level => 4) ;
  apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_subtag : ' || l_step_info.target_objt_subtag, p_level => 4) ;
  
  apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_id : ' || l_sbfl_rec.sbfl_id, p_level => 4) ;    
  apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_last_completed : ' || l_sbfl_rec.sbfl_last_completed, p_level => 4) ;    
  apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_prcs_id : ' || l_sbfl_rec.sbfl_prcs_id, p_level => 4) ;    
   
  case (l_step_info.target_objt_tag)
    when flow_constants_pkg.gc_bpmn_end_event    --next step is either end of process or sub-process returning to its parent
    then
      flow_engine.process_endEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_exclusive
    then
      flow_gateways.process_exclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_inclusive
    then
      flow_gateways.process_para_incl_Gateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_parallel 
    then
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
    when flow_constants_pkg.gc_bpmn_gateway_event_based
    then
        flow_gateways.process_eventBasedGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_catch_event   
    then 
        flow_engine.process_intermediateCatchEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_intermediate_throw_event   
    then 
        flow_engine.process_intermediateThrowEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  flow_constants_pkg.gc_bpmn_task 
    then 
        flow_tasks.process_task
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_usertask 
    then
        flow_tasks.process_userTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_scripttask 
    then 
        flow_tasks.process_scriptTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_manualtask 
    then 
        flow_tasks.process_manualTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_servicetask 
    then flow_tasks.process_serviceTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    end case;
    -- Commit transaction before returning
    commit;
exception
    when CASE_NOT_FOUND
    then
      apex_error.add_error
      ( p_message => 'Process Model Error: Process BPMN model next step uses unsupported object: '||l_step_info.target_objt_tag
      , p_display_location => apex_error.c_on_error_page
      );
    when NO_DATA_FOUND
    then
      apex_error.add_error
      ( p_message => 'Next step does not exist. Please check your process diagram.'
      , p_display_location => apex_error.c_on_error_page
      );
    when flow_plsql_runner_pkg.e_plsql_call_failed then
      apex_error.add_error
      (
        p_message => 'PL/SQL Call Error: The given PL/SQL code did not execute sucessfully.'
      , p_display_location => apex_error.c_on_error_page
      );
end flow_complete_step;

/************************************************************************************************************
****
****                       PROCESS INSTANCE FUNCTIONS (START, STOP, RESET, DELETE)
****
*************************************************************************************************************/

function flow_create
  ( p_dgrm_id   in flow_diagrams.dgrm_id%type
  , p_prcs_name in flow_processes.prcs_name%type
  ) return flow_processes.prcs_id%type
is
    l_ret flow_processes.prcs_id%type;
begin
    apex_debug.message(p_message => 'Begin flow_create', p_level => 3) ;
    insert 
      into  flow_processes prcs
          ( prcs.prcs_name
          , prcs.prcs_dgrm_id
          , prcs.prcs_status
          , prcs.prcs_init_ts
          , prcs.prcs_last_update
          )
    values
          ( p_prcs_name
          , p_dgrm_id
          , flow_constants_pkg.gc_prcs_status_created
          , systimestamp
          , systimestamp
          )
      returning prcs.prcs_id into l_ret
    ;
    commit;

    apex_debug.message(p_message => 'End flow_create', p_level => 3) ;

    return l_ret;
end flow_create;


procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  )
is
        l_return_code   number;
        cursor c_lock_all is 
            select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated
              from flow_subflows sbfl
              join flow_processes prcs
                on prcs.prcs_id = sbfl.sbfl_prcs_id 
              join flow_subflow_log sflg 
                on prcs.prcs_id = sflg.sflg_prcs_id
             where prcs.prcs_id = p_process_id
             order by sbfl.sbfl_process_level, sbfl.sbfl_id
               for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated wait 2
        ;
begin
    apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;
  
    -- lock all objects
    begin
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      );  
      open c_lock_all;
      close c_lock_all;
    exception 
      when lock_timeout then
      apex_error.add_error
      ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try your reservation again later.'
      , p_display_location => apex_error.c_on_error_page
      );
    end;

    -- kill any timers sill running in the process
    flow_timers_pkg.terminate_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  

    -- clear out run-time object_log

    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    -- delete the subflows
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
--    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
--    commented out during testing of inc/exclusive gateways and before run scriptTask is working
--    put this back in before FFA50
--    process variables are NOT being cleared when the process is reset without this

    update flow_processes prcs
       set prcs.prcs_last_update = systimestamp
         , prcs.prcs_status = flow_constants_pkg.gc_prcs_status_created
     where prcs.prcs_id = p_process_id
    ;
    commit;
end flow_reset;

procedure flow_delete
  (
    p_process_id in flow_processes.prcs_id%type
  )
is
    l_return_code   number;
    cursor c_lock_all is 
      select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id 
        join flow_subflow_log sflg 
          on prcs.prcs_id = sflg.sflg_prcs_id
       where prcs.prcs_id = p_process_id
       order by sbfl.sbfl_process_level, sbfl.sbfl_id
         for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated wait 2;
begin
    apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
    begin 
      -- lock all timers, logs, subflows and the process
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      );  
      open c_lock_all;
      close c_lock_all;
    exception 
      when lock_timeout then
        apex_error.add_error
        ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try again later.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;

    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    -- clear out run-time object_log

    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;

    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
    
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;
    commit;
end flow_delete;

end flow_engine;
/

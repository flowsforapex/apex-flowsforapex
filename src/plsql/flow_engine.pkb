create or replace package body flow_engine
as 

type flow_step_info is record
( dgrm_id           flow_diagrams.dgrm_id%type
, source_objt_tag   flow_objects.objt_tag_name%type
, target_objt_id    flow_objects.objt_id%type
, target_objt_ref   flow_objects.objt_bpmn_id%type
, target_objt_tag   flow_objects.objt_tag_name%type
, target_objt_subtag flow_objects.objt_sub_tag_name%type
);
type t_new_sbfl_rec is record
( sbfl_id   flow_subflows.sbfl_id%type
, route     flow_subflows.sbfl_route%type
);

type t_new_sbfls is table of t_new_sbfl_rec;

function get_dgrm_id
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_dgrm_id%type
  as
    l_prcs_dgrm_id flow_processes.prcs_dgrm_id%type;
  begin
    
    select prcs.prcs_dgrm_id
      into l_prcs_dgrm_id
      from flow_processes prcs
     where prcs.prcs_id = p_prcs_id
    ;
    
    return l_prcs_dgrm_id;
    
end get_dgrm_id;

procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type default null
  )
  is 
  begin
    insert into flow_subflow_log sflg
    ( sflg_prcs_id
    , sflg_objt_id
    , sflg_sbfl_id
    , sflg_last_updated
    , sflg_notes
    )
    values 
    ( p_process_id
    , p_completed_object
    , p_subflow_id
    , sysdate
    , p_notes
    );
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging step completion'
      , p_display_location => apex_error.c_on_error_page
      );
      raise;
  end log_step_completion;

function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_bpmn_id%type -- an object in the subprocess
  ) return number
  is
    l_parent_subflow          flow_subflows.sbfl_id%type;
    l_parent_subproc_activity flow_objects.objt_bpmn_id%type;
    l_dgrm_id                 flow_diagrams.dgrm_id%type;
  begin

    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );  

    -- get parent bpmn:subProcess object
    select par_objt.objt_bpmn_id
      into l_parent_subproc_activity
      from flow_objects objt
      join flow_objects par_objt
        on par_objt.objt_id = objt.objt_objt_id
     where objt.objt_bpmn_id = p_current
       and objt.objt_dgrm_id = l_dgrm_id
    ;
    -- try to get parent subflow
    begin
      select sbfl.sbfl_id
        into l_parent_subflow
        from flow_subflows sbfl
       where sbfl.sbfl_current = l_parent_subproc_activity
         and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    exception
      when no_data_found then
        -- no subflow found running the parent process 
        l_parent_subflow := null;
    end;
    return l_parent_subflow;
end get_subprocess_parent_subflow;

procedure get_number_of_connections
    ( pi_dgrm_id in flow_diagrams.dgrm_id%type
    , pi_target_objt_id flow_connections.conn_tgt_objt_id%type
    , po_num_forward_connections out number
    , po_num_back_connections out number
    )
is 
begin   
    select count(*)
      into po_num_back_connections
      from flow_connections conn 
     where conn.conn_tgt_objt_id = pi_target_objt_id
       and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
    select count(*)
      into po_num_forward_connections
      from flow_connections conn 
     where conn.conn_src_objt_id = pi_target_objt_id
       and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
end get_number_of_connections;

function get_gateway_route
    ( pi_process_id     in flow_processes.prcs_id%type
    , pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
    ) return varchar2
is
    l_forward_route     varchar2(2000);  -- 1 route for exclusiveGateway, 1 or more for inclusive (:sep)
    l_bad_routes        apex_application_global.vc_arr2;
    l_bad_route_string  varchar2(2000) := '';
    l_num_bad_routes    number := 0;
begin
    -- check if route is in process variable
    l_forward_route := flow_process_vars.get_var_vc2(pi_process_id, pi_objt_bpmn_id||':route');
    if l_forward_route is not null
    then
       begin
        -- test routes are all valid connections before returning
        l_num_bad_routes := 0;
        for bad_routes in (
            select column_value as bad_route 
              from table(apex_string.split(l_forward_route,':'))
            minus 
            select conn.conn_bpmn_id
              from flow_connections conn
              join flow_objects objt 
                on objt.objt_id = conn.conn_src_objt_id
              and conn.conn_dgrm_id = objt.objt_dgrm_id
              join flow_processes prcs
                on prcs.prcs_dgrm_id = conn.conn_dgrm_id
            where prcs.prcs_id = pi_process_id
              and objt.objt_bpmn_id = pi_objt_bpmn_id
            )
        loop
           l_num_bad_routes := l_num_bad_routes +1;
           l_bad_route_string := l_bad_route_string||bad_routes.bad_route||', ';
        end loop;
        if l_num_bad_routes > 0 then
            apex_error.add_error( p_message => 'Error routing process flow at '||pi_objt_bpmn_id||'. Supplied variable '||pi_objt_bpmn_id||':route contains invalid route: '||l_bad_route_string
                         , p_display_location => apex_error.c_on_error_page) ;
        end if;
      exception
        when no_data_found then -- all routes good
          return l_forward_route
          ;
      end;
    else -- forward route is null -- look for default routing
        begin
            -- check default route 
            select conn_bpmn_id
              into l_forward_route
              from flow_connections conn
              join flow_objects objt 
                on objt.objt_id = conn.conn_src_objt_id
               and conn.conn_dgrm_id = objt.objt_dgrm_id
              join flow_processes prcs 
                on prcs.prcs_dgrm_id = conn.conn_dgrm_id
             where conn.conn_is_default = 1
               and objt.objt_bpmn_id = pi_objt_bpmn_id
               and prcs.prcs_id = pi_process_id
                ;
        exception
            when no_data_found then
                apex_error.add_error
                ( p_message => 'Please specify the connection ID for process variable '||pi_objt_bpmn_id||':route or specify a default route for the gateway.'
                , p_display_location => apex_error.c_on_error_page
                );
            when too_many_rows then
                apex_error.add_error
                ( p_message => 'More than one default route specified on Gateway '||pi_objt_bpmn_id
                , p_display_location => apex_error.c_on_error_page
                );
        end;
    end if; 
    return l_forward_route;
end get_gateway_route;

function subflow_start
  ( 
    p_process_id                in flow_processes.prcs_id%type
  , p_parent_subflow            in flow_subflows.sbfl_id%type
  , p_starting_object           in flow_objects.objt_bpmn_id%type
  , p_current_object            in flow_objects.objt_bpmn_id%type
  , p_route                     in flow_subflows.sbfl_route%type
  , p_last_completed            in flow_objects.objt_bpmn_id%type
  , p_status                    in flow_subflows.sbfl_status%type default flow_constants_pkg.gc_sbfl_status_running
  , p_parent_sbfl_proc_level    in flow_subflows.sbfl_process_level%type
  , p_new_proc_level            in boolean default false
  ) return flow_subflows.sbfl_id%type
  is 
    l_ret flow_subflows.sbfl_id%type;
  begin
    apex_debug.message(p_message => 'Begin subflow_start', p_level => 3) ;
    insert
      into flow_subflows
         ( sbfl_prcs_id
         , sbfl_sbfl_id
         , sbfl_process_level
         , sbfl_starting_object
         , sbfl_route
         , sbfl_last_completed
         , sbfl_current
         , sbfl_status
         , sbfl_last_update
         )
    values
         ( p_process_id
         , p_parent_subflow
         , p_parent_sbfl_proc_level
         , p_starting_object
         , p_route
         , p_last_completed
         , p_current_object
         , p_status
         , systimestamp
         )
      returning sbfl_id into l_ret
    ;
    if p_new_proc_level then
        -- starting new process or new subprocess.  Set sbfl_process_level to new sbfl_id
        update flow_subflows
        set sbfl_process_level = l_ret
        where sbfl_id = l_ret
        ;
    end if;
    apex_debug.message(p_message => 'Subflow '||l_ret||' started', p_level => 3) ;
    return l_ret;
end subflow_start;

procedure flow_reserve_step
( p_process_id   in flow_processes.prcs_id%type
, p_subflow_id   in flow_subflows.sbfl_id%type
, p_reservation  in flow_subflows.sbfl_reservation%type
)
is
  l_existing_reservation  flow_subflows.sbfl_reservation%type;
  e_reserved_by_other     exception;
  e_reserved_by_same      exception;
begin
    apex_debug.message(p_message => 'Begin flow_reserve_step. Subflow '||p_subflow_id||' in Process '||p_process_id||' Reservation:'||p_reservation, p_level => 3) ;
    -- check step is not already reserved
    select sbfl_reservation
      into l_existing_reservation
      from flow_subflows sbfl 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    if l_existing_reservation is not null 
    then 
        if p_reservation = l_existing_reservation
        then 
           -- step already reserved by required reservation
           raise e_reserved_by_same;
        else 
           raise e_reserved_by_other;
        end if;
    end if;
    -- place the reservation
    update flow_subflows sbfl
       set sbfl_reservation = p_reservation
     where sbfl_prcs_id = p_process_id
       and sbfl_id = p_subflow_id
    ;

exception
    when no_data_found
    then
      apex_error.add_error
      ( p_message => 'Reservation unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
    when e_reserved_by_other
    then
      apex_error.add_error
      ( p_message => 'Reservation unsuccessful.  Step already reserved by another user.'
      , p_display_location => apex_error.c_on_error_page
      );    
    when e_reserved_by_same
    then
      apex_error.add_error
      ( p_message => 'Reservation already placed on next task.'
      , p_display_location => apex_error.c_on_error_page
      );
end flow_reserve_step;

procedure flow_release_step
( p_process_id   in flow_processes.prcs_id%type
, p_subflow_id   in flow_subflows.sbfl_id%type
)
is
  l_existing_reservation  flow_subflows.sbfl_reservation%type;
begin
    apex_debug.message(p_message => 'Begin flow_release_step. Subflow '||p_subflow_id||' in Process '||p_process_id, p_level => 3) ;
    -- check step is not already reserved
    select sbfl_reservation
      into l_existing_reservation
      from flow_subflows sbfl 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- place the reservation
    update flow_subflows sbfl
       set sbfl_reservation = null
     where sbfl_prcs_id = p_process_id
       and sbfl_id = p_subflow_id
    ;
exception
    when no_data_found
    then
      apex_error.add_error
      ( p_message => 'Reservation unsuccessful.  Subflow '||p_subflow_id||' in Process '||p_process_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
end flow_release_step;

procedure flow_terminate_level
( p_process_id   in flow_processes.prcs_id%type
, p_subflow_id   in flow_subflows.sbfl_id%type
)
is
    l_process_level   flow_subflows.sbfl_process_level%type;
begin
    apex_debug.message(p_message => 'Begin flow_terminate_level for prcs '||p_process_id||' subflow '||p_subflow_id, p_level => 3) ;
    --
    begin
      select sbfl.sbfl_process_level
        into l_process_level 
        from flow_subflows sbfl
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
      ;
    exception
      when no_data_found 
      then
        return;
    end;
    -- find any running subprocesses with parent at this level
    begin
      for running_subprocs in (
        select child_sbfl.sbfl_id
          from flow_subflows parent_sbfl
          join flow_subflows child_sbfl
            on parent_sbfl.sbfl_current = child_sbfl.sbfl_starting_object
         where parent_sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
           and parent_sbfl.sbfl_process_level = l_process_level
      )
      loop
        flow_terminate_level
        ( p_process_id => p_process_id
        , p_subflow_id => running_subprocs.sbfl_id);
      end loop;
    exception
      when no_data_found then
        null;
    end;
    -- end all subflows in the level
    delete from flow_subflows
    where sbfl_process_level = l_process_level 
      and sbfl_prcs_id = p_process_id
      ;
end flow_terminate_level;

procedure subflow_complete
  ( p_process_id        in flow_processes.prcs_id%type
  , p_subflow_id        in flow_subflows.sbfl_id%type
  )
  is
    l_remaining_subflows              number;
    l_remaining_siblings              number;
    l_current_object                  flow_subflows.sbfl_current%type;
    l_current_subflow_status          flow_subflows.sbfl_status%type;
    l_parent_subflow_id               flow_subflows.sbfl_sbfl_id%type;
    l_parent_subflow_status           flow_subflows.sbfl_status%type;
    l_parent_subflow_last_completed   flow_subflows.sbfl_last_completed%type;
    l_parent_subflow_current          flow_subflows.sbfl_current%type;
  begin
    apex_debug.message(p_message => 'Begin subflow_complete', p_level => 3) ;
    
    select sbfl.sbfl_sbfl_id
         , sbfl.sbfl_current
         , sbfl.sbfl_status
      into l_parent_subflow_id
         , l_current_object
         , l_current_subflow_status
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ; 
    
    if l_parent_subflow_id is not null then   
      -- get parent subflow info
      select sbfl.sbfl_status
           , sbfl.sbfl_last_completed
           , sbfl.sbfl_current
        into l_parent_subflow_status
           , l_parent_subflow_last_completed
           , l_parent_subflow_current
        from flow_subflows sbfl
       where sbfl.sbfl_id = l_parent_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    end if;
    -- delete the subflow
    delete from flow_subflows
     where sbfl_id = p_subflow_id
       and sbfl_prcs_id = p_process_id
    ;

    -- handle parallel flows with their own end events.  Last one completing needs to clear up the parent 'split' sbfl.
    -- if subflow has parent with   
    -- a)  status 'split'  (flow_constants_pkg.gc_sbfl_status_split)
    -- b)  no other children, AND
    -- c)  is not a merging gateway
    -- then we have an ophan parent process to clean up (all opening gateway paths have run to conclusion)
    -- need to call this recursively in case you have nested open parallel gateways

    if l_parent_subflow_id is not null then   
        
      select count(*)
        into l_remaining_siblings
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = l_parent_subflow_last_completed
      ;
      
      if (   l_remaining_siblings = 0
         and l_parent_subflow_status =  flow_constants_pkg.gc_sbfl_status_split    
         and l_current_subflow_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
         )
      then
        -- call subflow_complete again recursively in case it has orphan grandparent
        subflow_complete ( p_process_id => p_process_id
                         , p_subflow_id => l_parent_subflow_id
                         );
      end if;  
    end if;
end subflow_complete;

procedure flow_start_process
( p_process_id    in flow_processes.prcs_id%type
)
is
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_objt_bpmn_id          flow_objects.objt_bpmn_id%type;
    l_objt_sub_tag_name     flow_objects.objt_sub_tag_name%type;
    l_main_subflow_id       flow_subflows.sbfl_id%type;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
begin
    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
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
    -- check if start has a timer?  
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
    then 
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_waiting_timer;
    else
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_running;
    end if;

    l_main_subflow_id := flow_engine.subflow_start 
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
    -- update process status
    update flow_processes prcs
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
         , prcs.prcs_last_update = sysdate
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;
end flow_start_process;

procedure flow_set_boundary_timers
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
            l_new_non_int_timer_sbfl := subflow_start
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
end flow_unset_boundary_timers;

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
  , p_step_info     in flow_step_info
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
    log_step_completion   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => p_step_info.target_objt_ref
    );
    -- jump into matching catch event
    update flow_subflows sbfl
    set   sbfl.sbfl_current = l_next_objt
        , sbfl.sbfl_last_completed = p_step_info.target_objt_ref
        , sbfl.sbfl_last_update = sysdate
        , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
    where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    flow_complete_step
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
end flow_process_link_event;

procedure flow_get_boundary_event
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
  , p_step_info     in flow_step_info
  , p_par_sbfl      in flow_subflows.sbfl_id%type
  )
is 
    l_next_objt             flow_objects.objt_bpmn_id%type;
    l_interrupting          flow_objects.objt_interrupting%type;
    l_new_sbfl              flow_subflows.sbfl_id%type;
    l_parent_processs_level flow_subflows.sbfl_process_level%type;
begin 
    -- set the throwing event to completed
    log_step_completion   
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
        -- set parent subflow to boundary event and do flow_complete_step
        update flow_subflows sbfl
          set sbfl.sbfl_current = l_next_objt
            , sbfl.sbfl_last_completed = p_step_info.target_objt_ref 
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
          where sbfl.sbfl_id = p_par_sbfl
            and sbfl.sbfl_prcs_id = p_process_id
            ;
        flow_complete_step
        ( p_process_id => p_process_id
        , p_subflow_id => p_par_sbfl
        );
        -- stop processing in sub process and all children
        flow_terminate_level
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        ); 
    else 
        -- non interrupting.  
        select par_sbfl.sbfl_process_level
          into l_parent_processs_level 
          from flow_subflows par_sbfl
         where par_sbfl.sbfl_id = p_par_sbfl
           and par_sbfl.sbfl_prcs_id = p_process_id
           ;
        -- start new subflow starting at the boundary event and step to next task
        l_new_sbfl := subflow_start
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
            subflow_complete
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );
        end if;
    end if;
end flow_process_boundary_event;

/*
============================================================================================
  B P M N   O B J E C T   P R O C E S S O R S 
============================================================================================
*/

procedure process_task
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
begin
   apex_debug.message(p_message => 'Begin process_task for object: '||p_step_info.target_objt_tag, p_level => 3) ;
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;

      -- set boundaryEvent Timers, if any
      flow_set_boundary_timers 
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );  
end process_task;


procedure process_endEvent
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
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
    l_sbfl_id_par := get_subprocess_parent_subflow
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_current    => p_sbfl_info.sbfl_current
            );
    -- log the current endEvent as completed
    log_step_completion
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
              flow_terminate_level(p_process_id, p_subflow_id);

        elsif p_step_info.target_objt_subtag is null
        then
            subflow_complete
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
                 , prcs.prcs_last_update = sysdate
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
              flow_unset_boundary_timers (p_process_id, l_sbfl_id_par);
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
            flow_terminate_level
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );

        elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_terminate_event_definition
        then
            -- stop processing in sub process and all children
            flow_terminate_level
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            ); 
        elsif p_step_info.target_objt_subtag = flow_constants_pkg.gc_bpmn_escalation_event_definition
        then
            -- this can be interrupting or non-interupting
            flow_process_boundary_event
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_step_info => p_step_info
            , p_par_sbfl => l_sbfl_id_par
            );
        elsif p_step_info.target_objt_subtag is null -- Normal End
        then 
            -- normal end event
            subflow_complete
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

  procedure process_parallelGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
  is
    l_gateway_forward_status    varchar2(10);
    l_sbfl_id                   flow_subflows.sbfl_id%type;
    l_sbfl_id_sub               flow_subflows.sbfl_id%type;
    l_sbfl_id_par               flow_subflows.sbfl_id%type; 
    l_num_back_connections      number;   -- number of connections leading into object
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_unfinished_subflows   number;
    l_new_subflows              t_new_sbfls := t_new_sbfls();
    l_new_subflow               t_new_sbfl_rec;
  begin
    apex_debug.message(p_message => 'Next Step is parallelGateway '||p_step_info.target_objt_ref, p_level => 4) ;
    -- test if this is splitting or merging (or both) gateway
    get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );
    l_gateway_forward_status := 'proceed';
    l_sbfl_id  := p_subflow_id;

    if l_num_back_connections >= 2 then
      apex_debug.message(p_message => 'Merging Parallel Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       
      -- we have merging gateway
      l_gateway_forward_status := 'wait';
      -- set current subflow to status waiting,       
      update flow_subflows sbfl
         set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
           , sbfl.sbfl_last_update = sysdate 
           , sbfl.sbfl_current = p_step_info.target_objt_ref
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- check if we are waiting for other flows or can proceed
      select count(*)
        into l_num_unfinished_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
         and (  sbfl.sbfl_current != p_step_info.target_objt_ref
             or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
             )
      ;
      if l_num_unfinished_subflows = 0 then
        -- all merging tasks completed.  proceed from gateway
        for completed_subflows in ( select sbfl.sbfl_id
                                      from flow_subflows sbfl 
                                     where sbfl.sbfl_prcs_id = p_process_id
                                       and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                       and sbfl.sbfl_current = p_step_info.target_objt_ref 
                                       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                  )
        loop
          subflow_complete
          ( p_process_id => p_process_id
          , p_subflow_id => completed_subflows.sbfl_id
          );
        end loop;
        
        l_gateway_forward_status := 'proceed';
        --log gateway object as complete
  
        -- switch to parent subflow
        l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
        --restart parent split subflow
        update flow_subflows sbfl
           set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_proceed_gateway
             , sbfl.sbfl_current = p_step_info.target_objt_ref
             , sbfl.sbfl_last_update = sysdate
         where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
           and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
           and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
        ;
      end if;
    end if;
    
    -- now do forward path, if you have token to 'proceed'
    if l_gateway_forward_status = 'proceed' then 
      if l_num_forward_connections > 1 then
        -- we have splitting gateway going forward
        -- Current Subflow into status split and no current object
        update flow_subflows sbfl
           set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
             , sbfl.sbfl_current = null
             , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
             , sbfl.sbfl_last_update = sysdate 
         where sbfl.sbfl_id = l_sbfl_id
           and sbfl.sbfl_prcs_id = p_process_id
        ;
        -- get all forward parallel paths and create subflows for them
        -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
        -- create subflows in one loop then step through them again in second loop
        -- to prevent some subflows getting to following merge gateway before all subflows are created (causes race condition)

        for new_path in ( select conn.conn_bpmn_id route
                               , objt.objt_bpmn_id target
                            from flow_connections conn
                            join flow_objects objt
                              on objt.objt_id = conn.conn_tgt_objt_id
                             and conn.conn_dgrm_id = objt.objt_dgrm_id
                           where conn.conn_dgrm_id = p_step_info.dgrm_id
                             and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                             and conn.conn_src_objt_id = p_step_info.target_objt_id
                        )
        loop
          l_new_subflow.sbfl_id :=
            subflow_start
            ( p_process_id             => p_process_id         
            , p_parent_subflow         => l_sbfl_id        
            , p_starting_object        => p_step_info.target_objt_ref         
            , p_current_object         => p_step_info.target_objt_ref          
            , p_route                  => new_path.route         
            , p_last_completed         => p_step_info.target_objt_ref  
            , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
            , p_new_proc_level         => false
            )
          ;
          l_new_subflow.route   := new_path.route;
          l_new_subflows.extend;
          l_new_subflows (l_new_subflows.last) := l_new_subflow;
        end loop;
       
        for new_subflow in 1.. l_new_subflows.count
        loop
          -- step into first step on the new path
          flow_complete_step    
          ( p_process_id    => p_process_id
          , p_subflow_id    => l_new_subflows(new_subflow).sbfl_id
          , p_forward_route => l_new_subflows(new_subflow).route
          );
        end loop;
      elsif l_num_forward_connections = 1 then
        -- only single path going forward
        update  flow_subflows sbfl
            set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
              , sbfl.sbfl_current = p_step_info.target_objt_ref
              , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
              , sbfl.sbfl_last_update = sysdate 
          where sbfl.sbfl_id = l_sbfl_id
            and sbfl.sbfl_prcs_id = p_process_id
        ;
        -- step into first step on the new path
        flow_complete_step   
        ( p_process_id => p_process_id
        , p_subflow_id => l_sbfl_id
        , p_forward_route => null
        );
      end if;  -- single path
    end if;  -- forward token
  end process_parallelGateway;

  procedure process_inclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
  is
    l_sbfl_id                 flow_subflows.sbfl_id%type;
    l_sbfl_id_sub             flow_subflows.sbfl_id%type;
    l_sbfl_id_par             flow_subflows.sbfl_id%type; 
    l_num_back_connections    number;   -- number of connections leading into object
    l_num_forward_connections number;   -- number of connections forward from object
    l_num_unfinished_subflows number;
    l_forward_routes          varchar2(2000);
    l_new_subflows            t_new_sbfls := t_new_sbfls();
    l_new_subflow             t_new_sbfl_rec;
  begin
    -- handles opening and closing but not closing and reopening  --FFA41
    apex_debug.message(p_message => 'Next Step is inclusiveGateway '||p_step_info.target_objt_ref, p_level => 4) ;
    -- test if this is splitting or merging (or both) gateway
    get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );
    if l_num_back_connections = 1 then
      -- this is opening inclusiveGateway.  Step into it.  Forward paths will get opened by flow_complete_step
      -- after user decision.
      -- l_forward_routes := flow_process_vars.get_var_vc2(p_process_id, 'Route:'||p_step_info.target_objt_ref);
      l_forward_routes := get_gateway_route(p_process_id, p_step_info.target_objt_ref);
      apex_debug.message(p_message => 'Forward routes for inclusiveGateway '||p_step_info.target_objt_ref ||' :'||l_forward_routes, p_level => 4) ;
      -- set current subflow to status split, current = null       
      update flow_subflows sbfl
         set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
           , sbfl.sbfl_current = ''
           , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
           , sbfl.sbfl_last_update = sysdate 
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      for new_path in ( select conn.conn_bpmn_id                route
                             , ultimate_tgt_objt.objt_bpmn_id   target
                          from flow_connections conn
                          join flow_objects ultimate_tgt_objt
                            on ultimate_tgt_objt.objt_id = conn.conn_tgt_objt_id
                           and conn.conn_dgrm_id = ultimate_tgt_objt.objt_dgrm_id
                         where conn.conn_dgrm_id = p_step_info.dgrm_id
                           and conn.conn_src_objt_id = p_step_info.target_objt_id
                           and conn.conn_bpmn_id member of apex_string.split( l_forward_routes, ':' ) -- verify if this works
                      )
      loop
        -- path is included in list of chosen forward paths.
        apex_debug.message(p_message => 'starting parallel flow for inclusiveGateway', p_level => 3) ;
        l_new_subflow.sbfl_id :=
          flow_engine.subflow_start
          ( 
            p_process_id             => p_process_id         
          , p_parent_subflow         => p_subflow_id        
          , p_starting_object        => p_step_info.target_objt_ref        
          , p_current_object         => p_step_info.target_objt_ref          
          , p_route                  => new_path.route         
          , p_last_completed         => p_step_info.target_objt_ref  
          , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
          , p_new_proc_level         => false      
          );
        l_new_subflow.route   := new_path.route;
        l_new_subflows.extend;
        l_new_subflows (l_new_subflows.last) := l_new_subflow;
      end loop;
      -- now step the new sub flows forward into their first tasks
      for new_subflow in 1.. l_new_subflows.count
        loop
          -- step into first step on the new path
          flow_complete_step    
          ( p_process_id    => p_process_id
          , p_subflow_id    => l_new_subflows(new_subflow).sbfl_id
          , p_forward_route => l_new_subflows(new_subflow).route
          );
        end loop;
    elsif ( l_num_back_connections > 1 AND l_num_forward_connections >1 ) then
      -- diagram has closing and re-opening inclusiveGateway which is not supported
      apex_error.add_error
      ( 
        p_message => 'Inclusive Gateway with multiple inputs and multiple outputs not supported.  Re-draw as two gateways.'
      , p_display_location => apex_error.c_on_error_page
      );
    elsif ( l_num_forward_connections = 1 AND l_num_back_connections > 1 ) then
      -- merging gateway.  
      -- note actual number of subflows chosen could be 1 or more and need not be all of defined routes 
      -- forward paths from the diagram may have been started.  So always work on running subflows
      -- not connections from the diagram.
      apex_debug.message(p_message => 'Merging Inclusive Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       

      -- set current subflow to status waiting,       
      update flow_subflows sbfl
         set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
           , sbfl.sbfl_last_update = sysdate 
           , sbfl.sbfl_current = p_step_info.target_objt_ref
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- check if we are waiting for other flows or can proceed
      select count(*)
        into l_num_unfinished_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
         and (  sbfl.sbfl_current != p_step_info.target_objt_ref
             or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
             )
      ;
      if l_num_unfinished_subflows = 0 then
        -- all merging tasks completed.  proceed from gateway
        for completed_subflows in ( select sbfl.sbfl_id
                                      from flow_subflows sbfl 
                                     where sbfl.sbfl_prcs_id = p_process_id
                                       and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                       and sbfl.sbfl_current = p_step_info.target_objt_ref 
                                       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                  )
        loop
          subflow_complete
          ( p_process_id        => p_process_id
          , p_subflow_id        => completed_subflows.sbfl_id
          );
        end loop;
        -- switch to parent subflow
        l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
        --restart parent split subflow
        update flow_subflows sbfl
          set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
            , sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
            , sbfl.sbfl_last_update = sysdate
        where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
          and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
        ;
        -- step into first step on the new path
        flow_complete_step     
        ( 
          p_process_id    => p_process_id
        , p_subflow_id    => l_sbfl_id
        , p_forward_route => null
        );
      end if;    -- merging finished      
    end if;  -- operation type
end process_inclusiveGateway;

procedure process_exclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_back_connections      number;   -- number of connections back from object
    l_forward_route             varchar2(2000);
begin
    -- handles opening and closing and closing and reopening
    apex_debug.message(p_message => 'Begin process_exclusiveGateway for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );
    if l_num_forward_connections > 1
    then -- opening gateway - get choice
        l_forward_route := get_gateway_route(p_process_id, p_step_info.target_objt_ref);
    else -- closing gateway - keep going
        l_forward_route := null;
    end if;  

    update flow_subflows sbfl
        set sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;  
    flow_complete_step   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_forward_route => l_forward_route
    );

end process_exclusiveGateway;

  procedure process_subProcess
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_step_info
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
      subflow_start
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
        , sbfl.sbfl_last_update = sysdate
        , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
    where sbfl.sbfl_id = p_subflow_id
      and sbfl.sbfl_prcs_id = p_process_id
    ;  
    -- set boundaryEvent Timers, if any
    flow_set_boundary_timers 
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
  
  procedure process_eventBasedGateway
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_sbfl_info  in flow_subflows%rowtype
  , p_step_info  in flow_step_info
  )
  is 
    l_sbfl_id_sub flow_subflows.sbfl_id%type;
  begin
    -- eventGateway can have multiple inputs and outputs, but there is no waiting, etc.
    -- incoming subflow continues on the first output path.
    -- additional output paths create new subflows
    apex_debug.message
    (
      p_message => 'Begin process_EventBasedGateway for object %s'
    , p0        => p_step_info.target_objt_ref
    , p_level => 4
    );
    -- mark parent flow as split
    update flow_subflows sbfl
       set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
         , sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
         , sbfl.sbfl_last_update = sysdate 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- get all forward parallel paths and create subflows for them
    -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
    for new_path in ( select conn.conn_bpmn_id route
                           , objt.objt_bpmn_id target
                        from flow_connections conn
                        join flow_objects objt
                          on objt.objt_id = conn.conn_tgt_objt_id
                         and conn.conn_dgrm_id = objt.objt_dgrm_id
                       where conn.conn_dgrm_id = p_step_info.dgrm_id
                         and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                         and conn.conn_src_objt_id = p_step_info.target_objt_id
                    )
    loop
      -- create new subflows for forward event paths starting here
      l_sbfl_id_sub :=
        subflow_start
        ( 
          p_process_id             => p_process_id         
        , p_parent_subflow         => p_subflow_id       
        , p_starting_object        => p_step_info.target_objt_ref         
        , p_current_object         => p_step_info.target_objt_ref          
        , p_route                  => new_path.route         
        , p_last_completed         => p_step_info.target_objt_ref 
        , p_status                 => flow_constants_pkg.gc_sbfl_status_waiting_event   
        , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
        , p_new_proc_level         => false    
        )
      ;
      -- step into first step on the new path
      flow_complete_step   
      (
        p_process_id    => p_process_id
      , p_subflow_id    => l_sbfl_id_sub
      , p_forward_route => new_path.route
      );
    end loop;
  end process_eventBasedGateway;

  procedure process_intermediateCatchEvent
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_sbfl_info  in flow_subflows%rowtype
  , p_step_info  in flow_step_info
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
           , sbfl.sbfl_last_update = sysdate
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
           , sbfl.sbfl_last_update = sysdate
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
  , p_step_info     in flow_step_info
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
            , sbfl.sbfl_last_update = sysdate
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
             , sbfl.sbfl_last_update = sysdate
             , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
         where sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_prcs_id = p_process_id
        ;
        -- get the subProcess event in the parent level
        l_par_sbfl := get_subprocess_parent_subflow
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_current => p_step_info.target_objt_ref
        );
        -- escalate it to the boundary Event
        flow_process_boundary_event
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

procedure process_userTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
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
         , sbfl.sbfl_last_update = sysdate
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
  , p_step_info     in flow_step_info
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
         , sbfl.sbfl_last_update = sysdate
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
  , p_step_info     in flow_step_info
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
        , sbfl.sbfl_last_update = sysdate
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
  , p_step_info     in flow_step_info
  )
  is 
  begin
    apex_debug.message(p_message => 'Begin process_manualTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = sysdate
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- current implementation of manualTask performs exactly like a standard Task, without attached boundary timers
    -- future implementation could include auto-call of an APEX page telling you what the manual task is & providing information about it?

    -- set boundaryEvent Timers, if any
    flow_set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
  end process_manualTask;

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
    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
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
          , sbfl_last_update = sysdate
      where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_parent_subflow_id
        and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          ;
       flow_complete_step           
          ( p_process_id => p_process_id
          , p_subflow_id => p_parent_subflow_id
          , p_forward_route => null
          );
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
           , sbfl.sbfl_last_update = sysdate
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_id = p_subflow_id
           ;
      flow_complete_step 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_forward_route => null
      );
end handle_intermediate_catch_event;

procedure handle_interrupting_boundary_event
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
          flow_terminate_level
          ( p_process_id => p_process_id
          , p_subflow_id => l_child_sbfl
          );
       end if;
    end if;
    -- clean up any other boundary timers on the object
    flow_unset_boundary_timers (p_process_id, p_subflow_id);
    -- switch processing onto boundaryEvent path and do next step
    update flow_subflows sbfl
       set sbfl.sbfl_current = l_boundary_objt_bpmn_id
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
         , sbfl.sbfl_last_completed = l_parent_objt_bpmn_id
         , sbfl.sbfl_last_update = sysdate 
     where sbfl.sbfl_id = p_subflow_id 
       and sbfl.sbfl_prcs_id = p_process_id
         ;
     flow_complete_step (p_process_id, p_subflow_id);

end handle_interrupting_boundary_event;

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
    l_dgrm_id := get_dgrm_id (p_prcs_id => p_process_id);

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
                               , flow_constants_pkg.gc_bpmn_boundary_event  )
    then
        -- required functionality same as iCE currently
        handle_intermediate_catch_event (
          p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );
    elsif l_curr_objt_tag_name in ( flow_constants_pkg.gc_bpmn_subprocess
                                  , flow_constants_pkg.gc_bpmn_task 
                                  , flow_constants_pkg.gc_bpmn_usertask
                                  , flow_constants_pkg.gc_bpmn_manualtask
                                  )   -- add any objects that can support timer boundary events here
    then
        handle_interrupting_boundary_event 
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
      if  l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event   and 
            l_prev_objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_event_based  -- we have an eventBasedGateway
      then 
          handle_event_gateway_event (
            p_process_id => p_process_id
          , p_parent_subflow_id => l_parent_subflow
          , p_cleared_subflow_id => p_subflow_id
          );
      elsif l_curr_objt_tag_name = flow_constants_pkg.gc_bpmn_intermediate_catch_event  
      then
          -- independant iCE not following an eBG
          -- set subflow status to running and call flow_complete_step
          handle_intermediate_catch_event (
            p_process_id => p_process_id
          , p_subflow_id => p_subflow_id
          );
      end if;
    end if;
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
  l_step_info             flow_engine.flow_step_info;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.message
  (
    p_message => 'Begin flow_complete_step using Process ID %s and Subflow ID %s'
  , p0        => p_process_id
  , p1        => p_subflow_id
  , p_level   => 3
  );
  l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
  -- Get current object and current subflow info
  begin
    begin
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
            ;
    exception
        when no_data_found then
        -- check if subflow valid in process
        select sbfl.sbfl_prcs_id
          into l_prcs_check_id
          from flow_subflows sbfl
         where sbfl.sbfl_id = p_subflow_id
         ;
        if l_prcs_check_id != p_process_id
        then
            apex_error.add_error
            ( p_message => 'Application Error: Subflow ID supplied ( '||p_subflow_id||' ) exists but is not child of Process ID Supplied ( '||p_process_id||' ).'
            , p_display_location => apex_error.c_on_error_page
            );
        end if;
    end;
  exception
    when no_data_found then
            apex_error.add_error
            ( p_message => 'Application Error: Subflow ID supplied ( '||p_subflow_id||' ) not found .'
            , p_display_location => apex_error.c_on_error_page
            );
  end;
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
      flow_unset_boundary_timers (p_process_id, p_subflow_id);
  end if;
  -- release subflow reservation
  flow_release_step(p_process_id, p_subflow_id);

  -- log current step as completed
  log_step_completion   
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_completed_object => l_sbfl_rec.sbfl_current
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
      flow_engine.process_exclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_inclusive
    then
      flow_engine.process_inclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when flow_constants_pkg.gc_bpmn_gateway_parallel 
    then
      flow_engine.process_parallelGateway
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
        flow_engine.process_eventBasedGateway
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
        flow_engine.process_task
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_usertask 
    then
        flow_engine.process_userTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_scripttask 
    then 
        flow_engine.process_scriptTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_manualtask 
    then 
        flow_engine.process_manualTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  flow_constants_pkg.gc_bpmn_servicetask 
    then flow_engine.process_serviceTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    end case;
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
    apex_debug.message(p_message => 'End flow_create', p_level => 3) ;

    return l_ret;
end flow_create;


procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  )
is
        l_return_code   number;
begin
    apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;
  
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

        
    -- kill any timers sill running in the process
    flow_timers_pkg.terminate_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
--    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
--    commented out during testing of inc/exclusive gateways and before run scriptTask is working
--    put this back in before FFA50
--    process variables are NOT being cleared when the process is reset without this

    update flow_processes prcs
       set prcs.prcs_last_update = sysdate
         , prcs.prcs_status = flow_constants_pkg.gc_prcs_status_created
     where prcs.prcs_id = p_process_id
    ;
end flow_reset;

procedure flow_delete
  (
    p_process_id in flow_processes.prcs_id%type
  )
is
    l_return_code   number;
begin
    apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  

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
end flow_delete;

end flow_engine;
/

create or replace package body flow_engine_util
as 

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

  function check_subflow_exists
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean
  is
    l_cnt number;
  begin
    select count(*)
      into l_cnt
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    return ( l_cnt = 1 );
  end check_subflow_exists;

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

    l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );  

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

  function get_and_lock_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ) return flow_subflows%rowtype
  is 
    l_sbfl_rec  flow_subflows%rowtype;
    l_prcs_check_id         flow_processes.prcs_id%type;
  begin
    begin 
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        for update of sbfl.sbfl_current
                    , sbfl.sbfl_last_completed
                    , sbfl.sbfl_reservation
                    , sbfl.sbfl_last_update
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
    return l_sbfl_rec;
  exception
    when no_data_found then
            apex_error.add_error
            ( p_message => 'Subflow ID supplied ( '||p_subflow_id||' ) not found. Check for process events that changed process flow (timeouts, errors, escalations). '
            , p_display_location => apex_error.c_on_error_page
            );
  end get_and_lock_subflow_info;

end flow_engine_util;
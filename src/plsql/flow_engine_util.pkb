create or replace package body flow_engine_util
as 

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

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
    ( pi_dgrm_id                  in flow_diagrams.dgrm_id%type
    , pi_target_objt_id           in flow_connections.conn_tgt_objt_id%type
    , pi_conn_type                in flow_connections.conn_tag_name%type  
    , po_num_forward_connections  out number
    , po_num_back_connections     out number
    )
  is 
  begin   
    select count(*)
      into po_num_back_connections
      from flow_connections conn 
     where conn.conn_tgt_objt_id = pi_target_objt_id
       and conn.conn_tag_name = pi_conn_type
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
    select count(*)
      into po_num_forward_connections
      from flow_connections conn 
     where conn.conn_src_objt_id = pi_target_objt_id
       and conn.conn_tag_name = pi_conn_type
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
  end get_number_of_connections;

  function get_and_lock_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ) return flow_subflows%rowtype
  is 
    l_sbfl_rec          flow_subflows%rowtype;
    l_prcs_check_id     flow_processes.prcs_id%type;
  begin
    begin 
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        for update wait 2
        ;
    exception
      when no_data_found then
        -- check if subflow valid in process
        select sbfl.sbfl_prcs_id
          into l_prcs_check_id
          from flow_subflows sbfl
         where sbfl.sbfl_id = p_subflow_id
         ;
        if l_prcs_check_id != p_process_id then
            apex_error.add_error
            ( p_message => 'Application Error: Subflow ID supplied ( '||p_subflow_id||' ) exists but is not child of Process ID Supplied ( '||p_process_id||' ).'
            , p_display_location => apex_error.c_on_error_page
            );
        end if;
      when lock_timeout then
        apex_error.add_error
        ( p_message => 'Unable to lock subflow '||p_subflow_id||' as another user is modifying.  Try again later.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;
    return l_sbfl_rec;
  exception
    when no_data_found then
            apex_error.add_error
            ( p_message => 'Subflow ID supplied ( '||p_subflow_id||' ) not found. Check for process events that changed process flow (timeouts, errors, escalations). '
            , p_display_location => apex_error.c_on_error_page
            );
  end get_and_lock_subflow_info;

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
    , p_dgrm_id                   in flow_diagrams.dgrm_id%type
    ) return flow_subflows.sbfl_id%type
  is 
    l_ret flow_subflows.sbfl_id%type;
  begin
    apex_debug.enter 
    ( 'subflow_start'
    , 'Process', p_process_id
    , 'Parent Subflow', p_parent_subflow 
    );
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
         , sbfl_dgrm_id
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
         , p_dgrm_id
         )
    returning sbfl_id into l_ret
    ;
    if p_new_proc_level then
        -- starting new subprocess.  Set sbfl_process_level to new sbfl_id
        update flow_subflows
           set sbfl_process_level = l_ret
         where sbfl_id = l_ret
        ;
    end if;
    apex_debug.info
    ( p_message => 'New Subflow started.  Process: %0 Subflow: %1'
    , p0        => p_process_id
    , p1        => l_ret 
    );
    return l_ret;
  end subflow_start;

  procedure flow_terminate_level
    ( p_process_id   in flow_processes.prcs_id%type
    , p_subflow_id   in flow_subflows.sbfl_id%type
    )
  is
    l_process_level   flow_subflows.sbfl_process_level%type;
  begin
    apex_debug.enter
    ( 'flow_terminate_level'
    , 'Process',  p_process_id
    , 'Subflow ', p_subflow_id
    );
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
    apex_debug.info ( 'Process %0 : All subflows at process level %1 terminated', p_process_id, l_process_level);
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
    apex_debug.enter
    ( 'subflow_complete'
    , 'Subflow' , p_subflow_id 
    );
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

  function lock_subflow
  ( p_subflow_id    in flow_subflows.sbfl_id%type
  ) return boolean
  is 
    l_sbfl_id   flow_subflows.sbfl_id%type;
  begin 

    apex_debug.enter 
    ( 'lock_subflow'
    , 'Subflow', p_subflow_id 
    );

    select sbfl.sbfl_id
      into l_sbfl_id
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
    for update of sbfl.sbfl_id wait 2
    ;
    return true;
  exception
    when no_data_found then
      return false;
    when lock_timeout then
      apex_error.add_error
      ( p_message => 'Unable to lock subflow '||p_subflow_id||'.  Select for update timed out'
      , p_display_location => apex_error.c_on_error_page
      );
  end lock_subflow;

end flow_engine_util;
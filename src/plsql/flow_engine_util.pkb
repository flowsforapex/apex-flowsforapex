create or replace package body flow_engine_util
as 
/* 
-- Flows for APEX - flow_engine_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  April-2021  Richard Allen (Flowquest) - from flow_engine.pkb
-- Modified 2022-07-18  Moritz Klein (MT AG)
--
*/
  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  g_step_keys_enforced    boolean;

  function get_config_value
  ( 
    p_config_key    in flow_configuration.cfig_key%type
  , p_default_value in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type
  as  
    l_config_value   flow_configuration.cfig_value%type;
  begin 
    select cfig.cfig_value
      into l_config_value
      from flow_configuration cfig
     where cfig.cfig_key = p_config_key
    ;
    return l_config_value;
  exception 
    when no_data_found then 
      return p_default_value;
  end get_config_value;

  procedure set_config_value
  (
    p_config_key in flow_configuration.cfig_key%type
  , p_value      in flow_configuration.cfig_value%type)
  as
  begin
    update flow_configuration
       set cfig_value = p_value
     where cfig_key = p_config_key;
  end set_config_value;

  function step_key
  ( pi_sbfl_id        in flow_subflows.sbfl_id%type default null
  , pi_current        in flow_subflows.sbfl_current%type default null
  , pi_became_current in flow_subflows.sbfl_became_current%type default null
  ) return flow_subflows.sbfl_step_key%type
  is
  begin

      return sys.dbms_random.string('A', 10);
  end step_key;

  function step_key_valid
  ( pi_prcs_id              in flow_processes.prcs_id%type
  , pi_sbfl_id              in flow_subflows.sbfl_id%type
  , pi_step_key_supplied    in flow_subflows.sbfl_step_key%type
  , pi_step_key_required    in flow_subflows.sbfl_step_key%type default null
  ) return boolean
  is 
    l_step_key_required   flow_subflows.sbfl_step_key%type := pi_step_key_required;
  begin
    if pi_step_key_required is null then

      select sbfl.sbfl_step_key
        into l_step_key_required
        from flow_subflows sbfl
       where sbfl.sbfl_id = pi_sbfl_id
         and sbfl.sbfl_prcs_id = pi_prcs_id
      ;
    end if;

    apex_debug.info 
    ( p_message => 'Step Key Required: %0  Step Key Supplied: %1'
    , p0 => l_step_key_required
    , p1 => pi_step_key_supplied
    );

    if pi_step_key_supplied = l_step_key_required then
      return true;
    elsif (pi_step_key_supplied is null 
           and not g_step_keys_enforced) then
      return true;
    else
      flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'step-key-incorrect'
      , p0 => nvl(pi_step_key_supplied, '"null"')
      , p1 => l_step_key_required
      );
      -- $F4AMESSAGE 'step-key-incorrect' || 'This Process Step has already occurred.  (Incorrect step key %0 supplied while exopecting step key %1).' 
      return false;
    end if;
  end step_key_valid;

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
  ) return flow_types_pkg.t_subflow_context
  is
    l_parent_subflow          flow_types_pkg.t_subflow_context;
    l_parent_subproc_activity flow_objects.objt_bpmn_id%type;
  begin

    select calling_sbfl.sbfl_id
         , calling_sbfl.sbfl_step_key
         , calling_sbfl.sbfl_scope
      into l_parent_subflow.sbfl_id
         , l_parent_subflow.step_key
         , l_parent_subflow.scope
      from flow_subflows calling_sbfl
      join flow_subflows called_sbfl
        on called_sbfl.sbfl_calling_sbfl = calling_sbfl.sbfl_id
       and called_sbfl.sbfl_prcs_id = calling_sbfl.sbfl_prcs_id
     where called_sbfl.sbfl_id = p_subflow_id
       and called_sbfl.sbfl_prcs_id = p_process_id
       ;
    return l_parent_subflow;
  exception
      when no_data_found then
        -- no subflow found running the parent process 
        return null;
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

  function get_object_subtag
  ( p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type  
  )
  return varchar2
  is
    l_objt_sub_tag_name  flow_objects.objt_bpmn_id%type;
  begin
    select objt.objt_sub_tag_name
      into l_objt_sub_tag_name
      from flow_objects objt
     where objt.objt_bpmn_id = p_objt_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id
       ;
    return l_objt_sub_tag_name;
  end get_object_subtag;

  function get_object_tag
  ( p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type  
  ) return flow_objects.objt_tag_name%type
  is
    l_objt_tag_name  flow_objects.objt_bpmn_id%type;
  begin
    select objt.objt_tag_name
      into l_objt_tag_name
      from flow_objects objt
     where objt.objt_bpmn_id = p_objt_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id
       ;
    return l_objt_tag_name;
  end get_object_tag;

  function get_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_lock_subflow  in boolean default false
  , p_lock_process  in boolean default false
  ) return flow_subflows%rowtype
  is 
    l_sbfl_rec          flow_subflows%rowtype;
    l_prcs_check_id     flow_processes.prcs_id%type;
  begin
    begin 
      if p_lock_process then
        begin
          select prcs.prcs_id
            into l_prcs_check_id
            from flow_processes prcs
          where prcs.prcs_id = p_process_id
          ;
        exception
          when no_data_found then
            flow_errors.handle_instance_error
            ( pi_prcs_id     => p_process_id
            , pi_sbfl_id     => p_subflow_id
            , pi_message_key => 'engine-util-prcs-not-found'
            , p0 => p_process_id
            );
            -- $F4AMESSAGE 'engine-util-prcs-not-found' || 'Application Error: Process ID %0 not found).'  
        end;
      end if;
      if p_lock_subflow then 
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        for update wait 2
        ;
      else 
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        ;
      end if;
    exception
      when no_data_found then
        -- check if subflow valid in process
        select sbfl.sbfl_prcs_id
          into l_prcs_check_id
          from flow_subflows sbfl
         where sbfl.sbfl_id = p_subflow_id
         ;
        if l_prcs_check_id != p_process_id then
          flow_errors.handle_instance_error
          ( pi_prcs_id     => p_process_id
          , pi_sbfl_id     => p_subflow_id
          , pi_message_key => 'engine-util-sbfl-not-in-prcs'
          , p0 => p_subflow_id
          , p1 => p_process_id
          );
          -- $F4AMESSAGE 'engine-util-sbfl-not-in-prcs' || 'Application Error: Subflow ID supplied ( %0 ) exists but is not child of Process ID Supplied ( %1 ).'  
        end if;
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => p_subflow_id
        , pi_message_key => 'timeout_locking_subflow'
        , p0 => p_subflow_id
        );
        -- $F4AMESSAGE 'timeout_locking_subflow' || 'Unable to lock subflow %0 as currently locked by another user.  Retry your transaction later.'  
    end;
    return l_sbfl_rec;
  exception
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_sbfl_id     => p_subflow_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => p_subflow_id
      );
      return null;
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
  end get_subflow_info;

  function subflow_start
    ( 
      p_process_id                in flow_processes.prcs_id%type
    , p_parent_subflow            in flow_subflows.sbfl_id%type
    , p_starting_object           in flow_objects.objt_bpmn_id%type
    , p_current_object            in flow_objects.objt_bpmn_id%type
    , p_route                     in flow_subflows.sbfl_route%type
    , p_last_completed            in flow_objects.objt_bpmn_id%type
    , p_status                    in flow_subflows.sbfl_status%type default flow_constants_pkg.gc_sbfl_status_running
    , p_parent_sbfl_proc_level    in flow_subflows.sbfl_process_level%type  --- can remove?
    , p_new_proc_level            in boolean default false
    , p_new_scope                 in boolean default false
    , p_new_diagram               in boolean default false
    , p_dgrm_id                   in flow_diagrams.dgrm_id%type
    ) return flow_types_pkg.t_subflow_context
  is 
    l_timestamp           flow_subflows.sbfl_became_current%type;
    l_process_level       flow_subflows.sbfl_process_level%type := p_parent_sbfl_proc_level;
    l_diagram_level       flow_subflows.sbfl_diagram_level%type := 0;
    l_new_subflow_context flow_types_pkg.t_subflow_context;
    l_lane                flow_objects.objt_bpmn_id%type;
    l_lane_name           flow_objects.objt_name%type;
    l_scope               flow_subflows.sbfl_scope%type := 0;
    l_level_parent        flow_subflows.sbfl_id%type := 0;
    l_is_new_level        varchar2(1 byte) := flow_constants_pkg.gc_false;
    l_is_new_scope        varchar2(1 byte) := flow_constants_pkg.gc_false;
  begin
    apex_debug.enter 
    ( 'subflow_start'
    , 'Process', p_process_id
    , 'Parent Subflow', p_parent_subflow 
    );
    
    -- convert boolean in parameters to varchar2 for use in SQL
    if p_new_proc_level then 
      l_is_new_level := 'Y';
    end if;

    if p_parent_subflow is  null then
    -- initial subflow in process.   Get starting Lane info. (could be null)

      select lane_objt.objt_bpmn_id
           , lane_objt.objt_name
        into l_lane
           , l_lane_name
        from flow_objects start_objt
   left join flow_objects lane_objt
          on start_objt.objt_objt_lane_id = lane_objt.objt_id
         and start_objt.objt_dgrm_id      = lane_objt.objt_dgrm_id
       where start_objt.objt_dgrm_id = p_dgrm_id
         and start_objt.objt_bpmn_id = p_starting_object
      ;
    else
    -- new subflow in existing process
    -- get process level, diagram level, scope, calling subflow for copy down unless this is the initial subflow in a process
      select sbfl.sbfl_process_level
           , sbfl.sbfl_diagram_level
           , sbfl.sbfl_scope
           , sbfl.sbfl_lane
           , sbfl.sbfl_lane_name
           , case l_is_new_level
                when 'Y' then p_parent_subflow  
                when 'N' then sbfl.sbfl_calling_sbfl
             end
        into l_process_level
           , l_diagram_level
           , l_scope
           , l_lane
           , l_lane_name
           , l_level_parent
        from flow_subflows sbfl
       where sbfl.sbfl_id = p_parent_subflow;
    end if;

    -- create the new subflow

    insert
      into flow_subflows
         ( sbfl_prcs_id
         , sbfl_sbfl_id
         , sbfl_process_level
         , sbfl_starting_object
         , sbfl_route
         , sbfl_last_completed
         , sbfl_became_current
         , sbfl_current
         , sbfl_status
         , sbfl_last_update
         , sbfl_dgrm_id
         , sbfl_diagram_level
         , sbfl_step_key
         , sbfl_calling_sbfl
         , sbfl_scope
         , sbfl_lane
         , sbfl_lane_name
         )
    values
         ( p_process_id
         , p_parent_subflow
         , l_process_level
         , p_starting_object
         , p_route
         , p_last_completed
         , systimestamp
         , p_current_object
         , p_status
         , systimestamp
         , p_dgrm_id
         , l_diagram_level
         , flow_engine_util.step_key
         , l_level_parent
         , l_scope
         , l_lane
         , l_lane_name
         )
    returning sbfl_id, sbfl_step_key, sbfl_route, sbfl_scope into l_new_subflow_context
    ;                                 

    if p_new_proc_level then
      -- starting new subprocess.  Reset sbfl_process_level to new sbfl_id (change on new subProcesss, callActivity)
      l_process_level := l_new_subflow_context.sbfl_id;

      if p_new_scope then
        -- starting new variable scope.  Reset sbfl_scope to new sbfl_id. (change on callActivity (maybe others later...iteration, etc.) )
        l_new_subflow_context.scope := l_new_subflow_context.sbfl_id;
      end if;

      if p_new_diagram then
        -- starting a new diagram.   set the diagram_level to new sbfl_id (change on new callActivity)
        l_diagram_level := l_new_subflow_context.sbfl_id;
      end if;

      update flow_subflows
         set sbfl_process_level   = l_process_level
           , sbfl_scope           = l_new_subflow_context.scope
           , sbfl_diagram_level   = l_diagram_level
       where sbfl_id = l_new_subflow_context.sbfl_id;

    end if;

    apex_debug.info
    ( p_message => 'New Subflow started.  Process: %0 Subflow: %1 Step Key: %2 Scope: %3 Lane: %4 ( %5 ).'
    , p0        => p_process_id
    , p1        => l_new_subflow_context.sbfl_id
    , p2        => l_new_subflow_context.step_key
    , p3        => l_new_subflow_context.scope
    , p4        => l_lane
    , p5        => l_lane_name
    );
    return l_new_subflow_context;
  end subflow_start;

  procedure terminate_level
    ( p_process_id    in flow_processes.prcs_id%type
    , p_process_level in flow_subflows.sbfl_process_level%type
    )
  is
  begin
    apex_debug.enter
    ( 'terminate_level'
    , 'Process',  p_process_id
    , 'Process Level', p_process_level
    );
    -- find any running subprocesses with parent at this level
    begin
      for child_proc_levels in (
        select distinct child_sbfl.sbfl_process_level
          from flow_subflows parent_sbfl
          join flow_subflows child_sbfl
            on parent_sbfl.sbfl_current = child_sbfl.sbfl_starting_object
         where parent_sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
           and parent_sbfl.sbfl_process_level = p_process_level
           and parent_sbfl.sbfl_prcs_id = p_process_id
      )
      loop
        terminate_level
        ( p_process_id     => p_process_id
        , p_process_level  => child_proc_levels.sbfl_process_level);
      end loop;
    end;
    -- end all subflows in the level
    delete from flow_subflows
    where sbfl_process_level = p_process_level 
      and sbfl_prcs_id = p_process_id
      ;
    apex_debug.info 
    ( p_message => 'Process %0 : All subflows at process level %1 terminated'
    , p0 => p_process_id
    , p1 => p_process_level
    );
  end terminate_level;

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
    l_sbfl_prcs_id   flow_subflows.sbfl_prcs_id%type;
  begin 

    apex_debug.enter 
    ( 'lock_subflow'
    , 'Subflow', p_subflow_id 
    );

    select sbfl.sbfl_prcs_id
      into l_sbfl_prcs_id
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
    for update wait 2
    ;
    return true;
  exception
    when no_data_found then
      return false;
    when lock_timeout then
      flow_errors.handle_instance_error
      ( pi_prcs_id => l_sbfl_prcs_id
      , pi_sbfl_id => p_subflow_id
      , pi_message_key => 'timeout_locking_subflow'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'timeout_locking_subflow' || 'Unable to lock subflow %0 as currently locked by another user.  Try again later.'
      return false;
  end lock_subflow;

  function get_scope
  (  p_process_id  in flow_processes.prcs_id%type
  ,  p_subflow_id  in flow_subflows.sbfl_id%type
  ) return flow_subflows.sbfl_scope%type
  is
    l_scope   flow_subflows.sbfl_scope%type;
  begin
    select sbfl_scope
      into l_scope
      from flow_subflows
     where sbfl_id = p_subflow_id
       and sbfl_prcs_id = p_process_id
    ;
    return l_scope;
  exception
    when no_data_found then 
    flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_sbfl_id     => p_subflow_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => p_subflow_id
      , p1 => p_process_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).' 
  end get_scope;

  function json_array_join
  (
    p_json_array in sys.json_array_t
  ) return clob
  as
    l_return clob;
  begin
    apex_debug.info( p_message => '-- Joing JSON Array to CLOB, size %0', p0 => p_json_array.get_size );
    for i in 0..p_json_array.get_size - 1 loop
      l_return := l_return || p_json_array.get_string( i ) || apex_application.lf;
    end loop;
    return l_return;
  end json_array_join;

  function json_array_join
  (
    p_json_array in clob
  ) return clob
  as
    l_json sys.json_array_t;
  begin
    apex_debug.info( p_message => '-- Got CLOB parsing to JSON_ARRAY_T' );
    l_json := sys.json_array_t.parse( p_json_array );
    return json_array_join( p_json_array => l_json );
  end json_array_join;


  -- initialise step key enforcement parameter

  begin
    g_step_keys_enforced :=  (  flow_engine_util.get_config_value
                                ( p_config_key => flow_constants_pkg.gc_config_dup_step_prevention
                                , p_default_value => flow_constants_pkg.gc_config_default_dup_step_prevention 
                                )
                                = flow_constants_pkg.gc_config_dup_step_prevention_strict
                             );

end flow_engine_util;
/

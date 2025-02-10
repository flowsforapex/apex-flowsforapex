create or replace package body flow_engine_util
as 
/* 
-- Flows for APEX - flow_engine_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Consulting Limited. 2024-2025
--
-- Created  April-2021  Richard Allen (Flowquest) - from flow_engine.pkb
-- Modified 2022-07-18  Moritz Klein (MT AG)
-- Modified 09-Jan-2024  Richard Allen, Flowquest Consulting
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
    p_config_key      in flow_configuration.cfig_key%type
  , p_value           in flow_configuration.cfig_value%type
  , p_update_if_set   in boolean default true
  )
  is
    l_exists      number;
  begin
    select count(cfig_key)
      into l_exists
      from flow_configuration
     where cfig_key = p_config_key;
    
    if l_exists > 0 and p_update_if_set then 
      update flow_configuration
         set cfig_value = p_value
       where cfig_key = p_config_key;
    elsif l_exists = 0 then
      insert into flow_configuration
      ( cfig_key
      , cfig_value
      )
      values
      ( p_config_key
      , p_value
      );
    end if;
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

function get_object_tag
( p_sbfl_info   in flow_subflows%rowtype
) return flow_objects.objt_tag_name%type
is
  l_objt_tag_name   flow_objects.objt_tag_name%type;
begin
  select objt.objt_tag_name
    into l_objt_tag_name
    from flow_objects objt
   where objt.objt_bpmn_id = p_sbfl_info.sbfl_current
     and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
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
          for update wait 2
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

  function get_iteration_type
  ( p_step_info         flow_types_pkg.flow_step_info
  ) return varchar2
  is
    l_iteration_type          varchar2(10);
    l_sequential              boolean;
    l_target_objt_attributes  sys.json_object_t;
    l_target_iter_attributes  sys.json_object_t;
    l_multi_attributes        sys.json_object_t;
  begin
    -- get loop characteristics
    l_target_objt_attributes := sys.json_object_t.parse(p_step_info.target_objt_attributes);
    apex_debug.message (p_message => '...l_target_objt_atributes: %0', p0 => l_target_objt_attributes.to_string);
    if l_target_objt_attributes.has('apex') then
      apex_debug.message (p_message => '...has apex');
      l_target_iter_attributes := l_target_objt_attributes.get_object('apex');
      if l_target_objt_attributes.get_object('apex').has('standardLoopCharacteristics') then
        apex_debug.message (p_message => '...has standardLoop');
        l_iteration_type := flow_constants_pkg.gc_iteration_loop;
      elsif l_target_objt_attributes.get_object('apex').has('multiInstanceLoopCharacteristics') then
        apex_debug.message (p_message => '...has multiIstanceLoop');
        l_multi_attributes := l_target_objt_attributes.get_object('apex').get_object('multiInstanceLoopCharacteristics');
        l_sequential := l_multi_attributes.get_boolean('isSequential');
        case l_sequential
        when true then
          l_iteration_type := flow_constants_pkg.gc_iteration_sequential;
        when false then
          l_iteration_type := flow_constants_pkg.gc_iteration_parallel;
        end case;
      end if;
    else 
      l_iteration_type := null;
    end if;
    apex_debug.message (p_message => '...Iteration Type: %0', p0 => l_iteration_type);
    return l_iteration_type;
  end get_iteration_type;

  function get_loop_counter
  ( pi_sbfl_id       in  flow_subflows.sbfl_id%type
  ) return flow_subflows.sbfl_loop_counter%type
  is
    l_loop_counter   flow_subflows.sbfl_loop_counter%type;
  begin
    select it.iter_loop_counter
      into l_loop_counter
      from flow_iterations it
      join flow_subflows s
        on s.sbfl_iter_id = it.iter_id
     where s.sbfl_id = pi_sbfl_id;
    apex_debug.message (p_message=>'--> get_loop_counter - value = %0', p0=> l_loop_counter);
    return l_loop_counter;
  exception
    when others then
      return null;
  end get_loop_counter;


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
    , p_follows_ebg               in boolean default false
    , p_loop_counter              in number default null
    , p_iteration_type            in flow_subflows.sbfl_iteration_type%type default null
    , p_loop_total_instances      in flow_subflows.sbfl_loop_total_instances%type default null
    , p_iteration_var             in flow_process_variables.prov_var_name%type default null
    , p_iteration_var_scope       in flow_subflows.sbfl_scope%type default null
    , p_iter_id                   in flow_iterations.iter_id%type default null    
    , p_iterated_object           in flow_iterated_objects.iobj_id%type default null                 
    ) return flow_types_pkg.t_subflow_context
  is 
    l_timestamp           flow_subflows.sbfl_became_current%type;
    l_process_level       flow_subflows.sbfl_process_level%type := p_parent_sbfl_proc_level;
    l_diagram_level       flow_subflows.sbfl_diagram_level%type := 0;
    l_new_subflow_context flow_types_pkg.t_subflow_context;
    l_lane                flow_objects.objt_bpmn_id%type;
    l_lane_name           flow_objects.objt_name%type;
    l_lane_isRole         flow_subflows.sbfl_lane_isRole%type;
    l_lane_role           flow_subflows.sbfl_lane_role%type;
    l_scope               flow_subflows.sbfl_scope%type := 0;
    l_level_parent        flow_subflows.sbfl_id%type := 0;
    l_is_new_level        varchar2(1 byte) := flow_constants_pkg.gc_false;
    l_is_new_scope        varchar2(1 byte) := flow_constants_pkg.gc_false;
    l_follows_ebg         flow_subflows.sbfl_is_following_ebg%type;
    l_new_iter_id         flow_iterations.iter_id%type;
  begin
    apex_debug.enter 
    ( '>>  subflow_start'
    , 'Process', p_process_id
    , 'Parent Subflow', p_parent_subflow 
    , 'Loop Counter', p_loop_counter
    );
    
    -- convert boolean in parameters to varchar2 for use in SQL
    if p_new_proc_level then 
      l_is_new_level := flow_constants_pkg.gc_true;
    end if;
    if p_follows_ebg then
      l_follows_ebg := flow_constants_pkg.gc_true;
    end if;

    if p_parent_subflow is  null then
    -- initial subflow in process.   Get starting Lane info. (could be null)
    -- database 23.3 bug 35862529 means this will return NDF if there are no lanes so we handle (ignore) the NDF
      begin
        select lane_objt.objt_bpmn_id
             , lane_objt.objt_name
             , lane_objt.objt_attributes."apex"."isRole"
             , lane_objt.objt_attributes."apex"."role"
          into l_lane
             , l_lane_name
             , l_lane_isRole
             , l_lane_role
          from flow_objects start_objt
          left join flow_objects lane_objt
            on start_objt.objt_objt_lane_id = lane_objt.objt_id
           and start_objt.objt_dgrm_id      = lane_objt.objt_dgrm_id
         where start_objt.objt_dgrm_id = p_dgrm_id
           and start_objt.objt_bpmn_id = p_starting_object
        ;
      exception
        when no_data_found then
          null;
      end;
    else
    -- new subflow in existing process
    -- get process level, diagram level, scope, calling subflow for copy down unless this is the initial subflow in a process
      select sbfl.sbfl_process_level
           , sbfl.sbfl_diagram_level
           , sbfl.sbfl_scope
           , sbfl.sbfl_lane
           , sbfl.sbfl_lane_name
           , sbfl.sbfl_lane_isRole
           , sbfl.sbfl_lane_role
           , case l_is_new_level
                when 'Y' then p_parent_subflow  
                when 'N' then sbfl.sbfl_calling_sbfl
             end 
           , coalesce(p_iter_id, sbfl_iter_id)
        into l_process_level
           , l_diagram_level
           , l_scope
           , l_lane
           , l_lane_name
           , l_lane_isRole
           , l_lane_role
           , l_level_parent
           , l_new_iter_id
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
         , sbfl_last_update_by
         , sbfl_dgrm_id
         , sbfl_diagram_level
         , sbfl_step_key
         , sbfl_calling_sbfl
         , sbfl_scope
         , sbfl_lane
         , sbfl_lane_name
         , sbfl_lane_isRole
         , sbfl_lane_role
         , sbfl_is_following_ebg
         , sbfl_loop_counter
         , sbfl_iteration_type
         , sbfl_loop_total_instances
         , sbfl_iteration_var
         , sbfl_iteration_var_scope
         , sbfl_iter_id
         , sbfl_iobj_id
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
         , coalesce ( sys_context('apex$session','app_user') 
                    , sys_context('userenv','os_user')
                    , sys_context('userenv','session_user')
                    )  
         , p_dgrm_id
         , l_diagram_level
         , flow_engine_util.step_key
         , l_level_parent
         , l_scope
         , l_lane
         , l_lane_name
         , l_lane_isRole
         , l_lane_role
         , l_follows_ebg
         , p_loop_counter
         , p_iteration_type
         , p_loop_total_instances 
         , p_iteration_var
         , p_iteration_var_scope
         , l_new_iter_id  
         , p_iterated_object         
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
    ( p_message => '... New Subflow started.  Process: %0 Subflow: %1 Step Key: %2 Scope: %3 Lane: %4 ( %5 ) LoopCounter: %6. Iter_id: %7'
    , p0        => p_process_id
    , p1        => l_new_subflow_context.sbfl_id
    , p2        => l_new_subflow_context.step_key
    , p3        => l_new_subflow_context.scope
    , p4        => l_lane
    , p5        => l_lane_name
    , p6        => p_loop_counter
    , p7        => l_new_iter_id
    );
    return l_new_subflow_context;
  end subflow_start;

  procedure terminate_level
    ( p_process_id    in flow_processes.prcs_id%type
    , p_process_level in flow_subflows.sbfl_process_level%type
    )
  is
    l_apex_task_id  number;
  begin
    apex_debug.enter
    ( '>> terminate_level'
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
           and parent_sbfl.sbfl_prcs_id = child_sbfl.sbfl_prcs_id
           and parent_sbfl.sbfl_id      = child_sbfl.sbfl_calling_sbfl
--         where parent_sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_subprocess
         where parent_sbfl.sbfl_status in ( flow_constants_pkg.gc_sbfl_status_in_subprocess
                                          , flow_constants_pkg.gc_sbfl_status_in_callactivity 
                                          , flow_constants_pkg.gc_sbfl_status_iterating)
           and parent_sbfl.sbfl_process_level = p_process_level
           and parent_sbfl.sbfl_prcs_id = p_process_id
      )
      loop
        terminate_level
        ( p_process_id     => p_process_id
        , p_process_level  => child_proc_levels.sbfl_process_level);
      end loop;
    end;
    -- end all subflows in this level

      -- first check if any subflows have current tasks that running external tasks, e,g., APEX approvals
      begin
        for subflows_with_tasks in (
          select sbfl.sbfl_id
               , sbfl.sbfl_current
               , sbfl.sbfl_scope
               , sbfl.sbfl_dgrm_id
               , sbfl.sbfl_apex_task_id
               , sbfl.sbfl_apex_business_admin
               , objt.objt_tag_name
               , objt.objt_sub_tag_name
               , objt.objt_attributes."taskType" tasktype
            from flow_subflows sbfl
            join flow_objects objt
              on sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
             and sbfl.sbfl_current = objt.objt_bpmn_id
           where sbfl.sbfl_prcs_id = p_process_id
             and sbfl.sbfl_process_level = p_process_level
             and objt.objt_tag_name in ( flow_constants_pkg.gc_bpmn_usertask
                                       , flow_constants_pkg.gc_bpmn_receiveTask
                                       , flow_constants_pkg.gc_bpmn_intermediate_catch_event )
        )
        loop
          -- clear any approval tasks 
          case subflows_with_tasks.tasktype 
          when flow_constants_pkg.gc_apex_usertask_apex_approval then
            -- cancel apex workflow task
            flow_usertask_pkg.cancel_apex_task
            ( p_process_id          => p_process_id
            , p_objt_bpmn_id        => subflows_with_tasks.sbfl_current
            , p_dgrm_id             => subflows_with_tasks.sbfl_dgrm_id
            , p_apex_task_id        => subflows_with_tasks.sbfl_apex_task_id
            , p_apex_business_admin => subflows_with_tasks.sbfl_apex_business_admin
            );
          when flow_constants_pkg.gc_simple_message then
            flow_message_util.cancel_subscription ( p_process_id  => p_process_id 
                                                  , p_subflow_id  => subflows_with_tasks.sbfl_id
                                                  );
          else
            null;
          end case;
        end loop;
      end;

     -- then delete the subflows
    delete from flow_subflows
    where sbfl_process_level = p_process_level 
      and sbfl_prcs_id = p_process_id
      ;
    apex_debug.info 
    ( p_message => '... Process %0 : All subflows at process level %1 terminated'
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
    l_current_subflow_process_level   flow_subflows.sbfl_process_level%type;
    l_parent_subflow_id               flow_subflows.sbfl_sbfl_id%type;
    l_parent_subflow_status           flow_subflows.sbfl_status%type;
    l_parent_subflow_last_completed   flow_subflows.sbfl_last_completed%type;
    l_parent_subflow_current          flow_subflows.sbfl_current%type;
  begin
    apex_debug.enter
    ( '>> subflow_complete'
    , 'Subflow' , p_subflow_id 
    );
    select sbfl.sbfl_sbfl_id
         , sbfl.sbfl_current
         , sbfl.sbfl_status
         , sbfl.sbfl_process_level
      into l_parent_subflow_id
         , l_current_object
         , l_current_subflow_status
         , l_current_subflow_process_level
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
         and sbfl.sbfl_process_level   = l_current_subflow_process_level
      ;
      
      if (   l_remaining_siblings = 0
         and l_parent_subflow_status =  flow_constants_pkg.gc_sbfl_status_split    
         and l_current_subflow_status not in ( flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                             , flow_constants_pkg.gc_sbfl_status_waiting_iter )
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
    ( '>> lock_subflow'
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

  procedure lock_all_for_process 
  ( p_process_id  in    flow_processes.prcs_id%type
  ) 
  is
    cursor c_lock_all is 
        select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg_id
          from flow_subflows sbfl
          join flow_processes prcs
            on prcs.prcs_id = sbfl.sbfl_prcs_id 
          join flow_subflow_log sflg 
            on prcs.prcs_id = sflg.sflg_prcs_id
          join flow_instance_diagrams prdg
            on prcs.prcs_id = prdg.prdg_prcs_id
          where prcs.prcs_id = p_process_id
          order by sbfl.sbfl_process_level, sbfl.sbfl_id
            for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id wait 2
    ;
  begin
    apex_debug.enter
    ( '>> lock all_for_process'
    , 'process_id', p_process_id
    );
    -- lock all objects
    begin
      open c_lock_all;
      flow_timers_pkg.lock_process_timers ( pi_prcs_id => p_process_id );  
      flow_message_util.lock_instance_subscriptions ( p_process_id => p_process_id );
      close c_lock_all;
    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
        raise;
    end;
  end lock_all_for_process;


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
    apex_debug.info( p_message => '-- Joining JSON Array to CLOB, size %0', p0 => p_json_array.get_size );
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
    if p_json_array is not null then
      apex_debug.info( p_message => '-- Got CLOB parsing to JSON_ARRAY_T' );
      l_json := sys.json_array_t.parse( p_json_array );
      return json_array_join( p_json_array => l_json );
    else
      return null;
    end if;
  end json_array_join;

  function apex_json_array_join
  ( p_json_array in apex_t_varchar2
  )
  return clob
  is 
    l_return clob;
  begin
    apex_debug.info( p_message => '-- Joining APEX JSON Array to vc2, size %0', p0 => p_json_array.count );

    l_return := apex_string.join_clob( p_table => p_json_array );

    apex_debug.info( p_message => '-- returned string', p0 => l_return);
    return l_return;
  end apex_json_array_join;

  function clob_to_blob
  ( 
    pi_clob in clob
  ) return blob
  as
  $if flow_apex_env.ver_le_22_1 $then
    l_blob   blob;
    l_dstoff pls_integer := 1;
    l_srcoff pls_integer := 1;
    l_lngctx pls_integer := 0;
    l_warn   pls_integer;
  $end
  begin

  $if flow_apex_env.ver_le_22_1 $then
    sys.dbms_lob.createtemporary
    ( lob_loc => l_blob
    , cache   => true
    , dur     => sys.dbms_lob.call
    );    

    sys.dbms_lob.converttoblob
    ( dest_lob     => l_blob
    , src_clob     => pi_clob
    , amount       => sys.dbms_lob.lobmaxsize
    , dest_offset  => l_dstoff
    , src_offset   => l_srcoff
    , blob_csid    => nls_charset_id( 'AL32UTF8' )
    , lang_context => l_lngctx
    , warning      => l_warn
    );

    return l_blob;
  $else
    return apex_util.clob_to_blob( p_clob => pi_clob );
  $end

  end clob_to_blob;


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

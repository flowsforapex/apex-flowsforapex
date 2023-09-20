/* 
-- Flows for APEX - issue-681.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright MT AG, 2021-2022.
--
-- This hot fix file can be applied to Flows for APEX v 23.1 only
-- This file addresses Flows for APEX issue 681 (see https://github.com/flowsforapex/apex-flowsforapex/issues/681)
__ This fix addresses the following issues:
--   1) adds logging of step priotity and due date information into the step Event Log (flow_step_event_log)
--   2) adds column for step_key to the subflow log table (flow_subflow_log)
--   3) adds column for step_key to the stepflow event log (flow_step_event_log)
--   4) adds logging of task priority and due date into the step event log
--   5) emits the step step key, priority, and due date into the JSON instance summary document.
--
-- Created 20-Sep-2023  Richard Allen (Oracle)  
--
*/

PROMPT >> Create Task ID by adding Step Key to logs if not present

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_STEP_KEY'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log add (sflg_step_key VARCHAR2(20 CHAR))';
  end if;
end;
/

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGSF_STEP_KEY'
     and upper(table_name)  = 'FLOW_STEP_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_step_event_log add (lgsf_step_key VARCHAR2(20 CHAR))';
  end if;
end;
/

PROMPT >> Updating flow_logging package

create or replace package body flow_logging as
/* 
-- Flows for APEX - flow_logging.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created 29-Jul-2021  Richard Allen (Flowquest) for  MT AG
-- Updated 10-Feb-2023  Richard Allen (Oracle)  
--
*/
  g_logging_level           flow_configuration.cfig_value%type; 
  g_logging_hide_userid     flow_configuration.cfig_value%type;

  procedure log_diagram_event
  ( p_dgrm_id           in flow_diagrams.dgrm_id%type
  , p_dgrm_name         in flow_diagrams.dgrm_name%type default null
  , p_dgrm_version      in flow_diagrams.dgrm_version%type default null
  , p_dgrm_status       in flow_diagrams.dgrm_status%type default null
  , p_dgrm_category     in flow_diagrams.dgrm_category%type default null
  , p_dgrm_content      in flow_diagrams.dgrm_content%type default null
  , p_comment           in flow_flow_event_log.lgfl_comment%type default null
  )
  is
    l_log_dgrm_content  boolean;
    l_diagram_location  flow_flow_event_log.lgfl_dgrm_archive_location%type;
    l_dgrm_name         flow_diagrams.dgrm_name%type;
    l_dgrm_version      flow_diagrams.dgrm_version%type;
    l_dgrm_status       flow_diagrams.dgrm_status%type;
    l_dgrm_category     flow_diagrams.dgrm_category%type;
  begin
    apex_debug.enter('Log diagram event');
    if g_logging_level in ( flow_constants_pkg.gc_config_logging_level_secure
                          , flow_constants_pkg.gc_config_logging_level_full
                          ) 
    then
      if p_dgrm_content is not null and coalesce(p_dgrm_status, 'X') != flow_constants_pkg.gc_dgrm_status_draft then
        l_log_dgrm_content := true;
        -- copy the new bpmn content to the bpmn archive (table or OCI object storage)
        l_diagram_location := flow_log_admin.archive_bpmn_diagram ( p_dgrm_id       => p_dgrm_id
                                                                  , p_dgrm_content  => p_dgrm_content
                                                                  );
      end if;

      begin
        select 
            coalesce(p_dgrm_name, dgrm_name)
          , coalesce(p_dgrm_version, dgrm_version)
          , coalesce(p_dgrm_status, dgrm_status)
          , coalesce(p_dgrm_category, dgrm_category)
          into l_dgrm_name, l_dgrm_version, l_dgrm_status, l_dgrm_category
          from flow_diagrams
        where dgrm_id = p_dgrm_id;
      exception 
        when no_data_found then
          l_dgrm_name     := p_dgrm_name;
          l_dgrm_version  := p_dgrm_version;
          l_dgrm_status   := p_dgrm_status;
          l_dgrm_category := p_dgrm_category;
      end;

      insert into flow_flow_event_log
      ( lgfl_dgrm_id
      , lgfl_dgrm_name
      , lgfl_dgrm_version
      , lgfl_dgrm_status
      , lgfl_dgrm_category
      , lgfl_dgrm_archive_location
      , lgfl_user
      , lgfl_comment
      , lgfl_timestamp
      )
      values
      ( p_dgrm_id
      , l_dgrm_name
      , l_dgrm_version
      , l_dgrm_status
      , l_dgrm_category
      , l_diagram_location
      , coalesce  ( sys_context('apex$session','app_user') 
                  , sys_context('userenv','os_user')
                  , sys_context('userenv','session_user')
                  ) 
      , p_comment
      , systimestamp at time zone 'UTC'
      );
    end if;
  exception
    when others then
      flow_errors.handle_general_error
      ( pi_message_key => 'logging-diagram-event'
      );
      -- $F4AMESSAGE 'logging-diagram-event' || 'Flows - Internal error while logging a Diagram Event'
      raise;
  end log_diagram_event;

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_objt_bpmn_id      in flow_objects.objt_bpmn_id%type default null
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
  , p_error_info        in flow_instance_event_log.lgpr_error_info%type default null
  )
  is 
  begin 
    if g_logging_level in ( flow_constants_pkg.gc_config_logging_level_standard 
                          , flow_constants_pkg.gc_config_logging_level_secure
                          , flow_constants_pkg.gc_config_logging_level_full
                          ) 
    then
      insert into flow_instance_event_log
      ( lgpr_prcs_id 
      , lgpr_objt_id
      , lgpr_dgrm_id 
      , lgpr_prcs_name 
      , lgpr_business_id
      , lgpr_prcs_event
      , lgpr_timestamp
      , lgpr_duration 
      , lgpr_user 
      , lgpr_comment
      , lgpr_error_info
      )
      select prcs.prcs_id
          , p_objt_bpmn_id
          , prcs.prcs_dgrm_id
          , prcs.prcs_name
          , flow_proc_vars_int.get_business_ref (p_process_id)  --- 
          , p_event
          , systimestamp 
          , case p_event
            when flow_constants_pkg.gc_prcs_event_completed then
              prcs.prcs_complete_ts - prcs.prcs_start_ts
            when flow_constants_pkg.gc_prcs_event_terminated then
              prcs.prcs_complete_ts - prcs.prcs_start_ts
            else
              null
            end
          , case g_logging_hide_userid 
            when 'true' then 
              null
            else 
              coalesce  ( sys_context('apex$session','app_user') 
                        , sys_context('userenv','os_user')
                        , sys_context('userenv','session_user')
                        )  
            end 
          , p_comment
          , p_error_info
        from flow_processes prcs 
      where prcs.prcs_id = p_process_id
      ;
    end if;
  exception
    when others then
      flow_errors.handle_general_error
      ( pi_message_key => 'logging-instance-event'
      );
      -- $F4AMESSAGE 'logging-instance-event' || 'Flows - Internal error while logging an Instance Event'
      raise;
  end log_instance_event;

  procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type default null
  )
  is 
  begin
    -- current instance status / progress logging
    insert into flow_subflow_log sflg
    ( sflg_prcs_id
    , sflg_objt_id
    , sflg_sbfl_id
    , sflg_step_key
    , sflg_last_updated
    , sflg_dgrm_id
    , sflg_diagram_level
    , sflg_notes
    )
    select p_process_id
         , p_completed_object
         , p_subflow_id
         , sbfl.sbfl_step_key
         , sysdate
         , sbfl.sbfl_dgrm_id
         , sbfl.sbfl_diagram_level
         , p_notes
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
    ;

    -- system event logging
    if g_logging_level in ( flow_constants_pkg.gc_config_logging_level_standard 
                          , flow_constants_pkg.gc_config_logging_level_secure
                          , flow_constants_pkg.gc_config_logging_level_full
                          ) 
    then
      insert into flow_step_event_log
      ( lgsf_prcs_id 
      , lgsf_objt_id 
      , lgsf_sbfl_id 
      , lgsf_step_key
      , lgsf_sbfl_process_level
      , lgsf_last_completed
      , lgsf_status_when_complete
      , lgsf_sbfl_dgrm_id
      , lgsf_was_current 
      , lgsf_started 
      , lgsf_completed
      , lgsf_reservation
      , lgsf_due_on
      , lgsf_priority
      , lgsf_user
      , lgsf_comment
      )
      select sbfl.sbfl_prcs_id
           , p_completed_object
           , sbfl.sbfl_id
           , sbfl.sbfl_step_key
           , sbfl.sbfl_process_level
           , sbfl.sbfl_last_completed
           , sbfl.sbfl_status
           , sbfl.sbfl_dgrm_id
           , sbfl.sbfl_became_current
           , sbfl.sbfl_work_started
           , systimestamp
           , sbfl.sbfl_reservation
           , sbfl.sbfl_due_on
           , sbfl.sbfl_priority
          , case g_logging_hide_userid 
            when 'true' then 
              null
            else 
              coalesce  ( sys_context('apex$session','app_user') 
                        , sys_context('userenv','os_user')
                        , sys_context('userenv','session_user')
                        )  
            end 
           , p_notes        
        from flow_subflows sbfl 
       where sbfl.sbfl_id = p_subflow_id
      ;
    end if;
  exception
    when others then
      flow_errors.handle_general_error
      ( pi_message_key => 'logging-step-event'
      );
      -- $F4AMESSAGE 'logging-step-event' || 'Flows - Internal error while logging a Step Event'
      raise;
  end log_step_completion;

  procedure log_variable_event -- logs process variable set events
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_scope             in flow_process_variables.prov_scope%type
  , p_var_name          in flow_process_variables.prov_var_name%type
  , p_objt_bpmn_id      in flow_objects.objt_bpmn_id%type default null
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type default null
  , p_expr_set          in flow_object_expressions.expr_set%type default null
  , p_var_type          in flow_process_variables.prov_var_type%type
  , p_var_vc2           in flow_process_variables.prov_var_vc2%type default null
  , p_var_num           in flow_process_variables.prov_var_num%type default null
  , p_var_date          in flow_process_variables.prov_var_date%type default null
  , p_var_clob          in flow_process_variables.prov_var_clob%type default null
  , p_var_tstz            in flow_process_variables.prov_var_tstz%type default null
  )
  as 
  begin 
    if g_logging_level in (  flow_constants_pkg.gc_config_logging_level_full ) then
      insert into flow_variable_event_log
      ( lgvr_prcs_id  
      , lgvr_scope
      , lgvr_var_name	  
      , lgvr_objt_id	  
      , lgvr_sbfl_id	  
      , lgvr_expr_set	  
      , lgvr_timestamp  
      , lgvr_var_type	  
      , lgvr_var_vc2 	  
      , lgvr_var_num  
      , lgvr_var_date   
      , lgvr_var_clob   
      , lgvr_var_tstz  
      )
      values
      ( p_process_id
      , p_scope
      , p_var_name          
      , p_objt_bpmn_id    
      , p_subflow_id 
      , p_expr_set 
      , systimestamp
      , p_var_type 
      , p_var_vc2 
      , p_var_num  
      , p_var_date 
      , p_var_clob  
      , p_var_tstz 
      );
    end if;
  exception
    when others then
      flow_errors.handle_general_error
      ( pi_message_key => 'logging-variable-event'
      );
      -- $F4AMESSAGE 'logging-variable-event' || 'Flows - Internal error while logging a Variable Event'
      raise;
  end log_variable_event;

  -- initialize logging parameters

  begin 
    g_logging_level := flow_engine_util.get_config_value
                       ( p_config_key => flow_constants_pkg.gc_config_logging_level
                       , p_default_value => flow_constants_pkg.gc_config_default_logging_level
                       );
    g_logging_hide_userid := lower (flow_engine_util.get_config_value
                                      ( p_config_key => flow_constants_pkg.gc_config_logging_hide_userid 
                                      , p_default_value => flow_constants_pkg.gc_config_default_logging_hide_userid 
                                      )
                                   );
  
    apex_debug.message ( p_message  => 'Logging level: %0'
                       , p0         => g_logging_level
                       , p_level    => 4 
                       );
end flow_logging;
/

PROMPT >> Updating flow_log_admin package

create or replace package body flow_log_admin as
  /* 
  -- Flows for APEX - flow_log_admin.pkb
  -- 
  -- (c) Copyright Oracle Corporation and / or its affiliates, 2023.

  --
  -- Created    18-Feb-2021  Richard Allen (Oracle)
  --
  -- Package flow_log_admin manaes the Flows for APEX log tables, including
  --    - creation of instance archive summary
  --    - archiving of instance logs
  --    - purging of instance log tables 
  */  

  type t_archive_location is record
  ( destination_type               flow_types_pkg.t_vc200
  , db_table_name                  flow_types_pkg.t_vc200
  , db_id_column                   flow_types_pkg.t_vc200
  , db_timestamp_column            flow_types_pkg.t_vc200
  , db_blob_column                 flow_types_pkg.t_vc200
  , oci_base_url                   flow_types_pkg.t_vc200
  , oci_bucket_name                flow_types_pkg.t_vc200
  , oci_document_prefix            flow_types_pkg.t_vc200
  , oci_request_url                flow_types_pkg.t_vc200  -- url to use for request
  , oci_credential_static_id       flow_types_pkg.t_vc200  -- APEX Static ID of Credential
  );


  function get_instance_json_summary
  ( p_process_id     in flow_processes.prcs_id%type
  ) return clob
  is
    l_archive_json    clob;
  begin
    with p as
       (  select prcs_id
               , prcs_dgrm_id
               , prcs_name
               , prcs_priority
               , prcs_status
               , prcs_init_ts
               , prcs_init_by
               , prcs_due_on
          from   flow_processes prcs
          where  prcs_id = p_process_id               
      ),
     s as
        ( select distinct sc.lgvr_scope scope, sc.lgvr_prcs_id
          from   flow_variable_event_log sc
        )
    select json_object (
       'processID'    value p.prcs_id,
       'mainDiagram'  value p.prcs_dgrm_id,
       'processName'  value p.prcs_name,
       'businessID'   value prov.prov.prov_var_vc2,
       'priority'     value p.prcs_priority,
       'prcs_status'  value p.prcs_status,
       'prcs_init_ts' value p.prcs_init_ts,
       'prcs_init_by' value p.prcs_init_by,
       'prcs_due_on'  value p.prcs_due_on,
       'json_created' value systimestamp,
       'diagramsUsed' value
            (select json_arrayagg 
                       ( json_object 
                           (
                           'diagramLevel'               value prdg_diagram_level,
                           'diagramId'                  value prdg_dgrm_id,
                           'diagramName'                value dgrm_name,
                           'diagramVersion'             value dgrm_version,
                           'diagramStatus'              value dgrm_status,
                           'callingDiagram'             value prdg_calling_dgrm,
                           'callingObject'              value prdg_calling_objt
                           ) order by prdg_diagram_level asc 
                       returning clob)
               from flow_instance_diagrams prdg
               join flow_diagrams dgrm
                 on dgrm.dgrm_id = prdg.prdg_dgrm_id
              where prdg.prdg_prcs_id = p.prcs_id   
           ),
       'events' : 
           (select json_arrayagg 
                       ( json_object 
                           (
                           'event'                      value lgpr_prcs_event,
                           'object'                     value lgpr_objt_id,
                           'diagram'                    value lgpr_dgrm_id,
                           'timestamp'                  value lgpr_timestamp,
                           'user'                       value lgpr_user,
                           'error-info'                 value lgpr_error_info,
                           'comment'                    value lgpr_comment absent on null
                           ) order by lgpr_timestamp 
                        returning clob )
              from flow_instance_event_log lgpr
             where lgpr.lgpr_prcs_id = p.prcs_id
           ),       
       'steps' :
           (select json_arrayagg
                       (json_object 
                           (
                           'object'                     value lgsf_objt_id,
                           'subflowID'                  value lgsf_sbfl_id,
                           'stepKey'                    value lgsf_step_key,
                           'processLevel'               value lgsf_sbfl_process_level,
                           'priority'                   value lgsf_priority,
                           'lastCompleted'              value lgsf_last_completed,
                           'wasCurrent'                 value lgsf_was_current,
                           'wasStarted'                 value lgsf_started,
                           'wasCompleted'               value lgsf_completed,
                           'statusWhenComplete'         Value lgsf_status_when_complete,
                           'subflowDiagram'             value lgsf_sbfl_dgrm_id,
                           'reservation'                value lgsf_reservation,
                           'priority'                   value lgsf_priority,
                           'dueOn'                      value lgsf_due_on,
                           'user'                       value lgsf_user,
                           'comment'                    value lgsf_comment absent on null
                           ) order by lgsf_was_current
                       returning clob )
             from flow_step_event_log lgsf
            where lgsf.lgsf_prcs_id = p.prcs_id
            ),
       'processVariablesSet' :
               (  select json_arrayagg (
                       json_object (
                           'scope'         value s.scope,
                           'variables'     value
                               ( select json_arrayagg 
                                           (
                                           json_object 
                                               (
                                               'var_name'        value lgvr.lgvr_var_name,
                                               'subflowID'       value lgvr.lgvr_sbfl_id,
                                               'objectId'        value lgvr.lgvr_objt_id,
                                               'expr_set'        value lgvr.lgvr_expr_set,
                                               'type'            value lgvr.lgvr_var_type,
                                               'timestamp'       value lgvr.lgvr_timestamp,
                                               'newValue'        value case lgvr.lgvr_var_type
                                                          when 'VARCHAR2'                   then lgvr.lgvr_var_vc2
                                                          when 'NUMBER'                     then to_char(lgvr.lgvr_var_num)
                                                          when 'DATE'                       then to_char(lgvr.lgvr_var_date,'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                                                          when 'TIMESTAMP WITH TIME ZONE'   then to_char(lgvr.lgvr_var_tstz,'YYYY-MM-DD"T"HH24:MI:SSTZR')
                                                          when 'CLOB'                       then 'CLOB Value'
                                                          end 
                                               )
                                           order by lgvr.lgvr_timestamp 
                                           returning clob )
                                   from flow_variable_event_log lgvr
                                  where lgvr.lgvr_prcs_id = p.prcs_id
                                    and lgvr.lgvr_scope   = s.scope
                               ) returning clob
                           )
                       returning clob )
                   from s
                  where s.lgvr_prcs_id = p.prcs_id
               )
           returning clob )
     into l_archive_json
     from p 
     left join flow_process_variables prov
       on prov.prov_prcs_id    = p.prcs_id
      and prov.prov_var_name   = 'BUSINESS_REF'
      and prov.prov_scope      = 0
    ;
    return l_archive_json;
  end get_instance_json_summary;

  procedure purge_instance_logs
  ( p_retention_period_days  in number default null
  )
  is
    l_log_retain_days    flow_configuration.cfig_value%type;
    l_purge_interval     interval day(4) to second(0);
  begin
    apex_debug.enter ('purge_instance_logs'
    , 'p_retention_period_days', p_retention_period_days);

    -- if retention period not specified, get configuration parameter or default
    if p_retention_period_days is null then
      l_log_retain_days     := flow_engine_util.get_config_value 
                               ( p_config_key  => flow_constants_pkg.gc_config_logging_retain_logs
                               , p_default_value  => flow_constants_pkg.gc_config_default_log_retain_logs
                               );   
      l_purge_interval   := to_dsinterval ('P'||trim( both from l_log_retain_days)||'D');
    else
      l_purge_interval   := to_dsinterval ('P'||trim( both from p_retention_period_days)||'D');   
    end if;
    -- delete
    delete from flow_variable_event_log
    where lgvr_prcs_id in (select lgpr_prcs_id
                           from   flow_instance_event_log
                           where  lgpr_prcs_event = flow_constants_pkg.gc_prcs_event_completed
                           and    lgpr_timestamp < systimestamp - l_purge_interval);


    delete from flow_step_event_log
    where lgsf_prcs_id in (select lgpr_prcs_id
                           from   flow_instance_event_log
                           where  lgpr_prcs_event = flow_constants_pkg.gc_prcs_event_completed
                           and    lgpr_timestamp < systimestamp - l_purge_interval);

    delete from flow_instance_event_log
    where lgpr_prcs_id in (select lgpr_prcs_id
                           from   flow_instance_event_log
                           where  lgpr_prcs_event = flow_constants_pkg.gc_prcs_event_completed
                           and    lgpr_timestamp < systimestamp - l_purge_interval);

    flow_log_admin.purge_message_logs(p_retention_period_days => p_retention_period_days);

    flow_log_admin.purge_rest_logs(p_retention_period_days => p_retention_period_days);

  end purge_instance_logs;

  procedure purge_message_logs
  ( p_retention_period_days    in number default null
  )
  is
    l_log_retain_days    flow_configuration.cfig_value%type;
    l_purge_interval     interval day(4) to second(0);
  begin
    apex_debug.enter ('purge_message_logs'
    , 'p_retention_period_days', p_retention_period_days);

    -- if retention period not specified, get configuration parameter or default
    if p_retention_period_days is null then
      l_log_retain_days     := flow_engine_util.get_config_value 
                               ( p_config_key  => flow_constants_pkg.gc_config_logging_retain_msg_flow 
                               , p_default_value  => flow_constants_pkg.gc_config_default_log_retain_msg_flow_logs
                               );   
      l_purge_interval   := to_dsinterval ('P'||trim( both from l_log_retain_days)||'D');
    else
      l_purge_interval   := to_dsinterval ('P'||trim( both from p_retention_period_days)||'D');   
    end if;

    delete from flow_message_received_log
    where lgrx_received_on < systimestamp - l_purge_interval;

  end purge_message_logs;

  procedure purge_rest_logs
  ( p_retention_period_days    in number default null
  )
  is
    l_log_retain_days    flow_configuration.cfig_value%type;
    l_purge_interval     interval day(4) to second(0);
  begin
    apex_debug.enter ('purge_rest_logs'
    , 'p_retention_period_days', p_retention_period_days);

    -- if retention period not specified, get configuration parameter or default
    if p_retention_period_days is null then
      l_log_retain_days     := flow_engine_util.get_config_value 
                               ( p_config_key  => flow_rest_logging.c_log_rest_incoming_retain_days
                               , p_default_value  => flow_rest_logging.c_log_rest_incoming_retain_days_default
                               );   
      l_purge_interval   := to_dsinterval ('P'||trim( both from l_log_retain_days)||'D');
    else
      l_purge_interval   := to_dsinterval ('P'||trim( both from p_retention_period_days)||'D');   
    end if;

    delete from flow_rest_event_log
    where lgrt_timestamp < systimestamp - l_purge_interval;

  end purge_rest_logs;

  function get_archive_location
  ( p_archive_type   in varchar2
  )
  return t_archive_location
  is
    l_archive_location              t_archive_location;
    e_archive_bad_destination_json  exception;
    l_destination_json              flow_configuration.cfig_value%type;
  begin
    apex_debug.enter ( 'get_archive_location');

    l_destination_json      := flow_engine_util.get_config_value 
                             ( p_config_key  => p_archive_type
                             , p_default_value  => null);

    apex_debug.message 
    ( p_message => 'Retrieved configuration parameter %0 contents %1'
    , p0 => p_archive_type
    , p1 => l_destination_json
    );                         
    -- dbms_output.put_line('archive destination'||l_destination_json);
    apex_json.parse (p_source => l_destination_json);

    l_archive_location.destination_type            := apex_json.get_varchar2 (p_path => 'destinationType');

    apex_debug.message (p_message => '--- Destination Type : %0', p0=> l_archive_location.destination_type);  
    -- dbms_output.put_line('--- Destination Type : '||l_archive_location.destination_type);

    case l_archive_location.destination_type 
    when flow_constants_pkg.gc_config_archive_destination_table then
      l_archive_location.db_table_name             := apex_json.get_varchar2 (p_path => 'tableDetails.tableName');
      l_archive_location.db_id_column              := apex_json.get_varchar2 (p_path => 'tableDetails.idColumn');
      l_archive_location.db_timestamp_column       := apex_json.get_varchar2 (p_path => 'tableDetails.timestampColumn');
      l_archive_location.db_blob_column            := apex_json.get_varchar2 (p_path => 'tableDetails.blobColumn');

    when flow_constants_pkg.gc_config_archive_destination_oci_api then
      l_archive_location.oci_base_url              := apex_json.get_varchar2 (p_path => 'ociApiDetails.baseUrl');
      apex_debug.message (p_message => '--- Base URL : %0', p0=> l_archive_location.oci_base_url);  
      l_archive_location.oci_bucket_name           := apex_json.get_varchar2 (p_path => 'ociApiDetails.bucketName');
      apex_debug.message (p_message => '--- Bucket Name : %0', p0=> l_archive_location.oci_bucket_name);
      l_archive_location.oci_document_prefix       := apex_json.get_varchar2 (p_path => 'ociApiDetails.documentPrefix');
      l_archive_location.oci_credential_static_id  := apex_json.get_varchar2 (p_path => 'ociApiDetails.credentialApexStaticId');

      l_archive_location.oci_request_url :=  l_archive_location.oci_base_url
                                         || 'b/' 
                                         || l_archive_location.oci_bucket_name 
                                         || '/o/';
      apex_debug.message (p_message => '--- Request URL : %0', p0=> l_archive_location.oci_request_url);
    when flow_constants_pkg.gc_config_archive_destination_oci_preauth then
      l_archive_location.oci_request_url           := apex_json.get_varchar2 (p_path => 'ociPreAuthDetails.preAuthUrl');
      apex_debug.message (p_message => '--- Request URL : %0', p0=> l_archive_location.oci_request_url);
      l_archive_location.oci_document_prefix       := apex_json.get_varchar2 (p_path => 'ociPreAuthDetails.documentPrefix');
      l_archive_location.oci_credential_static_id  := apex_json.get_varchar2 (p_path => 'ociPreAuthDetails.credentialApexStaticId');
    end case;
    return l_archive_location;
    exception
      when others then 
        apex_debug.info 
        ( p_message => ' --- Error in %0 configuration parameter definition. Value :'
        , p0  => flow_constants_pkg.gc_config_logging_archive_location
        , p1  => l_destination_json
        );
        flow_errors.handle_general_error
        ( pi_message_key    => 'archive-destination-bad-json'
        , p0 => l_destination_json
        );  
        -- $F4AMESSAGE 'archive-destination-bad-json' || 'Error in archive destination configuration parameter.  Parameter: %0' 
      return null;
  end get_archive_location;

  procedure archive_to_database
  ( p_object_id         in number
  , p_archive           in blob
  , p_archive_location  in t_archive_location
  )
  is
    l_insert_sql           varchar2(4000);
    l_update_sql           varchar2(4000);
    e_db_archive_fail      exception;

  begin
    apex_debug.enter ( 'archive_to_database',
    'instance', p_object_id
    );   

    l_insert_sql := 'insert into '
                    ||p_archive_location.db_table_name
                    ||' ( ' ||p_archive_location.db_id_column 
                    ||' , ' ||p_archive_location.db_timestamp_column 
                    ||' , ' ||p_archive_location.db_blob_column
                    ||' ) values ( :1, systimestamp,  :2 )'
                    ;
    execute immediate l_insert_sql using p_object_id, p_archive;
    apex_debug.message 
    ( p_message => '-- Object %0 inserted into archive to %1.%2'
    , p0 => p_object_id
    , p1 => p_archive_location.db_table_name
    , p2 => p_archive_location.db_blob_column
    ); 
  exception
  /*  when dup_val_on_index then  -- added timestap column so this will not be called now...
      -- handle re-archive if the archive already exists.   This usually occurs if the process 
      -- was reset after archiving.
      l_update_sql := 'update '
                      ||p_archive_location.db_table_name
                      ||' set '
                      ||p_archive_location.db_blob_column
                      ||' = :1 where '
                      ||p_archive_location.db_id_column
                      ||' = :2 '
                      ;
      execute immediate l_update_sql using p_archive, p_object_id;
      apex_debug.message 
      ( p_message => '-- Object %0 archive updated in %1.%2'
      , p0 => p_object_id
      , p1 => p_archive_location.db_table_name
      , p2 => p_archive_location.db_blob_column
      ); */
    when others then
      apex_debug.message 
      ( p_message => 'Archiving object %0 into database column %1.%2 failed. Failed SQL: %3.'
      , p0 => p_object_id
      , p1 => p_archive_location.db_table_name
      , p2 => p_archive_location.db_blob_column
      , p3 => l_insert_sql
      ); 
      raise e_db_archive_fail;
  end archive_to_database;

  procedure archive_to_oci
  ( p_archive           in blob
  , p_archive_location  in t_archive_location
  , p_object_name       in varchar2
  , p_content_type      in varchar2
  )
  is
    l_url                       varchar2(4000);
    l_response                  clob;
    e_upload_failed_exception   exception;
  begin
    l_url := p_archive_location.oci_request_url
              ||p_archive_location.oci_document_prefix
              ||p_object_name;
    apex_debug.message 
    ( p_message => 'Preparing Archive URL - URL : %0 Credential Static ID: %1'
    , p0 => l_url
    , p1 => p_archive_location.oci_credential_static_id
    );
    apex_web_service.g_request_headers(1).name :=  'Content-Type';
    apex_web_service.g_request_headers(1).value :=  p_content_type;
    l_response :=  apex_web_service.make_rest_request
                   ( p_url          => l_url
                   , p_http_method  => 'PUT'
                   , p_body_blob    => p_archive
                   , p_credential_static_id => p_archive_location.oci_credential_static_id
                   );
    if apex_web_service.g_status_code != 200 then
      raise e_upload_failed_exception;
    end if;
  end archive_to_oci;

  function archive_bpmn_diagram
  ( p_dgrm_id            flow_diagrams.dgrm_id%type
  , p_dgrm_content       flow_diagrams.dgrm_content%type
  ) return flow_flow_event_log.lgfl_dgrm_archive_location%type
  is
    l_archive_blob        blob;
    l_archive_location    t_archive_location;
    l_timestamp           timestamp with time zone;
    l_stored_location     flow_flow_event_log.lgfl_dgrm_archive_location%type;
    l_object_name         flow_flow_event_log.lgfl_dgrm_archive_location%type;
  begin
    -- fix timestamp
    l_timestamp := systimestamp at time zone 'UTC';
    -- create bpmn blob
    l_archive_blob := flow_engine_util.clob_to_blob( pi_clob  => p_dgrm_content );
    -- get archive location
    l_archive_location := get_archive_location (p_archive_type => flow_constants_pkg.gc_config_logging_bpmn_location);
    -- store in preferred location
    case l_archive_location.destination_type
    when flow_constants_pkg.gc_config_archive_destination_table then
      archive_to_database ( p_object_id        => p_dgrm_id
                          , p_archive          => l_archive_blob
                          , p_archive_location => l_archive_location
                          );
      return l_archive_location.db_table_name;
    when flow_constants_pkg.gc_config_archive_destination_oci_api then
      l_object_name := trim(to_char(p_dgrm_id,'099999'))||'-'||to_char(l_timestamp,'YYYYMMDD-HH24MISS')||'.bpmn';
      archive_to_oci      ( p_archive          => l_archive_blob
                          , p_archive_location => l_archive_location
                          , p_object_name      => l_object_name
                          , p_content_type     => flow_constants_pkg.gc_mime_type_bpmn
                          );   
      return l_object_name;
    when flow_constants_pkg.gc_config_archive_destination_oci_preauth then
      l_object_name := trim(to_char(p_dgrm_id,'099999'))||'-'||to_char(l_timestamp,'YYYYMMDD-HH24MISS')||'.bpmn';
      archive_to_oci      ( p_archive          => l_archive_blob
                          , p_archive_location => l_archive_location
                          , p_object_name      => l_object_name
                          , p_content_type     => flow_constants_pkg.gc_mime_type_bpmn
                          );  
      return l_object_name;
    end case;
  end archive_bpmn_diagram;

  procedure archive_instance
  ( p_process_id         flow_processes.prcs_id%type
  , p_archive_location   t_archive_location
  )
  is
    l_archive_blob   blob;
  begin
    -- create instance summary json
    l_archive_blob := flow_engine_util.clob_to_blob( pi_clob  => get_instance_json_summary (p_process_id => p_process_id) );
    -- store in preferred location
    case p_archive_location.destination_type
    when flow_constants_pkg.gc_config_archive_destination_table then
      archive_to_database ( p_object_id        => p_process_id
                          , p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
                          );
    when flow_constants_pkg.gc_config_archive_destination_oci_api then
      archive_to_oci      ( p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
                          , p_object_name      => trim(to_char(p_process_id,'09999999'))||'.json'
                          , p_content_type     => flow_constants_pkg.gc_mime_type_json
                          );  
    when flow_constants_pkg.gc_config_archive_destination_oci_preauth then
      archive_to_oci      ( p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
                          , p_object_name      => trim(to_char(p_process_id,'09999999'))||'.json'
                          , p_content_type     => flow_constants_pkg.gc_mime_type_json
                          );  
    end case;
    -- update instance with archive timestamp
    update flow_processes
    set prcs_archived_ts = systimestamp
      , prcs_last_update = systimestamp
    where prcs_id = p_process_id;
  end archive_instance;

  procedure archive_completed_instances
  ( p_completed_before         in date default trunc(sysdate)
  , p_process_id               in flow_processes.prcs_id%type default null  
  )
  is
    type t_instance           is record (
      prcs_id                 flow_processes.prcs_id%type);
    type t_instances          is table of t_instance;

    l_response                clob;
    l_archive_location        t_archive_location;
    l_instances               t_instances;

    e_upload_failed_exception exception;
  begin
    apex_debug.enter ('archive_completed_instances'
    ,'p_completed_before',p_completed_before
    , 'p_process_id', p_process_id
    );
    -- get list of process instances to archive, if a single p_process_id was not passed in.
    -- get all completed ('completed' or 'terminated') non-archived instances
    -- dbms_output.put_line('Archiving starting');
    if p_process_id is null then
      select prcs.prcs_id
        bulk collect into l_instances
        from flow_processes prcs
       where prcs.prcs_status in ( flow_constants_pkg.gc_prcs_status_completed
                                 , flow_constants_pkg.gc_prcs_status_terminated )
         and trunc(prcs.prcs_complete_ts) < p_completed_before
         and prcs.prcs_archived_ts is null
      ;
    else
      select p_process_id
        bulk collect into l_instances
        from dual;
    end if;

    apex_debug.message (p_message => 'Instances to be Archived : %0'
    , p0 => l_instances.count);

    if l_instances.count > 0 then
      -- dbms_output.put_line('getting location');
      -- get archive location
      l_archive_location := get_archive_location (p_archive_type => flow_constants_pkg.gc_config_logging_archive_location);
      --dbms_output.put_line('got location');
      -- loop over instances
      for instance in 1 .. l_instances.count
      loop
        -- lock flow_processes?
        -- dbms_output.put_line('Archiving process '||l_instances(instance).prcs_id);
        archive_instance ( p_process_id => l_instances(instance).prcs_id
                         , p_archive_location => l_archive_location
                         );
        
        -- commit?
      end loop;      
    end if;
  exception  
    when others then
      flow_errors.handle_general_error( pi_message_key  => 'log-archive-error'
                                      , p0 => apex_web_service.g_status_code);
      raise;      
  end archive_completed_instances;

end flow_log_admin;
/

PROMPT >> Hot Fix 681 applied

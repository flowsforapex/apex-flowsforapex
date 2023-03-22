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
                           'processLevel'               value lgsf_sbfl_process_level,
                           'priority'                   value lgsf_priority,
                           'lastCompleted'              value lgsf_last_completed,
                           'wasCurrent'                 value lgsf_was_current,
                           'wasStarted'                 value lgsf_started,
                           'wasCompleted'               value lgsf_completed,
                           'statusWhenComplete'         Value lgsf_status_when_complete,
                           'subflowDiagram'             value lgsf_sbfl_dgrm_id,
                           'reservation'                value lgsf_reservation,
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

  end purge_instance_logs;


  /*function validate_db_archive_location
  ( p_table       flow_types_pkg.t_vc200
  , p_id_column   flow_types_pkg.t_vc200
  , p_blob_column flow_types_pkg.t_vc200
  ) return boolean -- true if validated
  is
  begin
    begin
      select 
  end validate_db_archive_location;*/

  function get_archive_location
  return t_archive_location
  is
    l_archive_location              t_archive_location;
    e_archive_bad_destination_json  exception;
    l_destination_json              flow_configuration.cfig_value%type;
  begin
    apex_debug.enter ( 'get_archive_location');

    l_destination_json      := flow_engine_util.get_config_value 
                             ( p_config_key  => flow_constants_pkg.gc_config_logging_archive_location
                             , p_default_value  => null);

    apex_debug.message 
    ( p_message => 'Retrieved configuration parameter %0 contents %1'
    , p0 => flow_constants_pkg.gc_config_logging_archive_location
    , p1 => l_destination_json
    );                         

    apex_json.parse (p_source => l_destination_json);

    l_archive_location.destination_type            := apex_json.get_varchar2 (p_path => 'destinationType');

    apex_debug.message (p_message => '--- Destination Type : %0', p0=> l_archive_location.destination_type);  

    case l_archive_location.destination_type 
    when flow_constants_pkg.gc_config_archive_destination_table then
      l_archive_location.db_table_name             := apex_json.get_varchar2 (p_path => 'tableDetails.tableName');
      l_archive_location.db_id_column              := apex_json.get_varchar2 (p_path => 'tableDetails.idColumn');
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
  ( p_process_id        in flow_processes.prcs_id%type
  , p_archive           in blob
  , p_archive_location  in t_archive_location
  )
  is
    l_insert_sql           varchar2(4000);
    l_update_sql           varchar2(4000);
    e_db_archive_fail      exception;

  begin
    apex_debug.enter ( 'archive_to_database',
    'instance', p_process_id
    );   

    l_insert_sql := 'insert into '
                    ||p_archive_location.db_table_name
                    ||' ( ' ||p_archive_location.db_id_column 
                    ||' , ' ||p_archive_location.db_blob_column
                    ||' ) values ( :1, :2 )'
                    ;
    execute immediate l_insert_sql using p_process_id, p_archive;
    apex_debug.message 
    ( p_message => '-- Instance %0 inserted into archive to %1.%2'
    , p0 => p_process_id
    , p1 => p_archive_location.db_table_name
    , p2 => p_archive_location.db_blob_column
    ); 
  exception
    when dup_val_on_index then 
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
      execute immediate l_update_sql using p_archive, p_process_id;
      apex_debug.message 
      ( p_message => '-- Instance %0 archive updated in %1.%2'
      , p0 => p_process_id
      , p1 => p_archive_location.db_table_name
      , p2 => p_archive_location.db_blob_column
      );
    when others then
      apex_debug.message 
      ( p_message => 'Archiving instance %0 into database column %1.%2 failed. Failed SQL: %3.'
      , p0 => p_process_id
      , p1 => p_archive_location.db_table_name
      , p2 => p_archive_location.db_blob_column
      , p3 => l_insert_sql
      ); 
      raise e_db_archive_fail;
  end archive_to_database;

  procedure archive_to_oci
  ( p_process_id        in flow_processes.prcs_id%type
  , p_archive           in blob
  , p_archive_location  in t_archive_location
  )
  is
    l_url                       varchar2(4000);
    l_response                  clob;
    e_upload_failed_exception   exception;
  begin
    l_url := p_archive_location.oci_request_url
              ||p_archive_location.oci_document_prefix
              ||trim(to_char(p_process_id,'09999999'))||'.json';
    apex_debug.message 
    ( p_message => 'Preparing Archive URL - URL : %0 Credential Static ID: %1'
    , p0 => l_url
    , p1 => p_archive_location.oci_credential_static_id
    );
    apex_web_service.g_request_headers(1).name :=  'Content-Type';
    apex_web_service.g_request_headers(1).value :=  'application/json';
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

  procedure archive_instance
  ( p_process_id         flow_processes.prcs_id%type
  , p_archive_location   t_archive_location
  )
  is
    l_archive_blob   blob;
  begin
    -- create instance summary json
    l_archive_blob := flow_db_exec.clob_to_blob( pi_clob  => get_instance_json_summary (p_process_id => p_process_id) );
    -- store in preferred location
    case p_archive_location.destination_type
    when flow_constants_pkg.gc_config_archive_destination_table then
      archive_to_database ( p_process_id       => p_process_id
                          , p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
                          );
    when flow_constants_pkg.gc_config_archive_destination_oci_api then
      archive_to_oci      ( p_process_id       => p_process_id
                          , p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
                          );   
    when flow_constants_pkg.gc_config_archive_destination_oci_preauth then
      archive_to_oci      ( p_process_id       => p_process_id
                          , p_archive          => l_archive_blob
                          , p_archive_location => p_archive_location
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
      -- get archive location
      l_archive_location := get_archive_location;
      -- loop over instances
      for instance in 1 .. l_instances.count
      loop
        -- lock flow_processes?
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

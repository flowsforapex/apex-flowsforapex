create or replace view flow_instance_summary_json_vw as 
 with s as
                    (select distinct sc.lgvr_scope scope, sc.lgvr_prcs_id
                    from   flow_variable_event_log sc
                    )
select prcs_id, prcs_status, systimestamp as json_created_date, 
        json_object (
    'processID'        : p.prcs_id,
    'mainDiagram'      : p.prcs_dgrm_id,
    'processName'      : p.prcs_name,
    'businessID'       : prov.prov.prov_var_vc2,
    'priority'         : p.prcs_priority,
    'prcs_status'      : p.prcs_status,
    'prcs_was_altered' : p.prcs_was_altered,
    'json_created'     : systimestamp,
    'prcs_init_ts'     : p.prcs_init_ts,
    'prcs_init_by'     : p.prcs_init_by,
    'prcs_due_on'      : p.prcs_due_on,
    'diagramsUsed'     :
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
                        ) ORDER BY prdg_diagram_level asc 
                    )
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
                        'object'                     value lgpr_OBJT_ID,
                        'diagram'                    value lgpr_DGRM_ID,
                        'timestamp'                  value lgpr_timestamp,
                        'user'                       value lgpr_USER,
                        'error-info'                 value lgpr_ERROR_INFO,
                        'comment'                    value lgpr_COMMENT absent on null
                        ) ORDER BY lgpr_timestamp 
                   returning clob )
           from flow_instance_event_log lgpr
          where lgpr.lgpr_prcs_id = p.prcs_id
        ),       
    'steps' :
        (select json_arrayagg
                    (json_object 
                        (
                        'object'                     VALUE LGSF_OBJT_ID,
                        'subflowID'                  VALUE LGSF_SBFL_ID,
                        'processLevel'               VALUE LGSF_SBFL_PROCESS_LEVEL,
                        'priority'                   VALUE lgsf_priority,
                        'lastCompleted'              VALUE LGSF_LAST_COMPLETED,
                        'wasCurrent'                 VALUE LGSF_WAS_CURRENT,
                        'wasStarted'                 VALUE LGSF_STARTED,
                        'wasCompleted'               VALUE LGSF_COMPLETED,
                        'statusWhenComplete'         VALUE LGSF_STATUS_WHEN_COMPLETE,
                        'subflowDiagram'             VALUE LGSF_SBFL_DGRM_ID,
                        'reservation'                VALUE LGSF_RESERVATION,
                        'user'                       VALUE LGSF_USER,
                        'comment'                    VALUE LGSF_COMMENT absent on null
                        ) ORDER BY lgsf_was_current
                    returning clob)
          from flow_step_event_log lgsf
         where lgsf.lgsf_prcs_id = p.prcs_id
        ),
    'processVariablesSet' :
            (  select json_arrayagg (
                    json_object (
                        'scope'         : s.scope,
                        'variables'     :
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
                                        )
                                from flow_variable_event_log lgvr
                               where lgvr.lgvr_prcs_id = p.prcs_id
                                 and lgvr.lgvr_scope   = s.scope
                            )
                        )
                    returning clob )
                from s
               where s.lgvr_prcs_id = p.prcs_id
            )
        returning clob)  summary_json
  from flow_processes p
  left join flow_process_variables prov
    on prov.prov_prcs_id    = p.prcs_id
 where prov.prov_var_name   = 'BUSINESS_REF'
   and prov.prov_scope      = 0
;

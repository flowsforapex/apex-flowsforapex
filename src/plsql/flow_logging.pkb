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
  begin
    if g_logging_level in ( flow_constants_pkg.gc_config_logging_level_secure
                          , flow_constants_pkg.gc_config_logging_level_full
                          ) 
    then
      if p_dgrm_content is not null and p_dgrm_status != flow_constants_pkg.gc_dgrm_status_draft then
        l_log_dgrm_content := true;
        -- copy the new bpmn content to the bpmn archive (table or OCI object storage)
        l_diagram_location := flow_log_admin.archive_bpmn_diagram ( p_dgrm_id       => p_dgrm_id
                                                                  , p_dgrm_content  => p_dgrm_content
                                                                  );
      end if;

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
      , p_dgrm_name
      , p_dgrm_version
      , p_dgrm_status
      , p_dgrm_category
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
    , sflg_last_updated
    , sflg_dgrm_id
    , sflg_diagram_level
    , sflg_notes
    )
    select p_process_id
         , p_completed_object
         , p_subflow_id
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
      , lgsf_sbfl_process_level
      , lgsf_last_completed
      , lgsf_status_when_complete
      , lgsf_sbfl_dgrm_id
      , lgsf_was_current 
      , lgsf_started 
      , lgsf_completed
      , lgsf_reservation
      , lgsf_user
      , lgsf_comment
      )
      select sbfl.sbfl_prcs_id
           , p_completed_object
           , sbfl.sbfl_id
           , sbfl.sbfl_process_level
           , sbfl.sbfl_last_completed
           , sbfl.sbfl_status
           , sbfl.sbfl_dgrm_id
           , sbfl.sbfl_became_current
           , sbfl.sbfl_work_started
           , systimestamp
           , sbfl.sbfl_reservation
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

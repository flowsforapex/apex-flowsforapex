create or replace package body flow_logging
as

  g_logging_level           flow_configuration.cfig_value%type; 
  g_logging_hide_userid     flow_configuration.cfig_value%type;

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
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
      , lgpr_dgrm_id 
      , lgpr_prcs_name 
      , lgpr_business_id
      , lgpr_prcs_event
      , lgpr_timestamp 
      , lgpr_user 
      , lgpr_comment
      )
      select prcs.prcs_id
          , prcs.prcs_dgrm_id
          , prcs.prcs_name
          , flow_process_vars.get_business_ref (p_process_id)  --- 
          , p_event
          , systimestamp 
          , coalesce ( sys_context('apex$session','app_user') 
                      , sys_context('userenv','os_user')
                      , sys_context('userenv','session_user')
                      )  --- check this is complete
          , p_comment
        from flow_processes prcs 
      where prcs.prcs_id = p_process_id
      ;
    end if;
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging instance event'
      , p_display_location => apex_error.c_on_error_page
      );
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
    , sflg_notes
    )
    values 
    ( p_process_id
    , p_completed_object
    , p_subflow_id
    , sysdate
    , p_notes
    );
    -- system event logging
    if g_logging_level in ( flow_constants_pkg.gc_config_logging_level_standard 
                          , flow_constants_pkg.gc_config_logging_level_secure
                          , flow_constants_pkg.gc_config_logging_level_full
                          ) 
    then
      insert into flow_subflow_event_log
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
           , coalesce ( sys_context('apex$session','app_user') 
                      , sys_context('userenv','os_user')
                      , sys_context('userenv','session_user')
                      )  --- check this is complete
           , p_notes        
        from flow_subflows sbfl 
       where sbfl.sbfl_id = p_subflow_id
      ;
    end if;
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging step completion'
      , p_display_location => apex_error.c_on_error_page
      );
      raise;
  end log_step_completion;

  procedure log_variable_event -- logs process variable set events
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_var_name          in flow_process_variables.prov_var_name%type
  , p_objt_bpmn_id      in flow_objects.objt_bpmn_id%type default null
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type default null
  , p_expr_set          in flow_object_expressions.expr_set%type default null
  , p_var_type          in flow_process_variables.prov_var_type%type
  , p_var_vc2           in flow_process_variables.prov_var_vc2%type default null
  , p_var_num           in flow_process_variables.prov_var_num%type default null
  , p_var_date          in flow_process_variables.prov_var_date%type default null
  , p_var_clob          in flow_process_variables.prov_var_clob%type default null
  )
  as 
  begin 
    if g_logging_level in (  flow_constants_pkg.gc_config_logging_level_full ) then
      insert into flow_variable_event_log
      ( lgvr_prcs_id  
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
      )
      values
      ( p_process_id
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
      );
    end if;
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging step completion'
      , p_display_location => apex_error.c_on_error_page
      );
      raise;
  end log_variable_event;

  -- initialize logging parameters

  begin 
    g_logging_level := flow_engine_util.get_config_value
                       ( p_config_key => flow_constants_pkg.gc_config_logging_level
                       , p_default_value => flow_constants_pkg.gc_config_default_logging_level
                       );
    g_logging_hide_userid := flow_engine_util.get_config_value
                       ( p_config_key => flow_constants_pkg.gc_config_logging_hide_userid 
                       , p_default_value => flow_constants_pkg.gc_config_default_logging_hide_userid 
                       );
  
    apex_debug.message ( p_message  => 'Logging level: %0'
                       , p0         => g_logging_level
                       , p_level    => 4 
                       );
end flow_logging;
/

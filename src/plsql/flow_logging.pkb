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
           , p_completed_object||' - '||p_notes         -- for initial debugging only - remove p_completed_object
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
  
end flow_logging;
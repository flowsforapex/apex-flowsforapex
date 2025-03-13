create or replace package body flow_admin_api as
 /* Flows for APEX - flow_admin_api.pkb
--
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    11-Feb-2023   Richard Allen, Oracle
*/
 /**
FLOWS FOR APEX ADMIN API
=========================

The `flow_admin_api` package gives you access to the Flows for APEX engine admin procedures, and allows you to perform:
-  Maintenance, Archiving and Purging of the Flows for APEX log files
-  Maintenance, Archiving, and Purging of the Flows for APEX performance statistics all_summaries
- Maintenance of Flows for APEX instance configuration parameters

*/
-- Log File Functions
  procedure purge_instance_logs
  ( p_retention_period_days  in number default null
  ) 
  is
  begin
    flow_log_admin.purge_instance_logs 
    ( p_retention_period_days => p_retention_period_days 
    );
  end purge_instance_logs;

  function instance_summary
  ( p_process_id        in flow_processes.prcs_id%type
  ) return clob
  is
  begin
    return flow_log_admin.get_instance_json_summary ( p_process_id => p_process_id);
  end instance_summary;

  procedure archive_completed_instances
  ( p_completed_before         in date default trunc(sysdate)
  )
  is
      l_session_id   number;
    begin  
        if v('APP_SESSION') is null then
          l_session_id := flow_apex_session.create_api_session(p_process_id => null);
        end if;

        flow_log_admin.archive_completed_instances
        ( p_completed_before         => p_completed_before
        );

        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
    exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;      
  end archive_completed_instances;

-- Performance Summary Functions

  procedure run_daily_stats
  is
  begin
    flow_statistics.run_daily_stats;
  end run_daily_stats;


  procedure purge_statistics
  is
  begin
    flow_statistics.purge_statistics;
  end purge_statistics;

  -- Configuration Parameters

  procedure set_config_value
  ( p_config_key        in flow_configuration.cfig_key%type,
    p_value             in flow_configuration.cfig_value%type,
    p_update_if_set     in boolean default true
  )
  is
  begin
    flow_engine_util.set_config_value
    ( p_config_key      => p_config_key
    , p_value           => p_value
    , p_update_if_set   => p_update_if_set
    );
  end set_config_value;

  function get_config_value
  ( p_config_key        in flow_configuration.cfig_key%type
  , p_default_value     in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type
  is
  begin
    return flow_engine_util.get_config_value ( p_config_key     => p_config_key 
                                             , p_default_value  => p_default_value
                                             );       
  end get_config_value;

  -- Diagram Release

  procedure release_diagram
  ( pi_dgrm_name    in flow_diagrams.dgrm_name%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type default '0' 
  )
  is
  begin 
    flow_diagram.release_diagram
    ( pi_dgrm_name    => pi_dgrm_name
    , pi_dgrm_version => pi_dgrm_version
    );
  end release_diagram;

  -- suspend process instance (requires EE)

  procedure suspend_process
  ( p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;
  begin  
    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_instances.suspend_process ( p_process_id => p_process_id
                                   , p_comment    => p_comment
                                   );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end suspend_process;

  -- resume process instance (requires EE)

  procedure resume_process
  ( p_process_id    in flow_processes.prcs_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;
  begin  
    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_instances.resume_process  ( p_process_id => p_process_id
                                   , p_comment    => p_comment
                                   );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end resume_process;

  procedure mark_subflow_for_deletion
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;  
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.mark_subflow_for_deletion  ( p_process_id => p_process_id
                                            , p_subflow_id => p_subflow_id
                                            , p_comment    => p_comment
                                            );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end mark_subflow_for_deletion;

  procedure return_to_prior_gateway
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
   is
    l_session_id   number;  
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.return_to_prior_gateway   ( p_process_id => p_process_id
                                            , p_subflow_id => p_subflow_id
                                            , p_comment    => p_comment
                                            );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end return_to_prior_gateway;

  procedure return_to_prior_step
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_new_step    in flow_objects.objt_bpmn_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;  
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.return_to_prior_step   ( p_process_id => p_process_id
                                        , p_subflow_id => p_subflow_id
                                        , p_new_step   => p_new_step
                                        , p_comment    => p_comment
                                        );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if; 
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end return_to_prior_step;

  procedure return_to_last_step
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.return_to_last_step   ( p_process_id => p_process_id
                                      , p_subflow_id => p_subflow_id
                                      , p_comment    => p_comment
                                      );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end return_to_last_step;
  

  procedure rewind_from_subprocess
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;  
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.rewind_from_subprocess   ( p_process_id => p_process_id
                                        , p_subflow_id => p_subflow_id
                                        , p_comment    => p_comment
                                        );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if; 
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end rewind_from_subprocess;

  procedure rewind_from_call_activity
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;  
  begin

    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.rewind_from_call_activity ( p_process_id => p_process_id
                                          , p_subflow_id => p_subflow_id
                                          , p_comment    => p_comment
                                          );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if; 
  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end rewind_from_call_activity;

  procedure flow_force_next_step
  ( p_process_id                   in flow_processes.prcs_id%type
  , p_subflow_id                   in flow_subflows.sbfl_id%type
  , p_step_key                     in flow_subflows.sbfl_step_key%type
  , p_comment                      in flow_instance_event_log.lgpr_comment%type default null
  )
  is
    l_session_id   number;
  begin     
    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
    end if;

    flow_rewind.flow_force_next_step ( p_process_id                   => p_process_id
                                     , p_subflow_id                   => p_subflow_id
                                     , p_step_key                     => p_step_key
                                     , p_execute_variable_expressions => false
                                     , p_comment                      => p_comment
                                     );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if; 

  exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end flow_force_next_step;


end flow_admin_api;
/

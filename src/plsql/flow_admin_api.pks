create or replace package flow_admin_api
   authid definer as
 /* Flows for APEX - flow_admin_api.pks
--
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    11-Feb-2023   Richard Allen, Oracle
*/

/**
FLOWS FOR APEX ADMIN API
=========================

The `flow_admin_api` package gives you access to the Flows for APEX engine admin procedures, and allows you to perform the following from the PL/SQL API:
-  Maintenance, Archiving and Purging of the Flows for APEX log files
-  Maintenance, Archiving, and Purging of the Flows for APEX performance statistics all_summaries
-  Maintenance of Flows for APEX instance configuration parameters
-  Release of Diagrams (useful when introducing a new model into a production system).

*/
-- Log File Functions


  function instance_summary
  ( p_process_id            in flow_processes.prcs_id%type
  ) return clob;

  procedure archive_completed_instances
  ( p_completed_before      in date default trunc(sysdate)
  );

  procedure purge_instance_logs
  ( p_retention_period_days  in number default null
  );

-- Performance Summary Functions

  procedure run_daily_stats;

  procedure purge_statistics;

-- set configuration parameters

  procedure set_config_value
  ( p_config_key        in flow_configuration.cfig_key%type,
    p_value             in flow_configuration.cfig_value%type,
    p_update_if_set     in boolean default true
  );

  function get_config_value
  ( p_config_key        in flow_configuration.cfig_key%type
  , p_default_value     in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type;

-- release a diagram

  procedure release_diagram
  ( pi_dgrm_name    in flow_diagrams.dgrm_name%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type default '0'
  );

-- suspend process instance (requires EE)

  procedure suspend_process
  ( p_process_id    in flow_processes.prcs_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );

-- resume process instance (requires EE)

  procedure resume_process
  ( p_process_id    in flow_processes.prcs_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );

-- delete a running subflow (requires EE)

  procedure mark_subflow_for_deletion
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure return_to_prior_gateway
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure return_to_prior_step
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_new_step    in flow_objects.objt_bpmn_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

end flow_admin_api;
/

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

**/
-- Log File Functions


  function instance_summary
  ( p_process_id            in flow_processes.prcs_id%type
  ) return clob;
/**
Function instance_summary
This function returns a JSON summary of the process instance execution, including all the steps, gateways, and subflows that have been executed.
Contents of the instance summary depend on the level of logging enabled for the process instance.
Contents can include:
- Process instance details
- Details of process models and versions used, including for any Call Activity calls
- Details of all steps executed, including the step type, step name, and step status  
- Details of all gateways executed, including the gateway type, gateway name, and gateway status  
- Details of all subflows executed, including the subflow name, subflow status, and subflow steps
- Details of all process variables set during the process instance execution.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
  procedure archive_completed_instances
  ( p_completed_before      in date default trunc(sysdate)
  );
/**
Procedure archive_completed_instances
This procedure archives all completed process instances that were completed before the specified date.
The procedure moves the process instance data from the live tables to the archive location specified in the configuration data
Archive location can be a database table or to OCI Object Storage.  See documentation on configuring the archive location.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
  procedure purge_instance_logs
  ( p_retention_period_days  in number default null
  );
/**
Procedure purge_instance_logs
This procedure purges the process instance log records for instances which completed  before the the specified retention period.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
-- Performance Summary Functions

  procedure run_daily_stats;
/**
Procedure run_daily_stats
This procedure runs the daily statistics summarization process.  It is typically run as a scheduled job.
Running the daily statistics summarization process creates daily summary records for all process instances that completed the previous day. 
If the daily statistics summarization process was not run for several days, running it will create daily summaries for each day since it was last run.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
  procedure purge_statistics;
/**
Procedure purge_statistics
This procedure purges the performance statistics summary records that are older than the configured retention period.
Statistics summary records are created by the daily statistics summarization process.
Statistics retention periods are configured in the configuration data.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
-- set configuration parameters

  procedure set_config_value
  ( p_config_key        in flow_configuration.cfig_key%type,
    p_value             in flow_configuration.cfig_value%type,
    p_update_if_set     in boolean default true
  );
/**
Procedure set_config_value
This procedure sets a configuration parameter value in the Flows for APEX configuration data.
If the configuration parameter does not exist, it is created.
If the configuration parameter exists and the p_update_if_set parameter is true, the value is updated.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
  function get_config_value
  ( p_config_key        in flow_configuration.cfig_key%type
  , p_default_value     in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type;
/**
Function get_config_value
This function returns the value of a configuration parameter from the Flows for APEX configuration data.
If the configuration parameter does not exist, the  value in p_default_value is returned.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
-- release a diagram

  procedure release_diagram
  ( pi_dgrm_name    in flow_diagrams.dgrm_name%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type default '0'
  );
/**
Procedure release_diagram
This procedure releases a diagram, making it available for use in new process instances.
The procedure sets the diagram status to 'released`.
If a version of this diagram already exists in 'released' status, the previous version is set to 'deprecated'.

This procedure is useful for deploying new diagrams into a production environment in a scripted manner.  You can install the 
new diagram into the production environment having exported it in SQL format, then release it when you are ready to start using it.

Available in Flows for APEX Community Edition and Flows for APEX Enterprise Edition.
**/
-- suspend process instance (requires EE)

  procedure suspend_process
  ( p_process_id    in flow_processes.prcs_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );
/**
Procedure suspend_process
This procedure suspends a process instance.
The process instance is paused and no further steps are executed until the process instance is resumed.
The process instance can be resumed using the `resume_process` procedure.
While suspended, an administrator can 'fix' a process instance that has encountered an error, or make changes to the process instance data.

Available in Flows for APEX Enterprise Edition.
**/
-- resume process instance (requires EE)

  procedure resume_process
  ( p_process_id    in flow_processes.prcs_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );
/**
Procedure resume_process
This procedure resumes a process instance that has been suspended.
On resuming the process, and changes that were made to the prrocess instance execution are applied
before the process instance continues to execute.

Available in Flows for APEX Enterprise Edition.
**/
-- delete a running subflow (requires EE)

  procedure mark_subflow_for_deletion
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );
/**
**/
  procedure return_to_prior_gateway
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );
/**
**/
  procedure return_to_prior_step
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_new_step    in flow_objects.objt_bpmn_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );
/**
**/
  procedure rewind_from_subprocess
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );
/**
**/
  procedure rewind_from_call_activity
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );
/**
**/
  procedure flow_force_next_step
  ( p_process_id                   in flow_processes.prcs_id%type
  , p_subflow_id                   in flow_subflows.sbfl_id%type
  , p_step_key                     in flow_subflows.sbfl_step_key%type
  , p_comment                      in flow_instance_event_log.lgpr_comment%type default null
  );
   

end flow_admin_api;
/

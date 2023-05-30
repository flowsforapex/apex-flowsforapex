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

The `flow_admin_api` package gives you access to the Flows for APEX engine admin procedures, and allows you to perform:
-  Maintenance, Archiving and Purging of the Flows for APEX log files
-  Maintenance, Archiving, and Purging of the Flows for APEX performance statistics all_summaries
- Maintenance of Flows for APEX instance configuration parameters

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

end flow_admin_api;
/

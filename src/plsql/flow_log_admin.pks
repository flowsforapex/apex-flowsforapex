create or replace package flow_log_admin 
  /* 
  -- Flows for APEX - flow_log_admin.pks
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
  authid definer
  accessible by ( flow_admin_api, flow_instances )
  as

  function get_instance_json_summary
  ( p_process_id        in flow_processes.prcs_id%type
  ) return clob;

  -- archive_completed_instances is normally called by apex_automations after midnight
  -- each day to prepare archive summaries for all processes that completed or terminated during
  -- the previous day.  This can be done without specifying any parameters.
  --
  -- p_process_id should only be specified when you need to archive a specific process.  
  -- Use Case for this is if a process instance is deleted (flow_api_pkg.flow_delete), archiving is enabled
  -- and the instance has not yet been archived. Call archive_completed_instances specifying the process ID.

  procedure archive_completed_instances
  ( p_completed_before         in date default trunc(sysdate)
  , p_process_id               in flow_processes.prcs_id%type default null  
  );

  procedure purge_instance_logs
  ( p_retention_period_days  in number default null
  );

end flow_log_admin;
/

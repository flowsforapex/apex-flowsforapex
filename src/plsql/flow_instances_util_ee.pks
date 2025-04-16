create or replace package flow_instances_util_ee
/* 
-- Flows for APEX - flow_instances_util_ee.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
-- Package Spec released under Flows for APEX Community Edition MIT licence.
--
-- Created  28-jan-2025  Richard Allen (Flowquest Limited)
--
*/
is 
  procedure suspend_process 
  ( p_process_id   in flow_processes.prcs_id%type
  , p_comment      in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure resume_process 
  ( p_process_id   in flow_processes.prcs_id%type
  , p_comment      in flow_instance_event_log.lgpr_comment%type default null
  );


end flow_instances_util_ee;
/

create or replace package flow_async_tasks_ee
/* 
-- Flows for APEX - flow_async_tasks_ee.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
-- Package Spec released under Flows for APEX Community Edition licence.
--
-- Created  17-Mar-2026  Richard Allen (Flowquest Limited)
--
*/
as

  procedure enqueue_async_step
  ( p_process_id      in flow_processes.prcs_id%type
  , p_subflow_id      in flow_subflows.sbfl_id%type
  , p_step_key        in flow_subflows.sbfl_step_key%type
  , p_enqueue_reason  in varchar2 default flow_constants_pkg.gc_async_before_key
  , p_extension       in clob default null
  );

  procedure dequeue_async_task
  ( context   raw
  , reginfo   sys.aq$_reg_info
  , descr     sys.aq$_descriptor
  , payload   raw
  , payloadl  number
  );

end flow_async_tasks_ee;
/
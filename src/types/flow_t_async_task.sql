/* 
-- Flows for APEX - flow_t_async_task.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created   17-Mar-2026 Richard Allen,  Flowquest Limited
--
-- File released under Flows for APEX Community Edition licence.
*/

/* Prior to running this, the Flows for APEX schema  user requires the following system privileges:
     create type

     Execute the following as a DB / Admin user
    
    GRANT CREATE TYPE TO Change_to_Your_F4A_Schema_name;

*/

  create or replace type flow_t_async_task as object
  ( prcs_id           number
  , sbfl_id           number
  , step_key          varchar2(20)
  , dgrm_id           number
  , current_objt_id   varchar2(100)
  , session_start_ts  timestamp with time zone
  , input_parameters  clob
  , callback_context  clob
  , enqueued_ts       timestamp with time zone
  , async_session_id  varchar2(50)
  , task_type         varchar2(50)
  , extension         clob
  );
  /

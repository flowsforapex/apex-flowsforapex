/* 
-- Flows for APEX - flow_t_correlated_message.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created   24-Feb-2025 Richard Allen,  Flowquest Limited
--
-- File released under Flows for APEX Community Edition licence.
*/

/* Prior to running this, the Flows for APEX schema  user requires the following system privileges:
     create type

     Execute the following as a DB / Admin user
    
    GRANT CREATE TYPE TO Change_to_Your_F4A_Schema_name;

*/

  create or replace type flow_t_correlated_message as object
  ( message_name  varchar2(200)
  , key_name      varchar2(200)
  , key_value     varchar2(200)
  , clob_payload  clob 
  , json_payload  clob
  , msub_id       number
  , prcs_id       number
  , sbfl_id       number
  , step_key      varchar2(20)
  , dgrm_id       number
  , callback      varchar2(200)
  , callback_par  varchar2(200)
  , payload_var   varchar2(50)
  , received_tstz timestamp with time zone
  , extension     clob
  );
  /


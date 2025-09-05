
create or replace package flow_ai_prompt_ee as
/* Flows for APEX Enterprise Edition Message Flow - file flow_ai_prompt_ee.pks

(c) Copyright, Flowquest Limited.  All Rights Reserved.  2024
Package Body released under Flows for APEX Enterprise Edition licence.

    10 Oct 2024   Created    Richard Allen (Flowquest)
*/

  function get_quick_actions
    return clob;

  function get_system_prompt
    return varchar2;

  function get_AI_message
  ( p_prompt_key    flow_ai_prompts.aipr_prompt_key%type
  ) return varchar2;

end flow_ai_prompt_ee;
/

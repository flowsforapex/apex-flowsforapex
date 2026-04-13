create or replace package flow_admin_api_ee
  authid definer
as
/* 
-- Flows for APEX Enterprise Edition - flow_admin_api_ee.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2026.
--
-- Created    12-Apr-2026  GitHub Copilot
--
*/

  function test_ai_connection
  ( p_ai_interface   in varchar2
  , p_ai_service     in varchar2 default null
  , p_ai_provider    in varchar2 default null
  , p_ai_model       in varchar2 default null
  , p_prompt         in clob default 'Hello AI World'
  ) return clob;

end flow_admin_api_ee;
/

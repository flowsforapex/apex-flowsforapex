create or replace package flow_gateways
/* 
-- Flows for APEX - flow_gateways.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Consulting Limited. 2024
--
-- Created    06-May-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   20-Jan-2024  Richard Allen, Flowquest Consulting Limited
--
*/
  authid definer
  accessible by (flow_engine, flow_settings)
as 

procedure process_para_incl_Gateway
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );
procedure process_exclusiveGateway
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

 procedure process_eventBasedGateway
  ( p_sbfl_info  in flow_subflows%rowtype
  , p_step_info  in flow_types_pkg.flow_step_info
  );

end flow_gateways;
/

/* 
-- Flows for APEX - flow_gateways.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    06-May-2021  Richard Allen (Flowquest, for MT AG)
--
*/

create or replace package flow_gateways
accessible by (flow_engine)
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

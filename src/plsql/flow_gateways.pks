create or replace package flow_gateways
/* 
-- Flows for APEX - flow_gateways.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Limited. 2024-25
--
-- Created    06-May-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   20-Jan-2024  Richard Allen, Flowquest Limited
--
*/
  authid definer
  accessible by (flow_engine, flow_settings, flow_rewind )
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

procedure get_nearest_previous_gateway
  ( pi_sbfl_rec                 in  flow_subflows%rowtype
  , po_nearest_gateway_bpmn_id out flow_objects.objt_bpmn_id%type
  , po_nearest_gateway_type    out flow_objects.objt_tag_name%type
  , po_nearest_gateway_name    out flow_objects.objt_name%type
  , po_num_steps               out integer
  );

procedure get_nearest_previous_opening_parincl_gateway
  ( pi_sbfl_rec                in  flow_subflows%rowtype
  , po_nearest_gateway_bpmn_id out flow_objects.objt_bpmn_id%type
  , po_nearest_gateway_type    out flow_objects.objt_tag_name%type
  , po_nearest_gateway_name    out flow_objects.objt_name%type
  , po_num_steps               out integer
  );

function get_matching_opening_gateway
  ( pi_sbfl_rec       in flow_subflows%rowtype
  ) return flow_objects.objt_bpmn_id%type;

end flow_gateways;
/

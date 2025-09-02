prompt --application/shared_components/logic/component_groups/flows_for_apex_components
begin
--   Manifest
--     COMPONENT GROUP: Flows for APEX Components
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_component_group(
 p_id=>wwv_flow_imp.id(4817123621810257)
,p_name=>'Flows for APEX Components'
,p_version_scn=>3820754388
,p_group_comment=>'Contains all of the components required in a Flows for APEX application.'
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4818250997788363)
,p_app_item_id=>wwv_flow_imp.id(4817631731796132)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4818421433788362)
,p_app_item_id=>wwv_flow_imp.id(4817822903793230)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4818745259788362)
,p_app_item_id=>wwv_flow_imp.id(4818094936791614)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4819861299780558)
,p_plugin_id=>wwv_flow_imp.id(5348613982934)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4820178057780558)
,p_plugin_id=>wwv_flow_imp.id(7028045730394045)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4819591311780558)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4819019978780559)
,p_plugin_id=>wwv_flow_imp.id(92418934266670712)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4819247630780558)
,p_plugin_id=>wwv_flow_imp.id(151286992364012459)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4820401783780558)
,p_plugin_id=>wwv_flow_imp.id(12315927534327459869)
);
wwv_flow_imp_shared.create_comp_grp_component(
 p_id=>wwv_flow_imp.id(4820725397780558)
,p_plugin_id=>wwv_flow_imp.id(52324636500430595707)
);
wwv_flow_imp.component_end;
end;
/

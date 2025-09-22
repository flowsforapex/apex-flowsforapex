prompt --application/shared_components/logic/application_items/subflow_id
begin
--   Manifest
--     APPLICATION ITEM: SUBFLOW_ID
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(4817822903793230)
,p_name=>'SUBFLOW_ID'
,p_protection_level=>'B'
,p_version_scn=>2476402114
);
wwv_flow_imp.component_end;
end;
/

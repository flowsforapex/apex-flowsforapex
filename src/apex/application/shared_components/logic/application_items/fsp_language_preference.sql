prompt --application/shared_components/logic/application_items/fsp_language_preference
begin
--   Manifest
--     APPLICATION ITEM: FSP_LANGUAGE_PREFERENCE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(9614743728201348)
,p_name=>'FSP_LANGUAGE_PREFERENCE'
,p_protection_level=>'I'
,p_escape_on_http_output=>'N'
,p_version_scn=>1760504921
);
wwv_flow_imp.component_end;
end;
/

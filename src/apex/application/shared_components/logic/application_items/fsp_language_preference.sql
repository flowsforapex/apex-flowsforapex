prompt --application/shared_components/logic/application_items/fsp_language_preference
begin
--   Manifest
--     APPLICATION ITEM: FSP_LANGUAGE_PREFERENCE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(9614743728201348)
,p_name=>'FSP_LANGUAGE_PREFERENCE'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/

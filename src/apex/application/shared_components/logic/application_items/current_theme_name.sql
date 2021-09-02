prompt --application/shared_components/logic/application_items/current_theme_name
begin
--   Manifest
--     APPLICATION ITEM: CURRENT_THEME_NAME
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
 p_id=>wwv_flow_api.id(6189993961233425)
,p_name=>'CURRENT_THEME_NAME'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/

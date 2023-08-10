prompt --application/shared_components/logic/application_items/app_name_title
begin
--   Manifest
--     APPLICATION ITEM: APP_NAME_TITLE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(34570520101106514)
,p_name=>'APP_NAME_TITLE'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/

prompt --application/shared_components/logic/application_items/flow_page_title
begin
--   Manifest
--     APPLICATION ITEM: FLOW_PAGE_TITLE
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
 p_id=>wwv_flow_api.id(34551546825917526)
,p_name=>'FLOW_PAGE_TITLE'
,p_protection_level=>'I'
);
wwv_flow_api.component_end;
end;
/

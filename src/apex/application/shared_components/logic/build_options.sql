prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(88199069651756122)
,p_build_option_name=>'Exclude'
,p_build_option_status=>'EXCLUDE'
);
wwv_flow_api.component_end;
end;
/

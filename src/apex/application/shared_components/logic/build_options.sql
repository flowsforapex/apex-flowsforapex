prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(88199069651756122)
,p_build_option_name=>'Exclude'
,p_build_option_status=>'EXCLUDE'
);
wwv_flow_imp.component_end;
end;
/

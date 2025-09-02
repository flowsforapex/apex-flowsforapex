prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(14832835672621379)
,p_build_option_name=>'Enterprise Edition'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>3787462948
,p_default_on_export=>'EXCLUDE'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(88199069651756122)
,p_build_option_name=>'Exclude'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>1760506490
);
wwv_flow_imp.component_end;
end;
/

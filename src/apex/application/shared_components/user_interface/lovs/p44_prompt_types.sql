prompt --application/shared_components/user_interface/lovs/p44_prompt_types
begin
--   Manifest
--     P44_PROMPT_TYPES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(12568179604221251)
,p_lov_name=>'P44_PROMPT_TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(12568179604221251)||'.'
,p_location=>'STATIC'
,p_version_scn=>2850265115
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12568477235221250)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'System'
,p_lov_return_value=>'system'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12568867645221249)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Welcome'
,p_lov_return_value=>'welcome'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12569240949221249)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Immediate Action'
,p_lov_return_value=>'immediateaction'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12569649774221249)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Quick Action'
,p_lov_return_value=>'quickaction'
);
wwv_flow_imp.component_end;
end;
/

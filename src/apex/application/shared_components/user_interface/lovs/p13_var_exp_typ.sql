prompt --application/shared_components/user_interface/lovs/p13_var_exp_typ
begin
--   Manifest
--     P13_VAR_EXP_TYP
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
 p_id=>wwv_flow_imp.id(15214828485777501)
,p_lov_name=>'P13_VAR_EXP_TYP'
,p_lov_query=>'.'||wwv_flow_imp.id(15214828485777501)||'.'
,p_location=>'STATIC'
,p_version_scn=>1760504928
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15215132143777515)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Static Value'
,p_lov_return_value=>'static'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15216223137803713)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Process Variable'
,p_lov_return_value=>'processVariable'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15216699385803714)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Item'
,p_lov_return_value=>'item'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15217004677803714)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'SQL Query (return single value)'
,p_lov_return_value=>'sqlQuerySingle'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15217473228803715)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'SQL Query (return colon separated value)'
,p_lov_return_value=>'sqlQueryList'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15217803205803716)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'PL/SQL Function Body'
,p_lov_return_value=>'plsqlFunctionBody'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15218228624803716)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'PL/SQL Expression'
,p_lov_return_value=>'plsqlExpression'
);
wwv_flow_imp.component_end;
end;
/

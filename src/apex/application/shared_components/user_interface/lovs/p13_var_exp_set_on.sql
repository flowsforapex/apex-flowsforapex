prompt --application/shared_components/user_interface/lovs/p13_var_exp_set_on
begin
--   Manifest
--     P13_VAR_EXP_SET_ON
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(15901843917364053)
,p_lov_name=>'P13_VAR_EXP_SET_ON'
,p_lov_query=>'.'||wwv_flow_api.id(15901843917364053)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15902102975364060)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Before Task'
,p_lov_return_value=>'beforeTask'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15902510563364061)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'After Task'
,p_lov_return_value=>'afterTask'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15902907108364061)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Before Event'
,p_lov_return_value=>'beforeEvent'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15903304316364061)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'On Event'
,p_lov_return_value=>'onEvent'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15903750919364061)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Before Split'
,p_lov_return_value=>'beforeSplit'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15904152776364061)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'After Merge'
,p_lov_return_value=>'afterMerge'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(62212194512228414)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'In Variables'
,p_lov_return_value=>'inVariables'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(62212467011228444)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Out Variables'
,p_lov_return_value=>'outVariables'
);
wwv_flow_api.component_end;
end;
/

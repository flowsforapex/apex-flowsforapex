prompt --application/shared_components/user_interface/lovs/p13_object_attributes
begin
--   Manifest
--     P13_OBJECT_ATTRIBUTES
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
 p_id=>wwv_flow_api.id(15330862223656536)
,p_lov_name=>'P13_OBJECT_ATTRIBUTES'
,p_lov_query=>'.'||wwv_flow_api.id(15330862223656536)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331159536656553)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Application'
,p_lov_return_value=>'apex:apex-application'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331535176656556)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Clear Cache'
,p_lov_return_value=>'apex:apex-cache'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331901949656556)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Item Values'
,p_lov_return_value=>'apex:apex-value'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15332307999656557)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Request'
,p_lov_return_value=>'apex:apex-request'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15332751649656557)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Page Items'
,p_lov_return_value=>'apex:apex-item'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333170482656557)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'PL/SQL Code'
,p_lov_return_value=>'apex:plsqlCode'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333581483656557)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'Bind Page Item Values'
,p_lov_return_value=>'apex:autoBinds'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333933530656557)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Engine'
,p_lov_return_value=>'apex:engine'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15334375925656558)
,p_lov_disp_sequence=>9
,p_lov_disp_value=>'Page'
,p_lov_return_value=>'apex:apex-page'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15373450429468526)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Process status after termination'
,p_lov_return_value=>'processStatus'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15373733235468542)
,p_lov_disp_sequence=>11
,p_lov_disp_value=>'Timer Definition Type'
,p_lov_return_value=>'timerType'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15374151920468542)
,p_lov_disp_sequence=>12
,p_lov_disp_value=>'Timer Definition'
,p_lov_return_value=>'timerDefinition'
);
wwv_flow_api.component_end;
end;
/

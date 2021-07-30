prompt --application/shared_components/logic/application_computations/app_name_title
begin
--   Manifest
--     APPLICATION COMPUTATION: APP_NAME_TITLE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(34570910330109834)
,p_computation_sequence=>10
,p_computation_item=>'APP_NAME_TITLE'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>'Flows for APEX'
);
wwv_flow_api.component_end;
end;
/

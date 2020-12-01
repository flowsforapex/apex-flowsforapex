prompt --application/shared_components/user_interface/lovs/p10_instance_connections_lov
begin
--   Manifest
--     P10_INSTANCE_CONNECTIONS_LOV
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
 p_id=>wwv_flow_api.id(3000126357622364)
,p_lov_name=>'P10_INSTANCE_CONNECTIONS_LOV'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'FLOW_INSTANCE_CONNECTIONS_LOV'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'src_objt_bpmn_id = :p10_gateway',
'and prcs_id = :p10_prcs_id'))
,p_return_column_name=>'CONN_BPMN_ID'
,p_display_column_name=>'CONN_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CONN_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/

prompt --application/shared_components/user_interface/lovs/p8_instance_gateways_lov
begin
--   Manifest
--     P8_INSTANCE_GATEWAYS_LOV
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
 p_id=>wwv_flow_api.id(2800147004522946)
,p_lov_name=>'P8_INSTANCE_GATEWAYS_LOV'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'FLOW_INSTANCE_GATEWAYS_LOV'
,p_query_where=>'prcs_id = :p8_prcs_id'
,p_return_column_name=>'OBJT_BPMN_ID'
,p_display_column_name=>'OBJT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'OBJT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/

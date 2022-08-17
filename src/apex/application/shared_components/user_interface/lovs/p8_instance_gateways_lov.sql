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
,p_query_where=>'prdg_id = :P8_PRDG_ID'
,p_return_column_name=>'OBJT_BPMN_ID'
,p_display_column_name=>'OBJT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'OBJT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(60613290222026477)
,p_query_column_name=>'OBJT_BPMN_ID'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(60613680131026481)
,p_query_column_name=>'OBJT_NAME'
,p_heading=>'Objt Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(60614013397026484)
,p_query_column_name=>'CALLING_OBJECT'
,p_heading=>'Calling Object'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(60614493307026485)
,p_query_column_name=>'PRDG_DIAGRAM_LEVEL'
,p_heading=>'Prdg Diagram Level'
,p_display_sequence=>40
,p_data_type=>'NUMBER'
);
wwv_flow_api.component_end;
end;
/

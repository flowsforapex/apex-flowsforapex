prompt --application/shared_components/user_interface/lovs/diagrams_parsed
begin
--   Manifest
--     DIAGRAMS_PARSED
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>984337
,p_default_id_offset=>0
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(599957119101802)
,p_lov_name=>'DIAGRAMS_PARSED'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'FLOW_DIAGRAMS_PARSED_LOV'
,p_return_column_name=>'DGRM_NAME'
,p_display_column_name=>'DGRM_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/

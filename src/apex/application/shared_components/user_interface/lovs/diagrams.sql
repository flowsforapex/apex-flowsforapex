prompt --application/shared_components/user_interface/lovs/diagrams
begin
--   Manifest
--     DIAGRAMS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>59800345087111703
,p_default_application_id=>480340
,p_default_id_offset=>13603073842510480015
,p_default_owner=>'FLOWSFORAPEX'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(146803569295347214)
,p_lov_name=>'DIAGRAMS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'DIAGRAMS'
,p_return_column_name=>'DGM_NAME'
,p_display_column_name=>'DGM_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'DGM_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/

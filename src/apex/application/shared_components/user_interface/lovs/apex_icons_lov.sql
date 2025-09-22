prompt --application/shared_components/user_interface/lovs/apex_icons_lov
begin
--   Manifest
--     APEX_ICONS_LOV
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
 p_id=>wwv_flow_imp.id(12461890405272053)
,p_lov_name=>'APEX_ICONS_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select icon_name as display_value',
'     , icon_name as return_value',
'     , icon_name as icon',
'  from APEX_DG_BUILTIN_FONTAPEX;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_icon_column_name=>'ICON'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>2843504695
);
wwv_flow_imp.component_end;
end;
/

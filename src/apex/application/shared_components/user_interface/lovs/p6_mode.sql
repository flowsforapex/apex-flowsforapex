prompt --application/shared_components/user_interface/lovs/p6_mode
begin
--   Manifest
--     P6_MODE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(13102745982982601)
,p_lov_name=>'P6_MODE'
,p_lov_query=>'.'||wwv_flow_imp.id(13102745982982601)||'.'
,p_location=>'STATIC'
,p_version_scn=>1760504935
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(13103030553982630)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'<span><span aria-hidden="true" class="fa fa-file-o fa-lg"></span><span style="display: block;">&APP_TEXT$APP_LOV_ONE_MODEL.</span></span>'
,p_lov_return_value=>'single'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(13103422381982643)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'<span><span aria-hidden="true" class="fa fa-files-o fa-lg"></span><span style="display: block;">&APP_TEXT$APP_LOV_MULTIPLE_MODELS.</span></span>'
,p_lov_return_value=>'multiple'
);
wwv_flow_imp.component_end;
end;
/

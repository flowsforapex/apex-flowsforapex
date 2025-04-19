prompt --application/shared_components/user_interface/shortcuts/delete_confirm_msg
begin
--   Manifest
--     SHORTCUT: DELETE_CONFIRM_MSG
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_shortcut(
 p_id=>wwv_flow_imp.id(12495496302977879965)
,p_shortcut_name=>'DELETE_CONFIRM_MSG'
,p_shortcut_type=>'TEXT_ESCAPE_JS'
,p_version_scn=>1760506517
,p_shortcut=>'Would you like to perform this delete action?'
);
wwv_flow_imp.component_end;
end;
/

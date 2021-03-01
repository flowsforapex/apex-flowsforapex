prompt --application/create_application
begin
--   Manifest
--     FLOW: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'FLOWS4APEX')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Flows for APEX')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'FLOWS4APEX')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'15B753D68F7A5467E3DD14853F094D31FD5E3C9E459C8DD99A84BD40F714D421'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'19.2'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_date_format=>'dd.mm.yyyy'
,p_date_time_format=>'dd.mm.yyyy hh24:mi:ss'
,p_timestamp_format=>'dd.mm.yyyy hh24:mi:ss'
,p_timestamp_tz_format=>'dd.mm.yyyy hh24:mi:ss'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_documentation_banner=>'Application created from create application wizard 2020.01.31.'
,p_authentication=>'PLUGIN'
,p_authentication_id=>wwv_flow_api.id(12495636783173880401)
,p_application_tab_set=>1
,p_logo_type=>'IT'
,p_logo=>'#APP_IMAGES#app-100-logo.png'
,p_logo_text=>'Flows for APEX'
,p_favicons=>'<link rel="icon" sizes="32x32" href="#APP_IMAGES#app-100-logo.png">'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 5.1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_authorize_batch_job=>'N'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_error_handling_function=>'apex_error_handling'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Workflow'
,p_last_updated_by=>'MOKLEIN'
,p_last_upd_yyyymmddhh24miss=>'20210226182209'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>24
,p_ui_type_name => null
);
wwv_flow_api.component_end;
end;
/

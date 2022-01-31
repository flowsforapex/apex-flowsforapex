prompt --application/deployment/install/install_publish_translations
begin
--   Manifest
--     INSTALL: INSTALL-Publish Translations
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_install_script(
 p_id=>wwv_flow_api.id(35320794740896782)
,p_install_id=>wwv_flow_api.id(17031066408817192)
,p_name=>'Publish Translations'
,p_sequence=>80
,p_script_type=>'INSTALL'
,p_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  apex_lang.publish_application(',
'    p_application_id => apex_application_install.get_application_id,',
'    p_language => ''fr'' ',
'  );',
'  commit;',
'end;'))
);
wwv_flow_api.component_end;
end;
/

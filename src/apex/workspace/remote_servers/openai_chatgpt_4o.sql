prompt --workspace/remote_servers/openai_chatgpt_4o
begin
--   Manifest
--     REMOTE SERVER: OpenAI ChatGPT 4o
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(1446946413060929)
,p_name=>'OpenAI ChatGPT 4o'
,p_static_id=>'F4A_AI_SERVICE'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('F4A_AI_SERVICE'),'https://api.openai.com/v1')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('F4A_AI_SERVICE'),'')
,p_server_type=>'GENERATIVE_AI'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('F4A_AI_SERVICE'),'')
,p_credential_id=>wwv_flow_imp.id(4444843643055631)
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('F4A_AI_SERVICE'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('F4A_AI_SERVICE'),'')
,p_prompt_on_install=>true
,p_ai_provider_type=>'OPENAI'
,p_ai_is_builder_service=>false
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('F4A_AI_SERVICE'),'gpt-4o')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('F4A_AI_SERVICE'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('F4A_AI_SERVICE'),'')
);
wwv_flow_imp.component_end;
end;
/

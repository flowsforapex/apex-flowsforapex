prompt --application/shared_components/logic/application_processes/css_tricks
begin
--   Manifest
--     APPLICATION PROCESS: CSS_TRICKS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(8120377472916762)
,p_process_sequence=>1
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'CSS_TRICKS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_version varchar2(4);',
'    l_user_style_id number := apex_theme.get_user_style(:APP_ID, :APP_USER, 42);',
'    l_user_style varchar2(100);',
'    l_debug boolean := apex_application.g_debug;',
'    l_file_exists number;',
'    l_directory varchar2(100);',
'    l_filename varchar2(100);',
'begin',
'    /* retrieve user theme setting */',
'    ',
'    if (l_user_style_id is not null ) then',
'        begin',
'            select name',
'            into l_user_style',
'            from apex_application_theme_styles',
'            where theme_style_id = l_user_style_id;',
'        exception',
'            when no_data_found',
'            then l_user_style := case :THEME_PLUGIN_CLASS when ''FLOWS'' then ''Vita'' else ''Vita - Dark'' end;',
'        end;',
'         ',
'    else',
'        l_user_style := case :THEME_PLUGIN_CLASS when ''FLOWS'' then ''Vita'' else ''Vita - Dark'' end;',
'    end if;',
'',
'    /* load theme specific file */',
'    ',
'    l_directory := ''css/'';',
'    l_filename := ''flows4apex.''||case l_user_style when ''Vita'' then ''light'' else ''dark'' end ||''.css'';',
'',
'    select count(*)',
'    into l_file_exists',
'    from apex_application_static_files',
'    where file_name = l_directory || l_filename',
'    and application_id = :app_id;',
'',
'    if (l_file_exists > 0) then',
'    l_filename := ''flows4apex.''||case l_user_style when ''Vita'' then ''light'' else ''dark'' end ||''#MIN#'';',
'        ',
'        APEX_CSS.ADD_FILE(',
'            p_name => l_filename',
'            , p_directory => ''#APP_IMAGES#''||l_directory',
'        );',
'    end if;',
'    ',
'    /* load version specific file */',
'',
'    select substr(version_no, 1, 4)',
'    into l_version',
'    from apex_release;',
'    ',
'    l_directory := ''css/'' || l_version || ''/'';',
'    l_filename := ''flows4apex.''||case l_user_style when ''Vita'' then ''light'' else ''dark'' end ||''.css'';',
'',
'    select count(*)',
'    into l_file_exists',
'    from apex_application_static_files',
'    where file_name = l_directory || l_filename',
'    and application_id = :app_id;',
'',
'    if (l_file_exists > 0) then',
'    l_filename := ''flows4apex.''||case l_user_style when ''Vita'' then ''light'' else ''dark'' end ||''#MIN#'';',
'        ',
'        APEX_CSS.ADD_FILE(',
'            p_name => l_filename',
'            , p_directory => ''#APP_IMAGES#''||l_directory',
'        );',
'    end if;',
'    ',
'    /* load prisma file */',
'    ',
'     APEX_CSS.ADD_FILE(',
'            p_name => ''prism'' || case l_user_style when ''Vita - Dark'' then ''.dark'' end ||''#MIN#''',
'            , p_directory => ''#APP_IMAGES#lib/prismjs/css/''',
'        ); ',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_version_scn=>1760504900
);
wwv_flow_imp.component_end;
end;
/

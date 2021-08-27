prompt --application/shared_components/user_interface/theme_style
begin
--   Manifest
--     THEME STYLE: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(5633999520827555)
,p_theme_id=>42
,p_name=>'FLOWS-DARK'
,p_is_current=>false
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita-Dark.less'
,p_theme_roller_config=>'{"customCSS":"/*Button in Flow Edit page next to version and status fiels*/\n\n.t-Button--simple:not(.t-Button--hot):not(.t-Button--danger):not(.t-Button--primary):not(.t-Button--success):not(.t-Button--warning) {\n  background-color: #4c4e50 !import'
||'ant;\n  color: #fff!important;\n}\n\n.t-Button--simple:not(.t-Button--hot):not(.t-Button--danger):not(.t-Button--primary):not(.t-Button--success):not(.t-Button--warning).is-active, .t-Button--simple:not(.t-Button--hot):not(.t-Button--danger):not(.t-B'
||'utton--primary):not(.t-Button--success):not(.t-Button--warning):focus, .t-Button--simple:not(.t-Button--hot):not(.t-Button--danger):not(.t-Button--primary):not(.t-Button--success):not(.t-Button--warning):hover {\n  background-color: #65686a !importan'
||'t;\n}\n\n/*Disabled menu*/\n\n.a-Menu .a-Menu-item.is-disabled .a-Menu-accel,\n.a-Menu .a-Menu-item.is-disabled .a-Menu-label {\n  color:rgb(144, 146, 147) !important;\n}\n\n/*IR controls when expanded*/\n.a-IG-controlsLabel,\n.a-IRR-controlsLabel {\'
||'n  background-color:#222629 !important;\n}\n\n.a-Menu .a-Menu-item.is-disabled.is-focused {\n  color: rgba(254, 254, 254, 0.5);\n  background-color: #6c6c6c75;\n}\n.a-Menu .a-Menu-item.is-disabled.is-focused > .a-Menu-inner .a-Menu-statusCol,\n.a-Men'
||'u .a-Menu-item.is-disabled.is-focused > .a-Menu-inner .a-Menu-accel {\n  color: rgb(144, 146, 147);\n  opacity: 1;\n}\n\n/*Date picker*/\n\n#ui-timepicker-divhour, #ui-timepicker-divminute {\n  background: #3f4244;\n  border-color: #646464;\n  border'
||'-radius: 8px;\n}\n#ui-timepicker-divhour:hover, #ui-timepicker-divminute:hover {\n  background: #646464;\n}\n\n.ui-datepicker-month, .ui-datepicker-year {\n  background-color: inherit;\n}\n\n.current-process:not([headers*=\"instance_status_col\"]) {\'
||'n  background-color: rgba(255, 255, 255, 0.14) !important;\n}\n\n/*Confirm dialog title background*/\nbody .ui-dialog .ui-dialog-titlebar {\n  background-color: #222629!important;\n}","vars":{}}'
,p_theme_roller_output_file_url=>'#THEME_DB_IMAGES#5633999520827555.css'
,p_theme_roller_read_only=>false
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(26992397294947328)
,p_theme_id=>42
,p_name=>'FLOWS'
,p_is_current=>true
,p_is_public=>true
,p_is_accessible=>true
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita.less'
,p_theme_roller_config=>'{"customCSS":".current-process:not([headers*=instance_status_col]){\n  background-color: rgba(0,0,0,.1)!important;\n}","vars":{"@Head-Height":"48px"}}'
,p_theme_roller_output_file_url=>'#THEME_DB_IMAGES#26992397294947328.css'
,p_theme_roller_read_only=>false
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(88100455406008715)
,p_theme_id=>42
,p_name=>'Vista'
,p_css_file_urls=>'#THEME_IMAGES#css/Vista#MIN#.css?v=#APEX_VERSION#'
,p_is_current=>false
,p_is_public=>false
,p_is_accessible=>false
,p_theme_roller_read_only=>true
,p_reference_id=>4007676303523989775
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(88100946570008715)
,p_theme_id=>42
,p_name=>'Vita'
,p_is_current=>false
,p_is_public=>true
,p_is_accessible=>true
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita.less'
,p_theme_roller_output_file_url=>'#THEME_IMAGES#css/Vita#MIN#.css?v=#APEX_VERSION#'
,p_theme_roller_read_only=>true
,p_reference_id=>2719875314571594493
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(88101292435008715)
,p_theme_id=>42
,p_name=>'Vita - Dark'
,p_is_current=>false
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita-Dark.less'
,p_theme_roller_output_file_url=>'#THEME_IMAGES#css/Vita-Dark#MIN#.css?v=#APEX_VERSION#'
,p_theme_roller_read_only=>true
,p_reference_id=>3543348412015319650
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(88101721771008715)
,p_theme_id=>42
,p_name=>'Vita - Red'
,p_is_current=>false
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita-Red.less'
,p_theme_roller_output_file_url=>'#THEME_IMAGES#css/Vita-Red#MIN#.css?v=#APEX_VERSION#'
,p_theme_roller_read_only=>true
,p_reference_id=>1938457712423918173
);
wwv_flow_api.create_theme_style(
 p_id=>wwv_flow_api.id(88102136662008716)
,p_theme_id=>42
,p_name=>'Vita - Slate'
,p_is_current=>false
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_IMAGES#less/theme/Vita-Slate.less'
,p_theme_roller_output_file_url=>'#THEME_IMAGES#css/Vita-Slate#MIN#.css?v=#APEX_VERSION#'
,p_theme_roller_read_only=>true
,p_reference_id=>3291983347983194966
);
wwv_flow_api.component_end;
end;
/

prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Getting Started'
,p_alias=>'GETTING-STARTED'
,p_step_title=>'Getting Started - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10603774502745437)
,p_plug_name=>'Getting Started'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h2>Flows for APEX</h2>',
'<h3>A Low code, BPMN-based Process Flow system for APEX.</h3>',
'<h4> Features</h4>',
'<ul>',
'<li>Flows for APEX enables APEX developers to model and run process flows in APEX using a combination of visual process design and low-code techniques.</li>',
'<li>Designed primarily for APEX developers, Flows for APEX uses the technologies that you are already familiar with - APEX, PL/SQL, and SQL - to create powerful and flexible process flows in your APEX environment.</li>',
'<li>Used to create and execute a process flow of APEX pages, PL/SQL scripts, send email.</li>',
'<li> The low-code diagrammatic process definition can also be understood and edited by business users to increase business flexibility.  Flows use the Business Process Modeling Notation (BPMN) V2 style</li>',
'<li>Built as an APEX community project, and released on an open source, MIT licence.</li>',
'</ul>',
'<p>',
'<h4>Download</h4>',
'<a href="https://flowsforapex.org" target="_blank">flowsforapex.org</a>',
'<p>',
'<h4>Documentation</h4>',
'<a href="https://flowsforapex.org/latest/getting-started/" target="_blank">Latest Documentation Online</a>',
'<p>',
'<h4>BPMN Tutorials</h4>',
'To get you started with modelling flows, try out the preinstalled tutorial flows. For further information on the tutorials have a look <a href="https://flowsforapex.org/latest/tutorials/" target="_blank">here</a>.',
'<p>',
'<h4>Demo App</h4>',
'<p>Take a look at our <a href="https://flowsforapex.org" target="_blank">website</a> to see how the integration of a flow can be done.'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(16518361588787101)
,p_plug_name=>'Getting Started'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_imp.id(12495589722092880240)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp.component_end;
end;
/

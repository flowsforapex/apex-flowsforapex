prompt --application/deployment/definition
begin
--   Manifest
--     INSTALL: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>984337
,p_default_id_offset=>0
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_install(
 p_id=>wwv_flow_api.id(13149005738210099868)
,p_deinstall_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'drop view "FLOW_R_DRGM_VW"',
'/',
'',
'drop view "FLOW_P0001_VW"',
'/',
'',
'drop view "FLOW_P0003_VW"',
'/',
'',
'drop view "FLOW_P0010_VW"',
'/',
'',
'drop view "FLOW_P0010_2_VW"',
'/',
'',
'drop view "FLOW_P0010_3_VW"',
'/',
'',
'drop table "FLOW_CONNECTIONS"',
'/',
'',
'drop table "FLOW_PROCESSES"',
'/',
'',
'drop table "FLOW_OBJECTS"',
'/',
'',
'drop table "FLOW_DIAGRAMS" ',
'/',
'',
'drop package body "FLOW_API_PKG"',
'/',
'',
'drop package "FLOW_API_PKG"',
'/',
'',
'drop package body "FLOW_BPMN_PARSER_PKG"',
'/',
'',
'drop package "FLOW_BPMN_PARSER_PKG"',
'/'))
,p_required_free_kb=>100
,p_required_sys_privs=>'CREATE PROCEDURE:CREATE TABLE:CREATE VIEW'
,p_required_names_available=>'FLOW_API_PKG:FLOW_BPMN_PARSER_PKG:FLOW_CONNECTIONS:FLOW_DIAGRAMS:FLOW_OBJECTS:FLOW_P0001_VW:FLOW_P0003_VW:FLOW_P0010_2_VW:FLOW_P0010_3_VW:FLOW_P0010_VW:FLOW_PROCESSES'
);
wwv_flow_api.component_end;
end;
/

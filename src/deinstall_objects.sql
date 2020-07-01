PROMPT >> Removing Flows4APEX Database Objects
PROMPT >> ====================================

PROMPT >> Packages
drop package flow_p0003_api;
drop package flow_p0010_api;
drop package flow_bpmn_parser_pkg;
drop package flow_api_pkg;

PROMPT >> Views
drop view flow_dgrm_lov;
drop view flow_p0001_vw;
drop view flow_p0003_vw;
drop view flow_p0010_vw;
drop view flow_p0010_branches_vw;
drop view flow_p0010_instances_vw;
drop view flow_p0010_subflows_vw;

PROMPT >> Tables
drop table flow_connections cascade constraints;
drop table flow_objects cascade constraints;
drop table flow_processes cascade constraints;
drop table flow_subflows cascade constraints;
drop table flow_subflow_log cascade constraints;
drop table flow_diagrams cascade constraints;

PROMPT >> Finished Removal of Flows4APEX Database Objects
PROMPT >> ===============================================

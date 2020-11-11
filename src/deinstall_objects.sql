PROMPT >> Removing Flows4APEX Database Objects
PROMPT >> ====================================

PROMPT >> Packages
drop package flow_p0003_api;
drop package flow_p0010_api;
drop package flow_bpmn_parser_pkg;
drop package flow_process_vars;
drop package flow_engine;
drop package flow_api_pkg;
drop package flow_timers_pkg;
drop package flow_types_pkg;
drop package flow_constants_pkg;

PROMPT >> Views
drop view flow_p0001_vw;
drop view flow_p0003_vw;
drop view flow_p0010_vw;
drop view flow_p0010_branches_vw;
drop view flow_p0010_instances_vw;
drop view flow_p0010_subflows_vw;
drop view flow_instance_inbox_vw;
drop view flow_instance_details_vw;
drop view flow_instance_variables_vw;
drop view flow_instances_vw;
drop view flow_subflows_vw;
drop view flow_diagrams_lov;
drop view flow_diagrams_parsed_lov;

PROMPT >> Tables
drop table flow_connections cascade constraints;
drop table flow_objects cascade constraints;
drop table flow_processes cascade constraints;
drop table flow_subflows cascade constraints;
drop table flow_subflow_log cascade constraints;
drop table flow_diagrams cascade constraints;
drop table flow_timers cascade constraints;
drop table flow_object_attributes cascade constraints;
drop table flow_tasks cascade constraints;
drop table flow_scripts cascade constraints;
drop table flow_script_parameters cascade constraints;
drop table flow_process_variables cascade constraints;

PROMPT >> Finished Removal of Flows4APEX Database Objects
PROMPT >> ===============================================

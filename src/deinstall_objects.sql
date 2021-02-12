PROMPT >> Removing Flows4APEX Database Objects
PROMPT >> ====================================

PROMPT >> Packages
drop package flow_p0002_api;
drop package flow_p0005_api;
drop package flow_p0010_api;
drop package flow_plsql_runner_pkg;
drop package flow_usertask_pkg;
drop package flow_bpmn_parser_pkg;
drop package flow_process_vars;
drop package flow_engine;
drop package flow_api_pkg;
drop package flow_timers_pkg;
drop package flow_types_pkg;
drop package flow_constants_pkg;
drop package flow_usertask_pkg;

PROMPT >> Views
drop view flow_p0002_diagrams_vw;
drop view flow_p0002_instances_counter_vw;
drop view flow_p0010_vw;
drop view flow_p0010_branches_vw;
drop view flow_p0010_instances_vw;
drop view flow_p0010_subflows_vw;
drop view flow_p0010_routes_vw;
drop view flow_p0010_variables_vw;
drop view flow_task_inbox_vw;
drop view flow_instance_connections_lov;
drop view flow_instance_gateways_lov;
drop view flow_instance_details_vw;
drop view flow_instance_variables_vw;
drop view flow_instances_vw;
drop view flow_subflows_vw;
drop view flow_diagram_categories_lov;
drop view flow_diagrams_lov;
drop view flow_diagrams_parsed_lov;
drop view flow_diagrams_vw;

PROMPT >> Tables
drop table flow_connections cascade constraints;
drop table flow_objects cascade constraints;
drop table flow_processes cascade constraints;
drop table flow_subflows cascade constraints;
drop table flow_subflow_log cascade constraints;
drop table flow_diagrams cascade constraints;
drop table flow_timers cascade constraints;
drop table flow_object_attributes cascade constraints;
drop table flow_process_variables cascade constraints;

PROMPT >> Finished Removal of Flows4APEX Database Objects
PROMPT >> ===============================================

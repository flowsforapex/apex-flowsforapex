PROMPT >> Removing Flows4APEX Database Objects
PROMPT >> ====================================

PROMPT >> Functions
drop function apex_error_handling;

PROMPT >> Packages
drop package flow_logging;
drop package flow_plsql_runner_pkg;
drop package flow_services;
drop package flow_usertask_pkg;
drop package flow_tasks;
drop package flow_boundary_events;
drop package flow_bpmn_parser_pkg;
drop package flow_migrate_xml_pkg;
drop package flow_expressions;
drop package flow_process_vars;
drop package flow_proc_vars_int;
drop package flow_instances;
drop package flow_engine;
drop package flow_api_pkg;
drop package flow_timers_pkg;
drop package flow_reservations;
drop package flow_gateways;
drop package flow_engine_util;
drop package flow_types_pkg;
drop package flow_constants_pkg;
drop package flow_engine_app_api;
drop package flow_apex_session;
drop package flow_errors;
drop package flow_globals;
drop package flow_diagram;
drop package flow_theme_api;
drop package flow_apex_env;

PROMPT >> Modeler Plugin Objects
drop package flow_modeler;

PROMPT >> Viewer Plugin Objects
drop package flow_viewer;

PROMPT >> Process Plugin Objects
drop package flow_plugin_manage_instance;
drop package flow_plugin_manage_instance_step;
drop package flow_plugin_manage_instance_variables;

PROMPT >> Views
drop view flow_p0002_diagrams_vw;
drop view flow_p0007_vw;
drop view flow_p0007_instances_counter_vw;
drop view flow_p0008_instance_details_vw;
drop view flow_p0008_instance_log_vw;
drop view flow_p0008_subflows_vw;
drop view flow_p0008_variables_vw;
drop view flow_p0008_vw;
drop view flow_p0010_instances_vw;
drop view flow_p0010_vw;
drop view flow_p0013_attributes_vw;
drop view flow_p0013_expressions_vw;
drop view flow_p0013_instance_log_vw;
drop view flow_p0013_step_log_vw;
drop view flow_p0013_subflows_vw;
drop view flow_p0013_variable_log_vw;
drop view flow_p0014_instance_log_vw;
drop view flow_p0014_step_log_vw;
drop view flow_p0014_subflows_vw;
drop view flow_p0014_variable_log_vw;
drop view flow_task_inbox_vw;
drop view flow_instance_connections_lov;
drop view flow_instance_gateways_lov;
drop view flow_instance_details_vw;
drop view flow_instance_variables_vw;
drop view flow_instances_vw;
drop view flow_subflows_vw;
drop view flow_diagram_categories_lov;
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
drop table flow_object_expressions cascade constraints;
drop table flow_flow_event_log cascade constraints;
drop table flow_instance_event_log cascade constraints;
drop table flow_instance_diagrams cascade constraints;
drop table flow_step_event_log cascade constraints;
drop table flow_variable_event_log cascade constraints;
drop table flow_configuration cascade constraints;
drop table flow_messages cascade constraints;


PROMPT >> Finished Removal of Flows4APEX Database Objects
PROMPT >> ===============================================

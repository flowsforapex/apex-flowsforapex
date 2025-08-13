PROMPT >> Removing Flows4APEX Database Objects
PROMPT >> ====================================

PROMPT >> Scheduler Objects
sys.dbms_scheduler.drop_job     (job_name => 'APEX_FLOW_STEP_TIMERS_J');
sys.dbms_scheduler.drop_program (program_name => 'APEX_FLOW_STEP_TIMERS_P');
sys.dbms_scheduler.drop_program (program_name => 'APEX_FLOW_CANCEL_APEX_TASK_P');

PROMPT >> Packages
drop package flow_logging;
drop package flow_plsql_runner_pkg;
drop package flow_services;
drop package flow_usertask_pkg;
drop package flow_tasks;
drop package flow_boundary_events;
drop package flow_bpmn_parser_pkg;
drop package flow_parser_util;
drop package flow_migrate_xml_pkg;
drop package flow_expressions;
drop package flow_settings;
drop package flow_db_exec;
drop package flow_message_flow;
drop package flow_message_util;
drop package flow_message_util_ee;
drop package flow_proc_vars_int;
drop package flow_instances;
drop package flow_instances_util_ee;
drop package flow_rewind;
drop package flow_engine;
drop package flow_api_pkg;
drop package flow_admin_api;
drop package flow_timers_pkg;
drop package flow_reservations;
drop package flow_gateways;
drop package flow_iteration;
drop package flow_engine_util;
drop package flow_types_pkg;
drop package flow_constants_pkg;
drop package flow_engine_app_api;
drop package flow_call_activities;
drop package flow_subprocesses;
drop package flow_apex_session;
drop package flow_errors;
drop package flow_globals;
drop package flow_diagram;
drop package flow_theme_api;
drop package flow_apex_env;
drop package flow_log_admin;
drop package flow_process_vars;
drop package flow_statistics;
drop package flow_simple_form_template;
drop package flow_rest_constants;
drop package flow_rest;
drop package flow_rest_auth;
drop package flow_rest_logging;
drop package flow_rest_response;
drop package flow_rest_errors;
drop package flow_rest_api_v1;
drop package flow_rest_install;

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
drop view flow_p0007_diagrams_var_vw;
drop view flow_p0007_diagrams_attributes_vw;
drop view flow_p0008_instance_details_vw;
drop view flow_p0007_called_diagrams_vw;
drop view flow_p0007_calling_diagrams_vw;
drop view flow_p0008_instance_log_vw;
drop view flow_p0008_message_subscriptions_vw;
drop view flow_p0008_subflows_vw;
drop view flow_p0008_variables_vw;
drop view flow_p0008_vw;
drop view flow_p0010_vw;
drop view flow_p0010_instances_vw;
drop view flow_p0013_attributes_vw;
drop view flow_p0013_expressions_vw;
drop view flow_p0013_instance_log_vw;
drop view flow_p0013_step_log_vw;
drop view flow_p0013_subflows_vw;
drop view flow_p0013_variable_log_vw;
drop view flow_p0013_called_diagrams_vw;
drop view flow_p0014_instance_log_vw;
drop view flow_p0014_step_log_vw;
drop view flow_p0014_subflows_vw;
drop view flow_p0014_variable_log_vw;
drop view flow_p0020_instance_timeline_vw;
drop view flow_task_inbox_vw;
drop view flow_instance_connections_lov;
drop view flow_instance_scopes_vw;
drop view flow_instance_gateways_lov;
drop view flow_instance_details_vw;
drop view flow_instance_timeline_vw;
drop view flow_instance_variables_vw;
drop view flow_instances_vw;
drop view flow_subflows_vw;
drop view flow_diagram_categories_lov;
drop view flow_diagrams_parsed_lov;
drop view flow_diagrams_vw;
drop view flow_instance_diagrams_lov;
drop view flow_diagrams_instanciated_lov;
drop view flow_startable_diagrams_vw;
drop view flow_message_subscriptions_vw;
drop view flow_rest_diagrams_vw;
drop view flow_rest_message_subscriptions_vw;
drop view flow_rest_process_vars_vw;
drop view flow_rest_processes_vw;
drop view flow_rest_subflows_vw;
drop view flow_viewer_vw;
drop view flow_apex_my_combined_task_list_vw;
drop view flow_apex_task_inbox_my_tasks_vw;
drop view flow_apex_task_inbox_vw;
drop view flow_ai_prompts_vw;
drop view flow_variable_event_timeline_vw

PROMPT >> Tables
drop table flow_connections cascade constraints;
drop table flow_objects cascade constraints;
drop table flow_message_subscriptions cascade constraints;
drop table flow_processes cascade constraints;
drop table flow_iterations cascade constraints;
drop table flow_iterated_objects cascade constraints;
drop table flow_subflows cascade constraints;
drop table flow_subflow_log cascade constraints;
drop table flow_diagrams cascade constraints;
drop table flow_timers cascade constraints;
drop table flow_process_variables cascade constraints;
drop table flow_object_expressions cascade constraints;
drop table flow_flow_event_log cascade constraints;
drop table flow_instance_event_log cascade constraints;
drop table flow_instance_diagrams cascade constraints;
drop table flow_step_event_log cascade constraints;
drop table flow_variable_event_log cascade constraints;
drop table flow_configuration cascade constraints;
drop table flow_messages cascade constraints;
drop table flow_instance_stats cascade constraints;
drop table flow_message_received_log cascade constraints;
drop table flow_parser_log cascade constraints;
drop table flow_stats_history cascade constraints;
drop table flow_step_stats cascade constraints;
drop table flow_rest_event_log cascade constraints;
drop table flow_iterations cascade constraints;
drop table flow_iterated_objects cascade constraints;
drop table flow_simple_form_templates cascade constraints;
drop table flow_ai_prompts cascade constraints;
drop table flow_bpmn_types cascade constraints;

PROMPT >> Finished Removal of Flows4APEX Database Objects
PROMPT >> ===============================================

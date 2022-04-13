/*
  Contains all calls which do not differ between scratch or migrate.
  Pretty much everything which has "create or replace" option
*/

PROMPT >> Installing Engine Objects
PROMPT >> =================
PROMPT >> Installing Package Specifications
@plsql/flow_types_pkg.pks
@plsql/flow_constants_pkg.pks
@plsql/flow_migrate_xml_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks
@plsql/flow_api_pkg.pks
@plsql/flow_engine_util.pks
@plsql/flow_gateways.pks
@plsql/flow_boundary_events.pks
@plsql/flow_tasks.pks
@plsql/flow_services.pks
@plsql/flow_timers_pkg.pks
@plsql/flow_instances.pks
@plsql/flow_engine.pks
@plsql/flow_reservations.pks
@plsql/flow_proc_vars_int.pks
@plsql/flow_process_vars.pks
@plsql/flow_expressions.pks
@plsql/flow_usertask_pkg.pks
@plsql/flow_plsql_runner_pkg.pks
@plsql/flow_logging.pks
@plsql/flow_globals.pks
@plsql/flow_errors.pks
@plsql/flow_diagram.pks
@plsql/flow_subprocesses.pks
@plsql/flow_call_activities.pks

PROMPT >> Installing Views
@views/flow_instances_vw.sql
@views/flow_subflows_vw.sql
@views/flow_diagrams_parsed_lov.sql
@views/flow_diagram_categories_lov.sql
@views/flow_instance_details_vw.sql
@views/flow_instance_variables_vw.sql
@views/flow_task_inbox_vw.sql
@views/flow_instance_connections_lov.sql
@views/flow_instance_gateways_lov.sql
@views/flow_diagrams_vw.sql

PROMPT >> Installing Package Bodies
@plsql/flow_proc_vars_int.pkb
@plsql/flow_process_vars.pkb
@plsql/flow_expressions.pkb
@plsql/flow_reservations.pkb
@plsql/flow_engine_util.pkb
@plsql/flow_gateways.pkb
@plsql/flow_boundary_events.pkb
@plsql/flow_tasks.pkb
@plsql/flow_services.pkb
@plsql/flow_instances.pkb
@plsql/flow_engine.pkb
@plsql/flow_api_pkg.pkb
@plsql/flow_migrate_xml_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb
@plsql/flow_timers_pkg.pkb
@plsql/flow_usertask_pkg.pkb
@plsql/flow_plsql_runner_pkg.pkb
@plsql/flow_logging.pkb
@plsql/flow_globals.pkb
@plsql/flow_errors.pkb
@plsql/flow_diagram.pkb
@plsql/flow_subprocesses.pkb
@plsql/flow_call_activities.pkb


PROMPT >> Installing Engine-App Objects
PROMPT >> =============================
PROMPT >> Global App Package Specifications
@plsql/engine-app/flow_engine_app_api.pks
@plsql/engine-app/flow_theme_api.pks

PROMPT >> Global Error Function
@plsql/engine-app/apex_error_handling.sql

PROMPT >> Page Views
@views/engine-app/flow_p0002_diagrams_vw.sql
@views/engine-app/flow_p0007_instances_counter_vw.sql
@views/engine-app/flow_p0007_vw.sql
@views/engine-app/flow_p0008_instance_details_vw.sql
@views/engine-app/flow_p0008_instance_log_vw.sql
@views/engine-app/flow_p0008_subflows_vw.sql
@views/engine-app/flow_p0008_variables_vw.sql
@views/engine-app/flow_p0008_vw.sql
@views/engine-app/flow_p0010_instances_vw.sql
@views/engine-app/flow_p0010_vw.sql
@views/engine-app/flow_p0013_attributes_vw.sql
@views/engine-app/flow_p0013_expressions_vw.sql
@views/engine-app/flow_p0013_instance_log_vw.sql
@views/engine-app/flow_p0013_step_log_vw.sql
@views/engine-app/flow_p0013_subflows_vw.sql
@views/engine-app/flow_p0013_variable_log_vw.sql
@views/engine-app/flow_p0014_instance_log_vw.sql
@views/engine-app/flow_p0014_step_log_vw.sql
@views/engine-app/flow_p0014_subflows_vw.sql
@views/engine-app/flow_p0014_variable_log_vw.sql

PROMPT >> Global App Package Body
@plsql/engine-app/flow_engine_app_api.pkb
@plsql/engine-app/flow_theme_api.pkb

PROMPT >> Process Plugin Objects
@plugins/manage-flow-instance/plsql/flow_plugin_manage_instance.pks
@plugins/manage-flow-instance/plsql/flow_plugin_manage_instance.pkb
@plugins/manage-flow-instance-step/plsql/flow_plugin_manage_instance_step.pks
@plugins/manage-flow-instance-step/plsql/flow_plugin_manage_instance_step.pkb
@plugins/manage-flow-instance-variables/plsql/flow_plugin_manage_instance_variables.pks
@plugins/manage-flow-instance-variables/plsql/flow_plugin_manage_instance_variables.pkb

PROMPT >> Modeler Plugin Objects
@plugins/modeler/plsql/flow_modeler.pks
@plugins/modeler/plsql/flow_modeler.pkb

PROMPT >> Viewer Plugin Objects
@plugins/viewer/plsql/flow_viewer.pks
@plugins/viewer/plsql/flow_viewer.pkb

PROMPT >> Engine Messages
@data/install_engine_messages_en.sql
@data/install_engine_messages_fr.sql

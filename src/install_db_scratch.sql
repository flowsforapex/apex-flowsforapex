set define '^'
set concat '.'

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_scratch.sql

PROMPT >> Installing Engine Objects
PROMPT >> =================
PROMPT >> Installing Package Specifications
@plsql/flow_types_pkg.pks
@plsql/flow_constants_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks
@plsql/flow_api_pkg.pks
@plsql/flow_engine_util.pks
@plsql/flow_gateways.pks
@plsql/flow_boundary_events.pks
@plsql/flow_tasks.pks
@plsql/flow_timers_pkg.pks
@plsql/flow_instances.pks
@plsql/flow_engine.pks
@plsql/flow_reservations.pks
@plsql/flow_process_vars.pks
@plsql/flow_expressions.pks
@plsql/flow_usertask_pkg.pks
@plsql/flow_plsql_runner_pkg.pks
@plsql/flow_logging.pks
@plsql/flow_globals.pks
@plsql/flow_errors.pks


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
@views/flow_diagram_categories_lov.sql

PROMPT >> Installing Package Bodies
@plsql/flow_process_vars.pkb
@plsql/flow_expressions.pkb
@plsql/flow_reservations.pkb
@plsql/flow_engine_util.pkb
@plsql/flow_gateways.pkb
@plsql/flow_boundary_events.pkb
@plsql/flow_tasks.pkb
@plsql/flow_instances.pkb
@plsql/flow_engine.pkb
@plsql/flow_api_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb
@plsql/flow_timers_pkg.pkb
@plsql/flow_usertask_pkg.pkb
@plsql/flow_plsql_runner_pkg.pkb
@plsql/flow_logging.pkb
@plsql/flow_globals.pkb
@plsql/flow_errors.pkb

PROMPT >> Installing Initial Engine Data
PROMPT >> =============================
PROMPT >> 

@data/install_default_config_data.sql
@data/install_engine_messages.sql


PROMPT >> Installing Engine-App Objects
PROMPT >> =============================
PROMPT >> Page API Specifications
@plsql/engine-app/flow_p0005_api.pks
@plsql/engine-app/flow_p0006_api.pks
@plsql/engine-app/flow_p0007_api.pks
@plsql/engine-app/flow_p0010_api.pks

PROMPT >> Global Error Function
@plsql/engine-app/apex_error_handling.sql;

PROMPT >> Page Views
@views/engine-app/flow_p0010_vw.sql
@views/engine-app/flow_p0010_instances_vw.sql
@views/engine-app/flow_p0010_subflows_vw.sql
@views/engine-app/flow_p0010_branches_vw.sql
@views/engine-app/flow_p0010_routes_vw.sql
@views/engine-app/flow_p0010_variables_vw.sql
@views/engine-app/flow_p0002_diagrams_vw.sql
@views/engine-app/flow_p0007_instances_counter_vw.sql
@views/engine-app/flow_p0013_attributes_vw.sql
@views/engine-app/flow_p0013_expressions_vw.sql
@views/engine-app/flow_p0013_subflows_vw.sql
@views/engine-app/flow_p0013_subflow_low_vw.sql
@views/engine-app/flow_p0013_variable_log_vw.sql
@views/engine-app/flow_p0014_instance_log_vw.sql
@views/engine-app/flow_p0014_subflows_vw.sql
@views/engine-app/flow_p0014_subflow_log_vw.sql

PROMPT >> Page API Bodies
@plsql/engine-app/flow_p0005_api.pkb
@plsql/engine-app/flow_p0006_api.pkb
@plsql/engine-app/flow_p0007_api.pkb
@plsql/engine-app/flow_p0010_api.pkb

PROMPT >> Modeler Plugin Objects
@plugins/modeler/plsql/flow_modeler.pks
@plugins/modeler/plsql/flow_modeler.pkb

PROMPT >> Viewer Plugin Objects
@plugins/viewer/plsql/flow_viewer.pks
@plugins/viewer/plsql/flow_viewer.pkb


PROMPT >> Checking for invalid Objects
  select object_type || ': ' || object_name as invalid_object
    from user_objects
   where status = 'INVALID'
order by object_type
       , object_name
;

PROMPT >> =====================
PROMPT >> Installation Finished
PROMPT >> =====================

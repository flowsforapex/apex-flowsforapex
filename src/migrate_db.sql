set define '^'
set concat '.'

define from_version = ^1.
define to_version   = ^2.

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Updating Tables
@ddl/migrate_^from_version._to_^to_version..sql

PROMPT >> Installing Engine Objects
PROMPT >> =================
PROMPT >> Installing Package Specifications
@plsql/flow_types_pkg.pks
@plsql/flow_constants_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks
@plsql/flow_api_pkg.pks
@plsql/flow_timers_pkg.pks
@plsql/flow_engine.pks
@plsql/flow_process_vars.pks
@plsql/flow_usertask_pkg.pks
@plsql/flow_plsql_runner_pkg.pks

PROMPT >> Installing Views
@views/flow_instances_vw.sql
@views/flow_subflows_vw.sql
@views/flow_diagrams_lov.sql
@views/flow_diagrams_parsed_lov.sql
@views/flow_diagram_categories_lov.sql
@views/flow_instance_details_vw.sql
@views/flow_instance_variables_vw.sql
@views/flow_task_inbox_vw.sql
@views/flow_instance_connections_lov.sql;
@views/flow_instance_gateways_lov.sql;
@views/flow_diagrams_vw.sql

PROMPT >> Installing Package Bodies
@plsql/flow_process_vars.pkb
@plsql/flow_engine.pkb
@plsql/flow_api_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb
@plsql/flow_timers_pkg.pkb
@plsql/flow_usertask_pkg.pkb
@plsql/flow_plsql_runner_pkg.pkb

PROMPT >> Installing Engine-App Objects
PROMPT >> =============================
PROMPT >> Page API Specifications
@plsql/engine-app/flow_p0010_api.pks
@plsql/engine-app/flow_p0005_api.pks
@plsql/engine-app/flow_p0002_api.pks

PROMPT >> Page Views
@views/engine-app/flow_p0010_vw.sql
@views/engine-app/flow_p0010_instances_vw.sql
@views/engine-app/flow_p0010_subflows_vw.sql
@views/engine-app/flow_p0010_branches_vw.sql
@views/engine-app/flow_p0010_routes_vw.sql
@views/engine-app/flow_p0010_variables_vw.sql
@views/engine-app/flow_p0002_diagrams_vw.sql
@views/engine-app/flow_p0002_instances_counter_vw.sql

PROMPT >> Page API Bodies
@plsql/engine-app/flow_p0010_api.pkb
@plsql/engine-app/flow_p0005_api.pkb
@plsql/engine-app/flow_p0002_api.pkb

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
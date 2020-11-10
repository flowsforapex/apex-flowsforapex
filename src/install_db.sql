set define '^'
set concat '.'

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_tables.sql
@ddl/install_extra_ddl_for_userTasks.sql

PROMPT >> Installing Package Specifications
-- Base Packages
@plsql/flow_types_pkg.pks
@plsql/flow_constants_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks
@plsql/flow_api_pkg.pks
@plsql/flow_timers_pkg.pks
@plsql/flow_engine.pks
@plsql/flow_process_vars.pks

-- Page Packages
@plsql/flow_p0010_api.pks

PROMPT >> Installing Views
-- Base Views
@views/flow_instances_vw.sql
@views/flow_instance_details_vw.sql
@views/flow_instance_inbox_vw.sql
@views/flow_instane_variables_vw.sql
@views/flow_subflows_vw.sql
@views/flow_diagrams_lov.sql
@views/flow_diagrams_parsed_lov.sql

-- Page Views
@views/flow_p0010_vw.sql
@views/flow_p0010_instances_vw.sql
@views/flow_p0010_subflows_vw.sql
@views/flow_p0010_branches_vw.sql

PROMPT >> Installing Package Bodies
-- Base Packages
@plsql/flow_process_vars.pkb
@plsql/flow_engine.pkb
@plsql/flow_api_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb
@plsql/flow_timers_pkg.pkb

-- Page Packages
@plsql/flow_p0010_api.pkb

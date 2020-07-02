PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_tables.sql

PROMPT >> Installing Package Specifications
@plsql/flow_api_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks
@plsql/flow_p0003_api.pks
@plsql/flow_p0010_api.pks

PRoMPT >> Installing Package Bodies
@plsql/flow_api_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb
@plsql/flow_p0003_api.pkb
@plsql/flow_p0010_api.pkb

PROMPT >> installing Views
@views/flow_p0001_vw.sql
@views/flow_p0003_vw.sql
@views/flow_p0010_vw.sql
@views/flow_p0010_instances_vw.sql
@views/flow_p0010_subflows_vw.sql
@views/flow_p0010_branches_vw.sql
@views/flow_r_diagrams.sql
@views/flow_r_diagrams_parsed.sql
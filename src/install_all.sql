
PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_tables.sql

PROMPT >> Installing Package Specifications
@plsql/flow_api_pkg.pks
@plsql/flow_bpmn_parser_pkg.pks

PRoMPT >> Installing Package Bodies
@plsql/flow_api_pkg.pkb
@plsql/flow_bpmn_parser_pkg.pkb

PROMPT >> installing Views
@views/flow_p0001_vw.sql
@views/flow_p0003_vw.sql
@views/flow_p0010_vw.sql
@views/flow_p0010_instances_vw.sql
@views/flow_p0010_subflows_vw.sql
@views/flow_p0010_branches_vw.sql
@views/flow_dgrm_lov.sql

PROMPT >> Application Installation
PROMPT >> ========================

PROMPT >> Set up environment
begin
  -- change this accordingly
  apex_application_install.set_workspace('FLOWS4APEX');
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema('F4A_DEV');
  apex_application_install.set_application_alias('MERGE1');
end;
/

PROMPT >> Install Application
@apex/install.sql

begin
  -- change this accordingly
  apex_application_install.set_workspace('TEST2');
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema('TEST2');
  apex_application_install.set_application_alias('TEST2');
end;
/

@apex/install.sql

@ddl/flow_diagrams.sql
@ddl/flow_objects.sql
@ddl/flow_processes.sql
@ddl/flow_connections.sql
@ddl/flow_subflow_log.sql
@ddl/flow_subflows.sql

@plsql/flow_api_pkg.spc
@plsql/flow_api_pkg.bdy
@plsql/flow_bpmn_parser_pkg.spc
@plsql/flow_bpmn_parser_pkg.bdy

@views/flow_p0001_vw.sql
@views/flow_p0003_vw.sql
@views/flow_p0010_2_vw.sql
@views/flow_p0010_3_vw.sql
@views/flow_p0010_4_vw.sql
@views/flow_p0010_vw.sql
@views/flow_r_dgrm_vw.sql
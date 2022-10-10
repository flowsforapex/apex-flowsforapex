PROMPT >> Reparsing all Diagrams
PROMPT >> ===============================================
begin
  for rec in ( select dgrm_id from flow_diagrams ) loop
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => rec.dgrm_id );
  end loop;
  commit;
end;
PROMPT >> Finished Reparsing all Diagrams
PROMPT >> ===============================================
/

PROMPT >> Parsing all existing diagrams
PROMPT >> =============================


begin
  for rec in ( select dgrm_id, dgrm_name, dgrm_version from flow_diagrams )
  loop
    dbms_output.put_line ('Parsing diagram '||rec.dgrm_name||' Version : '||rec.dgrm_version||'.');
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => rec.dgrm_id );
  end loop;
  commit;
end;


/

PROMPT >> Finished parsing all diagrams
PROMPT >> =============================

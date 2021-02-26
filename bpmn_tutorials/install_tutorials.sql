PROMPT >> Installing Tutorial Diagrams
PROMPT >> ============================

@sql/installTut0.sql
@sql/installTut1.sql
@sql/installTut2.sql
@sql/installTut3.sql
@sql/installTut4.sql
@sql/installTut5.sql
@sql/installTut6.sql
@sql/installTut7.sql
@sql/installTut8.sql

PROMPT >> Parsing all Tutorial Diagrams
PROMPT >> =============================
begin
  for rec in ( select dgrm_id from flow_diagrams where dgrm_category = 'Tutorials' ) loop
    flow_bpmn_parser_pkg.parse
    (
      pi_dgrm_id => rec.dgrm_id
    );
  end loop;
  commit;
end;
/

PROMPT >> Tutorial Diagrams Installation finished
PROMPT >> =======================================

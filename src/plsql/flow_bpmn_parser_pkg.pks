create or replace package flow_bpmn_parser_pkg
  authid definer
as

  procedure upload_diagram
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  );

  procedure upload_and_parse
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  );

  procedure parse
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  );

  procedure parse
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  );

end flow_bpmn_parser_pkg;
/

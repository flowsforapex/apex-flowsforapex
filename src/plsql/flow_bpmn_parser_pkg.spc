create or replace package flow_bpmn_parser_pkg
as
  procedure parse
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  );
end;
/
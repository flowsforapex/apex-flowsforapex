create or replace package flow_p0003_api
  authid definer
as

  procedure delete_diagram
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  );

end flow_p0003_api;
/

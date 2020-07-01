create or replace package body flow_p0003_api
as

  procedure delete_diagram
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  )
  as
  begin
    delete
      from flow_diagrams
     where dgrm_name = pi_dgrm_name
    ;
  end delete_diagram;

end flow_p0003_api;
/

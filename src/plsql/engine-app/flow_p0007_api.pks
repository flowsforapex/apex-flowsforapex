create or replace package flow_p0007_api
  authid definer
as

  procedure process_page
  (
    pio_dgrm_id      in out nocopy flow_diagrams.dgrm_id%type
  , pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_new_version   in flow_diagrams.dgrm_version%type
  , pi_cascade       in varchar2
  , pi_request       in varchar2
  );

end flow_p0007_api;
/

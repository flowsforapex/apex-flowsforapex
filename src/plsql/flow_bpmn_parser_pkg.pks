create or replace package flow_bpmn_parser_pkg
  authid definer
as

  function upload_diagram
  (
    pi_dgrm_name       in flow_diagrams.dgrm_name%type
  , pi_dgrm_version    in flow_diagrams.dgrm_version%type
  , pi_dgrm_category   in flow_diagrams.dgrm_category%type
  , pi_dgrm_content    in flow_diagrams.dgrm_content%type
  , pi_dgrm_status     in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  ) return flow_diagrams.dgrm_id%type;

  procedure upload_diagram
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  );

  procedure upload_and_parse
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  );

  procedure parse
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  );

  procedure parse
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  );

  procedure update_diagram
  (
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  );

end flow_bpmn_parser_pkg;
/

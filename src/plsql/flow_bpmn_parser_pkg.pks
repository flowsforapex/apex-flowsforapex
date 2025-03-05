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
  pragma deprecate (upload_diagram, 'flow_bpmn_parser_pkg.upload_diagram is deprecated.  Use flow_diagram.upload_diagram instead');

  procedure upload_diagram
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  );
  pragma deprecate (upload_diagram, 'flow_bpmn_parser_pkg.upload_diagram is deprecated.  Use flow_diagram.upload_diagram instead');

  procedure upload_and_parse
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  );
  pragma deprecate (upload_and_parse, 'flow_bpmn_parser_pkg.upload_and_parse is deprecated.  Use flow_diagram.upload_and_parse instead');

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
  pragma deprecate (update_diagram, 'flow_bpmn_parser_pkg.update_diagram is deprecated.  Use flow_diagram.update_diagram instead');

end flow_bpmn_parser_pkg;
/

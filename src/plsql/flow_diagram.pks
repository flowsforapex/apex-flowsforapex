create or replace package flow_diagram
/* 
-- Flows for APEX - flow_diagram.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-23.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  10-Dec-2021  Dennis Amthor - MT AG
-- Modified 22-May-2022  Moritz Klein - MT AG
-- Modified 16-Mar-2023  Richard Allen - Oracle 
--
*/
  authid definer
as

  diagram_exists exception;
  diagram_not_draft exception;
  pragma exception_init(diagram_exists, -20001);
  pragma exception_init(diagram_not_draft, -20002);

  function create_diagram(
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type)
  return flow_diagrams.dgrm_id%type;

  function upload_diagram
  (
    pi_dgrm_name       in flow_diagrams.dgrm_name%type
  , pi_dgrm_version    in flow_diagrams.dgrm_version%type
  , pi_dgrm_category   in flow_diagrams.dgrm_category%type
  , pi_dgrm_content    in flow_diagrams.dgrm_content%type
  , pi_dgrm_status     in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment     in flow_flow_event_log.lgfl_comment%type default null
  , pi_force_overwrite in boolean default false
  ) return flow_diagrams.dgrm_id%type;

  procedure upload_diagram
  (
    pi_dgrm_name       in flow_diagrams.dgrm_name%type
  , pi_dgrm_version    in flow_diagrams.dgrm_version%type
  , pi_dgrm_category   in flow_diagrams.dgrm_category%type
  , pi_dgrm_content    in flow_diagrams.dgrm_content%type
  , pi_dgrm_status     in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment     in flow_flow_event_log.lgfl_comment%type default null
  , pi_force_overwrite in boolean default false
  );

  procedure upload_and_parse
  (
    pi_dgrm_name       in flow_diagrams.dgrm_name%type
  , pi_dgrm_version    in flow_diagrams.dgrm_version%type
  , pi_dgrm_category   in flow_diagrams.dgrm_category%type
  , pi_dgrm_content    in flow_diagrams.dgrm_content%type
  , pi_dgrm_status     in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_log_comment     in flow_flow_event_log.lgfl_comment%type default null
  , pi_force_overwrite in boolean default false
  );

  procedure update_diagram
  (
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  );

  function add_diagram_version(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type)
  return flow_diagrams.dgrm_id%type;


  function import_diagram(
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type,
    pi_dgrm_content in flow_diagrams.dgrm_content%type,
    pi_force_overwrite in varchar2 default flow_constants_pkg.gc_false) 
  return flow_diagrams.dgrm_id%type;
  
  
  function diagram_is_modifiable(
    pi_dgrm_id in flow_diagrams.dgrm_id%type)
  return boolean;


  procedure delete_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_cascade in varchar2);


  procedure edit_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type,
    pi_dgrm_name in flow_diagrams.dgrm_name%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type);


  procedure release_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type);


  -- Exposed as Public API through flow_admin_api
  procedure release_diagram(
    pi_dgrm_name    in flow_diagrams.dgrm_name%type,
    pi_dgrm_version in flow_diagrams.dgrm_version%type default '0');


  procedure deprecate_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type);


  procedure archive_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type);   

  -- get_start_event
  --
  -- gets the start event for a diagram. returning the object as a flow_objects rowtype
  -- if p_event_starting_object is null (default), this will return the null start event or a timer start event - the main starting object in the diagram
  -- if p_event_starting_object is specified, it will return the row for that object.   You would use this if, for example, you were getting the message start 
  --    event from a model containing multiple start events.
  --
  function get_start_event(
    p_dgrm_id               in flow_diagrams.dgrm_id%type,
    p_process_id           in flow_processes.prcs_id%type,
    p_event_starting_object in flow_objects.objt_bpmn_id%type default null)
  return flow_objects%rowtype;

-- get the current dgrm_id to be used for a diagram name.
-- returns the current 'released' diagram or a 'draft' of version '0' 
  function get_current_diagram
    ( pi_dgrm_name              in flow_diagrams.dgrm_name%type
    , pi_dgrm_calling_method    in flow_types_pkg.t_bpmn_attribute_vc2
    , pi_dgrm_version           in flow_diagrams.dgrm_version%type
    , pi_prcs_id                in flow_processes.prcs_id%type default null
    )
  return flow_diagrams.dgrm_id%type;

  function get_diagram_name
    ( pi_dgrm_id            in flow_diagrams.dgrm_id%type
    )
  return flow_diagramS.dgrm_name%type;

end flow_diagram;
/

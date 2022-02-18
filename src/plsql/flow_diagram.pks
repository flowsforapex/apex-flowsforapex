create or replace package flow_diagram
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


  procedure deprecate_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type);


  procedure archive_diagram(
    pi_dgrm_id in flow_diagrams.dgrm_id%type);   

  function get_start_event(
    pi_dgrm_id    in flow_diagrams.dgrm_id%type,
    pi_prcs_id    in flow_processes.prcs_id%type)
  return varchar2;

end flow_diagram;
/

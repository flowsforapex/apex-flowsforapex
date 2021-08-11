create or replace package flow_types_pkg
  authid definer
as

  subtype t_bpmn_id             is varchar2(50 char);
  subtype t_bpmn_attributes_key is varchar2(50 char);
  subtype t_bpmn_attribute_vc2  is varchar2(4000 char);

  subtype t_single_vc2         is varchar2(1 char);

  subtype t_expr_type          is varchar2(130 char);
  subtype t_expr_set           is varchar2(20 char);

  type flow_step_info is record
  ( dgrm_id            flow_diagrams.dgrm_id%type
  , source_objt_tag    flow_objects.objt_tag_name%type
  , source_objt_id     flow_objects.objt_id%type
  , target_objt_id     flow_objects.objt_id%type
  , target_objt_ref    flow_objects.objt_bpmn_id%type
  , target_objt_tag    flow_objects.objt_tag_name%type
  , target_objt_subtag flow_objects.objt_sub_tag_name%type
  );

end flow_types_pkg;
/

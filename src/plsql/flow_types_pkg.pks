create or replace package flow_types_pkg
  authid definer
as

  subtype t_bpmn_id             is varchar2(50 char);
  subtype t_bpmn_attributes_key is varchar2(50 char);
  subtype t_bpmn_attribute_vc2  is varchar2(4000 char);

  subtype t_vc200              is varchar2(200 char);
  subtype t_single_vc2         is varchar2(1 char);
  subtype t_boolean_num        is number(1);

  subtype t_expr_type          is varchar2(130 char);
  subtype t_expr_set           is varchar2(20 char);

  type flow_step_info is record
  ( dgrm_id                 flow_diagrams.dgrm_id%type
  , source_objt_tag         flow_objects.objt_tag_name%type
  , source_objt_id          flow_objects.objt_id%type
  , target_objt_id          flow_objects.objt_id%type
  , target_objt_ref         flow_objects.objt_bpmn_id%type
  , target_objt_tag         flow_objects.objt_tag_name%type
  , target_objt_subtag      flow_objects.objt_sub_tag_name%type
  , target_objt_lane        flow_objects.objt_bpmn_id%type
  , target_objt_lane_name   flow_objects.objt_name%type
  );

  type t_subflow_context is record
  ( sbfl_id           flow_subflows.sbfl_id%type
  , step_key          flow_subflows.sbfl_step_key%type
  , route             flow_subflows.sbfl_route%type
  , scope             flow_subflows.sbfl_scope%type
  );

end flow_types_pkg;
/

create or replace package flow_types_pkg
  authid definer
as

  subtype t_bpmn_id             is varchar2(50 char);
  subtype t_bpmn_attributes_key is varchar2(50 char);
  subtype t_bpmn_attribute_vc2  is varchar2(4000 char);

  subtype t_single_vc2         is varchar2(1 char);

  subtype t_expr_type          is varchar2(130 char);
  subtype t_expr_phase         is varchar2(4 char);

end flow_types_pkg;
/

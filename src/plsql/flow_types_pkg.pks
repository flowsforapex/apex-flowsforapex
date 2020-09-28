create or replace package flow_types_pkg
  authid definer
as

  subtype t_bpmn_id is varchar2(50 char);

end flow_types_pkg;
/

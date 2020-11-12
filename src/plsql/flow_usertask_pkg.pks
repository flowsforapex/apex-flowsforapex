create or replace package flow_usertask_pkg
  authid definer
as

  function get_url
  (
    pi_objt_id in flow_objects.objt_id%type
  ) return varchar2;

end flow_usertask_pkg;
/

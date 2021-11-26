create or replace package flow_services
  authid current_user
as
  e_no_default_workspace exception;
  e_wrong_default_workspace exception;
  e_email_no_from exception;
  e_email_no_to exception;
  e_email_no_template exception;
  e_email_no_body exception;
  e_email_failed exception;

  procedure send_email(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

end flow_services;
/

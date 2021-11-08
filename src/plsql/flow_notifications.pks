create or replace package flow_notifications
  authid current_user
as

  e_email_no_from exception;
  e_email_no_to exception;
  e_email_no_template exception;
  e_email_no_body exception;
  e_email_failed exception;
  e_ws_error     exception;

  procedure send_email(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure send_slack_message(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure send_teams_message(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure send_gchat_message(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure twilio_send_sms(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure upload_file_to_dropbox(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure upload_file_to_oci(  
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  procedure upload_file_to_onedrive(  
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );

  /*procedure upload_to_gdrive(  
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
  );*/
end flow_notifications;
/

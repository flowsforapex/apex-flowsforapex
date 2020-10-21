create or replace package flow_notif_pkg as
/******************************************************************************
 Purpose:
   Provides support to notifications in Flows for APEX.
******************************************************************************/

/* PROCEDURES */
/******************************************************************************
  send_notification
    Send a notification using the template defined in the p_template_ident
    parameter.
******************************************************************************/
  PROCEDURE send_notification( p_process_id          in  flow_processes.prcs_id%type
                             , p_subflow_id          in  flow_subflows.sbfl_id%type
                             , p_template_ident      in  VARCHAR2
                             , p_substitution_values in  CLOB
                             , p_return_code         out NUMBER
                             );


END flow_notif_pkg;
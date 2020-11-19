create or replace PACKAGE flow_notif_pkg AS
/******************************************************************************
 Purpose:
   Provides support to notifications in Flows for APEX.
******************************************************************************/

/* FUNCTIONS */
/******************************************************************************
  get_transf_value
    Only for internal use in SQL.
******************************************************************************/
    FUNCTION get_transf_value (
        in_value VARCHAR2
    ) RETURN CLOB;

/* PROCEDURES */
/******************************************************************************
  send_notification
    Send a notification using the template defined in the p_template_ident
    parameter.
******************************************************************************/
   PROCEDURE send_notification (
      p_process_id       IN   flow_processes.prcs_id%TYPE,
      p_template_ident   IN   apex_appl_email_templates.static_id%TYPE,
      p_modeller_values  IN   CLOB,
      p_return_code      OUT  NUMBER
   );
END flow_notif_pkg;
/

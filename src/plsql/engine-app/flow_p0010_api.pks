create or replace package flow_p0010_api
  authid definer
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_ids in apex_application.g_f01%type
  , pi_sbfl_ids in apex_application.g_f02%type
  , pi_dgrm_ids in apex_application.g_f03%type
  , pi_prcs_names in apex_application.g_f04%type
  , pi_comment in varchar2
  );

end flow_p0010_api;
/

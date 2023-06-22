create or replace package flow_rest_install
  authid definer
as

  function is_rest_enabled( pi_schema varchar2 default apex_application.g_flow_owner)
    return boolean;
  
  function is_module_published( pi_schema varchar2 default apex_application.g_flow_owner
                              , pi_module_prefix varchar2 default flow_rest_constants.c_rest_current_version )
    return boolean;

  procedure set_base_url( pi_base_url  varchar2 );

end flow_rest_install;
/

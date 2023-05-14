create or replace package body flow_rest_install
as

  function is_rest_enabled( pi_schema varchar2 default apex_application.g_flow_owner )
    return boolean
  as
    l_status varchar2(50);
  begin
    select upper(max(status))
      into l_status
      from user_ords_schemas
      where parsing_schema = pi_schema;

    return nvl(l_status, flow_rest_constants.c_rest_schema_status_disabled) = flow_rest_constants.c_rest_schema_status_enabled;

  end is_rest_enabled;
  
  -------------------------------------------------------------------------------------------------------------------

  function is_module_published( pi_schema varchar2 default apex_application.g_flow_owner
                              , pi_module_prefix varchar2 default flow_rest_constants.c_rest_current_version )
    return boolean
  as
    l_status varchar2(50);
  begin
    select upper(max(om.status))
      into l_status
      from user_ords_modules om
      join user_ords_schemas os on om.schema_id = os.id
      where os.parsing_schema = pi_schema
        and trim('/' from om.uri_prefix) = pi_module_prefix;

    return nvl(l_status, 'X') = flow_rest_constants.c_rest_module_status_published;

  end is_module_published;
    
end flow_rest_install;
/

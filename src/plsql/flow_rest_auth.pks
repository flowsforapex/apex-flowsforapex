create or replace package flow_rest_auth
  authid definer
as

  function get_rest_roles
    return flow_rest_roles_nt
    pipelined;

  function get_client_id( pi_name  user_ords_clients.name%type )
    return user_ords_clients.id%type;

  function get_client_roles( pi_id  user_ords_clients.id%type )
    return apex_application_global.vc_arr2;

  procedure check_privilege( pi_client_id       varchar2 -- client_id is returned by implicit parameter :current_user
                           , pi_privilege_name  varchar2 );

  procedure update_client_roles( pi_id     user_ords_clients.id%type
                               , pi_roles  apex_application_global.vc_arr2); -- array of user_ords_roles.id

end flow_rest_auth;
/

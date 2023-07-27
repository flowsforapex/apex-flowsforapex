create or replace package flow_rest_auth
  authid definer
as
  type flow_rest_role_ot is record
  (
    role_id   number,
    role_name varchar2(255)
  );
  type flow_rest_roles_nt is table of flow_rest_role_ot;

  function get_rest_roles
    return flow_rest_roles_nt
    pipelined;

  function get_client_id( pi_name  user_ords_clients.name%type )
    return user_ords_clients.id%type;

  function get_client_roles( pi_id  user_ords_clients.id%type )
    return apex_application_global.vc_arr2;

  -- check if client has flowsforapex.read privilege (used for GET operations)
  -- return 1 if true or 0 if false
  function has_privilege_read( pi_client_id       varchar2)
    return number;

  -- check if client has flowsforapex.admin privilege (used for GET operations)
  -- return 1 if true or 0 if false
  function has_privilege_admin( pi_client_id      varchar2)
    return number;

  procedure check_privilege( pi_client_id       varchar2 -- client_id is returned by implicit parameter :current_user
                           , pi_privilege_name  varchar2 );

  procedure create_client( pi_name           varchar2
                         , pi_owner          varchar2
                         , pi_description    varchar2
                         , pi_support_email  varchar2
                         , pi_support_uri    varchar2 );

  procedure update_client_roles( pi_id     user_ords_clients.id%type
                               , pi_roles  apex_application_global.vc_arr2); -- array of user_ords_roles.id

end flow_rest_auth;
/

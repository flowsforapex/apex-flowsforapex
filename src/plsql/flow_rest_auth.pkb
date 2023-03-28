create or replace package body flow_rest_auth
as

  -------------------------------------------------------------------------------------------------------------------

  function get_rest_roles
    return flow_rest_roles_nt
    pipelined
  as
    l_roles apex_application_global.vc_arr2;  
  begin

    l_roles(1) := flow_rest_constants.c_rest_role_read;
    l_roles(2) := flow_rest_constants.c_rest_role_write;
    l_roles(3) := flow_rest_constants.c_rest_role_admin;

    for rec_roles in (select id, name 
                        from user_ords_roles 
                        where name in (select column_value from table(l_roles)))
    loop
      PIPE ROW (flow_rest_role_ot ( rec_roles.id, rec_roles.name ));
    end loop;
    return;

  end get_rest_roles;

  -------------------------------------------------------------------------------------------------------------------

  function get_client_id( pi_name  user_ords_clients.name%type )
    return user_ords_clients.id%type
  as
    l_id  user_ords_clients.id%type;
  begin
    select id 
      into l_id 
      from user_ords_clients
      where name = pi_name;
    return l_id;
  end get_client_id;

  -------------------------------------------------------------------------------------------------------------------

  function get_client_roles( pi_id   user_ords_clients.id%type )
    return apex_application_global.vc_arr2
  as
    l_roles  apex_application_global.vc_arr2;
  begin
    select role_id 
      bulk collect into l_roles
      from user_ords_client_roles
      where client_id = pi_id;
    return l_roles;
  end get_client_roles;

  -------------------------------------------------------------------------------------------------------------------

  function has_privilege( pi_client_id       varchar2 -- client_id is returned by implicit parameter :current_user
                        , pi_privilege_name  varchar2)
    return boolean
  as
    l_check number;
  begin

    select count(1)
      into l_check
      from user_ords_clients oc 
      join user_ords_client_roles ocr on oc.id = ocr.client_id
      join user_ords_privilege_roles opr on ocr.role_id = opr.role_id
      where oc.client_id = pi_client_id
        and opr.privilege_name = pi_privilege_name;

    if l_check > 0 then
      return true;
    else
      return false;
    end if;

  end has_privilege;

  -------------------------------------------------------------------------------------------------------------------

  procedure check_privilege( pi_client_id       varchar2 -- client_id is returned by implicit parameter :current_user
                           , pi_privilege_name  varchar2 )
  as
  begin

    if not has_privilege( pi_client_id      => pi_client_id 
                        , pi_privilege_name => pi_privilege_name )
    then 
      raise flow_rest_constants.e_privilege_not_granted;
    end if;

  end check_privilege;                       

  -------------------------------------------------------------------------------------------------------------------
  procedure update_client_roles( pi_id     user_ords_clients.id%type
                               , pi_roles  apex_application_global.vc_arr2)
  as
    l_client_name  user_ords_clients.name%type;

    cursor c_update_roles is  
        with cur_roles as (
          select ocr.role_id   as cur_role_id
                , ocr.role_name as cur_role_name
            from user_ords_clients c 
            join user_ords_client_roles ocr on c.id = ocr.client_id
            where c.id = pi_id ),
          set_roles as (
              select uor.id  as set_role_id
                    , uor.name as set_role_name
                from table(pi_roles) t
                join user_ords_roles uor on t.column_value = uor.id )
        select cur_role_id
              , cur_role_name
              , set_role_id
              , set_role_name
          from cur_roles ocr_cur
          full outer join set_roles sr on ocr_cur.cur_role_id = sr.set_role_id ;

    procedure get_client_name
    as
    begin
      select name 
        into l_client_name 
        from user_ords_clients
        where id = pi_id;
    end;
  begin

    get_client_name;

    for rec_update_roles in c_update_roles
    loop

      if    rec_update_roles.cur_role_id is not null 
        and rec_update_roles.set_role_id is null 
      then 
        
        oauth.revoke_client_role( p_client_name => l_client_name
                                , p_role_name   => rec_update_roles.cur_role_name );

      elsif rec_update_roles.cur_role_id is null 
        and rec_update_roles.set_role_id is not null 
      then 
        apex_debug.info('add role %s to client %s', rec_update_roles.cur_role_name, l_client_name);
        oauth.grant_client_role( p_client_name => l_client_name
                               , p_role_name   => rec_update_roles.set_role_name );

      end if; 

    end loop;

  end update_client_roles;                         

end flow_rest_auth;
/

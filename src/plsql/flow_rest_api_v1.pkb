create or replace package body flow_rest_api_v1
as


  function get_path( pi_path_endpoint  varchar2, pi_object_id  varchar2)
    return varchar2
  is
  begin
    return replace( flow_rest.get_config_value( pi_key => flow_rest_constants.c_config_key_base) || flow_rest_constants.c_module || pi_path_endpoint,':id', pi_object_id);
  end get_path;
  
  -------------------------------------------------------------------------------------------------------------------

  function get_link_json( pi_rel       varchar2
                        , pi_path      varchar2
                        , pi_object_id varchar2
                        , pi_action    varchar2 )
    return json_object_t
  as
    l_link_jo  json_object_t;
  begin
    l_link_jo := new json_object_t;
    l_link_jo.put(key => 'rel',    val => pi_rel);
    l_link_jo.put(key => 'href',   val => get_path(pi_path, pi_object_id));
    l_link_jo.put(key => 'action', val => pi_action);
    l_link_jo.put(key => 'types',  val => json_array_t.parse('["application/json"]'));
    return l_link_jo;
  end get_link_json;

  -------------------------------------------------------------------------------------------------------------------

  procedure add_usertask_url( pi_links  in out nocopy json_array_t
                            , pi_rel       varchar2
                            , pi_sbfl_id   flow_subflows.sbfl_id%type
                            , pi_action    varchar2 )
  as
    l_link_jo  json_object_t;
    l_url      varchar2(4000);
  begin

    begin
      l_url := flow_api_pkg.get_current_usertask_url( p_process_id => flow_rest.get_process_id(p_sbfl_id => pi_sbfl_id)
                                                    , p_subflow_id => pi_sbfl_id
                                                    , p_step_key   => flow_rest.get_step_key(p_sbfl_id => pi_sbfl_id) );
      exception 
        when others then 
          null; -- TODO: implement logic to check if usertask url should be created instead of catching exception
    end;
    
    if l_url is not null then 
      l_link_jo := new json_object_t;
      l_link_jo.put(key => 'rel',    val => pi_rel);
      l_link_jo.put(key => 'href',   val => l_url);
      l_link_jo.put(key => 'action', val => pi_action);
      l_link_jo.put(key => 'types',  val => json_array_t.parse('["application/json"]'));

      pi_links.append(l_link_jo);
    end if;

  end add_usertask_url;
  
  -------------------------------------------------------------------------------------------------------------------

  function get_links_array ( pi_object_type  varchar2
                           , pi_object_id    varchar2)
    return json_array_t
  as
    l_links  json_array_t;
    l_link   json_object_t;
  begin 
    l_links := new json_array_t();

    case lower(pi_object_type)
      when flow_rest_constants.c_object_type_diagram then 
        l_links.append( get_link_json( flow_rest_constants.c_object_type_diagram, flow_rest_constants.c_path_diagrams, pi_object_id, flow_rest_constants.c_http_action_get));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_diagram_processes, pi_object_id, flow_rest_constants.c_http_action_get));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_diagram_processes, pi_object_id, flow_rest_constants.c_http_action_post));
      when flow_rest_constants.c_object_type_process then 
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_processes, pi_object_id, flow_rest_constants.c_http_action_get));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_processes, pi_object_id, flow_rest_constants.c_http_action_put));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_processes, pi_object_id, flow_rest_constants.c_http_action_delete));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_process_start, pi_object_id, flow_rest_constants.c_http_action_post));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_process_reset, pi_object_id, flow_rest_constants.c_http_action_post));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process, flow_rest_constants.c_path_process_terminate, pi_object_id, flow_rest_constants.c_http_action_post));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process_vars, flow_rest_constants.c_path_process_vars, pi_object_id, flow_rest_constants.c_http_action_get));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_process_vars, flow_rest_constants.c_path_process_vars, pi_object_id, flow_rest_constants.c_http_action_put));
      when flow_rest_constants.c_object_type_step then
        l_links.append( get_link_json( flow_rest_constants.c_object_type_step, flow_rest_constants.c_path_steps, pi_object_id, flow_rest_constants.c_http_action_get));
        l_links.append( get_link_json( flow_rest_constants.c_object_type_step, flow_rest_constants.c_path_steps, pi_object_id, flow_rest_constants.c_http_action_put));
        add_usertask_url( l_links, flow_rest_constants.c_object_type_step_usertask, pi_object_id, flow_rest_constants.c_http_action_get);
      else 
        null;
    end case;

    return l_links;
  end get_links_array;

  -------------------------------------------------------------------------------------------------------------------

  function get_links_object ( pi_object_type  varchar2
                            , pi_object_id    varchar2)
    return json_object_t
  as
    l_json_object  json_object_t;
  begin

    l_json_object := new json_object_t();
    l_json_object.put(key => 'links', val => get_links_array ( pi_object_type  => pi_object_type
                                                             , pi_object_id    => pi_object_id));
    return l_json_object;                                                         
  end get_links_object;

  -------------------------------------------------------------------------------------------------------------------
  
  function get_links_string_http_GET ( pi_object_type  varchar2
                            , pi_object_id    varchar2)
    return clob
  as
    l_json_string  clob;
  begin

    l_json_string := get_links_array ( pi_object_type  => pi_object_type
                                     , pi_object_id    => pi_object_id).stringify;
    return trim( trailing ']' from trim( leading '[' from l_json_string));
  end get_links_string_http_GET;

  -------------------------------------------------------------------------------------------------------------------

  
  -------------------------------------------------------------------------------------------------------------------

  procedure init( pi_client_id        varchar2
                , pi_check_privilege  varchar2 )
  as
  begin

    owa_util.mime_header ('application/json', true); 

    flow_rest_auth.check_privilege( pi_client_id       => pi_client_id 
                                  , pi_privilege_name  => pi_check_privilege );

  end init;

  -------------------------------------------------------------------------------------------------------------------

  function get_business_ref_object( pi_business_ref  varchar2 )
    return json_object_t
  as
    l_business_ref  json_object_t;
  begin
    l_business_ref := new json_object_t();
    l_business_ref.put( 'name', 'business_ref');
    l_business_ref.put( 'type', 'varchar');
    l_business_ref.put( 'value', pi_business_ref );
    return l_business_ref;

  end get_business_ref_object;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_post( pi_dgrm_id  flow_diagrams.dgrm_id%type
                          , pi_payload  json_element_t
                          , pi_current_user     varchar2
                          , po_status_code      out number
                          , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;

    l_item_object   json_object_t;
    l_prcs_id       flow_processes.prcs_id%type;
    l_business_ref_arr  json_array_t;
    l_error_occured     boolean := false;

  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.verify_diagram_exists( pi_dgrm_id       => pi_dgrm_id
                                   , pi_dgrm_version  => l_item_object.get_String( flow_rest_constants.c_check_item_dgrm_version ) );

   
    l_prcs_id := flow_api_pkg.flow_create ( pi_dgrm_id    => pi_dgrm_id
                                          , pi_prcs_name  => l_item_object.get_String( 'name' ));

    -- if business_ref was provided set process variable after creation
    if l_item_object.has( 'business_ref' ) then
      l_business_ref_arr := flow_rest.get_json_array_t( get_business_ref_object( l_item_object.get_string( 'business_ref' )));
      flow_rest.process_vars_update( pi_prcs_id    => l_prcs_id
                                   , pio_prov_arr  => l_business_ref_arr
                                   , pi_add_error_msg  => true );
    end if;

    po_forward_location := get_path( pi_path_endpoint => flow_rest_constants.c_path_processes
                                   , pi_object_id     => l_prcs_id );
    
    commit;

    exception 
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_post;                       

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_start_post( pi_prcs_id          flow_processes.prcs_id%type
                                , pi_current_user     varchar2
                                , po_status_code      out number 
                                , po_forward_location out varchar2 )
  as 
    pragma autonomous_transaction;
    l_item_object      json_object_t;   
  begin
    
    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );


    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    l_item_object := new json_object_t();
    l_item_object.put('status','start');

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    
    
    flow_rest.send_response_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    commit;

    exception 
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when flow_rest_constants.e_attribute_not_found then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Attribute not found'
                                     , pi_payload     => l_item_object
                                     , pi_payload_attr_name => 'item'
                                     , po_status_code       => po_status_code );
      when flow_rest_constants.e_process_unknown_status then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Status unknown' 
                                     , po_status_code => po_status_code );
      when others then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_start_post;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_reset_post( pi_prcs_id          flow_processes.prcs_id%type
                                , pi_payload          json_element_t  
                                , pi_current_user     varchar2
                                , po_status_code      out number 
                                , po_forward_location out varchar2 )       
  as 
    pragma autonomous_transaction;
    l_item_object      json_object_t;   
  begin
    
    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    if pi_payload is null then 
      l_item_object := new json_object_t();
    else 
      flow_rest.verify_and_prepare_payload( pi_payload        => pi_payload 
                                          , pi_array_allowed  => false 
                                          , po_payload_object => l_item_object );
    end if;

    l_item_object.put('status','reset');

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    
    
    flow_rest.send_response_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    commit;

    exception 
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when flow_rest_constants.e_attribute_not_found then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Attribute not found'
                                     , pi_payload     => pi_payload
                                     , pi_payload_attr_name => 'item'
                                     , po_status_code       => po_status_code );
      when flow_rest_constants.e_process_unknown_status then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Status unknown' 
                                     , po_status_code => po_status_code );
      when others then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_reset_post;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_terminate_post( pi_prcs_id          flow_processes.prcs_id%type
                                    , pi_payload          json_element_t  
                                    , pi_current_user     varchar2
                                    , po_status_code      out number 
                                    , po_forward_location out varchar2 )                                                         
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;   
  begin
    
    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    if pi_payload is null then 
      l_item_object := new json_object_t();
    else
      flow_rest.verify_and_prepare_payload( pi_payload        => pi_payload 
                                          , pi_array_allowed  => false 
                                          , po_payload_object => l_item_object );
    end if;

    l_item_object.put('status','reset');

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    flow_rest.send_response_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    commit;

    exception 
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when flow_rest_constants.e_attribute_not_found then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Attribute not found'
                                     , pi_payload     => pi_payload
                                     , pi_payload_attr_name => 'item'
                                     , po_status_code       => po_status_code );
      when flow_rest_constants.e_process_unknown_status then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Status unknown' 
                                     , po_status_code => po_status_code );
      when others then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_terminate_post;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_put( pi_prcs_id  flow_processes.prcs_id%type
                         , pi_payload  json_element_t 
                         , pi_current_user     varchar2
                         , po_status_code out number
                         , po_forward_location out varchar2 )
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;   
  begin
    
    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    flow_rest.send_response_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    commit;

    exception 
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when flow_rest_constants.e_attribute_not_found then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Attribute not found'
                                     , pi_payload     => pi_payload
                                     , pi_payload_attr_name => 'item'
                                     , po_status_code       => po_status_code );
      when flow_rest_constants.e_process_unknown_status then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => 'Status unknown' 
                                     , po_status_code => po_status_code );
      when others then 
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_delete( pi_prcs_id  flow_processes.prcs_id%type
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code out number )
  as
    pragma autonomous_transaction;
    l_item_object          json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_admin );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_api_pkg.flow_delete( p_process_id => pi_prcs_id
                            , p_comment    => l_item_object.get_string('comment') );

    flow_rest.send_response_success( pi_success_message => 'process deleted' 
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end processes_delete;    

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_put( pi_sbfl_id  flow_subflows.sbfl_id%type
                     , pi_payload  json_element_t 
                     , pi_current_user     varchar2
                     , po_status_code      out number 
                     , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_put;
  
  -------------------------------------------------------------------------------------------------------------------
  
  procedure steps_start_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number 
                            , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_start);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_start_post;                               

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_reserve_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_reserve);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_reserve_post;                          

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_release_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_release);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_release_post;

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_complete_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                               , pi_payload  json_element_t 
                               , pi_current_user     varchar2
                               , po_status_code      out number 
                               , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_complete);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_complete_post;

  -------------------------------------------------------------------------------------------------------------------
  
  procedure steps_restart_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_restart);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_restart_post;

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_reschedule_timer_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                                       , pi_payload  json_element_t 
                                       , pi_current_user     varchar2
                                       , po_status_code      out number 
                                       , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_item_object      json_object_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_reschedule_timer);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest.send_response_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , po_status_code => po_status_code );

  end steps_reschedule_timer_post;                                    

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_put( pi_prcs_id  flow_processes.prcs_id%type 
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number 
                            , po_forward_location out varchar2)
  as
    pragma autonomous_transaction;
    l_prov_array   json_array_t;

  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload       => pi_payload 
                                        , pi_array_allowed => true 
                                        , po_payload_array => l_prov_array );

    flow_rest.process_vars_update( pi_prcs_id    => pi_prcs_id
                                 , pio_prov_arr  => l_prov_array
                                 , pi_add_error_msg  => true );


    flow_rest.send_response_success( pi_success_message   => 'process variables updated' 
                                   , pi_payload           => l_prov_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );

    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , pi_payload     => l_prov_array
                                     , pi_payload_attr_name => 'items'
                                     , po_status_code => po_status_code );

  end process_vars_put;    

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_delete( pi_prcs_id  flow_processes.prcs_id%type 
                               , pi_payload  json_element_t 
                               , pi_current_user     varchar2
                               , po_status_code out number )
  as
    pragma autonomous_transaction;
    l_prov_array   json_array_t;
  begin

    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_admin );

    flow_rest.verify_and_prepare_payload( pi_payload         => pi_payload 
                                        , pi_array_allowed   => false 
                                        , po_payload_array   => l_prov_array );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_vars_delete( pi_prcs_id    => pi_prcs_id
                                 , pio_prov_arr  => l_prov_array
                                 , pi_add_error_msg  => true );

    flow_rest.send_response_success( pi_success_message   => 'process variables deleted' 
                                   , pi_payload           => l_prov_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );
    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , pi_payload     => l_prov_array
                                     , pi_payload_attr_name => 'items'
                                     , po_status_code => po_status_code );

  end process_vars_delete;    

  -------------------------------------------------------------------------------------------------------------------

  procedure messages_put( pi_message_name  flow_message_subscriptions.msub_message_name%type 
                        , pi_payload       json_element_t 
                        , pi_current_user     varchar2
                        , po_status_code      out number 
                        , po_forward_location out varchar2 )
  as
    pragma autonomous_transaction;
    l_msg_array json_array_t;
  begin
    
    init( pi_client_id        => pi_current_user
        , pi_check_privilege  => flow_rest_constants.c_rest_priv_write );

    flow_rest.verify_and_prepare_payload( pi_payload         => pi_payload 
                                        , pi_array_allowed   => true 
                                        , po_payload_array   => l_msg_array );

    flow_rest.messages_update( pi_message_name  => pi_message_name
                             , pi_msg_arr       => l_msg_array );

    flow_rest.send_response_success( pi_success_message   => 'message subscription updated' 
                                   , pi_payload           => l_msg_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );
    commit;

    exception
      when flow_rest_constants.e_privilege_not_granted then
        rollback;
        po_status_code := 401;
      when others then
        rollback;
        flow_rest.send_response_error( pi_sqlerrm     => SQLERRM 
                                     , pi_stacktrace  => dbms_utility.format_error_backtrace
                                     , pi_payload     => l_msg_array
                                     , pi_payload_attr_name => 'items'
                                     , po_status_code => po_status_code );

  end messages_put;      

end flow_rest_api_v1;
/

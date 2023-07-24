create or replace package body flow_rest_api_v1
as

  procedure dispatch( pi_method           varchar2  --PUT/POST/DELETE
                    , pi_endpoint         varchar2
                    , pi_dgrm_id          flow_diagrams.dgrm_id%type default null
                    , pi_prcs_id          flow_processes.prcs_id%type default null
                    , pi_sbfl_id          flow_subflows.sbfl_id%type default null
                    , pi_message_name     flow_message_subscriptions.msub_message_name%type default null
                    , pi_payload          blob 
                    , pi_current_user     varchar2
                    , po_status_code      out number 
                    , po_forward_location out varchar2
                    )
  as
    l_payload                json_element_t;
    l_exc_payload            json_element_t;
    l_exc_payload_attr_name  varchar2(200);
  begin

    flow_rest.initialize( pi_client_id => pi_current_user
                        , pi_method    => pi_method );
    
    begin
      l_payload := flow_rest.blob_to_json(pi_payload);
      exception 
        when others then
          l_exc_payload_attr_name := 'payload';
          l_exc_payload := new json_object_t('{ "content": "'|| apex_escape.json(to_clob(pi_payload)) ||'" }' ); 
          raise;
    end;

    flow_rest_logging.enter( pi_payload => l_payload );
    
    case upper(pi_method)
      when 'POST' then

        case 
          when regexp_like(pi_endpoint, '^v1/diagrams/[[:digit:]]+/processes$', 'i') then
            flow_rest_api_v1.processes_post(  pi_dgrm_id          => pi_dgrm_id
                                            , pi_payload          => l_payload
                                            , pi_current_user     => pi_current_user
                                            , po_status_code      => po_status_code
                                            , po_forward_location => po_forward_location
                                            , po_exc_payload      => l_exc_payload
                                            , po_exc_payload_attr_name => l_exc_payload_attr_name );
          else 
            raise flow_rest_constants.e_not_implemented;
        end case;

      when 'PUT' then

        case 
          when regexp_like(pi_endpoint, '^v1/messages/[[:alnum:][:blank:][:punct:]]+$', 'i') then
            flow_rest_api_v1.messages_put( pi_message_name     => pi_message_name
                                         , pi_payload          => l_payload
                                         , pi_current_user     => pi_current_user
                                         , po_status_code      => po_status_code
                                         , po_forward_location => po_forward_location 
                                         , po_exc_payload      => l_exc_payload
                                         , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+/start$', 'i') then
            flow_rest_api_v1.processes_start_put( pi_prcs_id          => pi_prcs_id
                                                , pi_current_user     => pi_current_user
                                                , po_status_code      => po_status_code
                                                , po_forward_location => po_forward_location 
                                                , po_exc_payload      => l_exc_payload
                                                , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+/reset$', 'i') then
            flow_rest_api_v1.processes_reset_put( pi_prcs_id          => pi_prcs_id
                                                , pi_payload          => l_payload
                                                , pi_current_user     => pi_current_user
                                                , po_status_code      => po_status_code
                                                , po_forward_location => po_forward_location  
                                                , po_exc_payload      => l_exc_payload
                                                , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+/terminate$', 'i') then
            flow_rest_api_v1.processes_terminate_put( pi_prcs_id          => pi_prcs_id
                                                    , pi_payload          => l_payload
                                                    , pi_current_user     => pi_current_user
                                                    , po_status_code      => po_status_code
                                                    , po_forward_location => po_forward_location 
                                                    , po_exc_payload      => l_exc_payload
                                                    , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+$', 'i') then
            flow_rest_api_v1.processes_put( pi_prcs_id          => pi_prcs_id
                                          , pi_payload          => l_payload
                                          , pi_current_user     => pi_current_user
                                          , po_status_code      => po_status_code
                                          , po_forward_location => po_forward_location 
                                          , po_exc_payload      => l_exc_payload
                                          , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+$', 'i') then
            flow_rest_api_v1.steps_put( pi_sbfl_id          => pi_sbfl_id
                                      , pi_payload          => l_payload
                                      , pi_current_user     => pi_current_user
                                      , po_status_code      => po_status_code
                                      , po_forward_location => po_forward_location 
                                      , po_exc_payload      => l_exc_payload
                                      , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/start$', 'i') then
            flow_rest_api_v1.steps_start_put( pi_sbfl_id          => pi_sbfl_id
                                            , pi_payload          => l_payload
                                            , pi_current_user     => pi_current_user
                                            , po_status_code      => po_status_code
                                            , po_forward_location => po_forward_location 
                                            , po_exc_payload      => l_exc_payload
                                            , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/reserve$', 'i') then
            flow_rest_api_v1.steps_reserve_put( pi_sbfl_id          => pi_sbfl_id
                                              , pi_payload          => l_payload
                                              , pi_current_user     => pi_current_user
                                              , po_status_code      => po_status_code
                                              , po_forward_location => po_forward_location 
                                              , po_exc_payload      => l_exc_payload
                                              , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/release$', 'i') then
            flow_rest_api_v1.steps_release_put( pi_sbfl_id          => pi_sbfl_id
                                              , pi_payload          => l_payload
                                              , pi_current_user     => pi_current_user
                                              , po_status_code      => po_status_code
                                              , po_forward_location => po_forward_location 
                                              , po_exc_payload      => l_exc_payload
                                              , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/complete$', 'i') then
            flow_rest_api_v1.steps_complete_put( pi_sbfl_id          => pi_sbfl_id
                                               , pi_payload          => l_payload
                                               , pi_current_user     => pi_current_user
                                               , po_status_code      => po_status_code
                                               , po_forward_location => po_forward_location 
                                               , po_exc_payload      => l_exc_payload
                                               , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/restart$', 'i') then
            flow_rest_api_v1.steps_restart_put( pi_sbfl_id          => pi_sbfl_id
                                              , pi_payload          => l_payload
                                              , pi_current_user     => pi_current_user
                                              , po_status_code      => po_status_code
                                              , po_forward_location => po_forward_location 
                                              , po_exc_payload      => l_exc_payload
                                              , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/steps/[[:digit:]]+/reschedule_timer$', 'i') then
            flow_rest_api_v1.steps_reschedule_timer_put( pi_sbfl_id          => pi_sbfl_id
                                                       , pi_payload          => l_payload
                                                       , pi_current_user     => pi_current_user
                                                       , po_status_code      => po_status_code
                                                       , po_forward_location => po_forward_location 
                                                       , po_exc_payload      => l_exc_payload
                                                       , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+/process_vars$', 'i') then
            flow_rest_api_v1.process_vars_put( pi_prcs_id          => pi_prcs_id
                                             , pi_payload          => l_payload
                                             , pi_current_user     => pi_current_user
                                             , po_status_code      => po_status_code
                                             , po_forward_location => po_forward_location 
                                             , po_exc_payload      => l_exc_payload
                                             , po_exc_payload_attr_name => l_exc_payload_attr_name );
          else 
            raise flow_rest_constants.e_not_implemented;
        end case;

      when 'DELETE' then
        case 
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+$', 'i') then
            flow_rest_api_v1.processes_delete( pi_prcs_id      => pi_prcs_id
                                             , pi_payload      => l_payload
                                             , pi_current_user => pi_current_user
                                             , po_status_code  => po_status_code 
                                             , po_exc_payload  => l_exc_payload
                                             , po_exc_payload_attr_name => l_exc_payload_attr_name );
          when regexp_like(pi_endpoint, '^v1/processes/[[:digit:]]+/process_vars$', 'i') then
            flow_rest_api_v1.process_vars_delete( pi_prcs_id       => pi_prcs_id
                                                , pi_payload       => l_payload
                                                , pi_current_user  => pi_current_user
                                                , po_status_code   => po_status_code 
                                                , po_exc_payload   => l_exc_payload
                                                , po_exc_payload_attr_name => l_exc_payload_attr_name );
          else
            raise flow_rest_constants.e_not_implemented;
        end case;                                                
      else 
        raise flow_rest_constants.e_not_implemented;
    end case;

    flow_rest_logging.finished( pi_payload => l_payload );
    flow_rest.cleanup;
    commit;

    exception 
      when others then 
        flow_rest_errors.handle_error( pi_sqlcode            => SQLCODE
                                     , pi_message            => SQLERRM 
                                     , pi_stacktrace         => dbms_utility.format_error_backtrace 
                                     , pi_payload            => l_exc_payload
                                     , pi_payload_attr_name  => l_exc_payload_attr_name
                                     , po_status_code        => po_status_code );

  end dispatch;

  -------------------------------------------------------------------------------------------------------------------

  function get_path( pi_path_endpoint  varchar2, pi_object_id  varchar2)
    return varchar2
  is
  begin

    if flow_rest.get_apex_host is null then 
      flow_rest.set_apex_host;
    end if;

    return replace( flow_rest.get_apex_host || flow_rest_constants.c_module || pi_path_endpoint,':id', pi_object_id);
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
                          , po_forward_location out varchar2 
                          , po_exc_payload      out json_element_t
                          , po_exc_payload_attr_name out varchar2 )
  as
    pragma autonomous_transaction;

    l_item_object   json_object_t;
    l_prcs_id       flow_processes.prcs_id%type;
    l_business_ref_arr  json_array_t;
    l_error_occured     boolean := false;

  begin

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
      when others then 
        raise;
      
  end processes_post;                       

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_start_put( pi_prcs_id          flow_processes.prcs_id%type
                               , pi_current_user     varchar2
                               , po_status_code      out number 
                               , po_forward_location out varchar2
                               , po_exc_payload      out json_element_t
                               , po_exc_payload_attr_name out varchar2 )
  as 
    l_item_object      json_object_t;   
  begin
    
    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    l_item_object := new json_object_t();
    l_item_object.put('status','start');

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    
    
    flow_rest_response.send_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end processes_start_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_reset_put( pi_prcs_id          flow_processes.prcs_id%type
                               , pi_payload          json_element_t  
                               , pi_current_user     varchar2
                               , po_status_code      out number 
                               , po_forward_location out varchar2 
                               , po_exc_payload      out json_element_t
                               , po_exc_payload_attr_name out varchar2)       
  as 
    l_item_object      json_object_t;   
  begin

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

    
    
    flow_rest_response.send_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end processes_reset_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_terminate_put( pi_prcs_id          flow_processes.prcs_id%type
                                   , pi_payload          json_element_t  
                                   , pi_current_user     varchar2
                                   , po_status_code      out number 
                                   , po_forward_location out varchar2
                                   , po_exc_payload      out json_element_t
                                   , po_exc_payload_attr_name out varchar2 )                                                         
  as
    l_item_object      json_object_t;   
  begin

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

    flow_rest_response.send_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end processes_terminate_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_put( pi_prcs_id          flow_processes.prcs_id%type
                         , pi_payload          json_element_t 
                         , pi_current_user     varchar2
                         , po_status_code      out number
                         , po_forward_location out varchar2 
                         , po_exc_payload      out json_element_t
                         , po_exc_payload_attr_name out varchar2)
  as
    l_item_object      json_object_t;   
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_status_update( pi_prcs_id  => pi_prcs_id
                                   , pi_payload  => l_item_object );

    flow_rest_response.send_success( pi_success_message => 'status updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_process
                                                                           , pi_object_id    => pi_prcs_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;
  end processes_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure processes_delete( pi_prcs_id          flow_processes.prcs_id%type
                            , pi_payload          json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number
                            , po_exc_payload      out json_element_t
                            , po_exc_payload_attr_name out varchar2 )
  as
    l_item_object          json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_api_pkg.flow_delete( p_process_id => pi_prcs_id
                            , p_comment    => l_item_object.get_string('comment') );

    flow_rest_response.send_success( pi_success_message => 'process deleted' 
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end processes_delete;    

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                     , pi_payload          json_element_t 
                     , pi_current_user     varchar2
                     , po_status_code      out number 
                     , po_forward_location out varchar2
                     , po_exc_payload      out json_element_t
                     , po_exc_payload_attr_name out varchar2)
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_put;
  
  -------------------------------------------------------------------------------------------------------------------
  
  procedure steps_start_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                           , pi_payload          json_element_t 
                           , pi_current_user     varchar2
                           , po_status_code      out number 
                           , po_forward_location out varchar2
                           , po_exc_payload      out json_element_t
                           , po_exc_payload_attr_name out varchar2 )
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_start);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_start_put;                               

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_reserve_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                             , pi_payload          json_element_t 
                             , pi_current_user     varchar2
                             , po_status_code      out number 
                             , po_forward_location out varchar2
                             , po_exc_payload      out json_element_t
                             , po_exc_payload_attr_name out varchar2)
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_reserve);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_reserve_put;                          

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_release_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                             , pi_payload          json_element_t 
                             , pi_current_user     varchar2
                             , po_status_code      out number 
                             , po_forward_location out varchar2
                             , po_exc_payload      out json_element_t
                             , po_exc_payload_attr_name out varchar2)
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_release);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_release_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_complete_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                              , pi_payload          json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2
                              , po_exc_payload      out json_element_t
                              , po_exc_payload_attr_name out varchar2)
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_complete);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_complete_put;

  -------------------------------------------------------------------------------------------------------------------
  
  procedure steps_restart_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                             , pi_payload          json_element_t 
                             , pi_current_user     varchar2
                             , po_status_code      out number 
                             , po_forward_location out varchar2
                             , po_exc_payload      out json_element_t
                             , po_exc_payload_attr_name out varchar2 )
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_restart);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_restart_put;

  -------------------------------------------------------------------------------------------------------------------

  procedure steps_reschedule_timer_put( pi_sbfl_id          flow_subflows.sbfl_id%type
                                      , pi_payload          json_element_t 
                                      , pi_current_user     varchar2
                                      , po_status_code      out number 
                                      , po_forward_location out varchar2
                                      , po_exc_payload      out json_element_t
                                      , po_exc_payload_attr_name out varchar2 )
  as
    l_item_object      json_object_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload              => pi_payload 
                                        , pi_array_allowed        => false 
                                        , po_payload_object       => l_item_object );

    l_item_object.put( flow_rest_constants.c_step_status_status, flow_rest_constants.c_step_status_reschedule_timer);

    flow_rest.step_update( pi_sbfl_id  => pi_sbfl_id
                         , pi_payload  => l_item_object );

                        
    flow_rest_response.send_success( pi_success_message => 'step updated' 
                                   , pi_payload         => get_links_array ( pi_object_type  => flow_rest_constants.c_object_type_step
                                                                           , pi_object_id    => pi_sbfl_id )
                                   , pi_payload_attr_name => 'links'
                                   , po_status_code     => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_item_object;
        po_exc_payload_attr_name := 'item';
        raise;

  end steps_reschedule_timer_put;                                    

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_put( pi_prcs_id          flow_processes.prcs_id%type 
                            , pi_payload          json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number 
                            , po_forward_location out varchar2
                            , po_exc_payload      out json_element_t
                            , po_exc_payload_attr_name out varchar2 )
  as
    l_prov_array   json_array_t;

  begin

    flow_rest.verify_and_prepare_payload( pi_payload       => pi_payload 
                                        , pi_array_allowed => true 
                                        , po_payload_array => l_prov_array );

    flow_rest.process_vars_update( pi_prcs_id    => pi_prcs_id
                                 , pio_prov_arr  => l_prov_array
                                 , pi_add_error_msg  => true );


    flow_rest_response.send_success( pi_success_message   => 'process variables updated' 
                                   , pi_payload           => l_prov_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_prov_array;
        po_exc_payload_attr_name := 'items';
        raise;

  end process_vars_put;    

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_delete( pi_prcs_id          flow_processes.prcs_id%type 
                               , pi_payload          json_element_t 
                               , pi_current_user     varchar2
                               , po_status_code      out number
                               , po_exc_payload      out json_element_t
                               , po_exc_payload_attr_name out varchar2 )
  as
    l_prov_array   json_array_t;
  begin

    flow_rest.verify_and_prepare_payload( pi_payload         => pi_payload 
                                        , pi_array_allowed   => false 
                                        , po_payload_array   => l_prov_array );

    flow_rest.verify_process_exists( pi_prcs_id  => pi_prcs_id );

    flow_rest.process_vars_delete( pi_prcs_id    => pi_prcs_id
                                 , pio_prov_arr  => l_prov_array
                                 , pi_add_error_msg  => true );

    flow_rest_response.send_success( pi_success_message   => 'process variables deleted' 
                                   , pi_payload           => l_prov_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_prov_array;
        po_exc_payload_attr_name := 'items';
        raise;

  end process_vars_delete;    

  -------------------------------------------------------------------------------------------------------------------

  procedure messages_put( pi_message_name     flow_message_subscriptions.msub_message_name%type 
                        , pi_payload          json_element_t 
                        , pi_current_user     varchar2
                        , po_status_code      out number 
                        , po_forward_location out varchar2 
                        , po_exc_payload      out json_element_t
                        , po_exc_payload_attr_name out varchar2)
  as
    l_msg_array json_array_t;
  begin
    
    flow_rest.verify_and_prepare_payload( pi_payload         => pi_payload 
                                        , pi_array_allowed   => true 
                                        , po_payload_array   => l_msg_array );

    flow_rest.messages_update( pi_message_name  => pi_message_name
                             , pi_msg_arr       => l_msg_array );

    flow_rest_response.send_success( pi_success_message   => 'message subscription updated' 
                                   , pi_payload           => l_msg_array
                                   , pi_payload_attr_name => 'items'
                                   , po_status_code       => po_status_code );

    exception 
      when others then 
        po_exc_payload := l_msg_array;
        po_exc_payload_attr_name := 'items';
        raise;

  end messages_put;      

end flow_rest_api_v1;
/

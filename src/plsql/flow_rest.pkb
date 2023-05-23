create or replace package body flow_rest
as

  function get_config_value( pi_key  flow_configuration.cfig_key%type )
    return flow_configuration.cfig_value%type
  as
    l_key    flow_configuration.cfig_key%type := flow_rest_constants.c_config_prefix || pi_key;
    l_value  flow_configuration.cfig_value%type;
  begin 
    select cfig_value
      into l_value
      from flow_configuration 
      where cfig_key = l_key;
    return l_value;
  end get_config_value;

  -------------------------------------------------------------------------------------------------------------------
  
  procedure initialize( pi_client_id varchar2
                      , pi_method    varchar2 )
  as
    l_check_privilege  varchar2(50 char);
  begin

    case upper(pi_method) 
      when 'POST' then
        l_check_privilege := flow_rest_constants.c_rest_priv_write;
      when 'PUT'  then 
        l_check_privilege := flow_rest_constants.c_rest_priv_write;
      when 'DELET' then 
        l_check_privilege := flow_rest_constants.c_rest_priv_admin;
    end case;

    flow_rest.initialize( pi_client_id        => pi_client_id
                        , pi_check_privilege  => l_check_privilege ) ;             

  end initialize;

  -------------------------------------------------------------------------------------------------------------------

  procedure initialize( pi_client_id        varchar2
                      , pi_check_privilege  varchar2 )
  as
  begin

    flow_rest_logging.initialize;

    flow_globals.set_call_origin( p_origin => flow_rest_constants.c_config_origin );

    owa_util.mime_header ('application/json', true); 

    flow_rest_auth.check_privilege( pi_client_id       => pi_client_id 
                                  , pi_privilege_name  => pi_check_privilege );                              

  end initialize;

  -------------------------------------------------------------------------------------------------------------------

  procedure cleanup
  as
  begin

    flow_globals.unset_call_origin;
    flow_rest_logging.cleanup;

  end cleanup;

  -------------------------------------------------------------------------------------------------------------------

  procedure add_error( pio_object_jo in out nocopy json_object_t 
                     , pi_error_type in varchar2
                     , pi_error_msg  in varchar2 )
  as
    l_error_jo   json_object_t;
    l_errors_ja  json_array_t;
  begin

    if not pio_object_jo.has(flow_rest_constants.c_json_errors_key) then
      pio_object_jo.put(flow_rest_constants.c_json_errors_key, new json_array_t() );
    end if;

    l_error_jo := new json_object_t();
    l_error_jo.put( flow_rest_constants.c_json_error_type, pi_error_type );
    l_error_jo.put( flow_rest_constants.c_json_error_value, pi_error_msg );

    l_errors_ja := pio_object_jo.get_Array(flow_rest_constants.c_json_errors_key);
    l_errors_ja.append(l_error_jo);
  end add_error;

  -------------------------------------------------------------------------------------------------------------------

  function get_json_array_t( pi_json_object_t  json_object_t)
    return json_array_t
  as
    l_json_array_t  json_array_t;
  begin
    l_json_array_t := new json_array_t();
    l_json_array_t.append( pi_json_object_t );
    return l_json_array_t;
  end get_json_array_t;

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_and_prepare_payload( pi_payload         json_element_t 
                                      , pi_array_allowed   boolean 
                                      , po_payload_object  out json_object_t
                                      , po_payload_array   out json_array_t )
  as
  begin
  
    if pi_payload.is_Object then

      po_payload_object := treat(pi_payload as json_object_t);
      po_payload_array  := new json_array_t;
      po_payload_array.append( po_payload_object );

    elsif pi_payload.is_Array then  

      if not pi_array_allowed then 
        raise flow_rest_constants.e_multiple_object_error;
      end if;
      po_payload_array := treat(pi_payload as json_array_t);

    else
      raise flow_rest_constants.e_payload_not_acceptable;
    end if;

  end verify_and_prepare_payload;       

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_and_prepare_payload( pi_payload         json_element_t 
                                      , pi_array_allowed   boolean 
                                      , po_payload_object  out json_object_t)
  as
    po_payload_array json_array_t;
  begin

    verify_and_prepare_payload( pi_payload              => pi_payload
                              , pi_array_allowed        => pi_array_allowed
                              , po_payload_object       => po_payload_object
                              , po_payload_array        => po_payload_array );
    

  end verify_and_prepare_payload;   

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_and_prepare_payload( pi_payload         json_element_t 
                                      , pi_array_allowed   boolean 
                                      , po_payload_array   out json_array_t)
  as
    po_payload_object json_object_t;
  begin

    verify_and_prepare_payload( pi_payload              => pi_payload
                              , pi_array_allowed        => pi_array_allowed
                              , po_payload_object       => po_payload_object
                              , po_payload_array        => po_payload_array );
    

  end verify_and_prepare_payload;   

  -------------------------------------------------------------------------------------------------------------------

  function chk_attributes_exist( pio_object_jo       in out nocopy json_object_t
                               , pi_attributes_list  varchar2
                               , pi_add_error_msg    boolean default true )
    return boolean
  as
    l_attribute_exists  boolean := true;
  begin
    for rec_attributes in (select column_value as name 
                             from apex_string.split( pi_attributes_list
                                                   , flow_rest_constants.c_split_sep ))
    loop
      if pio_object_jo.get(rec_attributes.name) is null then

        l_attribute_exists := false;

        if pi_add_error_msg then
          add_error( pio_object_jo => pio_object_jo
                   , pi_error_type => flow_rest_constants.c_json_error_type_missing_attr
                   , pi_error_msg  => rec_attributes.name );
        end if;

      end if;
    end loop;

    return l_attribute_exists;

  end chk_attributes_exist;

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_diagram_exists( pi_dgrm_id       flow_diagrams.dgrm_id%type
                                 , pi_dgrm_version  flow_diagrams.dgrm_version%type default null )
  as
    l_check  number; 
  begin
    select 1
      into l_check 
      from flow_diagrams
      where dgrm_id = pi_dgrm_id 
        and dgrm_version = nvl(pi_dgrm_version, dgrm_version)
      fetch first 1 rows only;

    exception 
      when no_data_found then
        raise flow_rest_constants.e_item_not_found;

  end verify_diagram_exists;

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_process_exists( pi_prcs_id  flow_processes.prcs_id%type )
  as
    l_check  number; 
  begin
    select 1
      into l_check 
      from flow_processes
      where prcs_id = pi_prcs_id;

    exception 
      when no_data_found then
        raise flow_rest_constants.e_item_not_found;

  end verify_process_exists;

  -------------------------------------------------------------------------------------------------------------------

  procedure verify_subflow_exists( pi_sbfl_id  flow_subflows.sbfl_id%type )
  as
    l_check  number; 
  begin
    select 1
      into l_check 
      from flow_subflows
      where sbfl_id = pi_sbfl_id;

    exception 
      when no_data_found then
        raise flow_rest_constants.e_item_not_found;

  end verify_subflow_exists;

  -------------------------------------------------------------------------------------------------------------------

  function get_process_id( p_sbfl_id  flow_subflows.sbfl_id%type )
    return flow_processes.prcs_id%type
  is
    l_prcs_id  flow_processes.prcs_id%type;
  begin
    select sbfl_prcs_id 
      into l_prcs_id
      from flow_subflows
      where sbfl_id = p_sbfl_id;
    return l_prcs_id;
  end get_process_id;

  -------------------------------------------------------------------------------------------------------------------
  
  function get_process_id( pi_message_name   flow_message_subscriptions.msub_message_name%type
                         , pi_msub_key_name  flow_message_subscriptions.msub_key_name%type
                         , pi_msub_key_value flow_message_subscriptions.msub_key_value%type )
    return flow_processes.prcs_id%type
  is
    l_prcs_id  flow_processes.prcs_id%type;
  begin
    select msub_prcs_id 
      into l_prcs_id
      from flow_message_subscriptions
      where msub_message_name = pi_message_name
        and msub_key_name     = pi_msub_key_name
        and msub_key_value    = pi_msub_key_value;
    return l_prcs_id;
  end get_process_id;
  
  -------------------------------------------------------------------------------------------------------------------

  function get_step_key( p_sbfl_id  flow_subflows.sbfl_id%type )
    return flow_subflows.sbfl_step_key%type
  is
    l_step_key  flow_subflows.sbfl_step_key%type;
  begin
    select sbfl_step_key
      into l_step_key
      from flow_subflows
      where sbfl_id = p_sbfl_id;
    return l_step_key;
  end get_step_key;

  -------------------------------------------------------------------------------------------------------------------

  procedure process_status_update( pi_prcs_id   flow_processes.prcs_id%type 
                                 , pi_payload   in out nocopy json_object_t )
  as
  begin

    if not chk_attributes_exist( pio_object_jo       => pi_payload
                               , pi_attributes_list  => flow_rest_constants.c_check_attr_process_update
                               , pi_add_error_msg    => true ) 
    then
      raise flow_rest_constants.e_attribute_not_found;
    end if;

    case lower(pi_payload.get_string( 'status' ))
      when flow_rest_constants.c_process_status_start then
        flow_api_pkg.flow_start( p_process_id => pi_prcs_id );

      when flow_rest_constants.c_process_status_reset then
        flow_api_pkg.flow_reset( p_process_id => pi_prcs_id
                               , p_comment    => pi_payload.get_string( 'comment' ));

      when flow_rest_constants.c_process_status_terminate then
        flow_api_pkg.flow_terminate( p_process_id  => pi_prcs_id
                                   , p_comment     => pi_payload.get_string( 'comment' ));    

      else
        raise flow_rest_constants.e_process_unknown_status;
    end case;

  end process_status_update;                          

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_update( pi_prcs_id    flow_processes.prcs_id%type 
                               , pio_prov_arr  in out nocopy json_array_t 
                               , pi_add_error_msg   boolean default true )
  as 
    l_prov_object  json_object_t;
    l_error_occured boolean := false;
  begin

    verify_process_exists( pi_prcs_id => pi_prcs_id );

    for idx_json in 0..pio_prov_arr.get_size-1
    loop
      begin
        l_prov_object := treat(pio_prov_arr.get(idx_json) as json_object_t);

        if not chk_attributes_exist( pio_object_jo       => l_prov_object
                                   , pi_attributes_list  => flow_rest_constants.c_check_attr_process_var_update
                                   , pi_add_error_msg    => pi_add_error_msg ) 
        then
          raise flow_rest_constants.e_attribute_not_found;
        end if;

        if not l_prov_object.has( flow_rest_constants.c_json_prov_sbfl_id ) then
          case lower( l_prov_object.get_string( flow_rest_constants.c_json_prov_type ) )
            when flow_rest_constants.c_pvar_type_varchar then
              flow_process_vars.set_var( pi_prcs_id   => pi_prcs_id
                                       , pi_var_name  => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_scope     => nvl( l_prov_object.get_string( flow_rest_constants.c_json_prov_scope ), 0)
                                       , pi_vc2_value => l_prov_object.get_string( flow_rest_constants.c_json_prov_value ) );
            when flow_rest_constants.c_pvar_type_number then
              flow_process_vars.set_var( pi_prcs_id   => pi_prcs_id
                                       , pi_var_name  => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_scope     => nvl( l_prov_object.get_string( flow_rest_constants.c_json_prov_scope ), 0)
                                       , pi_num_value => to_number(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
            when flow_rest_constants.c_pvar_type_date then
              flow_process_vars.set_var( pi_prcs_id    => pi_prcs_id
                                       , pi_var_name   => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_scope      => nvl( l_prov_object.get_string( flow_rest_constants.c_json_prov_scope ), 0)
                                       , pi_date_value => to_date(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
            when flow_rest_constants.c_pvar_type_clob then
              flow_process_vars.set_var( pi_prcs_id    => pi_prcs_id
                                       , pi_var_name   => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_scope      => nvl( l_prov_object.get_string( flow_rest_constants.c_json_prov_scope ), 0)
                                       , pi_clob_value => to_clob(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
          end case;
        else
          case lower( l_prov_object.get_string( flow_rest_constants.c_json_prov_type ) )
            when flow_rest_constants.c_pvar_type_varchar then
              flow_process_vars.set_var( pi_prcs_id   => pi_prcs_id
                                       , pi_var_name  => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_sbfl_id   => l_prov_object.get_number( flow_rest_constants.c_json_prov_sbfl_id )
                                       , pi_vc2_value => l_prov_object.get_string( flow_rest_constants.c_json_prov_value ) );
            when flow_rest_constants.c_pvar_type_number then
              flow_process_vars.set_var( pi_prcs_id   => pi_prcs_id
                                       , pi_var_name  => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_sbfl_id   => l_prov_object.get_number( flow_rest_constants.c_json_prov_sbfl_id )
                                       , pi_num_value => to_number(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
            when flow_rest_constants.c_pvar_type_date then
              flow_process_vars.set_var( pi_prcs_id    => pi_prcs_id
                                       , pi_var_name   => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_sbfl_id    => l_prov_object.get_number( flow_rest_constants.c_json_prov_sbfl_id )
                                       , pi_date_value => to_date(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
            when flow_rest_constants.c_pvar_type_clob then
              flow_process_vars.set_var( pi_prcs_id    => pi_prcs_id
                                       , pi_var_name   => l_prov_object.get_string( flow_rest_constants.c_json_prov_name )
                                       , pi_sbfl_id    => l_prov_object.get_number( flow_rest_constants.c_json_prov_sbfl_id )
                                       , pi_clob_value => to_clob(l_prov_object.get_string( flow_rest_constants.c_json_prov_value )) );
          end case;
        end if;


      exception 
        when flow_rest_constants.e_attribute_not_found then
          l_error_occured := true;     
        when others then 
          l_error_occured := true;
          if pi_add_error_msg then 
            add_error( pio_object_jo  => l_prov_object
                     , pi_error_type  => flow_rest_constants.c_json_error_type_processing_error
                     , pi_error_msg   => SQLERRM );
          end if;
      end;
    
    end loop;

    if l_error_occured then 
      raise flow_rest_constants.e_processing_error;
    end if;

  end process_vars_update;

  -------------------------------------------------------------------------------------------------------------------

  procedure process_vars_delete( pi_prcs_id    flow_processes.prcs_id%type 
                               , pio_prov_arr  in out nocopy json_array_t 
                               , pi_add_error_msg   boolean default true )
  as 
    l_prov_object    json_object_t;
    l_error_occured  boolean := false;
  begin

    verify_process_exists( pi_prcs_id => pi_prcs_id );

    for idx_json in 0..pio_prov_arr.get_size-1
    loop
      begin
        l_prov_object := treat(pio_prov_arr.get(idx_json) as json_object_t);

        -- check if necessary parameters exists
        if not chk_attributes_exist( pio_object_jo       => l_prov_object
                                   , pi_attributes_list  => flow_rest_constants.c_check_attr_process_var_delete
                                   , pi_add_error_msg    => pi_add_error_msg ) 
        then
          raise flow_rest_constants.e_attribute_not_found;
        end if;

        if not l_prov_object.has('sbfl_id') then
          flow_process_vars.delete_var( pi_prcs_id   => pi_prcs_id
                                      , pi_scope     => nvl( l_prov_object.get_string('scope'), 0) 
                                      , pi_var_name  => l_prov_object.get_string('name') );
        else
          flow_process_vars.delete_var( pi_prcs_id   => pi_prcs_id
                                      , pi_sbfl_id   => l_prov_object.get_number('sbfl_id')
                                      , pi_var_name  => l_prov_object.get_string('name') );
        end if;

        exception 
        when flow_rest_constants.e_attribute_not_found then
          l_error_occured := true;     
        when others then 
          l_error_occured := true;
          if pi_add_error_msg then 
            add_error( pio_object_jo  => l_prov_object
                     , pi_error_type  => flow_rest_constants.c_json_error_type_processing_error
                     , pi_error_msg   => SQLERRM );
          end if;
      end;
    end loop;         
                      
    if l_error_occured then 
      raise flow_rest_constants.e_processing_error;
    end if;

  end process_vars_delete;
  
  -------------------------------------------------------------------------------------------------------------------

  procedure step_update( pi_sbfl_id  flow_subflows.sbfl_id%type
                       , pi_payload   in out nocopy json_object_t )
  as
  begin

    verify_subflow_exists( pi_sbfl_id => pi_sbfl_id );
    
    if not chk_attributes_exist(pio_object_jo      => pi_payload
                              , pi_attributes_list => flow_rest_constants.c_check_attr_step_update
                              , pi_add_error_msg   => true)
    then 
      raise flow_rest_constants.e_attribute_not_found;
    end if; 

    case lower( pi_payload.get_string(flow_rest_constants.c_step_status_status) )
      when flow_rest_constants.c_step_status_start then
        flow_api_pkg.flow_start_step( p_process_id => get_process_id( p_sbfl_id => pi_sbfl_id )
                                    , p_subflow_id => pi_sbfl_id 
                                    , p_step_key   => pi_payload.get_string('step_key') );
      when flow_rest_constants.c_step_status_reserve then
        flow_api_pkg.flow_reserve_step( p_process_id  => get_process_id( p_sbfl_id => pi_sbfl_id )
                                      , p_subflow_id  => pi_sbfl_id 
                                      , p_step_key    => pi_payload.get_string('step_key')
                                      , p_reservation => pi_payload.get_string('reservation') );
      when flow_rest_constants.c_step_status_release then
        flow_api_pkg.flow_release_step( p_process_id => get_process_id( p_sbfl_id => pi_sbfl_id )
                                      , p_subflow_id => pi_sbfl_id
                                      , p_step_key   => pi_payload.get_string('step_key') );
      when flow_rest_constants.c_step_status_complete then
        flow_api_pkg.flow_complete_step( p_process_id  => get_process_id( p_sbfl_id => pi_sbfl_id )
                                        , p_subflow_id  => pi_sbfl_id
                                        , p_step_key    => pi_payload.get_string('step_key') );
      when flow_rest_constants.c_step_status_restart then
        flow_api_pkg.flow_restart_step( p_process_id  => get_process_id( p_sbfl_id => pi_sbfl_id )
                                      , p_subflow_id  => pi_sbfl_id
                                      , p_step_key    => pi_payload.get_string('step_key') );
      when flow_rest_constants.c_step_status_reschedule_timer then
        flow_api_pkg.flow_reschedule_timer( p_process_id    => get_process_id( p_sbfl_id => pi_sbfl_id )
                                          , p_subflow_id    => pi_sbfl_id
                                          , p_step_key      => pi_payload.get_string('step_key')
                                          , p_is_immediate  => pi_payload.get_boolean('is_immediate') 
                                          , p_new_timestamp => cast(pi_payload.get_date('new_timestamp') as timestamp)
                                          , p_comment       => pi_payload.get_string('comment') );
      else
        raise flow_rest_constants.e_step_unknown_operation;
    end case;

  end step_update;                       

  -------------------------------------------------------------------------------------------------------------------

  procedure messages_update( pi_message_name   flow_message_subscriptions.msub_message_name%type 
                           , pi_msg_arr        in out nocopy json_array_t )
  as 
    l_msg_object  json_object_t;
    l_error_occured boolean := false;
  begin

    for idx_json in 0..pi_msg_arr.get_size-1
    loop
      begin
        l_msg_object := treat(pi_msg_arr.get(idx_json) as json_object_t);

        -- check if necessary parameters exists
        if not chk_attributes_exist(pio_object_jo      => l_msg_object
                                  , pi_attributes_list => flow_rest_constants.c_check_attr_message_update
                                  , pi_add_error_msg   => true)
        then 
          raise flow_rest_constants.e_attribute_not_found;
        end if;

        flow_api_pkg.receive_message( p_message_name  => pi_message_name
                                    , p_key_name      => l_msg_object.get_string('key')
                                    , p_key_value     => l_msg_object.get_string('value')
                                    , p_payload       => l_msg_object.get_clob('payload') );

        exception 
            when flow_rest_constants.e_attribute_not_found then 
              l_error_occured := true;
      end;
    end loop;

    if l_error_occured then 
      raise flow_rest_constants.e_processing_error;
    end if;

  end messages_update;
  

end flow_rest;
/

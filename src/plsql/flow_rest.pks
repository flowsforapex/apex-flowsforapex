create or replace package flow_rest
  authid definer
as
/* 
-- Flows for APEX - flow_rest.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  19-JAN-2023  Jörg Doppelreiter (solicon IT GmbH)
--
*/

  function get_config_value( pi_key  flow_configuration.cfig_key%type )
    return flow_configuration.cfig_value%type;
    
  procedure init( pi_client_id        varchar2
                , pi_check_privilege  varchar2 );

  procedure final;     

  function get_json_array_t( pi_json_object_t  json_object_t)
    return json_array_t;

  procedure verify_and_prepare_payload( pi_payload              json_element_t 
                                      , pi_array_allowed        boolean 
                                      , po_payload_object   out json_object_t
                                      , po_payload_array    out json_array_t );     

  procedure verify_and_prepare_payload( pi_payload              json_element_t 
                                      , pi_array_allowed        boolean 
                                      , po_payload_object   out json_object_t);

  procedure verify_and_prepare_payload( pi_payload              json_element_t 
                                      , pi_array_allowed        boolean 
                                      , po_payload_array    out json_array_t);                                      

  procedure verify_diagram_exists( pi_dgrm_id       flow_diagrams.dgrm_id%type
                                 , pi_dgrm_version  flow_diagrams.dgrm_version%type default null );

  procedure verify_process_exists( pi_prcs_id  flow_processes.prcs_id%type );

  procedure verify_subflow_exists( pi_sbfl_id  flow_subflows.sbfl_id%type );

  function get_process_id( p_sbfl_id  flow_subflows.sbfl_id%type )
    return flow_processes.prcs_id%type;
  
  function get_process_id( pi_message_name   flow_message_subscriptions.msub_message_name%type
                         , pi_msub_key_name  flow_message_subscriptions.msub_key_name%type
                         , pi_msub_key_value flow_message_subscriptions.msub_key_value%type )
    return flow_processes.prcs_id%type;

  function get_step_key( p_sbfl_id  flow_subflows.sbfl_id%type )
    return flow_subflows.sbfl_step_key%type;

  procedure process_status_update( pi_prcs_id   flow_processes.prcs_id%type 
                                 , pi_payload   in out nocopy json_object_t );

  procedure process_vars_update( pi_prcs_id    flow_processes.prcs_id%type 
                               , pio_prov_arr  in out nocopy json_array_t 
                               , pi_add_error_msg   boolean default true );

  procedure process_vars_delete( pi_prcs_id    flow_processes.prcs_id%type 
                               , pio_prov_arr  in out nocopy json_array_t 
                               , pi_add_error_msg   boolean default true );                               

  procedure step_update( pi_sbfl_id  flow_subflows.sbfl_id%type
                       , pi_payload   in out nocopy json_object_t );

  procedure messages_update( pi_message_name   flow_message_subscriptions.msub_message_name%type 
                           , pi_msg_arr        in out nocopy json_array_t );

end flow_rest;
/

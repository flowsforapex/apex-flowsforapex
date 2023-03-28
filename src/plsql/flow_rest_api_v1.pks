create or replace package flow_rest_api_v1
  authid definer
as

  /*
  *  Workaround for ORDS-GET Method to support nested JSON Array in Collection Query 
  *  ORDS already generates separate collection brackets [] -> therefor the brackets are removed from the string.
  */
  function get_links_string_http_GET ( pi_object_type  varchar2
                                     , pi_object_id    varchar2)
    return clob;    

  function get_path( pi_path_endpoint  varchar2, pi_object_id  varchar2)
    return varchar2;

  procedure processes_post( pi_dgrm_id  flow_diagrams.dgrm_id%type
                          , pi_payload  json_element_t 
                          , pi_current_user     varchar2
                          , po_status_code      out number 
                          , po_forward_location out varchar2);
  
  procedure processes_start_post( pi_prcs_id          flow_processes.prcs_id%type
                                , pi_current_user     varchar2
                                , po_status_code      out number 
                                , po_forward_location out varchar2 );

  procedure processes_reset_post( pi_prcs_id          flow_processes.prcs_id%type
                                , pi_payload          json_element_t  
                                , pi_current_user     varchar2
                                , po_status_code      out number 
                                , po_forward_location out varchar2 );       

  procedure processes_terminate_post( pi_prcs_id          flow_processes.prcs_id%type
                                    , pi_payload          json_element_t  
                                    , pi_current_user     varchar2
                                    , po_status_code      out number 
                                    , po_forward_location out varchar2 );                                                          

  procedure processes_put( pi_prcs_id  flow_processes.prcs_id%type
                         , pi_payload  json_element_t 
                         , pi_current_user     varchar2
                         , po_status_code      out number 
                         , po_forward_location out varchar2);

  procedure processes_delete( pi_prcs_id  flow_processes.prcs_id%type
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code out number );

  procedure steps_put( pi_sbfl_id  flow_subflows.sbfl_id%type
                     , pi_payload  json_element_t 
                     , pi_current_user     varchar2
                     , po_status_code      out number 
                     , po_forward_location out varchar2);    

  procedure steps_start_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number 
                            , po_forward_location out varchar2);    

  procedure steps_reserve_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2); 

  procedure steps_release_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2);

  procedure steps_complete_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                               , pi_payload  json_element_t 
                               , pi_current_user     varchar2
                               , po_status_code      out number 
                               , po_forward_location out varchar2); 

  procedure steps_restart_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                              , pi_payload  json_element_t 
                              , pi_current_user     varchar2
                              , po_status_code      out number 
                              , po_forward_location out varchar2); 

  procedure steps_reschedule_timer_post( pi_sbfl_id  flow_subflows.sbfl_id%type
                                       , pi_payload  json_element_t 
                                       , pi_current_user     varchar2
                                       , po_status_code      out number 
                                       , po_forward_location out varchar2); 

  procedure process_vars_put( pi_prcs_id  flow_processes.prcs_id%type 
                            , pi_payload  json_element_t 
                            , pi_current_user     varchar2
                            , po_status_code      out number 
                            , po_forward_location out varchar2);

  procedure process_vars_delete( pi_prcs_id  flow_processes.prcs_id%type 
                               , pi_payload  json_element_t 
                               , pi_current_user     varchar2
                               , po_status_code out number );

  procedure messages_put( pi_message_name  flow_message_subscriptions.msub_message_name%type 
                        , pi_payload       json_element_t 
                        , pi_current_user     varchar2
                        , po_status_code      out number 
                        , po_forward_location out varchar2 );

end flow_rest_api_v1;
/

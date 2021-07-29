create or replace package body flow_logging
as

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
  )
  is 
  begin 
    insert into flow_instance_event_log
    ( lgpr_prcs_id 
    , lgpr_dgrm_id 
    , lgpr_prcs_name 
    , lgpr_business_id
    , lgpr_prcs_event
    , lgpr_timestamp 
    , lgpr_user 
    , lgpr_comment
    )
    select prcs.prcs_id
         , prcs.prcs_dgrm_id
         , prcs.prcs_name
         , flow_process_vars.get_business_ref (p_process_id)  --- 
         , p_event
         , systimestamp 
         , coalesce ( sys_context('apex$session','app_user') 
                    , sys_context('userenv','os_user')
                    , sys_context('userenv','session_user')
                    )  --- check this is complete
         , p_comment
      from flow_processes prcs 
     where prcs.prcs_id = p_process_id
    ;
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging instance event'
      , p_display_location => apex_error.c_on_error_page
      );
      raise;
  end log_instance_event;

end flow_logging;
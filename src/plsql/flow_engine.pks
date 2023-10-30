create or replace package flow_engine
  authid definer
  accessible by ( flow_api_pkg, flow_instances, flow_gateways, flow_tasks
                , flow_boundary_events, flow_timers_pkg, flow_subprocesses
                , flow_call_activities, flow_usertask_pkg, flow_message_flow)
as 
  procedure timer_callback
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type
  , p_timr_id       in flow_timers.timr_id%type default null
  , p_run           in flow_timers.timr_run%type default null
  , p_callback      in flow_timers.timr_callback%type default null
  , p_callback_par  in flow_timers.timr_callback_par%type default null
  , p_event_type    in flow_objects.objt_sub_tag_name%type
  ); 
procedure flow_complete_step
  ( p_process_id        in flow_processes.prcs_id%type
  , p_subflow_id        in flow_subflows.sbfl_id%type
  , p_step_key          in flow_subflows.sbfl_step_key%type default null
  , p_forward_route     in flow_connections.conn_bpmn_id%type default null   
  , p_log_as_completed  in boolean default true
  , p_recursive_call    in boolean default true
  );

procedure start_step
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_step_key            in flow_subflows.sbfl_step_key%type default null
  , p_called_internally   in boolean default false
  );

procedure restart_step
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_step_key            in flow_subflows.sbfl_step_key%type default null
  , p_comment             in flow_instance_event_log.lgpr_comment%type default null
  );

procedure handle_event_gateway_event
  ( p_process_id         in flow_processes.prcs_id%type
  , p_parent_subflow_id  in flow_subflows.sbfl_id%type
  , p_cleared_subflow_id in flow_subflows.sbfl_id%type
  );
  
end flow_engine;
/

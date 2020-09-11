create or replace package flow_engine
-- accessible by flow_api_pkg
as 

type flow_step_info is record
( dgrm_id           flow_diagrams.dgrm_id%type
, source_objt_type  flow_objects.objt_type%type
, source_objt_tag   flow_objects.objt_tag_name%type
, target_objt_id    flow_objects.objt_id%type
, target_objt_ref   flow_objects.objt_bpmn_id%type
, target_objt_type  flow_objects.objt_type%type
, target_objt_tag   flow_objects.objt_tag_name%type
, target_objt_subtag flow_objects.objt_sub_tag_name%type
);

procedure process_task  
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_endEvent
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_parallelGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_inclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_exclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_subProcess
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_eventBasedGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_intermediateCatchEvent
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_userTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_scriptTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_sendTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure process_manualTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  );

procedure flow_handle_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

procedure flow_start_process
    ( p_process_id    in flow_processes.prcs_id%type
    );

function subflow_start  -- remove before shipping - should be private to engine
  ( 
    p_process_id      in flow_processes.prcs_id%type
  , p_parent_subflow  in flow_subflows.sbfl_id%type
  , p_starting_object in flow_objects.objt_bpmn_id%type
  , p_current_object  in flow_objects.objt_bpmn_id%type
  , p_route           in flow_subflows.sbfl_route%type
  , p_last_completed  in flow_objects.objt_bpmn_id%type
  , p_status       in flow_subflows.sbfl_status%type default 'running'
  ) return flow_subflows.sbfl_id%type;

procedure flow_next_step
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_forward_route in flow_diagrams.dgrm_id%type default null
);

end flow_engine;
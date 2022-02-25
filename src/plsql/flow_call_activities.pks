/* 
-- Flows for APEX - flow_call_activities.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 19-Feb-2022   Richard Allen - Create 
--
*/
create or replace package flow_call_activities 
as

  procedure process_call_activity_endEvent
    ( p_process_id        in flow_processes.prcs_id%type
    , p_subflow_id        in flow_subflows.sbfl_id%type
    , p_sbfl_info         in flow_subflows%rowtype
    , p_step_info         in flow_types_pkg.flow_step_info
    , p_sbfl_context_par  in flow_types_pkg.t_subflow_context
    );

  procedure process_callActivity
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    );

  function is_called_activity
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type  
    ) return boolean;

end flow_call_activities;
/
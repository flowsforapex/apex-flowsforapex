/* 
-- Flows for APEX - flow_subprocesses.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 22-Feb-2022   Richard Allen - Refactor SubProcess code from flow_engine
--
*/
create or replace package flow_subprocesses
as

  procedure process_subprocess_endEvent
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    , p_sbfl_context_par  in flow_types_pkg.t_subflow_context
    );

  procedure process_subProcess
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    );

end flow_subprocesses;
/

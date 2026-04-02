create or replace package flow_adhoc_subprocesses_core
as
/* 
-- Flows for APEX Enterprise Edition - flow_adhoc_subprocesses_core.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2025-2026.
--
-- Created    02-Apr-2026  GitHub Copilot
--
*/

  function adhoc_completion_condition_met
    ( p_process_id            in flow_processes.prcs_id%type
    , p_adhoc_subproc_bpmn_id in flow_objects.objt_bpmn_id%type
    , p_adhoc_subproc_dgrm_id in flow_subflows.sbfl_dgrm_id%type
    , p_scope                 in flow_subflows.sbfl_scope%type
    )
    return boolean;

  function get_adhoc_activity_run_count
    ( p_process_id           in flow_processes.prcs_id%type
    , p_parent_subflow_id    in flow_subflows.sbfl_id%type
    , p_parent_step_key      in flow_subflows.sbfl_step_key%type
    , p_objt_bpmn_id         in flow_objects.objt_bpmn_id%type
    , p_is_repeatable        in varchar2
    )
    return number;

  function activity_start_condition_met
    ( p_process_id            in flow_processes.prcs_id%type
    , p_start_condition       in varchar2
    , p_scope                 in flow_subflows.sbfl_scope%type
    )
    return boolean;

  function activity_start_condition_met_YN
    ( p_process_id                  in flow_processes.prcs_id%type
    , p_activity_start_condition    in varchar2
    , p_scope                       in flow_subflows.sbfl_scope%type
    )
    return varchar2;

  procedure start_starting_adhoc_activities
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    );

end flow_adhoc_subprocesses_core;
/
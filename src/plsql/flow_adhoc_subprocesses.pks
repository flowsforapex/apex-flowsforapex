create or replace package flow_adhoc_subprocesses
as
/* 
-- Flows for APEX Enterprise Edition - flow_adhoc_subprocesses.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2025-2026.
--
-- Created    10-Nov-2025  Richard Allen (Flowquest)
--
*/

  procedure start_adhoc_SubProcess
    ( p_sbfl_info            in flow_subflows%rowtype
    , p_step_info            in flow_types_pkg.flow_step_info
    );

  procedure start_adhoc_activity
    ( p_process_id                  in flow_processes.prcs_id%type
    , p_parent_subflow_id           in flow_subflows.sbfl_id%type
    , p_objt_bpmn_id                in flow_objects.objt_bpmn_id%type
    , p_user_input_parameters       in clob default null
    , p_ai_decision_id              in flow_adhoc_subproc_ai_decisions.asad_id%type default null
    );

  procedure end_adhoc_activity
    ( p_sbfl_rec             in flow_subflows%rowtype
    );

  procedure complete_adhoc_SubProcess
    ( p_process_id           in flow_processes.prcs_id%type
    , p_subproc_sbfl_id      in flow_subflows.sbfl_id%type
    );

  function activity_start_condition_met_YN
    ( p_process_id                in flow_processes.prcs_id%type
    , p_activity_start_condition  in varchar2
    , p_scope                     in flow_subflows.sbfl_scope%type default 0
    )
    return varchar2;

  -- Manual AI control API
  procedure request_ai_decision
    ( p_process_id  in flow_processes.prcs_id%type
    , p_subflow_id  in flow_subflows.sbfl_id%type
    , p_step_key    in flow_subflows.sbfl_step_key%type
    , p_comment     in varchar2 default 'Manual UI Request'
    );

  -- AI scheduling information API
  procedure get_ai_schedule_info
    ( p_process_id           in flow_processes.prcs_id%type
    , p_subflow_id           in flow_subflows.sbfl_id%type
    , p_step_key             in flow_subflows.sbfl_step_key%type
    , p_next_check_time      out timestamp with time zone
    , p_check_reason         out varchar2
    );

  -- Process any autonomous or hybrid AI checks that are due for the process.
  procedure process_due_ai_checks
    ( p_process_id           in flow_processes.prcs_id%type
    );

  -- Demo/Production mode utilities
  function get_effective_timestamp
    ( p_prcs_id in flow_processes.prcs_id%type
    , p_offset_hours in number default 0
    )
    return timestamp with time zone;

end flow_adhoc_subprocesses;
/
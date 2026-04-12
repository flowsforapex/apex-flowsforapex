create or replace package flow_adhoc_subprocesses_ai
as
/* 
-- Flows for APEX Enterprise Edition - flow_adhoc_subprocesses_ai.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2025-2026.
--
-- Created    02-Apr-2026  GitHub Copilot
--
*/

  procedure request_ai_decision
    ( p_process_id  in flow_processes.prcs_id%type
    , p_subflow_id  in flow_subflows.sbfl_id%type
    , p_step_key    in flow_subflows.sbfl_step_key%type
    , p_comment     in varchar2 default 'Manual UI Request'
    );

  procedure get_ai_schedule_info
    ( p_process_id           in flow_processes.prcs_id%type
    , p_subflow_id           in flow_subflows.sbfl_id%type
    , p_step_key             in flow_subflows.sbfl_step_key%type
    , p_next_check_time      out timestamp with time zone
    , p_check_reason         out varchar2
    );

  procedure process_due_ai_checks
    ( p_process_id           in flow_processes.prcs_id%type
    );

  procedure invoke_ai_control
    ( p_ahsp_id              in flow_adhoc_subprocs.ahsp_id%type
    , p_trigger_type         in varchar2 default 'activity_completed'
    , p_scope                in flow_subflows.sbfl_scope%type default 0
    );

  -- Recommendation mode approval API
  procedure approve_ai_recommendation
    ( p_process_id       in flow_processes.prcs_id%type
    , p_subflow_id       in flow_subflows.sbfl_id%type
    , p_step_key         in flow_subflows.sbfl_step_key%type
    , p_asad_id          in flow_adhoc_subproc_ai_decisions.asad_id%type
    , p_activity_bpmn_id in flow_objects.objt_bpmn_id%type
    );

  procedure discard_ai_recommendation
    ( p_process_id       in flow_processes.prcs_id%type
    , p_subflow_id       in flow_subflows.sbfl_id%type
    , p_step_key         in flow_subflows.sbfl_step_key%type
    , p_asad_id          in flow_adhoc_subproc_ai_decisions.asad_id%type
    );

end flow_adhoc_subprocesses_ai;
/
create or replace package flow_adhoc_subprocesses
as
/* 
-- Flows for APEX Enterprise Edition - flow_adhoc_subprocesses.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2025.
--
-- Created    10-Nov-2025  Richard Allen (Flowquest)
--
*/

  procedure start_adhoc_SubProcess
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    );

  procedure start_adhoc_activity
    ( p_process_id           in flow_processes.prcs_id%type
    , p_parent_subflow_id    in flow_subflows.sbfl_id%type
    , p_objt_bpmn_id     in flow_objects.objt_bpmn_id%type
    );

end flow_adhoc_subprocesses;
/
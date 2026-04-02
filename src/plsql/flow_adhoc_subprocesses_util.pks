create or replace package flow_adhoc_subprocesses_util
as
/* 
-- Flows for APEX Enterprise Edition - flow_adhoc_subprocesses_util.pks
--
-- (c) Copyright Flowquest Limited and/or its associates, 2025-2026.
--
-- Created    02-Apr-2026  GitHub Copilot
--
*/

  function get_new_adhoc_process_level
    return number;

  function get_adhoc_subprocess_task_list_visibility
    ( p_subproc_attributes   in flow_objects.objt_attributes%type
    )
    return varchar2;

  procedure extract_ahsp_configuration
    ( p_apex_extension       in sys.json_object_t
    , p_custom_extension     in sys.json_object_t default null
    , p_control             out varchar2
    , p_interval_minutes    out number
    , p_max_iterations      out number
    , p_task_visibility     out varchar2
    , p_turns_per_session   out number
    , p_max_total_turns     out number
    );

  function get_operating_mode
    ( p_prcs_id in flow_processes.prcs_id%type
    )
    return varchar2;

  function get_effective_timestamp
    ( p_prcs_id in flow_processes.prcs_id%type
    , p_offset_hours in number default 0
    )
    return timestamp with time zone;

end flow_adhoc_subprocesses_util;
/

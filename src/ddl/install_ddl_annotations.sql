/*
-- Flows for APEX - install_ddl_annotations.sql
--
-- Schema annotations for all Flows for APEX tables.
-- Requires Oracle 19.28+ or Oracle 23ai / 26ai.
--
-- (c) Copyright Flowquest Consulting Limited. 2026.
--
-- Created  31-May-2026  Richard Allen, Flowquest Consulting
--
-- Annotation keys used:
--   Table annotations:
--     app     : 'Flows for APEX'
--     type    : definition | runtime | logging | statistics | configuration
--     content : brief description of the table purpose
--     note    : important caveats (used sparingly)
--   Column annotations:
--     content : brief description of the column purpose
--
-- Migration note:
--   This script uses ADD throughout (annotations must not pre-exist).
--   It is safe to run on:
--     - a fresh installation (install_db_scratch.sql)
--     - the 26.1 migration of a pre-annotations database
--   For subsequent migrations: add new column annotations with ADD,
--   update existing annotation values with REPLACE (not ADD OR REPLACE
--   which is currently broken - ORA-11548).
*/

-- ===========================================================================
-- Version Check: Requires Oracle 19.28+ or Oracle 23ai+
-- ===========================================================================
spool install_ddl_annotations.log

whenever sqlerror exit failure

declare
  l_major  pls_integer := dbms_db_version.version;
  l_ru     pls_integer := 0;
begin
  if l_major < 19 then
    raise_application_error( -20000
                           , 'Schema annotations require Oracle 19.28+ or 23ai. Found major version: '
                             || l_major );
  elsif l_major = 19 then
    -- BANNER_FULL (added 18c) contains e.g. '...Production Version 19.31.0.1.0'
    -- Use capture group to extract RU (2nd component after 'Version X.')
    -- v$version used instead of v$instance for ADB/Autonomous compatibility
    select to_number( regexp_substr( banner_full, 'Version \d+\.(\d+)', 1, 1, 'i', 2 ) )
      into l_ru
      from v$version
     where banner like 'Oracle Database%'
       and rownum = 1;
    if l_ru < 28 then
      raise_application_error( -20000
                             , 'Schema annotations require Oracle 19.28+. Found - 19.'
                               || l_ru );
    end if;
  end if;
  dbms_output.put_line( 'Version check OK - Oracle ' || l_major
    || case when l_major = 19 then ' RU' || l_ru end );
end;
/

-- Continue past annotation errors (e.g. safe re-run after partial apply)
whenever sqlerror continue


-- ===========================================================================
-- DEFINITION TABLES
-- Parsed BPMN process model data (created when a diagram is saved/released)
-- ===========================================================================

alter table flow_diagrams annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Process definitions and their BPMN XML diagrams'
  );

alter table flow_diagrams modify dgrm_id             annotations (add content 'Unique numeric ID for this diagram');
alter table flow_diagrams modify dgrm_name           annotations (add content 'Business process name; often the name of the process being modelled');
alter table flow_diagrams modify dgrm_version        annotations (add content 'Version string for this diagram');
alter table flow_diagrams modify dgrm_status         annotations (add content 'Lifecycle status - draft, released, deprecated, archived');
alter table flow_diagrams modify dgrm_category       annotations (add content 'Optional category for grouping diagrams');
alter table flow_diagrams modify dgrm_last_update    annotations (add content 'Timestamp of most recent diagram change');
alter table flow_diagrams modify dgrm_content        annotations (add content 'BPMN XML content of the process diagram (CLOB)');
alter table flow_diagrams modify dgrm_short_description annotations (add content 'Brief description of the process');
alter table flow_diagrams modify dgrm_description    annotations (add content 'Detailed description of the process');
alter table flow_diagrams modify dgrm_icon           annotations (add content 'Icon identifier for use in APEX applications');

alter table flow_objects annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Parsed BPMN objects from process definitions'
  );

alter table flow_objects modify objt_id            annotations (add content 'System-generated unique ID; changes on re-parse');
alter table flow_objects modify objt_bpmn_id       annotations (add content 'BPMN identifier from the diagram XML');
alter table flow_objects modify objt_dgrm_id       annotations (add content 'Diagram containing this object (FK - flow_diagrams)');
alter table flow_objects modify objt_name          annotations (add content 'Display name of the BPMN object');
alter table flow_objects modify objt_tag_name      annotations (add content 'BPMN XML element type tag name, e.g. task, startEvent, subProcess');
alter table flow_objects modify objt_sub_tag_name  annotations (add content 'BPMN element sub-type, e.g. terminateEventDefinition');
alter table flow_objects modify objt_objt_id       annotations (add content 'Parent container object (FK - flow_objects)');
alter table flow_objects modify objt_objt_lane_id  annotations (add content 'Lane this object belongs to (FK - flow_objects)');
alter table flow_objects modify objt_attached_to   annotations (add content 'BPMN ID of parent object for boundary events');
alter table flow_objects modify objt_interrupting  annotations (add content 'For boundary events - 1 = interrupting, 0 = non-interrupting');
alter table flow_objects modify objt_attributes    annotations (add content 'Additional object attributes as JSON');

alter table flow_connections annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Parsed BPMN connections between process objects'
  );

alter table flow_connections modify conn_id          annotations (add content 'System-generated unique ID; changes on re-parse');
alter table flow_connections modify conn_bpmn_id     annotations (add content 'BPMN identifier from the diagram XML');
alter table flow_connections modify conn_dgrm_id     annotations (add content 'Diagram containing this connection (FK - flow_diagrams)');
alter table flow_connections modify conn_name        annotations (add content 'Display name of the connection');
alter table flow_connections modify conn_src_objt_id annotations (add content 'Source object (FK - flow_objects)');
alter table flow_connections modify conn_tgt_objt_id annotations (add content 'Target object (FK - flow_objects)');
alter table flow_connections modify conn_tag_name    annotations (add content 'BPMN XML connection type tag name, e.g. sequenceFlow, messageFlow');
alter table flow_connections modify conn_origin      annotations (add content 'Whether the source object is in a PROCESS or SUBPROCESS');
alter table flow_connections modify conn_is_default  annotations (add content '1 if this is the default path from the source object');
alter table flow_connections modify conn_sequence    annotations (add content 'Evaluation order when multiple connections leave a source object');
alter table flow_connections modify conn_attributes  annotations (add content 'Additional connection attributes as JSON');

alter table flow_object_expressions annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Variable expressions attached to BPMN objects for data mapping'
  );

alter table flow_object_expressions modify expr_id          annotations (add content 'Unique ID for this expression; changes on re-parse');
alter table flow_object_expressions modify expr_objt_id     annotations (add content 'Object this expression belongs to (FK - flow_objects)');
alter table flow_object_expressions modify expr_set         annotations (add content 'When this expression fires - beforeTask, afterTask, onEvent, beforeSplit, afterMerge, inVariables, outVariables');
alter table flow_object_expressions modify expr_order       annotations (add content 'Execution order within the expression set');
alter table flow_object_expressions modify expr_var_name    annotations (add content 'Process variable name to set or read');
alter table flow_object_expressions modify expr_var_type    annotations (add content 'Variable type - VARCHAR2, NUMBER, DATE, TSTZ, CLOB, JSON');
alter table flow_object_expressions modify expr_type        annotations (add content 'Expression type - static value, SQL query, PL/SQL function, etc.');
alter table flow_object_expressions modify expr_expression  annotations (add content 'The expression body');
alter table flow_object_expressions modify expr_source_type annotations (add content 'Source type for inVariables and outVariables expressions');
alter table flow_object_expressions modify expr_source      annotations (add content 'Source name for inVariables and outVariables expressions');


-- ===========================================================================
-- RUNTIME TABLES
-- Live process execution state (exists while a process instance is active)
-- ===========================================================================

alter table flow_processes annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Live state of process instances'
  );

alter table flow_processes modify prcs_id              annotations (add content 'Unique numeric ID for this process instance');
alter table flow_processes modify prcs_dgrm_id         annotations (add content 'Diagram this instance runs (FK - flow_diagrams)');
alter table flow_processes modify prcs_name            annotations (add content 'Business name of this process instance');
alter table flow_processes modify prcs_process_bpmn_id annotations (add content 'BPMN ID of the top-level process element');
alter table flow_processes modify prcs_status          annotations (add content 'Current status - created, running, completed, terminated, error');
alter table flow_processes modify prcs_init_ts         annotations (add content 'Timestamp when the instance was initialised');
alter table flow_processes modify prcs_init_by         annotations (add content 'User who initialised the instance');
alter table flow_processes modify prcs_start_ts        annotations (add content 'Timestamp when instance was started; resets on reset');
alter table flow_processes modify prcs_complete_ts     annotations (add content 'Timestamp when instance completed or was terminated');
alter table flow_processes modify prcs_due_on          annotations (add content 'Optional due date/time for the process instance');
alter table flow_processes modify prcs_archived_ts     annotations (add content 'Timestamp when instance was archived');
alter table flow_processes modify prcs_priority        annotations (add content 'Priority of this instance (user-defined numeric value)');
alter table flow_processes modify prcs_logging_level   annotations (add content 'Logging verbosity level 0-8');
alter table flow_processes modify prcs_was_altered     annotations (add content 'Y if instance has been altered from normal flow');
alter table flow_processes modify prcs_last_update     annotations (add content 'Timestamp of most recent change to this instance');
alter table flow_processes modify prcs_last_update_by  annotations (add content 'User who made the most recent change');

alter table flow_subflows annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Live state of subflows within running process instances'
  , add note    'Subflows represent active process scopes, including the main process and any active call activities or subprocesses.  Subflows are deleted when their active scope ends, but completed steps within subflows are retained in flow_subflow_log for historical reporting.'
  );

alter table flow_subflows modify sbfl_id                     annotations (add content 'Unique ID for this subflow');
alter table flow_subflows modify sbfl_prcs_id                annotations (add content 'Parent process instance (FK - flow_processes)');
alter table flow_subflows modify sbfl_dgrm_id                annotations (add content 'Diagram this subflow is running in (FK - flow_diagrams)');
alter table flow_subflows modify sbfl_sbfl_id                annotations (add content 'Parent subflow (FK - flow_subflows)');
alter table flow_subflows modify sbfl_process_level          annotations (add content 'Nesting level from main process - = 0 for main process, = sbfl_id of first subflow in each process level for subsequent levels');
alter table flow_subflows modify sbfl_diagram_level          annotations (add content 'Diagram level - = 0 for main process, = sbfl_id of first subflow in each diagram level for subsequent levels');
alter table flow_subflows modify sbfl_calling_sbfl           annotations (add content 'Subflow that called this one (used by Call Activities)');
alter table flow_subflows modify sbfl_scope                  annotations (add content 'Scope ID used for process variable scoping');
alter table flow_subflows modify sbfl_starting_object        annotations (add content 'BPMN ID of the object where this subflow started');
alter table flow_subflows modify sbfl_route                  annotations (add content 'Route identifier for this subflow');
alter table flow_subflows modify sbfl_last_completed         annotations (add content 'BPMN ID of the last completed object');
alter table flow_subflows modify sbfl_current                annotations (add content 'BPMN ID of the current object where this subflow is waiting');
alter table flow_subflows modify sbfl_step_key               annotations (add content 'Unique step key for optimistic concurrency control - can act as UK for current step');
alter table flow_subflows modify sbfl_is_adhoc               annotations (add content 'Y if this subflow is immediately inside an adhoc subprocess');
alter table flow_subflows modify sbfl_ahsp_id                annotations (add content 'Adhoc subprocess ID if current object is an adhoc subprocess (FK - flow_adhoc_subprocs)');
alter table flow_subflows modify sbfl_hide_in_task_list      annotations (add content 'Y if the current step should not appear in APEX task lists');
alter table flow_subflows modify sbfl_due_on                 annotations (add content 'Due date/time for the current step');
alter table flow_subflows modify sbfl_priority               annotations (add content 'TaskPriority for the current step (1 = highest priority, 5 = lowest priority)');
alter table flow_subflows modify sbfl_status                 annotations (add content 'Current status - running, waiting, split, complete, error, etc.');
alter table flow_subflows modify sbfl_became_current         annotations (add content 'Timestamp when subflow arrived at current object');
alter table flow_subflows modify sbfl_work_started           annotations (add content 'Timestamp when work on current step began');
alter table flow_subflows modify sbfl_has_events             annotations (add content 'Comma-separated list of boundary event types currently active on this step');
alter table flow_subflows modify sbfl_is_following_ebg       annotations (add content 'Y if current step is immediately following an event-based gateway');
alter table flow_subflows modify sbfl_lane                   annotations (add content 'BPMN ID of the lane containing the current step');
alter table flow_subflows modify sbfl_lane_name              annotations (add content 'Name of lane containing current step (denormalised; required for Call Activities)');
alter table flow_subflows modify sbfl_lane_isRole            annotations (add content 'Whether the lane is role-based (denormalised; required for Call Activities)');
alter table flow_subflows modify sbfl_lane_role              annotations (add content 'Role name for the lane (denormalised; required for Call Activities)');
alter table flow_subflows modify sbfl_reservation            annotations (add content 'Username who has reserved the current task');
alter table flow_subflows modify sbfl_potential_users        annotations (add content 'Users eligible to work the current task');
alter table flow_subflows modify sbfl_potential_groups       annotations (add content 'Groups eligible to work the current task');
alter table flow_subflows modify sbfl_excluded_users         annotations (add content 'Users excluded from working the current task');
alter table flow_subflows modify sbfl_apex_task_id           annotations (add content 'APEX task ID if current step uses an APEX human task');
alter table flow_subflows modify sbfl_apex_business_admin    annotations (add content 'APEX business administrator for the current task');
alter table flow_subflows modify sbfl_iteration_type         annotations (add content 'Type of iteration - sequential, parallel, loop');
alter table flow_subflows modify sbfl_iobj_id                annotations (add content 'FK to flow_iterated_objects if subflow is executing an iteration');
alter table flow_subflows modify sbfl_iter_id                annotations (add content 'FK to flow_iterations for the current iteration');
alter table flow_subflows modify sbfl_iteration_var          annotations (add content 'Process variable holding iteration array (deprecated; use flow_iterated_objects)');
alter table flow_subflows modify sbfl_iteration_var_scope    annotations (add content 'Scope of iteration variable (deprecated; use flow_iterated_objects)');
alter table flow_subflows modify sbfl_loop_counter           annotations (add content 'Current loop count for loop objects');
alter table flow_subflows modify sbfl_loop_total_instances   annotations (add content 'Total instances declared for multi-instance objects');
alter table flow_subflows modify sbfl_task_input_parameters  annotations (add content 'Input parameter bindings for current task as JSON');
alter table flow_subflows modify sbfl_task_output_parameters annotations (add content 'Output parameter bindings for current task as JSON');
alter table flow_subflows modify sbfl_last_update            annotations (add content 'Timestamp of most recent change to this subflow');
alter table flow_subflows modify sbfl_last_update_by         annotations (add content 'User who made the most recent change');

alter table flow_process_variables annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process variables set on running process instances'
  );

alter table flow_process_variables modify prov_prcs_id     annotations (add content 'Process instance owning this variable (FK - flow_processes)');
alter table flow_process_variables modify prov_scope       annotations (add content 'Scope ID determining variable visibility across call activities');
alter table flow_process_variables modify prov_var_name    annotations (add content 'Variable name (case-insensitive; stored as supplied)');
alter table flow_process_variables modify prov_var_type    annotations (add content 'Variable type - VARCHAR2, NUMBER, DATE, TSTZ, CLOB, JSON');
alter table flow_process_variables modify prov_var_vc2     annotations (add content 'Value storage for VARCHAR2-typed variables');
alter table flow_process_variables modify prov_var_num     annotations (add content 'Value storage for NUMBER-typed variables');
alter table flow_process_variables modify prov_var_date    annotations (add content 'Value storage for DATE-typed variables');
alter table flow_process_variables modify prov_var_tstz    annotations (add content 'Value storage for TIMESTAMP WITH TIME ZONE-typed variables');
alter table flow_process_variables modify prov_var_clob    annotations (add content 'Value storage for CLOB-typed variables');
alter table flow_process_variables modify prov_var_json    annotations (add content 'Value storage for JSON-typed variables');
alter table flow_process_variables modify prov_var_name_uc annotations (add content 'Upper-cased variable name (virtual column; used in primary key for case-insensitive lookup)');

alter table flow_subflow_log annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Completed steps within running process instances'
  , add note    'Persists for the life of the instance; purged on archive or delete'
  );

alter table flow_subflow_log modify sflg_prcs_id         annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_subflow_log modify sflg_objt_id         annotations (add content 'BPMN ID of the completed object');
alter table flow_subflow_log modify sflg_sbfl_id         annotations (add content 'Subflow that completed this step');
alter table flow_subflow_log modify sflg_step_key        annotations (add content 'Step key at time of completion');
alter table flow_subflow_log modify sflg_dgrm_id         annotations (add content 'Diagram ID for this step');
alter table flow_subflow_log modify sflg_scope           annotations (add content 'Scope ID at time of completion');
alter table flow_subflow_log modify sflg_diagram_level   annotations (add content 'Diagram level at time of completion');
alter table flow_subflow_log modify sflg_iter_id         annotations (add content 'Iteration ID if step was part of an iteration (FK - flow_iterations)');
alter table flow_subflow_log modify sflg_last_updated    annotations (add content 'Date of last update to this log entry');
alter table flow_subflow_log modify sflg_matching_object annotations (add content 'BPMN ID of matched object; used at joining gateways and link events');
alter table flow_subflow_log modify sflg_notes           annotations (add content 'Optional notes for this log entry');

alter table flow_instance_diagrams annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Diagrams used by running process instances; tracks Call Activity nesting'
  , add note    'Created at Instance CREATION and updated on call activity entry. This creates a fixed nesting structure for the instance BEFORE any execution begins, and prevents dynamic call activity paths.'
  );

alter table flow_instance_diagrams modify prdg_id            annotations (add content 'Unique ID for this diagram usage');
alter table flow_instance_diagrams modify prdg_prdg_id       annotations (add content 'Parent diagram usage (FK - flow_instance_diagrams)');
alter table flow_instance_diagrams modify prdg_prcs_id       annotations (add content 'Process instance using this diagram (FK - flow_processes)');
alter table flow_instance_diagrams modify prdg_dgrm_id       annotations (add content 'Diagram being used (FK - flow_diagrams)');
alter table flow_instance_diagrams modify prdg_calling_dgrm  annotations (add content 'Diagram that called this one via a Call Activity (FK - flow_diagrams)');
alter table flow_instance_diagrams modify prdg_calling_objt  annotations (add content 'BPMN ID of the Call Activity object that invoked this diagram');
alter table flow_instance_diagrams modify prdg_diagram_level annotations (add content 'Diagram level assigned to this usage; equals sbfl_id of the first subflow from this diagram');

alter table flow_timers annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active timers set on running process instances'
  );

alter table flow_timers modify timr_id           annotations (add content 'Unique ID for this timer');
alter table flow_timers modify timr_run          annotations (add content 'Run counter for repeating timers');
alter table flow_timers modify timr_prcs_id      annotations (add content 'Process instance owning this timer (FK - flow_processes)');
alter table flow_timers modify timr_sbfl_id      annotations (add content 'Subflow associated with this timer (FK - flow_subflows)');
alter table flow_timers modify timr_step_key     annotations (add content 'Step key when timer was created');
alter table flow_timers modify timr_type         annotations (add content 'Timer type - timerDate, timerDuration, timerCycle');
alter table flow_timers modify timr_last_run     annotations (add content 'Timestamp of most recent timer firing');
alter table flow_timers modify timr_created_on   annotations (add content 'Timestamp when timer was created');
alter table flow_timers modify timr_status       annotations (add content 'Timer status - S=scheduled, C=completed, R=running');
alter table flow_timers modify timr_start_on     annotations (add content 'Scheduled start timestamp');
alter table flow_timers modify timr_interval_ym  annotations (add content 'Repeat interval, year-to-month component');
alter table flow_timers modify timr_interval_ds  annotations (add content 'Repeat interval, day-to-second component');
alter table flow_timers modify timr_repeat_times annotations (add content 'Remaining repeats; -1 for infinite');
alter table flow_timers modify timr_callback     annotations (add content 'Procedure to call when timer fires');
alter table flow_timers modify timr_callback_par annotations (add content 'Parameter to pass to the callback procedure');

alter table flow_message_subscriptions annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions for process collaboration and BPMN messageFlow'
  );

alter table flow_message_subscriptions modify msub_id           annotations (add content 'Unique ID for this message subscription');
alter table flow_message_subscriptions modify msub_message_name annotations (add content 'Message name to match on incoming messages');
alter table flow_message_subscriptions modify msub_key_name     annotations (add content 'Correlation key name to match on incoming messages');
alter table flow_message_subscriptions modify msub_key_value    annotations (add content 'Correlation key value to match on incoming messages');
alter table flow_message_subscriptions modify msub_prcs_id      annotations (add content 'Process instance to notify on message receipt (FK - flow_processes)');
alter table flow_message_subscriptions modify msub_sbfl_id      annotations (add content 'Subflow to notify on message receipt (FK - flow_subflows)');
alter table flow_message_subscriptions modify msub_step_key     annotations (add content 'Step key at time of subscription');
alter table flow_message_subscriptions modify msub_dgrm_id      annotations (add content 'Diagram to use for message start events (FK - flow_diagrams)');
alter table flow_message_subscriptions modify msub_callback     annotations (add content 'Callback procedure for received messages');
alter table flow_message_subscriptions modify msub_callback_par annotations (add content 'Parameter to pass to the callback procedure');
alter table flow_message_subscriptions modify msub_payload_var  annotations (add content 'Process variable to receive the message payload');
alter table flow_message_subscriptions modify msub_created      annotations (add content 'Timestamp when subscription was created');

alter table flow_iterated_objects annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Objects being iterated or looped within running process instances'
  );

alter table flow_iterated_objects modify iobj_id             annotations (add content 'Unique ID for this iterated object');
alter table flow_iterated_objects modify iobj_prcs_id        annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_iterated_objects modify iobj_diagram_level  annotations (add content 'Diagram level of the iterated object');
alter table flow_iterated_objects modify iobj_dgrm_id        annotations (add content 'Diagram containing the iterated object (FK - flow_diagrams)');
alter table flow_iterated_objects modify iobj_parent_bpmn_id annotations (add content 'BPMN ID of the object being iterated or looped');
alter table flow_iterated_objects modify iobj_step_key       annotations (add content 'Step key of the parent object for this iteration');
alter table flow_iterated_objects modify iobj_iteration_var  annotations (add content 'Process variable holding the iteration collection as JSON');
alter table flow_iterated_objects modify iobj_var_scope      annotations (add content 'Scope of the iteration variable');
alter table flow_iterated_objects modify iobj_objt_type      annotations (add content 'Type of the iterated BPMN object');
alter table flow_iterated_objects modify iobj_iteration_type annotations (add content 'Iteration type - sequential, parallel, loop');
alter table flow_iterated_objects modify iobj_parent_iter_id annotations (add content 'Parent iteration for nested iterations (FK - flow_iterations)');
alter table flow_iterated_objects modify iobj_display_name   annotations (add content 'Display name for this iterated object in APEX UI');

alter table flow_iterations annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Individual iteration instances within an iterated object'
  );

alter table flow_iterations modify iter_id           annotations (add content 'Unique ID for this iteration');
alter table flow_iterations modify iter_prcs_id      annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_iterations modify iter_iobj_id      annotations (add content 'Iterated object this iteration belongs to (FK - flow_iterated_objects)');
alter table flow_iterations modify iter_loop_counter annotations (add content 'Loop count for this iteration (1-based)');
alter table flow_iterations modify iter_sbfl_id      annotations (add content 'Subflow executing this iteration (FK - flow_subflows)');
alter table flow_iterations modify iter_scope        annotations (add content 'Scope ID for this iteration');
alter table flow_iterations modify iter_step_key     annotations (add content 'Step key for this iteration');
alter table flow_iterations modify iter_status       annotations (add content 'Status - running, completed, terminated');
alter table flow_iterations modify iter_description  annotations (add content 'Description of this iteration');
alter table flow_iterations modify iter_display_name annotations (add content 'Display name for this iteration in APEX UI');
alter table flow_iterations modify iter_inputs       annotations (add content 'Input variable bindings for this iteration as JSON');
alter table flow_iterations modify iter_outputs      annotations (add content 'Output variable bindings for this iteration as JSON');

alter table flow_adhoc_subprocs annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Adhoc subprocesses active within running process instances'
  );

alter table flow_adhoc_subprocs modify ahsp_id                     annotations (add content 'Unique ID for this adhoc subprocess');
alter table flow_adhoc_subprocs modify ahsp_prcs_id                annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_adhoc_subprocs modify ahsp_sbfl_id                annotations (add content 'Subflow executing this adhoc subprocess (FK - flow_subflows)');
alter table flow_adhoc_subprocs modify ahsp_dgrm_id                annotations (add content 'Diagram containing this adhoc subprocess (FK - flow_diagrams)');
alter table flow_adhoc_subprocs modify ahsp_bpmn_id                annotations (add content 'BPMN ID of the adhoc subprocess object');
alter table flow_adhoc_subprocs modify ahsp_step_key               annotations (add content 'Step key of the adhoc subprocess');
alter table flow_adhoc_subprocs modify ahsp_process_level          annotations (add content 'Process level of this adhoc subprocess');
alter table flow_adhoc_subprocs modify ahsp_control                annotations (add content 'Control mode - manual, ai, recommendation, or hybrid');
alter table flow_adhoc_subprocs modify ahsp_last_ai_check          annotations (add content 'Timestamp of most recent AI management check');
alter table flow_adhoc_subprocs modify ahsp_check_interval_minutes annotations (add content 'Minutes between AI management checks');
alter table flow_adhoc_subprocs modify ahsp_iteration_count        annotations (add content 'Number of AI check iterations performed');
alter table flow_adhoc_subprocs modify ahsp_status                 annotations (add content 'Current status of this adhoc subprocess');
alter table flow_adhoc_subprocs modify ahsp_next_recommended_check annotations (add content 'AI-recommended timestamp for next management check');
alter table flow_adhoc_subprocs modify ahsp_next_check_reason      annotations (add content 'AI explanation for the recommended next check timing');
alter table flow_adhoc_subprocs modify ahsp_turns_per_session      annotations (add content 'Maximum AI turns allowed per management check session');
alter table flow_adhoc_subprocs modify ahsp_max_total_turns        annotations (add content 'Maximum total AI turns allowed for this subprocess lifecycle');

alter table flow_adhoc_subflows annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Subflows belonging to active adhoc subprocesses'
  );

alter table flow_adhoc_subflows modify ahsf_sbfl_id           annotations (add content 'Subflow executing this adhoc subflow (FK - flow_subflows)');
alter table flow_adhoc_subflows modify ahsf_ahsp_id           annotations (add content 'Parent adhoc subprocess (FK - flow_adhoc_subprocs)');
alter table flow_adhoc_subflows modify ahsf_starting_object   annotations (add content 'BPMN ID of the object where this adhoc subflow started');
alter table flow_adhoc_subflows modify ahsf_starting_step_key annotations (add content 'Step key of the object where this adhoc subflow started');
alter table flow_adhoc_subflows modify ahsf_repeat_count      annotations (add content 'Number of times this starting object has been executed');
alter table flow_adhoc_subflows modify ahsf_status            annotations (add content 'Current status of this adhoc subflow');
alter table flow_adhoc_subflows modify ahsf_start_time        annotations (add content 'Timestamp when this adhoc subflow started');
alter table flow_adhoc_subflows modify ahsf_complete_time     annotations (add content 'Timestamp when this adhoc subflow completed');
alter table flow_adhoc_subflows modify ahsf_inputs            annotations (add content 'Input variable bindings as JSON');
alter table flow_adhoc_subflows modify ahsf_outputs           annotations (add content 'Output variable bindings as JSON');

alter table flow_adhoc_subproc_ai_decisions annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'AI decisions and reasoning records for autonomous adhoc subprocess management'
  );

alter table flow_adhoc_subproc_ai_decisions modify asad_id         annotations (add content 'Unique ID for this AI decision record');
alter table flow_adhoc_subproc_ai_decisions modify asad_ahsp_id    annotations (add content 'Adhoc subprocess being managed (FK - flow_adhoc_subprocs)');
alter table flow_adhoc_subproc_ai_decisions modify asad_turn       annotations (add content 'Turn number within this AI management session');
alter table flow_adhoc_subproc_ai_decisions modify asad_rationale  annotations (add content 'AI reasoning for the decision made');
alter table flow_adhoc_subproc_ai_decisions modify asad_actions    annotations (add content 'JSON array of actions recommended by the AI');
alter table flow_adhoc_subproc_ai_decisions modify asad_timestamp  annotations (add content 'Timestamp when the AI decision was recorded');
alter table flow_adhoc_subproc_ai_decisions modify asad_created_by annotations (add content 'User or system that triggered this AI decision');


-- ===========================================================================
-- LOGGING TABLES
-- Event and audit logs
-- ===========================================================================

alter table flow_flow_event_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Audit log for process diagram creation, editing, and deletion'
  );

alter table flow_flow_event_log modify lgfl_dgrm_id               annotations (add content 'Diagram that generated this entry (FK - flow_diagrams)');
alter table flow_flow_event_log modify lgfl_dgrm_name             annotations (add content 'Diagram name at time of event (denormalised)');
alter table flow_flow_event_log modify lgfl_dgrm_version          annotations (add content 'Diagram version at time of event (denormalised)');
alter table flow_flow_event_log modify lgfl_dgrm_status           annotations (add content 'Diagram status at time of event (denormalised)');
alter table flow_flow_event_log modify lgfl_dgrm_category         annotations (add content 'Diagram category at time of event (denormalised)');
alter table flow_flow_event_log modify lgfl_timestamp             annotations (add content 'Timestamp of the event');
alter table flow_flow_event_log modify lgfl_user                  annotations (add content 'User who caused the event');
alter table flow_flow_event_log modify lgfl_comment               annotations (add content 'Optional comment on the event');
alter table flow_flow_event_log modify lgfl_dgrm_archive_location annotations (add content 'Archive file path if diagram was archived');

alter table flow_instance_event_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Audit log for process instance lifecycle events'
  );

alter table flow_instance_event_log modify lgpr_prcs_id       annotations (add content 'Process instance that generated this entry (FK - flow_processes)');
alter table flow_instance_event_log modify lgpr_objt_id       annotations (add content 'BPMN ID of the object associated with this event');
alter table flow_instance_event_log modify lgpr_sbfl_id       annotations (add content 'Subflow associated with this event');
alter table flow_instance_event_log modify lgpr_step_key      annotations (add content 'Step key at time of event');
alter table flow_instance_event_log modify lgpr_process_level annotations (add content 'Process level at time of event');
alter table flow_instance_event_log modify lgpr_dgrm_id       annotations (add content 'Diagram ID at time of event');
alter table flow_instance_event_log modify lgpr_prcs_name     annotations (add content 'Process instance name (denormalised)');
alter table flow_instance_event_log modify lgpr_business_id   annotations (add content 'Business reference identifier for this instance');
alter table flow_instance_event_log modify lgpr_prcs_event    annotations (add content 'Event type - started, completed, terminated, error, reset, etc.');
alter table flow_instance_event_log modify lgpr_severity      annotations (add content 'Event severity level');
alter table flow_instance_event_log modify lgpr_timestamp     annotations (add content 'Timestamp of the event');
alter table flow_instance_event_log modify lgpr_duration      annotations (add content 'Duration of the event or step');
alter table flow_instance_event_log modify lgpr_user          annotations (add content 'User who caused the event');
alter table flow_instance_event_log modify lgpr_comment       annotations (add content 'Optional comment on the event');
alter table flow_instance_event_log modify lgpr_apex_task_id  annotations (add content 'APEX task ID if event relates to an APEX human task');
alter table flow_instance_event_log modify lgpr_error_info    annotations (add content 'Error details if event was an error');

alter table flow_step_event_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Audit log for individual process step completions'
  , add note    'Each entry represents the completion of a single step within a process instance, including user tasks, service tasks, script tasks, etc.  This log is used for detailed step-level reporting and auditing.'
  );

alter table flow_step_event_log modify lgsf_prcs_id              annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_step_event_log modify lgsf_objt_id              annotations (add content 'BPMN ID of the step object');
alter table flow_step_event_log modify lgsf_sbfl_id              annotations (add content 'Subflow that executed this step');
alter table flow_step_event_log modify lgsf_step_key             annotations (add content 'Step key for this execution');
alter table flow_step_event_log modify lgsf_sbfl_process_level   annotations (add content 'Process level at time of step');
alter table flow_step_event_log modify lgsf_last_completed       annotations (add content 'BPMN ID of the step completed immediately before this one');
alter table flow_step_event_log modify lgsf_status_when_complete annotations (add content 'Subflow status when this step completed');
alter table flow_step_event_log modify lgsf_sbfl_dgrm_id         annotations (add content 'Diagram ID for this step');
alter table flow_step_event_log modify lgsf_was_current          annotations (add content 'Timestamp when step became current');
alter table flow_step_event_log modify lgsf_started              annotations (add content 'Timestamp when work on the step began');
alter table flow_step_event_log modify lgsf_completed            annotations (add content 'Timestamp when step completed');
alter table flow_step_event_log modify lgsf_reservation          annotations (add content 'Username who worked this step');
alter table flow_step_event_log modify lgsf_due_on               annotations (add content 'Due date/time for this step');
alter table flow_step_event_log modify lgsf_priority             annotations (add content 'Priority at time of step execution');
alter table flow_step_event_log modify lgsf_apex_task_id         annotations (add content 'APEX task ID if step used an APEX human task');
alter table flow_step_event_log modify lgsf_user                 annotations (add content 'User who completed the step');
alter table flow_step_event_log modify lgsf_comment              annotations (add content 'Optional comment on step completion');

alter table flow_variable_event_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Audit log for process variable create, update, and delete events'
  );

alter table flow_variable_event_log modify lgvr_prcs_id   annotations (add content 'Process instance (FK - flow_processes)');
alter table flow_variable_event_log modify lgvr_scope     annotations (add content 'Variable scope at time of event');
alter table flow_variable_event_log modify lgvr_var_name  annotations (add content 'Name of the process variable');
alter table flow_variable_event_log modify lgvr_objt_id   annotations (add content 'BPMN ID of the object that triggered the variable event');
alter table flow_variable_event_log modify lgvr_sbfl_id   annotations (add content 'Subflow that triggered the variable event');
alter table flow_variable_event_log modify lgvr_expr_set  annotations (add content 'Expression set that triggered the variable event');
alter table flow_variable_event_log modify lgvr_timestamp annotations (add content 'Timestamp of the variable event');
alter table flow_variable_event_log modify lgvr_user      annotations (add content 'User who caused the variable event');
alter table flow_variable_event_log modify lgvr_var_type  annotations (add content 'Variable type at time of event');
alter table flow_variable_event_log modify lgvr_var_vc2   annotations (add content 'Variable value (VARCHAR2) at time of event');
alter table flow_variable_event_log modify lgvr_var_num   annotations (add content 'Variable value (NUMBER) at time of event');
alter table flow_variable_event_log modify lgvr_var_date  annotations (add content 'Variable value (DATE) at time of event');
alter table flow_variable_event_log modify lgvr_var_tstz  annotations (add content 'Variable value (TIMESTAMP WITH TIME ZONE) at time of event');
alter table flow_variable_event_log modify lgvr_var_clob  annotations (add content 'Variable value (CLOB) at time of event');
alter table flow_variable_event_log modify lgvr_var_json  annotations (add content 'Variable value (JSON) at time of event');

alter table flow_message_received_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Log of all BPMN message flow messages received by the system'
  );

alter table flow_message_received_log modify lgrx_id             annotations (add content 'Unique ID for this received message log entry');
alter table flow_message_received_log modify lgrx_message_name   annotations (add content 'Name of the received message');
alter table flow_message_received_log modify lgrx_key_name       annotations (add content 'Correlation key name from received message');
alter table flow_message_received_log modify lgrx_key_value      annotations (add content 'Correlation key value from received message');
alter table flow_message_received_log modify lgrx_payload        annotations (add content 'Message payload');
alter table flow_message_received_log modify lgrx_prcs_id        annotations (add content 'Process instance correlated to (FK - flow_processes)');
alter table flow_message_received_log modify lgrx_sbfl_id        annotations (add content 'Subflow correlated to (FK - flow_subflows)');
alter table flow_message_received_log modify lgrx_received_on    annotations (add content 'Timestamp when message was received');
alter table flow_message_received_log modify lgrx_was_correlated annotations (add content 'Y if message was successfully correlated to a waiting subscription');
alter table flow_message_received_log modify lgrx_comment        annotations (add content 'Optional comment');

alter table flow_rest_event_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Log of all REST API calls received by the engine'
  );

alter table flow_rest_event_log modify lgrt_id               annotations (add content 'Unique ID for this REST event log entry');
alter table flow_rest_event_log modify lgrt_call_guid        annotations (add content 'Unique GUID for this REST call');
alter table flow_rest_event_log modify lgrt_client_id        annotations (add content 'OAuth client ID making the request');
alter table flow_rest_event_log modify lgrt_log_info         annotations (add content 'Supplementary log information');
alter table flow_rest_event_log modify lgrt_token            annotations (add content 'Authentication token identifier');
alter table flow_rest_event_log modify lgrt_timestamp        annotations (add content 'Timestamp of the REST call');
alter table flow_rest_event_log modify lgrt_http_method      annotations (add content 'HTTP method - GET, POST, PUT, DELETE');
alter table flow_rest_event_log modify lgrt_endpoint         annotations (add content 'REST endpoint path called');
alter table flow_rest_event_log modify lgrt_payload          annotations (add content 'Request or response payload');
alter table flow_rest_event_log modify lgrt_error_code       annotations (add content 'HTTP error code if call failed');
alter table flow_rest_event_log modify lgrt_error_msg        annotations (add content 'Error message if call failed');
alter table flow_rest_event_log modify lgrt_error_stacktrace annotations (add content 'Full error stack trace if call failed');

alter table flow_parser_log annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Log of errors and warnings from BPMN diagram parsing'
  );

alter table flow_parser_log modify plog_id         annotations (add content 'Unique ID for this parser log entry');
alter table flow_parser_log modify plog_dgrm_id    annotations (add content 'Diagram being parsed when entry was created');
alter table flow_parser_log modify plog_bpmn_id    annotations (add content 'BPMN ID of the element associated with this log entry');
alter table flow_parser_log modify plog_log_time   annotations (add content 'Timestamp when log entry was created');
alter table flow_parser_log modify plog_parse_step annotations (add content 'Parse step where log entry was created');
alter table flow_parser_log modify plog_payload    annotations (add content 'Additional payload or context for this log entry');


-- ===========================================================================
-- STATISTICS TABLES
-- Process and step performance analytics
-- ===========================================================================

alter table flow_instance_stats annotations
  ( add app     'Flows for APEX'
  , add type    'statistics'
  , add content 'Summary statistics for process instances aggregated by period'
  );

alter table flow_instance_stats modify stpr_dgrm_id           annotations (add content 'Diagram ID for these statistics');
alter table flow_instance_stats modify stpr_period_start      annotations (add content 'Start date of the statistics period');
alter table flow_instance_stats modify stpr_period            annotations (add content 'Period type - DAY, MTD, MONTH, QUARTER, YEAR');
alter table flow_instance_stats modify stpr_created           annotations (add content 'Count of instances created in period');
alter table flow_instance_stats modify stpr_started           annotations (add content 'Count of instances started in period');
alter table flow_instance_stats modify stpr_error             annotations (add content 'Count of instances that errored in period');
alter table flow_instance_stats modify stpr_completed         annotations (add content 'Count of instances completed in period');
alter table flow_instance_stats modify stpr_terminated        annotations (add content 'Count of instances terminated in period');
alter table flow_instance_stats modify stpr_reset             annotations (add content 'Count of instances reset in period');
alter table flow_instance_stats modify stpr_duration_10pc_ivl annotations (add content '10th percentile instance duration as interval');
alter table flow_instance_stats modify stpr_duration_50pc_ivl annotations (add content '50th percentile instance duration as interval');
alter table flow_instance_stats modify stpr_duration_90pc_ivl annotations (add content '90th percentile instance duration as interval');
alter table flow_instance_stats modify stpr_duration_max_ivl  annotations (add content 'Maximum instance duration as interval');
alter table flow_instance_stats modify stpr_duration_10pc_sec annotations (add content '10th percentile instance duration in seconds');
alter table flow_instance_stats modify stpr_duration_50pc_sec annotations (add content '50th percentile instance duration in seconds');
alter table flow_instance_stats modify stpr_duration_90pc_sec annotations (add content '90th percentile instance duration in seconds');
alter table flow_instance_stats modify stpr_duration_max_sec  annotations (add content 'Maximum instance duration in seconds');

alter table flow_step_stats annotations
  ( add app     'Flows for APEX'
  , add type    'statistics'
  , add content 'Summary statistics for process steps aggregated by period'
  );

alter table flow_step_stats modify stsf_dgrm_id           annotations (add content 'Diagram ID for these statistics');
alter table flow_step_stats modify stsf_objt_bpmn_id      annotations (add content 'BPMN ID of the step object');
alter table flow_step_stats modify stsf_tag_name          annotations (add content 'BPMN element type of the step');
alter table flow_step_stats modify stsf_period_start      annotations (add content 'Start date of the statistics period');
alter table flow_step_stats modify stsf_period            annotations (add content 'Period type - DAY, MTD, MONTH, QUARTER, YEAR');
alter table flow_step_stats modify stsf_completed         annotations (add content 'Count of step completions in period');
alter table flow_step_stats modify stsf_duration_10pc_ivl annotations (add content '10th percentile step duration as interval');
alter table flow_step_stats modify stsf_duration_50pc_ivl annotations (add content '50th percentile step duration as interval');
alter table flow_step_stats modify stsf_duration_90pc_ivl annotations (add content '90th percentile step duration as interval');
alter table flow_step_stats modify stsf_duration_max_ivl  annotations (add content 'Maximum step duration as interval');
alter table flow_step_stats modify stsf_duration_10pc_sec annotations (add content '10th percentile step duration in seconds');
alter table flow_step_stats modify stsf_duration_50pc_sec annotations (add content '50th percentile step duration in seconds');
alter table flow_step_stats modify stsf_duration_90pc_sec annotations (add content '90th percentile step duration in seconds');
alter table flow_step_stats modify stsf_duration_max_sec  annotations (add content 'Maximum step duration in seconds');
alter table flow_step_stats modify stsf_waiting_10pc_ivl  annotations (add content '10th percentile step waiting time as interval');
alter table flow_step_stats modify stsf_waiting_50pc_ivl  annotations (add content '50th percentile step waiting time as interval');
alter table flow_step_stats modify stsf_waiting_90pc_ivl  annotations (add content '90th percentile step waiting time as interval');
alter table flow_step_stats modify stsf_waiting_max_ivl   annotations (add content 'Maximum step waiting time as interval');
alter table flow_step_stats modify stsf_waiting_10pc_sec  annotations (add content '10th percentile step waiting time in seconds');
alter table flow_step_stats modify stsf_waiting_50pc_sec  annotations (add content '50th percentile step waiting time in seconds');
alter table flow_step_stats modify stsf_waiting_90pc_sec  annotations (add content '90th percentile step waiting time in seconds');
alter table flow_step_stats modify stsf_waiting_max_sec   annotations (add content 'Maximum step waiting time in seconds');

alter table flow_stats_history annotations
  ( add app     'Flows for APEX'
  , add type    'statistics'
  , add content 'History of statistics calculation runs'
  );

alter table flow_stats_history modify sths_id         annotations (add content 'Unique ID for this statistics run record');
alter table flow_stats_history modify sths_date        annotations (add content 'Date statistics were gathered');
alter table flow_stats_history modify sths_status      annotations (add content 'Outcome - SUCCESS or ERROR');
alter table flow_stats_history modify sths_type        annotations (add content 'Period type - DAY, MONTH, MTD, QUARTER, YEAR');
alter table flow_stats_history modify sths_operation   annotations (add content 'Operation performed - calculate, purge, etc.');
alter table flow_stats_history modify sths_errors      annotations (add content 'Error details if statistics run failed');
alter table flow_stats_history modify sths_comments    annotations (add content 'Additional comments on the statistics run');
alter table flow_stats_history modify sths_created_on  annotations (add content 'Timestamp when this record was created');
alter table flow_stats_history modify sths_updated_on  annotations (add content 'Timestamp when this record was last updated');
alter table flow_stats_history modify sths_updated_by  annotations (add content 'User who last updated this record');


-- ===========================================================================
-- CONFIGURATION TABLES
-- System settings, reference data, and templates
-- ===========================================================================

alter table flow_configuration annotations
  ( add app     'Flows for APEX'
  , add type    'configuration'
  , add content 'Active system configuration settings'
  );

alter table flow_configuration modify cfig_key   annotations (add content 'Configuration parameter name');
alter table flow_configuration modify cfig_value annotations (add content 'Configuration parameter value');

alter table flow_messages annotations
  ( add app     'Flows for APEX'
  , add type    'configuration'
  , add content 'Localised engine error and warning messages'
  );

alter table flow_messages modify fmsg_message_key     annotations (add content 'Message identifier key');
alter table flow_messages modify fmsg_lang            annotations (add content 'Language code for this message, e.g. en, fr, de');
alter table flow_messages modify fmsg_message_content annotations (add content 'Localised message text in fmsg_lang');

alter table flow_simple_form_templates annotations
  ( add app     'Flows for APEX'
  , add type    'configuration'
  , add content 'Templates for simple APEX forms used in user tasks'
  );

alter table flow_simple_form_templates modify sfte_id        annotations (add content 'Unique ID for this form template');
alter table flow_simple_form_templates modify sfte_name      annotations (add content 'Display name of the form template');
alter table flow_simple_form_templates modify sfte_static_id annotations (add content 'Static identifier used to reference the template in BPMN');
alter table flow_simple_form_templates modify sfte_content   annotations (add content 'Form template definition as strict JSON');

alter table flow_ai_prompts annotations
  ( add app     'Flows for APEX'
  , add type    'configuration'
  , add content 'AI prompt templates for Flows for APEX AI features'
  );

alter table flow_ai_prompts modify aipr_id                 annotations (add content 'Unique ID for this AI prompt');
alter table flow_ai_prompts modify aipr_prompt_key         annotations (add content 'Prompt identifier key');
alter table flow_ai_prompts modify aipr_lang               annotations (add content 'Language code for this prompt');
alter table flow_ai_prompts modify aipr_provider_type_code annotations (add content 'AI provider type - OCI_GENAI, OPENAI, etc.');
alter table flow_ai_prompts modify aipr_model_name         annotations (add content 'Specific AI model name this prompt applies to');
alter table flow_ai_prompts modify aipr_type               annotations (add content 'Prompt type - system, user, etc.');
alter table flow_ai_prompts modify aipr_title              annotations (add content 'Short title for this prompt');
alter table flow_ai_prompts modify aipr_prompt_text        annotations (add content 'The prompt template text');
alter table flow_ai_prompts modify aipr_display_as_qa      annotations (add content 'Y if prompt should be displayed in Q and A format');

alter table flow_bpmn_types annotations
  ( add app     'Flows for APEX'
  , add type    'configuration'
  , add content 'Reference data for BPMN object types supported by the engine'
  );

alter table flow_bpmn_types modify bpmn_code         annotations (add content 'Short code identifier for this BPMN type (primary key)');
alter table flow_bpmn_types modify bpmn_object_name  annotations (add content 'Human-readable name of this BPMN element type');
alter table flow_bpmn_types modify bpmn_tag_name     annotations (add content 'BPMN XML tag name');
alter table flow_bpmn_types modify bpmn_sub_tag_name annotations (add content 'BPMN XML sub-tag name for specialised element types');
alter table flow_bpmn_types modify bpmn_icon         annotations (add content 'Icon identifier for APEX UI rendering');
alter table flow_bpmn_types modify bpmn_super_type   annotations (add content 'Broad category - event, task, gateway, connection, etc.');
alter table flow_bpmn_types modify bpmn_is_supported annotations (add content 'Y if this BPMN type is currently supported by the engine');
alter table flow_bpmn_types modify bpmn_interrupting annotations (add content '1 if this boundary event type is interrupting');

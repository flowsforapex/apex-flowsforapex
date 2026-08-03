/* 
-- Flows for APEX - install_ddl_comments.sql
-- 
-- (c) Copyright Flowquest Limited. 2024-2026.
--
-- Oracle SQL comments on all Flows for APEX tables and columns.
-- Compatible with all Oracle versions; supplements annotations.
-- Content now mirrors the 'content' key from install_ddl_annotations.sql.
--
-- Created   01-Mar-2024  Richard Allen, Flowquest Consulting
-- Updated   31-May-2026  Richard Allen, Flowquest Limited  - Regenerated from install_ddl_annotations.sql
--
*/


PROMPT >> Adding Comments to all Flows for APEX Tables and Columns
PROMPT >> ========================================================

comment on table flow_diagrams                                 is 'Process definitions and their BPMN XML diagrams';
comment on column flow_diagrams.dgrm_id                                            is 'Unique numeric ID for this diagram';
comment on column flow_diagrams.dgrm_name                                          is 'Business process name; often the name of the process being modelled';
comment on column flow_diagrams.dgrm_version                                       is 'Version string for this diagram';
comment on column flow_diagrams.dgrm_status                                        is 'Lifecycle status: draft, released, deprecated, archived';
comment on column flow_diagrams.dgrm_category                                      is 'Optional category for grouping diagrams';
comment on column flow_diagrams.dgrm_last_update                                   is 'Timestamp of most recent diagram change';
comment on column flow_diagrams.dgrm_content                                       is 'BPMN XML content of the process diagram (CLOB)';
comment on column flow_diagrams.dgrm_short_description                             is 'Brief description of the process';
comment on column flow_diagrams.dgrm_description                                   is 'Detailed description of the process';
comment on column flow_diagrams.dgrm_icon                                          is 'Icon identifier for use in APEX applications';

comment on table flow_objects                                  is 'Parsed BPMN objects from process definitions';
comment on column flow_objects.objt_id                                            is 'System-generated unique ID; changes on re-parse';
comment on column flow_objects.objt_bpmn_id                                       is 'BPMN identifier from the diagram XML';
comment on column flow_objects.objt_dgrm_id                                       is 'Diagram containing this object (FK: flow_diagrams)';
comment on column flow_objects.objt_name                                          is 'Display name of the BPMN object';
comment on column flow_objects.objt_tag_name                                      is 'BPMN element type, e.g. bpmn:task, bpmn:subProcess';
comment on column flow_objects.objt_sub_tag_name                                  is 'BPMN element sub-type, e.g. terminateEventDefinition';
comment on column flow_objects.objt_objt_id                                       is 'Parent container object (FK: flow_objects)';
comment on column flow_objects.objt_objt_lane_id                                  is 'Lane this object belongs to (FK: flow_objects)';
comment on column flow_objects.objt_attached_to                                   is 'BPMN ID of parent object for boundary events';
comment on column flow_objects.objt_interrupting                                  is 'For boundary events: 1 = interrupting, 0 = non-interrupting';
comment on column flow_objects.objt_attributes                                    is 'Additional object attributes as JSON';

comment on table flow_connections                              is 'Parsed BPMN connections between process objects';
comment on column flow_connections.conn_id                                            is 'System-generated unique ID; changes on re-parse';
comment on column flow_connections.conn_bpmn_id                                       is 'BPMN identifier from the diagram XML';
comment on column flow_connections.conn_dgrm_id                                       is 'Diagram containing this connection (FK: flow_diagrams)';
comment on column flow_connections.conn_name                                          is 'Display name of the connection';
comment on column flow_connections.conn_src_objt_id                                   is 'Source object (FK: flow_objects)';
comment on column flow_connections.conn_tgt_objt_id                                   is 'Target object (FK: flow_objects)';
comment on column flow_connections.conn_tag_name                                      is 'BPMN connection type, e.g. bpmn:messageFlow, bpmn:sequenceFlow';
comment on column flow_connections.conn_origin                                        is 'Whether the source object is in a PROCESS or SUBPROCESS';
comment on column flow_connections.conn_is_default                                    is '1 if this is the default path from the source object';
comment on column flow_connections.conn_sequence                                      is 'Evaluation order when multiple connections leave a source object';
comment on column flow_connections.conn_attributes                                    is 'Additional connection attributes as JSON';

comment on table flow_object_expressions                       is 'Variable expressions attached to BPMN objects for data mapping';
comment on column flow_object_expressions.expr_id                                            is 'Unique ID for this expression; changes on re-parse';
comment on column flow_object_expressions.expr_objt_id                                       is 'Object this expression belongs to (FK: flow_objects)';
comment on column flow_object_expressions.expr_set                                           is 'When this expression fires: beforeTask, afterTask, onEvent, beforeSplit, afterMerge, inVariables, outVariables';
comment on column flow_object_expressions.expr_order                                         is 'Execution order within the expression set';
comment on column flow_object_expressions.expr_var_name                                      is 'Process variable name to set or read';
comment on column flow_object_expressions.expr_var_type                                      is 'Variable type: VARCHAR2, NUMBER, DATE, TSTZ, CLOB, JSON';
comment on column flow_object_expressions.expr_type                                          is 'Expression type: static value, SQL query, PL/SQL function, etc.';
comment on column flow_object_expressions.expr_expression                                    is 'The expression body';
comment on column flow_object_expressions.expr_source_type                                   is 'Source type for inVariables and outVariables expressions';
comment on column flow_object_expressions.expr_source                                        is 'Source name for inVariables and outVariables expressions';

comment on table flow_processes                                is 'Live state of process instances';
comment on column flow_processes.prcs_id                                            is 'Unique numeric ID for this process instance';
comment on column flow_processes.prcs_dgrm_id                                       is 'Diagram this instance runs (FK: flow_diagrams)';
comment on column flow_processes.prcs_name                                          is 'Business name of this process instance';
comment on column flow_processes.prcs_process_bpmn_id                               is 'BPMN ID of the top-level process element';
comment on column flow_processes.prcs_status                                        is 'Current status: created, running, completed, terminated, error';
comment on column flow_processes.prcs_init_ts                                       is 'Timestamp when the instance was initialised';
comment on column flow_processes.prcs_init_by                                       is 'User who initialised the instance';
comment on column flow_processes.prcs_start_ts                                      is 'Timestamp when instance was started; resets on reset';
comment on column flow_processes.prcs_complete_ts                                   is 'Timestamp when instance completed or was terminated';
comment on column flow_processes.prcs_due_on                                        is 'Optional due date/time for the process instance';
comment on column flow_processes.prcs_archived_ts                                   is 'Timestamp when instance was archived';
comment on column flow_processes.prcs_priority                                      is 'Priority of this instance (user-defined numeric value)';
comment on column flow_processes.prcs_logging_level                                 is 'Logging verbosity level 0-8';
comment on column flow_processes.prcs_was_altered                                   is 'Y if instance has been altered from normal flow';
comment on column flow_processes.prcs_last_update                                   is 'Timestamp of most recent change to this instance';
comment on column flow_processes.prcs_last_update_by                                is 'User who made the most recent change';

comment on table flow_subflows                                 is 'Live state of subflows within running process instances';
comment on column flow_subflows.sbfl_id                                            is 'Unique ID for this subflow';
comment on column flow_subflows.sbfl_prcs_id                                       is 'Parent process instance (FK: flow_processes)';
comment on column flow_subflows.sbfl_dgrm_id                                       is 'Diagram this subflow is running in (FK: flow_diagrams)';
comment on column flow_subflows.sbfl_sbfl_id                                       is 'Parent subflow (FK: flow_subflows)';
comment on column flow_subflows.sbfl_process_level                                 is 'Nesting level from main process: = 0 for main process, = sbfl_id of first subflow in each process level for subsequent levels';
comment on column flow_subflows.sbfl_diagram_level                                 is 'Diagram level: = 0 for main process, = sbfl_id of first subflow in each diagram level for subsequent levels';
comment on column flow_subflows.sbfl_calling_sbfl                                  is 'Subflow that called this one (used by Call Activities)';
comment on column flow_subflows.sbfl_scope                                         is 'Scope ID used for process variable scoping';
comment on column flow_subflows.sbfl_starting_object                               is 'BPMN ID of the object where this subflow started';
comment on column flow_subflows.sbfl_route                                         is 'Route identifier for this subflow';
comment on column flow_subflows.sbfl_last_completed                                is 'BPMN ID of the last completed object';
comment on column flow_subflows.sbfl_current                                       is 'BPMN ID of the current object where this subflow is waiting';
comment on column flow_subflows.sbfl_step_key                                      is 'Unique step key for optimistic concurrency control: can act as UK for current step';
comment on column flow_subflows.sbfl_is_adhoc                                      is 'Y if this subflow is immediately inside an adhoc subprocess';
comment on column flow_subflows.sbfl_ahsp_id                                       is 'Adhoc subprocess ID if current object is an adhoc subprocess (FK: flow_adhoc_subprocs)';
comment on column flow_subflows.sbfl_hide_in_task_list                             is 'Y if the current step should not appear in APEX task lists';
comment on column flow_subflows.sbfl_due_on                                        is 'Due date/time for the current step';
comment on column flow_subflows.sbfl_priority                                      is 'TaskPriority for the current step (1 = highest priority, 5 = lowest priority)';
comment on column flow_subflows.sbfl_status                                        is 'Current status: running, waiting, split, complete, error, etc.';
comment on column flow_subflows.sbfl_became_current                                is 'Timestamp when subflow arrived at current object';
comment on column flow_subflows.sbfl_work_started                                  is 'Timestamp when work on current step began';
comment on column flow_subflows.sbfl_has_events                                    is 'Comma-separated list of boundary event types currently active on this step';
comment on column flow_subflows.sbfl_is_following_ebg                              is 'Y if current step is immediately following an event-based gateway';
comment on column flow_subflows.sbfl_lane                                          is 'BPMN ID of the lane containing the current step';
comment on column flow_subflows.sbfl_lane_name                                     is 'Name of lane containing current step (denormalised; required for Call Activities)';
comment on column flow_subflows.sbfl_lane_isRole                                   is 'Whether the lane is role-based (denormalised; required for Call Activities)';
comment on column flow_subflows.sbfl_lane_role                                     is 'Role name for the lane (denormalised; required for Call Activities)';
comment on column flow_subflows.sbfl_reservation                                   is 'Username who has reserved the current task';
comment on column flow_subflows.sbfl_potential_users                               is 'Users eligible to work the current task';
comment on column flow_subflows.sbfl_potential_groups                              is 'Groups eligible to work the current task';
comment on column flow_subflows.sbfl_excluded_users                                is 'Users excluded from working the current task';
comment on column flow_subflows.sbfl_apex_task_id                                  is 'APEX task ID if current step uses an APEX human task';
comment on column flow_subflows.sbfl_apex_business_admin                           is 'APEX business administrator for the current task';
comment on column flow_subflows.sbfl_iteration_type                                is 'Type of iteration: sequential, parallel, loop';
comment on column flow_subflows.sbfl_iobj_id                                       is 'FK to flow_iterated_objects if subflow is executing an iteration';
comment on column flow_subflows.sbfl_iter_id                                       is 'FK to flow_iterations for the current iteration';
comment on column flow_subflows.sbfl_iteration_var                                 is 'Process variable holding iteration array (deprecated; use flow_iterated_objects)';
comment on column flow_subflows.sbfl_iteration_var_scope                           is 'Scope of iteration variable (deprecated; use flow_iterated_objects)';
comment on column flow_subflows.sbfl_loop_counter                                  is 'Current loop count for loop objects';
comment on column flow_subflows.sbfl_loop_total_instances                          is 'Total instances declared for multi-instance objects';
comment on column flow_subflows.sbfl_task_input_parameters                         is 'Input parameter bindings for current task as JSON';
comment on column flow_subflows.sbfl_task_output_parameters                        is 'Output parameter bindings for current task as JSON';
comment on column flow_subflows.sbfl_last_update                                   is 'Timestamp of most recent change to this subflow';
comment on column flow_subflows.sbfl_last_update_by                                is 'User who made the most recent change';

comment on table flow_process_variables                        is 'Process variables set on running process instances';
comment on column flow_process_variables.prov_prcs_id                                       is 'Process instance owning this variable (FK: flow_processes)';
comment on column flow_process_variables.prov_scope                                         is 'Scope ID determining variable visibility across call activities';
comment on column flow_process_variables.prov_var_name                                      is 'Variable name (case-insensitive; stored as supplied)';
comment on column flow_process_variables.prov_var_type                                      is 'Variable type: VARCHAR2, NUMBER, DATE, TSTZ, CLOB, JSON';
comment on column flow_process_variables.prov_var_vc2                                       is 'Value storage for VARCHAR2-typed variables';
comment on column flow_process_variables.prov_var_num                                       is 'Value storage for NUMBER-typed variables';
comment on column flow_process_variables.prov_var_date                                      is 'Value storage for DATE-typed variables';
comment on column flow_process_variables.prov_var_tstz                                      is 'Value storage for TIMESTAMP WITH TIME ZONE-typed variables';
comment on column flow_process_variables.prov_var_clob                                      is 'Value storage for CLOB-typed variables';
comment on column flow_process_variables.prov_var_json                                      is 'Value storage for JSON-typed variables';
comment on column flow_process_variables.prov_var_name_uc                                   is 'Upper-cased variable name (virtual column; used in primary key for case-insensitive lookup)';

comment on table flow_subflow_log                              is 'Completed steps within running process instances';
comment on column flow_subflow_log.sflg_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_subflow_log.sflg_objt_id                                       is 'BPMN ID of the completed object';
comment on column flow_subflow_log.sflg_sbfl_id                                       is 'Subflow that completed this step';
comment on column flow_subflow_log.sflg_step_key                                      is 'Step key at time of completion';
comment on column flow_subflow_log.sflg_dgrm_id                                       is 'Diagram ID for this step';
comment on column flow_subflow_log.sflg_scope                                         is 'Scope ID at time of completion';
comment on column flow_subflow_log.sflg_diagram_level                                 is 'Diagram level at time of completion';
comment on column flow_subflow_log.sflg_iter_id                                       is 'Iteration ID if step was part of an iteration (FK: flow_iterations)';
comment on column flow_subflow_log.sflg_last_updated                                  is 'Date of last update to this log entry';
comment on column flow_subflow_log.sflg_matching_object                               is 'BPMN ID of matched object; used at joining gateways and link events';
comment on column flow_subflow_log.sflg_notes                                         is 'Optional notes for this log entry';

comment on table flow_instance_diagrams                        is 'Diagrams used by running process instances; tracks Call Activity nesting';
comment on column flow_instance_diagrams.prdg_id                                            is 'Unique ID for this diagram usage';
comment on column flow_instance_diagrams.prdg_prdg_id                                       is 'Parent diagram usage (FK: flow_instance_diagrams)';
comment on column flow_instance_diagrams.prdg_prcs_id                                       is 'Process instance using this diagram (FK: flow_processes)';
comment on column flow_instance_diagrams.prdg_dgrm_id                                       is 'Diagram being used (FK: flow_diagrams)';
comment on column flow_instance_diagrams.prdg_calling_dgrm                                  is 'Diagram that called this one via a Call Activity (FK: flow_diagrams)';
comment on column flow_instance_diagrams.prdg_calling_objt                                  is 'BPMN ID of the Call Activity object that invoked this diagram';
comment on column flow_instance_diagrams.prdg_diagram_level                                 is 'Diagram level assigned to this usage; equals sbfl_id of the first subflow from this diagram';

comment on table flow_timers                                   is 'Active timers set on running process instances';
comment on column flow_timers.timr_id                                            is 'Unique ID for this timer';
comment on column flow_timers.timr_run                                           is 'Run counter for repeating timers';
comment on column flow_timers.timr_prcs_id                                       is 'Process instance owning this timer (FK: flow_processes)';
comment on column flow_timers.timr_sbfl_id                                       is 'Subflow associated with this timer (FK: flow_subflows)';
comment on column flow_timers.timr_step_key                                      is 'Step key when timer was created';
comment on column flow_timers.timr_type                                          is 'Timer type: timerDate, timerDuration, timerCycle';
comment on column flow_timers.timr_last_run                                      is 'Timestamp of most recent timer firing';
comment on column flow_timers.timr_created_on                                    is 'Timestamp when timer was created';
comment on column flow_timers.timr_status                                        is 'Timer status: S=scheduled, C=completed, R=running';
comment on column flow_timers.timr_start_on                                      is 'Scheduled start timestamp';
comment on column flow_timers.timr_interval_ym                                   is 'Repeat interval, year-to-month component';
comment on column flow_timers.timr_interval_ds                                   is 'Repeat interval, day-to-second component';
comment on column flow_timers.timr_repeat_times                                  is 'Remaining repeats; -1 for infinite';
comment on column flow_timers.timr_callback                                      is 'Procedure to call when timer fires';
comment on column flow_timers.timr_callback_par                                  is 'Parameter to pass to the callback procedure';

comment on table flow_message_subscriptions                    is 'Active message subscriptions for process collaboration and BPMN messageFlow';
comment on column flow_message_subscriptions.msub_id                                            is 'Unique ID for this message subscription';
comment on column flow_message_subscriptions.msub_message_name                                  is 'Message name to match on incoming messages';
comment on column flow_message_subscriptions.msub_key_name                                      is 'Correlation key name to match on incoming messages';
comment on column flow_message_subscriptions.msub_key_value                                     is 'Correlation key value to match on incoming messages';
comment on column flow_message_subscriptions.msub_prcs_id                                       is 'Process instance to notify on message receipt (FK: flow_processes)';
comment on column flow_message_subscriptions.msub_sbfl_id                                       is 'Subflow to notify on message receipt (FK: flow_subflows)';
comment on column flow_message_subscriptions.msub_step_key                                      is 'Step key at time of subscription';
comment on column flow_message_subscriptions.msub_dgrm_id                                       is 'Diagram to use for message start events (FK: flow_diagrams)';
comment on column flow_message_subscriptions.msub_callback                                      is 'Callback procedure for received messages';
comment on column flow_message_subscriptions.msub_callback_par                                  is 'Parameter to pass to the callback procedure';
comment on column flow_message_subscriptions.msub_payload_var                                   is 'Process variable to receive the message payload';
comment on column flow_message_subscriptions.msub_created                                       is 'Timestamp when subscription was created';

comment on table flow_iterated_objects                         is 'Objects being iterated or looped within running process instances';
comment on column flow_iterated_objects.iobj_id                                            is 'Unique ID for this iterated object';
comment on column flow_iterated_objects.iobj_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_iterated_objects.iobj_diagram_level                                 is 'Diagram level of the iterated object';
comment on column flow_iterated_objects.iobj_dgrm_id                                       is 'Diagram containing the iterated object (FK: flow_diagrams)';
comment on column flow_iterated_objects.iobj_parent_bpmn_id                                is 'BPMN ID of the object being iterated or looped';
comment on column flow_iterated_objects.iobj_step_key                                      is 'Step key of the parent object for this iteration';
comment on column flow_iterated_objects.iobj_iteration_var                                 is 'Process variable holding the iteration collection as JSON';
comment on column flow_iterated_objects.iobj_var_scope                                     is 'Scope of the iteration variable';
comment on column flow_iterated_objects.iobj_objt_type                                     is 'Type of the iterated BPMN object';
comment on column flow_iterated_objects.iobj_iteration_type                                is 'Iteration type: sequential, parallel, loop';
comment on column flow_iterated_objects.iobj_parent_iter_id                                is 'Parent iteration for nested iterations (FK: flow_iterations)';
comment on column flow_iterated_objects.iobj_display_name                                  is 'Display name for this iterated object in APEX UI';

comment on table flow_iterations                               is 'Individual iteration instances within an iterated object';
comment on column flow_iterations.iter_id                                            is 'Unique ID for this iteration';
comment on column flow_iterations.iter_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_iterations.iter_iobj_id                                       is 'Iterated object this iteration belongs to (FK: flow_iterated_objects)';
comment on column flow_iterations.iter_loop_counter                                  is 'Loop count for this iteration (1-based)';
comment on column flow_iterations.iter_sbfl_id                                       is 'Subflow executing this iteration (FK: flow_subflows)';
comment on column flow_iterations.iter_scope                                         is 'Scope ID for this iteration';
comment on column flow_iterations.iter_step_key                                      is 'Step key for this iteration';
comment on column flow_iterations.iter_status                                        is 'Status: running, completed, terminated';
comment on column flow_iterations.iter_description                                   is 'Description of this iteration';
comment on column flow_iterations.iter_display_name                                  is 'Display name for this iteration in APEX UI';
comment on column flow_iterations.iter_inputs                                        is 'Input variable bindings for this iteration as JSON';
comment on column flow_iterations.iter_outputs                                       is 'Output variable bindings for this iteration as JSON';

comment on table flow_adhoc_subprocs                           is 'Adhoc subprocesses active within running process instances';
comment on column flow_adhoc_subprocs.ahsp_id                                            is 'Unique ID for this adhoc subprocess';
comment on column flow_adhoc_subprocs.ahsp_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_adhoc_subprocs.ahsp_sbfl_id                                       is 'Subflow executing this adhoc subprocess (FK: flow_subflows)';
comment on column flow_adhoc_subprocs.ahsp_dgrm_id                                       is 'Diagram containing this adhoc subprocess (FK: flow_diagrams)';
comment on column flow_adhoc_subprocs.ahsp_bpmn_id                                       is 'BPMN ID of the adhoc subprocess object';
comment on column flow_adhoc_subprocs.ahsp_step_key                                      is 'Step key of the adhoc subprocess';
comment on column flow_adhoc_subprocs.ahsp_process_level                                 is 'Process level of this adhoc subprocess';
comment on column flow_adhoc_subprocs.ahsp_control                                       is 'Control mode: manual, ai, recommendation, or hybrid';
comment on column flow_adhoc_subprocs.ahsp_last_ai_check                                 is 'Timestamp of most recent AI management check';
comment on column flow_adhoc_subprocs.ahsp_check_interval_minutes                        is 'Minutes between AI management checks';
comment on column flow_adhoc_subprocs.ahsp_iteration_count                               is 'Number of AI check iterations performed';
comment on column flow_adhoc_subprocs.ahsp_status                                        is 'Current status of this adhoc subprocess';
comment on column flow_adhoc_subprocs.ahsp_next_recommended_check                        is 'AI-recommended timestamp for next management check';
comment on column flow_adhoc_subprocs.ahsp_next_check_reason                             is 'AI explanation for the recommended next check timing';
comment on column flow_adhoc_subprocs.ahsp_turns_per_session                             is 'Maximum AI turns allowed per management check session';
comment on column flow_adhoc_subprocs.ahsp_max_total_turns                               is 'Maximum total AI turns allowed for this subprocess lifecycle';

comment on table flow_adhoc_subflows                           is 'Subflows belonging to active adhoc subprocesses';
comment on column flow_adhoc_subflows.ahsf_sbfl_id                                       is 'Subflow executing this adhoc subflow (FK: flow_subflows)';
comment on column flow_adhoc_subflows.ahsf_ahsp_id                                       is 'Parent adhoc subprocess (FK: flow_adhoc_subprocs)';
comment on column flow_adhoc_subflows.ahsf_starting_object                               is 'BPMN ID of the object where this adhoc subflow started';
comment on column flow_adhoc_subflows.ahsf_starting_step_key                             is 'Step key of the object where this adhoc subflow started';
comment on column flow_adhoc_subflows.ahsf_repeat_count                                  is 'Number of times this starting object has been executed';
comment on column flow_adhoc_subflows.ahsf_status                                        is 'Current status of this adhoc subflow';
comment on column flow_adhoc_subflows.ahsf_start_time                                    is 'Timestamp when this adhoc subflow started';
comment on column flow_adhoc_subflows.ahsf_complete_time                                 is 'Timestamp when this adhoc subflow completed';
comment on column flow_adhoc_subflows.ahsf_inputs                                        is 'Input variable bindings as JSON';
comment on column flow_adhoc_subflows.ahsf_outputs                                       is 'Output variable bindings as JSON';

comment on table flow_adhoc_subproc_ai_decisions               is 'AI decisions and reasoning records for autonomous adhoc subprocess management';
comment on column flow_adhoc_subproc_ai_decisions.asad_id                                            is 'Unique ID for this AI decision record';
comment on column flow_adhoc_subproc_ai_decisions.asad_ahsp_id                                       is 'Adhoc subprocess being managed (FK: flow_adhoc_subprocs)';
comment on column flow_adhoc_subproc_ai_decisions.asad_turn                                          is 'Turn number within this AI management session';
comment on column flow_adhoc_subproc_ai_decisions.asad_rationale                                     is 'AI reasoning for the decision made';
comment on column flow_adhoc_subproc_ai_decisions.asad_actions                                       is 'JSON array of actions recommended by the AI';
comment on column flow_adhoc_subproc_ai_decisions.asad_timestamp                                     is 'Timestamp when the AI decision was recorded';
comment on column flow_adhoc_subproc_ai_decisions.asad_created_by                                    is 'User or system that triggered this AI decision';

comment on table flow_flow_event_log                           is 'Audit log for process diagram creation, editing, and deletion';
comment on column flow_flow_event_log.lgfl_dgrm_id                                       is 'Diagram that generated this entry (FK: flow_diagrams)';
comment on column flow_flow_event_log.lgfl_dgrm_name                                     is 'Diagram name at time of event (denormalised)';
comment on column flow_flow_event_log.lgfl_dgrm_version                                  is 'Diagram version at time of event (denormalised)';
comment on column flow_flow_event_log.lgfl_dgrm_status                                   is 'Diagram status at time of event (denormalised)';
comment on column flow_flow_event_log.lgfl_dgrm_category                                 is 'Diagram category at time of event (denormalised)';
comment on column flow_flow_event_log.lgfl_timestamp                                     is 'Timestamp of the event';
comment on column flow_flow_event_log.lgfl_user                                          is 'User who caused the event';
comment on column flow_flow_event_log.lgfl_comment                                       is 'Optional comment on the event';
comment on column flow_flow_event_log.lgfl_dgrm_archive_location                         is 'Archive file path if diagram was archived';

comment on table flow_instance_event_log                       is 'Audit log for process instance lifecycle events';
comment on column flow_instance_event_log.lgpr_prcs_id                                       is 'Process instance that generated this entry (FK: flow_processes)';
comment on column flow_instance_event_log.lgpr_objt_id                                       is 'BPMN ID of the object associated with this event';
comment on column flow_instance_event_log.lgpr_sbfl_id                                       is 'Subflow associated with this event';
comment on column flow_instance_event_log.lgpr_step_key                                      is 'Step key at time of event';
comment on column flow_instance_event_log.lgpr_process_level                                 is 'Process level at time of event';
comment on column flow_instance_event_log.lgpr_dgrm_id                                       is 'Diagram ID at time of event';
comment on column flow_instance_event_log.lgpr_prcs_name                                     is 'Process instance name (denormalised)';
comment on column flow_instance_event_log.lgpr_business_id                                   is 'Business reference identifier for this instance';
comment on column flow_instance_event_log.lgpr_prcs_event                                    is 'Event type: started, completed, terminated, error, reset, etc.';
comment on column flow_instance_event_log.lgpr_severity                                      is 'Event severity level';
comment on column flow_instance_event_log.lgpr_timestamp                                     is 'Timestamp of the event';
comment on column flow_instance_event_log.lgpr_duration                                      is 'Duration of the event or step';
comment on column flow_instance_event_log.lgpr_user                                          is 'User who caused the event';
comment on column flow_instance_event_log.lgpr_comment                                       is 'Optional comment on the event';
comment on column flow_instance_event_log.lgpr_apex_task_id                                  is 'APEX task ID if event relates to an APEX human task';
comment on column flow_instance_event_log.lgpr_error_info                                    is 'Error details if event was an error';

comment on table flow_step_event_log                           is 'Audit log for individual process step completions';
comment on column flow_step_event_log.lgsf_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_step_event_log.lgsf_objt_id                                       is 'BPMN ID of the step object';
comment on column flow_step_event_log.lgsf_sbfl_id                                       is 'Subflow that executed this step';
comment on column flow_step_event_log.lgsf_step_key                                      is 'Step key for this execution';
comment on column flow_step_event_log.lgsf_sbfl_process_level                            is 'Process level at time of step';
comment on column flow_step_event_log.lgsf_last_completed                                is 'BPMN ID of the step completed immediately before this one';
comment on column flow_step_event_log.lgsf_status_when_complete                          is 'Subflow status when this step completed';
comment on column flow_step_event_log.lgsf_sbfl_dgrm_id                                  is 'Diagram ID for this step';
comment on column flow_step_event_log.lgsf_was_current                                   is 'Timestamp when step became current';
comment on column flow_step_event_log.lgsf_started                                       is 'Timestamp when work on the step began';
comment on column flow_step_event_log.lgsf_completed                                     is 'Timestamp when step completed';
comment on column flow_step_event_log.lgsf_reservation                                   is 'Username who worked this step';
comment on column flow_step_event_log.lgsf_due_on                                        is 'Due date/time for this step';
comment on column flow_step_event_log.lgsf_priority                                      is 'Priority at time of step execution';
comment on column flow_step_event_log.lgsf_apex_task_id                                  is 'APEX task ID if step used an APEX human task';
comment on column flow_step_event_log.lgsf_user                                          is 'User who completed the step';
comment on column flow_step_event_log.lgsf_comment                                       is 'Optional comment on step completion';

comment on table flow_variable_event_log                       is 'Audit log for process variable create, update, and delete events';
comment on column flow_variable_event_log.lgvr_prcs_id                                       is 'Process instance (FK: flow_processes)';
comment on column flow_variable_event_log.lgvr_scope                                         is 'Variable scope at time of event';
comment on column flow_variable_event_log.lgvr_var_name                                      is 'Name of the process variable';
comment on column flow_variable_event_log.lgvr_objt_id                                       is 'BPMN ID of the object that triggered the variable event';
comment on column flow_variable_event_log.lgvr_sbfl_id                                       is 'Subflow that triggered the variable event';
comment on column flow_variable_event_log.lgvr_expr_set                                      is 'Expression set that triggered the variable event';
comment on column flow_variable_event_log.lgvr_timestamp                                     is 'Timestamp of the variable event';
comment on column flow_variable_event_log.lgvr_user                                          is 'User who caused the variable event';
comment on column flow_variable_event_log.lgvr_var_type                                      is 'Variable type at time of event';
comment on column flow_variable_event_log.lgvr_var_vc2                                       is 'Variable value (VARCHAR2) at time of event';
comment on column flow_variable_event_log.lgvr_var_num                                       is 'Variable value (NUMBER) at time of event';
comment on column flow_variable_event_log.lgvr_var_date                                      is 'Variable value (DATE) at time of event';
comment on column flow_variable_event_log.lgvr_var_tstz                                      is 'Variable value (TIMESTAMP WITH TIME ZONE) at time of event';
comment on column flow_variable_event_log.lgvr_var_clob                                      is 'Variable value (CLOB) at time of event';
comment on column flow_variable_event_log.lgvr_var_json                                      is 'Variable value (JSON) at time of event';

comment on table flow_message_received_log                     is 'Log of all BPMN message flow messages received by the system';
comment on column flow_message_received_log.lgrx_id                                            is 'Unique ID for this received message log entry';
comment on column flow_message_received_log.lgrx_message_name                                  is 'Name of the received message';
comment on column flow_message_received_log.lgrx_key_name                                      is 'Correlation key name from received message';
comment on column flow_message_received_log.lgrx_key_value                                     is 'Correlation key value from received message';
comment on column flow_message_received_log.lgrx_payload                                       is 'Message payload';
comment on column flow_message_received_log.lgrx_prcs_id                                       is 'Process instance correlated to (FK: flow_processes)';
comment on column flow_message_received_log.lgrx_sbfl_id                                       is 'Subflow correlated to (FK: flow_subflows)';
comment on column flow_message_received_log.lgrx_received_on                                   is 'Timestamp when message was received';
comment on column flow_message_received_log.lgrx_was_correlated                                is 'Y if message was successfully correlated to a waiting subscription';
comment on column flow_message_received_log.lgrx_comment                                       is 'Optional comment';

comment on table flow_rest_event_log                           is 'Log of all REST API calls received by the engine';
comment on column flow_rest_event_log.lgrt_id                                            is 'Unique ID for this REST event log entry';
comment on column flow_rest_event_log.lgrt_call_guid                                     is 'Unique GUID for this REST call';
comment on column flow_rest_event_log.lgrt_client_id                                     is 'OAuth client ID making the request';
comment on column flow_rest_event_log.lgrt_log_info                                      is 'Supplementary log information';
comment on column flow_rest_event_log.lgrt_token                                         is 'Authentication token identifier';
comment on column flow_rest_event_log.lgrt_timestamp                                     is 'Timestamp of the REST call';
comment on column flow_rest_event_log.lgrt_http_method                                   is 'HTTP method: GET, POST, PUT, DELETE';
comment on column flow_rest_event_log.lgrt_endpoint                                      is 'REST endpoint path called';
comment on column flow_rest_event_log.lgrt_payload                                       is 'Request or response payload';
comment on column flow_rest_event_log.lgrt_error_code                                    is 'HTTP error code if call failed';
comment on column flow_rest_event_log.lgrt_error_msg                                     is 'Error message if call failed';
comment on column flow_rest_event_log.lgrt_error_stacktrace                              is 'Full error stack trace if call failed';

comment on table flow_parser_log                               is 'Log of errors and warnings from BPMN diagram parsing';
comment on column flow_parser_log.plog_id                                            is 'Unique ID for this parser log entry';
comment on column flow_parser_log.plog_dgrm_id                                       is 'Diagram being parsed when entry was created';
comment on column flow_parser_log.plog_bpmn_id                                       is 'BPMN ID of the element associated with this log entry';
comment on column flow_parser_log.plog_log_time                                      is 'Timestamp when log entry was created';
comment on column flow_parser_log.plog_parse_step                                    is 'Parse step where log entry was created';
comment on column flow_parser_log.plog_payload                                       is 'Additional payload or context for this log entry';

comment on table flow_instance_stats                           is 'Summary statistics for process instances aggregated by period';
comment on column flow_instance_stats.stpr_dgrm_id                                       is 'Diagram ID for these statistics';
comment on column flow_instance_stats.stpr_period_start                                  is 'Start date of the statistics period';
comment on column flow_instance_stats.stpr_period                                        is 'Period type: DAY, MTD, MONTH, QUARTER, YEAR';
comment on column flow_instance_stats.stpr_created                                       is 'Count of instances created in period';
comment on column flow_instance_stats.stpr_started                                       is 'Count of instances started in period';
comment on column flow_instance_stats.stpr_error                                         is 'Count of instances that errored in period';
comment on column flow_instance_stats.stpr_completed                                     is 'Count of instances completed in period';
comment on column flow_instance_stats.stpr_terminated                                    is 'Count of instances terminated in period';
comment on column flow_instance_stats.stpr_reset                                         is 'Count of instances reset in period';
comment on column flow_instance_stats.stpr_duration_10pc_ivl                             is '10th percentile instance duration as interval';
comment on column flow_instance_stats.stpr_duration_50pc_ivl                             is '50th percentile instance duration as interval';
comment on column flow_instance_stats.stpr_duration_90pc_ivl                             is '90th percentile instance duration as interval';
comment on column flow_instance_stats.stpr_duration_max_ivl                              is 'Maximum instance duration as interval';
comment on column flow_instance_stats.stpr_duration_10pc_sec                             is '10th percentile instance duration in seconds';
comment on column flow_instance_stats.stpr_duration_50pc_sec                             is '50th percentile instance duration in seconds';
comment on column flow_instance_stats.stpr_duration_90pc_sec                             is '90th percentile instance duration in seconds';
comment on column flow_instance_stats.stpr_duration_max_sec                              is 'Maximum instance duration in seconds';

comment on table flow_step_stats                               is 'Summary statistics for process steps aggregated by period';
comment on column flow_step_stats.stsf_dgrm_id                                       is 'Diagram ID for these statistics';
comment on column flow_step_stats.stsf_objt_bpmn_id                                  is 'BPMN ID of the step object';
comment on column flow_step_stats.stsf_tag_name                                      is 'BPMN element type of the step';
comment on column flow_step_stats.stsf_period_start                                  is 'Start date of the statistics period';
comment on column flow_step_stats.stsf_period                                        is 'Period type: DAY, MTD, MONTH, QUARTER, YEAR';
comment on column flow_step_stats.stsf_completed                                     is 'Count of step completions in period';
comment on column flow_step_stats.stsf_duration_10pc_ivl                             is '10th percentile step duration as interval';
comment on column flow_step_stats.stsf_duration_50pc_ivl                             is '50th percentile step duration as interval';
comment on column flow_step_stats.stsf_duration_90pc_ivl                             is '90th percentile step duration as interval';
comment on column flow_step_stats.stsf_duration_max_ivl                              is 'Maximum step duration as interval';
comment on column flow_step_stats.stsf_duration_10pc_sec                             is '10th percentile step duration in seconds';
comment on column flow_step_stats.stsf_duration_50pc_sec                             is '50th percentile step duration in seconds';
comment on column flow_step_stats.stsf_duration_90pc_sec                             is '90th percentile step duration in seconds';
comment on column flow_step_stats.stsf_duration_max_sec                              is 'Maximum step duration in seconds';
comment on column flow_step_stats.stsf_waiting_10pc_ivl                              is '10th percentile step waiting time as interval';
comment on column flow_step_stats.stsf_waiting_50pc_ivl                              is '50th percentile step waiting time as interval';
comment on column flow_step_stats.stsf_waiting_90pc_ivl                              is '90th percentile step waiting time as interval';
comment on column flow_step_stats.stsf_waiting_max_ivl                               is 'Maximum step waiting time as interval';
comment on column flow_step_stats.stsf_waiting_10pc_sec                              is '10th percentile step waiting time in seconds';
comment on column flow_step_stats.stsf_waiting_50pc_sec                              is '50th percentile step waiting time in seconds';
comment on column flow_step_stats.stsf_waiting_90pc_sec                              is '90th percentile step waiting time in seconds';
comment on column flow_step_stats.stsf_waiting_max_sec                               is 'Maximum step waiting time in seconds';

comment on table flow_stats_history                            is 'History of statistics calculation runs';
comment on column flow_stats_history.sths_id                                            is 'Unique ID for this statistics run record';
comment on column flow_stats_history.sths_date                                          is 'Date statistics were gathered';
comment on column flow_stats_history.sths_status                                        is 'Outcome: SUCCESS or ERROR';
comment on column flow_stats_history.sths_type                                          is 'Period type: DAY, MONTH, MTD, QUARTER, YEAR';
comment on column flow_stats_history.sths_operation                                     is 'Operation performed: calculate, purge, etc.';
comment on column flow_stats_history.sths_errors                                        is 'Error details if statistics run failed';
comment on column flow_stats_history.sths_comments                                      is 'Additional comments on the statistics run';
comment on column flow_stats_history.sths_created_on                                    is 'Timestamp when this record was created';
comment on column flow_stats_history.sths_updated_on                                    is 'Timestamp when this record was last updated';
comment on column flow_stats_history.sths_updated_by                                    is 'User who last updated this record';

comment on table flow_configuration                            is 'Active system configuration settings';
comment on column flow_configuration.cfig_key                                           is 'Configuration parameter name';
comment on column flow_configuration.cfig_value                                         is 'Configuration parameter value';

comment on table flow_messages                                 is 'Localised engine error and warning messages';
comment on column flow_messages.fmsg_message_key                                   is 'Message identifier key';
comment on column flow_messages.fmsg_lang                                          is 'Language code for this message, e.g. en, fr, de';
comment on column flow_messages.fmsg_message_content                               is 'Localised message text in fmsg_lang';

comment on table flow_simple_form_templates                    is 'Templates for simple APEX forms used in user tasks';
comment on column flow_simple_form_templates.sfte_id                                            is 'Unique ID for this form template';
comment on column flow_simple_form_templates.sfte_name                                          is 'Display name of the form template';
comment on column flow_simple_form_templates.sfte_static_id                                     is 'Static identifier used to reference the template in BPMN';
comment on column flow_simple_form_templates.sfte_content                                       is 'Form template definition as strict JSON';

comment on table flow_ai_prompts                               is 'AI prompt templates for Flows for APEX AI features';
comment on column flow_ai_prompts.aipr_id                                            is 'Unique ID for this AI prompt';
comment on column flow_ai_prompts.aipr_prompt_key                                    is 'Prompt identifier key';
comment on column flow_ai_prompts.aipr_lang                                          is 'Language code for this prompt';
comment on column flow_ai_prompts.aipr_provider_type_code                            is 'AI provider type: OCI_GENAI, OPENAI, etc.';
comment on column flow_ai_prompts.aipr_model_name                                    is 'Specific AI model name this prompt applies to';
comment on column flow_ai_prompts.aipr_type                                          is 'Prompt type: system, user, etc.';
comment on column flow_ai_prompts.aipr_title                                         is 'Short title for this prompt';
comment on column flow_ai_prompts.aipr_prompt_text                                   is 'The prompt template text';
comment on column flow_ai_prompts.aipr_display_as_qa                                 is 'Y if prompt should be displayed in Q and A format';

comment on table flow_bpmn_types                               is 'Reference data for BPMN object types supported by the engine';
comment on column flow_bpmn_types.bpmn_code                                          is 'Short code identifier for this BPMN type (primary key)';
comment on column flow_bpmn_types.bpmn_object_name                                   is 'Human-readable name of this BPMN element type';
comment on column flow_bpmn_types.bpmn_tag_name                                      is 'BPMN XML tag name';
comment on column flow_bpmn_types.bpmn_sub_tag_name                                  is 'BPMN XML sub-tag name for specialised element types';
comment on column flow_bpmn_types.bpmn_icon                                          is 'Icon identifier for APEX UI rendering';
comment on column flow_bpmn_types.bpmn_super_type                                    is 'Broad category: event, task, gateway, connection, etc.';
comment on column flow_bpmn_types.bpmn_is_supported                                  is 'Y if this BPMN type is currently supported by the engine';
comment on column flow_bpmn_types.bpmn_interrupting                                  is '1 if this boundary event type is interrupting';


create or replace package flow_constants_pkg
/* 
-- Flows for APEX - flow_constants_pkg.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates. 2022-23.
--
-- Created 2020   Moritz Klein - MT AG  
-- Edited  14-Mar-2022 R Allen, Oracle
--
*/
  authid definer
as

  gc_version constant varchar2(10 char) := '22.2.0';

  gc_true          constant varchar2(1 byte)  := 'Y';
  gc_false         constant varchar2(1 byte)  := 'N';
  gc_vcbool_true   constant varchar2(10 char) := 'true';
  gc_vcbool_false  constant varchar2(10 char) := 'false';
  gc_numbool_true  constant number            := 1;
  gc_numbool_false constant number            := 0;

  gc_nsmap       constant varchar2(200 char) := 'xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"';
  gc_nsbpmn      constant varchar2(200 char) := 'http://www.omg.org/spec/BPMN/20100524/MODEL';
  gc_nsapex      constant varchar2(200 char) := 'https://flowsforapex.org';
  gc_bpmn_prefix constant varchar2(10 char)  := 'bpmn:';
  gc_apex_prefix constant varchar2(10 char)  := 'apex:';

  ge_invalid_session_params   exception;
  pragma exception_init (ge_invalid_session_params, -20987);

  -- BPMN Keys
  gc_bpmn_participant                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'participant';
  gc_bpmn_collaboration                constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'collaboration';
  gc_bpmn_lane_set                     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'laneSet';
  gc_bpmn_child_lane_set               constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'childLaneSet';
  gc_bpmn_lane                         constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'lane';

  gc_bpmn_process                      constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'process';
  gc_bpmn_subprocess                   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'subProcess';
  gc_bpmn_call_activity                constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'callActivity';

  gc_bpmn_start_event                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'startEvent';
  gc_bpmn_end_event                    constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'endEvent';
  gc_bpmn_intermediate_throw_event     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'intermediateThrowEvent';
  gc_bpmn_intermediate_catch_event     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'intermediateCatchEvent';
  gc_bpmn_boundary_event               constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'boundaryEvent';

  gc_bpmn_terminate_event_definition   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'terminateEventDefinition';
  gc_bpmn_error_event_definition       constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'errorEventDefinition';
  gc_bpmn_escalation_event_definition  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'escalationEventDefinition';
  gc_bpmn_link_event_definition        constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'linkEventDefinition';
  gc_bpmn_message_event_definition     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'messageEventDefinition';
  gc_bpmn_conditional_event_definition constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'conditionalEventDefinition';
  gc_bpmn_signal_event_definition      constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'signalEventDefinition';

  gc_bpmn_timer_event_definition       constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timerEventDefinition';
  gc_timer_type_date                   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDate';
  gc_timer_type_duration               constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDuration';
  gc_timer_type_cycle                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeCycle';

  gc_bpmn_object_documentation         constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'documentation';

  gc_bpmn_gateway_exclusive            constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'exclusiveGateway';
  gc_bpmn_gateway_inclusive            constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'inclusiveGateway';
  gc_bpmn_gateway_parallel             constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'parallelGateway';
  gc_bpmn_gateway_event_based          constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'eventBasedGateway';

  gc_bpmn_sequence_flow                constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'sequenceFlow';

  gc_bpmn_task                         constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'task';
  gc_bpmn_usertask                     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'userTask';
  gc_bpmn_servicetask                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'serviceTask';
  gc_bpmn_manualtask                   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'manualTask';
  gc_bpmn_scripttask                   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'scriptTask';
  gc_bpmn_businessruletask             constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'businessRuleTask';
  
  gc_bpmn_text                         constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'text';

  -- APEX Extensions to BPMN
  -- bpmnProcess
  gc_apex_process_workspace           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'workspace';
  gc_apex_process_application_id      constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'applicationId';
  gc_apex_process_page_id             constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageId';
  gc_apex_process_username            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'username';
  
  -- userTask
  gc_apex_usertask_apex_page          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apexPage';
  gc_apex_usertask_apex_approval      constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apexApproval';
  gc_apex_usertask_external_url       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'externalUrl';

  gc_apex_usertask_application_id     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'applicationId';
  gc_apex_usertask_page_id            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageId';
  gc_apex_usertask_request            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'request';
  gc_apex_usertask_cache              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'cache';

  gc_apex_usertask_page_items         constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageItems';
  gc_apex_usertask_item               constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'itemName';
  gc_apex_usertask_value              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'itemValue';

  gc_apex_usertask_url                constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'url';

  gc_apex_usertask_static_id          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'taskStaticId';
  gc_apex_usertask_subject            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'subject';
  gc_apex_usertask_business_ref       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'businessRef';
  gc_apex_usertask_task_comment       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'taskComment';
  gc_apex_usertask_parameters         constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'parameters';

  --serviceTask
  gc_apex_servicetask_send_mail       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'sendMail';

  gc_apex_servicetask_email_from      constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'emailFrom';
  gc_apex_servicetask_email_to        constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'emailTo';
  gc_apex_servicetask_email_cc        constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'emailCC';
  gc_apex_servicetask_email_bcc       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'emailBCC';
  gc_apex_servicetask_email_reply_to  constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'emailReplyTo';
  gc_apex_servicetask_use_template    constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'useTemplate';
  gc_apex_servicetask_application_id  constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'applicationId';
  gc_apex_servicetask_template_id     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'templateId';
  gc_apex_servicetask_placeholder     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'placeholder';
  gc_apex_servicetask_subject         constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'subject';
  gc_apex_servicetask_body_text       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'bodyText';
  gc_apex_servicetask_body_html       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'bodyHTML';
  gc_apex_servicetask_attachment      constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'attachment';
  gc_apex_servicetask_immediately     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'immediately';
   
  -- execute PL/SQL tasks
  gc_apex_task_execute_plsql    constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'executePlsql';

  gc_apex_task_plsql_engine     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'engine';
  gc_apex_task_plsql_code       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'plsqlCode';
  gc_apex_task_plsql_auto_binds constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'autoBinds';

  --terminateEndEvent
  gc_apex_process_status              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'processStatus';

  -- Oracle format timer definitions
  gc_timer_type_oracle_date           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'oracleDate';
  gc_timer_type_oracle_duration       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'oracleDuration';
  gc_timer_type_oracle_cycle          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'oracleCycle';

  gc_apex_timer_date                  constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'date';
  gc_apex_timer_format_mask           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'formatMask';
  gc_apex_timer_interval_ym           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'intervalYM';
  gc_apex_timer_interval_ds           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'intervalDS';
  gc_apex_timer_start_interval_ds     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'startIntervalDS';
  gc_apex_timer_repeat_interval_ds    constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'repeatIntervalDS';
  gc_apex_timer_max_runs              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'maxRuns';

  -- Callable Process Tags
  gc_apex_process_callable            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'isCallable';

  -- callActivity tags
  gc_apex_called_diagram                    constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagram';
  gc_apex_called_diagram_version_selection  constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagramVersionSelection';
  gc_apex_called_diagram_version            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagramVersion';

  -- Diagram calling methods
  gc_dgrm_version_named_version       constant flow_types_pkg.t_bpmn_attributes_key := 'namedVersion';
  gc_dgrm_version_latest_version      constant flow_types_pkg.t_bpmn_attributes_key := 'latestVersion';

  -- Special Keys from FLOW_OBJECTS.OBJT_ATTRIBUTES
  gc_timer_type_key                   constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key                    constant flow_types_pkg.t_bpmn_id := 'timerDefinition';
  
  gc_task_type_key                    constant flow_types_pkg.t_bpmn_id := 'taskType';

  gc_terminate_result                 constant flow_types_pkg.t_bpmn_id := 'processStatus';

  -- Flows 4 APEX Substitution Strings
  gc_substitution_flow_identifier     constant varchar2(10 char)                    := 'F4A$';
  gc_substitution_prefix              constant flow_types_pkg.t_single_vc2          := '&';
  gc_substitution_postfix             constant flow_types_pkg.t_single_vc2          := '.';
  gc_substitution_process_id          constant flow_types_pkg.t_bpmn_attributes_key := 'PROCESS_ID';
  gc_substitution_subflow_id          constant flow_types_pkg.t_bpmn_attributes_key := 'SUBFLOW_ID';
  gc_substitution_step_key            constant flow_types_pkg.t_bpmn_attributes_key := 'STEP_KEY';
  gc_substitution_scope               constant flow_types_pkg.t_bpmn_attributes_key := 'SCOPE';
  gc_substitution_process_priority    constant flow_types_pkg.t_bpmn_attributes_key := 'PROCESS_PRIORITY';
  

  gc_substitution_pattern             constant flow_types_pkg.t_bpmn_attributes_key := gc_substitution_prefix || 'F4A\$([a-zA-Z0-9:\_\-]*)' || gc_substitution_postfix;
  gc_bind_prefix                      constant flow_types_pkg.t_single_vc2          := ':';
  gc_bind_pattern                     constant flow_types_pkg.t_bpmn_attributes_key := gc_bind_prefix || 'F4A\$([a-zA-Z0-9:\_\-]*)';

  -- Diagram Versioning Status
  gc_dgrm_status_draft                constant  varchar2(10 char) := 'draft';
  gc_dgrm_status_released             constant  varchar2(10 char) := 'released';
  gc_dgrm_status_deprecated           constant  varchar2(10 char) := 'deprecated';
  gc_dgrm_status_archived             constant  varchar2(10 char) := 'archived';

  -- Subflow status
  gc_sbfl_status_created              constant  varchar2(20 char) := 'created';
  gc_sbfl_status_running              constant  varchar2(20 char) := 'running';
  gc_sbfl_status_waiting_timer        constant  varchar2(20 char) := 'waiting for timer';
  gc_sbfl_status_waiting_gateway      constant  varchar2(20 char) := 'waiting at gateway';
  gc_sbfl_status_waiting_event        constant  varchar2(20 char) := 'waiting for event';
  gc_sbfl_status_waiting_approval     constant  varchar2(20 char) := 'waiting for approval';
  gc_sbfl_status_proceed_gateway      constant  varchar2(20 char) := 'proceed from gateway';
  gc_sbfl_status_split                constant  varchar2(20 char) := 'split';
  gc_sbfl_status_in_subprocess        constant  varchar2(20 char) := 'in subprocess';
  gc_sbfl_status_in_callactivity      constant  varchar2(20 char) := 'in call activity';
  gc_sbfl_status_error                constant  varchar2(20 char) := 'error';
  gc_sbfl_status_completed            constant  varchar2(20 char) := 'completed';  -- note sbfl deleted after completion

  -- Process Instance Status
  gc_prcs_status_created              constant  varchar2(20 char) := 'created';
  gc_prcs_status_running              constant  varchar2(20 char) := 'running';
  gc_prcs_status_completed            constant  varchar2(20 char) := 'completed';
  gc_prcs_status_terminated           constant  varchar2(20 char) := 'terminated';
  gc_prcs_status_error                constant  varchar2(20 char) := 'error';

  -- Process Instance Events
  gc_prcs_event_created               constant  varchar2(20 char) := gc_prcs_status_created;
  gc_prcs_event_started               constant  varchar2(20 char) := 'started';
  gc_prcs_event_completed             constant  varchar2(20 char) := gc_prcs_status_completed;
  gc_prcs_event_terminated            constant  varchar2(20 char) := gc_prcs_status_terminated;
  gc_prcs_event_reset                 constant  varchar2(20 char) := 'reset';
  gc_prcs_event_error                 constant  varchar2(20 char) := gc_prcs_status_error;
  gc_prcs_event_restart_step          constant  varchar2(20 char) := 'restart step';
  gc_prcs_event_deleted               constant  varchar2(20 char) := 'deleted';
  gc_prcs_event_rescheduled           constant  varchar2(20 char) := 'rescheduled';
  gc_prcs_event_enter_call            constant  varchar2(20 char) := 'start called model';
  gc_prcs_event_leave_call            constant  varchar2(20 char) := 'finish called model';
  gc_prcs_event_priority_set          constant  varchar2(20 char) := 'priority set';
  gc_prcs_event_due_on_set            constant  varchar2(20 char) := 'due on set';

  -- Process Variable Datatypes

  gc_prov_var_type_varchar2           constant  varchar2(50 char) := 'VARCHAR2';
  gc_prov_var_type_date               constant  varchar2(50 char) := 'DATE';
  gc_prov_var_type_number             constant  varchar2(50 char) := 'NUMBER';
  gc_prov_var_type_clob               constant  varchar2(50 char) := 'CLOB';
  gc_prov_var_type_tstz               constant  varchar2(50 char) := 'TIMESTAMP WITH TIME ZONE';

  gc_prov_default_date_format         constant  varchar2(30 char) := 'YYYY-MM-DD HH24:MI:SS';
  gc_prov_default_tstz_format         constant  varchar2(30 char) := 'YYYY-MM-DD HH24:MI:SS TZR';

  -- Standard Process Variables

  gc_prov_builtin_business_ref        constant  varchar2(50 char) := 'BUSINESS_REF';

  -- Standard Process Variable Suffixes

  gc_prov_suffix_task_id              constant  varchar2(50 char) := ':task_id';
  gc_prov_suffix_route                constant  varchar2(50 char) := ':route';  

  -- Process Variable and Gateway Routing Variable Expression Types
  gc_apex_expression constant flow_types_pkg.t_bpmn_attribute_vc2 := 'conditionExpression';

  gc_expr_type_static                   constant flow_types_pkg.t_expr_type := 'static';
  gc_expr_type_proc_var                 constant flow_types_pkg.t_expr_type := 'processVariable';
  gc_expr_type_item                     constant flow_types_pkg.t_expr_type := 'item';
  gc_expr_type_sql                      constant flow_types_pkg.t_expr_type := 'sqlQuerySingle';
  gc_expr_type_sql_delimited_list       constant flow_types_pkg.t_expr_type := 'sqlQueryList';
  gc_expr_type_plsql_function_body      constant flow_types_pkg.t_expr_type := 'plsqlFunctionBody';  -- vc2 typed functionbody (e.g., date returns vc2)
  gc_expr_type_plsql_expression         constant flow_types_pkg.t_expr_type := 'plsqlExpression';    -- vc2 typed expression  (e.g., date returns vc2)
  gc_expr_type_plsql_raw_function_body  constant flow_types_pkg.t_expr_type := 'plsqlRawFunctionBody';  -- raw functionbody  (e.g., date returns date)
  gc_expr_type_plsql_raw_expression     constant flow_types_pkg.t_expr_type := 'plsqlRawExpression';    -- raw expression  (e.g., date returns date)


  gc_date_value_type_date             constant flow_types_pkg.t_expr_type := 'date';
  gc_date_value_type_time_of_day      constant flow_types_pkg.t_expr_type := 'timeOfDay';
  gc_date_value_type_duration         constant flow_types_pkg.t_expr_type := 'duration';
  gc_date_value_type_oracle_scheduler constant flow_types_pkg.t_expr_type := 'oracleScheduler';

-- Process Variable Expression sets and CallActivity in-Out sets
  gc_expr_set_before_task             constant flow_types_pkg.t_expr_set := 'beforeTask';
  gc_expr_set_after_task              constant flow_types_pkg.t_expr_set := 'afterTask';
  gc_expr_set_before_split            constant flow_types_pkg.t_expr_set := 'beforeSplit';
  gc_expr_set_after_merge             constant flow_types_pkg.t_expr_set := 'afterMerge';
  gc_expr_set_before_event            constant flow_types_pkg.t_expr_set := 'beforeEvent';
  gc_expr_set_on_event                constant flow_types_pkg.t_expr_set := 'onEvent';
  gc_expr_set_in_variables            constant flow_types_pkg.t_expr_set := 'inVariables';
  gc_expr_set_out_variables           constant flow_types_pkg.t_expr_set := 'outVariables';

-- ASync Session Parameter Keys

  gc_async_parameter_username          constant flow_types_pkg.t_expr_set := 'username';
  gc_async_parameter_applicationId     constant flow_types_pkg.t_expr_set := 'applicationId';
  gc_async_parameter_pageId            constant flow_types_pkg.t_expr_set := 'pageId';

-- Config Parameter Keys

  gc_config_logging_level               constant varchar2(50 char) := 'logging_level';
  gc_config_logging_hide_userid         constant varchar2(50 char) := 'logging_hide_userid';
  gc_config_logging_language            constant varchar2(50 char) := 'logging_language';
  gc_config_logging_retain_logs         constant varchar2(50 char) := 'logging_retain_logs_after_prcs_completion_days';
  gc_config_logging_archive_location    constant varchar2(50 char) := 'logging_archive_location';
  gc_config_logging_archive_enabled     constant varchar2(50 char) := 'logging_archive_instance_summaries';
  gc_config_engine_app_mode             constant varchar2(50 char) := 'engine_app_mode';
  gc_config_dup_step_prevention         constant varchar2(50 char) := 'duplicate_step_prevention';
  gc_config_timer_max_cycles            constant varchar2(50 char) := 'timer_max_cycles';
  gc_config_default_workspace           constant varchar2(50 char) := 'default_workspace';
  gc_config_default_application         constant varchar2(50 char) := 'default_application';
  gc_config_default_pageid              constant varchar2(50 char) := 'default_pageid';
  gc_config_default_username            constant varchar2(50 char) := 'default_username';
  gc_config_default_email_sender        constant varchar2(50 char) := 'default_email_sender';
  gc_config_stats_retain_summary_daily  constant varchar2(50 char) := 'stats_retain_daily_summaries_days';
  gc_config_stats_retain_summary_month  constant varchar2(50 char) := 'stats_retain_monthly_summaries_months';
  gc_config_stats_retain_summary_qtr    constant varchar2(50 char) := 'stats_retain_quarterly_summaries_months';


-- Config Parameter Valid Values (when not true / false or numeric)

  gc_config_logging_level_none               constant varchar2(2000 char) := 'none';        -- none
  gc_config_logging_level_standard           constant varchar2(2000 char) := 'standard';    -- instances and tasks
  gc_config_logging_level_secure             constant varchar2(2000 char) := 'secure';      -- standard + diagram changes
  gc_config_logging_level_full               constant varchar2(2000 char) := 'full';        -- secure + variable changes
  gc_config_engine_app_mode_dev              constant varchar2(2000 char) := 'development';
  gc_config_engine_app_mode_prod             constant varchar2(2000 char) := 'production';
  gc_config_dup_step_prevention_legacy       constant varchar2(2000 char) := 'legacy';      -- null step key allowed
  gc_config_dup_step_prevention_strict       constant varchar2(2000 char) := 'strict';      -- step key enforced
  gc_config_archive_destination_table        constant varchar2(2000 char) := 'TABLE';       -- To Database Table
  gc_config_archive_destination_oci_api      constant varchar2(2000 char) := 'OCI-API';     -- OCI using API Key
  gc_config_archive_destination_oci_preauth  constant varchar2(2000 char) := 'OCI-PREAUTH'; -- OCI using PreAuth


-- Config Parameter Default Values

  gc_config_default_logging_level               constant varchar2(2000 char) := gc_config_logging_level_standard;
  gc_config_default_logging_hide_userid         constant varchar2(2000 char) := 'false';
  gc_config_default_logging_language            constant varchar2(2000 char) := 'en';
  gc_config_default_logging_archive_enabled     constant varchar2(2000 char) := 'false';
  gc_config_default_engine_app_mode             constant varchar2(2000 char) := 'production';
  gc_config_default_dup_step_prevention         constant varchar2(2000 char) := 'legacy';
  gc_config_default_default_workspace           constant varchar2(2000 char) := 'FLOWS4APEX';
  gc_config_default_default_application         constant varchar2(2000 char) := '100';
  gc_config_default_default_pageID              constant varchar2(2000 char) := '1';
  gc_config_default_default_username            constant varchar2(2000 char) := 'FLOWS4APEX';
  gc_config_default_timer_max_cycles            constant varchar2(2000 char) := '1000';
  gc_config_default_log_retain_logs             constant varchar2(2000 char) := '60';
  gc_config_default_stats_retain_summary_daily  constant varchar2(2000 char) := '180';
  gc_config_default_stats_retain_summary_month  constant varchar2(2000 char) := '9';
  gc_config_default_stats_retain_summary_qtr    constant varchar2(2000 char) := '36';

-- Staistics Period
  gc_stats_period_day                   constant varchar2(20 char) := 'DAY';
  gc_stats_period_month                 constant varchar2(20 char) := 'MONTH';
  gc_stats_period_quarter               constant varchar2(20 char) := 'QUARTER';

  gc_stats_outcome_success              constant varchar2(50 char) := 'SUCCESS';
  gc_stats_outcome_error                constant varchar2(50 char) := 'ERROR';



  -- Default XML for new diagrams
  gc_default_xml constant varchar2(4000) := '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="' || gc_version || '">
<bpmn:process id="Process_#RANDOM_PRCS_ID#" isExecutable="false" />
<bpmndi:BPMNDiagram id="BPMNDiagram_1">
<bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_#RANDOM_PRCS_ID#" />
</bpmndi:BPMNDiagram>
</bpmn:definitions>
';


end flow_constants_pkg;
/

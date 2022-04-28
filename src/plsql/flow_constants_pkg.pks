/* 
-- Flows for APEX - flow_constants_pkg.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates. 2022.
--
-- Created 2020   Moritz Klein - MT AG  
-- Edited  14-Mar-2022 R Allen, Oracle
--
*/
create or replace package flow_constants_pkg
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

  -- BPMN Keys
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
  

  -- APEX Extensions to BPMN
  -- userTask
  gc_apex_usertask_apex_page          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apexPage';
  gc_apex_usertask_external_url       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'externalUrl';

  gc_apex_usertask_application_id     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'applicationId';
  gc_apex_usertask_page_id            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageId';
  gc_apex_usertask_request            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'request';
  gc_apex_usertask_cache              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'cache';

  gc_apex_usertask_page_items          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageItems';
  --gc_apex_usertask_page_item          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'pageItem';
  gc_apex_usertask_item               constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'itemName';
  gc_apex_usertask_value              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'itemValue';

  gc_apex_usertask_url                constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'url';

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

  -- callActivity tags
  gc_apex_called_diagram                    constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagram';
  gc_apex_called_diagram_version_selection  constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagramVersionSelection';
  gc_apex_called_diagram_version            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'calledDiagramVersion';

  -- Diagram calling methods
  gc_dgrm_version_named_version       constant flow_types_pkg.t_bpmn_attributes_key := 'namedVersion';
  gc_dgrm_version_latest_version      constant flow_types_pkg.t_bpmn_attributes_key := 'latestVersion';

  -- Special Keys from FLOW_OBJECT_ATTRIBUTES
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
  gc_substitution_pattern             constant flow_types_pkg.t_bpmn_attributes_key := gc_substitution_prefix || 'F4A\$(\w*)\.';

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
  gc_prcs_event_created              constant  varchar2(20 char) := gc_prcs_status_created;
  gc_prcs_event_started              constant  varchar2(20 char) := 'started';
  gc_prcs_event_completed            constant  varchar2(20 char) := gc_prcs_status_completed;
  gc_prcs_event_terminated           constant  varchar2(20 char) := gc_prcs_status_terminated;
  gc_prcs_event_reset                constant  varchar2(20 char) := 'reset';
  gc_prcs_event_error                constant  varchar2(20 char) := gc_prcs_status_error;
  gc_prcs_event_restart_step         constant  varchar2(20 char) := 'restart step';
  gc_prcs_event_deleted              constant  varchar2(20 char) := 'deleted';
  gc_prcs_event_rescheduled          constant  varchar2(20 char) := 'rescheduled';

  -- Process Variable Datatypes

  gc_prov_var_type_varchar2           constant  varchar2(50 char) := 'VARCHAR2';
  gc_prov_var_type_date               constant  varchar2(50 char) := 'DATE';
  gc_prov_var_type_number             constant  varchar2(50 char) := 'NUMBER';
  gc_prov_var_type_clob               constant  varchar2(50 char) := 'CLOB';

  gc_prov_default_date_format         constant  varchar2(30 char) := 'YYYY-MM-DD HH24:MI:SS';

  -- Standard Process Variables

  gc_prov_builtin_business_ref        constant  varchar2(50 char) := 'BUSINESS_REF';

  -- Process Variable Expression Types
  gc_expr_type_static                 constant flow_types_pkg.t_expr_type := 'static';
  gc_expr_type_proc_var               constant flow_types_pkg.t_expr_type := 'processVariable';
  gc_expr_type_item                   constant flow_types_pkg.t_expr_type := 'item';
  gc_expr_type_sql                    constant flow_types_pkg.t_expr_type := 'sqlQuerySingle';
  gc_expr_type_sql_delimited_list     constant flow_types_pkg.t_expr_type := 'sqlQueryList';
  gc_expr_type_plsql_function_body    constant flow_types_pkg.t_expr_type := 'plsqlFunctionBody';
  gc_expr_type_plsql_expression       constant flow_types_pkg.t_expr_type := 'plsqlExpression';

-- Process Variable Expression sets and CallActivity in-Out sets
  gc_expr_set_before_task             constant flow_types_pkg.t_expr_set := 'beforeTask';
  gc_expr_set_after_task              constant flow_types_pkg.t_expr_set := 'afterTask';
  gc_expr_set_before_split            constant flow_types_pkg.t_expr_set := 'beforeSplit';
  gc_expr_set_after_merge             constant flow_types_pkg.t_expr_set := 'afterMerge';
  gc_expr_set_before_event            constant flow_types_pkg.t_expr_set := 'beforeEvent';
  gc_expr_set_on_event                constant flow_types_pkg.t_expr_set := 'onEvent';
  gc_expr_set_in_variables            constant flow_types_pkg.t_expr_set := 'inVariables';
  gc_expr_set_out_variables           constant flow_types_pkg.t_expr_set := 'outVariables';

-- Config Parameter Keys

  gc_config_logging_level             constant varchar2(50 char) := 'logging_level';
  gc_config_logging_hide_userid       constant varchar2(50 char) := 'logging_hide_userid';
  gc_config_logging_language          constant varchar2(50 char) := 'logging_language';
  gc_config_engine_app_mode           constant varchar2(50 char) := 'engine_app_mode';
  gc_config_dup_step_prevention       constant varchar2(50 char) := 'duplicate_step_prevention';
  gc_config_timer_max_cycles          constant varchar2(50 char) := 'timer_max_cycles';

-- Config Parameter Valid Values (when not true / false or numeric)

  gc_config_logging_level_none        constant varchar2(2000 char) := 'none';      -- none
  gc_config_logging_level_standard    constant varchar2(2000 char) := 'standard';  -- instances and tasks
  gc_config_logging_level_secure      constant varchar2(2000 char) := 'secure';    -- standard + diagram changes
  gc_config_logging_level_full        constant varchar2(2000 char) := 'full';      -- secure + variable changes
  gc_config_engine_app_mode_dev       constant varchar2(2000 char) := 'development';
  gc_config_engine_app_mode_prod      constant varchar2(2000 char) := 'production';
  gc_config_dup_step_prevention_legacy constant varchar2(2000 char) := 'legacy';   -- null step key allowed
  gc_config_dup_step_prevention_strict constant varchar2(2000 char) := 'strict';   -- step key enforced


-- Config Parameter Default Values

  gc_config_default_logging_level             constant varchar2(2000 char) := gc_config_logging_level_standard;
  gc_config_default_logging_hide_userid       constant varchar2(2000 char) := 'false';
  gc_config_default_logging_language          constant varchar2(2000 char) := 'en';
  gc_config_default_engine_app_mode           constant varchar2(2000 char) := 'production';
  gc_config_default_dup_step_prevention       constant varchar2(2000 char) := 'legacy';
  gc_config_default_default_workspace         constant varchar2(2000 char) := 'FLOWS4APEX';
  gc_config_default_timer_max_cycles          constant varchar2(2000 char) := '1000';


  -- Default XML for new diagrams
  gc_default_xml constant varchar2(4000) := '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="' || gc_version || '">
<bpmn:process id="Process_0rxermh" isExecutable="false" />
<bpmndi:BPMNDiagram id="BPMNDiagram_1">
<bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_0rxermh" />
</bpmndi:BPMNDiagram>
</bpmn:definitions>
';


end flow_constants_pkg;
/

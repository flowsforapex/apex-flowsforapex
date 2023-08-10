PROMPT >> Add Timestamp with Time Zone Process Variable type

PROMPT >> Add new timestamp column to flow_process_variables and logging table
alter table flow_process_variables add  ( prov_var_tstz      timestamp with time zone );
alter table flow_variable_event_log add ( lgvr_var_tstz      timestamp with time zone );

PROMPT >> Add Due Dates, Priorities and Task Assignment
alter table flow_processes add (
    prcs_due_on         TIMESTAMP WITH TIME ZONE,
    prcs_priority       NUMBER);

alter table flow_subflows add (
    sbfl_due_on           TIMESTAMP WITH TIME ZONE,
    sbfl_priority         NUMBER,
    sbfl_potential_users  VARCHAR2(4000 CHAR),
    sbfl_potential_groups VARCHAR2(4000 CHAR),
    sbfl_excluded_users   VARCHAR2(4000 CHAR),
    sbfl_lane_isRole      VARCHAR2(10 CHAR), /*cannot always be looked up with callActivities so must include */
    sbfl_lane_role        VARCHAR2(200 CHAR) /*cannot always be looked up with callActivities so must include */
    );

alter table flow_step_event_log add (
   lgsf_due_on               TIMESTAMP WITH TIME ZONE, 
   lgsf_priority             NUMBER);
   
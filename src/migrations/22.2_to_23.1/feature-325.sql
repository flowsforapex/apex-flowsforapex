

 -- add completed_ts column to flow_processes

 alter table flow_processes
 add (
  prcs_start_ts      timestamp with time zone,
  prcs_complete_ts   timestamp with time zone,
  prcs_archived_ts   timestamp with time zone
 );

 comment on column flow_processes.prcs_complete_ts is 
 'Timestamp for process end when instance is in states "completed" or "terminated".';

  comment on column flow_processes.prcs_start_ts is 
 'Timestamp for process start.  Resets if process instance is reset.';

  comment on column flow_processes.prcs_archived_ts is 
 'Timestamp for process archive.  Resets if process instance is reset. ';

 alter table flow_instance_event_log 
 add ( lgpr_duration interval day(3) to second (3));

 -- approximate start_ts to instance creation_ts.   accurate unless instance has been reset
 -- so should be good approximation for any production systems.

 update flow_processes
    set prcs_start_ts = prcs_init_ts 
  where prcs_start_ts is null
    and prcs_status != 'created';

-- create table flow_stats_history

create table flow_stats_history
( sths_id         number GENERATED always AS IDENTITY ( START WITH 1 NOCACHE ORDER ) not null
, sths_date       date
, sths_status     varchar2(50 char)
, sths_type       varchar2(20 char)
, sths_operation  varchar2(20 char)
, sths_errors     varchar2(4000 char)
, sths_comments   varchar2(4000 char)
, sths_created_on systimestamp with time zone
, sths_updated_on systimestamp with time zone
, sths_updated_by varchar2(50 char)
);

create index flow_sths_ix on flow_stats_history (sths_date);

alter table flow_stats_history
  add constraint flow_sths_pk
    primary key (sths_id)
;

alter table flow_stats_history
  add constraint flow_sths_status_ck
    check (sths_status in ('SUCCESS', 'ERROR') );

alter table flow_stats_type
  add constraint flow_sths_type_ck
    check (sths_type in ('DAY', 'MONTH', 'MTD', 'QUARTER', 'YEAR') );

-- add stats tables

create table flow_instance_stats
( stpr_dgrm_id              number
, stpr_period_start         date
, stpr_period               varchar2(10 char)
, stpr_created              number
, stpr_started              number
, stpr_error                number
, stpr_completed            number
, stpr_terminated           number
, stpr_reset                number
, stpr_duration_10pc_ivl    interval day(3) to second(0)
, stpr_duration_50pc_ivl    interval day(3) to second(0)
, stpr_duration_90pc_ivl    interval day(3) to second(0)
, stpr_duration_max_ivl     interval day(3) to second(0)
, stpr_duration_10pc_sec    number
, stpr_duration_50pc_sec    number
, stpr_duration_90pc_sec    number
, stpr_duration_max_sec     number
);

create unique index flow_stpr_ux on flow_instance_stats (stpr_dgrm_id, stpr_period, stpr_period_start);

alter table flow_instance_stats
    add constraint flow_stpr_period_type_ck
      check ( stpr_period in ('DAY' ,'MONTH', 'MTD', 'QUARTER','YEAR') );

create table flow_step_stats
( stsf_dgrm_id             number
, stsf_objt_bpmn_id        varchar2(50 char)
, stsf_tag_name            varchar2(50 char)
, stsf_period_start        date
, stsf_period              varchar2(10 char)
, stsf_completed           number
, stsf_duration_10pc_ivl   interval day(3) to second(3)
, stsf_duration_50pc_ivl   interval day(3) to second(3)
, stsf_duration_90pc_ivl   interval day(3) to second(3)
, stsf_duration_max_ivl    interval day(3) to second(3)
, stsf_duration_10pc_sec   number
, stsf_duration_50pc_sec   number
, stsf_duration_90pc_sec   number
, stsf_duration_max_sec    number
, stsf_waiting_10pc_ivl    interval day(3) to second(3)
, stsf_waiting_50pc_ivl    interval day(3) to second(3)
, stsf_waiting_90pc_ivl    interval day(3) to second(3)
, stsf_waiting_max_ivl     interval day(3) to second(3)
, stsf_waiting_10pc_sec    number
, stsf_waiting_50pc_sec    number
, stsf_waiting_90pc_sec    number
, stsf_waiting_max_sec     number
);

create unique index flow_stsf_ux on flow_step_stats (stsf_dgrm_id, stsf_objt_bpmn_id, stsf_period, stsf_period_start);

alter table flow_step_stats
    add constraint flow_stsf_period_type_ck
      check ( stsf_period in ('DAY' , 'MTD', 'MONTH', 'QUARTER','YEAR') );

-- add flow_instance_timeline views

-- add retention config

  insert into flow_configuration (cfig_key, cfig_value) values ('logging_retain_logs_after_prcs_completion_days','60');
  insert into flow_configuration (cfig_key, cfig_value) values ('logging_archive_instance_summaries','false');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_daily_summaries_days','185');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_monthly_summaries_months','9');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_quarterly_summaries_months','60');

-- modify flow_flow_event_log

  alter table flow_flow_event_log 
    drop column lgfl_dgrm_content;

  alter table flow_flow_event_log
    add ( lgfl_dgrm_archive_location  varchar2(2000));

  alter table flow_flow_event_log
    modify 
    ( lgfl_dgrm_name null
    , lgfl_dgrm_status null
    , lgfl_dgrm_version null
    );
    
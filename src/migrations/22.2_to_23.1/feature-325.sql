

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
( sths_id       number GENERATED always AS IDENTITY ( START WITH 1 NOCACHE ORDER ) not null
, sths_date     date
, sths_status   varchar2(50 char)
, sths_type     varchar2(20 char)
, sths_errors   varchar2(4000 char)
, sths_comments varchar2(4000 char)
, sths_created_on systimestamp with time zone
, sths_updated_on systimestamp with time zone
, sths_updated_by varchar2(50 char)
);

create index flow_sths_ix on flow_stats_history (sths_date);

alter table flow_stats_history
  add constraint check_sths_status
    check (sths_status in ('SUCCESS', 'ERROR') );

alter table flow_stats_type
  add constraint check_sths_type
    check (sths_type in ('DAY', 'MONTH', 'QUARTER') );

-- add stats tables

-- add flow_instance_timeline views

-- add retention config

  insert into flow_configuration (cfig_key, cfig_value) values ('logging_retain_logs_after_prcs_completion_days','60');
  insert into flow_configuration (cfig_key, cfig_value) values ('logging_archive_instance_summaries','false');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_daily_summaries_days','185');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_monthly_summaries_months','9');
  insert into flow_configuration (cfig_key, cfig_value) values ('stats_retain_quarterly_summaries_months','60');
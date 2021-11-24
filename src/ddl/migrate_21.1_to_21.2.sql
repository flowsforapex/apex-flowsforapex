/*
  Migration Script for Release 21.1 to 21.2
*/

PROMPT >> Running DDL for Upgrade from 21.1 to 21.2
PROMPT >> -------------------------------------------

PROMPT >> Remove obsolete objects

PROMPT >> Create new tables

PROMPT >> Modify existing tables

ALTER TABLE flow_subflows add  sbfl_step_key varchar2(20);
ALTER TABLE flow_timers add  timr_step_key varchar2(20);
ALTER TABLE flow_timers add timr_run default 0 number;

PROMPT >> Data migration

-- create step keys for all subflows present, then make step_key not null
update flow_subflows 
   set sbfl_step_key = substr ( apex_util.get_hash ( apex_t_varchar2 ( sbfl_id, sbfl_current, sbfl_became_current))
                              , 1 , 10);

alter table flow_subflows modify (sbfl_step_key not null); 

-- put migrated systems into legacy mode for step keys
insert into flow_configuration (cfig_key, cfig_value) values ('duplicate_step_prevention','legacy');
insert into flow_configuration (cfig_key, cfig_value) values ('version_initial_installed','unknown');
insert into flow_configuration (cfig_key, cfig_value) values ('version_now_installed','21.2');

-- migrate table flow_timers to modify PK

update table flow_timers
set timr_run = 0;

alter table flow_timers modify (timr_run not null); 
alter table flow_timers drop constraint timr_pk;
alter table flow_timers add constraint timr_pk primary key (timr_id, timr_run);
/

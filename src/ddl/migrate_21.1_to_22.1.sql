/*
  Migration Script for Release 21.1 to 22.1
*/

PROMPT >> Running Upgrade from 21.1 to 22.1
PROMPT >> -------------------------------------------

PROMPT >> Removing obsolete objects
drop package flow_p0005_api;
drop package flow_p0006_api;
drop package flow_p0007_api;


PROMPT >> Step Key for Subflows
begin
  execute immediate 'alter table flow_subflows add  sbfl_step_key varchar2(20)';

  execute immediate q'[update flow_subflows set sbfl_step_key = sys.dbms_random.string('A', 10)]';
  commit;

  execute immediate 'alter table flow_subflows modify (sbfl_step_key not null)';
end;
/

PROMPT >> Step Key and Run Counter for Timers
begin
  execute immediate 'alter table flow_timers add  timr_step_key varchar2(20)';
  execute immediate 'alter table flow_timers add timr_run number default 1';

  execute immediate 'update flow_timers set timr_run = 1, timr_step_key = ( select sbfl_step_key from flow_subflows where sbfl_id = timr_sbfl_id )';
  commit;

  execute immediate 'alter table flow_timers modify (timr_run not null)';
  execute immediate 'alter table flow_timers drop constraint timr_pk';
  execute immediate 'alter table flow_timers add constraint timr_pk primary key (timr_id, timr_run)';
end;
/

PROMPT >> Issue #360 - Remove Orphan Process Variables and add cascading FK
begin
  delete
    from flow_process_variables
   where prov_prcs_id not in ( select prcs_id from flow_processes )
  ;
  commit;

  execute immediate 'alter table flow_process_variables add constraint prov_prcs_fk foreign key (prov_prcs_id) references flow_processes (prcs_id) on delete cascade';
end;
/

PROMPT >> Add new Flow Configuration Settings ( Duplicate Step Prevention = legacy for migrated systems )
begin
  insert into flow_configuration (cfig_key, cfig_value) values ('duplicate_step_prevention','legacy');
  insert into flow_configuration (cfig_key, cfig_value) values ('version_initial_installed','unknown');
  insert into flow_configuration (cfig_key, cfig_value) values ('version_now_installed','22.1');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_workspace', 'FLOWS4APEX');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_email_sender', '');
  insert into flow_configuration (cfig_key, cfig_value) values ('timer_max_cycles','1000');
  commit;
end;
/

PROMPT >> Finished Upgrade from 21.1 to 22.1

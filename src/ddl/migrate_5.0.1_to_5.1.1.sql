/*
  Migration Script for Release 5.0.1 to 5.1.1
*/

whenever sqlerror exit rollback

PROMPT >> Running DDL for Upgrade from 5.0.1 to 5.1.1
PROMPT >> -------------------------------------------

PROMPT >> Modify Table FLOW_DIAGRAMS
alter table flow_diagrams add dgrm_version  varchar2(10 char) default '0' not null;
alter table flow_diagrams add dgrm_status   varchar2(10 char) default 'draft' not null;
alter table flow_diagrams add dgrm_category varchar2(30 char);

alter table flow_diagrams add dgrm_last_update timestamp with time zone;
update flow_diagrams
   set dgrm_last_update = systimestamp
;
alter table flow_diagrams modify dgrm_last_update not null;
alter table flow_diagrams modify dgrm_last_update default systimestamp;

alter table flow_diagrams drop constraint dgrm_uk;

alter table flow_diagrams add constraint dgrm_uk unique ( dgrm_name , dgrm_version);

alter table flow_diagrams add constraint dgrm_status_ck check ( dgrm_status in ('draft','released','deprecated','archived'));

create unique index dgrm_uk2 on flow_diagrams ( dgrm_name, case dgrm_status when 'released' then null else dgrm_version end );

PROMPT >> Modify Table FLOW_PROCESSES
alter table flow_processes drop constraint prcs_dgrm_fk;
alter table flow_processes add constraint prcs_dgrm_fk foreign key (prcs_dgrm_id) references flow_diagrams (dgrm_id) enable;

PROMPT >> Modify Table FLOW_PROCESS_VARIABLES
alter table flow_process_variables modify ( prov_var_vc2 varchar2(4000 char) );

PROMPT >> Remove obsolete objects
drop view flow_diagrams_lov;

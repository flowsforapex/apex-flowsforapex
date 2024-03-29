/*
  Migration Script for Feature CallActivities

  Created RAllen  25 Feb 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/

PROMPT >> Prepare for Call Activities

PROMPT >> Prepare Expressions for Call Activity In-Out Parameters

-- change constraint on flow_object_expressions to add 'inVariables' and 'outVariables'

ALTER TABLE flow_object_expressions
    drop CONSTRAINT expr_set_ck;

ALTER TABLE flow_object_expressions
    ADD CONSTRAINT expr_set_ck
      CHECK ( expr_set in ('beforeEvent', 'onEvent', 'beforeTask', 'afterTask', 'beforeSplit', 'afterMerge', 'inVariables', 'outVariables') );

PROMPT >> Prepare Subflow table for Call Activities


  alter table flow_subflows
  add (
    sbfl_calling_sbfl   number,
    sbfl_scope          number,
    sbfl_diagram_level  number,
    sbfl_lane           varchar2(50 char),
    sbfl_lane_name      varchar2(200 char)
  );

-- migration

  update flow_subflows   
  set sbfl_scope = 0
    , sbfl_diagram_level = 0;

 /* Migrating existing instances with subProcess calls is required now sbfl_calling_sbfl is set for subProcesses and callActivities.  
 -  existing subflows where the process_level != 0, need to set the sbfl_calling_sbfl to the calling sbfl
 -- its only for subproceses, as we won't have any call activities to migrate -- so we can get this with the right query on the objects / connections
 */

  -- set sbfl_calling_sbfl
  -- first for subflows in top level - so not in a subprocess...
  update flow_subflows
  set sbfl_calling_sbfl = 0
  where sbfl_process_level = 0;
  -- now for subflows inside a subprocess...
  update flow_subflows s
  set s.sbfl_calling_sbfl = 
     ( select par_sbfl.sbfl_id 
        from flow_objects cur_objt
        join flow_objects par_objt
          on par_objt.objt_id      = cur_objt.objt_objt_id
         and par_objt.objt_dgrm_id = cur_objt.objt_dgrm_id
        join flow_processes prcs
          on prcs.prcs_dgrm_id = cur_objt.objt_dgrm_id
        join flow_subflows cur_sbfl
          on nvl(cur_sbfl.sbfl_current, cur_sbfl.sbfl_last_completed) = cur_objt.objt_bpmn_id
         and cur_sbfl.sbfl_prcs_id = prcs.prcs_id
        join flow_subflows par_sbfl
          on par_sbfl.sbfl_prcs_id = prcs.prcs_id
         and par_sbfl.sbfl_current = par_objt.objt_bpmn_id
       where par_sbfl.sbfl_status   = 'in subprocess'
         and par_objt.objt_tag_name = 'bpmn:subProcess'
         and cur_sbfl.sbfl_process_level != 0
         and cur_sbfl.sbfl_id = s.sbfl_id)
  where s.sbfl_process_level != 0;

  -- now set lane and lane name using flow_objects BEFORE it is reparsed
  -- in 22.1 this was all just taken from flow_objects as a join with flow_subflows in flow_task_inbox_vw
  -- but with callActivities, the engine needs to keep track of lanes and lane names on each process step
  -- we need to get the object lane names FROM THE 22.1 CATALOG BEFORE WE REPARSE the diagrams.
  update flow_subflows s
   set (s.sbfl_lane, s.sbfl_lane_name) = (
        select lane.objt_bpmn_id , lane.objt_name 
          from flow_subflows sbfl
          join flow_processes prcs
            on prcs.prcs_id = sbfl.sbfl_prcs_id
          join flow_objects objt
            on objt.objt_dgrm_id = prcs.prcs_dgrm_id
           and objt.objt_bpmn_id = nvl(sbfl.sbfl_current, sbfl.sbfl_last_completed)
     left join flow_objects lane
            on objt.objt_objt_lane_id = lane.objt_id
         where sbfl.sbfl_id = s.sbfl_id);

 /* 
Is it possible to reliably run a script BEFORE we change the DML?  I’m thinking that we should:
- Stop the engine for customer transactions & stop the scheduler.
- Make a copy of Flow_objects, or create a table as select objt_bpmn_id, corresponding lane bpmn_id for all objects.
- Do the upgrade, which will add flow_subflows.sbfl_lane 
- Re-parse all diagrams (we were going to do that anyhow for AJAX.   We need to do that for lanes now as well!)
- Populate sbfl_lanes for existing subflows using the copy of flow_objects from before the update.
- Any other migration.
- Restart the engine and scheduler
- Carry on running…
*/
PROMPT >> Prepare Subflow Log for Call Activities

  begin
    execute immediate '
      alter table flow_subflow_log
      add (
        sflg_dgrm_id       NUMBER,
        sflg_diagram_level NUMBER
      )';
  end;
  /

  update flow_subflow_log l
  set l.sflg_diagram_level = 0,
      l.sflg_dgrm_id = ( select prcs.prcs_dgrm_id
                         from   flow_processes prcs
                         where  prcs.prcs_id = l.sflg_prcs_id );

PROMPT >> Prepare Instance Diagrams table (PRDG)

  CREATE TABLE flow_instance_diagrams (
    prdg_id             NUMBER GENERATED BY DEFAULT AS IDENTITY ( START WITH 1 NOCACHE ORDER )
                        NOT NULL,
    prdg_prdg_id        NUMBER,                    
    prdg_prcs_id        NUMBER NOT NULL,
    prdg_dgrm_id        NUMBER NOT NULL,
    prdg_calling_dgrm   NUMBER,
    prdg_calling_objt   VARCHAR2(50 CHAR),
    prdg_diagram_level  NUMBER
);

COMMENT ON COLUMN flow_instance_diagrams.prdg_prdg_id is
    'Parent prdg_id (prdg_id of Calling Diagram)';

ALTER TABLE flow_instance_diagrams
    ADD CONSTRAINT prdg_prcs_fk FOREIGN KEY ( prdg_prcs_id )
        REFERENCES flow_processes ( prcs_id )
            ON DELETE CASCADE;

ALTER TABLE flow_instance_diagrams
    ADD CONSTRAINT prdg_dgrm_fk FOREIGN KEY ( prdg_dgrm_id )
        REFERENCES flow_diagrams ( dgrm_id );

ALTER TABLE flow_instance_diagrams
    ADD CONSTRAINT prdg_calling_dgrm_fk FOREIGN KEY ( prdg_calling_dgrm )
        REFERENCES flow_diagrams ( dgrm_id );

-- add a row into here for each existing instance (all of which don't have callactivities)

insert into flow_instance_diagrams 
( prdg_prcs_id
, prdg_dgrm_id
, prdg_diagram_level
)
select prcs.prcs_id
     , prcs.prcs_dgrm_id
     , 0
from flow_processes prcs
;


PROMPT >> Prepare Process Variables for Scoping 

  alter table flow_process_variables
  add ( prov_scope number );

  alter table flow_variable_event_log
  add ( lgvr_scope number);

  update flow_process_variables prov
     set prov.prov_scope = 0;

  update flow_variable_event_log lgvr
     set lgvr.lgvr_scope = 0;

  alter table flow_process_variables
    modify ( prov_scope not null);

  alter table flow_variable_event_log
    modify ( lgvr_scope not null);

 -- NOTE primary key on flow_process_variables is recreated as part of issue-77.sql migration script

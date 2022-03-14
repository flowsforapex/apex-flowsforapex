/*
  Migration Script for Release 22.1 to 22.2

  Created RAllen  25 Feb 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.
  
*/

PROMPT >> Running Upgrade from 22.1 to 22.2
PROMPT >> -------------------------------------------

PROMPT >> Prepare Subflows for Call Activities

-- change constraint on flow_object_expressions to add 'inVariables' and 'outVariables'
/*ALTER TABLE flow_object_expressions
    ADD CONSTRAINT expr_set_ck
      CHECK ( expr_set in ('beforeEvent', 'onEvent', 'beforeTask', 'afterTask', 'beforeSplit', 'afterMerge') );
*/

begin
  execute immediate '
    alter table flow_subflows
    add (
      sbfl_calling_sbfl   number,
      sbfl_scope          number,
      sbfl_diagram_level  number
    )' 
  ;

  update flow_subflows   --- needs more work - see below
  set sbfl_calling_sbfl = 0 
    , sbfl_scope = 0;
end;
/* Migrating existing instances with subProcess calls is a problem now sbfl_calling_sbfl is set for subProcesses and callActivities.  
 - we will need to step through existing prcesses where the process_level != 0, and set the sbfl_calling_sbfl to the calling sbfl
 -- its only for subproceses, as we won't have any call activities to migrate -- so we can get this with the right query on the objects / connections
 */

  begin
    execute immediate '
      alter table flow_subflow_log
      add (
        sflg_dgrm_id       NUMBER,
        sflg_diagram_level NUMBER,
        sflg_calling_objt  VARCHAR2(50) -- only used on Start Eevents to record Parent
      )';
  end;

-- need to add migration
-- need to set not nulls as appropriate once migrated

PROMPT >> Finished Upgrade from 22.1 to 22.2

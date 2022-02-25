/*
  Migration Script for Release 22.1 to 22.2
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
  alter table flow_subflows
  add (
    sbfl_calling_sbfl number,
    sbfl_scope        number
  );

  update flow_subflows   --- needs more work - see below
  set sbfl_calling_sbfl = 0 
    , sbfl_scope = 0;
end;
/* Migrating existing instances with subProcess calls is a problem now sbfl_calling_sbfl is set for subProcesses and callActivities.  
 - we will need to step through existing prcesses where the process_level != 0, and set the sbfl_calling_sbfl to the calling sbfl
 -- its only for subproceses, as we won't have any call activities to migrate -- so we can get this with the right query on the objects / connections
 */


PROMPT >> Finished Upgrade from 22.1 to 22.2

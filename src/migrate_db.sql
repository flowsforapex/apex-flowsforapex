set define '^'
set concat '.'

define from_version = ^1.
define to_version   = ^2.

PROMPT >> Pre Migration Checks
@migrations/^from_version._to_^to_version./premigrate.sql

PROMPT >> Halt DBMS_SCHEDULER job 
/* TODO Implement Job disabling */


PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> DDL and Data Migration
@migrations/^from_version._to_^to_version./migrate.sql

PROMPT >> Common Objects
@common_db.sql

PROMPT >> Reparse all Diagrams so everything fits to current Flows Version
@parse_all_diagrams.sql

PROMPT >> Checking for invalid Objects
  select object_type || ': ' || object_name as invalid_object
    from user_objects
   where status = 'INVALID'
order by object_type
       , object_name
;

PROMPT >> Resume DBMS_SCHEDULER job
/* TODO Implement Job enabling AFTER RE-PARSE*/

PROMPT >> =====================
PROMPT >> Upgrade Finished
PROMPT >> =====================

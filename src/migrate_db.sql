set define '^'
set concat '.'

define from_version = ^1.
define to_version   = ^2.

PROMPT >> Pre Migration Checks
@migrations/^from_version._to_^to_version./premigrate.sql

PROMPT >> Halt DBMS_SCHEDULER job 
begin
  flow_timers_pkg.disable_scheduled_job;
end;
/

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> DDL and Data Migration
@migrations/^from_version._to_^to_version./migrate.sql

PROMPT >> Update Common Objects
@common_db.sql
PROMPT >> Update Comments
@ddl/install_ddl_comments.sql

PROMPT >> Reparse all Diagrams so everything fits to current Flows Version
@parse_all_diagrams.sql

PROMPT >> Checking for invalid Objects
  select object_type || ': ' || object_name as invalid_object
    from user_objects
   where status = 'INVALID'
order by object_type
       , object_name
;

PROMPT >> Enable DBMS_SCHEDULER job 
begin
  flow_timers_pkg.enable_scheduled_job;
end;
/

PROMPT >> Please make sure your Flows for APEX installation configuration is correct.
PROMPT >> Check our migration guide in the docs for any post-installation tasks.

PROMPT >> =====================
PROMPT >> Upgrade Finished
PROMPT >> =====================

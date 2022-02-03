set define '^'
set concat '.'

define from_version = ^1.
define to_version   = ^2.

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> DDL and Data Migration
@ddl/migrate_^from_version._to_^to_version..sql
PROMPT >> Common Objects
@common_db.sql

PROMPT >> Checking for invalid Objects
  select object_type || ': ' || object_name as invalid_object
    from user_objects
   where status = 'INVALID'
order by object_type
       , object_name
;

PROMPT >> =====================
PROMPT >> Upgrade Finished
PROMPT >> =====================

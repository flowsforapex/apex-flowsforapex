set define '^'
set concat '.'

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_scratch.sql

PROMPT >> Installing Schema Level Types
@types/flow_t_correlated_message.sql

PROMPT >> Common Objects
@common_db.sql
PROMPT >> Adding Comments
@ddl/install_ddl_comments.sql

PROMPT >> Adding Schema Annotations (requires Oracle 19.28+ or 23ai)
column ann_cmd new_value ann_cmd noprint
select case
         when dbms_db_version.version >= 23 then
           '@ddl/install_ddl_annotations.sql'
         when dbms_db_version.version = 19
              and nvl(to_number(regexp_substr(dbms_db_version.version_full, '[0-9]+', 1, 2)), 0) >= 28 then
           '@ddl/install_ddl_annotations.sql'
         else
           'prompt >> Skipping schema annotations on this Oracle version'
       end as ann_cmd
  from dual;
^ann_cmd.
whenever sqlerror exit rollback

PROMPT >> Installing Database Scheduler Objects
@ddl/create_scheduler_objects.sql

PROMPT >> Initial Engine Configuration
PROMPT >> =============================
PROMPT >> 
@data/install_default_config_data.sql

PROMPT >> Checking for invalid Objects
  select object_type || ': ' || object_name as invalid_object
    from user_objects
   where status = 'INVALID'
order by object_type
       , object_name
;

PROMPT >> =====================
PROMPT >> Installation Finished
PROMPT >> =====================

set define '^'
set concat '.'

PROMPT >> Database Objects Installation
PROMPT >> =============================

PROMPT >> Installing Tables
@ddl/install_scratch.sql
PROMPT >> Common Objects
@common_db.sql

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

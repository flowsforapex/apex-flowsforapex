/*
  Migration Script for Release 25.1 to 26.1

  Created  Richard Allen, Flowquest    10 Nov 2025

  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/

PROMPT >> Checking that Schema can be Upgraded from 25.1 to 26.1
PROMPT >> ------------------------------------------------------

-- wrap test query in pl/sql that raises exception if any rows returned


PROMPT >> Running Schema Upgrade from 25.1 to 26.1
PROMPT >> -------------------------------------------

@@feature-adhoc-subprocs.sql

PROMPT >> Adding Schema Annotations (requires Oracle 19.28+ or 23ai)
-- note this is only required for 25.1 to 261 upgrade. For subsequent migrations, use replace. Note Oracle 19c bug on ADD OR REPLACE of annotations which complicates this.
-- run this as last feature migration.
column ann_cmd new_value ann_cmd noprint
select case
         when dbms_db_version.version >= 23 then
           '@@../../ddl/install_ddl_annotations.sql'
         when dbms_db_version.version = 19
              and nvl(to_number(regexp_substr(dbms_db_version.version_full, '[0-9]+', 1, 2)), 0) >= 28 then
           '@@../../ddl/install_ddl_annotations.sql'
         else
           'prompt >> Skipping schema annotations on this Oracle version'
       end as ann_cmd
  from dual;
^ann_cmd.
whenever sqlerror exit rollback

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 25.1 to 26.1

/*
  Migration Script for Release 24.1 to 25.1

  Created  Richard Allen, Flowquest    11 Mar 2025

  (c) Copyright Flowquest Limited and/or its affiliates.  2024-25.

*/

PROMPT >> Checking that Schema can be Upgraded from 24.1 to 25.1
PROMPT >> ------------------------------------------------------

-- wrap test query in pl/sql that raises exception if any rows returned


PROMPT >> Running Schema Upgrade from 24.1 to 25.1
PROMPT >> -------------------------------------------


@@feature-rewind.sql
@@feature-apex-human-task-enhs.sql
@@feature-AIPrompts.sql
@@feature-AQMessageFlow.sql
@@feature-rest-enhancements.sql

@@remove-unused-views.sql

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 24.1 to 25.1

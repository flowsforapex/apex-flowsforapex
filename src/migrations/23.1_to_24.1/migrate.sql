/*
  Migration Script for Release 23.1 to 24.1

  Created  Richard Allen, Flowquest    11 Jan 2024

  (c) Copyright Flowquest Limited and/or its affiliates.  2024.

*/

PROMPT >> Checking that Schema can be Upgraded from 23.1 to 24.1
PROMPT >> ------------------------------------------------------

-- wrap test query in pl/sql that raises exception if any rows returned


PROMPT >> Running Schema Upgrade from 23.1 to 24.1
PROMPT >> -------------------------------------------


@@feature-681.sql
@@feature-666.sql
@@feature-simple-forms.sql

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 23.1 to 24.1

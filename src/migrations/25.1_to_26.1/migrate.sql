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

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 25.1 to 26.1

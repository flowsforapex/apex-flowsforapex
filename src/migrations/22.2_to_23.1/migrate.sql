/*
  Migration Script for Release 22.2 to 23.1

  Created  RAllen   17 Nov 2022


  (c) Copyright Oracle Corporation and/or its affiliates.  2022-2023.

*/

PROMPT >> Checking that Schema can be Upgraded from 22.2 to 23.1
PROMPT >> ------------------------------------------------------

-- wrap test query in pl/sql that raises exception if any rows returned


PROMPT >> Running Schema Upgrade from 22.2 to 23.1
PROMPT >> -------------------------------------------


@@feature-565.sql
@@feature-325.sql
@@feature-581.sql

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 22.2 to 23.1
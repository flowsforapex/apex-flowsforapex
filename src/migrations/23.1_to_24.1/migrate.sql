/*
  Migration Script for Release 23.1 to 24.1

  Created  RAllen   19 Sep 2023


  (c) Copyright Oracle Corporation and/or its affiliates.  2023.

*/

PROMPT >> Checking that Schema can be Upgraded from 23.1 to 24.1
PROMPT >> ------------------------------------------------------

-- wrap test query in pl/sql that raises exception if any rows returned


PROMPT >> Running Schema Upgrade from 23.1 to 24.1
PROMPT >> -------------------------------------------


@feature-681.sql
@feature-687.sql

@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 23.1 to 24.1

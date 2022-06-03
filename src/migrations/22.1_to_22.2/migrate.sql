/*
  Migration Script for Release 22.1 to 22.2

  Created  RAllen   25 Feb 2022
  Modified commi235 28 Apr 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/


PROMPT >> Running Schema Upgrade from 22.1 to 22.2
PROMPT >> -------------------------------------------

@@feature-447.sql
@@feature-172.sql
@@issue-444.sql
@@set_flows_version.sql


PROMPT >> Finished Schema Upgrade from 22.1 to 22.2

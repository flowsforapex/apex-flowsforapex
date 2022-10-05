/*
  Migration Script for Release 22.1 to 22.2

  Created  RAllen   25 Feb 2022
  Modified commi235 28 Apr 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/

PROMPT >> Checking that Schema can be Upgraded from 22.1 to 22.2
PROMPT >> ------------------------------------------------------




PROMPT >> Running Schema Upgrade from 22.1 to 22.2
PROMPT >> -------------------------------------------

PROMPT >> Halt DBMS_SCHEDULER job 
/* TODO Implement Job disabling */

@@feature-447.sql
@@feature-172.sql
@@issue-444.sql
@@feature-468.sql
@@issue-77.sql
@@issue-516.sql
@@issue-511.sql
@@set_flows_version.sql


PROMPT >> Resume DBMS_SCHEDULER job
/* TODO Implement Job enabling */

PROMPT >> Finished Schema Upgrade from 22.1 to 22.2

/*
  Pre Migration Checks Script for Release 22.1 to 22.2

  Created  RAllen   05 Oct 22

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/

PROMPT >> Checking that Schema can be Upgraded from 22.1 to 22.2
PROMPT >> ------------------------------------------------------

WHENEVER SQLERROR exit


@@pre-migration-check-issue-77.sql



WHENEVER SQLERROR continue

PROMPT >> Finished Schema Pre-Migration Checks for  22.1 to 22.2

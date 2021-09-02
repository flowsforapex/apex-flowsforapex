/*
  Migration Script for Release 5.1.2 to 21.1
*/

PROMPT >> Running DDL for Upgrade from 5.1.0 to 5.1.1
PROMPT >> -------------------------------------------

PROMPT >> Remove obsolete objects
drop view flow_p0010_subflows_vw;
drop view flow_p0010_variables_vw;

drop package flow_p0010_api;
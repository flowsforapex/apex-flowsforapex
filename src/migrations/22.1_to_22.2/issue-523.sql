/*
  Migration Script for Issue 523 - Improved APEX Inbox Interoperability

  Created R Allen  25 Sep 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/

alter table flow_processes add(
    prcs_init_by        VARCHAR2(255 CHAR),
    prcs_last_update_by VARCHAR2(255 CHAR)
);

alter table flow_subflows add (
    sbfl_last_update_by   VARCHAR2(255 CHAR)
);
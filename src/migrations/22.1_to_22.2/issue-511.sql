/*
  Migration Script for Issue 511 - Add Indexes to Log Files

  Created R Allen  16 Sep 2022

  (c) Copyright Oracle Corporation and/or its affiliates.  2022.

*/

PROMPT >> Adding Indices to Logging Tables

create index flow_lgpr_ix on flow_instance_event_log (lgpr_prcs_id, lgpr_objt_id );
create index flow_lgsf_ix on flow_step_event_log (lgsf_prcs_id, lgsf_objt_id );
create index flow_lgvr_ix on flow_variable_event_log (lgvr_prcs_id, lgvr_scope, lgvr_var_name);

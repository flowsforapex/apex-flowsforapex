/* 
-- Flows for APEX - flow_adhoc_activities_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
-- todo - should this be a materialized view?
--
-- Created    15-Nov-2025  Richard Allen,  Flowquest Limited
*/
create or replace view flow_adhoc_activities_vw as
  select par_objt.objt_dgrm_id                      dgrm_id
       , par_objt.objt_bpmn_id                      subprocess_bpmn_id
       , objt.objt_bpmn_id                          activity_bpmn_id
       , objt.objt_name                             activity_name
       , objt.objt_tag_name                         activity_tag_name
         , case objt.objt_attributes."apex"."isRepeatable"
           when 'true' then 'Y' 
           else 'N' 
           end activity_is_repeatable
         , objt.objt_attributes."apex"."description" as activity_description
         , objt.objt_attributes."apex"."grouping" as activity_grouping
         , objt.objt_attributes."apex"."displayOrder" as activity_display_order
         , objt.objt_attributes."apex"."inputParameters" as activity_input_parameters
         , objt.objt_attributes."apex"."outputParameters" as activity_output_parameters
         , objt.objt_attributes."apex"."startCondition" as activity_start_condition
       , nvl(par_objt.objt_attributes."apex"."taskVisibility", 'both')    as task_list_visibility
    from flow_objects objt
    join flow_objects par_objt
      on par_objt.objt_id      = objt.objt_objt_id
     and par_objt.objt_dgrm_id = objt.objt_dgrm_id
   where par_objt.objt_tag_name = 'bpmn:adHocSubProcess'
     and not exists ( select conn.conn_id
                        from flow_connections conn
                       where conn.conn_tgt_objt_id = objt.objt_id)
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_adhoc_activities_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Ad-hoc activity catalogue with BPMN extension attributes, repeatability flags, and task visibility settings'
  )]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_is_repeatable annotations (add content 'Y/N flag derived from the isRepeatable APEX extension attribute'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_description annotations (add content 'Descriptive text from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_grouping annotations (add content 'Grouping category from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_display_order annotations (add content 'Display sequence from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_input_parameters annotations (add content 'JSON input parameter definitions from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_output_parameters annotations (add content 'JSON output parameter definitions from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (activity_start_condition annotations (add content 'Start condition expression from the APEX extension attributes'))]';
    execute immediate q'[alter view flow_adhoc_activities_vw modify (task_list_visibility annotations (add content 'Task list visibility setting defaulting to both when not configured'))]';
  end if;
end;
/

whenever sqlerror exit failure

/* 
-- Flows for APEX - flow_startable_diagrams_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    05-Apr-2023  Richard Allen (Oracle)
-- Edited     05-Jun-2023  Louis Moreaux, Insum
-- Edited     07-Oct-2024  Dennis Amthor, Hyand Solutions GmbH
-- Edited     11-Jun-2025  Dennis Amthor, Hyand Solutions GmbH
--
-- This view shows any process diagrams that are marked as startable, along with users and groups that can start them
-- and excluded uses who cannot start them (takes precedence over positive grants in potentialStartingGroups).
--
--  -- Note this View can only be queried inside an APEX session
--
*/
create or replace view flow_startable_diagrams_vw
as 
select dgrm.dgrm_id
     , dgrm.dgrm_name
     , dgrm.dgrm_short_description
     , dgrm.dgrm_description
     , dgrm.dgrm_icon
     , dgrm.dgrm_category
     , dgrm.dgrm_version
     , dgrm.dgrm_status
     , objt.objt_name process_name
     , objt.objt_bpmn_id process_bpmn_id
     , nvl2(objt.objt_attributes."apex"."potentialStartingUsers", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."potentialStartingUsers"),null) potential_starting_users
     , nvl2(objt.objt_attributes."apex"."potentialStartingGroups", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."potentialStartingGroups"),null) potential_starting_groups
     , nvl2(objt.objt_attributes."apex"."excludedStartingUsers", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."excludedStartingUsers"),null) excluded_starting_users
  from flow_diagrams_vw dgrm
  join flow_objects objt
    on dgrm.dgrm_id = objt.objt_dgrm_id
   and objt.objt_attributes."apex"."isStartable" = 'true'
  with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_startable_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Diagrams marked as startable with user and group permissions for initiating process instances'
  )]';
    execute immediate q'[alter view flow_startable_diagrams_vw modify (process_name annotations (add content 'Display name of the startable process start event'))]';
    execute immediate q'[alter view flow_startable_diagrams_vw modify (process_bpmn_id annotations (add content 'BPMN ID of the startable process object'))]';
    execute immediate q'[alter view flow_startable_diagrams_vw modify (potential_starting_users annotations (add content 'Evaluated list of users permitted to start this process'))]';
    execute immediate q'[alter view flow_startable_diagrams_vw modify (potential_starting_groups annotations (add content 'Evaluated list of groups permitted to start this process'))]';
    execute immediate q'[alter view flow_startable_diagrams_vw modify (excluded_starting_users annotations (add content 'Evaluated list of users excluded from starting this process'))]';
  end if;
end;
/

whenever sqlerror exit failure

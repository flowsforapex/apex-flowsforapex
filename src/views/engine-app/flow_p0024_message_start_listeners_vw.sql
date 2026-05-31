/* 
-- Flows for APEX - flow_p0024_message_start_listeners_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2024.
--
-- Admin view of active message start listeners.
-- These are permanent subscriptions registered when a diagram is released,
-- acting as persistent listeners that start a new process instance when
-- a matching message is received (msub_callback = 'bpmn:startEvent').
--
-- Created    31-May-2026  Richard Allen
*/
create or replace view flow_p0024_message_start_listeners_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_callback_par        as msub_start_event_bpmn_id,
          mes.msub_payload_var,
          mes.msub_created,
          dgrm.dgrm_id,
          dgrm.dgrm_name,
          dgrm.dgrm_version,
          dgrm.dgrm_category,
          dgrm.dgrm_icon
     from flow_message_subscriptions_vw mes
     join flow_diagrams                 dgrm on dgrm.dgrm_id = mes.msub_dgrm_id
    where mes.msub_callback = 'bpmn:startEvent'
with read only;

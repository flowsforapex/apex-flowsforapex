create or replace view flow_objects_vw
as
  select objt.objt_id
       , objt.objt_bpmn_id
       , objt.objt_dgrm_id
       , objt.objt_name
       , objt.objt_tag_name
       , objt.objt_sub_tag_name
       , objt.objt_objt_id
       , objt.objt_objt_lane_id
       , objt.objt_attached_to
       , objt.objt_interrupting
  from flow_objects objt
with read only;

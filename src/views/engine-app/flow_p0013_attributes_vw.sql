create or replace view flow_p0013_attributes_vw
as
  select 
    json_query(objt_attributes, '$' returning clob pretty) as json_attributes,
    objt_dgrm_id,
    objt_bpmn_id 
  from flow_objects
  where objt_attributes is not null
with read only;

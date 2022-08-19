create or replace view flow_p0013_attributes_vw
as
   with datas as (
      select 
         objt_attributes as attributes,
         objt_dgrm_id as dgrm_id,
         objt_bpmn_id as bpmn_id
      from flow_objects
      where objt_attributes is not null
      union all
      select 
         conn_attributes as attributes,
         conn_dgrm_id as dgrm_id,
         conn_bpmn_id as bpmn_id
      from flow_connections
      where conn_attributes is not null
   )
   select 
      json_query(attributes, '$' returning clob pretty) as json_attributes,
      dgrm_id,
      bpmn_id 
   from datas
with read only;

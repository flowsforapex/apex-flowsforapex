create or replace view flow_p0007_diagrams_var_vw
as
   select 
      objt_dgrm_id,
      'In' as var_direction,
      jt.var_name,
      jt.var_type,
      jt.var_desc
   from flow_objects objt,
   json_table( objt.objt_attributes, '$.apex.inVariables[*]'
      columns
           var_name varchar2(4000) path '$.varName'
         , var_type varchar2(4000) path '$.varDataType'
         , var_desc varchar2(4000) path '$.varDescription'
   ) jt
   where objt_attributes is not null
     and objt_tag_name = 'bpmn:process'
   union
   select 
      objt_dgrm_id,
      'Out' as var_direction,
      jt.var_name,
      jt.var_type,
      jt.var_desc
   from flow_objects objt,
   json_table( objt.objt_attributes, '$.apex.outVariables[*]'
      columns
           var_name varchar2(4000) path '$.varName'
         , var_type varchar2(4000) path '$.varDataType'
         , var_desc varchar2(4000) path '$.varDescription'
   ) jt
      where objt_attributes is not null
      and objt_tag_name = 'bpmn:process'
with read only;

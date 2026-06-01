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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0007_diagrams_var_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Input and output variable declarations extracted from diagram process JSON extension attributes'
  );

alter view flow_p0007_diagrams_var_vw modify (var_direction annotations (add content 'Variable direction: In for input parameters, Out for output parameters'));
alter view flow_p0007_diagrams_var_vw modify (var_name annotations (add content 'Variable name as defined in the process JSON extension attributes'));
alter view flow_p0007_diagrams_var_vw modify (var_type annotations (add content 'Variable data type as defined in the process JSON extension attributes'));
alter view flow_p0007_diagrams_var_vw modify (var_desc annotations (add content 'Variable description as defined in the process JSON extension attributes'));

whenever sqlerror exit failure

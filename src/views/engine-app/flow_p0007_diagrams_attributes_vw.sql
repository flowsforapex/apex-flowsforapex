create or replace view flow_p0007_diagrams_attributes_vw
as
   select 
   objt_dgrm_id,
   jt.application_id,
   jt.page_id,
   jt.username,
   jt.is_callable
from flow_objects objt,
json_table( objt.objt_attributes, '$.apex'
   columns
        application_id     varchar2(4000) path '$.applicationId'
      , page_id            varchar2(4000) path '$.pageId'
      , username           varchar2(4000) path '$.username'
      , is_callable        varchar2(4000) path '$.isCallable'
   ) jt
   where objt_attributes is not null
   and objt_tag_name = 'bpmn:process'
with read only;

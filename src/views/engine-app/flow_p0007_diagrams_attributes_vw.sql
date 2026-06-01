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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0007_diagrams_attributes_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'APEX application and page configuration extracted from diagram process JSON extension attributes'
  );

alter view flow_p0007_diagrams_attributes_vw modify (application_id annotations (add content 'APEX application ID from the BPMN process JSON extension attributes'));
alter view flow_p0007_diagrams_attributes_vw modify (page_id annotations (add content 'APEX page ID from the BPMN process JSON extension attributes'));
alter view flow_p0007_diagrams_attributes_vw modify (username annotations (add content 'Process username attribute from the BPMN JSON extension attributes'));
alter view flow_p0007_diagrams_attributes_vw modify (is_callable annotations (add content 'Whether this process is callable as a called sub-process'));

whenever sqlerror exit failure

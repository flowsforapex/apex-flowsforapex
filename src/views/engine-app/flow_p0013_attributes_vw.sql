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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0013_attributes_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'BPMN object and connection extension attributes as formatted JSON for the debug panel in engine app page 13'
  )]';
    execute immediate q'[alter view flow_p0013_attributes_vw modify (json_attributes annotations (add content 'Extension attributes of the BPMN object or connection formatted as pretty-printed JSON'))]';
  end if;
end;
/

whenever sqlerror exit failure

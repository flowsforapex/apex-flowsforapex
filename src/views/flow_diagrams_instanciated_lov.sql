create or replace view flow_diagrams_instanciated_lov
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
    from flow_diagrams dgrm
   where exists 
         ( select null
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
    and exists (
      select 1
      from flow_instance_diagrams prdg
      where prdg.prdg_dgrm_id = dgrm.dgrm_id
    )
  with read only
  ;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_diagrams_instanciated_lov annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Diagrams with active process instances for instance-filtered LOV selection'
  )]';
  end if;
end;
/

whenever sqlerror exit failure

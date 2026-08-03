create or replace view flow_instances_vw
as
  select prcs.prcs_id
       , prcs.prcs_name
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_short_description
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , prcs.prcs_priority
       , dgrm.dgrm_category
       , prcs.prcs_status
       , prcs.prcs_logging_level
       , prcs.prcs_was_altered
       , prcs.prcs_init_ts
       , prcs.prcs_init_by
       , prcs.prcs_start_ts
       , prcs.prcs_due_on
       , prcs.prcs_complete_ts
       , prcs.prcs_last_update
       , prcs.prcs_last_update_by
       , prov.prov_var_vc2 as prcs_business_ref
    from flow_processes prcs
    join flow_diagrams dgrm
      on dgrm.dgrm_id = prcs.prcs_dgrm_id
    left join flow_process_variables prov
      on prov.prov_prcs_id = prcs.prcs_id
     and prov.prov_var_name = 'BUSINESS_REF'
     and prov.prov_var_type = 'VARCHAR2' 
     and prov.prov_scope = 0
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instances_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'All process instances with diagram metadata, status, priority, timestamps, and business reference'
  )]';
    execute immediate q'[alter view flow_instances_vw modify (prcs_business_ref annotations (add content 'Business reference value from the BUSINESS_REF process variable'))]';
  end if;
end;
/

whenever sqlerror exit failure

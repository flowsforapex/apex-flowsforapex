create or replace view flow_instance_variables_vw
as
  select prov.prov_prcs_id
       , prov.prov_var_name
       , prov.prov_var_name_uc
       , prov.prov_scope
       , prov.prov_var_type
       , prov.prov_var_vc2
       , prov.prov_var_num
       , prov.prov_var_date
       , prov.prov_var_tstz
       , prov.prov_var_clob
       , prov.prov_var_json
       , prcs.prcs_name
       , prcs.prcs_status
    from flow_process_variables prov
    join flow_processes prcs
      on prcs.prcs_id = prov.prov_prcs_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instance_variables_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Current process variables for a process instance with names, types, scopes, and typed values'
  )]';
  end if;
end;
/

whenever sqlerror exit failure

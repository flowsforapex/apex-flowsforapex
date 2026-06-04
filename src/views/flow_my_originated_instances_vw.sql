
create or replace view flow_my_originated_instances_vw
as 
select   prcs_id
       , prcs_name
       , dgrm_id
       , dgrm_name
       , dgrm_version
       , dgrm_status
       , dgrm_category
       , prcs_status
       , case prcs_status
          when 'created' then
            'u-color-37'
          when 'running' then
            'u-success'
          when 'error' then
            'u-danger'
          when 'terminated' then
            'u-color-38'
          when 'completed' then
            'u-color-30'
          else null
          end as prcs_status_css
       , prcs_priority
       , prcs_due_on
       , prcs_init_ts
       , 'Initiated '||apex_util.get_since (p_value => prcs_init_ts) as prcs_init_since
       , prcs_init_by
       , prcs_last_update
       , 'last updated '||apex_util.get_since (p_value => prcs_last_update) as prcs_last_update_since
       , prcs_last_update_by
       , prcs_business_ref
       , prcs_was_altered
from flow_instances_vw
where prcs_init_by =  sys_context('apex$session','app_user') 
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_my_originated_instances_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process instances initiated by the current user with status styling and relative timestamps'
  )]';
    execute immediate q'[alter view flow_my_originated_instances_vw modify (prcs_status_css annotations (add content 'APEX CSS class for status-based colour styling'))]';
    execute immediate q'[alter view flow_my_originated_instances_vw modify (prcs_init_since annotations (add content 'Human-readable relative time since the instance was initiated'))]';
    execute immediate q'[alter view flow_my_originated_instances_vw modify (prcs_last_update_since annotations (add content 'Human-readable relative time since the last update'))]';
  end if;
end;
/

whenever sqlerror exit failure

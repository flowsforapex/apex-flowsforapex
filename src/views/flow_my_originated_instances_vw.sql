
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
       , prcs_init_ts
       , 'Initiated '||apex_util.get_since (p_value => prcs_init_ts) as prcs_init_since
       , prcs_init_by
       , prcs_last_update
       , 'last updated '||apex_util.get_since (p_value => prcs_last_update) as prcs_last_update_since
       , prcs_last_update_by
       , prcs_business_ref
from flow_instances_vw
where prcs_init_by =  sys_context('apex$session','app_user') 
with read only;

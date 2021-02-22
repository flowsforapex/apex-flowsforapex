
create or replace view flow_p0007_instances_counter_vw
as
  select distinct d.dgrm_id,
    sum(case when i.prcs_status = 'created' then 1 else 0 end) over (partition by d.dgrm_id)  as created_instances,
    sum(case when i.prcs_status = 'running' then 1 else 0 end) over (partition by d.dgrm_id) as running_instances,
    sum(case when i.prcs_status = 'completed' then 1 else 0 end) over (partition by d.dgrm_id) as completed_instances
from flow_diagrams_vw d
left join flow_instances_vw i on i.dgrm_id = d.dgrm_id
with read only
;

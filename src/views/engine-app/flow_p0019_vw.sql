create or replace view flow_p0019_vw as
with sbfl_counts as (
    select p.prcs_dgrm_id dgrm_id, 
           s.sbfl_current steps, 
           s.sbfl_status, 
           count(s.sbfl_id) numprocs
    from   flow_subflows s
    join   flow_processes p
    on     s.sbfl_prcs_id = p.prcs_id
    where  p.prcs_status in ('error', 'suspended', 'running')
    and    s.sbfl_status in ('error', 'suspended', 'running', 'waiting for message')
    group  by p.prcs_dgrm_id, s.sbfl_current, s.sbfl_status
),
step_labels as (
    select sc.dgrm_id,
           sc.steps,
           json_arrayagg(
             json_object(
               key 'position' value case sc.sbfl_status 
                                   when 'running' then 'TopRight'
                                   when 'waiting for message' then 'TopLeft'
                                   else 'BottomLeft'
                                 end,
               key 'shape' value 'circle',
               key 'label' value sc.numprocs,
               key 'textColor' value '#000000',
               key 'backgroundColor' value case sc.sbfl_status 
                                           when 'running' then '#43A047'
                                           when 'waiting for message' then '#FB8C00'
                                           else '#E53935'
                                         end
             )
           ) as labels
    from sbfl_counts sc
    group by sc.dgrm_id, sc.steps
), 
badges_data as (
    select dgrm_id,
           json_objectagg(
             key sl.steps value sl.labels
           ) as badges_data
    from     step_labels sl
    group by sl.dgrm_id
)
select  d.dgrm_id,
        d.dgrm_name,
        d.dgrm_content,
        bd.badges_data
from flow_diagrams d
join badges_data bd
on   bd.dgrm_id = d.dgrm_id
with read only;

create or replace view flow_p0019_vw as
with sbfl_counts as (
    select p.prcs_dgrm_id dgrm_id, 
           s.sbfl_current steps, 
           case s.sbfl_status
             when 'error'     then 'error'
             when 'suspended' then 'suspended'
             else                  'running'
           end as badge_category,
           count(s.sbfl_id) numprocs
    from   flow_subflows s
    join   flow_processes p
    on     s.sbfl_prcs_id = p.prcs_id
    where  p.prcs_status in ('error', 'suspended', 'running')
    and    s.sbfl_status in ('error', 'suspended', 'running', 'waiting for message', 'waiting for approval', 
                             'waiting at gateway', 'waiting for timer', 'in subprocess','in call activity', 'iterating')
    group  by p.prcs_dgrm_id
            , s.sbfl_current
            , case s.sbfl_status
                when 'error'     then 'error'
                when 'suspended' then 'suspended'
                else                  'running'
              end
),
step_labels as (
    select sc.dgrm_id,
           sc.steps,
           json_arrayagg(
             json_object(
               key 'position' value case sc.badge_category
                                   when 'running' then 'TopLeft'
                                   when 'suspended' then 'TopRight'
                                   else 'BottomLeft'
                                 end,
               key 'shape' value 'circle',
               key 'label' value sc.numprocs,
               key 'textColor' value '#ffffff',
               key 'backgroundColor' value case sc.badge_category 
                                           when 'running' then '#43A047'
                                           when 'suspended' then '#056ac8'
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
left outer join badges_data bd
on   bd.dgrm_id = d.dgrm_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0019_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Diagrams with running step badge overlay data as JSON for the process viewer in engine app page 19'
  , add note    'This view is intended for use in the engine application and may be subject to change. Use only for querying diagram data for a single instance to display in the viewer, not for other purposes.'
  );

alter view flow_p0019_vw modify (badges_data annotations (add content 'JSON object mapping BPMN element IDs to badge configuration arrays for the viewer overlay'));

whenever sqlerror exit failure

create or replace view flow_p0010_instances_vw
as
   select prcs_id
        , prcs_name
        , prcs_dgrm_id
        , prcs_dgrm_name
        , prcs_dgrm_version
        , prcs_dgrm_status
        , prcs_dgrm_category
        , prcs_status
        , prcs_dgrm_status_icon
        , prcs_priority
        , prcs_logging_level
        , prcs_status_icon
        , prcs_due_on
        , prcs_was_altered
        , prcs_init_date
        , prcs_last_update
        , prcs_business_ref
        , null as btn
        , apex_item.checkbox2(p_idx => 1, p_value => prcs_id, p_attributes => 'data-prcs = "' || prcs_id || '" data-status = "' || prcs_status ||'"') as checkbox
        , null as quick_action
     from ( select prcs_id
                 , prcs_name
                 , dgrm_id as prcs_dgrm_id
                 , dgrm_name as prcs_dgrm_name
                 , dgrm_version as prcs_dgrm_version
                 , dgrm_status as prcs_dgrm_status
                 , case dgrm_status
                  when 'draft' then 'fa fa-wrench'
                  when 'released' then 'fa fa-check'
                  when 'deprecated' then 'fa fa-ban'
                  when 'archived' then 'fa fa-archive'
                end as prcs_dgrm_status_icon
                 , prcs_priority
                 , prcs_logging_level
                 , dgrm_category as prcs_dgrm_category
                 , prcs_status
                 , prcs_due_on at time zone sessiontimezone as prcs_due_on
                 , prcs_was_altered
                 , prcs_init_ts at time zone sessiontimezone as prcs_init_date
                 , prcs_last_update at time zone sessiontimezone as prcs_last_update
                 , prcs_business_ref
                 , case prcs_status
                     when 'running' then 'fa-play-circle-o'
                     when 'created' then 'fa-plus-circle-o'
                     when 'suspended' then 'fa-pause-circle-o'
                     when 'completed' then 'fa-check-circle-o'
                     when 'terminated' then 'fa-stop-circle-o'
                     when 'error' then 'fa-exclamation-circle-o'
                   end as prcs_status_icon
              from flow_instances_vw
          )
with read only
;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0010_instances_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process instances with diagram and status icons, action placeholders, and checkbox widget for engine app page 10'
  );

alter view flow_p0010_instances_vw modify (prcs_dgrm_status_icon annotations (add content 'FA icon CSS class for the diagram status'));
alter view flow_p0010_instances_vw modify (prcs_status_icon annotations (add content 'FA icon CSS class for the process instance status'));
alter view flow_p0010_instances_vw modify (btn annotations (add content 'Null placeholder for an action button column'));
alter view flow_p0010_instances_vw modify (checkbox annotations (add content 'APEX checkbox widget with process ID and status data attributes'));
alter view flow_p0010_instances_vw modify (quick_action annotations (add content 'Null placeholder for a quick action column'));

whenever sqlerror exit failure

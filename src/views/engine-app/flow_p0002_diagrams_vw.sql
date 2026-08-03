
create or replace view flow_p0002_diagrams_vw
as
  with instance_numbers as
  (
    select prdg_dgrm_id as dgrm_id
         , created_cnt
         , running_cnt
         , suspended_cnt
         , completed_cnt
         , terminated_cnt
         , error_cnt
         , created_cnt + running_cnt + suspended_cnt + completed_cnt + terminated_cnt + error_cnt as total_cnt 
      from (
             select prdg.prdg_dgrm_id
                  , prcs.prcs_status
               from flow_processes prcs
               join flow_instance_diagrams prdg
                 on prdg.prdg_prcs_id = prcs.prcs_id
           group by prcs.prcs_id, prdg.prdg_dgrm_id, prcs.prcs_status
           )
     pivot (
             count(*) for
               prcs_status in ( 'created' created_cnt, 'running' running_cnt, 'completed' completed_cnt
                              , 'terminated' terminated_cnt, 'error' as error_cnt, 'suspended' as suspended_cnt
                              )
           )
  )
    select d.dgrm_id
         , d.dgrm_name
         , d.dgrm_version
         , d.dgrm_status
         , d.dgrm_category
         , d.dgrm_last_update at time zone sessiontimezone as dgrm_last_update
         , null as btn
         , apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id) as edit_link
         , apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id) as create_instance_link
         , decode(inst_nums.total_cnt, 0, null, inst_nums.total_cnt) as instances 
         , case when not exists( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id ) then 'No' else 'Yes' end as diagram_parsed
         , case when not exists( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id ) then 'fa-times-circle-o fa-lg u-danger-text' else 'fa-check-circle-o fa-lg u-success-text' end as diagram_parsed_icon
         , dgrm_status_icon
         , nullif(inst_nums.created_cnt, 0) as instance_created
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',created', p_clear_cache => 'RP,RIR') as instance_created_link
         , nullif(inst_nums.running_cnt, 0) as instance_running
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',running', p_clear_cache => 'RP,RIR') as instance_running_link
         , nullif(inst_nums.suspended_cnt, 0) as instance_suspended
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',suspended', p_clear_cache => 'RP,RIR') as instance_suspended_link
         , nullif(inst_nums.completed_cnt, 0) as instance_completed
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',completed', p_clear_cache => 'RP,RIR') as instance_completed_link
         , nullif(inst_nums.terminated_cnt, 0) as instance_terminated
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',terminated', p_clear_cache => 'RP,RIR') as instance_terminated_link
         , nullif(inst_nums.error_cnt, 0) as instance_error
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',error', p_clear_cache => 'RP,RIR') as instance_error_link
         , apex_item.checkbox2(p_idx => 1, p_value => d.dgrm_id, p_attributes => 'data-name = "' || dgrm_name || '" data-version = "' || dgrm_version || '"') as checkbox
      from flow_diagrams_vw d
 left join instance_numbers inst_nums
        on inst_nums.dgrm_id = d.dgrm_id
with read only
;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0002_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Diagram management list with per-status instance counts, parsed status, and navigation links for engine app page 2'
  )]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (btn annotations (add content 'Null placeholder for an inline action button'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (edit_link annotations (add content 'APEX URL to open the diagram in the editor (page 7)'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (create_instance_link annotations (add content 'APEX URL to create a new process instance from this diagram'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instances annotations (add content 'Total instance count across all statuses; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (diagram_parsed annotations (add content 'Yes/No indicator whether diagram objects have been parsed'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (diagram_parsed_icon annotations (add content 'FA icon CSS class indicating whether the diagram is parsed'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (dgrm_status_icon annotations (add content 'FA icon CSS class for the diagram status'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_created annotations (add content 'Count of created instances; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_created_link annotations (add content 'APEX URL filtered to created instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_running annotations (add content 'Count of running instances; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_running_link annotations (add content 'APEX URL filtered to running instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_suspended annotations (add content 'Count of suspended instances; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_suspended_link annotations (add content 'APEX URL filtered to suspended instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_completed annotations (add content 'Count of completed instances; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_completed_link annotations (add content 'APEX URL filtered to completed instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_terminated annotations (add content 'Count of terminated instances; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_terminated_link annotations (add content 'APEX URL filtered to terminated instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_error annotations (add content 'Count of instances in error state; null when zero'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (instance_error_link annotations (add content 'APEX URL filtered to error instances'))]';
    execute immediate q'[alter view flow_p0002_diagrams_vw modify (checkbox annotations (add content 'APEX checkbox widget with diagram name and version data attributes'))]';
  end if;
end;
/

whenever sqlerror exit failure

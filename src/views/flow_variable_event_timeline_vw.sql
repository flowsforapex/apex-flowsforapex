create or replace view flow_variable_event_timeline_vw as
with instance_dgrms as (
  select distinct prdg_prcs_id prcs_id, prdg_dgrm_id dgrm_id
  from flow_instance_diagrams
)
select lgvr_prcs_id
     , lgvr_var_name
     , upper(lgvr_var_name) as lgvr_var_name_uc
     , lgvr_scope
     , lgvr_var_type
     , case
           when lgvr_var_vc2  is not null then lgvr_var_vc2
           when lgvr_var_num  is not null then cast(lgvr_var_num as varchar2(4000))
           when lgvr_var_date is not null then to_char(lgvr_var_date, v('APP_DATE_TIME_FORMAT'))
           when lgvr_var_clob is not null then cast(dbms_lob.substr(lgvr_var_clob, 1000) as varchar2(4000))
           when lgvr_var_tstz is not null then to_char(lgvr_var_tstz, v('NLS_TIMESTAMP_TZ_FORMAT'))
           when lgvr_var_json is not null then cast(dbms_lob.substr(lgvr_var_json, 1000) as varchar2(4000))
         end as  lgvr_var_value 
     , lgvr_objt_id
     , (select coalesce(objt_name, objt_bpmn_id) 
          from flow_objects objt
         where objt.objt_bpmn_id = lgvr_objt_id
           and objt.objt_dgrm_id in (select dgrm_id 
                                      from instance_dgrms 
                                     where prcs_id = lgvr_prcs_id)
       ) as lgvr_objt_name
     , lgvr_sbfl_id
     , lgvr_expr_set
     , lgvr_timestamp
     , lgvr_user
  from flow_variable_event_log
  order by lgvr_timestamp
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_variable_event_timeline_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Timeline of variable assignments with object and scope context for audit and debugging'
  )]';
    execute immediate q'[alter view flow_variable_event_timeline_vw modify (lgvr_var_name_uc annotations (add content 'Upper-case variable name for case-insensitive filtering'))]';
    execute immediate q'[alter view flow_variable_event_timeline_vw modify (lgvr_var_value annotations (add content 'Current value of the variable retrieved as VARCHAR2'))]';
    execute immediate q'[alter view flow_variable_event_timeline_vw modify (lgvr_objt_name annotations (add content 'Display name of the BPMN object that set the variable'))]';
  end if;
end;
/

whenever sqlerror exit failure

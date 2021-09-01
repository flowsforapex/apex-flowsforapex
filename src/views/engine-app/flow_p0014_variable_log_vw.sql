create or replace view flow_p0014_variable_log_vw
as
  select lgvr_prcs_id
       , lgvr_sbfl_id
       , lgvr_objt_id
       , lgvr_var_name
       , lgvr_expr_set
       , lgvr_timestamp
       , lgvr_var_type
       , case
           when lgvr_var_vc2 is not null then lgvr_var_vc2
           when lgvr_var_num is not null then cast(lgvr_var_num as varchar2(4000))
           when lgvr_var_date is not null then cast(lgvr_var_date as varchar2(4000))
           when lgvr_var_clob is not null then '[clob]'
         end as lgvr_value
    from flow_variable_event_log
with read only;

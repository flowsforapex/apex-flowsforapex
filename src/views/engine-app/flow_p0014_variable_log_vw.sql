create or replace view flow_p0014_variable_log_vw
as
  select lgvr_prcs_id
       , lgvr_sbfl_id
       , lgvr_objt_id
       , lgvr_var_name
       , lgvr_scope
       , lgvr_expr_set
       , lgvr_timestamp at time zone sessiontimezone as lgvr_timestamp
       , lgvr_var_type
       , case
           when lgvr_var_vc2 is not null then lgvr_var_vc2
           when lgvr_var_num is not null then cast(lgvr_var_num as varchar2(4000))
           when lgvr_var_date is not null then to_char(lgvr_var_date, v('APP_DATE_TIME_FORMAT'))
           when lgvr_var_clob is not null then cast(dbms_lob.substr(lgvr_var_clob, 1000) as varchar2(4000))
           when lgvr_var_tstz is not null then to_char(lgvr_var_tstz, v('NLS_TIMESTAMP_TZ_FORMAT'))
           when lgvr_var_json is not null then cast(dbms_lob.substr(lgvr_var_json, 1000) as varchar2(4000))
         end as lgvr_value
    from flow_variable_event_log
with read only;

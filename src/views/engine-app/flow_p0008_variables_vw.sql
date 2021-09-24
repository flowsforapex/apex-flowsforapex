create or replace view flow_p0008_variables_vw
as
  select apex_item.checkbox( p_idx => 3, p_value => prov_var_name, p_attributes => 'data-prcs="'|| prov_prcs_id || '"') as checkbox,
       null as action,
       prov_prcs_id,
       prov_var_name,
       prov_var_type,
       case
            when prov_var_vc2 is not null then prov_var_vc2
            when prov_var_num is not null then cast(prov_var_num as varchar2(4000))
            when prov_var_date is not null then to_char(prov_var_date, v('APP_DATE_TIME_FORMAT'))
            when prov_var_clob is not null then cast(dbms_lob.substr(prov_var_clob, 4000) as  varchar2(4000))
        end as prov_var_value,
        case when instr(prov_var_name, ':route') > 0 then 'true' else 'false' end is_gateway_route
    from flow_instance_variables_vw
with read only;

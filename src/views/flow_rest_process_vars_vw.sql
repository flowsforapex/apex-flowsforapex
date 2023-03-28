create or replace view flow_rest_process_vars_vw
      (
          prcs_id
        , scope 
        , name 
        , type 
        , value
      )
  as
  select  pv.prov_prcs_id  as prcs_id
        , pv.prov_scope    as scope
        , pv.prov_var_name as name
        , pv.prov_var_type as type
        , decode( lower(pv.prov_var_type) 
              , 'varchar2', pv.prov_var_vc2
              , 'number',   pv.prov_var_num
              , 'date',     pv.prov_var_num
              , 'clob',     pv.prov_var_num
              , null ) as value
  from flow_process_variables pv;
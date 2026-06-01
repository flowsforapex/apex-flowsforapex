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
              , 'date',     pv.prov_var_date
              , 'clob',     pv.prov_var_clob
              , 'timestamp with time zone', pv.prov_var_tstz
              , 'json', pv.prov_var_json
              , null ) as value
  from flow_process_variables pv;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_rest_process_vars_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process variables with type-aware value conversion for REST API responses'
  );

alter view flow_rest_process_vars_vw modify (prcs_id annotations (add content 'Process instance this variable belongs to'));
alter view flow_rest_process_vars_vw modify (scope   annotations (add content 'Variable scope number'));
alter view flow_rest_process_vars_vw modify (name    annotations (add content 'Variable name'));
alter view flow_rest_process_vars_vw modify (type    annotations (add content 'Variable data type: VARCHAR2, NUMBER, DATE, TIMESTAMP, CLOB, JSON'));
alter view flow_rest_process_vars_vw modify (value   annotations (add content 'Variable value cast to VARCHAR2 for REST response'));

whenever sqlerror exit failure

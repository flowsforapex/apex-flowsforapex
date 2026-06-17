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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_rest_process_vars_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process variables with type-aware value conversion for REST API responses'
  )]';
    execute immediate q'[alter view flow_rest_process_vars_vw modify (prcs_id annotations (add content 'Process instance this variable belongs to'))]';
    execute immediate q'[alter view flow_rest_process_vars_vw modify (scope   annotations (add content 'Variable scope number'))]';
    execute immediate q'[alter view flow_rest_process_vars_vw modify (name    annotations (add content 'Variable name'))]';
    execute immediate q'[alter view flow_rest_process_vars_vw modify (type    annotations (add content 'Variable data type: VARCHAR2, NUMBER, DATE, TIMESTAMP, CLOB, JSON'))]';
    execute immediate q'[alter view flow_rest_process_vars_vw modify (value   annotations (add content 'Variable value cast to VARCHAR2 for REST response'))]';
  end if;
end;
/

whenever sqlerror exit failure

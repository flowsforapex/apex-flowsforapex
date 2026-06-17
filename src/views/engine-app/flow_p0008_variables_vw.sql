create or replace view flow_p0008_variables_vw
as
  select apex_item.checkbox( p_idx => 3, p_value => prov_var_name, p_attributes => 'data-prcs="'|| prov_prcs_id || '"') as checkbox,
       null as action,
       prov_prcs_id,
       prov_var_name,
       prov_var_name_uc,
       prov_var_type,
       prov_scope, 
       ( select nvl(objt.objt_name, 'Main Diagram')
           from flow_instance_diagrams prdg 
         left join flow_objects objt
             on prdg.prdg_calling_objt = objt.objt_bpmn_id
            and prdg.prdg_calling_dgrm = objt.objt_dgrm_id
          where prdg.prdg_diagram_level = prov_scope 
            and prdg.prdg_prcs_id =prov_prcs_id) as Calling_object,
       case
            when prov_var_vc2  is not null then prov_var_vc2
            when prov_var_num  is not null then cast(prov_var_num as varchar2(4000))
            when prov_var_date is not null then to_char(prov_var_date, coalesce(v('APP_DATE_TIME_FORMAT'), 'YYYY-MM-DD HH24:MI:SS'))
            when prov_var_clob is not null then cast(dbms_lob.substr(prov_var_clob, 1000) as varchar2(4000))
            when prov_var_tstz is not null then to_char(prov_var_tstz, coalesce(v('NLS_TIMESTAMP_TZ_FORMAT'),'YYYY-MM-DD HH24:MI:SS TZR'))
            when prov_var_json is not null then cast(dbms_lob.substr(prov_var_json, 1000) as varchar2(4000))
        end as prov_var_value,
        case when instr(prov_var_name, ':route') > 0 then 'true' else 'false' end is_gateway_route
    from flow_instance_variables_vw
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0008_variables_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process variables with coalesced display value, gateway route flag, and checkbox widget for engine app page 8'
  )]';
    execute immediate q'[alter view flow_p0008_variables_vw modify (checkbox annotations (add content 'APEX checkbox widget with process ID data attribute'))]';
    execute immediate q'[alter view flow_p0008_variables_vw modify (action annotations (add content 'Null placeholder for an inline action column'))]';
    execute immediate q'[alter view flow_p0008_variables_vw modify (calling_object annotations (add content 'Display name of the variable scope diagram or Main Diagram'))]';
    execute immediate q'[alter view flow_p0008_variables_vw modify (prov_var_value annotations (add content 'Variable value coalesced across all typed columns as VARCHAR2'))]';
    execute immediate q'[alter view flow_p0008_variables_vw modify (is_gateway_route annotations (add content 'True/false string indicating whether this variable is a gateway routing control'))]';
  end if;
end;
/

whenever sqlerror exit failure

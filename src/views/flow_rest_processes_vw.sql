create or replace view flow_rest_processes_vw
      (
          dgrm_id
        , prcs_id
        , name
        , status
        , init_ts
        , init_by
        , process_vars
        , links
      )
  as
  SELECT  
          d.dgrm_id
        , p.prcs_id
        , p.prcs_name     as name
        , p.prcs_status   as status
        , p.prcs_init_ts  as init_ts
        , p.prcs_init_by  as init_by
        , json_array( 
            listagg( 
                json_object (
                  'scope' value pv.prov_scope
                 , 'name' value pv.prov_var_name
                 , 'type' value pv.prov_var_type
                 , 'value' value decode( lower(pv.prov_var_type) 
                                      , 'varchar2', pv.prov_var_vc2
                                      , 'number',   pv.prov_var_num
                                      , 'date',     pv.prov_var_num
                                      , 'clob',     pv.prov_var_num
                                      , null )
                )     
            ,',') format json
          ) process_vars
        , json_array(
            flow_rest_api_v1.get_links_string_http_GET('process',p.prcs_id) format json
          ) links
  from flow_diagrams d
  join flow_processes p on d.dgrm_id = p.prcs_dgrm_id
  left join flow_process_variables pv on p.prcs_id = pv.prov_prcs_id
  group by  d.dgrm_id
          , p.prcs_id
          , p.prcs_name
          , p.prcs_status
          , p.prcs_init_ts
          , p.prcs_init_by;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_rest_processes_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process instances with aggregated variables and HATEOAS links formatted for REST API'
  );

alter view flow_rest_processes_vw modify (dgrm_id      annotations (add content 'Diagram this instance was created from'));
alter view flow_rest_processes_vw modify (prcs_id      annotations (add content 'Unique process instance identifier'));
alter view flow_rest_processes_vw modify (name         annotations (add content 'Process instance name'));
alter view flow_rest_processes_vw modify (status       annotations (add content 'Current execution status'));
alter view flow_rest_processes_vw modify (init_ts      annotations (add content 'Timestamp when the instance was initialised'));
alter view flow_rest_processes_vw modify (init_by      annotations (add content 'User who initialised the instance'));
alter view flow_rest_processes_vw modify (process_vars annotations (add content 'JSON array of current process variables'));
alter view flow_rest_processes_vw modify (links        annotations (add content 'HATEOAS links JSON for this process instance resource'));

whenever sqlerror exit failure

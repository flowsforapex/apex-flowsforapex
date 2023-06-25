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
create or replace view flow_rest_diagrams_vw
      (
          dgrm_id
        , name 
        , version
        , status 
        , category 
        , links
      )
  as
  select  d.dgrm_id
        , d.dgrm_name     as name
        , d.dgrm_version  as version
        , d.dgrm_status   as status
        , d.dgrm_category as category
        , json_array(
            flow_rest_api_v1.get_links_string_http_GET('diagram',d.dgrm_id) format json
          ) links
    from flow_diagrams d;
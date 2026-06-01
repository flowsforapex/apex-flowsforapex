create or replace view flow_rest_diagrams_vw
      (
          dgrm_id
        , name 
        , version
        , status 
        , category 
        , content
        , links
      )
  as
  select  d.dgrm_id
        , d.dgrm_name     as name
        , d.dgrm_version  as version
        , d.dgrm_status   as status
        , d.dgrm_category as category
        , d.dgrm_content  as content
        , json_array(
            flow_rest_api_v1.get_links_string_http_GET('diagram',d.dgrm_id) format json
          ) links
    from flow_diagrams d;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_rest_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Process diagrams formatted for REST API responses with HATEOAS links'
  );

alter view flow_rest_diagrams_vw modify (dgrm_id  annotations (add content 'Unique numeric ID for the diagram'));
alter view flow_rest_diagrams_vw modify (name     annotations (add content 'Business process name'));
alter view flow_rest_diagrams_vw modify (version  annotations (add content 'Version string for this diagram'));
alter view flow_rest_diagrams_vw modify (status   annotations (add content 'Lifecycle status: draft, released, deprecated, archived'));
alter view flow_rest_diagrams_vw modify (category annotations (add content 'Optional category for grouping diagrams'));
alter view flow_rest_diagrams_vw modify (content  annotations (add content 'BPMN XML content of the process diagram'));
alter view flow_rest_diagrams_vw modify (links    annotations (add content 'HATEOAS links JSON for this diagram resource'));

whenever sqlerror exit failure

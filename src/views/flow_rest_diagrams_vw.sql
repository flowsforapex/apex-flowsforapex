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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_rest_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Process diagrams formatted for REST API responses with HATEOAS links'
  )]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (dgrm_id  annotations (add content 'Unique numeric ID for the diagram'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (name     annotations (add content 'Business process name'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (version  annotations (add content 'Version string for this diagram'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (status   annotations (add content 'Lifecycle status: draft, released, deprecated, archived'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (category annotations (add content 'Optional category for grouping diagrams'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (content  annotations (add content 'BPMN XML content of the process diagram'))]';
    execute immediate q'[alter view flow_rest_diagrams_vw modify (links    annotations (add content 'HATEOAS links JSON for this diagram resource'))]';
  end if;
end;
/

whenever sqlerror exit failure

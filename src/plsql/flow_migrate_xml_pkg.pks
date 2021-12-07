create or replace package flow_migrate_xml_pkg
as
  procedure migrate_xml(
    p_dgrm_content in out clob
  , p_has_changed out boolean
  );
end flow_migrate_xml_pkg;
/

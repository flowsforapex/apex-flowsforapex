create or replace package flow_migrate_xml_pkg
as
  function migrate_xml(
    p_dgrm_content in out clob
  ) return boolean;
end flow_migrate_xml_pkg;
/

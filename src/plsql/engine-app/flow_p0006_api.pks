create or replace package flow_p0006_api
  authid definer
as

    function is_file_uploaded(
        pi_file_name in varchar2
    )
    return boolean;
    
    function is_valid_xml(
        pi_import_from in varchar2,
        pi_dgrm_content in flow_diagrams.dgrm_content%type,
        pi_file_name in varchar2
    )
    return boolean;
  
    function upload_and_parse(
        pi_import_from in varchar2,
        pi_dgrm_name in flow_diagrams.dgrm_name%type,
        pi_dgrm_category in flow_diagrams.dgrm_category%type,
        pi_dgrm_version in flow_diagrams.dgrm_version%type,
        pi_dgrm_content in flow_diagrams.dgrm_content%type,
        pi_file_name in varchar2,
        pi_force_overwrite in varchar2
    ) 
    return flow_diagrams.dgrm_id%type;

end flow_p0006_api;
/

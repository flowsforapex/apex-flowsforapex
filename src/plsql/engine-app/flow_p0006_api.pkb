create or replace package body flow_p0006_api
as

    function is_file_uploaded(
        pi_file_name in varchar2
    )
    return boolean
    is
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_err boolean := true;
    begin
        begin
            select to_clob(blob_content)
            into l_dgrm_content
            from apex_application_temp_files
            where name = pi_file_name;
        exception when no_data_found then
            l_err := false;
        end;
 
        return l_err;
    end is_file_uploaded;

    function is_valid_xml(
        pi_import_from in varchar2,
        pi_dgrm_content in flow_diagrams.dgrm_content%type,
        pi_file_name in varchar2
    )
    return boolean
    is
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_xmltype xmltype;
        l_err boolean := true;
    begin
        if (pi_import_from = 'text') then
            l_dgrm_content := pi_dgrm_content;
        else
            select to_clob(blob_content)
            into l_dgrm_content
            from apex_application_temp_files
            where name = pi_file_name;
        end if;
        begin
            l_xmltype := xmltype.createXML(l_dgrm_content);
        exception when others then
            l_err := false;
        end;
        return l_err;
    end is_valid_xml;

    function upload_and_parse(
        pi_import_from in varchar2,
        pi_dgrm_name in flow_diagrams.dgrm_name%type,
        pi_dgrm_category in flow_diagrams.dgrm_category%type,
        pi_dgrm_version in flow_diagrams.dgrm_version%type,
        pi_dgrm_content in flow_diagrams.dgrm_content%type,
        pi_file_name in varchar2,
        pi_force_overwrite in varchar2
    ) 
    return flow_diagrams.dgrm_id%type
    is
        l_dgrm_id flow_diagrams.dgrm_id%type;
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_dgrm_exists number;
        l_dgrm_status flow_diagrams.dgrm_status%type;
    begin
        select count(*)
          into l_dgrm_exists
          from flow_diagrams
         where dgrm_name = pi_dgrm_name
           and dgrm_version = pi_dgrm_version
        ;

        if (l_dgrm_exists > 0) then
            select dgrm_status
            into l_dgrm_status
            from flow_diagrams
            where dgrm_name = pi_dgrm_name
            and dgrm_version = pi_dgrm_version
            ;
        end if;

        if (l_dgrm_exists = 0 or (l_dgrm_exists > 0 and pi_force_overwrite = 'Y' and l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft)) then
            if (pi_import_from = 'text') then
                l_dgrm_content := pi_dgrm_content;
            else
                select to_clob(blob_content)
                into l_dgrm_content
                from apex_application_temp_files
                where name = pi_file_name;
            end if;
        
            l_dgrm_id := flow_bpmn_parser_pkg.upload_diagram(
                pi_dgrm_name => pi_dgrm_name
                , pi_dgrm_version => pi_dgrm_version
                , pi_dgrm_category => pi_dgrm_category
                , pi_dgrm_content => l_dgrm_content
                , pi_force_overwrite => case pi_force_overwrite when 'Y' then true else false end
            );

            flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id);
        else
            if (l_dgrm_status = flow_constants_pkg.gc_dgrm_status_draft) then
                apex_error.add_error(
                    p_message => 'Model already exists.'
                    , p_display_location => apex_error.c_on_error_page
                );
            else
                apex_error.add_error(
                    p_message => 'Overwrite only possible for draft models.'
                    , p_display_location => apex_error.c_on_error_page
                );
            end if;
        end if;
        return l_dgrm_id;
    end upload_and_parse;

end flow_p0006_api;
/

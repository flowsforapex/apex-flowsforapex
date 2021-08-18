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

    function is_valid_multi_file_archive(
        pi_file_name in varchar2
    )
    return varchar2
    is
        l_mime_type    apex_application_temp_files.mime_type%type;
        l_blob_content apex_application_temp_files.blob_content%type;
        l_error        varchar2(4000);
        l_files        apex_zip.t_files;
        l_found_json   boolean := false;
    begin
        select mime_type, blob_content
        into l_mime_type, l_blob_content
        from apex_application_temp_files
        where name = pi_file_name;

        if ( l_mime_type != 'application/zip') then
            l_error := 'You should provide a valid Flows for APEX zip export file.';
        else
            l_files := apex_zip.get_files(
                p_zipped_blob => l_blob_content
            );
            for i in 1..l_files.count loop
                apex_debug.message(l_files(i));
                if ( l_files(i) = 'import.json' ) then
                    l_found_json := true;
                end if;
                exit when l_found_json;
            end loop;
            if ( l_found_json = false ) then
                l_error := 'Missing import.json file in the zip export file.';
            end if;
        end if;
        return l_error;
    end;

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

    procedure multiple_flow_import(
        pi_file_name       in varchar2,
        pi_force_overwrite in varchar2
    )
    is
        l_dgrm_id       flow_diagrams.dgrm_id%type;
        l_dgrm_name     flow_diagrams.dgrm_name%type;
        l_dgrm_category flow_diagrams.dgrm_category%type;
        l_dgrm_version  flow_diagrams.dgrm_version%type;
        l_dgrm_content  flow_diagrams.dgrm_content%type;
        l_file          varchar2(300);
        l_json_array    json_array_t;
        l_json_object   json_object_t;
        l_blob_content  blob;
        l_json_file     blob;
        l_bpmn_file     blob;
        l_clob          clob;
    begin
        select blob_content
        into l_blob_content
        from apex_application_temp_files
        where name = pi_file_name;

        l_json_file := apex_zip.get_file_content(
            p_zipped_blob => l_blob_content,
            p_file_name   => 'import.json'
        );

        l_json_array := json_array_t.parse(l_json_file);

        for i in 0..l_json_array.get_size() - 1 loop
            l_json_object := treat(l_json_array.get(i) as json_object_t);

            l_dgrm_name     := l_json_object.get_String('dgrm_name');
            l_dgrm_version  := l_json_object.get_String('dgrm_version');
            l_dgrm_category := l_json_object.get_String('dgrm_category');
            l_dgrm_name     := l_json_object.get_String('dgrm_name');
            l_file          := l_json_object.get_String('file');   

            l_bpmn_file := apex_zip.get_file_content(
                p_zipped_blob => l_blob_content,
                p_file_name   => l_file
            );

            select to_clob(l_bpmn_file)
            into l_clob
            from dual;
            
            l_dgrm_id := flow_p0006_api.upload_and_parse(
                  pi_import_from => 'text'
                , pi_dgrm_name => l_dgrm_name
                , pi_dgrm_category => l_dgrm_category
                , pi_dgrm_version => l_dgrm_version
                , pi_dgrm_content => l_clob
                , pi_file_name => null
                , pi_force_overwrite => pi_force_overwrite
            );
        end loop;
    end multiple_flow_import;

end flow_p0006_api;
/

create or replace package body flow_p0005_api
as

  function get_file_name
  (
    p_dgrm_id in number
  , p_include_version in varchar2
  , p_include_status in varchar2
  , p_include_category in varchar2
  , p_include_last_change_date in varchar2
  , p_download_as in varchar2
  ) 
  return varchar2
  is
    l_file_name      varchar2(300 char);

    l_dgrm_name        flow_diagrams.dgrm_name%type;
    l_dgrm_version     flow_diagrams.dgrm_version%type;
    l_dgrm_status      flow_diagrams.dgrm_status%type;
    l_dgrm_category    flow_diagrams.dgrm_category%type;
    l_dgrm_last_update flow_diagrams.dgrm_last_update%type;
  begin
    select dgrm_name
         , dgrm_version
         , dgrm_status
         , dgrm_category
         , dgrm_last_update
      into l_dgrm_name
         , l_dgrm_version
         , l_dgrm_status
         , l_dgrm_category
         , l_dgrm_last_update
      from flow_diagrams
     where dgrm_id = p_dgrm_id
    ;
    
    l_file_name := to_char(sysdate, 'YYYYMMDD-HH24MI') || '_' || l_dgrm_name;
    
    if (p_include_category = 'Y' and l_dgrm_category is not null) then
      l_file_name := l_file_name || '_' || l_dgrm_category;
    end if;
    if (p_include_status = 'Y') then
      l_file_name := l_file_name || '_' || l_dgrm_status;
    end if;
    if (p_include_version = 'Y') then
      l_file_name := l_file_name || '_' || l_dgrm_version;
    end if;
    if (p_include_last_change_date = 'Y') then
      l_file_name := l_file_name || '_' || to_char(l_dgrm_last_update, 'YYYYMMDD-HH24MI');
    end if;

    if (p_download_as = 'SQL') then
      l_file_name := l_file_name || '.sql';
    end if;
    if (p_download_as = 'BPMN') then
      l_file_name := l_file_name || '.bpmn';
    end if;
    return l_file_name;
  end get_file_name;


  function get_sql_script(
      p_dgrm_id in number
  ) 
  return clob
  is
    l_split_content apex_t_varchar2;
    l_sql clob;
    l_buffer varchar2(32767);  
    r_diagrams flow_diagrams%rowtype;
  begin 
    dbms_lob.createtemporary(l_sql,true, DBMS_LOB.CALL);

    select *
    into r_diagrams
    from flow_diagrams
    where dgrm_id = p_dgrm_id;

    l_buffer := 'declare'||utl_tcp.crlf;
    l_buffer := l_buffer||'  l_dgrm_content clob;'||utl_tcp.crlf;
    l_buffer := l_buffer||'begin'||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);

    l_split_content := apex_string.split(p_str => replace(r_diagrams.dgrm_content,  apex_application.CRLF,  apex_application.LF));
    l_buffer := '  l_dgrm_content := apex_string.join_clob('||utl_tcp.crlf;
    l_buffer := l_buffer||'    apex_t_varchar2('||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);

    for i in l_split_content.first..l_split_content.last
    loop
      if (i = l_split_content.first) then
        l_buffer := '      q''['||l_split_content(i)||']'''||utl_tcp.crlf;
      else
        l_buffer := '      ,q''['||l_split_content(i)||']'''||utl_tcp.crlf;
      end if;
      dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    end loop;
    l_buffer := '  ));';
    l_buffer := l_buffer||utl_tcp.crlf;
    l_buffer := l_buffer||'  flow_bpmn_parser_pkg.upload_and_parse('||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_name => '||dbms_assert.enquote_literal(r_diagrams.dgrm_name)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_version => '||dbms_assert.enquote_literal(r_diagrams.dgrm_version)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_category => '||dbms_assert.enquote_literal(r_diagrams.dgrm_category)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_content => l_dgrm_content'||utl_tcp.crlf||');'||utl_tcp.crlf;
    l_buffer := l_buffer||'end;'||utl_tcp.crlf||'/'||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    
    return l_sql;
  end get_sql_script;
  

  function get_bmpn_content(
      p_dgrm_id in number
  ) return clob
  is 
    l_dgrm_content flow_diagrams.dgrm_content%type;
  begin
    select dgrm_content
    into l_dgrm_content
    from flow_diagrams
    where dgrm_id = p_dgrm_id;

    return l_dgrm_content;
  end get_bmpn_content;

  function sanitize_file_name(
    p_file_name in varchar2
  )
  return varchar2
  is
    l_file_name varchar2(300 char);
  begin
    l_file_name := p_file_name;
    l_file_name := replace(l_file_name, '/', '_');
    l_file_name := replace(l_file_name, '\', '_');
    l_file_name := replace(l_file_name, '*', '_');
    l_file_name := replace(l_file_name, ':', '_');
    l_file_name := replace(l_file_name, '?', '_');
    l_file_name := replace(l_file_name, '|', '_');
    l_file_name := replace(l_file_name, '<', '_');
    l_file_name := replace(l_file_name, '>', '_');
    return l_file_name;
  end sanitize_file_name;

  function clob_to_blob(
    p_clob in clob
  )
  return blob
  is
    l_blob         BLOB;
    l_dest_offset  PLS_INTEGER := 1;
    l_src_offset   PLS_INTEGER := 1;
    l_lang_context PLS_INTEGER := DBMS_LOB.default_lang_ctx;
    l_warning      PLS_INTEGER := DBMS_LOB.warn_inconvertible_char;
  begin
    dbms_lob.createtemporary(
      lob_loc => l_blob,
      cache   => TRUE
    );
    dbms_lob.converttoblob(
      dest_lob      => l_blob,
      src_clob      => p_clob,
      amount        => DBMS_LOB.lobmaxsize,
      dest_offset   => l_dest_offset,
      src_offset    => l_src_offset, 
      blob_csid     => DBMS_LOB.default_csid,
      lang_context  => l_lang_context,
      warning       => l_warning
    );
  
    return l_blob;
  end clob_to_blob;

  procedure download_file(
      p_dgrm_id in number,
      p_file_name in varchar2,
      p_download_as in varchar2,
      p_multi_file in boolean default false
  )
  is 
    l_clob        clob;
    l_blob        blob;
    l_zip_file    blob;
    l_buffer      varchar2(32767);  
    l_length      integer;
    l_desc_offset pls_integer := 1;
    l_src_offset  pls_integer := 1;
    l_lang        pls_integer := 0;
    l_warning     pls_integer := 0;
    l_mime_type   varchar2(100) := 'application/octet';
    type r_flow   is record (
      dgrm_id       flow_diagrams.dgrm_id%type, 
      dgrm_name     flow_diagrams.dgrm_name%type,
      dgrm_version  flow_diagrams.dgrm_version%type,
      dgrm_status   flow_diagrams.dgrm_status%type,
      dgrm_category flow_diagrams.dgrm_category%type,
      filename      varchar2(300)
    );
    type t_flows  is table of r_flow;
    l_flows       t_flows;
    l_json_array  json_array_t;
    l_json_object json_object_t;
    l_json_clob   clob;
    l_sql_clob    clob;
    l_file_name   varchar2(300);
  begin
    l_file_name := p_file_name;

    if ( p_download_as = 'BPMN' ) then
      l_json_array := json_array_t('[]');
    end if;

    if ( p_multi_file ) then
      select 
        dgrm_id, 
        dgrm_name,
        dgrm_version,
        dgrm_status,
        dgrm_category,
        dgrm_name||'_'||dgrm_version as filename
      bulk collect into l_flows
      from flow_diagrams 
      where dgrm_id in (
        select n001
        from apex_collections
        where collection_name = 'C_SELECT'
      );

    else
      l_flows := t_flows(r_flow(p_dgrm_id, p_file_name));
    end if;

    for i in 1..l_flows.count()
    loop
      if (p_download_as = 'BPMN') then
          l_clob := flow_p0005_api.get_bmpn_content(p_dgrm_id => l_flows(i).dgrm_id);
          apex_debug.message(dbms_lob.getlength(l_clob));
      end if;
      if (p_download_as = 'SQL') then
        l_clob := flow_p0005_api.get_sql_script(p_dgrm_id => l_flows(i).dgrm_id);
      end if;

      l_blob := clob_to_blob(l_clob);

      if ( p_multi_file ) then
        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => sanitize_file_name(l_flows(i).filename) || '.' || lower(p_download_as),
          p_content     => l_blob
        );

        if ( p_download_as = 'BPMN' ) then
          l_json_object := json_object_t('{}');
          l_json_object.put('dgrm_name' ,  l_flows(i).dgrm_name);
          l_json_object.put('dgrm_version' ,  l_flows(i).dgrm_version);
          l_json_object.put('dgrm_status' ,  l_flows(i).dgrm_status);
          l_json_object.put('dgrm_category' ,  l_flows(i).dgrm_category);
          l_json_object.put('file' ,  sanitize_file_name(l_flows(i).filename) || '.bpmn');

          l_json_array.append(l_json_object);
        elsif ( p_download_as = 'SQL' ) then
          l_sql_clob := l_sql_clob||'@"'||sanitize_file_name(l_flows(i).filename) || '.' || lower(p_download_as)||'";'||utl_tcp.crlf;
        end if;
      end if;
    end loop;

    if ( p_multi_file ) then
      if ( p_download_as = 'BPMN' ) then
        l_json_clob := treat(l_json_array as json_element_t).to_clob(); 

        l_blob := clob_to_blob(l_json_clob);

        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => 'import.json',
          p_content     => l_blob
        );
      elsif ( p_download_as = 'SQL' ) then
        l_sql_clob := 'set define off;' || utl_tcp.crlf || l_sql_clob || utl_tcp.crlf;
        l_blob := clob_to_blob(l_sql_clob);
        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => 'import.sql',
          p_content     => l_blob
        );
      end if;

      apex_zip.finish (
        p_zipped_blob => l_zip_file 
      );
      l_blob := l_zip_file;
      l_mime_type := 'application/zip';

      l_file_name := 'F4A_'||to_char(systimestamp, 'YYYYMMDD_HH24MISS')||'.zip';
    end if;

    l_length := dbms_lob.getlength(l_blob);

    owa_util.mime_header(l_mime_type, false) ;
    htp.p('Content-length: ' || l_length);
    htp.p('Content-Disposition: attachment; filename="'||sanitize_file_name(l_file_name)||'"');
    owa_util.http_header_close;
    wpg_docload.download_file(l_blob);

    apex_application.stop_apex_engine;
  end download_file;

end flow_p0005_api;
/

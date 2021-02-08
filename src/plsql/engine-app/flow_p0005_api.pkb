create or replace package body flow_p0005_api
as

  function get_file_name(
      p_dgrm_id in number,
      p_include_version in varchar2,
      p_include_status in varchar2,
      p_include_category in varchar2,
      p_include_last_change_date in varchar2,
      p_download_as in varchar2
  ) 
  return varchar2
  is
    l_file_name varchar2(100);
    l_dgrm_name flow_diagrams.dgrm_name%type;
    l_dgrm_version flow_diagrams.dgrm_version%type;
    l_dgrm_status flow_diagrams.dgrm_status%type;
    l_dgrm_category flow_diagrams.dgrm_category%type;
    l_dgrm_last_update flow_diagrams.dgrm_last_update%type;
  begin
    select 
        dgrm_name,
        dgrm_version,
        dgrm_status,
        dgrm_category,
        dgrm_last_update
    into 
        l_dgrm_name,
        l_dgrm_version,
        l_dgrm_status,
        l_dgrm_category,
        l_dgrm_last_update
    from flow_diagrams
    where dgrm_id = p_dgrm_id;
    
    l_file_name := to_char(sysdate, 'YYYY-MON-DD_HH24-MI')||'_'||l_dgrm_name;
    
    if (p_include_category = 'Y' and l_dgrm_category is not null) then
        l_file_name := l_file_name||'_'||l_dgrm_category;
    end if;
    if (p_include_status = 'Y') then
        l_file_name := l_file_name||'_'||l_dgrm_status;
    end if;
    if (p_include_version = 'Y') then
        l_file_name := l_file_name||'_'||l_dgrm_version;
    end if;
    if (p_include_last_change_date = 'Y') then
        l_file_name := l_file_name||'_'||to_char(l_dgrm_last_update, 'YYYY-MON-DD_HH24-MI');
    end if;
    if (p_download_as = 'SQL') then
        l_file_name := l_file_name||'.sql';
    end if;
    if (p_download_as = 'BPMN') then
        l_file_name := l_file_name||'.bpmn';
    end if;
    return l_file_name;
  end get_file_name;


  function get_sql_script(
      p_dgrm_id in number
  ) 
  return clob
  is
    l_clob clob;
    l_buffer varchar2(32767);  
    l_length integer;
    r_diagrams flow_diagrams%rowtype;
    l_diagram_content clob;
  begin 
    dbms_lob.createtemporary(l_clob,true);
    dbms_lob.createtemporary(l_diagram_content,true);

    select *
    into r_diagrams
    from flow_diagrams
    where dgrm_id = p_dgrm_id;

    l_buffer := 'insert into flow_diagrams (dgrm_name, dgrm_version, dgrm_category, dgrm_last_update, dgrm_content) values (';
    l_buffer := l_buffer||dbms_assert.enquote_literal(r_diagrams.dgrm_name)||', ';
    l_buffer := l_buffer||dbms_assert.enquote_literal(r_diagrams.dgrm_version)||', ';
    l_buffer := l_buffer||dbms_assert.enquote_literal(r_diagrams.dgrm_category)||', ';
    l_buffer := l_buffer||'TIMESTAMP '||dbms_assert.enquote_literal(to_char(r_diagrams.dgrm_last_update, 'YYYY-MM-DD HH24:MI:SS TZR'))||', ';
    dbms_lob.writeappend(l_clob, length(l_buffer), l_buffer);

    l_diagram_content := r_diagrams.dgrm_content;
    l_buffer := 'apex_string.join_clob(
                    apex_t_varchar2(';
    while (dbms_lob.getlength(l_diagram_content) > 4000) loop
      l_buffer := l_buffer||'q''['||dbms_lob.substr(l_diagram_content, 4000, 1)||']'','||utl_tcp.crlf;
      dbms_lob.writeappend(l_clob, length(l_buffer), l_buffer);
      l_diagram_content := dbms_lob.substr(l_diagram_content, 4001);
    end loop;
    l_buffer := 'q''['||l_diagram_content||']'')));'||utl_tcp.crlf;
    dbms_lob.writeappend(l_clob, length(l_buffer), l_buffer);

    --dbms_lob.freetemporary(l_clob);
    --dbms_lob.freetemporary(l_diagram_content);
    
    return l_clob;
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

  procedure download_file(
      p_dgrm_id in number,
      p_file_name in varchar2,
      p_download_as in varchar2
  )
  is 
    l_clob clob;
    l_blob blob;
    l_buffer varchar2(32767);  
    l_length integer;
    l_desc_offset   pls_integer := 1;
    l_src_offset    pls_integer := 1;
    l_lang          pls_integer := 0;
    l_warning       pls_integer := 0;
  begin
    dbms_lob.createtemporary(l_clob,true);
    dbms_lob.createtemporary(l_blob,true);

    if (p_download_as = 'BPMN') then
        l_clob := flow_p0005_api.get_bmpn_content(p_dgrm_id => p_dgrm_id);
    end if;
    if (p_download_as = 'SQL') then
      l_clob := flow_p0005_api.get_sql_script(p_dgrm_id => p_dgrm_id);
    end if;

    dbms_lob.converttoblob(l_blob, l_clob, dbms_lob.getlength(l_clob), l_desc_offset, l_src_offset, dbms_lob.default_csid, l_lang, l_warning);
  l_length := dbms_lob.getlength(l_blob);

  owa_util.mime_header('application/octet',false) ;
  htp.p('Content-length: ' || l_length);
  htp.p('Content-Disposition: attachment; filename="'||p_file_name||'"') ;
  owa_util.http_header_close;
  wpg_docload.download_file(l_blob);

  dbms_lob.freetemporary(l_blob);
  dbms_lob.freetemporary(l_clob);
  apex_application.stop_apex_engine;
  end download_file;

end flow_p0005_api;
/

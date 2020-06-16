create or replace package body flow_bpmn_parser_pkg
as
  subtype t_vc50  is varchar2(50 char);

  function upload_diagram
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
    return flow_diagrams.dgrm_id%type
  as
    l_cnt     number;
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin

    begin
      select dgrm_id
        into l_dgrm_id
        from flow_diagrams
       where dgrm_name = pi_dgrm_name
      ;
    exception
      when when no_data_found then
        l_dgrm_id := null;
    end;

    if l_dgrm_id is null then
      insert
        into flow_diagrams ( dgrm_name, dgrm_content )
        values ( pi_dgrm_name, pi_dgrm_content )
      returning dgrm_id into l_dgrm_id
      ;
    else
      update flow_diagrams
         set dgrm_content = pi_dgrm_content
       where dgrm_id = l_dgrm_id
      ;
    end if;

    return l_dgrm_id;

  end upload_diagram;

  procedure upload_diagram
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
    l_dgrm_id := upload_diagram( pi_dgrm_name => pi_dgrm_name, pi_dgrm_content => pi_dgrm_content );
  end upload_diagram;

  procedure cleanup_parsing_tables
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  )
  as
  begin
    delete
      from flow_connections conn
     where conn.conn_dgrm_id = pi_dgrm_id
    ;

    delete
      from flow_objects objt
     where objt.objt_dgrm_id = pi_dgrm_id
    ;
  end cleanup_parsing_tables;

  procedure insert_object
  (
    pi_objt_dgrm_id   in flow_objects.objt_dgrm_id%type
  , pi_objt_bpmn_id   in flow_objects.objt_id%type
  , pi_objt_name      in flow_objects.objt_name%type default null
  , pi_objt_type      in flow_objects.objt_type%type default null
  , pi_objt_tag_name  in flow_objects.objt_tag_name%type default null
  , pi_objt_objjt_id  in flow_objects.objt_objt_id%type default null
  , po_objt_id       out nocopy flow_objects.objt_id%type
  )
  as
  begin
    insert
      into flow_objects
           (
             objt_dgrm_id
           , objt_bpmn_id
           , objt_name
           , objt_type
           , objt_tag_name
           , objt_objt_id
           )
    values (
             pi_objt_dgrm_id
           , pi_objt_bpmn_id
           , pi_objt_name
           , pi_objt_type
           , pi_objt_tag_name
           , pi_objt_objt_id
           )
      returning objt_id into po_objt_id
    ;
  end insert_object;

  procedure insert_connection
  (
    pi_conn_dgrm_id      in flow_connections.conn_dgrm_id%type
  , pi_conn_bpmn_id      in flow_connections.conn_bpmn_id%type
  , pi_conn_name         in flow_connections.conn_name%type
  , pi_conn_src_objt_id  in flow_connections.conn_source_ref%type
  , pi_conn_tgt_objt_id  in flow_connections.conn_target_ref%type
  , pi_conn_type         in flow_connections.conn_type%type
  , pi_conn_tag_name     in flow_connections.conn_tag_name%type
  , pi_conn_origin       in flow_connections.conn_origin%type -- ?? needed ??
  , po_conn_id          out flow_connections.conn_id%type
  )
  as
  begin
    insert
      into flow_connections
            (
              conn_dgrm_name
            , conn_id
            , conn_name
            , conn_source_ref
            , conn_target_ref
            , conn_type
            , conn_tag_name
            , conn_origin
            )
    values (
              p_conn_dgrm_name
            , p_conn_id
            , p_conn_name
            , p_conn_source_ref
            , p_conn_target_ref
            , p_conn_type
            , p_conn_tag_name
            , p_conn_origin
            )
    ;
  end insert_connection;

  procedure parse_steps
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_xml          in xmltype
  , p_proc_type    in t_vc50
  , p_proc_id      in t_vc50
  )
  as
  begin
    for rec in (
        select steps.steps_type
             , steps.steps_name
             , steps.steps_id
             , steps.source_ref
             , steps.target_ref
             , listagg( cons.incoming, '|' ) within group ( order by cons.incoming ) as flows_in
             , listagg( cons.outgoing, '|' ) within group ( order by cons.outgoing ) as flows_out
          from xmltable
               (
                 xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
               , '*' passing p_xml
                 columns
                   steps_type varchar2(50 char)  path 'name()'
                 , steps_name varchar2(200 char) path '@name'
                 , steps_id   varchar2(50 char)  path '@id'
                 , source_ref varchar2(50 char)  path '@sourceRef'
                 , target_ref varchar2(50 char)  path '@targetRef'
                 , inout      xmltype            path '*' default xmltype('<dummy>dummy</dummy>')
               ) steps
             , xmltable
               (
                 xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
               , '*' passing steps.inout
                 columns
                   incoming varchar2(50 char) path '/bpmn:incoming/text()'
                 , outgoing varchar2(50 char) path '/bpmn:outgoing/text()'
               ) cons
      group by steps.steps_type
             , steps.steps_name
             , steps.steps_id
             , steps.source_ref
             , steps.target_ref
    ) loop
      case
        -- We ignore Incoming and Outgoing here,
        -- because those become attributes on existing connections
        when rec.steps_type in ('bpmn:incoming', 'bpmn:outgoing') then
          null;
        when rec.source_ref is null then -- assume objects don't have a sourceRef attribute
          insert_object
          (
            p_objt_dgrm_name => p_diagram_name
          , p_objt_id       => rec.steps_id
          , p_objt_name     => rec.steps_name
          , p_objt_type     => p_proc_type
          , p_objt_tag_name => rec.steps_type
          , p_objt_incoming => rec.flows_in
          , p_objt_outgoing => rec.flows_out
          , p_objt_origin   => p_proc_id
          );
        else
          insert_connection
          (
            p_conn_dgrm_name   => p_diagram_name
          , p_conn_id         => rec.steps_id
          , p_conn_name       => rec.steps_name
          , p_conn_source_ref => rec.source_ref
          , p_conn_target_ref => rec.target_ref
          , p_conn_type       => p_proc_type
          , p_conn_tag_name   => rec.steps_type
          , p_conn_origin     => p_proc_id
          );
      end case;
    end loop;  
  end parse_steps;
  procedure parse_xml
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_xml       in xmltype
  , pi_parent_id in t_vc50
  )
  as
  begin
    if pi_parent_id is null then
      for rec in (
                 select proc.proc_id
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , '/bpmn:definitions/bpmn:process' passing pi_xml
                        columns
                          proc_id        varchar2(50 char) path '@id'
                        , proc_type      varchar2(50 char) path 'name()'
                        , proc_steps     xmltype           path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype           path 'bpmn:subProcess'
                      ) proc
                 )
      loop
        -- insert each process as an object so we can reference later
        insert_object
        (
          pi_objt_dgrm_id => pi_dgrm_id
        , pi_objt_id      => rec.proc_id
        , pi_objt_type    => rec.proc_type
        , pi_parent_id    => pi_parent_id
        );
        parse_steps( p_diagram_name => p_diagram_name, p_xml => rec.proc_steps, p_proc_type => rec.proc_type, p_proc_id => rec.proc_id );
        if rec.proc_sub_procs is not null then
          parse_xml( p_diagram_name => p_diagram_name, p_xml => rec.proc_sub_procs, p_parent_id => rec.proc_id );
        end if;        
      end loop;
    else
      for rec in (
                 select proc.proc_id
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , 'bpmn:subProcess' passing p_xml
                        columns
                          proc_id        varchar2(50 char) path '@id'
                        , proc_type      varchar2(50 char) path 'name()'
                        , proc_steps     xmltype           path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype           path 'bpmn:subProcess'
                      ) proc
                 )
      loop
        -- We add an entry for a sub process here,
        -- as it is an object within the master process
        insert_object
        (
          pi_objt_dgrm_id => pi_dgrm_id
        , pi_objt_id      => rec.proc_id
        , pi_objt_type    => rec.proc_type
        , pi_parent_id    => pi_parent_id
        );

        parse_steps
        ( 
          pi_dgrm_id => p_diagram_name
        , p_xml => rec.proc_steps
        , p_proc_type => rec.proc_type
        , p_proc_id => rec.proc_id
        );
        -- We go into recursion if we found any sub process
        if rec.proc_sub_procs is not null then
          parse_xml
          (
            p_diagram_name => p_diagram_name
          , p_xml => rec.proc_sub_procs
          , p_parent_id => rec.proc_id
          );
        end if;        
      end loop;
    end if;
  end parse_xml;
  
  procedure parse
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  )
  as
    l_dgrm_content clob;
  begin    
    -- delete any existing parsed information before parsing again
    cleanup_parsing_tables( p_diagram_name => p_diagram_name );
    
    -- get the CLOB content
    select dgrm_content
      into l_dgrm_content
      from flow_diagrams
     where dgrm_id = pi_dgrm_id
    ;
    
    -- start recursive processsing of xml
    parse_xml( pi_dgrm_id => p_dgrm_id, pi_xml => xmltype(l_dgrm_content), pi_parent_id => null );
  end parse;
  
  procedure upload_and_parse
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
    l_dgrm_id := upload( pi_dgrm_name => pi_dgrm_name, pi_dgrm_content => pi_dgrm_content );
    parse( pi_dgrm_id => pi_dgrm_id );
  end upload_and_parse;

end flow_bpmn_parser_pkg;
/

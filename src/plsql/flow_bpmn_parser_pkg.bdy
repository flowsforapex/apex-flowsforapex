create or replace package body flow_bpmn_parser_pkg
as
  subtype t_vc50  is varchar2(50 char);
  procedure upload_diagram
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  )
  as
  begin
    merge into flow_diagrams d
         using (select ac.clob001
                     , td.p_diagram_name
                  from apex_collections ac
                     , (select p_diagram_name from dual) td
                 where ac.collection_name = 'CLOB_CONTENT'
               ) s
            on ( d.dgrm_name = s.p_diagram_name )
      when matched then
        update
           set d.dgrm_content = s.clob001
      when not matched then
        insert ( d.dgrm_name, d.dgrm_content )
        values ( s.p_diagram_name, s.clob001 )
    ;
  end upload_diagram;
  procedure cleanup_parsing_tables
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  )
  as
  begin
    delete
      from flow_connections conn
     where conn.conn_dgrm_name = p_diagram_name
    ;
    delete
      from flow_objects objt
     where objt.objt_dgrm_name = p_diagram_name
    ;
  end cleanup_parsing_tables;
  procedure insert_object
  (
    p_objt_dgrm_name in flow_objects.objt_dgrm_name%type
  , p_objt_id       in flow_objects.objt_id%type
  , p_objt_name     in flow_objects.objt_name%type default null
  , p_objt_type     in flow_objects.objt_type%type default null
  , p_objt_tag_name in flow_objects.objt_tag_name%type default null
  , p_objt_incoming in flow_objects.objt_incoming%type default null
  , p_objt_outgoing in flow_objects.objt_outgoing%type default null
  , p_objt_origin   in flow_objects.objt_origin%type default null
  )
  as
  begin
    insert
      into flow_objects
           (
             objt_dgrm_name
           , objt_id
           , objt_name
           , objt_type
           , objt_tag_name
           , objt_incoming
           , objt_outgoing
           , objt_origin
           )
    values (
             p_objt_dgrm_name
           , p_objt_id
           , p_objt_name
           , p_objt_type
           , p_objt_tag_name
           , p_objt_incoming
           , p_objt_outgoing
           , p_objt_origin
           )
    ;
  end insert_object;
  procedure insert_connection
  (
    p_conn_dgrm_name   in flow_connections.conn_dgrm_name%type
  , p_conn_id         in flow_connections.conn_id%type
  , p_conn_name       in flow_connections.conn_name%type
  , p_conn_source_ref in flow_connections.conn_source_ref%type
  , p_conn_target_ref in flow_connections.conn_target_ref%type
  , p_conn_type       in flow_connections.conn_type%type
  , p_conn_tag_name   in flow_connections.conn_tag_name%type
  , p_conn_origin     in flow_connections.conn_origin%type
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
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_xml          in xmltype
  , p_parent_id    in t_vc50
  )
  as
  begin
    if p_parent_id is null then
      for rec in (
                 select proc.proc_id
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , '/bpmn:definitions/bpmn:process' passing p_xml
                        columns
                          proc_id        varchar2(50 char) path '@id'
                        , proc_type      varchar2(50 char) path 'name()'
                        , proc_steps     xmltype           path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype           path 'bpmn:subProcess'
                      ) proc
                 )
      loop
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
            p_objt_dgrm_name => p_diagram_name
          , p_objt_id       => rec.proc_id
          , p_objt_type     => rec.proc_type
          , p_objt_origin   => p_parent_id
        );
        parse_steps
        ( 
          p_diagram_name => p_diagram_name
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
  
  procedure parse_collaboration
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_xml          in xmltype
  )
  as
  begin
    for rec in (
                 select colab_id
                      , colab_name
                      , colab_type
                      , colab_src_ref
                      , colab_tgt_ref
                   from xmltable
                        (
                          xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                        , '/bpmn:definitions/bpmn:collaboration/*' passing p_xml
                          columns
                            colab_id      varchar2(50 char)  path '@id'
                          , colab_name    varchar2(200 char) path '@name'
                          , colab_type    varchar2(50 char)  path 'name()'
                          , colab_src_ref varchar2(50 char)  path '@sourceRef'
                          , colab_tgt_ref varchar2(50 char)  path '@targetRef'
                        ) colab    
    ) loop
    
      case
        when rec.colab_src_ref is null then
          insert_object
          (
            p_objt_dgrm_name => p_diagram_name
          , p_objt_id        => rec.colab_id
          , p_objt_name      => rec.colab_name
          , p_objt_type      => null
          , p_objt_tag_name  => rec.colab_type
          , p_objt_incoming  => null
          , p_objt_outgoing  => null
          , p_objt_origin    => null
          );
        else
          insert_connection
          (
            p_conn_dgrm_name   => p_diagram_name
          , p_conn_id          => rec.colab_id
          , p_conn_name        => rec.colab_name
          , p_conn_source_ref  => rec.colab_src_ref
          , p_conn_target_ref  => rec.colab_tgt_ref
          , p_conn_type        => null
          , p_conn_tag_name    => rec.colab_type
          , p_conn_origin      => null
          );          
      end case;
    
    end loop;
    
  end parse_collaboration;
  
  procedure parse
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  )
  as
    l_dgrm_content clob;
  begin
    -- take over the XML stored in the APEX collection into table flow_diagrams
    upload_diagram( p_diagram_name => p_diagram_name );
    
    -- delete any existing parsed information before parsing again
    cleanup_parsing_tables( p_diagram_name => p_diagram_name );
    
    -- get the CLOB content
    select dgrm_content
      into l_dgrm_content
      from flow_diagrams
     where dgrm_name = p_diagram_name
    ;
    
    -- Parse Top Level Collaboration once
    parse_collaboration( p_diagram_name => p_diagram_name, p_xml => xmltype(l_dgrm_content) );
    
    -- start recursive processsing of remaining xml structures
    parse_xml( p_diagram_name => p_diagram_name, p_xml => xmltype(l_dgrm_content), p_parent_id => null );
  end parse;
  
end flow_bpmn_parser_pkg;
/
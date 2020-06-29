create or replace package body flow_bpmn_parser_pkg
as

  -- Standard Data Types to use
  subtype t_vc50  is varchar2(50 char);
  subtype t_vc200 is varchar2(200 char);

  -- Types for temporary storage of parsing result
  type t_objt_rec is
    record
    (
      objt_bpmn_id        t_vc50
    , objt_name           t_vc200
    , objt_type           t_vc50
    , objt_tag_name       t_vc50
    , objt_parent_bpmn_id t_vc50
    );
  type t_objt_tab is table of t_objt_rec;

  type t_conn_rec is
    record
    (
      conn_bpmn_id     t_vc50
    , conn_name        t_vc200
    , conn_src_bpmn_id t_vc50
    , conn_tgt_bpmn_id t_vc50
    , conn_type        t_vc50
    , conn_tag_name    t_vc50
    , conn_origin      t_vc50
    );
  type t_conn_tab is table of t_conn_rec;

  type t_id_lookup_tab is table of number index by t_vc50;

  -- Variables to hold data during parse run
  g_dgrm_id     flow_diagrams.dgrm_id%type;
  g_objects     t_objt_tab;
  g_connections t_conn_tab;

  -- Let's see if we need this or not
  g_objt_lookup t_id_lookup_tab;


  procedure register_object
  (
    pi_objt_bpmn_id        in flow_objects.objt_bpmn_id%type
  , pi_objt_name           in flow_objects.objt_name%type default null
  , pi_objt_type           in flow_objects.objt_type%type default null
  , pi_objt_tag_name       in flow_objects.objt_tag_name%type default null
  , pi_objt_parent_bpmn_id in flow_objects.objt_bpmn_id%type default null
  )
  as
    l_objt_rec t_objt_rec;
  begin
  
    l_objt_rec.objt_bpmn_id        := pi_objt_bpmn_id;
    l_objt_rec.objt_name           := pi_objt_name;
    l_objt_rec.objt_type           := pi_objt_type;
    l_objt_rec.objt_tag_name       := pi_objt_tag_name;
    l_objt_rec.objt_parent_bpmn_id := pi_objt_parent_bpmn_id;

    g_objects( g_objects.count + 1 ) := l_objt_rec;
  
  end register_object;

  procedure register_connection
  (
    pi_conn_bpmn_id     in flow_connections.conn_bpmn_id%type
  , pi_conn_name        in flow_connections.conn_name%type
  , pi_conn_src_bpmn_id in flow_objects.objt_bpmn_id%type
  , pi_conn_tgt_bpmn_id in flow_objects.objt_bpmn_id%type
  , pi_conn_type        in flow_connections.conn_type%type
  , pi_conn_tag_name    in flow_connections.conn_tag_name%type
  , pi_conn_origin      in flow_connections.conn_origin%type
  )
  as
    l_conn_rec t_conn_rec;
  begin

    l_conn_rec.conn_bpmn_id     := pi_conn_bpmn_id;
    l_conn_rec.conn_name        := pi_conn_name;
    l_conn_rec.conn_src_bpmn_id := pi_conn_src_bpmn_id;
    l_conn_rec.conn_tgt_bpmn_id := pi_conn_tgt_bpmn_id;
    l_conn_rec.conn_type        := pi_conn_type;
    l_conn_rec.conn_tag_name    := pi_conn_tag_name;
    l_conn_rec.conn_origin      := pi_conn_origin;

    g_connections( g_connections.count + 1 ) := l_conn_rec;

  end register_connection;

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
      when no_data_found then
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
  begin
    g_dgrm_id := upload_diagram( pi_dgrm_name => pi_dgrm_name, pi_dgrm_content => pi_dgrm_content );
  end upload_diagram;

  procedure cleanup_parsing_tables
  as
  begin
    delete
      from flow_connections conn
     where conn.conn_dgrm_id = g_dgrm_id
    ;

    delete
      from flow_objects objt
     where objt.objt_dgrm_id = g_dgrm_id
    ;
  end cleanup_parsing_tables;

  procedure insert_object
  (
    pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
  , pi_objt_name      in flow_objects.objt_name%type default null
  , pi_objt_type      in flow_objects.objt_type%type default null
  , pi_objt_tag_name  in flow_objects.objt_tag_name%type default null
  , pi_objt_objt_id   in flow_objects.objt_objt_id%type default null
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
             g_dgrm_id
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
  , pi_conn_src_objt_id  in flow_connections.conn_src_objt_id%type
  , pi_conn_tgt_objt_id  in flow_connections.conn_tgt_objt_id%type
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
              conn_dgrm_id
            , conn_bpmn_id
            , conn_name
            , conn_src_objt_id
            , conn_tgt_objt_id
            , conn_type
            , conn_tag_name
            , conn_origin
            )
    values (
              g_dgrm_id
            , pi_conn_bpmn_id
            , pi_conn_name
            , pi_conn_src_objt_id
            , pi_conn_tgt_objt_id
            , pi_conn_type
            , pi_conn_tag_name
            , pi_conn_origin
            )
      returning conn_id into po_conn_id
    ;
  end insert_connection;

  procedure parse_steps
  (
    pi_xml          in xmltype
  , pi_proc_type    in t_vc50
  , pi_proc_bpmn_id in t_vc50
  )
  as
  begin
    for rec in (
                select steps.steps_type
                     , steps.steps_name
                     , steps.steps_id
                     , steps.source_ref
                     , steps.target_ref
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                       , '*' passing pi_xml
                         columns
                           steps_type varchar2(50 char)  path 'name()'
                         , steps_name varchar2(200 char) path '@name'
                         , steps_id   varchar2(50 char)  path '@id'
                         , source_ref varchar2(50 char)  path '@sourceRef'
                         , target_ref varchar2(50 char)  path '@targetRef'
                       ) steps
               )
    loop
      -- fill the global variables
      case
        -- We ignore Incoming and Outgoing here,
        -- because those become attributes on existing connections
        when rec.steps_type in ('bpmn:incoming', 'bpmn:outgoing') then
          null;
        when rec.source_ref is null then -- assume objects don't have a sourceRef attribute
          register_object
          (
            pi_objt_bpmn_id        => rec.steps_id
          , pi_objt_name           => rec.steps_name
          , pi_objt_type           => pi_proc_type
          , pi_objt_tag_name       => rec.steps_type
          , pi_objt_parent_bpmn_id => pi_proc_bpmn_id
          );
        else
          register_connection
          (
            pi_conn_bpmn_id     => rec.steps_id
          , pi_conn_name        => rec.steps_name
          , pi_conn_src_bpmn_id => rec.source_ref
          , pi_conn_tgt_bpmn_id => rec.target_ref
          , pi_conn_type        => pi_proc_type
          , pi_conn_tag_name    => rec.steps_type
          , pi_conn_origin      => pi_proc_bpmn_id
          );        
      end case;
    end loop;  
  end parse_steps;
  
  procedure parse_xml
  (
    pi_xml       in xmltype
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

        -- register each process as an object so we can reference later
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
        , pi_objt_type           => rec.proc_type
        , pi_objt_parent_bpmn_id => pi_parent_id
        );

        -- parse immediate steps        
        parse_steps
        ( 
          pi_xml          => rec.proc_steps
        , pi_proc_type    => rec.proc_type
        , pi_proc_bpmn_id => rec.proc_id
        );
        
        -- recurse if sub processes found
        if rec.proc_sub_procs is not null then
        
          parse_xml
          ( 
            pi_xml => rec.proc_sub_procs
          , pi_parent_id => rec.proc_id
          );
        
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
                      , 'bpmn:subProcess' passing pi_xml
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
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
        , pi_objt_type           => rec.proc_type
        , pi_objt_parent_bpmn_id => pi_parent_id
        );

        -- parse any immediate steps
        parse_steps
        ( 
          pi_xml          => rec.proc_steps
        , pi_proc_type    => rec.proc_type
        , pi_proc_bpmn_id => rec.proc_id
        );
        
        -- recurse if we found any sub process
        if rec.proc_sub_procs is not null then
          parse_xml
          (
            pi_xml       => rec.proc_sub_procs
          , pi_parent_id => rec.proc_id
          );
        end if;        
      end loop;
    end if;
  end parse_xml;
  
  procedure parse
  as
    l_dgrm_content clob;
  begin    
    -- delete any existing parsed information before parsing again
    cleanup_parsing_tables;
    
    -- get the CLOB content
    select dgrm_content
      into l_dgrm_content
      from flow_diagrams
     where dgrm_id = g_dgrm_id
    ;
    
    -- start recursive processsing of xml
    parse_xml( pi_xml => xmltype(l_dgrm_content), pi_parent_id => null );
  end parse;
  
  procedure upload_and_parse
  (
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
  as
  begin
  
    upload_diagram( pi_dgrm_name => pi_dgrm_name, pi_dgrm_content => pi_dgrm_content );
    parse;
    
  end upload_and_parse;

end flow_bpmn_parser_pkg;
/

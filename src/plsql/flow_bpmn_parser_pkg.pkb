create or replace package body flow_bpmn_parser_pkg
as

  -- Standard Data Types to use
  subtype t_vc50  is varchar2(50 char);
  subtype t_vc200 is varchar2(200 char);

  -- Types for temporary storage of parsing result
  type t_objt_rec is
    record
    (
      objt_name           t_vc200
    , objt_type           t_vc50
    , objt_tag_name       t_vc50
    , objt_parent_bpmn_id t_vc50
    );
  type t_objt_tab is table of t_objt_rec index by t_vc50;

  type t_conn_rec is
    record
    (
      conn_name        t_vc200
    , conn_src_bpmn_id t_vc50
    , conn_tgt_bpmn_id t_vc50
    , conn_type        t_vc50
    , conn_tag_name    t_vc50
    , conn_origin      t_vc50
    );
  type t_conn_tab is table of t_conn_rec index by t_vc50;

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
  
    l_objt_rec.objt_name           := pi_objt_name;
    l_objt_rec.objt_type           := pi_objt_type;
    l_objt_rec.objt_tag_name       := pi_objt_tag_name;
    l_objt_rec.objt_parent_bpmn_id := pi_objt_parent_bpmn_id;

    g_objects( pi_objt_bpmn_id ) := l_objt_rec;
  
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

    l_conn_rec.conn_name        := pi_conn_name;
    l_conn_rec.conn_src_bpmn_id := pi_conn_src_bpmn_id;
    l_conn_rec.conn_tgt_bpmn_id := pi_conn_tgt_bpmn_id;
    l_conn_rec.conn_type        := pi_conn_type;
    l_conn_rec.conn_tag_name    := pi_conn_tag_name;
    l_conn_rec.conn_origin      := pi_conn_origin;

    g_connections( pi_conn_bpmn_id ) := l_conn_rec;

  end register_connection;

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
    pi_conn_bpmn_id      in flow_connections.conn_bpmn_id%type
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

  procedure process_objects
  as
    l_cur_objt_bpmn_id  t_vc50;
    l_next_objt_bpmn_id t_vc50;
    l_cur_object        t_objt_rec;
    l_objt_id           flow_objects.objt_id%type;
  begin

    l_cur_objt_bpmn_id := g_objects.first;
    while l_cur_objt_bpmn_id is not null
    loop
      -- reset object id, we get it if insert done
      l_objt_id     := null;
      l_cur_object := g_objects( l_cur_objt_bpmn_id );

      -- no parent, we can insert without checking further
      if l_cur_object.objt_parent_bpmn_id is null then
        
        insert_object
        (
          pi_objt_bpmn_id  => l_cur_objt_bpmn_id
        , pi_objt_name     => l_cur_object.objt_name
        , pi_objt_type     => l_cur_object.objt_type
        , pi_objt_tag_name => l_cur_object.objt_tag_name
        , po_objt_id       => l_objt_id
        );

      -- has parent but we know ID already
      elsif g_objt_lookup.exists( l_cur_object.objt_parent_bpmn_id ) then

        insert_object
        (
          pi_objt_bpmn_id  => l_cur_objt_bpmn_id
        , pi_objt_name     => l_cur_object.objt_name
        , pi_objt_type     => l_cur_object.objt_type
        , pi_objt_tag_name => l_cur_object.objt_tag_name
        , pi_objt_objt_id  => g_objt_lookup( l_cur_object.objt_parent_bpmn_id )
        , po_objt_id       => l_objt_id
        );

      end if;


      -- Get next ID for lookup and if object was processed
      -- put it into lookup and remove from things to process
      l_next_objt_bpmn_id := g_objects.next( l_cur_objt_bpmn_id );
      if l_objt_id is not null then

        g_objt_lookup( l_cur_objt_bpmn_id ) := l_objt_id;
        g_objects.delete( l_cur_objt_bpmn_id );

      end if;

      l_cur_objt_bpmn_id := l_next_objt_bpmn_id;
    end loop;

    -- restart with remaining set if still objects to process
    if g_objects.count > 0 then
      process_objects;
    end if;
  end process_objects;

  procedure process_connections
  as
    l_cur_conn_bpmn_id t_vc50;
    l_cur_conn         t_conn_rec;
    l_conn_id          flow_connections.conn_id%type;
  begin

    l_cur_conn_bpmn_id := g_connections.first;
    while l_cur_conn_bpmn_id is not null
    loop
      l_conn_id  := null;
      l_cur_conn := g_connections( l_cur_conn_bpmn_id );

      -- verify if we know the IDs for source and target connection if set
      -- anything strange stop all processing and raise error
      if (  ( l_cur_conn.conn_src_bpmn_id is not null and not g_objt_lookup.exists( l_cur_conn.conn_src_bpmn_id ) )
         or ( l_cur_conn.conn_tgt_bpmn_id is not null and not g_objt_lookup.exists( l_cur_conn.conn_tgt_bpmn_id ) )
         )
      then
        raise_application_error(-20000, 'Connection Source or Target not found!');
      else
        insert_connection
        (
          pi_conn_bpmn_id      => l_cur_conn_bpmn_id
        , pi_conn_name         => l_cur_conn.conn_name
        , pi_conn_src_objt_id  => case when l_cur_conn.conn_src_bpmn_id is not null then g_objt_lookup( l_cur_conn.conn_src_bpmn_id ) else null end
        , pi_conn_tgt_objt_id  => case when l_cur_conn.conn_tgt_bpmn_id is not null then g_objt_lookup( l_cur_conn.conn_tgt_bpmn_id ) else null end
        , pi_conn_type         => l_cur_conn.conn_type
        , pi_conn_tag_name     => l_cur_conn.conn_tag_name
        , pi_conn_origin       => l_cur_conn.conn_origin
        , po_conn_id           => l_conn_id
        );
      end if;

      l_cur_conn_bpmn_id := g_connections.next( l_cur_conn_bpmn_id );
    end loop;

  end process_connections;

  procedure finalize
  as
  begin

    process_objects;
    process_connections;
    
  end finalize;

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
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type_rem
                      , proc.proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                      , proc.proc_name
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , '/bpmn:definitions/bpmn:process' passing pi_xml
                        columns
                          proc_id        varchar2(50 char) path '@id'
                        , proc_type      varchar2(50 char) path 'name()'
                        , proc_name      varchar2(50 char) path '@name'
                        , proc_steps     xmltype           path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype           path 'bpmn:subProcess'
                      ) proc
                 )
      loop

        -- register each process as an object so we can reference later
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
        , pi_objt_type           => rec.proc_type_rem
        , pi_objt_tag_name       => rec.proc_type
        , pi_objt_name           => rec.proc_name
        , pi_objt_parent_bpmn_id => pi_parent_id
        );

        -- parse immediate steps        
        parse_steps
        ( 
          pi_xml          => rec.proc_steps
        , pi_proc_type    => rec.proc_type_rem
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
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type_rem
                      , proc.proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                      , proc.proc_name
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , 'bpmn:subProcess' passing pi_xml
                        columns
                          proc_id        varchar2(50 char) path '@id'
                        , proc_name      varchar2(50 char) path '@name'
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
        , pi_objt_type           => rec.proc_type_rem
        , pi_objt_tag_name       => rec.proc_type
        , pi_objt_name           => rec.proc_name
        , pi_objt_parent_bpmn_id => pi_parent_id
        );

        -- parse any immediate steps
        parse_steps
        ( 
          pi_xml          => rec.proc_steps
        , pi_proc_type    => rec.proc_type_rem
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

  procedure parse_collaboration
  (
    pi_xml in xmltype
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
                        , '/bpmn:definitions/bpmn:collaboration/*' passing pi_xml
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
          register_object
          (
            pi_objt_bpmn_id        => rec.colab_id
          , pi_objt_tag_name       => rec.colab_type
          , pi_objt_name           => rec.colab_name
          );
        else
          register_connection
          (
            pi_conn_bpmn_id     => rec.colab_id
          , pi_conn_name        => rec.colab_name
          , pi_conn_src_bpmn_id => rec.colab_src_ref
          , pi_conn_tgt_bpmn_id => rec.colab_tgt_ref
          , pi_conn_type        => null
          , pi_conn_tag_name    => rec.colab_type
          , pi_conn_origin      => null
          );

      end case;
    
    end loop;
    
  end parse_collaboration;

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

    -- parse out collaboration part first
    parse_collaboration( pi_xml => xmltype(l_dgrm_content) );    
    -- start recursive processsing of xml
    parse_xml( pi_xml => xmltype(l_dgrm_content), pi_parent_id => null );

    -- finally insert all parsed data
    finalize;

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

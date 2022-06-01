create or replace package body flow_bpmn_parser_pkg
as

  -- Variables to hold data during parse run
  g_dgrm_id        flow_diagrams.dgrm_id%type;
  g_objects        flow_parser_util.t_objt_tab;
  g_objt_expr      flow_parser_util.t_objt_expr_tab;
  g_connections    flow_parser_util.t_conn_tab;
  g_lane_refs      flow_parser_util.t_bpmn_ref_tab;
  g_default_cons   flow_parser_util.t_bpmn_id_tab;
  g_objt_lookup    flow_parser_util.t_id_lookup_tab;

  procedure register_object
  (
    pi_objt_bpmn_id        in flow_objects.objt_bpmn_id%type
  , pi_objt_name           in flow_objects.objt_name%type default null
  , pi_objt_tag_name       in flow_objects.objt_tag_name%type default null
  , pi_objt_sub_tag_name   in flow_objects.objt_sub_tag_name%type default null
  , pi_objt_parent_bpmn_id in flow_objects.objt_bpmn_id%type default null
  , pi_objt_attached_to    in flow_objects.objt_attached_to%type default null 
  , pi_objt_interrupting   in flow_objects.objt_interrupting%type default null
  )
  as
    l_objt_rec flow_parser_util.t_objt_rec;
  begin
    if pi_objt_bpmn_id is not null then
      if g_objects.exists( pi_objt_bpmn_id ) then
        l_objt_rec := g_objects( pi_objt_bpmn_id );
      end if;
      l_objt_rec.objt_name           := coalesce( pi_objt_name, l_objt_rec.objt_name );
      l_objt_rec.objt_tag_name       := coalesce( pi_objt_tag_name, l_objt_rec.objt_tag_name );
      l_objt_rec.objt_sub_tag_name   := coalesce( pi_objt_sub_tag_name, l_objt_rec.objt_sub_tag_name );
      l_objt_rec.objt_parent_bpmn_id := coalesce( pi_objt_parent_bpmn_id, l_objt_rec.objt_parent_bpmn_id );
      l_objt_rec.objt_attached_to    := coalesce( pi_objt_attached_to, l_objt_rec.objt_attached_to );
      l_objt_rec.objt_interrupting   := coalesce( pi_objt_interrupting, l_objt_rec.objt_interrupting );

      g_objects( pi_objt_bpmn_id ) := l_objt_rec;
    end if;
  end register_object;

  procedure register_object_attribute
  (
    pi_objt_bpmn_id   in flow_types_pkg.t_bpmn_id
  , pi_attribute_name in flow_types_pkg.t_bpmn_attributes_key
  , pi_value          in flow_types_pkg.t_bpmn_attribute_vc2
  )
  as
    l_namespace        flow_types_pkg.t_vc200;
    l_attribute        flow_types_pkg.t_vc200;
    l_namespace_object sys.json_object_t;
    l_json_element     sys.json_element_t;
  begin

    if not g_objects.exists( pi_objt_bpmn_id ) then
      register_object( pi_objt_bpmn_id => pi_objt_bpmn_id );
      g_objects(pi_objt_bpmn_id).objt_attributes := sys.json_object_t();
    end if;

    flow_parser_util.property_to_json
    (
      pi_property_name => pi_attribute_name
    , pi_value         => pi_value
    , po_namespace     => l_namespace
    , po_key           => l_attribute
    , po_json_element  => l_json_element
    );

    if l_namespace is not null then
      flow_parser_util.guarantee_named_object
      (
        pio_objt_attributes => g_objects(pi_objt_bpmn_id).objt_attributes
      , pi_key              => l_namespace
      );
      l_namespace_object := g_objects(pi_objt_bpmn_id).objt_attributes.get_object( l_namespace );
    else
      l_namespace_object := g_objects(pi_objt_bpmn_id).objt_attributes;
    end if;

    if l_json_element is not null then
      l_namespace_object.put( l_attribute, l_json_element );
    else
      l_namespace_object.put( l_attribute, pi_value );
    end if;

  end register_object_attribute;

  procedure register_object_expression
  (
    pi_objt_bpmn_id    in flow_objects.objt_bpmn_id%type
  , pi_expr_set        in flow_object_expressions.expr_set%type
  , pi_expr_order      in flow_object_expressions.expr_order%type
  , pi_expr_var_name   in flow_object_expressions.expr_var_name%type
  , pi_expr_var_type   in flow_object_expressions.expr_var_type%type
  , pi_expr_type       in flow_object_expressions.expr_type%type
  , pi_expr_expression in flow_object_expressions.expr_expression%type
  )
  as
    l_object_expression flow_parser_util.t_expr_rec;
    l_insert_index      pls_integer := 0;
  begin
    if pi_objt_bpmn_id is not null then
      l_object_expression.expr_set        := pi_expr_set;
      l_object_expression.expr_order      := pi_expr_order;
      l_object_expression.expr_var_name   := pi_expr_var_name;
      l_object_expression.expr_var_type   := pi_expr_var_type;
      l_object_expression.expr_type       := pi_expr_type;
      l_object_expression.expr_expression := pi_expr_expression;    

      -- Verify if we already have some variable expression for same object
      if g_objt_expr.exists(pi_objt_bpmn_id) then
        l_insert_index := g_objt_expr(pi_objt_bpmn_id).count + 1;
      else
        l_insert_index := 1;
      end if;

      g_objt_expr(pi_objt_bpmn_id)(l_insert_index) := l_object_expression;
    end if;
  end register_object_expression;

  procedure register_connection
  (
    pi_conn_bpmn_id     in flow_connections.conn_bpmn_id%type
  , pi_conn_name        in flow_connections.conn_name%type
  , pi_conn_src_bpmn_id in flow_objects.objt_bpmn_id%type
  , pi_conn_tgt_bpmn_id in flow_objects.objt_bpmn_id%type
  , pi_conn_tag_name    in flow_connections.conn_tag_name%type
  , pi_conn_origin      in flow_connections.conn_origin%type
  )
  as
    l_conn_rec flow_parser_util.t_conn_rec;
  begin
    if pi_conn_bpmn_id is not null then
      l_conn_rec.conn_name        := pi_conn_name;
      l_conn_rec.conn_src_bpmn_id := pi_conn_src_bpmn_id;
      l_conn_rec.conn_tgt_bpmn_id := pi_conn_tgt_bpmn_id;
      l_conn_rec.conn_tag_name    := pi_conn_tag_name;
      l_conn_rec.conn_origin      := pi_conn_origin;

      g_connections( pi_conn_bpmn_id ) := l_conn_rec;
    end if;
  end register_connection;

  procedure insert_object
  (
    pi_objt_bpmn_id       in flow_objects.objt_bpmn_id%type
  , pi_objt_name          in flow_objects.objt_name%type default null
  , pi_objt_tag_name      in flow_objects.objt_tag_name%type default null
  , pi_objt_objt_id       in flow_objects.objt_objt_id%type default null
  , pi_objt_sub_tag_name  in flow_objects.objt_sub_tag_name%type default null
  , pi_objt_objt_lane_id  in flow_objects.objt_objt_lane_id%type default null
  , pi_objt_attached_to   in flow_objects.objt_attached_to%type default null
  , pi_objt_interrupting  in flow_objects.objt_interrupting%type default null
  , pi_objt_attributes    in flow_objects.objt_attributes%type default null
  , po_objt_id           out nocopy flow_objects.objt_id%type
  )
  as
  begin
    insert
      into flow_objects
           (
             objt_dgrm_id
           , objt_bpmn_id
           , objt_name
           , objt_tag_name
           , objt_sub_tag_name
           , objt_objt_id
           , objt_objt_lane_id
           , objt_attached_to
           , objt_interrupting
           , objt_attributes
           )
    values (
             g_dgrm_id
           , pi_objt_bpmn_id
           , pi_objt_name
           , pi_objt_tag_name
           , pi_objt_sub_tag_name
           , pi_objt_objt_id
           , pi_objt_objt_lane_id
           , pi_objt_attached_to
           , pi_objt_interrupting
           , pi_objt_attributes
           )
      returning objt_id into po_objt_id
    ;
  end insert_object;

  procedure insert_object_expression
  (
    pi_expr_objt_id    in flow_object_expressions.expr_objt_id%type
  , pi_expr_set        in flow_object_expressions.expr_set%type
  , pi_expr_order      in flow_object_expressions.expr_order%type
  , pi_expr_var_name   in flow_object_expressions.expr_var_name%type
  , pi_expr_var_type   in flow_object_expressions.expr_var_type%type
  , pi_expr_type       in flow_object_expressions.expr_type%type
  , pi_expr_expression in flow_object_expressions.expr_expression%type
  )
  as
  begin
    insert
      into flow_object_expressions
           (
             expr_objt_id
           , expr_set
           , expr_order
           , expr_var_name
           , expr_var_type
           , expr_type
           , expr_expression
           )
    values (
             pi_expr_objt_id
           , pi_expr_set
           , pi_expr_order
           , pi_expr_var_name
           , upper(pi_expr_var_type)
           , pi_expr_type
           , pi_expr_expression
           )
    ;
  end insert_object_expression;

  procedure insert_connection
  (
    pi_conn_bpmn_id      in flow_connections.conn_bpmn_id%type
  , pi_conn_name         in flow_connections.conn_name%type
  , pi_conn_src_objt_id  in flow_connections.conn_src_objt_id%type
  , pi_conn_tgt_objt_id  in flow_connections.conn_tgt_objt_id%type
  , pi_conn_tag_name     in flow_connections.conn_tag_name%type
  , pi_conn_origin       in flow_connections.conn_origin%type -- ?? needed ??
  , po_conn_id          out flow_connections.conn_id%type
  )
  as
    l_conn_is_default flow_connections.conn_is_default%type := 0;
  begin
    l_conn_is_default := case when g_default_cons.exists(pi_conn_bpmn_id) then 1 else 0 end;
    insert
      into flow_connections
            (
              conn_dgrm_id
            , conn_bpmn_id
            , conn_name
            , conn_src_objt_id
            , conn_tgt_objt_id
            , conn_tag_name
            , conn_origin
            , conn_is_default
            )
    values (
              g_dgrm_id
            , pi_conn_bpmn_id
            , pi_conn_name
            , pi_conn_src_objt_id
            , pi_conn_tgt_objt_id
            , pi_conn_tag_name
            , pi_conn_origin
            , l_conn_is_default 
            )
      returning conn_id into po_conn_id
    ;
  end insert_connection;

  procedure process_object_expressions
  (
    pi_objt_id       in flow_object_expressions.expr_objt_id%type
  , pi_objt_bpmn_id  in flow_types_pkg.t_bpmn_id    
  )
  as
    l_cur_expressions flow_parser_util.t_expr_tab;
    l_cur_index       pls_integer;
  begin
    if g_objt_expr.exists(pi_objt_bpmn_id) then
      l_cur_index       := g_objt_expr(pi_objt_bpmn_id).first;
      while l_cur_index is not null loop
        insert_object_expression
        (
          pi_expr_objt_id    => pi_objt_id
        , pi_expr_set        => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_set
        , pi_expr_order      => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_order
        , pi_expr_var_name   => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_var_name
        , pi_expr_var_type   => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_var_type
        , pi_expr_type       => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_type
        , pi_expr_expression => g_objt_expr(pi_objt_bpmn_id)(l_cur_index).expr_expression
        );
        l_cur_index := g_objt_expr(pi_objt_bpmn_id).next(l_cur_index);
      end loop;
    end if;
  end process_object_expressions;

  procedure process_objects
  as
    l_cur_objt_bpmn_id  flow_types_pkg.t_bpmn_id;
    l_next_objt_bpmn_id flow_types_pkg.t_bpmn_id;
    l_cur_object        flow_parser_util.t_objt_rec;
    l_objt_id           flow_objects.objt_id%type;
    l_parent_check      boolean;
    l_lane_check        boolean;
  begin

    l_cur_objt_bpmn_id := g_objects.first;
    while l_cur_objt_bpmn_id is not null
    loop
      -- reset object id, we get it if insert done
      l_objt_id      := null;
      l_cur_object   := g_objects( l_cur_objt_bpmn_id );

      -- check possible parent and lane
      -- either not set or ID already known
      l_parent_check :=
           l_cur_object.objt_parent_bpmn_id is null
        or (   l_cur_object.objt_parent_bpmn_id is not null
           and g_objt_lookup.exists( l_cur_object.objt_parent_bpmn_id )
           )
      ;
      l_lane_check :=
           not g_lane_refs.exists( l_cur_objt_bpmn_id )
        or ( g_lane_refs.exists( l_cur_objt_bpmn_id )
           and g_objt_lookup.exists( g_lane_refs( l_cur_objt_bpmn_id ) )
           )
      ;

      -- checks passed insert into table
      if l_parent_check and l_lane_check  then

        insert_object
        (
          pi_objt_bpmn_id      => l_cur_objt_bpmn_id
        , pi_objt_name         => l_cur_object.objt_name
        , pi_objt_tag_name     => l_cur_object.objt_tag_name
        , pi_objt_objt_id      => case when l_cur_object.objt_parent_bpmn_id is not null then g_objt_lookup( l_cur_object.objt_parent_bpmn_id ) else null end
        , pi_objt_objt_lane_id => case when g_lane_refs.exists( l_cur_objt_bpmn_id ) then g_objt_lookup( g_lane_refs( l_cur_objt_bpmn_id ) ) else null end
        , pi_objt_sub_tag_name => l_cur_object.objt_sub_tag_name
        , pi_objt_attached_to  => l_cur_object.objt_attached_to
        , pi_objt_interrupting => l_cur_object.objt_interrupting
        , pi_objt_attributes   => case when l_cur_object.objt_attributes is not null then l_cur_object.objt_attributes.to_clob() else null end
        , po_objt_id           => l_objt_id
        );

        process_object_expressions
        (
          pi_objt_id      => l_objt_id
        , pi_objt_bpmn_id => l_cur_objt_bpmn_id
        );

      -- checks not passed skip record for now
      else
        null;
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
    l_cur_conn_bpmn_id flow_types_pkg.t_bpmn_id;
    l_cur_conn         flow_parser_util.t_conn_rec;
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
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
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
         and dgrm_version = pi_dgrm_version
      ;
    exception
      when no_data_found then
        l_dgrm_id := null;
    end;

    if l_dgrm_id is null then
      insert
        into flow_diagrams ( dgrm_name, dgrm_version, dgrm_category, dgrm_status, dgrm_last_update, dgrm_content )
        values ( pi_dgrm_name, pi_dgrm_version, pi_dgrm_category, 
                 pi_dgrm_status,  systimestamp, pi_dgrm_content )
      returning dgrm_id into l_dgrm_id
      ;
    else
      if (pi_force_overwrite) then
        update flow_diagrams
          set dgrm_content = pi_dgrm_content
            , dgrm_last_update = systimestamp
            , dgrm_status  = pi_dgrm_status
        where dgrm_id = l_dgrm_id
        ;
      end if;
    end if;

    return l_dgrm_id;

  end upload_diagram;

  procedure upload_diagram
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  )
  as
  begin
    g_dgrm_id := upload_diagram( pi_dgrm_name => pi_dgrm_name, pi_dgrm_version => pi_dgrm_version,
                                 pi_dgrm_category => pi_dgrm_category, pi_dgrm_content => pi_dgrm_content,
                                 pi_dgrm_status => pi_dgrm_status, pi_force_overwrite => pi_force_overwrite
                                  );
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

  procedure parse_lanes
  (
    pi_laneset_xml  in xmltype
  , pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
  begin
    for lane_rec in (
      select lanes.lane_id
           , lanes.lane_name
           , lanes.lane_type
           , lanes.child_elements
        from xmltable
             (
               xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
             , '*' passing pi_laneset_xml
               columns
                 lane_id   varchar2(50  char) path '@id'
               , lane_name varchar2(200 char) path '@name'
               , lane_type varchar2(50  char) path 'name()'
               , child_elements xmltype path '*'
             ) lanes
    ) loop

      register_object
      (
        pi_objt_bpmn_id        => lane_rec.lane_id
      , pi_objt_name           => lane_rec.lane_name
      , pi_objt_tag_name       => lane_rec.lane_type
      , pi_objt_parent_bpmn_id => pi_objt_bpmn_id
      );

      for node_rec in (
        select nodes.node_ref
          from xmltable
             (
               xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
             , '*' passing lane_rec.child_elements
               columns
                 node_ref   varchar2(50 char) path 'text()'
             ) nodes
      ) loop
        g_lane_refs( node_rec.node_ref ) := lane_rec.lane_id;
      end loop;

    end loop;

  end parse_lanes;

  function find_subtag_name
  (
    pi_xml in xmltype
  )
    return flow_types_pkg.t_bpmn_id
  as
    c_nsmap        constant flow_types_pkg.t_vc200 := flow_constants_pkg.gc_nsmap;
    l_return                flow_types_pkg.t_bpmn_id;
  begin
    l_return :=
      case
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_terminate_event_definition, nsmap => c_nsmap ) = 1   then flow_constants_pkg.gc_bpmn_terminate_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_timer_event_definition, nsmap => c_nsmap ) = 1       then flow_constants_pkg.gc_bpmn_timer_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_date, nsmap => c_nsmap ) = 1                   then flow_constants_pkg.gc_timer_type_date
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_duration, nsmap => c_nsmap ) = 1               then flow_constants_pkg.gc_timer_type_duration
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_cycle, nsmap => c_nsmap ) = 1                  then flow_constants_pkg.gc_timer_type_cycle
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_error_event_definition, nsmap => c_nsmap ) = 1       then flow_constants_pkg.gc_bpmn_error_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_escalation_event_definition, nsmap => c_nsmap ) = 1  then flow_constants_pkg.gc_bpmn_escalation_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_link_event_definition, nsmap => c_nsmap ) = 1        then flow_constants_pkg.gc_bpmn_link_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_message_event_definition, nsmap => c_nsmap ) = 1     then flow_constants_pkg.gc_bpmn_message_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_conditional_event_definition, nsmap => c_nsmap ) = 1 then flow_constants_pkg.gc_bpmn_conditional_event_definition
        when pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_signal_event_definition, nsmap => c_nsmap ) = 1      then flow_constants_pkg.gc_bpmn_signal_event_definition
        else null
      end
    ;

    return l_return;
  end find_subtag_name;

  procedure parse_process_variables
  (
    pi_bpmn_id         in flow_types_pkg.t_bpmn_id
  , pi_execution_point in varchar2
  , pi_proc_vars_xml   in xmltype
  )
  as
  begin
    for rec in (
                select variable_sequence
                     , variable_name
                     , variable_type
                     , expression_type
                     , expression_value
                  from xmltable
                       (
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
                       , '*' passing pi_proc_vars_xml
                         columns
                           variable_sequence number              path 'apex:varSequence'
                         , variable_name     varchar2(50 char)   path 'apex:varName'
                         , variable_type     varchar2(50 char)   path 'apex:varDataType'
                         , expression_type   varchar2(200 char)  path 'apex:varExpressionType'
                         , expression_value  varchar2(4000 char) path 'apex:varExpression'
                       )
               )
    loop
      register_object_expression
      (
        pi_objt_bpmn_id    => pi_bpmn_id
      , pi_expr_set        => pi_execution_point
      , pi_expr_order      => rec.variable_sequence
      , pi_expr_var_name   => rec.variable_name
      , pi_expr_var_type   => rec.variable_type
      , pi_expr_type       => rec.expression_type
      , pi_expr_expression => rec.expression_value
      );
    end loop;
  end parse_process_variables;

  procedure parse_page_items
  (
    pi_bpmn_id         in flow_types_pkg.t_bpmn_id
  , pi_page_items_xml  in xmltype
  )
  as
    l_page_item   sys.json_object_t;
    l_page_items  sys.json_array_t := sys.json_array_t();
    l_apex_object sys.json_object_t;
  begin
    for rec in (
                select items.item_name
                     , items.item_value
                  from xmltable
                       (
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
                       , '*' passing pi_page_items_xml
                         columns
                           item_name  varchar2(50 char) path 'apex:itemName'
                         , item_value varchar2(50 char) path 'apex:itemValue'
                       ) items
               )
    loop
      l_page_item := sys.json_object_t();
      l_page_item.put( 'name', rec.item_name );
      l_page_item.put( 'value', rec.item_value );
      l_page_items.append( l_page_item );
    end loop;
    flow_parser_util.guarantee_apex_object( pio_objt_attributes => g_objects(pi_bpmn_id).objt_attributes);

    -- Complex JSON types are handled by reference
    l_apex_object := g_objects(pi_bpmn_id).objt_attributes.get_object( 'apex' );
    l_apex_object.put( 'pageItems', l_page_items );
  end parse_page_items;

  procedure parse_task_subtypes
  (
    pi_bpmn_id     in flow_types_pkg.t_bpmn_id
  , pi_subtype_xml in xmltype
  )
  as
    l_namespace        flow_types_pkg.t_vc200;
    l_attribute        flow_types_pkg.t_vc200;
    l_json_element     sys.json_element_t;
    l_namespace_object sys.json_object_t;
  begin

    for rec in (
                select props.prop_name
                     , props.prop_value
                     , props.prop_children
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_subtype_xml
                         columns
                           prop_name     varchar2(50 char) path 'name()'
                         , prop_value    clob              path 'text()'
                         , prop_children xmltype           path '* except bpmn:incoming except bpmn:outgoing'
                       ) props
               )
    loop
      -- User Task: nested page items are handled separately
      if rec.prop_name = flow_constants_pkg.gc_apex_usertask_page_items then
        parse_page_items
        (
          pi_bpmn_id        => pi_bpmn_id
        , pi_page_items_xml => rec.prop_children
        );
      elsif length(rec.prop_value) > 0 then
        flow_parser_util.property_to_json
        (
          pi_property_name => rec.prop_name
        , pi_value         => rec.prop_value
        , po_namespace     => l_namespace
        , po_key           => l_attribute
        , po_json_element  => l_json_element
        );

        flow_parser_util.guarantee_named_object( pio_objt_attributes => g_objects(pi_bpmn_id).objt_attributes, pi_key => l_namespace );
        l_namespace_object := g_objects(pi_bpmn_id).objt_attributes.get_object( l_namespace );
        if l_json_element is not null then
          l_namespace_object.put( l_attribute, l_json_element );
        else
          l_namespace_object.put( l_attribute, rec.prop_value );
        end if;
      --Empty properties will not be stored
      else
        null;
      end if;
    end loop;
  end parse_task_subtypes;

  procedure parse_custom_timers
  (
    pi_bpmn_id     in flow_types_pkg.t_bpmn_id
  , pi_subtype_xml in xmltype
  )
  as
    l_namespace        flow_types_pkg.t_vc200;
    l_attribute        flow_types_pkg.t_vc200;
    l_namespace_object sys.json_object_t;
    l_json_element     sys.json_element_t;
  begin

    for rec in (
                select props.prop_name
                     , props.prop_value
                     , props.prop_children
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_subtype_xml
                         columns
                           prop_name     varchar2(50 char)    path 'name()'
                         , prop_value    varchar2(4000 char)  path 'text()'
                         , prop_children xmltype              path '* except bpmn:incoming except bpmn:outgoing'
                       ) props
               )
    loop
      if length(rec.prop_value) > 0 then
        flow_parser_util.property_to_json
        (
          pi_property_name => rec.prop_name
        , pi_value         => rec.prop_value
        , po_namespace     => l_namespace
        , po_key           => l_attribute
        , po_json_element  => l_json_element
        );

        flow_parser_util.guarantee_named_object( pio_objt_attributes => g_objects(pi_bpmn_id).objt_attributes, pi_key => l_namespace );
        l_namespace_object := g_objects(pi_bpmn_id).objt_attributes.get_object( l_namespace );
        if l_json_element is not null then
          l_namespace_object.put( l_attribute, l_json_element );
        else
          l_namespace_object.put( l_attribute, rec.prop_value );
        end if;
      end if;
    end loop;
  end parse_custom_timers;

  procedure parse_extension_elements
  (
    pi_bpmn_id       in flow_types_pkg.t_bpmn_id
  , pi_extension_xml in xmltype
  )
  as
  begin
    for rec in (
                select extension_type
                     , extension_data
                  from xmltable
                       (
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
                       , '/bpmn:extensionElements/*' passing pi_extension_xml
                         columns
                           extension_type varchar2(50 char) path 'name()'
                         , extension_data xmltype           path '*'
                       ) 
               )
    loop
      -- Process Variables
      if replace(rec.extension_type, 'apex:') in ( flow_constants_pkg.gc_expr_set_before_task, flow_constants_pkg.gc_expr_set_after_task
                                                 , flow_constants_pkg.gc_expr_set_before_split, flow_constants_pkg.gc_expr_set_after_merge
                                                 , flow_constants_pkg.gc_expr_set_before_event, flow_constants_pkg.gc_expr_set_on_event
                                                 , flow_constants_pkg.gc_expr_set_in_variables, flow_constants_pkg.gc_expr_set_out_variables
                                                 )
      then
        parse_process_variables
        (
          pi_bpmn_id         => pi_bpmn_id
        , pi_execution_point => replace(rec.extension_type, 'apex:')
        , pi_proc_vars_xml   => rec.extension_data
        );
      -- Task Subtypes
      elsif rec.extension_type in ( flow_constants_pkg.gc_apex_usertask_apex_page
                                  , flow_constants_pkg.gc_apex_usertask_external_url
                                  , flow_constants_pkg.gc_apex_servicetask_send_mail
                                  , flow_constants_pkg.gc_apex_task_execute_plsql
                                  )
      then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_bpmn_id
        , pi_attribute_name => flow_constants_pkg.gc_task_type_key
        , pi_value          => rec.extension_type
        );
  
        -- parse properties
        parse_task_subtypes
        (
          pi_bpmn_id     => pi_bpmn_id
        , pi_subtype_xml => rec.extension_data
        );
      -- Custom Timers
      elsif rec.extension_type in ( flow_constants_pkg.gc_timer_type_oracle_date
                                  , flow_constants_pkg.gc_timer_type_oracle_duration
                                  , flow_constants_pkg.gc_timer_type_oracle_cycle
                                  )
      then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_bpmn_id
        , pi_attribute_name => flow_constants_pkg.gc_timer_type_key
        , pi_value          => rec.extension_type
        );
        g_objects(pi_bpmn_id).objt_sub_tag_name := flow_constants_pkg.gc_bpmn_timer_event_definition;

        -- parse properties
        parse_custom_timers
        (
          pi_bpmn_id     => pi_bpmn_id
        , pi_subtype_xml => rec.extension_data
        );
      end if;
    end loop;
  end parse_extension_elements;

  procedure parse_child_elements
  (
    pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_xml          in xmltype
  )
  as
    l_child_type         flow_types_pkg.t_bpmn_id;
    l_child_id           flow_types_pkg.t_bpmn_id;
    l_child_value        flow_types_pkg.t_bpmn_attribute_vc2;
    l_child_details      xmltype;
    l_detail_type        flow_types_pkg.t_bpmn_id;
    l_detail_id          flow_types_pkg.t_bpmn_id;
    l_detail_value       flow_types_pkg.t_bpmn_attribute_vc2;
  begin

    for rec in (
                select children.child_type
                     , children.child_id
                     , children.child_value
                     , children.child_details
                     , children.extension_elements
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_xml
                         columns
                           child_type         varchar2(50 char)    path 'name()'
                         , child_id           varchar2(50 char)    path '@id'
                         , child_value        varchar2(4000 char)  path 'text()'
                         , child_details      xmltype              path '* except bpmn:incoming except bpmn:outgoing'
                         , extension_elements xmltype              path 'bpmn:extensionElements'
                       ) children
               )
    loop

      if rec.child_details is null then
        -- register the child which does not have details
        if rec.child_value is not null then
          -- if needed distinguish here between different attributes

          register_object_attribute
          (
            pi_objt_bpmn_id    => pi_objt_bpmn_id
          , pi_attribute_name  => rec.child_type
          , pi_value           => rec.child_value
          );
        end if;
      else
        -- register the child which has details
        if rec.child_type = flow_constants_pkg.gc_bpmn_timer_event_definition then
          -- if custom (Flows) type then all processing is done by using the extension element
          if rec.extension_elements is not null then
            parse_extension_elements
            ( 
              pi_bpmn_id       => pi_objt_bpmn_id
            , pi_extension_xml => rec.extension_elements
            );
          -- if standard type just register value inside tag
          else
            select details.detail_type
            , details.detail_id
            , details.detail_value
                into l_detail_type
                  , l_detail_id
                  , l_detail_value
                from xmltable
                    (
                      xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                    , '*' passing rec.child_details
                      columns
                        detail_type        varchar2(50 char)    path 'name()'
                      , detail_id          varchar2(50 char)    path '@id'
                      , detail_value       varchar2(4000 char)  path 'text()'
                    ) details;

            -- register the timer type
            register_object_attribute
            (
              pi_objt_bpmn_id   => pi_objt_bpmn_id
            , pi_attribute_name => flow_constants_pkg.gc_timer_type_key
            , pi_value          => l_detail_type
            );

            register_object_attribute
            (
              pi_objt_bpmn_id   => pi_objt_bpmn_id
            , pi_attribute_name => flow_constants_pkg.gc_timer_def_key
            , pi_value          => l_detail_value
            );
          end if;
        -- custom processStatus attribute on terminateEndEvents
        elsif rec.child_type = flow_constants_pkg.gc_bpmn_terminate_event_definition then
          select details.detail_type
               , details.detail_value
            into l_detail_type
               , l_detail_value
            from xmltable
                 (
                   xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                 , '*' passing rec.child_details
                   columns
                     detail_type  varchar2(50 char) path   'name()'
                   , detail_value varchar2(4000 char) path 'text()'
                 ) details
          ;
          if l_detail_type = flow_constants_pkg.gc_apex_process_status then
            register_object_attribute
            (
              pi_objt_bpmn_id   => pi_objt_bpmn_id
            , pi_attribute_name => flow_constants_pkg.gc_terminate_result
            , pi_value          => l_detail_value
            );
          end if;
	    end if;

      end if;

    end loop;

  end parse_child_elements;

  procedure parse_call_activity
  (
    pi_xml          in xmltype
  , pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
  begin

    for rec in (
                select activity.activity_diagram
                     , activity.activity_versionSelection
                     , activity.activity_version
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_xml
                         columns
                           activity_diagram          varchar2(50 char) path '@apex:calledDiagram'
                         , activity_versionSelection varchar2(50 char) path '@apex:calledDiagramVersionSelection'
                         , activity_version          varchar2(50 char) path '@apex:calledDiagramVersion'
                       ) activity
               )
    loop

      if rec.activity_diagram is not null then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_objt_bpmn_id
        , pi_attribute_name => flow_constants_pkg.gc_apex_called_diagram
        , pi_value          => rec.activity_diagram
        );
      end if;

      if rec.activity_versionSelection is not null then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_objt_bpmn_id
        , pi_attribute_name => flow_constants_pkg.gc_apex_called_diagram_version_selection
        , pi_value          => rec.activity_versionSelection
        );
      end if;

      if rec.activity_version is not null then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_objt_bpmn_id
        , pi_attribute_name => flow_constants_pkg.gc_apex_called_diagram_version
        , pi_value          => rec.activity_version
        );
      end if;

    end loop;

  end parse_call_activity;

  procedure parse_steps
  (
    pi_xml          in xmltype
  , pi_proc_type    in flow_types_pkg.t_bpmn_id
  , pi_proc_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
    l_objt_sub_tag_name flow_objects.objt_sub_tag_name%type;
  begin
    for rec in (
                select steps.steps_type
                     , steps.steps_name
                     , steps.steps_id
                     , steps.source_ref
                     , steps.target_ref
                     , steps.default_conn
                     , steps.attached_to
                     , case steps.interrupting when 'false' then 0 else 1 end as interrupting
                     , steps.child_elements
                     , steps.extension_elements
                     , steps.step
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                       , '*' passing pi_xml
                         columns
                           steps_type         varchar2(50  char) path 'name()'
                         , steps_name         varchar2(200 char) path '@name'
                         , steps_id           varchar2(50  char) path '@id'
                         , source_ref         varchar2(50  char) path '@sourceRef'
                         , target_ref         varchar2(50  char) path '@targetRef'
                         , default_conn       varchar2(50  char) path '@default'
                         , attached_to        varchar2(50  char) path '@attachedToRef'
                         , interrupting       varchar2(50  char) path '@cancelActivity'
                         , child_elements     xmltype            path '* except bpmn:incoming except bpmn:outgoing except bpmn:extensionElements'
                         , extension_elements xmltype            path 'bpmn:extensionElements'
                         , step               xmltype            path '.'
                       ) steps
               )
    loop

      if rec.source_ref is null then -- assume objects don't have a sourceRef attribute

        -- Parse additional information from child elements
        -- relevant for e.g. terminateEndEvent
        -- Additionally collect generic attributes if possible
        if rec.child_elements is not null then
          l_objt_sub_tag_name := find_subtag_name( pi_xml => rec.child_elements );
          parse_child_elements
          (
            pi_objt_bpmn_id => rec.steps_id
          , pi_xml          => rec.child_elements
          );
        else
          l_objt_sub_tag_name := null;
        end if;

        if rec.extension_elements is not null then
          parse_extension_elements
          ( 
            pi_bpmn_id       => rec.steps_id
          , pi_extension_xml => rec.extension_elements
          );
        end if;

        if rec.default_conn is not null then
          g_default_cons(rec.default_conn) := 1;
        end if;

        register_object
        (
          pi_objt_bpmn_id        => rec.steps_id
        , pi_objt_name           => rec.steps_name
        , pi_objt_tag_name       => rec.steps_type
        , pi_objt_sub_tag_name   => l_objt_sub_tag_name
        , pi_objt_parent_bpmn_id => pi_proc_bpmn_id
        , pi_objt_attached_to    => rec.attached_to
        , pi_objt_interrupting   => rec.interrupting
        );

        if rec.steps_type = 'bpmn:laneSet' then
          parse_lanes
          (
            pi_laneset_xml  => rec.child_elements
          , pi_objt_bpmn_id => rec.steps_id
          );
        end if;

        if rec.steps_type = 'bpmn:callActivity' then
          parse_call_activity
          (
            pi_xml          => rec.step
          , pi_objt_bpmn_id => rec.steps_id
          );
        end if;
      else
        register_connection
        (
          pi_conn_bpmn_id     => rec.steps_id
        , pi_conn_name        => rec.steps_name
        , pi_conn_src_bpmn_id => rec.source_ref
        , pi_conn_tgt_bpmn_id => rec.target_ref
        , pi_conn_tag_name    => rec.steps_type
        , pi_conn_origin      => pi_proc_bpmn_id
        );        
      end if;
    end loop;  
  end parse_steps;

  procedure parse_xml
  (
    pi_xml       in xmltype
  , pi_parent_id in flow_types_pkg.t_bpmn_id
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
                      , proc.proc_laneset
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , '/bpmn:definitions/bpmn:process' passing pi_xml
                        columns
                          proc_id        varchar2(50  char) path '@id'
                        , proc_type      varchar2(50  char) path 'name()'
                        , proc_name      varchar2(200 char) path '@name'
                        , proc_steps     xmltype            path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype            path 'bpmn:subProcess'
                        , proc_laneset   xmltype            path 'bpmn:laneSet'
                      ) proc
                 )
      loop

        -- register each process as an object so we can reference later
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
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
                          proc_id        varchar2(50  char) path '@id'
                        , proc_name      varchar2(200 char) path '@name'
                        , proc_type      varchar2(50  char) path 'name()'
                        , proc_steps     xmltype            path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype            path 'bpmn:subProcess'
                      ) proc
                 )
      loop
        -- We add an entry for a sub process here,
        -- as it is an object within the master process
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
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
                            colab_id      varchar2(50  char)  path '@id'
                          , colab_name    varchar2(200 char) path '@name'
                          , colab_type    varchar2(50  char)  path 'name()'
                          , colab_src_ref varchar2(50  char)  path '@sourceRef'
                          , colab_tgt_ref varchar2(50  char)  path '@targetRef'
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
          , pi_conn_tag_name    => rec.colab_type
          , pi_conn_origin      => null
          );

      end case;

    end loop;

  end parse_collaboration;

  procedure reset
  as
  begin
    g_dgrm_id := null;
    g_objects.delete;
    g_objt_expr.delete;
    g_connections.delete;
    g_objt_lookup.delete;
    g_default_cons.delete;
  end reset;

  procedure parse
  as
    l_dgrm_content clob;
    l_has_changed boolean;
  begin
    -- delete any existing parsed information before parsing again
    cleanup_parsing_tables;

    -- get the CLOB content
    select dgrm_content
      into l_dgrm_content
      from flow_diagrams
     where dgrm_id = g_dgrm_id
    ;

    -- migrate old diagrams
    flow_migrate_xml_pkg.migrate_xml(
      p_dgrm_content => l_dgrm_content
    , p_has_changed => l_has_changed
    );

    -- update diagram after change
    if l_has_changed then
      update flow_diagrams
      set dgrm_content = l_dgrm_content
      where dgrm_id = g_dgrm_id;
    end if;

    -- parse out collaboration part first
    parse_collaboration( pi_xml => xmltype(l_dgrm_content) );
    -- start recursive processsing of xml
    parse_xml( pi_xml => xmltype(l_dgrm_content), pi_parent_id => null );

    -- finally insert all parsed data
    finalize;

  end parse;

  procedure parse
  (
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  )
  as
  begin
    reset;
    g_dgrm_id := pi_dgrm_id;
    parse;
  end parse;

  procedure parse
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  )
  as
  begin
    reset;
    select dgrm_id
      into g_dgrm_id
      from flow_diagrams
     where dgrm_name = pi_dgrm_name
       and dgrm_version = pi_dgrm_version
    ;
    parse;
  end parse;

  procedure upload_and_parse
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_dgrm_content  in flow_diagrams.dgrm_content%type
  , pi_dgrm_status   in flow_diagrams.dgrm_status%type default flow_constants_pkg.gc_dgrm_status_draft
  , pi_force_overwrite in boolean default false
  )
  as
  begin
    reset;

    upload_diagram( pi_dgrm_name => pi_dgrm_name, pi_dgrm_version => pi_dgrm_version,
                    pi_dgrm_category => pi_dgrm_category, pi_dgrm_content => pi_dgrm_content,
                    pi_dgrm_status => pi_dgrm_status, pi_force_overwrite => pi_force_overwrite
                  );
    parse;

  end upload_and_parse;

  procedure update_diagram
  (
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_content in flow_diagrams.dgrm_content%type
  )
  as
  begin
    reset;
    g_dgrm_id := pi_dgrm_id;

    update flow_diagrams
       set dgrm_content = pi_dgrm_content
         , dgrm_last_update = systimestamp
     where dgrm_id = g_dgrm_id
    ;

    parse;
  end update_diagram;

end flow_bpmn_parser_pkg;
/

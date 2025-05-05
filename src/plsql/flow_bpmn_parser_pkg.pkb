create or replace package body flow_bpmn_parser_pkg
as
/* 
-- Flows for APEX - flow_bpmn_parser_pkg.pkb
-- 
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    2020         Moritz Klein (MT AG)
-- Modified   2022-08-10   Moritz Klein (MT AG)
-- Modified   2023-03-10   Moritz Klein (MT GmbH)
-- Modified   2023-04-12   Moritz Klein (MT GmbH)
-- Modified   2023-05-16   Moritz Klein (MT GmbH)
-- Modified   2024-07-19   Moritz Klein (Hyand Solutions GmbH)
--
*/

  -- Configuration Settings
  g_log_enabled    boolean := false;

  -- Variables to hold data during parse run
  g_dgrm_id        flow_diagrams.dgrm_id%type;
  g_objects        flow_parser_util.t_objt_tab;
  g_objt_expr      flow_parser_util.t_objt_expr_tab;
  g_connections    flow_parser_util.t_conn_tab;
  g_lane_refs      flow_parser_util.t_bpmn_ref_tab;
  g_collab_refs    flow_parser_util.t_bpmn_ref_tab;
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
  , pi_value          in clob
  )
  as
    l_namespace        flow_types_pkg.t_vc200;
    l_attribute        flow_types_pkg.t_vc200;
    l_namespace_object sys.json_object_t;
    l_json_element     sys.json_element_t;
  begin

    if not g_objects.exists( pi_objt_bpmn_id ) then
      register_object( pi_objt_bpmn_id => pi_objt_bpmn_id );
    end if;

    if g_objects(pi_objt_bpmn_id).objt_attributes is null then
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
        pio_attributes => g_objects(pi_objt_bpmn_id).objt_attributes
      , pi_key         => l_namespace
      );
      l_namespace_object := g_objects(pi_objt_bpmn_id).objt_attributes.get_object( l_namespace );
    else
      l_namespace_object := g_objects(pi_objt_bpmn_id).objt_attributes;
    end if;

    if l_json_element is not null then
      l_namespace_object.put( l_attribute, l_json_element );
    elsif pi_value in ( flow_constants_pkg.gc_vcbool_true, flow_constants_pkg.gc_vcbool_false ) then
      l_namespace_object.put( l_attribute, (pi_value = flow_constants_pkg.gc_vcbool_true) );
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
  , pi_conn_sequence    in flow_connections.conn_sequence%type
  , pi_conn_attributes  in sys.json_object_t default null
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
      l_conn_rec.conn_sequence    := pi_conn_sequence;
      l_conn_rec.conn_attributes  := pi_conn_attributes;

      g_connections( pi_conn_bpmn_id ) := l_conn_rec;
    end if;
  end register_connection;

  procedure register_connection_attribute
  (
    pi_conn_bpmn_id   in flow_types_pkg.t_bpmn_id
  , pi_attribute_name in flow_types_pkg.t_bpmn_attributes_key
  , pi_value          in clob
  )
  as
    l_namespace        flow_types_pkg.t_vc200;
    l_attribute        flow_types_pkg.t_vc200;
    l_namespace_object sys.json_object_t;
    l_json_element     sys.json_object_t;
  begin

    if g_connections(pi_conn_bpmn_id).conn_attributes is null then
      g_connections(pi_conn_bpmn_id).conn_attributes := sys.json_object_t();
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
        pio_attributes => g_connections(pi_conn_bpmn_id).conn_attributes
      , pi_key         => l_namespace
      );
      l_namespace_object := g_connections(pi_conn_bpmn_id).conn_attributes.get_object( l_namespace );
    else
      l_namespace_object := g_connections(pi_conn_bpmn_id).conn_attributes;
    end if;

    if l_json_element is not null then
      l_namespace_object.put( l_attribute, l_json_element );
    elsif pi_value in ( flow_constants_pkg.gc_vcbool_true, flow_constants_pkg.gc_vcbool_false ) then
      l_namespace_object.put( l_attribute, (pi_value = flow_constants_pkg.gc_vcbool_true) );
    else
      l_namespace_object.put( l_attribute, pi_value );
    end if;

  end register_connection_attribute;

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
  , pi_conn_origin       in flow_connections.conn_origin%type
  , pi_conn_sequence     in flow_connections.conn_sequence%type
  , pi_conn_attributes   in flow_connections.conn_attributes%type
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
            , conn_sequence
            , conn_attributes
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
            , pi_conn_sequence
            , pi_conn_attributes
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
        , pi_objt_attributes   => case when l_cur_object.objt_attributes is not null then l_cur_object.objt_attributes.to_clob else null end
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
        , pi_conn_sequence     => l_cur_conn.conn_sequence
        , pi_conn_attributes   => case when l_cur_conn.conn_attributes is not null then l_cur_conn.conn_attributes.to_clob else null end
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

  procedure parse_page_items
  (
    pi_bpmn_id         in flow_types_pkg.t_bpmn_id
  , pi_page_items_xml  in sys.xmltype
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
                           item_name  varchar2(  50 char) path 'apex:itemName'
                         , item_value varchar2(4000 char) path 'apex:itemValue'
                       ) items
               )
    loop
      l_page_item := sys.json_object_t();
      l_page_item.put( 'name', rec.item_name );
      l_page_item.put( 'value', rec.item_value );
      l_page_items.append( l_page_item );
    end loop;
    flow_parser_util.guarantee_apex_object( pio_attributes => g_objects(pi_bpmn_id).objt_attributes);

    -- Complex JSON types are handled by reference
    l_apex_object := g_objects(pi_bpmn_id).objt_attributes.get_object( 'apex' );
    l_apex_object.put( 'pageItems', l_page_items );
  end parse_page_items;
  
  procedure parse_parameters
  (
    pi_bpmn_id        in flow_types_pkg.t_bpmn_id
  , pi_parameters_xml in sys.xmltype
  )
  as
    l_param_array clob;
    l_apex_object sys.json_object_t;
  begin

    select json_arrayagg( json_object
                          (
                            key 'parStaticId' is parameter_static_id
                          , key 'parDataType' is parameter_data_type
                          , key 'parValue'    is parameter_value
                          )
                        ) as par_obj
      into l_param_array
      from xmltable
           (
             xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
           , '*' passing pi_parameters_xml
             columns
               parameter_static_id varchar2(  50 char) path 'apex:parStaticId'
             , parameter_data_type varchar2(  50 char) path 'apex:parDataType'
             , parameter_value     varchar2(4000 char) path 'apex:parValue'
           )
    ;

    if l_param_array is not null then
      flow_parser_util.guarantee_apex_object( pio_attributes => g_objects(pi_bpmn_id).objt_attributes );
      l_apex_object := g_objects(pi_bpmn_id).objt_attributes.get_object( 'apex' );
      l_apex_object.put( 'parameters', sys.json_array_t.parse( l_param_array ) );
    end if;
  end parse_parameters;

  procedure parse_task_subtypes
  (
    pi_bpmn_id     in flow_types_pkg.t_bpmn_id
  , pi_subtype_xml in sys.xmltype
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
                         , prop_children sys.xmltype       path '* except bpmn:incoming except bpmn:outgoing'
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
      -- Array of Parameter Bindings, used by Unified Tasklist Integration
      elsif rec.prop_name = flow_constants_pkg.gc_apex_usertask_parameters then
        parse_parameters
        (
          pi_bpmn_id        => pi_bpmn_id
        , pi_parameters_xml => rec.prop_children
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

        flow_parser_util.guarantee_named_object( pio_attributes => g_objects(pi_bpmn_id).objt_attributes, pi_key => l_namespace );
        l_namespace_object := g_objects(pi_bpmn_id).objt_attributes.get_object( l_namespace );
        if l_json_element is not null then
          l_namespace_object.put( l_attribute, l_json_element );
        else
          -- Need to create real booleans in JSON
          if rec.prop_value in ( flow_constants_pkg.gc_vcbool_true, flow_constants_pkg.gc_vcbool_false ) then
            l_namespace_object.put( l_attribute, ( rec.prop_value = flow_constants_pkg.gc_vcbool_true ) );
          else
            l_namespace_object.put( l_attribute, rec.prop_value );
          end if;
        end if;
      --Empty properties will not be stored
      else
        null;
      end if;
    end loop;
  end parse_task_subtypes;

  procedure parse_process_variables
  (
    pi_bpmn_id         in flow_types_pkg.t_bpmn_id
  , pi_execution_point in varchar2
  , pi_proc_vars_xml   in sys.xmltype
  )
  as
  begin
    for rec in (
                select variable_sequence
                     , variable_name
                     , case variable_type
                         when 'TIMESTAMP_WITH_TIME_ZONE' then 'TIMESTAMP WITH TIME ZONE'
                         else variable_type
                       end as variable_type
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

  procedure parse_custom_timers
  (
    pi_bpmn_id     in flow_types_pkg.t_bpmn_id
  , pi_subtype_xml in sys.xmltype
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
                         , prop_children sys.xmltype          path '* except bpmn:incoming except bpmn:outgoing'
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

        flow_parser_util.guarantee_named_object( pio_attributes => g_objects(pi_bpmn_id).objt_attributes, pi_key => l_namespace );
        l_namespace_object := g_objects(pi_bpmn_id).objt_attributes.get_object( l_namespace );
        if l_json_element is not null then
          l_namespace_object.put( l_attribute, l_json_element );
        else
          l_namespace_object.put( l_attribute, rec.prop_value );
        end if;
      end if;
    end loop;
  end parse_custom_timers;

  procedure parse_simple_expression
  (
    pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_ext_type     in varchar2
  , pi_exp_type     in varchar2
  , pi_exp_fmt_mask in varchar2
  , pi_exp_val      in clob
  )
  as
    l_apex_object sys.json_object_t;
    l_ext_object  sys.json_object_t := sys.json_object_t();
  begin
    if not g_objects.exists( pi_objt_bpmn_id ) then
      register_object( pi_objt_bpmn_id => pi_objt_bpmn_id );
      g_objects(pi_objt_bpmn_id).objt_attributes := sys.json_object_t();
    end if;
    flow_parser_util.guarantee_apex_object( pio_attributes => g_objects(pi_objt_bpmn_id).objt_attributes );
    l_apex_object := g_objects(pi_objt_bpmn_id).objt_attributes.get_object( 'apex' );

    l_ext_object.put( 'expressionType', pi_exp_type );
    if pi_exp_type in ( flow_constants_pkg.gc_expr_type_sql, flow_constants_pkg.gc_expr_type_sql_delimited_list
                      , flow_constants_pkg.gc_expr_type_plsql_expression, flow_constants_pkg.gc_expr_type_plsql_function_body
                      , flow_constants_pkg.gc_expr_type_plsql_raw_expression, flow_constants_pkg.gc_expr_type_plsql_raw_function_body
                      )
    then
      l_ext_object.put( 'expression', flow_parser_util.get_lines_array( pi_str => pi_exp_val ) );
    else
      l_ext_object.put( 'expression', pi_exp_val );
    end if;

    if pi_exp_fmt_mask is not null then
      l_ext_object.put( 'formatMask', pi_exp_fmt_mask );
    end if;

    l_apex_object.put( replace(pi_ext_type, 'apex:'), l_ext_object );
  end parse_simple_expression;

  procedure parse_extension_elements
  (
    pi_bpmn_id       in flow_types_pkg.t_bpmn_id
  , pi_extension_xml in sys.xmltype
  )
  as
  begin

    if g_log_enabled then
      flow_parser_util.log
      (
        pi_plog_dgrm_id    => g_dgrm_id
      , pi_plog_bpmn_id    => pi_bpmn_id
      , pi_plog_parse_step => 'parse_extension_elements'
      , pi_plog_payload    => pi_extension_xml
      );
    end if;
    
    for rec in (
                select replace(extension_type, 'apex:') as extension_type
                     , extension_type as orig_extension_type
                     , extension_data
                     , extension_exp_type
                     , extension_exp_val
                     , extension_fmt_mask
                     , extension_text
                  from xmltable
                       (
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
                       , '/bpmn:extensionElements/*' passing pi_extension_xml
                         columns
                           extension_type     varchar2( 50 char) path 'name()'
                         , extension_data     sys.xmltype        path '*'
                         , extension_exp_type varchar2( 50 char) path 'apex:expressionType'
                         , extension_exp_val  clob               path 'apex:expression'
                         , extension_fmt_mask varchar2(200 char) path 'apex:formatMask'
                         , extension_text     clob               path 'text()'
                       ) 
               )
    loop
      -- Process Variables
      if rec.extension_type in ( flow_constants_pkg.gc_expr_set_before_task, flow_constants_pkg.gc_expr_set_after_task
                               , flow_constants_pkg.gc_expr_set_before_split, flow_constants_pkg.gc_expr_set_after_merge
                               , flow_constants_pkg.gc_expr_set_before_event, flow_constants_pkg.gc_expr_set_on_event
                               , flow_constants_pkg.gc_expr_set_in_variables, flow_constants_pkg.gc_expr_set_out_variables
                               )
      then
        parse_process_variables
        (
          pi_bpmn_id         => pi_bpmn_id
        , pi_execution_point => rec.extension_type
        , pi_proc_vars_xml   => rec.extension_data
        );
      -- Task Subtypes
      elsif rec.extension_type in ( flow_constants_pkg.gc_apex_usertask_apex_page
                                  , flow_constants_pkg.gc_apex_usertask_apex_approval
                                  , flow_constants_pkg.gc_apex_usertask_apex_simple_form
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
      -- Standard Expressions with expressionType and expression nested
      elsif rec.extension_exp_type is not null then
        if g_log_enabled then
          flow_parser_util.log
          (
            pi_plog_dgrm_id    => g_dgrm_id
          , pi_plog_bpmn_id    => pi_bpmn_id
          , pi_plog_parse_step => 'when standard expression'
          , pi_plog_payload    => 'extension_type: ' || rec.extension_type
          );
        end if;

        parse_simple_expression
        (
          pi_objt_bpmn_id => pi_bpmn_id
        , pi_ext_type     => rec.extension_type
        , pi_exp_type     => rec.extension_exp_type
        , pi_exp_fmt_mask => rec.extension_fmt_mask
        , pi_exp_val      => rec.extension_exp_val
        );
      else
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_bpmn_id
        , pi_attribute_name => rec.orig_extension_type
        , pi_value          => rec.extension_text
        );
      end if;
    end loop;
  end parse_extension_elements;

  procedure parse_iterator_attributes
  (
    pi_objt_bpmn_id       in flow_types_pkg.t_bpmn_id
  , pi_iterator_type      in varchar2
  , pi_is_sequential      in varchar2
  , pi_extension_elements in sys.xmltype
  )
  as
    l_apex_object      sys.json_object_t;
    l_iterator_object  sys.json_object_t := sys.json_object_t();
    l_ext_object       sys.json_object_t;
  begin
    if g_log_enabled then
      flow_parser_util.log
      (
        pi_plog_dgrm_id    => g_dgrm_id
      , pi_plog_bpmn_id    => pi_objt_bpmn_id
      , pi_plog_parse_step => 'parse_iterator_attributes'
      , pi_plog_payload    => pi_extension_elements
      );
    end if;

    if not g_objects.exists( pi_objt_bpmn_id ) then
      register_object( pi_objt_bpmn_id => pi_objt_bpmn_id );
      g_objects(pi_objt_bpmn_id).objt_attributes := sys.json_object_t();
    end if;
    flow_parser_util.guarantee_apex_object( pio_attributes => g_objects(pi_objt_bpmn_id).objt_attributes );
    l_apex_object := g_objects(pi_objt_bpmn_id).objt_attributes.get_object( 'apex' );

    l_iterator_object.put( key => 'isSequential', val => case when pi_is_sequential = flow_constants_pkg.gc_vcbool_true then true else false end );

    for rec in (
                select replace(extension_type, 'apex:') as extension_type
                     , extension_type as orig_extension_type
                     , extension_data
                     , extension_exp_type
                     , extension_exp_val
                     , inside_variable
                     , extension_text
                  from xmltable
                       (
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn", 'https://flowsforapex.org' as "apex" )
                       , '/bpmn:extensionElements/*' passing pi_extension_elements
                         columns
                           extension_type     varchar2(  50 char) path 'name()'
                         , extension_data     sys.xmltype         path '*'
                         , extension_exp_type varchar2(  50 char) path 'apex:expressionType'
                         , extension_exp_val  clob                path 'apex:expression'
                         , inside_variable    varchar2(4000 char) path 'apex:insideVariable'
                         , extension_text     clob                path 'text()'
                       ) 
               )
    loop

      l_ext_object := sys.json_object_t();

      if rec.extension_exp_type != flow_constants_pkg.gc_apex_iterator_description then
        l_ext_object.put( key => 'expressionType', val => rec.extension_exp_type );

        if rec.extension_exp_type in ( flow_constants_pkg.gc_expr_type_sql, flow_constants_pkg.gc_expr_type_sql_delimited_list
                                    , flow_constants_pkg.gc_expr_type_plsql_expression, flow_constants_pkg.gc_expr_type_plsql_function_body
                                    , flow_constants_pkg.gc_expr_type_plsql_raw_expression, flow_constants_pkg.gc_expr_type_plsql_raw_function_body
                                    )
        then
          l_ext_object.put( 'expression', flow_parser_util.get_lines_array( pi_str => rec.extension_exp_val ) );
        else
          l_ext_object.put( 'expression', rec.extension_exp_val );
        end if;

        if rec.inside_variable is not null then
          l_ext_object.put( key => 'insideVariable', val => rec.inside_variable );
        end if;

        l_iterator_object.put( key => rec.extension_type, val => l_ext_object );
      else
        if rec.extension_text is not null then
          l_iterator_object.put( key => 'description', val => rec.extension_text );
        end if;
      end if;
    end loop;
    
    l_apex_object.put( key => replace( pi_iterator_type, 'bpmn:' ), val => l_iterator_object );

  end parse_iterator_attributes;

  procedure parse_flow_node_refs
  (
    pi_lane_refs_xml  in sys.xmltype
  , pi_parent_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
  begin
    for node_rec in (
        select nodes.node_ref
          from xmltable
             (
               xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
             , '*' passing pi_lane_refs_xml
               columns
                 node_ref   varchar2(50 char) path 'text()'
             ) nodes
    ) loop
      g_lane_refs( node_rec.node_ref ) := pi_parent_bpmn_id;
    end loop;
  end parse_flow_node_refs;

  procedure parse_laneset
  (
    pi_laneset_xml    in sys.xmltype
  , pi_parent_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
    l_laneset_id  flow_types_pkg.t_bpmn_id;
    l_laneset_tag flow_types_pkg.t_bpmn_id;
    l_lanes_xml   sys.xmltype;
  begin

    select laneset_id
         , laneset_tag
         , lanes_xml
      into l_laneset_id
         , l_laneset_tag
         , l_lanes_xml
      from xmltable
           (
             xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                           , 'https://flowsforapex.org' as "apex")
           , '*' passing pi_laneset_xml
             columns
               laneset_id    varchar2(50 char) path '@id'
             , laneset_tag   varchar2(50 char) path 'name()'
             , lanes_xml     sys.xmltype       path '*'
           )
    ;

    register_object
    (
      pi_objt_bpmn_id        => l_laneset_id
    , pi_objt_tag_name       => l_laneset_tag
    , pi_objt_parent_bpmn_id => pi_parent_bpmn_id
    );

    for lane_rec in (
      select lane_id
           , lane_name
           , lane_type
           , lane_is_role
           , lane_role
           , node_refs
           , child_laneset
           , lane_extensions
        from xmltable
             (
               xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                             , 'https://flowsforapex.org' as "apex"
                             )
             , '*' passing l_lanes_xml
               columns
                 lane_id         varchar2( 50 char) path '@id'
               , lane_name       varchar2(200 char) path '@name'
               , lane_type       varchar2( 50 char) path 'name()'
               , lane_is_role    varchar2( 50 char) path '@apex:isRole'
               , lane_role       varchar2(200 char) path '@apex:role'
               , node_refs       sys.xmltype        path '* except bpmn:childLaneSet except bpmn:extensionElements'
               , child_laneset   sys.xmltype        path 'bpmn:childLaneSet'
               , lane_extensions sys.xmltype        path 'bpmn:extensionElements'
             )
    ) loop

      register_object
      (
        pi_objt_bpmn_id        => lane_rec.lane_id
      , pi_objt_name           => lane_rec.lane_name
      , pi_objt_tag_name       => lane_rec.lane_type
      , pi_objt_parent_bpmn_id => l_laneset_id
      );

      if lane_rec.lane_is_role is not null then
        register_object_attribute
        (
          pi_objt_bpmn_id   => lane_rec.lane_id
        , pi_attribute_name => 'apex:isRole'
        , pi_value          => lane_rec.lane_is_role
        );
      end if;

      if lane_rec.lane_is_role is not null then
        register_object_attribute
        (
          pi_objt_bpmn_id   => lane_rec.lane_id
        , pi_attribute_name => 'apex:role'
        , pi_value          => lane_rec.lane_role
        );
      end if;

      parse_extension_elements
      (
        pi_bpmn_id       => lane_rec.lane_id
      , pi_extension_xml => lane_rec.lane_extensions
      );

      if lane_rec.child_laneset is not null then
        -- ignore flowNodeRefs on this level as they duplicate lower levels
        -- jump into childLaneSet parsing (recursion)
        parse_laneset
        (
          pi_laneset_xml    => lane_rec.child_laneset
        , pi_parent_bpmn_id => lane_rec.lane_id
        );
      else
        parse_flow_node_refs
        (
          pi_lane_refs_xml  => lane_rec.node_refs
        , pi_parent_bpmn_id => lane_rec.lane_id
        );
      end if;

    end loop;

  end parse_laneset;

  function find_subtag_name
  (
    pi_xml in sys.xmltype
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

  procedure parse_process_extensions
  (
    pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_xml          in sys.xmltype
  )
  as
    l_apex_object  sys.json_object_t;
    l_var_array    flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    flow_parser_util.guarantee_apex_object( pio_attributes => g_objects(pi_objt_bpmn_id).objt_attributes );
    l_apex_object := g_objects(pi_objt_bpmn_id).objt_attributes.get_object( 'apex' );

    -- Extensions which use expressionType + expression structure
    for rec in (
      select ext_type
           , exp_type
           , exp_value
           , exp_fmt_mask
           , ext_text
        from xmltable
             (
               xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                             , 'https://flowsforapex.org' as "apex")
             , '/bpmn:extensionElements/*' passing pi_xml
               columns
                 ext_type     varchar2( 50 char) path 'name()'
               , exp_type     varchar2( 50 char) path 'apex:expressionType'
               , exp_value    clob               path 'apex:expression'
               , exp_fmt_mask varchar2(200 char) path 'apex:formatMask'
               , ext_text     clob               path 'text()'
             ) ext
    ) loop
      if rec.exp_type is not null then
        parse_simple_expression
        (
          pi_objt_bpmn_id => pi_objt_bpmn_id
        , pi_ext_type     => rec.ext_type
        , pi_exp_type     => rec.exp_type
        , pi_exp_fmt_mask => rec.exp_fmt_mask
        , pi_exp_val      => rec.exp_value
        );
      elsif rec.ext_type = flow_constants_pkg.gc_apex_custom_extension then
        register_object_attribute
        (
          pi_objt_bpmn_id   => pi_objt_bpmn_id
        , pi_attribute_name => rec.ext_type
        , pi_value          => rec.ext_text
        );
      end if;
    end loop;

    -- Parse in vs. out variables separately
    -- Makes it easier to understand in the code
    -- while not hitting performance too much

    select json_arrayagg
           (
             json_object
             (
               key 'varName'        is var_name
             , key 'varDataType'    is var_datatype
             , key 'varDescription' is var_description
             )
           ) in_var_array
      into l_var_array
      from xmltable
           (
             xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                           , 'https://flowsforapex.org' as "apex")
           , '/bpmn:extensionElements/apex:inVariables/apex:processVariable[*]' passing pi_xml
             columns
               var_name        varchar2(50 char) path 'apex:varName'
             , var_datatype    varchar2(50 char) path 'apex:varDataType'
             , var_description varchar2(50 char) path 'apex:varDescription'
           )
    ;

    -- If no inVariables are found the variable is null
    if l_var_array is not null then
      l_apex_object.put( 'inVariables', sys.json_array_t.parse( l_var_array ) );
    end if;

    select json_arrayagg
           (
             json_object
             (
               key 'varName'        is var_name
             , key 'varDataType'    is var_datatype
             , key 'varDescription' is var_description
             )
           ) in_var_array
      into l_var_array
      from xmltable
           (
             xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                           , 'https://flowsforapex.org' as "apex")
           , '/bpmn:extensionElements/apex:outVariables/apex:processVariable[*]' passing pi_xml
             columns
               var_name        varchar2(50 char) path 'apex:varName'
             , var_datatype    varchar2(50 char) path 'apex:varDataType'
             , var_description varchar2(50 char) path 'apex:varDescription'
           )
    ;

    if l_var_array is not null then
      l_apex_object.put( 'outVariables', sys.json_array_t.parse( l_var_array ) );
    end if;

  end parse_process_extensions;

  procedure parse_child_elements
  (
    pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_xml          in sys.xmltype
  )
  as
    l_child_type         flow_types_pkg.t_bpmn_id;
    l_child_id           flow_types_pkg.t_bpmn_id;
    l_child_value        flow_types_pkg.t_bpmn_attribute_vc2;
    l_child_details      sys.xmltype;
    l_detail_type        flow_types_pkg.t_bpmn_id;
    l_detail_id          flow_types_pkg.t_bpmn_id;
    l_detail_value       flow_types_pkg.t_bpmn_attribute_vc2;
  begin

    if g_log_enabled then
      flow_parser_util.log
      (
        pi_plog_dgrm_id    => g_dgrm_id
      , pi_plog_bpmn_id    => pi_objt_bpmn_id
      , pi_plog_parse_step => 'parse_child_elements'
      , pi_plog_payload    => pi_xml
      );
    end if;


    for rec in (
                select children.child_type
                     , children.child_id
                     , children.child_value
                     , children.child_details
                     , children.extension_elements
                     , children.message_ref
                     , children.is_sequential
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_xml
                         columns
                           child_type         varchar2(  50 char)  path 'name()'
                         , child_id           varchar2(  50 char)  path '@id'
                         , child_value        varchar2(4000 char)  path 'text()'
                         , message_ref        varchar2(  50 char)  path '@messageRef'
                         , is_sequential      varchar2(  50 char)  path '@isSequential'
                         , child_details      sys.xmltype          path '* except bpmn:incoming except bpmn:outgoing except bpmn:extensionElements'
                         , extension_elements sys.xmltype          path 'bpmn:extensionElements'
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
      end if;
      -- register the child which has details
      case rec.child_type
        when flow_constants_pkg.gc_bpmn_timer_event_definition then
        -- if custom (Flows) type then all processing is done by using the extension element
          if rec.extension_elements is not null then
            parse_extension_elements
            ( 
              pi_bpmn_id       => pi_objt_bpmn_id
            , pi_extension_xml => rec.extension_elements
            );
          -- if standard type just register value inside tag
          elsif rec.child_details is not null then
            if g_log_enabled then
              flow_parser_util.log
              (
                pi_plog_dgrm_id    => g_dgrm_id
              , pi_plog_bpmn_id    => pi_objt_bpmn_id
              , pi_plog_parse_step => 'parse_child_elements - not timer'
              , pi_plog_payload    => rec.child_details
              );
            end if;

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
                   ) details
            ;

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
        when flow_constants_pkg.gc_bpmn_terminate_event_definition then
          if g_log_enabled then
            flow_parser_util.log
            (
              pi_plog_dgrm_id    => g_dgrm_id
            , pi_plog_bpmn_id    => pi_objt_bpmn_id
            , pi_plog_parse_step => 'when ' || flow_constants_pkg.gc_bpmn_terminate_event_definition
            , pi_plog_payload    => rec.child_details
            );
          end if;

          if rec.child_details is not null then
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
        when flow_constants_pkg.gc_bpmn_message_event_definition then

          if g_log_enabled then
            flow_parser_util.log
            (
              pi_plog_dgrm_id    => g_dgrm_id
            , pi_plog_bpmn_id    => pi_objt_bpmn_id
            , pi_plog_parse_step => 'when ' || flow_constants_pkg.gc_bpmn_message_event_definition
            , pi_plog_payload    => rec.extension_elements
            );
          end if;

          if rec.message_ref is not null then
            register_object_attribute
            (
              pi_objt_bpmn_id   => pi_objt_bpmn_id
            , pi_attribute_name => 'messageRef'
            , pi_value          => rec.message_ref
            );
          end if;
          if rec.extension_elements is not null then
            parse_extension_elements
            ( 
              pi_bpmn_id       => pi_objt_bpmn_id
            , pi_extension_xml => rec.extension_elements
            );
          end if;
        when flow_constants_pkg.gc_bpmn_multi_instance_loop then
          if g_log_enabled then
            flow_parser_util.log
            (
              pi_plog_dgrm_id    => g_dgrm_id
            , pi_plog_bpmn_id    => pi_objt_bpmn_id
            , pi_plog_parse_step => 'when ' || flow_constants_pkg.gc_bpmn_multi_instance_loop
            , pi_plog_payload    => 'isSequential: ' || rec.is_sequential
            );
          end if;

          parse_iterator_attributes
          (
            pi_objt_bpmn_id       => pi_objt_bpmn_id
          , pi_iterator_type      => rec.child_type
          , pi_is_sequential      => rec.is_sequential
          , pi_extension_elements => rec.extension_elements
          );
        when flow_constants_pkg.gc_bpmn_standard_loop then
          if g_log_enabled then
            flow_parser_util.log
            (
              pi_plog_dgrm_id    => g_dgrm_id
            , pi_plog_bpmn_id    => pi_objt_bpmn_id
            , pi_plog_parse_step => 'when ' || flow_constants_pkg.gc_bpmn_standard_loop
            , pi_plog_payload    => 'isSequential: ' || rec.is_sequential
            );
          end if;

          parse_iterator_attributes
          (
            pi_objt_bpmn_id       => pi_objt_bpmn_id
          , pi_iterator_type      => rec.child_type
          , pi_is_sequential      => rec.is_sequential
          , pi_extension_elements => rec.extension_elements
          );
        else
          null;
      end case;

    end loop;

  end parse_child_elements;

  procedure parse_call_activity
  (
    pi_xml          in sys.xmltype
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
                         xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
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

  function get_connection_attributes
  (
    pi_conn_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_xml          in sys.xmltype
  ) return sys.json_object_t
  as
    l_condition_base       flow_types_pkg.t_bpmn_attribute_vc2;
    l_condition_expression clob;
    l_condition_object     sys.json_object_t;
    l_expression_array     sys.json_array_t;
    l_attributes_json      sys.json_object_t := sys.json_object_t();
  begin
    select json_object( key 'language' is condition_language )
         , condition_value
      into l_condition_base
         , l_condition_expression
      from xmltable
           (
             xmlnamespaces( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                          , 'https://flowsforapex.org' as "apex")
           , '/bpmn:conditionExpression' passing pi_xml
             columns
               condition_language varchar2(50 char) path '@language'
             , condition_value    clob              path 'text()'
           )
    ;
    l_condition_object := sys.json_object_t.parse( l_condition_base );
    l_expression_array := flow_parser_util.get_lines_array( pi_str => l_condition_expression );
    l_condition_object.put( 'expression', l_expression_array );

    l_attributes_json.put( 'conditionExpression', l_condition_object );
    return l_attributes_json;
  exception
    when no_data_found then
      return null;
  end get_connection_attributes;

  procedure parse_connection_extensions
  (
    pi_conn_bpmn_id     in     flow_types_pkg.t_bpmn_id
  , pi_xml              in     sys.xmltype
  , pio_conn_attributes in out sys.json_object_t
  )
  as
    l_apex_object sys.json_object_t;
    l_namespace    flow_types_pkg.t_bpmn_id;
    l_key          flow_types_pkg.t_bpmn_attributes_key;
    l_json_element sys.json_element_t;
  begin
    flow_parser_util.guarantee_apex_object( pio_attributes => pio_conn_attributes );
    l_apex_object := pio_conn_attributes.get_object( 'apex' );

    for rec in (
      select ext_type
           , ext_text
        from xmltable
             (
               xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                             , 'https://flowsforapex.org' as "apex")
             , '/bpmn:extensionElements/*' passing pi_xml
               columns
                 ext_type  varchar2( 50 char) path 'name()'
               , ext_text  clob               path 'text()'
             ) ext
       where ext_type = flow_constants_pkg.gc_apex_custom_extension
    ) loop
      flow_parser_util.property_to_json
      (
        pi_property_name => rec.ext_type
      , pi_value         => rec.ext_text
      , po_namespace     => l_namespace
      , po_key           => l_key
      , po_json_element  => l_json_element
      );
      if l_json_element is not null then
        l_apex_object.put( l_key, l_json_element );
      end if;
    end loop;
  end parse_connection_extensions;

  procedure parse_steps
  (
    pi_xml          in sys.xmltype
  , pi_proc_type    in flow_types_pkg.t_bpmn_id
  , pi_proc_bpmn_id in flow_types_pkg.t_bpmn_id
  )
  as
    l_objt_sub_tag_name flow_objects.objt_sub_tag_name%type;
    l_conn_attributes   sys.json_object_t;
  begin
    if g_log_enabled then
      flow_parser_util.log
      (
        pi_plog_dgrm_id    => g_dgrm_id
      , pi_plog_bpmn_id    => pi_proc_bpmn_id
      , pi_plog_parse_step => 'parse_steps'
      , pi_plog_payload    => pi_xml
      );
    end if;

    for rec in (
                select steps.steps_type
                     , steps.steps_name
                     , steps.steps_id
                     , steps.source_ref
                     , steps.target_ref
                     , steps.default_conn
                     , steps.attached_to
                     , case steps.steps_type
                         when flow_constants_pkg.gc_bpmn_boundary_event then
                           case steps.interrupting
                             when flow_constants_pkg.gc_vcbool_false then 0
                             else 1
                           end
                         else
                           null
                       end as interrupting
                     , steps.conn_sequence
                     , steps.task_type
                     , steps.is_sequential
                     , steps.child_elements
                     , steps.extension_elements
                     , steps.step
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                       , 'https://flowsforapex.org' as "apex")
                       , '*' passing pi_xml
                         columns
                           steps_type         varchar2( 50 char) path 'name()'
                         , steps_name         varchar2(200 char) path '@name'
                         , steps_id           varchar2( 50 char) path '@id'
                         , source_ref         varchar2( 50 char) path '@sourceRef'
                         , target_ref         varchar2( 50 char) path '@targetRef'
                         , default_conn       varchar2( 50 char) path '@default'
                         , attached_to        varchar2( 50 char) path '@attachedToRef'
                         , interrupting       varchar2( 50 char) path '@cancelActivity'
                         , conn_sequence      number             path '@apex:sequence'
                         , task_type          varchar2( 50 char) path '@apex:type'
                         , is_sequential      varchar2( 50 char) path '@isSequential'
                         , child_elements     sys.xmltype        path '* except bpmn:incoming except bpmn:outgoing except bpmn:extensionElements'
                         , extension_elements sys.xmltype        path 'bpmn:extensionElements'
                         , step               sys.xmltype        path '.'
                       ) steps
               )
    loop
      if g_log_enabled then

        if rec.steps_id is null then
          flow_parser_util.log
          (
            pi_plog_dgrm_id    => g_dgrm_id
          , pi_plog_bpmn_id    => pi_proc_bpmn_id
          , pi_plog_parse_step => 'parse_steps - loop'
          , pi_plog_payload    => 'No step_id. In process of type ' || pi_proc_type || ' with id ' || pi_proc_bpmn_id
          );
        end if;

        flow_parser_util.log
        (
          pi_plog_dgrm_id    => g_dgrm_id
        , pi_plog_bpmn_id    => rec.steps_id
        , pi_plog_parse_step => 'parse_steps - loop step data'
        , pi_plog_payload    => rec.step
        );

        flow_parser_util.log
        (
          pi_plog_dgrm_id    => g_dgrm_id
        , pi_plog_bpmn_id    => rec.steps_id
        , pi_plog_parse_step => 'parse_steps - loop childElements data'
        , pi_plog_payload    => rec.child_elements
        );

        flow_parser_util.log
        (
          pi_plog_dgrm_id    => g_dgrm_id
        , pi_plog_bpmn_id    => rec.steps_id
        , pi_plog_parse_step => 'parse_steps - loop extensionElements data'
        , pi_plog_payload    => rec.extension_elements
        );

      end if;

      -- Iterator found as step, shortcut other processing
      if rec.steps_type in ( flow_constants_pkg.gc_bpmn_multi_instance_loop, flow_constants_pkg.gc_bpmn_standard_loop ) then
        if g_log_enabled then
          flow_parser_util.log
          (
            pi_plog_dgrm_id    => g_dgrm_id
          , pi_plog_bpmn_id    => pi_proc_bpmn_id
          , pi_plog_parse_step => 'parse_steps - loop -> found iterator of type ' || rec.steps_type
          , pi_plog_payload    => rec.extension_elements
          );
        end if;

        parse_iterator_attributes
        (
          pi_objt_bpmn_id       => pi_proc_bpmn_id
        , pi_iterator_type      => rec.steps_type
        , pi_is_sequential      => rec.is_sequential
        , pi_extension_elements => rec.extension_elements
        );
      elsif rec.source_ref is null then -- assume objects don't have a sourceRef attribute

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

        if rec.task_type is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.steps_id
          , pi_attribute_name => flow_constants_pkg.gc_task_type_key
          , pi_value          => rec.task_type
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
        l_conn_attributes := null;
        if rec.child_elements is not null then
          l_conn_attributes := 
            get_connection_attributes
            (
              pi_conn_bpmn_id   => rec.steps_id
            , pi_xml            => rec.child_elements
            );
        end if;
        if rec.extension_elements is not null then
          parse_connection_extensions
          (
            pi_conn_bpmn_id     => rec.steps_id
          , pi_xml              => rec.extension_elements
          , pio_conn_attributes => l_conn_attributes
          );
        end if;
        register_connection
        (
          pi_conn_bpmn_id     => rec.steps_id
        , pi_conn_name        => rec.steps_name
        , pi_conn_src_bpmn_id => rec.source_ref
        , pi_conn_tgt_bpmn_id => rec.target_ref
        , pi_conn_tag_name    => rec.steps_type
        , pi_conn_origin      => pi_proc_bpmn_id
        , pi_conn_sequence    => rec.conn_sequence
        , pi_conn_attributes  => l_conn_attributes
        );        
      end if;
    end loop;  
  end parse_steps;

  procedure parse_xml
  (
    pi_xml       in sys.xmltype
  , pi_parent_id in flow_types_pkg.t_bpmn_id
  )
  as
  begin

    if g_log_enabled then

      flow_parser_util.log
      (
        pi_plog_dgrm_id    => g_dgrm_id
      , pi_plog_bpmn_id    => pi_parent_id
      , pi_plog_parse_step => 'parse_xml'
      , pi_plog_payload    => pi_xml
      );

    end if;

    if pi_parent_id is null then
      for rec in (
                 select proc.proc_id
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type_rem
                      , proc.proc_type
                      , proc.proc_callable
                      , proc.proc_startable
                      , proc.proc_min_logging_level
                      , proc.proc_instance_name
                      , proc.proc_application_id
                      , proc.proc_page_id
                      , proc.proc_username
                      , proc.proc_business_admin
                      , proc.proc_steps
                      , proc.proc_sub_procs
                      , proc.proc_name
                      , proc.proc_laneset
                      , proc.proc_extensions
                   from xmltable
                      (
                        xmlnamespaces ( 'http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'https://flowsforapex.org' as "apex")
                      , '/bpmn:definitions/bpmn:process' passing pi_xml
                        columns
                          proc_id                 varchar2( 50 char) path '@id'
                        , proc_type               varchar2( 50 char) path 'name()'
                        , proc_name               varchar2(200 char) path '@name'
                        , proc_callable           varchar2( 50 char) path '@apex:isCallable'
                        , proc_startable          varchar2( 50 char) path '@apex:isStartable'
                        , proc_min_logging_level  varchar2( 50 char) path '@apex:minLoggingLevel'   
                        , proc_instance_name      varchar2(200 char) path '@apex:instanceName'
                        , proc_application_id     varchar2( 50 char) path '@apex:applicationId'
                        , proc_page_id            varchar2( 50 char) path '@apex:pageId'
                        , proc_username           varchar2( 50 char) path '@apex:username'
                        , proc_business_admin     varchar2( 50 char) path '@apex:businessAdmin'
                        , proc_steps              sys.xmltype        path '* except bpmn:subProcess except bpmn:extensionElements except bpmn:laneSet'
                        , proc_sub_procs          sys.xmltype        path 'bpmn:subProcess'
                        , proc_laneset            sys.xmltype        path 'bpmn:laneSet'
                        , proc_extensions         sys.xmltype        path 'bpmn:extensionElements'
                      ) proc
                 )
      loop

        -- register each process as an object so we can reference later
        register_object
        (
          pi_objt_bpmn_id        => rec.proc_id
        , pi_objt_tag_name       => rec.proc_type
        , pi_objt_name           => rec.proc_name
        , pi_objt_parent_bpmn_id => case when g_collab_refs.exists( rec.proc_id ) then g_collab_refs( rec.proc_id ) else null end
        );

        if rec.proc_application_id is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_application_id
          , pi_value          => rec.proc_application_id
          );
        end if;

        if rec.proc_page_id is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_page_id
          , pi_value          => rec.proc_page_id
          );
        end if;

        if rec.proc_username is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_username
          , pi_value          => rec.proc_username
          );
        end if;

        if rec.proc_business_admin is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_business_admin
          , pi_value          => rec.proc_business_admin
          );
        end if;

        if rec.proc_callable is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_callable
          , pi_value          => rec.proc_callable
          );
        end if;

        if rec.proc_startable is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_startable
          , pi_value          => rec.proc_startable
          );
        end if;

        if rec.proc_min_logging_level is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_min_logging_level
          , pi_value          => rec.proc_min_logging_level
          );
        end if;

        if rec.proc_instance_name is not null then
          register_object_attribute
          (
            pi_objt_bpmn_id   => rec.proc_id
          , pi_attribute_name => flow_constants_pkg.gc_apex_process_instance_name
          , pi_value          => rec.proc_instance_name
          );
        end if;

        if rec.proc_extensions is not null then
          parse_process_extensions
          (
            pi_objt_bpmn_id => rec.proc_id
          , pi_xml          => rec.proc_extensions
          );
        end if;

        -- parse LaneSet if existing
        if rec.proc_laneset is not null then
          parse_laneset
          (  
            pi_laneset_xml    => rec.proc_laneset
          , pi_parent_bpmn_id => rec.proc_id
          );
        end if;

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
                      , proc.proc_name
                      , case proc.proc_type when 'bpmn:subProcess' then 'SUB_PROCESS' else 'PROCESS' end as proc_type_rem
                      , proc.proc_type
                      , proc.proc_steps
                      , proc.proc_sub_procs
                      , proc.proc_extensions
                   from xmltable
                      (
                        xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                      , 'bpmn:subProcess' passing pi_xml
                        columns
                          proc_id         varchar2(50  char) path '@id'
                        , proc_name       varchar2(200 char) path '@name'
                        , proc_type       varchar2(50  char) path 'name()'
                        , proc_steps      sys.xmltype        path '* except bpmn:subProcess except bpmn:extensionElements'
                        , proc_sub_procs  sys.xmltype        path 'bpmn:subProcess'
                        , proc_extensions sys.xmltype        path 'bpmn:extensionElements'
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

        if rec.proc_extensions is not null then
          parse_extension_elements
          (
            pi_bpmn_id       => rec.proc_id
          , pi_extension_xml => rec.proc_extensions
          );
        end if;

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
    pi_xml in sys.xmltype
  )
  as
    l_collab_id         flow_types_pkg.t_bpmn_id;
    l_collab_name       flow_types_pkg.t_vc200;
    l_collab_type       flow_types_pkg.t_bpmn_id;
    l_collab_extensions sys.xmltype;
    l_collab_nodes      sys.xmltype;

    l_conn_attributes   sys.json_object_t;
  begin

    select collab_id
         , collab_name
         , collab_type
         , collab_extensions
         , collab_nodes
      into l_collab_id
         , l_collab_name
         , l_collab_type
         , l_collab_extensions
         , l_collab_nodes
      from xmltable
           (
             xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
           , '/bpmn:definitions/bpmn:collaboration' passing pi_xml
             columns
               collab_id         varchar2(50  char) path '@id'
             , collab_name       varchar2(200 char) path '@name'
             , collab_type       varchar2(50  char) path 'name()'
             , collab_extensions sys.xmltype        path 'bpmn:extensionElements'
             , collab_nodes      sys.xmltype        path '*'
           ) collab
    ;

    register_object
    (
      pi_objt_bpmn_id        => l_collab_id
    , pi_objt_tag_name       => l_collab_type
    , pi_objt_name           => l_collab_name
    );

    if l_collab_extensions is not null then
      parse_extension_elements
      (
        pi_bpmn_id       => l_collab_id
      , pi_extension_xml => l_collab_extensions
      );
    end if;

    for rec in (
                 select node_id
                      , node_name
                      , node_type
                      , node_proc_ref
                      , node_src_ref
                      , node_tgt_ref
                      , node_cat_ref
                      , node_extensions
                   from xmltable
                        (
                          xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                        , '*' passing l_collab_nodes
                          columns
                            node_id         varchar2( 50 char) path '@id'
                          , node_name       varchar2(200 char) path '@name'
                          , node_type       varchar2( 50 char) path 'name()'
                          , node_proc_ref   varchar2( 50 char) path '@processRef'
                          , node_src_ref    varchar2( 50 char) path '@sourceRef'
                          , node_tgt_ref    varchar2( 50 char) path '@targetRef'
                          , node_cat_ref    varchar2( 50 char) path '@categoryValueRef'
                          , node_extensions sys.xmltype        path 'bpmn:extensionElements'
                        ) collab_nodes
    ) loop

      l_conn_attributes := null;

      case
        when rec.node_src_ref is null then
          register_object
          (
            pi_objt_bpmn_id        => rec.node_id
          , pi_objt_tag_name       => rec.node_type
          , pi_objt_name           => rec.node_name
          , pi_objt_parent_bpmn_id => l_collab_id
          );
          if rec.node_extensions is not null then
            parse_extension_elements
            (
              pi_bpmn_id       => rec.node_id
            , pi_extension_xml => rec.node_extensions
            );
          end if;
          case rec.node_type
            when flow_constants_pkg.gc_bpmn_participant then
              if rec.node_proc_ref is not null then
                g_collab_refs(rec.node_proc_ref) := rec.node_id;
              end if;
            else
              null;
          end case;
        else

          if rec.node_extensions is not null then
            parse_connection_extensions
            (
              pi_conn_bpmn_id     => rec.node_id
            , pi_xml              => rec.node_extensions
            , pio_conn_attributes => l_conn_attributes
            );
          end if;
          register_connection
          (
            pi_conn_bpmn_id     => rec.node_id
          , pi_conn_name        => rec.node_name
          , pi_conn_src_bpmn_id => rec.node_src_ref
          , pi_conn_tgt_bpmn_id => rec.node_tgt_ref
          , pi_conn_tag_name    => rec.node_type
          , pi_conn_origin      => null
          , pi_conn_sequence    => null
          , pi_conn_attributes  => l_conn_attributes
          );
      end case;
    end loop;
  exception
    when no_data_found then
      -- if no collaboration present we can skip
      null;
  end parse_collaboration;

  procedure parse_messages
  (
    pi_xml in sys.xmltype
  )
  as
  begin

    for rec in (
      select message_id
           , message_name
           , message_type
        from xmltable
             (
               xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
             , '/bpmn:definitions/bpmn:message' passing pi_xml
               columns
                 message_id   varchar2(50  char) path '@id'
               , message_name varchar2(200 char) path '@name'
               , message_type varchar2(50  char) path 'name()'
             )
    ) loop

      register_object
      (
        pi_objt_bpmn_id => rec.message_id
      , pi_objt_tag_name => rec.message_type
      , pi_objt_name => rec.message_name
      );

    end loop;

  end parse_messages;

  procedure reset
  as
  begin
    g_dgrm_id := null;
    g_objects.delete;
    g_objt_expr.delete;
    g_connections.delete;
    g_lane_refs.delete;
    g_collab_refs.delete;
    g_default_cons.delete;
    g_objt_lookup.delete;
  end reset;

  procedure parse
  as
    l_dgrm_content clob;
    l_has_changed boolean;
  begin
    -- Check if logging is enabled
    g_log_enabled := flow_parser_util.is_log_enabled;

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
       where dgrm_id = g_dgrm_id
      ;
    end if;

    -- parse out collaboration part first
    parse_collaboration( pi_xml => sys.xmltype(l_dgrm_content) );
    -- grab any message definitions
    parse_messages( pi_xml => sys.xmltype(l_dgrm_content) );
    -- start recursive processsing of xml
    parse_xml( pi_xml => sys.xmltype(l_dgrm_content), pi_parent_id => null );

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

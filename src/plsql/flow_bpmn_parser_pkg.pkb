create or replace package body flow_bpmn_parser_pkg
as

  -- Standard Data Types to use
  subtype t_vc200 is varchar2(200 char);

  -- Types for temporary storage of parsing result
  type t_objt_rec is
    record
    (
      objt_name           t_vc200
    , objt_tag_name       flow_types_pkg.t_bpmn_id
    , objt_parent_bpmn_id flow_types_pkg.t_bpmn_id
    , objt_sub_tag_name   flow_types_pkg.t_bpmn_id
    , objt_attached_to    flow_types_pkg.t_bpmn_id
    , objt_interrupting   number
    );
  type t_objt_tab is table of t_objt_rec index by flow_types_pkg.t_bpmn_id;

  type t_obat_rec is
    record
    (
      obat_key            flow_object_attributes.obat_key%type
    , obat_num_value      flow_object_attributes.obat_num_value%type
    , obat_date_value     flow_object_attributes.obat_date_value%type
    , obat_vc_value       flow_object_attributes.obat_vc_value%type
    , obat_clob_value     flow_object_attributes.obat_clob_value%type
    );
  type t_obat_tab is table of t_obat_rec index by pls_integer;

  type t_objt_obat_rec is
    record
    (
      obat_sub_tag_name   flow_objects.objt_sub_tag_name%type
    , obat_tab            t_obat_tab
    );
  type t_objt_obat_tab is table of t_objt_obat_rec index by flow_types_pkg.t_bpmn_id;
  
  type t_conn_rec is
    record
    (
      conn_name        t_vc200
    , conn_src_bpmn_id flow_types_pkg.t_bpmn_id
    , conn_tgt_bpmn_id flow_types_pkg.t_bpmn_id
    , conn_tag_name    flow_types_pkg.t_bpmn_id
    , conn_origin      flow_types_pkg.t_bpmn_id
    );
  type t_conn_tab is table of t_conn_rec index by flow_types_pkg.t_bpmn_id;

  type t_bpmn_ref_tab is table of flow_types_pkg.t_bpmn_id index by flow_types_pkg.t_bpmn_id;
  type t_bpmn_id_tab is table of number index by flow_types_pkg.t_bpmn_id;

  type t_id_lookup_tab is table of number index by flow_types_pkg.t_bpmn_id;

  -- Variables to hold data during parse run
  g_dgrm_id        flow_diagrams.dgrm_id%type;
  g_objects        t_objt_tab;
  g_obj_attribs    t_objt_obat_tab;
  g_connections    t_conn_tab;
  g_lane_refs      t_bpmn_ref_tab;
  g_default_cons   t_bpmn_id_tab;
  g_objt_lookup    t_id_lookup_tab;


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
    l_objt_rec t_objt_rec;
  begin
    if pi_objt_bpmn_id is not null then
      l_objt_rec.objt_name           := pi_objt_name;
      l_objt_rec.objt_tag_name       := pi_objt_tag_name;
      l_objt_rec.objt_sub_tag_name   := pi_objt_sub_tag_name;
      l_objt_rec.objt_parent_bpmn_id := pi_objt_parent_bpmn_id;
      l_objt_rec.objt_attached_to    := pi_objt_attached_to;
      l_objt_rec.objt_interrupting   := pi_objt_interrupting;

      g_objects( pi_objt_bpmn_id ) := l_objt_rec;
    end if;
  end register_object;

  procedure register_object_attributes
  (
    pi_objt_bpmn_id       in flow_objects.objt_bpmn_id%type
  , pi_objt_sub_tag_name  in flow_objects.objt_sub_tag_name%type default null
  , pi_obat_key           in flow_object_attributes.obat_key%type
  , pi_obat_num_value     in flow_object_attributes.obat_num_value%type default null
  , pi_obat_date_value    in flow_object_attributes.obat_date_value%type default null
  , pi_obat_vc_value      in flow_object_attributes.obat_vc_value%type default null
  , pi_obat_clob_value    in flow_object_attributes.obat_clob_value%type default null
  )
  as
    l_objt_sub_tag_name     flow_objects.objt_sub_tag_name%type;

    l_obat_rec              t_obat_rec;
    l_obat_idx              pls_integer;
	l_objt_obat_idx_exists  boolean := false;
  begin
    if pi_objt_bpmn_id is not null then

	  -- check, if the index already exists
	  begin
	     l_objt_sub_tag_name := g_obj_attribs(pi_objt_bpmn_id).obat_sub_tag_name;
		 l_objt_obat_idx_exists := true;
	  exception
	    when no_data_found then
		 l_objt_obat_idx_exists := false;
	  end;

	  -- fill attributes record
	  l_obat_rec.obat_key        := pi_obat_key;
	  l_obat_rec.obat_num_value  := pi_obat_num_value;
	  l_obat_rec.obat_date_value := pi_obat_date_value;
	  l_obat_rec.obat_vc_value   := pi_obat_vc_value;
	  l_obat_rec.obat_clob_value := pi_obat_clob_value;
	  
      if not l_objt_obat_idx_exists then
        g_obj_attribs(pi_objt_bpmn_id).obat_sub_tag_name := pi_objt_sub_tag_name;
		g_obj_attribs(pi_objt_bpmn_id).obat_tab(1) := l_obat_rec;
	  else
        l_obat_idx := coalesce(g_obj_attribs(pi_objt_bpmn_id).obat_tab.last,0);
        g_obj_attribs(pi_objt_bpmn_id).obat_tab(l_obat_idx + 1) := l_obat_rec;
	  end if;

    end if;
  end register_object_attributes;

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
    l_conn_rec t_conn_rec;
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
           )
      returning objt_id into po_objt_id
    ;
  end insert_object;

  procedure insert_object_attributes
  (
    pi_objt_id          in flow_object_attributes.obat_objt_id%type
  , pi_obat_key         in flow_object_attributes.obat_key%type
  , pi_obat_num_value   in flow_object_attributes.obat_num_value%type default null
  , pi_obat_date_value  in flow_object_attributes.obat_date_value%type default null
  , pi_obat_vc_value    in flow_object_attributes.obat_vc_value%type default null
  , pi_obat_clob_value  in flow_object_attributes.obat_clob_value%type default null
  )
  as
  begin
    insert
      into flow_object_attributes
           (
             obat_objt_id
           , obat_key
           , obat_num_value
           , obat_date_value
           , obat_vc_value
           , obat_clob_value
           )
    values (
             pi_objt_id
           , pi_obat_key
           , pi_obat_num_value
           , pi_obat_date_value
           , pi_obat_vc_value
           , pi_obat_clob_value
           )
    ;
  end insert_object_attributes;

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

  procedure process_object_attributes
  (
    pi_objt_id       in flow_object_attributes.obat_objt_id%type
  , pi_objt_bpmn_id  in flow_types_pkg.t_bpmn_id
  )
  as
    l_obat_tab      t_obat_tab;
    l_obat_rec      t_obat_rec;
    l_obat_exists   boolean;
    l_cur_obat_idx  pls_integer;
    l_next_obat_idx pls_integer;
  begin

    -- check, if there are attributes for the object
    begin
      l_obat_tab := g_obj_attribs(pi_objt_bpmn_id).obat_tab;
      l_obat_exists := true;
    exception
      when no_data_found then
        l_obat_exists := false;
    end;

    if l_obat_exists then
      l_cur_obat_idx := l_obat_tab.first;
      while l_cur_obat_idx is not null
      loop
        l_obat_rec := l_obat_tab( l_cur_obat_idx );

        insert_object_attributes
        (
          pi_objt_id         => pi_objt_id
        , pi_obat_key        => l_obat_rec.obat_key
        , pi_obat_num_value  => l_obat_rec.obat_num_value
        , pi_obat_date_value => l_obat_rec.obat_date_value
        , pi_obat_vc_value   => l_obat_rec.obat_vc_value
        , pi_obat_clob_value => l_obat_rec.obat_clob_value
        );

        l_next_obat_idx := l_obat_tab.next( l_cur_obat_idx );
        l_cur_obat_idx := l_next_obat_idx;
      end loop;
    end if;

  end process_object_attributes;

  procedure process_objects
  as
    l_cur_objt_bpmn_id  flow_types_pkg.t_bpmn_id;
    l_next_objt_bpmn_id flow_types_pkg.t_bpmn_id;
    l_cur_object        t_objt_rec;
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
      if l_parent_check and l_lane_check then

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
        , po_objt_id           => l_objt_id
        );

        process_object_attributes
        (
          pi_objt_id           => l_objt_id
        , pi_objt_bpmn_id      => l_cur_objt_bpmn_id
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
                 lane_id   varchar2(50 char) path '@id'
               , lane_name varchar2(50 char) path '@name'
               , lane_type varchar2(50 char) path 'name()'
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
    c_nsmap        constant t_vc200 := flow_constants_pkg.gc_nsmap;
    l_return                flow_types_pkg.t_bpmn_id;
  begin

    if pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_terminate_event_definition, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_bpmn_terminate_event_definition;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_timer_event_definition, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_bpmn_timer_event_definition;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_date, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_timer_type_date;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_duration, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_timer_type_duration;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_timer_type_cycle, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_timer_type_cycle;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_error_event_definition, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_bpmn_error_event_definition;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_escalation_event_definition, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_bpmn_escalation_event_definition;
    elsif pi_xml.existsNode( xpath => '/' || flow_constants_pkg.gc_bpmn_link_event_definition, nsmap => c_nsmap ) = 1 then
      l_return := flow_constants_pkg.gc_bpmn_link_event_definition;    
    end if;

    return l_return;
  end find_subtag_name;

  procedure parse_child_elements
  (
    pi_objt_bpmn_id in flow_types_pkg.t_bpmn_id
  , pi_xml          in xmltype
  )
  as
    l_child_type         flow_types_pkg.t_bpmn_id;
    l_child_id           flow_types_pkg.t_bpmn_id;
    l_child_value        flow_object_attributes.obat_vc_value%type;
    l_child_details      xmltype;
    l_detail_type        flow_types_pkg.t_bpmn_id;
    l_detail_id          flow_types_pkg.t_bpmn_id;
    l_detail_value       flow_object_attributes.obat_vc_value%type;
  begin

    for rec in (
                select children.child_type
                     , children.child_id
                     , children.child_value
                     , children.child_details
                  into l_child_type
                     , l_child_id
                     , l_child_value
                     , l_child_details
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn"
                                      , 'http://www.apex.mt-ag.com' as "apex")
                       , '*' passing pi_xml
                         columns
                           child_type     varchar2(50 char)    path 'name()'
                         , child_id       varchar2(50 char)    path '@id'
                         , child_value    varchar2(4000 char)  path 'text()'
                         , child_details  xmltype              path '* except bpmn:incoming except bpmn:outgoing'
                       ) children
               )
    loop

      if rec.child_details is null then
        -- register the child which does not have details
        if rec.child_value is not null then
          -- if needed distinguish here between different attributes
          register_object_attributes
          (
            pi_objt_bpmn_id      => pi_objt_bpmn_id
          , pi_obat_key          => rec.child_type
          , pi_obat_vc_value     => rec.child_value
        );
        end if;
      else
        -- register the child which has details
        if rec.child_type = flow_constants_pkg.gc_bpmn_timer_event_definition then
    	  begin
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
                       detail_type   varchar2(50 char)    path 'name()'
                     , detail_id     varchar2(50 char)    path '@id'
                     , detail_value  varchar2(4000 char)  path 'text()'
                   ) details;
          end;

          -- register the timer type
          register_object_attributes
          (
            pi_objt_bpmn_id      => pi_objt_bpmn_id
          , pi_objt_sub_tag_name => rec.child_type
          , pi_obat_key          => flow_constants_pkg.gc_timer_type_key
          , pi_obat_vc_value     => l_detail_type
          );
		
          -- register the timer definition
          register_object_attributes
          (
            pi_objt_bpmn_id      => pi_objt_bpmn_id
          , pi_objt_sub_tag_name => rec.child_type
          , pi_obat_key          => flow_constants_pkg.gc_timer_def_key
          , pi_obat_vc_value     => l_detail_value
          );
		
        elsif rec.child_type = flow_constants_pkg.gc_bpmn_terminate_event_definition then
          null;
	    end if;

      end if;

    end loop;

  end parse_child_elements;

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
                  from xmltable
                       (
                         xmlnamespaces ('http://www.omg.org/spec/BPMN/20100524/MODEL' as "bpmn")
                       , '*' passing pi_xml
                         columns
                           steps_type     varchar2(50 char)  path 'name()'
                         , steps_name     varchar2(200 char) path '@name'
                         , steps_id       varchar2(50 char)  path '@id'
                         , source_ref     varchar2(50 char)  path '@sourceRef'
                         , target_ref     varchar2(50 char)  path '@targetRef'
                         , default_conn   varchar2(50 char)  path '@default'
                         , attached_to    varchar2(50 char)  path '@attachedToRef'
                         , interrupting   varchar2(50 char)  path '@cancelActivity'
                         , child_elements xmltype            path '* except bpmn:incoming except bpmn:outgoing'
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

        -- Register Object on Lane if parent belongs to a lane
        -- Those connections are not directly visible in the XML
        -- but BPMN defines inheritance for these.
        if g_lane_refs.exists( pi_proc_bpmn_id ) and rec.steps_id is not null then
          g_lane_refs( rec.steps_id ) := g_lane_refs( pi_proc_bpmn_id );
        end if;

        if rec.steps_type = 'bpmn:laneSet' then
          parse_lanes
          (
            pi_laneset_xml  => rec.child_elements
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
                          proc_id        varchar2(50 char) path '@id'
                        , proc_type      varchar2(50 char) path 'name()'
                        , proc_name      varchar2(50 char) path '@name'
                        , proc_steps     xmltype           path '* except bpmn:subProcess'
                        , proc_sub_procs xmltype           path 'bpmn:subProcess'
                        , proc_laneset   xmltype           path 'bpmn:laneSet'
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
        , pi_objt_tag_name       => rec.proc_type
        , pi_objt_name           => rec.proc_name
        , pi_objt_parent_bpmn_id => pi_parent_id
        );

        -- Register Object on Lane if parent belongs to a lane
        -- Those connections are not directly visible in the XML
        -- but BPMN defines inheritance for these.
        if g_lane_refs.exists( pi_parent_id ) and rec.proc_id is not null then
          g_lane_refs( rec.proc_id ) := g_lane_refs( pi_parent_id );
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
    g_obj_attribs.delete;
    g_connections.delete;
    g_objt_lookup.delete;
  end reset;

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

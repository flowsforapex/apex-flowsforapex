create or replace package body flow_gateways
as 
/* 
-- Flows for APEX - flow_gateways.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Consulting Limited. 2021-24
--
-- Created    06-May-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
-- Modified   2022-07-18   Moritz Klein (MT AG)
-- Modified   09-Jan-2024  Richard Allen, Flowquest Consulting
--
*/
  type t_new_sbfls is table of flow_types_pkg.t_subflow_context;

  e_no_route_found          exception;
  e_bad_routing_expression  exception;
  lock_timeout              exception;
  pragma exception_init (lock_timeout, -3006);

  procedure get_nearest_previous_opening_parincl_gateway
  ( pi_sbfl_rec                in  flow_subflows%rowtype
  , po_nearest_gateway_bpmn_id out flow_objects.objt_bpmn_id%type
  , po_nearest_gateway_type    out flow_objects.objt_tag_name%type
  , po_nearest_gateway_name    out flow_objects.objt_name%type
  , po_num_steps               out integer
  )
  is
    l_gateway_bpmn_id   flow_objects.objt_bpmn_id%type;
    l_current_object    flow_objects.objt_bpmn_id%type;
    l_gateway_type      flow_objects.objt_tag_name%type;
    l_gateway_name      flow_objects.objt_name%type;
    l_num_steps         integer;
  begin
    apex_debug.enter
    ( 'get_nearest_previous_opening_parincl_gateway'
    , 'pi_sbfl_rec.sbfl_current' , pi_sbfl_rec.sbfl_current
    );
    begin
       -- get nearest previous opening parallel or inclusve gateway
       with candidate_gateways as    
        ( select distinct prev_obj.objt_bpmn_id 
               , prev_obj.objt_tag_name
               , coalesce( prev_obj.objt_name, prev_obj.objt_bpmn_id) objt_name
               , prev_obj.objt_id
               , prev_obj.objt_dgrm_id
               , level as num_steps
            from flow_objects prev_obj
            join flow_connections conn
              on conn.conn_src_objt_id = prev_obj.objt_id
             and conn.conn_dgrm_id     = prev_obj.objt_dgrm_id
             and conn.conn_tag_name    = flow_constants_pkg.gc_bpmn_sequence_flow
            join flow_objects curr_obj
              on conn.conn_tgt_objt_id = curr_obj.objt_id
             and conn.conn_dgrm_id     = curr_obj.objt_dgrm_id
             and conn.conn_tag_name    = flow_constants_pkg.gc_bpmn_sequence_flow
           where curr_obj.objt_dgrm_id = pi_sbfl_rec.sbfl_dgrm_id
             and prev_obj.objt_tag_name in ('bpmn:inclusiveGateway','bpmn:parallelGateway')
           start with curr_obj.objt_bpmn_id = pi_sbfl_rec.sbfl_current
          connect by  curr_obj.objt_tag_name not in ('bpmn:inclusiveGateway','bpmn:parallelGateway', 'bpmn:startEvent', 'bpmn:boundaryEvent')
                  and curr_obj.objt_id = prior prev_obj.objt_id
          order by level 
        )
     select candidate_gateways.objt_bpmn_id
          , candidate_gateways.objt_tag_name
          , candidate_gateways.objt_name
          , candidate_gateways.num_steps
       into l_gateway_bpmn_id
          , l_gateway_type
          , l_gateway_name
          , l_num_steps
      from candidate_gateways
      where ( select count (back_links.conn_id)
                from flow_connections back_links
               where back_links.conn_tgt_objt_id = candidate_gateways.objt_id
                 and back_links.conn_tag_name    = flow_constants_pkg.gc_bpmn_sequence_flow
                 and back_links.conn_dgrm_id     = candidate_gateways.objt_dgrm_id
            ) = 1
        ;
    exception
      when no_data_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id      => pi_sbfl_rec.sbfl_prcs_id
        , pi_message_key  => 'gateway-no-previous-gateway'
        );
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id      => pi_sbfl_rec.sbfl_prcs_id
        , pi_message_key  => 'gateway-multiple-previous-gateways'
        );
    end;
    apex_debug.message ( 'Nearest previous opening parallel or inclusive gateway: %0 %1 %2 %3'
                       , l_gateway_bpmn_id
                       , l_gateway_type
                       , l_gateway_name
                       , l_num_steps
                       );
    po_nearest_gateway_bpmn_id := l_gateway_bpmn_id;
    po_nearest_gateway_type    := l_gateway_type;
    po_nearest_gateway_name    := l_gateway_name;  
    po_num_steps               := l_num_steps;  
  end get_nearest_previous_opening_parincl_gateway;

  function get_matching_opening_gateway
  ( pi_sbfl_rec       in flow_subflows%rowtype
  ) return flow_objects.objt_bpmn_id%type
  is
    l_gateway_rec         flow_objects%rowtype;
    l_tgt_objt_bpmn_id    flow_objects.objt_bpmn_id%type;
  begin
    apex_debug.enter
    ( 'get_matching_opening_gateway'
    , 'pi_sbfl_rec.sbfl_current' , pi_sbfl_rec.sbfl_current
    , 'pi_sbfl_rec.sbfl_dgrm_id' , pi_sbfl_rec.sbfl_dgrm_id
    , 'pi_sbfl_rec.sbfl_status'  , pi_sbfl_rec.sbfl_status
    );
    -- get the matching object from the subflow_log record for the completed closing gateway
    begin
      select distinct sflg.sflg_matching_object
        into l_tgt_objt_bpmn_id
        from flow_subflow_log sflg
       where sflg_prcs_id        = pi_sbfl_rec.sbfl_prcs_id
         and sflg_sbfl_id        = pi_sbfl_rec.sbfl_id
         and sflg_objt_id        = pi_sbfl_rec.sbfl_current
      ;
    exception
      when no_data_found then
        -- migration issue from pre 25.1 - no matching object - just can't rewind here!
        l_tgt_objt_bpmn_id  := null;
      when others then
        flow_errors.handle_instance_error
        ( pi_prcs_id      => pi_sbfl_rec.sbfl_prcs_id
        , pi_message_key  => 'gateway-matching-object-error'
        );
    end;
    
    apex_debug.message ( p_message => 'Matching opening gateway: %0 '
                       , p0 => l_tgt_objt_bpmn_id
                       );
    return l_tgt_objt_bpmn_id;
  end get_matching_opening_gateway;

  procedure get_nearest_previous_gateway
  ( pi_sbfl_rec                in  flow_subflows%rowtype
  , po_nearest_gateway_bpmn_id out flow_objects.objt_bpmn_id%type
  , po_nearest_gateway_type    out flow_objects.objt_tag_name%type
  , po_nearest_gateway_name    out flow_objects.objt_name%type
  , po_num_steps               out integer
  )
  is
    l_gateway_bpmn_id   flow_objects.objt_bpmn_id%type;
    l_current_object    flow_objects.objt_bpmn_id%type;
    l_gateway_type      flow_objects.objt_tag_name%type;
    l_gateway_name      flow_objects.objt_name%type;
    l_num_steps         integer;
  begin
    -- get nearest previous gateway
    begin
        select prev_obj.objt_bpmn_id 
             , prev_obj.objt_tag_name
             , coalesce( prev_obj.objt_name, prev_obj.objt_bpmn_id)
             , level
          into l_gateway_bpmn_id
             , l_gateway_type
             , l_gateway_name
             , l_num_steps
          from flow_objects prev_obj
          join flow_connections conn
            on conn.conn_src_objt_id = prev_obj.objt_id
           and conn.conn_dgrm_id     = prev_obj.objt_dgrm_id
           and conn.conn_tag_name    = flow_constants_pkg.gc_bpmn_sequence_flow
          join flow_objects curr_obj
            on conn.conn_tgt_objt_id = curr_obj.objt_id
           and conn.conn_dgrm_id     = curr_obj.objt_dgrm_id
           and conn.conn_tag_name    = flow_constants_pkg.gc_bpmn_sequence_flow
         where curr_obj.objt_dgrm_id = pi_sbfl_rec.sbfl_dgrm_id
           and prev_obj.objt_tag_name in ('bpmn:eventBasedGateway','bpmn:inclusiveGateway','bpmn:parallelGateway',  'bpmn:exclusiveGateway')
         start with curr_obj.objt_bpmn_id = pi_sbfl_rec.sbfl_current
        connect by  curr_obj.objt_tag_name not in ('bpmn:eventBasedGateway','bpmn:inclusiveGateway','bpmn:parallelGateway', 'bpmn:startEvent', 'bpmn:exclusiveGateway', 'bpmn:boundaryEvent')
                and curr_obj.objt_id = prior prev_obj.objt_id
        order by level
        fetch first 1 row only
        ;
    exception
      when no_data_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id      => pi_sbfl_rec.sbfl_prcs_id
        , pi_message_key  => 'gateway-no-previous-gateway'
        );
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id      => pi_sbfl_rec.sbfl_prcs_id
        , pi_message_key  => 'gateway-multiple-previous-gateways'
        );
    end;
    po_nearest_gateway_bpmn_id := l_gateway_bpmn_id;
    po_nearest_gateway_type    := l_gateway_type;
    po_nearest_gateway_name    := l_gateway_name;
    po_num_steps               := l_num_steps;  
  end get_nearest_previous_gateway;

  function get_valid_routing_variable_routes
    ( pi_prcs_id            in flow_processes.prcs_id%type
    , pi_sbfl_id            in flow_subflows.sbfl_id%type
    , pi_objt_bpmn_id       in flow_objects.objt_bpmn_id%type
    , pi_objt_tag           in flow_objects.objt_tag_name%type 
    , pi_routing_variable   in flow_process_variables.prov_var_vc2%type  
    ) return apex_t_varchar2
  is 
    l_forward_routes   apex_t_varchar2;  -- routes specified in the routing variable
    l_possible_routes  apex_t_varchar2;  -- all possible forward routes from the splitting gateway
    l_bad_routes       apex_t_varchar2;  -- specified routes which are not valid routes
    l_bad_route_string varchar2 (2000);
  begin
    begin
      l_forward_routes := apex_string.split ( p_str => pi_routing_variable
                                            , p_sep => ':'
                                            );
      if pi_objt_tag = flow_constants_pkg.gc_bpmn_gateway_exclusive then
        if (l_forward_routes.count > 1) then
          l_bad_route_string := pi_routing_variable;
          apex_debug.info ( p_message => '-- exclusive gateway - routing variable contains more than one forward route %0'
                          , p0 => l_bad_route_string
                          );
          raise flow_errors.e_gateway_invalid_route;
        end if;
      end if;
      -- get the possible forward routes
      select conn.conn_bpmn_id
        bulk collect into l_possible_routes
        from flow_connections conn
        join flow_objects objt 
          on objt.objt_id      = conn.conn_src_objt_id
         and objt.objt_dgrm_id = conn.conn_dgrm_id 
        join flow_subflows sbfl
          on sbfl.sbfl_dgrm_id = conn.conn_dgrm_id
       where sbfl.sbfl_id      = pi_sbfl_id
         and objt.objt_bpmn_id = pi_objt_bpmn_id
      ;
      -- check all specified routes are valid
      l_bad_routes := l_forward_routes multiset except l_possible_routes;

      if l_bad_routes.count > 0 then
        -- we have some invalid routes in the routing variable
        l_bad_route_string := apex_string.join(l_bad_routes,',');
        apex_debug.message ( 
          p_message => 'Invalid routes found - count %0, bad routes: %1)'
        , p0 => l_bad_routes.count
        , p1 => l_bad_route_string 
        );
        raise flow_errors.e_gateway_invalid_route;
      end if;
    exception
      when flow_errors.e_gateway_invalid_route then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'gateway-invalid-route'
        , p0 => pi_objt_bpmn_id 
        , p1 => pi_objt_bpmn_id||flow_constants_pkg.gc_prov_suffix_route
        , p2 => l_bad_route_string
        );
        -- $F4AMESSAGE 'gateway-invalid-route' || 'Error at gateway %0. Supplied variable %1 contains invalid route: %2'  
    end;
    return l_forward_routes;
  end get_valid_routing_variable_routes;

  function get_valid_routing_expression_routes
    ( pi_prcs_id            in flow_processes.prcs_id%type
    , pi_sbfl_id            in flow_subflows.sbfl_id%type
    , pi_scope              in flow_subflows.sbfl_scope%type
    , pi_objt_bpmn_id       in flow_objects.objt_bpmn_id%type
    , pi_objt_tag           in flow_objects.objt_tag_name%type 
    ) return apex_t_varchar2
  is
    l_forward_routes    apex_t_varchar2 := apex_t_varchar2();
    type t_possible_route  is record 
      ( conn_id         flow_connections.conn_id%type
      , conn_is_default flow_connections.conn_is_default%type
      , conn_sequence   flow_connections.conn_sequence%type
      , conn_bpmn_id    flow_connections.conn_bpmn_id%type
      , conn_expression clob
      , conn_language   flow_types_pkg.t_expr_type
      );
    type t_possible_routes is table of t_possible_route;
    l_possible_routes       t_possible_routes;
    l_take_route            boolean;
    l_expr                  clob;
    l_expr_type             flow_types_pkg.t_expr_type;
    l_bind_list             apex_plugin_util.t_bind_list;
    l_expressions           number;
    l_has_default           boolean;
    l_default_has_condition boolean;
    l_num_expected_exprs    number;
  begin
    -- get all valid forward routes, ordered by 
    select conn.conn_id
         , conn.conn_is_default
         , conn.conn_sequence
         , conn.conn_bpmn_id
         , conn.conn_attributes."conditionExpression"."expression" as conn_expression
         , conn.conn_attributes."conditionExpression"."language"   as conn_language
      bulk collect into l_possible_routes
      from flow_connections conn
      join flow_objects objt
        on conn.conn_dgrm_id      = objt.objt_dgrm_id
       and conn.conn_src_objt_id  = objt.objt_id
      join flow_subflows sbfl
        on sbfl.sbfl_dgrm_id      = objt.objt_dgrm_id
     where objt.objt_bpmn_id      = pi_objt_bpmn_id
       and sbfl.sbfl_id           = pi_sbfl_id
       and conn.conn_tag_name     = flow_constants_pkg.gc_bpmn_sequence_flow
     order by conn.conn_is_default asc, conn.conn_sequence asc
    ;

    apex_debug.info( p_message => '-- Found %0 possible routes.', p0 => l_possible_routes.count );

    -- check whether expressions are being used
    -- if so, raise exception if any non default path is missing an expression - assume a missing gw routing var)

    l_expressions           := 0;
    l_has_default           := false;
    l_default_has_condition  := false;

    for route in 1 ..l_possible_routes.count
    loop
      if l_possible_routes(route).conn_expression is not null then
        l_expressions := l_expressions +1;
      end if;
      if l_possible_routes(route).conn_is_default = 1 then
        l_has_default           := true;
        if l_possible_routes(route).conn_expression is not null then
          l_default_has_condition  := true;
        end if;
      end if;
    end loop;

    l_num_expected_exprs := l_possible_routes.count;
    if l_has_default and not l_default_has_condition then
      l_num_expected_exprs := l_num_expected_exprs - 1;
    end if;

    if l_expressions > 0  then
      if l_num_expected_exprs > l_expressions then
        raise e_no_route_found;
      end if;
    end if;

    -- evaluate each routing condition in sequence.  Treat no expression as unconditional

    if l_possible_routes.count > 0 then
      -- loop over routes
      for route in 1 .. l_possible_routes.count
      loop
        l_bind_list := apex_plugin_util.c_empty_bind_list;
        apex_debug.info( p_message => '-- Evaluating Route #%0, Language: %1, Expression: %2', p0 => route, p1 => l_possible_routes(route).conn_language, p2 => l_possible_routes(route).conn_expression );
        l_take_route := false;
        -- evaluate route expression
        l_expr      :=
          flow_engine_util.json_array_join
          ( 
            p_json_array => l_possible_routes(route).conn_expression
          );
        l_expr_type := l_possible_routes(route).conn_language;

        apex_debug.info (p_message => '--- unpacked gateway expression : %0 type : %1  '
          , p0 => l_expr
          , p1 => l_expr_type);

        if l_expr is null and l_possible_routes(route).conn_is_default = 0 then
          -- treat forward path as being false
          l_take_route := false;

          apex_debug.info (p_message => 'Expression contains no condition and will not be taken.'); 
        else 
          -- evaluate condition

          flow_proc_vars_int.do_substitution  ( pi_prcs_id   => pi_prcs_id 
                                              , pi_sbfl_id   => pi_sbfl_id 
                                              , pi_scope     => pi_scope 
                                              , pio_string   => l_expr 
                                              );      

          apex_debug.info (p_message => '--- after substitution - expression : %0 type : %1  '
            , p0 => l_expr
            , p1 => l_expr_type);

          l_bind_list := flow_proc_vars_int.get_bind_list ( pi_expr    => l_expr
                                                          , pi_prcs_id => pi_prcs_id
                                                          , pi_sbfl_id => pi_sbfl_id
                                                          , pi_scope   => pi_scope
                                                          );

          begin
            case l_expr_type  
            when flow_constants_pkg.gc_expr_type_plsql_expression then
              l_take_route := apex_plugin_util.get_plsql_expr_result_boolean ( p_plsql_expression => l_expr 
                                                                             , p_auto_bind_items  => false
                                                                             , p_bind_list        => l_bind_list
                                                                             );
            when flow_constants_pkg.gc_expr_type_plsql_function_body then
              l_take_route := apex_plugin_util.get_plsql_func_result_boolean ( p_plsql_function => l_expr 
                                                                             , p_auto_bind_items  => false
                                                                             , p_bind_list        => l_bind_list
                                                                             );          
            else       
              l_take_route := false;
            end case;
          exception
            when others then
              raise e_bad_routing_expression;
          end;
        end if;

        apex_debug.info (p_message => 'Routing Expresion evaluation result : %0  '
            , p0 => case l_take_route when true then 'true' else 'false' end );

        -- if valid, add to forward_routes
        if l_take_route or ( l_possible_routes(route).conn_is_default = 1 
                             and l_forward_routes.count = 0 )
        then
          l_forward_routes.extend;
          l_forward_routes(l_forward_routes.last) := l_possible_routes(route).conn_bpmn_id;
          if l_possible_routes(route).conn_is_default = 1 then
            apex_debug.info ( p_message => '--- gateway routing using default routing'); 
          end if;
          -- if exclusive gateway, break out - we have our route
          if pi_objt_tag = flow_constants_pkg.gc_bpmn_gateway_exclusive then
            return l_forward_routes;
          end if;
        end if;
      end loop;
    else
      raise e_no_route_found;
    end if;
    -- check that some routes were found
    if l_forward_routes.count = 0 then
      raise e_no_route_found;
    end if;
    return l_forward_routes;
  end get_valid_routing_expression_routes;

  function get_gateway_route
    ( pi_prcs_id        in flow_processes.prcs_id%type
    , pi_sbfl_id        in flow_subflows.sbfl_id%type
    , pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
    , pi_objt_tag       in flow_objects.objt_tag_name%type
    , pi_scope          in flow_subflows.sbfl_scope%type
    ) return apex_t_varchar2
  is
    l_routing_variable      varchar2(2000);  -- 1 route for exclusiveGateway, 1 or more for inclusive (:sep)
    l_forward_routes        apex_t_varchar2 := apex_t_varchar2();
    l_num_routes            number := 0;
    l_default_route         flow_connections.conn_bpmn_id%type;

  begin
    begin
      -- check if route is in process variable
      l_routing_variable := flow_proc_vars_int.get_var_vc2 
                            ( pi_prcs_id  => pi_prcs_id
                            , pi_var_name => pi_objt_bpmn_id||flow_constants_pkg.gc_prov_suffix_route
                            , pi_scope    => pi_scope
                            );
      if l_routing_variable is not null then
        apex_debug.info( p_message => '-- Using Routing Variable (Legacy Mode).' );
        -- route from routing variable
        l_forward_routes := get_valid_routing_variable_routes ( pi_prcs_id          => pi_prcs_id
                                                              , pi_sbfl_id          => pi_sbfl_id
                                                              , pi_objt_bpmn_id     => pi_objt_bpmn_id
                                                              , pi_objt_tag         => pi_objt_tag
                                                              , pi_routing_variable => l_routing_variable
                                                              );   
        apex_debug.info ( p_message => '-- gateway routing using gateway routing variable.  Forward path: %0'
                        , p0 => l_routing_variable
                        );                                                                
      else 
        apex_debug.info( p_message => '-- Using Gateway Route Expressions or Default Routing.' );
        -- look for gateway routing expressions or default routing
        l_forward_routes := get_valid_routing_expression_routes ( pi_prcs_id          => pi_prcs_id
                                                                , pi_sbfl_id          => pi_sbfl_id
                                                                , pi_objt_bpmn_id     => pi_objt_bpmn_id
                                                                , pi_objt_tag         => pi_objt_tag
                                                                , pi_scope            => pi_scope
                                                                ); 
        apex_debug.info ( p_message => '-- gateway routing using gateway routing expressions or default path. Forward path: %0'
                        , p0 => apex_string.join (p_table => l_forward_routes, p_sep => ':')
                        );   
      end if; 
      if l_forward_routes.count = 0 then
        raise e_no_route_found;
      end if;
    exception
      when e_no_route_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'gateway-no-route'
        , p0 => pi_objt_bpmn_id||flow_constants_pkg.gc_prov_suffix_route
        );
        -- $F4AMESSAGE 'gateway-no-route' || 'No gateway routing instruction provided in variable %0 and model contains no default route.'  
      when e_bad_routing_expression then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'gateway-bad-expression'
        , p0 => pi_objt_bpmn_id||flow_constants_pkg.gc_prov_suffix_route
        );
        -- $F4AMESSAGE 'gateway-bad_expression' || 'Bad gateway routing expression.  This can occur if you attempt to bind a variable with embedded colon (:).'  
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'gateway-too-many-defaults'
        , p0 => pi_objt_bpmn_id
        );
        -- $F4AMESSAGE 'gateway-too-many-defaults' || 'More than one default route specified in model for Gateway %0.' 
    end;
    return l_forward_routes;
  end get_gateway_route;

  function gateway_merge
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    ) return varchar2 -- returns forward status 'wait' or 'proceed'
  is 
    l_num_unfinished_subflows   number;
    l_gateway_forward_status    varchar2(10)  := 'wait';
    l_subflow                   flow_subflows.sbfl_id%type;
  begin  
    apex_debug.enter 
    ( 'gateway_merge'
    , 'p_sbfl_info.sbfl_current' , p_sbfl_info.sbfl_current
    , 'p_step_info.target_objt_ref' , p_step_info.target_objt_ref
    , 'p_sbfl_info.sbfl_last_completed', p_sbfl_info.sbfl_last_completed
    );
    -- set current subflow to status waiting,       
    update flow_subflows sbfl
        set sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_waiting_gateway
          , sbfl.sbfl_current        = p_step_info.target_objt_ref
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )            
      where sbfl.sbfl_id = p_sbfl_info.sbfl_id
        and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
    ;
    -- check if we are waiting for other flows or can proceed
    select count(*)
      into l_num_unfinished_subflows
      from flow_subflows sbfl
      where sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
        and sbfl.sbfl_diagram_level = p_sbfl_info.sbfl_diagram_level
        and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
        and (  sbfl.sbfl_current != p_step_info.target_objt_ref
            or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
            )
    ;
    if l_num_unfinished_subflows = 0 then
      -- all task to be merged have completed.  So we do the merge... 
      -- lock parent subflow first
      if flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id) then
        begin
          -- proceed from gateway, locking child subflows
          for completed_subflows in ( select completed_sbfl.sbfl_id
                                        from flow_subflows completed_sbfl 
                                        where completed_sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
                                          and completed_sbfl.sbfl_diagram_level = p_sbfl_info.sbfl_diagram_level
                                          and completed_sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                          and completed_sbfl.sbfl_current = p_step_info.target_objt_ref 
                                          and completed_sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                          for update wait 2
                                    )
          loop
            l_subflow := completed_subflows.sbfl_id;
            flow_engine_util.subflow_complete
            ( p_process_id => p_sbfl_info.sbfl_prcs_id
            , p_subflow_id => completed_subflows.sbfl_id
            );
          end loop;

          --mark parent split subflow ready to restart
          l_subflow := p_sbfl_info.sbfl_sbfl_id;
          update flow_subflows parent_sbfl
              set parent_sbfl.sbfl_status                   = flow_constants_pkg.gc_sbfl_status_proceed_gateway
                , parent_sbfl.sbfl_current                  = p_step_info.target_objt_ref
                , parent_sbfl.sbfl_iteration_type           = null
                , parent_sbfl.sbfl_loop_counter             = null
                , parent_sbfl.sbfl_loop_total_instances     = null
                , parent_sbfl.sbfl_last_completed           = p_sbfl_info.sbfl_current  -- last step of final child sbfl pre-merge
                , parent_sbfl.sbfl_last_update              = systimestamp
                , parent_sbfl.sbfl_last_update_by           = coalesce ( sys_context('apex$session','app_user') 
                                                                       , sys_context('userenv','os_user')
                                                                       , sys_context('userenv','session_user')
                                                                       )  
            where parent_sbfl.sbfl_last_completed           = p_sbfl_info.sbfl_starting_object
              and parent_sbfl.sbfl_status                   = flow_constants_pkg.gc_sbfl_status_split  
              and parent_sbfl.sbfl_id                       = p_sbfl_info.sbfl_sbfl_id
          ;
        exception
          when lock_timeout then
            flow_errors.handle_instance_error
            ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
            , pi_sbfl_id => l_subflow
            , pi_message_key => 'timeout_locking_subflow'
            , p0 => l_subflow
            );
          when others then
            flow_errors.handle_instance_error
            ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
            , pi_message_key => 'gateway-merge-error'
            , p0 => l_subflow
            );          
            -- $F4AMESSAGE 'gateway-merge-error' || 'Internal error processing merging gateway on subflow %0' 
        end;
        -- test for any errors so far 
        if not flow_globals.get_step_error then 
          -- process any after-merge expression set
          flow_expressions.process_expressions
          ( pi_objt_id     => p_step_info.target_objt_id
          , pi_set         => flow_constants_pkg.gc_expr_set_after_merge
          , pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id     => p_sbfl_info.sbfl_sbfl_id
          , pi_var_scope   => p_sbfl_info.sbfl_scope
          , pi_expr_scope  => p_sbfl_info.sbfl_scope
          );
          -- test again for any errors so far - if so, don't commit
          if not flow_globals.get_step_error then 
            -- commit tx
            commit;
            -- start new tx by locking parent subflow
            if not flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id) then
              -- unable to lock parent 'split' subflow.
              flow_errors.handle_instance_error
              ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
              , pi_sbfl_id => p_sbfl_info.sbfl_sbfl_id
              , pi_message_key => 'timeout_locking_subflow'
              , p0 => p_sbfl_info.sbfl_sbfl_id
              );
            end if;
            l_gateway_forward_status := 'proceed';
          else
            -- has step errors from expressions
            flow_errors.set_error_status
            ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
            , pi_sbfl_id => p_sbfl_info.sbfl_sbfl_id
            );
          end if;  
        else 
          -- has step errors from merge
          flow_errors.set_error_status
          ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id => p_sbfl_info.sbfl_sbfl_id
          );
        end if;       
      else 
        -- unable to lock parent 'split' subflow.
        -- exception already handled in lock_subflow so no need to throw an error here.
        -- has step errors from locking
        flow_errors.set_error_status
        ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id => p_sbfl_info.sbfl_sbfl_id
        );
      end if;
    end if; 
    return l_gateway_forward_status;
  end gateway_merge;

  procedure gateway_split
    ( p_subflow_id     in flow_subflows.sbfl_id%type 
    , p_sbfl_info      in flow_subflows%rowtype
    , p_step_info      in flow_types_pkg.flow_step_info
    , p_gateway_routes in apex_t_varchar2
    )
  is 
    l_new_subflows      t_new_sbfls := t_new_sbfls();
    l_new_subflow       flow_types_pkg.t_subflow_context;
  begin 
    apex_debug.enter 
    ( 'gateway_split'
    , 'p_sbfl_info.sbfl_current' , p_sbfl_info.sbfl_current
    , 'p_step_info.target_objt_ref' , p_step_info.target_objt_ref
    );
    -- note that p_subflow_id might be different to the subflow in p_sbfl_info.sbfl_id
    -- we have splitting gateway going forward
    -- Current Subflow into status split 
    update flow_subflows sbfl
        set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
          , sbfl.sbfl_current        = p_step_info.target_objt_ref
          , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_split  
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
    ;
    -- get all forward parallel paths and create subflows for them
    -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
    -- create subflows in one loop then step through them again in second loop
    -- to prevent some subflows getting to following merge gateway before all subflows are created (causes race condition)

    for new_path in ( select conn.conn_bpmn_id route
                           , ultimate_tgt_objt.objt_bpmn_id target
                        from flow_connections conn
                        join flow_objects ultimate_tgt_objt -- first object in each child
                          on ultimate_tgt_objt.objt_id = conn.conn_tgt_objt_id
                         and conn.conn_dgrm_id = ultimate_tgt_objt.objt_dgrm_id
                        join flow_objects objt  -- gateway object
                          on objt.objt_id = conn.conn_src_objt_id
                         and conn.conn_dgrm_id = objt.objt_dgrm_id
                       where conn.conn_dgrm_id = p_step_info.dgrm_id
                         and conn.conn_src_objt_id = p_step_info.target_objt_id
                         and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                         and ( objt.objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_parallel
                             OR 
                             ( objt.objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_inclusive
                             and 
                               conn.conn_bpmn_id member of p_gateway_routes
                             ))
                    )
    loop
      -- path is included in list of chosen forward paths.
      apex_debug.info
      ( p_message => 'starting parallel flow for %0'
      , p0        => p_step_info.target_objt_tag
      );

      l_new_subflow :=
        flow_engine_util.subflow_start
        ( p_process_id             => p_sbfl_info.sbfl_prcs_id         
        , p_parent_subflow         => p_subflow_id       
        , p_starting_object        => p_step_info.target_objt_ref         
        , p_current_object         => p_step_info.target_objt_ref          
        , p_route                  => new_path.route         
        , p_last_completed         => p_sbfl_info.sbfl_current 
        , p_status                 => flow_constants_pkg.gc_sbfl_status_created
        , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
        , p_new_proc_level         => false
        , p_dgrm_id                => p_sbfl_info.sbfl_dgrm_id
        )
      ;
      l_new_subflow.route   := new_path.route;
      l_new_subflows.extend;
      l_new_subflows (l_new_subflows.last) := l_new_subflow;
    end loop;
    -- log gateway as completed
    flow_logging.log_step_completion   
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => p_step_info.target_objt_ref 
    );
    -- update parent status now split and no current object
     update flow_subflows sbfl
        set sbfl.sbfl_current        = null
          , sbfl.sbfl_last_completed = p_step_info.target_objt_ref
          , sbfl.sbfl_last_update    = systimestamp
          , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id;

    -- commit the transaction
    commit;
    
    apex_debug.info ( p_message => 'New Subflow Creation Commited');
    
    for new_subflow in 1.. l_new_subflows.count
    loop
      -- reset step_had_error flag
      flow_globals.set_step_error ( p_has_error => false);
      -- check subflow still exists and lock it(in case earlier loop terminated everything in level)
      if flow_engine_util.lock_subflow( p_subflow_id => l_new_subflows(new_subflow).sbfl_id)
      then
        -- step into first step on the new path
        flow_engine.flow_complete_step    
        ( p_process_id        => p_sbfl_info.sbfl_prcs_id
        , p_subflow_id        => l_new_subflows(new_subflow).sbfl_id
        , p_step_key          => l_new_subflows(new_subflow).step_key
        , p_forward_route     => l_new_subflows(new_subflow).route
        , p_log_as_completed  => false
        );
      end if;
    end loop;
    -- reset step_had_error flag
    flow_globals.set_step_error ( p_has_error => false);
  end gateway_split;

  procedure process_para_incl_Gateway
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_gateway_forward_status    varchar2(10);
    l_sbfl_id                   flow_subflows.sbfl_id%type;
    l_sbfl_id_sub               flow_subflows.sbfl_id%type;
    l_sbfl_id_par               flow_subflows.sbfl_id%type; 
    l_num_back_connections      number;   -- number of connections leading into object
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_unfinished_subflows   number;
    l_forward_routes            apex_t_varchar2 := apex_t_varchar2();
    l_step_key                  flow_subflows.sbfl_step_key%type;
    l_tag_name                  flow_objects.objt_tag_name%type; -- not used
    l_is_actual_gateway         boolean;  -- set if the object is really a gateway (vs. an iteration acting as a gateway)
    l_matching_object           flow_objects.objt_bpmn_id%type;
/*    l_new_subflows              t_new_sbfls := t_new_sbfls();
    l_new_subflow               flow_types_pkg.t_subflow_context; */ -- think these not used
  begin
    apex_debug.enter 
    ( 'process_para_incl_Gateway'
    , 'p_step_info.target_objt_tag'       , p_step_info.target_objt_tag
    , 'p_step_info.target_objt_ref'       , p_step_info.target_objt_ref
    , 'p_step_info.target_objt_iteration' , nvl( p_step_info.target_objt_iteration, 'Null')
    );
    if p_step_info.target_objt_treat_as_tag is null and p_sbfl_info.sbfl_loop_counter is null then 
      -- for actual gateway get number of forward and backward connections
      flow_engine_util.get_number_of_connections
      ( pi_dgrm_id                  => p_step_info.dgrm_id
      , pi_objt_bpmn_id             => p_step_info.target_objt_ref
      , pi_conn_type                => flow_constants_pkg.gc_bpmn_sequence_flow
      , po_num_back_connections     => l_num_back_connections
      , po_num_forward_connections  => l_num_forward_connections
      , po_objt_tag_name            => l_tag_name  -- not used
      );
      l_is_actual_gateway := true;
    elsif p_step_info.target_objt_treat_as_tag = flow_constants_pkg.gc_bpmn_gateway_parallel 
    and p_sbfl_info.sbfl_loop_counter is null then
      l_is_actual_gateway := false;
      l_num_back_connections    := 1;
      l_num_forward_connections := 99;
    elsif p_step_info.target_objt_treat_as_tag = flow_constants_pkg.gc_bpmn_gateway_parallel 
    and p_sbfl_info.sbfl_loop_counter is not null then
      l_is_actual_gateway := false;
      l_num_back_connections    := 99;
      l_num_forward_connections := 1;
    end if;

    l_gateway_forward_status := 'proceed';
    l_sbfl_id  := p_sbfl_info.sbfl_id;

    if l_num_back_connections > 1  then
      apex_debug.info
      ( p_message => '%0 Parallel Merging %1'
      , p0        => p_step_info.target_objt_tag
      , p1        => p_step_info.target_objt_ref
      );  
      if p_sbfl_info.sbfl_iteration_type = flow_constants_pkg.gc_iteration_parallel 
         and p_sbfl_info.sbfl_loop_counter is not null 
      then
        -- we have merging gateway.  do the merge. returns 'wait' if flow is waiting at gateway, 'proceed' if merged
        l_gateway_forward_status := flow_iteration.parallel_merge ( p_sbfl_info  => p_sbfl_info
                                                                    , p_step_info  => p_step_info
                                                                    );
      else      
        -- we have merging gateway.  do the merge. returns 'wait' if flow is waiting at gateway, 'proceed' if merged
        l_gateway_forward_status := gateway_merge ( p_sbfl_info  => p_sbfl_info
                                                  , p_step_info  => p_step_info
                                                  );
        l_matching_object := p_sbfl_info.sbfl_starting_object;
      end if;                                        
      -- switch to parent subflow 
      l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
    end if;
    
    -- now do forward path, if you have token to 'proceed'
    if l_gateway_forward_status = 'proceed' then 
      if l_num_forward_connections > 1 then
        -- we have splitting gateway going forward
        apex_debug.info 
        ( p_message => '%0 Parallel Splitting %1 - %2 forward paths'
        , p0 => p_step_info.target_objt_tag
        , p1 => p_step_info.target_objt_ref
        , p2 => l_num_forward_connections
        );       
        if l_is_actual_gateway then
          -- process any before-split expression set
          flow_expressions.process_expressions
          ( pi_objt_id     => p_step_info.target_objt_id
          , pi_set         => flow_constants_pkg.gc_expr_set_before_split
          , pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id     => l_sbfl_id
          , pi_var_scope   => p_sbfl_info.sbfl_scope
          , pi_expr_scope  => p_sbfl_info.sbfl_scope
          );
        end if;      
        -- test for any errors so far - if so, skip finding a route
        if not flow_globals.get_step_error then 
          apex_debug.info ( p_message => 'process_para_incl_Gateway: step has no errors after evaluating expressions');

          if l_is_actual_gateway then
            case p_step_info.target_objt_tag
            when flow_constants_pkg.gc_bpmn_gateway_inclusive then 
              -- actual inclusive gateway
              l_forward_routes := get_gateway_route
              ( pi_prcs_id       => p_sbfl_info.sbfl_prcs_id
              , pi_sbfl_id       => l_sbfl_id --l_sbfl_id?
              , pi_objt_bpmn_id   => p_step_info.target_objt_ref
              , pi_objt_tag       => p_step_info.target_objt_tag
              , pi_scope          => p_sbfl_info.sbfl_scope
              );
              apex_debug.info
              ( p_message => 'Forward routes for inclusiveGateway %0 : %1'
              , p0 => p_step_info.target_objt_ref
              , p1 => apex_string.join(l_forward_routes,':')
              );
              flow_logging.log_step_event
              ( p_sbfl_rec      => p_sbfl_info
--              , p_objt_bpmn_id  => p_step_info.target_objt_ref
              , p_event  => flow_constants_pkg.gc_step_event_route_chosen
              , p_event_level => flow_constants_pkg.gc_logging_level_routine
              , p_comment  => 'Chosen Paths : '||apex_string.join(l_forward_routes,':')
              );
            when flow_constants_pkg.gc_bpmn_gateway_parallel then 
              -- actual parallel gateway
              l_forward_routes.extend;
              l_forward_routes(l_forward_routes.first) := 'parallel';  -- just needs to be some not null string
            end case;
          end if; 
          -- test for any errors again - if so, skip doing the split
          if not flow_globals.get_step_error then 
            apex_debug.info ( p_message => 'process_para_incl_Gateway: step has no errors after evaluating routes');
            if l_is_actual_gateway then
              gateway_split
              ( p_subflow_id => l_sbfl_id
              , p_sbfl_info  => p_sbfl_info
              , p_step_info  => p_step_info
              , p_gateway_routes => l_forward_routes
              );
            else
              -- is a parallel iteration split...
              ---- Add Edition IFDEF code here... If Enterprise compile this
              flow_iteration.parallel_split
              ( p_subflow_id => l_sbfl_id
              , p_sbfl_info  => p_sbfl_info
              , p_step_info  => p_step_info
              );   
              ---- Add Edition IFDEF code here... else include this stubb
              -- raise feature_not_in_this_edition error
              --
              --
              -- End of Edition IFDEF code.       
            end if;
          else
            -- has step errors from evaluating route
            flow_errors.set_error_status
            ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
            , pi_sbfl_id => l_sbfl_id
            );
          end if;
        else
          -- has step errors from expressions
          flow_errors.set_error_status
          ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id => l_sbfl_id
          );
        end if;
      elsif l_num_forward_connections = 1 then
        -- only single path going forward
        update  flow_subflows sbfl
            set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
              , sbfl.sbfl_current = p_step_info.target_objt_ref
              , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
              , sbfl.sbfl_last_update = systimestamp 
          where sbfl.sbfl_id = l_sbfl_id
            and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
        ;
        -- get step key from parent 
        select sbfl.sbfl_step_key
          into l_step_key
          from flow_subflows sbfl
         where sbfl.sbfl_id = l_sbfl_id; 

        -- step into first step on the new path
        flow_engine.flow_complete_step   
        ( p_process_id => p_sbfl_info.sbfl_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key   => l_step_key
        , p_forward_route => null
        , p_matching_object => l_matching_object
        );
      end if;  -- single path
    end if;  -- forward token
  end process_para_incl_Gateway;

  procedure process_exclusiveGateway
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is 
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_back_connections      number;   -- number of connections back from object
    l_forward_routes            apex_t_varchar2 := apex_t_varchar2();
    l_forward_route             flow_connections.conn_bpmn_id%type;
    l_tag_name                  flow_objects.objt_tag_name%type;  -- not used
  begin
    -- handles opening and closing and closing and reopening
    apex_debug.enter 
    ( 'process_exclusiveGateway'
    , 'p_step_info.target_objt_tag' , p_step_info.target_objt_tag
    );
    flow_engine_util.get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_objt_bpmn_id => p_step_info.target_objt_ref
    , pi_conn_type => flow_constants_pkg.gc_bpmn_sequence_flow
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    , po_objt_tag_name => l_tag_name  -- not used
    );

    if l_num_forward_connections > 1 then
      -- opening gateway 
      -- process any before-split expression set before gateway chooses route
      flow_expressions.process_expressions
      ( pi_objt_id     => p_step_info.target_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_before_split
      , pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_info.sbfl_id
      , pi_var_scope   => p_sbfl_info.sbfl_scope
      , pi_expr_scope  => p_sbfl_info.sbfl_scope
      );
      -- test for any errors so far - if so, skip finding a route
      if not flow_globals.get_step_error then 
        -- get route choice
        l_forward_routes := get_gateway_route
        ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id        => p_sbfl_info.sbfl_id
        , pi_objt_bpmn_id   => p_step_info.target_objt_ref
        , pi_objt_tag       => p_step_info.target_objt_tag
        , pi_scope          => p_sbfl_info.sbfl_scope
        );
        if l_forward_routes.count > 0 then
          l_forward_route := l_forward_routes(l_forward_routes.first);
        end if;
      else
        -- has step errors from expressions
        flow_errors.set_error_status
        ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id => p_sbfl_info.sbfl_id
        );
      end if;
    else 
      -- closing gateway 
      -- process any after-merge expression set
      flow_expressions.process_expressions
      ( pi_objt_id     => p_step_info.target_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_after_merge
      , pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id     => p_sbfl_info.sbfl_id
      , pi_var_scope   => p_sbfl_info.sbfl_scope
      , pi_expr_scope  => p_sbfl_info.sbfl_scope
      );      
      -- keep going
      l_forward_route := null;
    end if;  

    if not flow_globals.get_step_error then 
      -- all good so step forward
      update flow_subflows sbfl
         set sbfl.sbfl_current        = p_step_info.target_objt_ref
           , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
           , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_running
           , sbfl.sbfl_last_update    = systimestamp
           , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                                 , sys_context('userenv','os_user')
                                                 , sys_context('userenv','session_user')
                                                 )  
       where sbfl.sbfl_id = p_sbfl_info.sbfl_id
         and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
      ;  
      flow_engine.flow_complete_step   
      ( p_process_id    => p_sbfl_info.sbfl_prcs_id
      , p_subflow_id    => p_sbfl_info.sbfl_id
      , p_step_key      => p_sbfl_info.sbfl_step_key
      , p_forward_route => l_forward_route
      );
    else        
      -- has step errors from evaluating route
      flow_errors.set_error_status
      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id => p_sbfl_info.sbfl_id
      );
    end if;

  end process_exclusiveGateway; 

  procedure process_eventBasedGateway
    ( p_sbfl_info  in flow_subflows%rowtype
    , p_step_info  in flow_types_pkg.flow_step_info
    )
  is 
    l_new_subflow       flow_types_pkg.t_subflow_context;
    l_new_subflows      t_new_sbfls := t_new_sbfls();
  begin
    -- eventGateway can have multiple inputs and outputs, but there is no waiting, etc.
    -- incoming subflow continues on the first output path.
    -- additional output paths create new subflows
    apex_debug.enter
    (
      p_routine_name => 'process_EventBasedGateway'
    , p_name01       => 'p_step_info.target_objt_ref'
    , p_value01      => p_step_info.target_objt_ref
    );
    -- process any before-split expression set
    flow_expressions.process_expressions
    ( pi_objt_id     => p_step_info.target_objt_id
    , pi_set         => flow_constants_pkg.gc_expr_set_before_split
    , pi_prcs_id     => p_sbfl_info.sbfl_prcs_id
    , pi_sbfl_id     => p_sbfl_info.sbfl_id
    , pi_var_scope   => p_sbfl_info.sbfl_scope
    , pi_expr_scope  => p_sbfl_info.sbfl_scope
    );

    -- log gateway as completed here so only logged once
    flow_logging.log_step_completion   
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_completed_object => p_step_info.target_objt_ref 
    );
    -- get all forward parallel paths and create subflows for them
    -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
    for new_path in ( select conn.conn_bpmn_id route
                           , objt.objt_bpmn_id target
                        from flow_connections conn
                        join flow_objects objt
                          on objt.objt_id = conn.conn_tgt_objt_id
                         and conn.conn_dgrm_id = objt.objt_dgrm_id
                       where conn.conn_dgrm_id = p_step_info.dgrm_id
                         and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                         and conn.conn_src_objt_id = p_step_info.target_objt_id
                    )
    loop
      -- create new subflows for forward event paths starting here
      -- don't start them yet...
      apex_debug.info
      ( p_message => 'starting parallel flow from Event Based Gateway for %0'
      , p0        => p_step_info.target_objt_tag
      );

     l_new_subflow :=  flow_engine_util.subflow_start
        ( 
          p_process_id             => p_sbfl_info.sbfl_prcs_id        
        , p_parent_subflow         => p_sbfl_info.sbfl_id       
        , p_starting_object        => p_step_info.target_objt_ref         
        , p_current_object         => p_step_info.target_objt_ref          
        , p_route                  => new_path.route         
        , p_last_completed         => p_step_info.target_objt_ref 
        , p_status                 => flow_constants_pkg.gc_sbfl_status_created   
        , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
        , p_new_proc_level         => false    
        , p_dgrm_id                => p_sbfl_info.sbfl_dgrm_id
        , p_follows_ebg            => true
        )
      ;
      l_new_subflow.route   := new_path.route;
      l_new_subflows.extend;
      l_new_subflows (l_new_subflows.last) := l_new_subflow;
    end loop;      
    -- mark parent flow as split
    update flow_subflows sbfl
       set sbfl.sbfl_last_completed = p_sbfl_info.sbfl_current
         , sbfl.sbfl_current        = p_step_info.target_objt_ref
         , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_split  
         , sbfl.sbfl_last_update    = systimestamp
         , sbfl.sbfl_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                               , sys_context('userenv','os_user')
                                               , sys_context('userenv','session_user')
                                               )  
     where sbfl.sbfl_id = p_sbfl_info.sbfl_id
       and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
    ;
    -- commit the transaction
    commit;
    apex_debug.info ( p_message => 'New Subflow Creation Commited');
    
    for new_subflow in 1.. l_new_subflows.count
    loop
      -- reset step_had_error flag
      flow_globals.set_step_error ( p_has_error => false);
      -- check subflow still exists and lock it(in case earlier loop terminated everything in level)
      if flow_engine_util.lock_subflow
        ( p_subflow_id => l_new_subflows(new_subflow).sbfl_id
        )
      then    
        -- step into first step on the new path
        flow_engine.flow_complete_step   
        (
          p_process_id        => p_sbfl_info.sbfl_prcs_id
        , p_subflow_id        => l_new_subflows(new_subflow).sbfl_id
        , p_step_key          => l_new_subflows(new_subflow).step_key
        , p_forward_route     => l_new_subflows(new_subflow).route
        , p_log_as_completed  => false
        );
      end if;
    end loop;
    -- reset step_had_error flag
    flow_globals.set_step_error ( p_has_error => false);
  end process_eventBasedGateway;

end flow_gateways;
/

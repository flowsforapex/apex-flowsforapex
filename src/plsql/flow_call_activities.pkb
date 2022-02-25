/* 
-- Flows for APEX - flow_call_activities.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 19-Feb-2022   Richard Allen - Create 
--
*/

create or replace package body flow_call_activities 
as

  type t_call_def is record
    ( dgrm_name              flow_diagrams.dgrm_name%type
    , dgrm_version           flow_diagrams.dgrm_version%type
    , dgrm_id                flow_diagrams.dgrm_id%type
    , dgrm_version_selection flow_object_attributes.obat_vc_value%type
    );

  function is_called_activity
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type  
    ) return boolean
  is
    l_prcs_dgrm_id flow_processes.prcs_dgrm_id%type;
    l_sbfl_dgrm_id flow_subflows.sbfl_dgrm_id%type;
  begin
    select prcs.prcs_dgrm_id
         , sbfl.sbfl_dgrm_id
      into l_prcs_dgrm_id
         , l_sbfl_dgrm_id
      from flow_subflows sbfl
      join flow_processes prcs
        on prcs.prcs_id = sbfl.sbfl_prcs_id
     where prcs.prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
    ;
    return ( l_prcs_dgrm_id != l_sbfl_dgrm_id);
  end;

  procedure process_call_activity_endEvent
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    , p_sbfl_context_par  in flow_types_pkg.t_subflow_context
    )
  is
  begin
    null;
  end process_call_activity_endEvent;

  function get_call_definition
    ( pi_call_objt_id       in   flow_objects.objt_id%type
    ) return t_call_def
  is 
    l_call_def                  t_call_def;
  begin
    apex_debug.enter
    ( 'get_call_definition'
    , 'callActivity objt id' , pi_call_objt_id
    );

    for rec in (
                select obat.obat_key
                     , obat.obat_vc_value
                  from flow_object_attributes obat
                 where obat.obat_objt_id = pi_call_objt_id
                   and obat.obat_key in ( flow_constants_pkg.gc_apex_called_diagram 
                                        , flow_constants_pkg.gc_apex_called_diagram_version_selection
                                        , flow_constants_pkg.gc_apex_called_diagram_version
                                        )
               )
    loop
      case rec.obat_key
        when flow_constants_pkg.gc_apex_called_diagram then
          l_call_def.dgrm_name := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_called_diagram_version_selection then
          l_call_def.dgrm_version_selection := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_called_diagram_version then
          l_call_def.dgrm_version := rec.obat_vc_value;
        else
          null;
      end case;
    end loop;

    return l_call_def;

  end get_call_definition;

  procedure process_callActivity
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_call_definition           t_call_def;
    l_called_dgrm_id            flow_diagrams.dgrm_id%type;
    l_called_start_objt_bpmn_id flow_objects.objt_bpmn_id%type;
    l_called_subflow_context    flow_types_pkg.t_subflow_context;
  begin
    apex_debug.enter 
    ( 'process_callActivity'
    , 'object', p_step_info.target_objt_tag 
    );

    -- get Call activity Attributes
    l_call_definition := get_call_definition ( pi_call_objt_id  => p_step_info.target_objt_id );

    -- find called diagram

    case l_call_definition.dgrm_version_selection 
    when 'latestVersion' then
      -- get the 'released' diagram or 'draft' version '0' diagram
      l_called_dgrm_id := flow_diagram.get_current_diagram 
                          ( pi_dgrm_name => l_call_definition.dgrm_name
                          , pi_prcs_id   => p_process_id
                          , pi_sbfl_id   => p_subflow_id
                          );
    when 'namedVersion' then
      select dgrm_id
        into l_called_dgrm_id
        from flow_diagrams
       where dgrm_name    = l_call_definition.dgrm_name
         and dgrm_version = l_call_definition.dgrm_version
      ;
    end case;

    -- find start object

    l_called_start_objt_bpmn_id := flow_diagram.get_start_event 
                                    ( pi_dgrm_id => l_called_dgrm_id
                                    , pi_prcs_id => p_process_id
                                    );

    -- create initial subflow in called activity (set new dgrm id, new scope)

    l_called_subflow_context := flow_engine_util.subflow_start 
      ( p_process_id      => p_process_id
      , p_parent_subflow  => p_subflow_id
      , p_starting_object => l_called_start_objt_bpmn_id
      , p_current_object  => l_called_start_objt_bpmn_id
      , p_route           => 'main'
      , p_last_completed  => p_sbfl_info.sbfl_current
      , p_status          => flow_constants_pkg.gc_sbfl_status_running 
      , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
      , p_new_proc_level  => true
      , p_new_scope       => true
      , p_dgrm_id         => l_called_dgrm_id
      );

      -- Always do all updates to parent data first before performing any next step in the children.
      -- Reason: A subflow could immediately disappear if we're stepping through it completly.
      -- check for any errors on the step

    if not flow_globals.get_step_error then 
      -- set boundaryEvent Timers on parent, if any
      /*flow_boundary_events.set_boundary_timers 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      );  */
      if not flow_globals.get_step_error then 
        -- Check again, then Update parent subflow to 'in callActivity'
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref -- parent call Activity
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_in_callactivity
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;  
/*         -- map inVariables expressions for call
        flow_expressions.process_expressions
        ( pi_objt_bpmn_id => l_target_objt_sub  
        , pi_set          => flow_constants_pkg.gc_expr_set_on_event
        , pi_prcs_id      => p_process_id
        , pi_sbfl_id      => l_sbfl_context_sub.sbfl_id
        );*/
        -- run on-event expressions for child startEvent
        flow_expressions.process_expressions
        ( pi_objt_bpmn_id => l_called_start_objt_bpmn_id 
        , pi_set          => flow_constants_pkg.gc_expr_set_on_event
        , pi_prcs_id      => p_process_id
        , pi_sbfl_id      => l_called_subflow_context.sbfl_id
        );
        if not flow_globals.get_step_error then 
          -- check again for any errors from expressions before stepping forward in the called activity
          flow_engine.flow_complete_step   
          ( p_process_id    => p_process_id
          , p_subflow_id    => l_called_subflow_context.sbfl_id
          , p_step_key      => l_called_subflow_context.step_key
          );
        end if;
      end if;
    end if;
  end process_callActivity; 

end flow_call_activities;
/
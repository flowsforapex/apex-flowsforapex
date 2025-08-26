create or replace package body flow_instances as
/* 
-- Flows for APEX - flow_instances.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Limited and/or its affiliates, 2025
--
-- Created  25-May-2021  Richard Allen (Flowquest) for  MT AG  - refactor from flow_engine
-- Modified 30-May-2022  Moritz Klein (MT AG)
-- Modified 28-Jan-2025  Richard Allen (Flowquest)
--
*/

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  e_unsupported_start_event exception;

  type t_call_def is record
    ( dgrm_name              flow_diagrams.dgrm_name%type
    , dgrm_version           flow_diagrams.dgrm_version%type
    , dgrm_id                flow_diagrams.dgrm_id%type
    , dgrm_version_selection flow_types_pkg.t_bpmn_attribute_vc2
    );

  function call_is_recursive
    ( p_prcs_id   flow_processes.prcs_id%type
    , p_prdg_id   flow_instance_diagrams.prdg_id%type
    , p_dgrm_id   flow_diagrams.dgrm_id%type  
    ) return boolean
  is
    l_num_recursive_nodes number;
  begin
    -- tests id p_dgrm_id exists in the instance diagram tree above p_prdg_id
    select  count(1)
    into    l_num_recursive_nodes
    from    flow_instance_diagrams
    where   prdg_prcs_id = p_prcs_id
    and     prdg_dgrm_id = p_dgrm_id
    and     level        > 1
    start with prdg_id   = p_prdg_id
    connect by prior prdg_prdg_id = prdg_id
    ;
    return l_num_recursive_nodes > 0;
  end call_is_recursive;

  function diagram_is_callable
    ( p_dgrm_id   flow_diagrams.dgrm_id%type
    ) return boolean
  is
    l_is_callable   flow_types_pkg.t_bpmn_attribute_vc2;
  begin
      select nvl( objt.objt_attributes."apex"."isCallable" ,'false')
        into l_is_callable
        from flow_objects objt
       where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
         and objt.objt_dgrm_id = p_dgrm_id
      ;
      return l_is_callable = 'true';
  end diagram_is_callable;

  procedure find_nested_calls
    ( p_dgrm_id         flow_diagrams.dgrm_id%type
    , p_prcs_id         flow_processes.prcs_id%type
    , p_parent_prdg_id  flow_instance_diagrams.prdg_id%type
    )
  is 
    l_child_dgrm_id                         flow_diagrams.dgrm_id%type;
    l_call_def                              t_call_def;
    l_current_prdg_id                       flow_instance_diagrams.prdg_id%type;
  begin
    for call_activity in (
      select objt.objt_bpmn_id
           , objt.objt_id
           , objt.objt_attributes."apex"."calledDiagram" as dgrm_name
           , objt.objt_attributes."apex"."calledDiagramVersion" as dgrm_version
           , objt.objt_attributes."apex"."calledDiagramVersionSelection" as dgrm_version_selection
        from flow_objects objt
       where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_call_activity
         and objt.objt_dgrm_id = p_dgrm_id
      )
    loop
      l_child_dgrm_id :=
        flow_diagram.get_current_diagram
        ( pi_dgrm_name            => call_activity.dgrm_name
        , pi_dgrm_calling_method  => call_activity.dgrm_version_selection
        , pi_dgrm_version         => call_activity.dgrm_version
        , pi_prcs_id              => p_prcs_id
        );
      -- check diagram is callable
      if  diagram_is_callable (p_dgrm_id => l_child_dgrm_id) then
        -- diagram is callable 
        -- Check for self-reference
        -- If Diagram is calling itself stop processing and error out.
        if l_child_dgrm_id = p_dgrm_id then
          flow_errors.handle_general_error
          ( pi_message_key => 'start-diagram-calls-itself'
          , p0 => p_dgrm_id
          );
          -- $F4AMESSAGE 'start-diagram-calls-itself' || 'You tried to start a diagram %0 that contains a callActivity calling itself.' 
        else
          -- insert an instance_diagram record
          insert into flow_instance_diagrams
          ( prdg_prcs_id
          , prdg_dgrm_id
          , prdg_calling_dgrm
          , prdg_calling_objt
          , prdg_prdg_id
          )
          values 
          ( p_prcs_id
          , l_child_dgrm_id
          , p_dgrm_id
          , call_activity.objt_bpmn_id
          , p_parent_prdg_id
          )
          returning prdg_id into l_current_prdg_id
          ;
          -- check for indirect recursion
          if call_is_recursive  ( p_prcs_id => p_prcs_id
                                , p_dgrm_id => l_child_dgrm_id
                                , p_prdg_id => l_current_prdg_id) 
          then
            flow_errors.handle_general_error
            ( pi_message_key => 'start-diagram-calls-itself'
            , p0 => p_dgrm_id
            );
            -- $F4AMESSAGE 'start-diagram-calls-itself' || 'You tried to start a diagram %0 that contains a callActivity calling itself.'           
          -- find any nested calls in child
          end if;
          find_nested_calls ( p_dgrm_id         => l_child_dgrm_id
                            , p_prcs_id         => p_prcs_id 
                            , p_parent_prdg_id  => l_current_prdg_id
                            );
        end if;
      else
        -- diagram is not callable - raise error
        apex_debug.info
        ( p_message  => 'Building Diagram Call Tree - Diagram %0 (called by diagram %1 is set as not-callable'
        , p0  => l_child_dgrm_id
        , p1  => p_dgrm_id
        );
        flow_errors.handle_general_error
        ( pi_message_key => 'call-diagram-not-callable'
        , p0 => l_child_dgrm_id
        );
        -- $F4AMESSAGE 'call-diagram-not-callable' || 'You tried to call a diagram %0 that is marked as being not callable.'        
      end if;
    end loop; 
  end find_nested_calls;

  procedure create_call_structure
    ( p_prcs_id  in flow_processes.prcs_id%type
    , p_dgrm_id  in flow_diagrams.dgrm_id%type
    )
  is 
    l_parent_prdg_id  flow_instance_diagrams.prdg_id%type;
  begin
    -- put top level diagram into the call structure
    insert into flow_instance_diagrams
      ( prdg_prcs_id
      , prdg_dgrm_id
      , prdg_diagram_level
      )
    values 
      ( p_prcs_id
      , p_dgrm_id
      , 0
      )
    returning prdg_id into l_parent_prdg_id;
    -- find any nested calls 
    find_nested_calls ( p_dgrm_id         => p_dgrm_id
                      , p_prcs_id         => p_prcs_id
                      , p_parent_prdg_id  => l_parent_prdg_id
                      );
  end create_call_structure;

  procedure get_instance_attributes
    ( p_prcs_id                     in  flow_processes.prcs_id%type
    , p_dgrm_id                     in  flow_diagrams.dgrm_id%type
    , p_starting_object             in  flow_objects.objt_bpmn_id%type default null
    , p_requested_logging_level     in  flow_processes.prcs_logging_level%type default null
    , p_calculated_logging_level    out flow_processes.prcs_logging_level%type
    , p_process_bpmn_id             out flow_objects.objt_bpmn_id%type
    )
  is
    l_bpmn_process_objt flow_objects%rowtype;
    l_logging_level     flow_processes.prcs_logging_level%type;
    j_objt_attributes   sys.json_object_t;
    j_apex_attributes   sys.json_object_t;
    j_custom_extensions sys.json_object_t;
  begin
    -- This is used to calculate the instance logging level, taking into account
    --    - the default logging level from the diagram
    --    - the logging level requested from the process create call
    --    - the default logging level set in flow configuration
    -- We'll also use this to set the instance description / subject in a later project.

    -- find the bpmn:process object for the diagram to get logging info 
    l_bpmn_process_objt := flow_diagram.get_bpmn_process_object
                            ( p_dgrm_id               => p_dgrm_id
                            , p_process_id            => p_prcs_id
                            , p_event_starting_object => p_starting_object
                            );
    apex_debug.message (p_message => 'BPMN Process Object : %0', p0 => l_bpmn_process_objt.objt_id);

    if l_bpmn_process_objt.objt_attributes is null then
      l_logging_level := flow_engine_util.get_config_value 
                          ( p_config_key    => flow_constants_pkg.gc_config_logging_default_level 
                          , p_default_value => 0 );
    else
      -- get the logging level from the bpmn process object
      l_logging_level := json_value (l_bpmn_process_objt.objt_attributes, '$.apex.minLoggingLevel' returning number); 
      if l_logging_level is null then
        l_logging_level := flow_engine_util.get_config_value 
                            ( p_config_key    => flow_constants_pkg.gc_config_logging_default_level 
                            , p_default_value => 0 );
      end if;
    end if;
    l_logging_level := greatest ( nvl(p_requested_logging_level,0)
                                , l_logging_level );
    p_calculated_logging_level := l_logging_level;
    p_process_bpmn_id          := l_bpmn_process_objt.objt_bpmn_id;
  end get_instance_attributes;

  procedure set_instance_name
    ( p_prcs_id            in flow_processes.prcs_id%type
    , p_sbfl_id            in flow_subflows.sbfl_id%type
    , p_instance_name_def  in flow_types_pkg.t_bpmn_attribute_vc2
    )
  is
    l_instance_name  varchar2(200) := p_instance_name_def;
  begin
    -- set the instance name
    if l_instance_name is not null then
      flow_proc_vars_int.do_substitution
      ( pi_prcs_id => p_prcs_id
      , pi_sbfl_id => p_sbfl_id
      , pi_scope   => 0
      , pio_string => l_instance_name
      );
      update flow_processes prcs
         set prcs.prcs_name = l_instance_name
       where prcs.prcs_id   = p_prcs_id
       ;
    end if;
  end set_instance_name;


  function create_process
    ( p_dgrm_id         in flow_diagrams.dgrm_id%type
    , p_prcs_name       in flow_processes.prcs_name%type default null
    , p_logging_level   in flow_processes.prcs_logging_level%type default null
    , p_starting_object in flow_objects.objt_bpmn_id%type default null
    , p_auto_commit     in boolean default true
    ) return flow_processes.prcs_id%type
  is
    l_new_prcs_id            flow_processes.prcs_id%type;
    l_calc_logging_level     flow_processes.prcs_logging_level%type;
    l_instance_name          flow_processes.prcs_name%type;
    l_process_objt_bpmn_id   flow_objects.objt_bpmn_id%type;
  begin
    apex_debug.enter
    ('create_process'
    , 'dgrm_id', p_dgrm_id
    , 'p_prcs_name', p_prcs_name 
    , 'p_logging_level', p_logging_level
    , 'p_starting_object', p_starting_object
    );

    if p_prcs_name is not null then
      l_instance_name := p_prcs_name;
    else
      select substr (dgrm.dgrm_name,1,50) || ' - ' || to_char(systimestamp,'DD-MON-YYYY HH24:MI:SS')
        into l_instance_name
        from flow_diagrams dgrm
       where dgrm.dgrm_id = p_dgrm_id;
    end if;

    insert into flow_processes prcs
          ( prcs.prcs_name
          , prcs.prcs_dgrm_id
          , prcs.prcs_status
          , prcs.prcs_init_ts
          , prcs.prcs_last_update
          , prcs.prcs_init_by
          )
    values
          ( l_instance_name
          , p_dgrm_id
          , flow_constants_pkg.gc_prcs_status_created
          , systimestamp
          , systimestamp
          , coalesce  ( sys_context('apex$session','app_user') 
                      , sys_context('userenv','os_user')
                      , sys_context('userenv','session_user')
                      )  
          )
      returning prcs.prcs_id into l_new_prcs_id
    ;
    -- build the call structure for the process instance and any diagram calls 
    create_call_structure ( p_prcs_id => l_new_prcs_id, p_dgrm_id => p_dgrm_id);

    -- get the instance attributes
    get_instance_attributes ( p_prcs_id                   => l_new_prcs_id
                            , p_dgrm_id                   => p_dgrm_id
                            , p_starting_object           => p_starting_object
                            , p_requested_logging_level   => p_logging_level
                            , p_calculated_logging_level  => l_calc_logging_level
                            , p_process_bpmn_id           => l_process_objt_bpmn_id
                            );

    -- update the process with the logging level
    update flow_processes prcs
       set prcs.prcs_logging_level    = l_calc_logging_level
         , prcs.prcs_process_bpmn_id  = l_process_objt_bpmn_id
     where prcs.prcs_id = l_new_prcs_id
       ;

    -- log the process creation
    flow_logging.log_instance_event
    ( p_process_id  => l_new_prcs_id
    , p_event       => flow_constants_pkg.gc_prcs_event_created
    , p_event_level => flow_constants_pkg.gc_logging_level_major_events
    , p_comment     => 'Instance name set to ' || l_instance_name
    );
    
    if p_auto_commit then
      commit;
    end if;

    apex_debug.info
    ( p_message => 'Flow Instance created.  DGRM_ID : %0, PRCS_ID : %1, Logging Level: %2'
    , p0 => p_dgrm_id
    , p1 => l_new_prcs_id 
    , p2 => l_calc_logging_level 
    );

    return l_new_prcs_id;
  end create_process;

  procedure start_process
  ( p_process_id              in flow_processes.prcs_id%type
  , p_event_starting_object   in flow_objects.objt_bpmn_id%type default null -- only for messageStart, etc.
  , p_is_recursive_step       in boolean default false
  )
  is
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_process_status        flow_processes.prcs_status%type;
    l_main_subflow          flow_types_pkg.t_subflow_context;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
    l_priority_json         flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority              flow_processes.prcs_priority%type;
    l_due_on_json           flow_types_pkg.t_bpmn_attribute_vc2;
    l_due_on                flow_processes.prcs_due_on%type;
    l_starting_object       flow_objects%rowtype;
    l_instance_name_def     flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    apex_debug.enter
    ('start_process'
    , 'Process_ID', p_process_id 
    , 'Event Starting Object' , p_event_starting_object
    );
    -- check process exists, is not running, and lock it
    begin

      flow_globals.set_is_recursive_step (p_is_recursive_step => p_is_recursive_step);
      -- initialise step_had_error flag
      flow_globals.set_step_error ( p_has_error => false);

      select prcs.prcs_status
           , prcs.prcs_dgrm_id
        into l_process_status
           , l_dgrm_id
        from flow_processes prcs 
       where prcs.prcs_id = p_process_id
      for update wait 2
      ;
      if l_process_status != 'created' then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-already-running'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-already-running' || 'You tried to start a process (id %0) that is already running.'
      end if;
      
    exception
      when no_data_found then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-not-created'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-not-created' || 'You tried to start a process (id %0) that does not exist.' 
      when too_many_rows then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-multiple-already-running'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-multiple-already-running' || 'You tried to start a process (id %0) with multiple copies already running.' 
    end;

    if not flow_globals.get_step_error then
      -- get the starting object
      l_starting_object := flow_diagram.get_start_event ( p_dgrm_id               => l_dgrm_id
                                                        , p_process_id            => p_process_id
                                                        , p_event_starting_object => p_event_starting_object);

    begin
      -- get instance scheduling information for the process being started
      select objt.objt_attributes."apex"."priority"
           , objt.objt_attributes."apex"."dueOn"
           , objt.objt_attributes."apex"."instanceName"  
        into l_priority_json
           , l_due_on_json
           , l_instance_name_def 
        from flow_objects objt
       where objt.objt_dgrm_id  = l_dgrm_id
         and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
         and objt.objt_id       = l_starting_object.objt_objt_id
      ;
      if l_priority_json is not null then
        l_priority := flow_settings.get_priority ( pi_prcs_id => p_process_id, pi_expr => l_priority_json);
      end if;
      if l_due_on_json is not null then 
        l_due_on   := flow_settings.get_due_on (pi_prcs_id => p_process_id, pi_expr => l_due_on_json);
      end if;
      apex_debug.info (p_message => 'Process Priority : %0  Due On : %1', p0 => l_priority, p1 => l_due_on );
    end;

      if not flow_globals.get_step_error then
        -- mark process as running
        update flow_processes prcs
           set prcs.prcs_status         = flow_constants_pkg.gc_prcs_status_running
             , prcs.prcs_start_ts       = systimestamp
             , prcs.prcs_last_update    = systimestamp
             , prcs.prcs_last_update_by =  coalesce  ( sys_context('apex$session','app_user') 
                                                     , sys_context('userenv','os_user')
                                                     , sys_context('userenv','session_user')
                                                     )  
             , prcs.prcs_priority       = l_priority
             , prcs.prcs_due_on         = l_due_on
         where prcs.prcs_dgrm_id   = l_dgrm_id
           and prcs.prcs_id        = p_process_id
             ;    
        -- log the start
        flow_logging.log_instance_event
        ( p_process_id  => p_process_id
        , p_event       => flow_constants_pkg.gc_prcs_event_started
        , p_event_level => flow_constants_pkg.gc_logging_level_major_events
        );
        -- create the status for new subflow based on start subtype
        case
          when l_starting_object.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then
            l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_waiting_timer;
          when (   l_starting_object.objt_sub_tag_name is null 
               or  l_starting_object.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_message_event_definition ) then
            l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_running;
          else
            raise e_unsupported_start_event;
        end case;

        if not flow_globals.get_step_error then
          -- create the main subflow

          l_main_subflow := flow_engine_util.subflow_start 
            ( p_process_id => p_process_id
            , p_parent_subflow => null
            , p_starting_object => l_starting_object.objt_bpmn_id
            , p_current_object  => l_starting_object.objt_bpmn_id
            , p_route => 'main'
            , p_last_completed => null
            , p_status => l_new_subflow_status 
            , p_parent_sbfl_proc_level => 0 
            , p_new_proc_level => false
            , p_dgrm_id => l_dgrm_id
            );

          apex_debug.info
          ( p_message => 'Initial Subflow created %0 with Step Key %1'
          , p0 => l_main_subflow.sbfl_id
          , p1 => l_main_subflow.step_key
          );
          if l_starting_object.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then 
            -- process any before-event variable expressions on the starting object
            flow_expressions.process_expressions
            ( pi_objt_bpmn_id   => l_starting_object.objt_bpmn_id
            , pi_set            => flow_constants_pkg.gc_expr_set_before_event
            , pi_prcs_id        => p_process_id
            , pi_sbfl_id        => l_main_subflow.sbfl_id
            , pi_step_key       => l_main_subflow.step_key
            , pi_var_scope      => l_main_subflow.scope
            , pi_expr_scope     => l_main_subflow.scope
            );
            -- test for any step errors
            if not flow_globals.get_step_error then 

              -- set the instance name if defined
              if l_instance_name_def is not null then
                set_instance_name
                ( p_prcs_id => p_process_id
                , p_sbfl_id => l_main_subflow.sbfl_id
                , p_instance_name_def => l_instance_name_def
                );
              end if;

              if not flow_globals.get_step_error then
    
                -- start the timer
                flow_timers_pkg.start_timer
                (
                  pi_prcs_id    => p_process_id
                , pi_sbfl_id    => l_main_subflow.sbfl_id
                , pi_step_key   => l_main_subflow.step_key
                , pi_callback   => flow_constants_pkg.gc_bpmn_start_event
                ); 
              else
                -- set error status on instance and subflow
                flow_errors.set_error_status
                ( pi_prcs_id => p_process_id
                , pi_sbfl_id => l_main_subflow.sbfl_id
                );

              end if;
            end if;       

          elsif (  l_starting_object.objt_sub_tag_name is null 
                or l_starting_object.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_message_event_definition ) then
            -- plain (none) startEvent or messageStartEvent
            -- process any variable expressions on the starting object
            flow_expressions.process_expressions
            ( pi_objt_bpmn_id  => l_starting_object.objt_bpmn_id
            , pi_set           => flow_constants_pkg.gc_expr_set_on_event
            , pi_prcs_id       => p_process_id
            , pi_sbfl_id       => l_main_subflow.sbfl_id
            , pi_step_key      => l_main_subflow.step_key
            , pi_var_scope     => l_main_subflow.scope
            , pi_expr_scope    => l_main_subflow.scope      
            );

            if not flow_globals.get_step_error then 

              -- set the instance name if defined
              if l_instance_name_def is not null then
                set_instance_name
                ( p_prcs_id => p_process_id
                , p_sbfl_id => l_main_subflow.sbfl_id
                , p_instance_name_def => l_instance_name_def
                );
              end if;

              if not flow_globals.get_step_error then 
                -- step into first step
                flow_engine.flow_complete_step  
                ( p_process_id => p_process_id
                , p_subflow_id => l_main_subflow.sbfl_id
                , p_step_key   => l_main_subflow.step_key
                , p_forward_route => null
                , p_recursive_call => false
                );
              else 
                -- set error status on instance and subflow
                flow_errors.set_error_status
                ( pi_prcs_id => p_process_id
                , pi_sbfl_id => l_main_subflow.sbfl_id
                );
              end if;
            end if; -- not step error processing expressions
          else 
            raise e_unsupported_start_event;
          end if;
        else
          -- set error status on instance and subflow
          flow_errors.set_error_status
          ( pi_prcs_id => p_process_id
          , pi_sbfl_id => l_main_subflow.sbfl_id
          );
        end if; -- not step error creating main subflow
      end if; -- not step error finding start object and setting priority and due on
    end if; -- not step error finding a created process

  exception
    when e_unsupported_start_event then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => l_main_subflow.sbfl_id
      , pi_message_key    => 'start-type-unsupported'
      , p0                => l_starting_object.objt_sub_tag_name       
      );
      -- $F4AMESSAGE 'start-type-unsupported' || 'Unsupported start event type (%0). Only None (standard) Start Event, Message and Timer Start Event are currently supported.'
  end start_process;

  procedure reset_process
    ( p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code   number;
  begin
    apex_debug.enter
    ( 'reset_process'
    , 'process_id', p_process_id
    );
    -- lock all objects
    begin
      flow_engine_util.lock_all_for_process (p_process_id => p_process_id);
    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;

    -- kill any timers still running in the process
    flow_timers_pkg.terminate_process_timers
    ( pi_prcs_id => p_process_id
    , po_return_code => l_return_code
    );  
    -- cancel any message subscriptions
    flow_message_util.cancel_instance_subscriptions
    ( p_process_id => p_process_id
    );
    -- cancel any apex human tasks
    flow_usertask_pkg.cancel_all_apex_tasks ( p_process_id => p_process_id );
    -- clear out run-time object_log
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    -- clean up iteration arrays
    delete
      from flow_iterated_objects
     where iobj_prcs_id = p_process_id
     ;
    -- delete the subflows
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    -- delete all process variables except the builtins (new behaviour in 21.1)
    flow_proc_vars_int.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => true
    );
    -- reset the instance diagrams / call structure
    update flow_instance_diagrams prdg
    set prdg.prdg_diagram_level = null
    where prdg.prdg_prcs_id = p_process_id
      and prdg.prdg_diagram_level != 0
    ;
    -- reset the process status to 'created'
    update flow_processes prcs
       set prcs.prcs_status         = flow_constants_pkg.gc_prcs_status_created
         , prcs_start_ts            = null
         , prcs_complete_ts         = null
         , prcs_archived_ts         = null
         , prcs.prcs_last_update    = systimestamp
         , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
     where prcs.prcs_id = p_process_id
    ;
    -- log the reset
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_reset
    , p_event_level => flow_constants_pkg.gc_logging_level_abnormal_events
    , p_comment    => p_comment
    );
    commit;
  end reset_process;


  procedure suspend_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    e_feature_requires_ee              exception;
    e_prcs_not_suspendable             exception;
    l_status                           flow_processes.prcs_status%type;
  begin
    $IF flow_apex_env.ee $THEN
      -- check current process state in running or errored
      select prcs_status
        into l_status
        from flow_processes
       where prcs_id = p_process_id;

      if l_status not in ( flow_constants_pkg.gc_prcs_status_running 
                         , flow_constants_pkg.gc_prcs_status_error) then 
        raise e_prcs_not_suspendable;
      end if;

      -- lock process, subflows, subflog log, subscriptions, prdg
      flow_engine_util.lock_all_for_process (p_process_id => p_process_id);
      flow_instances_util_ee.suspend_process (p_process_id => p_process_id);

    $ELSE
      raise e_feature_requires_ee;
    $END
    -- if process status in (running, error)
  exception
    when e_feature_requires_ee then
      -- feature not supported without Enterprise Edition licence
      flow_errors.handle_instance_error
      ( pi_prcs_id      => p_process_id
      , pi_message_key  => 'feature-requires-ee'
      );
      -- F4A$MESSAGE 'feature-requires-ee' || 'Processing this feature requires licensing Flows for APEX Enterprise Edition.'
      raise;
    when e_prcs_not_suspendable then
      -- only running or errored process can be suspended
      flow_errors.handle_instance_error
      ( pi_prcs_id      => p_process_id
      , pi_message_key  => 'suspend-invalid-status'
      );
      -- F4A$MESSAGE 'suspend-invalid-status' || 'Only process instances currently in running or error status can be suspended.'
      raise;
  end suspend_process;

  procedure resume_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    e_feature_requires_ee              exception;
    e_prcs_not_suspended               exception;
    l_status                           flow_processes.prcs_status%type;
  begin
    $IF flow_apex_env.ee $THEN
      -- check current process state is suspended
      select prcs_status
        into l_status
        from flow_processes
       where prcs_id = p_process_id;

      if l_status != flow_constants_pkg.gc_prcs_status_suspended then 
        raise e_prcs_not_suspended;
      end if;

      -- lock process, subflows, subflog log, subscriptions, prdg
      flow_engine_util.lock_all_for_process (p_process_id => p_process_id);
      flow_instances_util_ee.resume_process (p_process_id => p_process_id);

    $ELSE
      raise e_feature_requires_ee;
    $END
    -- if process status in (running, error)
  exception
    when e_feature_requires_ee then
      -- feature not supported without Enterprise Edition licence
      flow_errors.handle_instance_error
      ( pi_prcs_id      => p_process_id
      , pi_message_key  => 'feature-requires-ee'
      );
      -- F4A$MESSAGE 'feature-requires-ee' || 'Processing this feature requires licensing Flows for APEX Enterprise Edition.'
      raise;
    when e_prcs_not_suspended then
      -- only suspended process can be resumed
      flow_errors.handle_instance_error
      ( pi_prcs_id      => p_process_id
      , pi_message_key  => 'resume-invalid-status'
      );
      -- F4A$MESSAGE 'resume-invalid-status' || 'Only process instances currently in suspended status can be resumed.'
      raise;
  end resume_process;

  procedure reset_process_to_running
  (
    p_subflow_rec  in flow_subflows%rowtype 
  , p_comment      in flow_instance_event_log.lgpr_comment%type default null
  ) 
  is
    l_num_error_subflows  number;
  begin
    -- tries to reset the process instance to running after subflow errors are cleared
    -- used on - subflow restart step, force next step, and resume process
    -- assumes the flow_processes record is already locked
    apex_debug.enter
    ( 'reset_process_to_running'
    , 'process_id', p_subflow_rec.sbfl_prcs_id
    , 'subflow_id', p_subflow_rec.sbfl_id
    );
    -- see if instance can be reset to running
    select count(sbfl_id)
      into l_num_error_subflows
      from flow_subflows sbfl 
     where sbfl.sbfl_prcs_id = p_subflow_rec.sbfl_prcs_id
       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_error 
    ;
    if l_num_error_subflows = 0 then
      update flow_processes prcs
         set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
           , prcs.prcs_was_altered = 'Y'
           , prcs.prcs_last_update = systimestamp
           , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
       where prcs.prcs_id = p_subflow_rec.sbfl_prcs_id
      ;
      flow_logging.log_instance_event
      ( p_process_id    => p_subflow_rec.sbfl_prcs_id
      , p_objt_bpmn_id  => p_subflow_rec.sbfl_current
      , p_event         => flow_constants_pkg.gc_prcs_status_running
      , p_event_level   => flow_constants_pkg.gc_logging_level_abnormal_events
      );
    else
      -- mark instance as altered anyhow
      flow_instances.set_was_altered (p_process_id => p_subflow_rec.sbfl_prcs_id);
    end if;
  end reset_process_to_running;

  procedure terminate_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code   number;
    cursor c_lock_all is 
      select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id 
        join flow_subflow_log sflg 
          on prcs.prcs_id = sflg.sflg_prcs_id
       where prcs.prcs_id = p_process_id
       order by sbfl.sbfl_process_level, sbfl.sbfl_id
         for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated wait 2;
  begin
    apex_debug.enter
    ( 'terminate_process'
    , 'process_id', p_process_id
    );
    begin 
      -- lock all timers, logs, subflows and the process.  
      open c_lock_all;
      flow_message_util.lock_instance_subscriptions ( p_process_id => p_process_id );
      flow_timers_pkg.lock_process_timers ( pi_prcs_id => p_process_id ); 
      close c_lock_all; 
    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;

    -- kill any message subscriptions or timers sill running in the process
    flow_message_util.cancel_instance_subscriptions ( p_process_id => p_process_id );
    flow_timers_pkg.delete_process_timers
    (
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    -- cancel any apex human tasks
    flow_usertask_pkg.cancel_all_apex_tasks ( p_process_id => p_process_id );
    -- stop processing 
    flow_engine_util.terminate_level
    ( p_process_id => p_process_id
    , p_process_level => 0
    );
    apex_debug.info
    ( p_message => 'Flow Instance %0 terminated'
    , p0        => p_process_id
    );
    -- mark process as terminated
    update flow_processes prcs
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_terminated
         , prcs.prcs_last_update = systimestamp
         , prcs.prcs_complete_ts = systimestamp
         , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
     where prcs.prcs_id = p_process_id
    ; 
    -- log termination
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_terminated
    , p_event_level => flow_constants_pkg.gc_logging_level_abnormal_events
    , p_comment    => p_comment
    );
    -- finalize
    commit;
  end terminate_process;

  procedure delete_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code             number;
    l_is_not_archived         boolean := false;
    l_cur_prcs_id             flow_processes.prcs_id%type;
    l_cur_sbfl_id             flow_subflows.sbfl_id%type;
    l_cur_sflg_updated        flow_subflow_log.sflg_last_updated%type;
    l_cur_prdg_id             flow_instance_diagrams.prdg_id%type;
    l_cur_prcs_archived_ts    flow_processes.prcs_archived_ts%type;
    cursor c_lock_all is 
      select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id, prcs.prcs_archived_ts
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id 
        join flow_subflow_log sflg 
          on prcs.prcs_id = sflg.sflg_prcs_id
        join flow_instance_diagrams prdg
          on prcs.prcs_id = prdg.prdg_prcs_id
       where prcs.prcs_id = p_process_id
       order by sbfl.sbfl_process_level, sbfl.sbfl_id
         for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id wait 2;
  begin
    apex_debug.enter
    ( 'delete_process'
    , 'process_id', p_process_id
    );
    begin 
      -- lock all timers, logs, subflows, instance diagrams and the process
      open c_lock_all;
      fetch c_lock_all into l_cur_prcs_id
                          , l_cur_sbfl_id
                          , l_cur_sflg_updated
                          , l_cur_prdg_id
                          , l_cur_prcs_archived_ts;
      flow_message_util.lock_instance_subscriptions (p_process_id => p_process_id);
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      ); 
      if l_cur_prcs_archived_ts is null then
        l_is_not_archived := true;
      end if;
      close c_lock_all; 

    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;
    -- log the deletion before process data deleted
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_deleted
    , p_event_level => flow_constants_pkg.gc_logging_level_major_events
    , p_comment    => p_comment
    );
    -- kill any message subscriptions or  timers still running in the instance
    flow_message_util.cancel_instance_subscriptions (p_process_id => p_process_id);
    flow_timers_pkg.delete_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    -- cancel any apex human tasks
    flow_usertask_pkg.cancel_all_apex_tasks ( p_process_id => p_process_id );
    -- if instance archiving is enabled and instance is not yet archived, run instance archive now before
    -- process data is deleted from run time tables to ensure arcchive is full audit trail
    if l_is_not_archived then
      if flow_engine_util.get_config_value ( p_config_key => flow_constants_pkg.gc_config_logging_archive_enabled 
                                           , p_default_value => flow_constants_pkg.gc_config_default_logging_archive_enabled
                                           ) = 'true' 
      then
        flow_log_admin.archive_completed_instances (p_process_id => p_process_id);
      end if;
    end if;
    -- clear out run-time object_log
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    -- clear out any iterations
    delete
      from flow_iterated_objects
     where iobj_prcs_id = p_process_id
     ;
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    flow_proc_vars_int.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => false
    );
    delete 
      from flow_instance_diagrams prdg
     where prdg_prcs_id = p_process_id
    ;
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;

    commit;
  end delete_process;

  procedure set_priority
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_priority    in flow_processes.prcs_priority%type
    )
  is
  begin
      update flow_processes prcs
      set prcs.prcs_priority = p_priority
        , prcs.prcs_last_update = systimestamp
        , prcs.prcs_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                              , sys_context('userenv','os_user')
                                              , sys_context('userenv','session_user')
                                              )  
      where prcs.prcs_id = p_process_id;
      -- log the priority change
      flow_logging.log_instance_event
      ( p_process_id  => p_process_id
      , p_event       => flow_constants_pkg.gc_prcs_event_priority_set
      , p_event_level => flow_constants_pkg.gc_logging_level_major_events
      , p_comment     => 'Process priority set to '||p_priority
      );      
  end set_priority;

  function priority
    ( p_process_id  in flow_processes.prcs_id%type
    ) return flow_processes.prcs_priority%type
  is
      l_priority    flow_processes.prcs_priority%type;
  begin
      select prcs_priority
        into l_priority
        from flow_processes
       where prcs_id = p_process_id;
      return l_priority;
  end priority;

  procedure set_due_on
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_due_on      in flow_processes.prcs_due_on%type
    )
  is
  begin
      update flow_processes prcs
      set prcs.prcs_due_on = p_due_on
        , prcs.prcs_last_update = systimestamp
        , prcs.prcs_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                              , sys_context('userenv','os_user')
                                              , sys_context('userenv','session_user')
                                              )  
      where prcs.prcs_id = p_process_id;
      -- log the priority change
      flow_logging.log_instance_event
      ( p_process_id  => p_process_id
      , p_event       => flow_constants_pkg.gc_prcs_event_due_on_set
      , p_event_level => flow_constants_pkg.gc_logging_level_major_events
      , p_comment     => 'Instance Due On set to '||to_char(p_due_on, flow_constants_pkg.gc_prov_default_tstz_format)
      );  
  end set_due_on;

  function due_on
    ( p_process_id  in flow_processes.prcs_id%type
    ) return flow_processes.prcs_due_on%type
  is
      l_due_on    flow_processes.prcs_due_on%type;
  begin
      select prcs_due_on
        into l_due_on
        from flow_processes
       where prcs_id = p_process_id;
      return l_due_on;
  end due_on;

  function status
    ( p_process_id  in flow_processes.prcs_id%type
    ) return flow_processes.prcs_status%type
  is
      l_status    flow_processes.prcs_status%type;
  begin
      select prcs_status
        into l_status
        from flow_processes
       where prcs_id = p_process_id;
      return l_status;
  end status;

  procedure set_was_altered
    (
      p_process_id  in flow_processes.prcs_id%type
    )
  is
  begin 
      update flow_processes prcs
      set prcs.prcs_was_altered = 'Y'
        , prcs.prcs_last_update = systimestamp
        , prcs.prcs_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                              , sys_context('userenv','os_user')
                                              , sys_context('userenv','session_user')
                                              )  
      where prcs.prcs_id = p_process_id;
  end set_was_altered;

end flow_instances;
/

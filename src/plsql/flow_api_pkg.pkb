create or replace package body flow_api_pkg as
/* 
-- Flows for APEX - flow_api_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG. 2020-22
-- (c) Flowquest Limited and / or its affiliates, 2025.
--
-- Created    20-Jun-2020   Moritz Klein, MT AG 
-- Modified   01-May-2022   Richard Allen, Oracle
-- Modified   02-Mar-2025   Richard Allen, Flowquest
-- 
*/

  e_lock_timeout exception;
  pragma exception_init (e_lock_timeout, -3006);

  function get_dgrm_name
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2
  is
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin

    select dgrm.dgrm_name
      into l_dgrm_name
      from flow_processes prcs
      join flow_diagrams dgrm
        on dgrm.dgrm_id = prcs.prcs_dgrm_id
     where prcs.prcs_id = p_prcs_id
    ;
         
    return l_dgrm_name;
  end get_dgrm_name;

  function flow_create
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type default null
  , pi_prcs_name in flow_processes.prcs_name%type default null
  , pi_logging_level in flow_processes.prcs_logging_level%type default null
  ) return flow_processes.prcs_id%type
  as
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_dgrm_version    flow_diagrams.dgrm_version%type;
    l_calling_method  flow_types_pkg.t_bpmn_attribute_vc2;
  begin
  
    if pi_dgrm_version is null then
      -- this is the former way of calling the latest release
      l_calling_method := flow_constants_pkg.gc_dgrm_version_latest_version;
    else
      -- dgrm_version was specified - use 'namedVersion' call...                                                      
      l_calling_method := flow_constants_pkg.gc_dgrm_version_named_version;
    end if;

    -- get the released diagram or 'draft' version '0' diagram (or error...)
    l_dgrm_id := flow_diagram.get_current_diagram ( pi_dgrm_name            => pi_dgrm_name 
                                                  , pi_dgrm_calling_method  => l_calling_method
                                                  , pi_dgrm_version         => pi_dgrm_version
                                                  );

    -- TODO - Get the Logging level from the diagram, then start the process with the greatest logging level

    return  flow_instances.create_process
            ( p_dgrm_id       => l_dgrm_id
            , p_prcs_name     => pi_prcs_name
            , p_logging_level => pi_logging_level
            );
  end flow_create;

  function flow_create
  (
    pi_dgrm_id       in flow_diagrams.dgrm_id%type
  , pi_prcs_name     in flow_processes.prcs_name%type default null
  , pi_logging_level in flow_processes.prcs_logging_level%type default null
  ) return flow_processes.prcs_id%type
  is
    l_ret flow_processes.prcs_id%type;
  begin
    return flow_instances.create_process
           ( p_dgrm_id => pi_dgrm_id
           , p_prcs_name => pi_prcs_name
           , p_logging_level => pi_logging_level
           )
    ;
  end flow_create;

  procedure flow_create
  (
    pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type default null
  , pi_prcs_name     in flow_processes.prcs_name%type default null
  , pi_logging_level in flow_processes.prcs_logging_level%type default null
  )
  as
    l_prcs_id flow_processes.prcs_id%type;
  begin
    l_prcs_id :=
      flow_create
      (
        pi_dgrm_name     => pi_dgrm_name
      , pi_dgrm_version  => pi_dgrm_version
      , pi_prcs_name     => pi_prcs_name
      , pi_logging_level => pi_logging_level
      );
  end flow_create;

  procedure flow_create
  (
    pi_dgrm_id       in flow_diagrams.dgrm_id%type
  , pi_prcs_name     in flow_processes.prcs_name%type default null
  , pi_logging_level in flow_processes.prcs_logging_level%type default null
  )
  as
    l_prcs_id flow_processes.prcs_id%type;
  begin
    l_prcs_id :=
      flow_instances.create_process
      (
        p_dgrm_id       => pi_dgrm_id
      , p_prcs_name     => pi_prcs_name
      , p_logging_level => pi_logging_level
      );
  end flow_create;

  procedure flow_start
    ( p_process_id in flow_processes.prcs_id%type
    )
    is
      l_session_id   number;
    begin  
        if v('APP_SESSION') is null then
          l_session_id := flow_apex_session.create_api_session (p_process_id => p_process_id);
        end if;

        apex_debug.message(p_message => 'Begin flow_start', p_level => 3) ;

        flow_globals.set_context
        ( pi_prcs_id => p_process_id
        , pi_scope   => 0   -- initial scope is always 0
        );
  
        flow_instances.start_process 
        ( p_process_id => p_process_id
        );

        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
    exception
      when others then
        if l_session_id is not null then
          flow_apex_session.delete_session (p_session_id => l_session_id );
        end if;
        raise;
  end flow_start;

  procedure flow_set_priority 
  ( p_process_id in flow_processes.prcs_id%type
  , p_priority   in flow_processes.prcs_priority%type 
  )
  is
  begin
    flow_instances.set_priority ( p_process_id  => p_process_id
                                , p_priority    => p_priority
                                );
  end flow_set_priority;

  procedure flow_set_due_on
  ( p_process_id in flow_processes.prcs_id%type
  , p_due_on     in flow_processes.prcs_due_on%type 
  )
  is
  begin
    flow_instances.set_due_on ( p_process_id  => p_process_id
                              , p_due_on      => p_due_on
                                );
  end flow_set_due_on;

  procedure flow_reserve_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_reservation   in flow_subflows.sbfl_reservation%type
  )
  is 
  begin

    flow_reservations.reserve_step
    ( p_process_id  => p_process_id
    , p_subflow_id  => p_subflow_id
    , p_reservation => p_reservation
    , p_step_key    => p_step_key
    );
  end flow_reserve_step;

  procedure flow_release_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  )
  is 
  begin

    flow_reservations.release_step
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_step_key   => p_step_key
    );
  end flow_release_step;

  procedure flow_start_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  )
  is 
  begin
    flow_engine.start_step
    ( p_process_id  => p_process_id
    , p_subflow_id  => p_subflow_id
    , p_step_key    => p_step_key
    );
  end flow_start_step;

    procedure flow_pause_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  )
  is 
  begin
    flow_engine.pause_step
    ( p_process_id  => p_process_id
    , p_subflow_id  => p_subflow_id
    , p_step_key    => p_step_key
    );
  end flow_pause_step;

  procedure flow_restart_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is 
    l_session_id   number;
  begin 
    -- create an APEX session if this has come in from outside APEX
    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_subflow_id => p_subflow_id);
    end if;

    flow_globals.set_context
    ( pi_prcs_id      => p_process_id
    , pi_sbfl_id      => p_subflow_id
    , pi_step_key     => p_step_key
    , pi_scope        => flow_engine_util.get_scope (p_process_id => p_process_id, p_subflow_id => p_subflow_id)
    , pi_loop_counter => flow_engine_util.get_loop_counter (pi_sbfl_id => p_subflow_id)
    );
    flow_engine.restart_step
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_step_key   => p_step_key
    , p_comment    => p_comment
    );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
    when others then
      if l_session_id is not null then
        flow_apex_session.delete_session (p_session_id => l_session_id );
      end if;
      raise;
  end flow_restart_step;


  procedure flow_complete_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  )
  is 
      l_session_id   number;
  begin
    -- create an APEX session if this has come in from outside APEX
    if v('APP_SESSION') is null then
      l_session_id := flow_apex_session.create_api_session (p_subflow_id => p_subflow_id);
    end if; 

    flow_globals.set_context
    ( pi_prcs_id  => p_process_id
    , pi_sbfl_id  => p_subflow_id
    , pi_step_key => p_step_key
    , pi_scope    => flow_engine_util.get_scope (p_process_id => p_process_id, p_subflow_id => p_subflow_id)
    );
    flow_engine.flow_complete_step
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_step_key   => p_step_key
    , p_recursive_call => false
    );

    if l_session_id is not null then
      flow_apex_session.delete_session (p_session_id => l_session_id );
    end if;
  exception
    when others then
      if l_session_id is not null then
        flow_apex_session.delete_session (p_session_id => l_session_id );
      end if;
      raise;
  end flow_complete_step;

  procedure flow_reschedule_timer
  (
      p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_step_key      in flow_subflows.sbfl_step_key%type default null
    , p_is_immediate  in boolean default false
    , p_new_timestamp in flow_timers.timr_start_on%type default null
    , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  )
  is
  begin
    flow_timers_pkg.reschedule_timer
    ( 
      p_process_id    => p_process_id
    , p_subflow_id    => p_subflow_id
    , p_step_key      => p_step_key 
    , p_is_immediate  => p_is_immediate
    , p_new_timestamp => p_new_timestamp
    , p_comment       => p_comment
    );
  end flow_reschedule_timer;

  procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
  begin
    apex_debug.enter 
    ( p_routine_name => 'flow_reset'
    );
    flow_instances.reset_process 
    ( p_process_id  => p_process_id
    , p_comment     => p_comment
    );
  end flow_reset;

  procedure flow_terminate
  ( p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
  begin
    apex_debug.enter 
    ( p_routine_name => 'flow_terminate'
    );
    flow_instances.terminate_process 
    ( p_process_id => p_process_id
    , p_comment    => p_comment
    );
  end flow_terminate;

  procedure flow_delete
  ( p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  )
  is
  begin
    apex_debug.enter
    (p_routine_name => 'flow_delete'
    );
    flow_instances.delete_process 
    ( p_process_id => p_process_id
    , p_comment    => p_comment
    );
  end flow_delete;

  function get_current_usertask_url
  (
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_step_key   in flow_subflows.sbfl_step_key%type default null
  , p_scope      in flow_subflows.sbfl_scope%type default 0
  ) return varchar2
  as
    l_objt_id flow_objects.objt_id%type;
  begin
    apex_debug.trace ( p_message => 'Entering GET_CURRENT_USERTASK_URL' );

    select objt.objt_id
      into l_objt_id
      from flow_subflows sbfl
      join flow_processes prcs
        on prcs.prcs_id = sbfl.sbfl_prcs_id
      join flow_objects objt
        on objt.objt_dgrm_id = prcs.prcs_dgrm_id
       and objt.objt_bpmn_id = sbfl.sbfl_current
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
       and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_usertask
    ;

    apex_debug.trace( p_message => 'Found OBJT_ID %s', p0 => l_objt_id );

    return 
      flow_usertask_pkg.get_url
      (
        pi_prcs_id  => p_process_id
      , pi_sbfl_id  => p_subflow_id
      , pi_step_key => p_step_key
      , pi_objt_id  => l_objt_id
      , pi_scope    => p_scope
      );
  end get_current_usertask_url;

  function message
  ( p_message_key    in varchar2
  , p_lang            in varchar2 default 'en'
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  ) return varchar2
  is
  begin
    return flow_errors.make_error_message
           ( pi_message_key => p_message_key
           , pi_lang        => p_lang
           , p0   => p0
           , p1   => p1
           , p2   => p2
           , p3   => p3
           , p4   => p4
           , p5   => p5
           , p6   => p6
           , p7   => p7
           , p8   => p8
           , p9   => p9
           );

  end message;

  function get_tasks 
  ( p_context      in varchar2
  , p_prcs_id      in flow_processes.prcs_id%type
  , p_user         in varchar2 default null 
  , p_groups       in varchar2 default null
  )
  return sys_refcursor
  is
    l_cur     sys_refcursor;
    l_user    varchar2(250);
  begin 
    l_user := coalesce( p_user, SYS_CONTEXT('APEX$SESSION','APP_USER') ); 

    case p_context
    when flow_constants_pkg.gc_task_list_context_my_tasks then
      
        open l_cur for
        select curr_objt.objt_name
             , curr_objt.objt_tag_name
             , curr_objt.objt_id
             , sbfl.sbfl_current
             , prcs.prcs_name
             , bref.prov_var_vc2
             , dgrm.dgrm_name
             , sbfl.sbfl_due_on
             , round((cast(sbfl.sbfl_due_on as date) - sysdate) * 24, 1) 
             , sbfl.sbfl_priority
             , prcs.prcs_init_by
             , sbfl.sbfl_reservation
             , sbfl.sbfl_status
             , sbfl.sbfl_became_current
             , sbfl.sbfl_last_update_by
             , sbfl.sbfl_last_update
             , prcs.prcs_id
             , sbfl.sbfl_id
             , sbfl.sbfl_step_key
             , sbfl.sbfl_scope
             , sbfl.sbfl_potential_users
             , sbfl.sbfl_potential_groups
             , sbfl.sbfl_excluded_users
             , sbfl.sbfl_lane_name
             , sbfl.sbfl_lane_role
          from flow_subflows sbfl
          join flow_processes prcs
            on prcs.prcs_id = sbfl.sbfl_prcs_id
     left join flow_objects curr_objt
            on curr_objt.objt_bpmn_id = sbfl.sbfl_current
           and curr_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
          join flow_diagrams dgrm 
            on dgrm.dgrm_id = prcs.prcs_dgrm_id
     left join flow_process_variables bref
            on bref.prov_prcs_id = sbfl.sbfl_prcs_id
           and bref.prov_var_name = 'BUSINESS_REF'
           and bref.prov_scope = 0
         where curr_objt.objt_tag_name = 'bpmn:userTask' 
           and sbfl.sbfl_status = 'running'
           and (instr ( sbfl.sbfl_excluded_users, l_user) = 0
               or sbfl.sbfl_excluded_users is null)
           and ( sbfl.sbfl_reservation = l_user
               OR   sbfl.sbfl_reservation is null );

    when flow_constants_pkg.gc_task_list_context_single then
        open l_cur for
        select curr_objt.objt_name
             , curr_objt.objt_tag_name
             , curr_objt.objt_id
             , sbfl.sbfl_current
             , prcs.prcs_name
             , bref.prov_var_vc2
             , dgrm.dgrm_name
             , sbfl.sbfl_due_on
             , round((cast(sbfl.sbfl_due_on as date) - sysdate) * 24, 1) 
             , sbfl.sbfl_priority
             , prcs.prcs_init_by
             , sbfl.sbfl_reservation
             , sbfl.sbfl_status
             , sbfl.sbfl_became_current
             , sbfl.sbfl_last_update_by
             , sbfl.sbfl_last_update
             , prcs.prcs_id
             , sbfl.sbfl_id
             , sbfl.sbfl_step_key
             , sbfl.sbfl_scope
             , sbfl.sbfl_potential_users
             , sbfl.sbfl_potential_groups
             , sbfl.sbfl_excluded_users
             , sbfl.sbfl_lane_name
             , sbfl.sbfl_lane_role
          from flow_subflows sbfl
          join flow_processes prcs
            on prcs.prcs_id = sbfl.sbfl_prcs_id
     left join flow_objects curr_objt
            on curr_objt.objt_bpmn_id = sbfl.sbfl_current
           and curr_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
          join flow_diagrams dgrm 
            on dgrm.dgrm_id = prcs.prcs_dgrm_id
     left join flow_process_variables bref
            on bref.prov_prcs_id = sbfl.sbfl_prcs_id
           and bref.prov_var_name = 'BUSINESS_REF'
           and bref.prov_scope = 0
         where curr_objt.objt_tag_name = 'bpmn:userTask' 
           and sbfl.sbfl_status in ( flow_constants_pkg.gc_sbfl_status_running
                                   , flow_constants_pkg.gc_sbfl_status_waiting_approval)
           and prcs.prcs_id = p_prcs_id;
    end case;

    return l_cur;
  end get_tasks;


  function get_current_tasks
  ( p_context    in varchar2 default flow_constants_pkg.gc_task_list_context_my_tasks
  , p_prcs_id    in flow_processes.prcs_id%type default null
  , p_user       in varchar2 default null
  , p_groups     in varchar2 default null
  ) return t_task_list_items pipelined 
  is
    type t_sbfl_row is record 
      ( curr_objt_name        varchar2( 200 char)
      , curr_objt_tag_name    varchar2(  50 char)
      , curr_objt_id          number
      , sbfl_current          varchar2(  50 char)
      , prcs_name             varchar2( 150 char)
      , prcs_business_ref     varchar2(4000 char)
      , prcs_dgrm_name        varchar2( 150 char)
      , sbfl_due_on           timestamp with time zone
      , sbfl_due_in_hours     number
      , sbfl_priority         number
      , prcs_init_by          varchar2( 255 char)
      , sbfl_reservation      varchar2( 255 char)
      , sbfl_status           varchar2(  20 char)
      , sbfl_became_current   timestamp with time zone
      , sbfl_last_update_by   varchar2( 255 char)
      , sbfl_last_update      timestamp with time zone
      , prcs_id               number
      , sbfl_id               number
      , sbfl_step_key              varchar2(  20 char)
      , sbfl_scope            number
      , sbfl_potential_users  varchar2(4000 char)
      , sbfl_potential_groups varchar2(4000 char)
      , sbfl_excluded_users   varchar2(4000 char)
      , sbfl_lane_name        varchar2( 200 char)
      , sbfl_lane_role        varchar2( 200 char)
      );

    --

    --
    l_row               t_sbfl_row;
    l_cur               sys_refcursor;
    l_task              flow_api_pkg.t_task_list_item;  
    l_current_groups    apex_t_varchar2;
    l_user              varchar2 (255 char);
    --
    procedure process_row is
    begin
        l_task.manager                 := 'FlowsForAPEX';
        l_task.app_id                  := null;
        l_task.task_id                 := null;
        l_task.task_def_id             := null;
        l_task.task_def_name           := coalesce( l_row.curr_objt_name, l_row.sbfl_current );
        l_task.task_def_static_id      := null;
        l_task.subject                 := l_row.prcs_name||' ('||l_row.prcs_business_ref||') - '||coalesce( l_row.curr_objt_name, l_row.sbfl_current);
        l_task.task_type               := case l_row.sbfl_status
                                              when flow_constants_pkg.gc_sbfl_status_waiting_approval then
                                                  'APPROVAL'
                                              else
                                                  'F4A_USERTASK'
                                          end;
        l_task.details_app_id          := null;
        l_task.details_app_name        := l_row.prcs_dgrm_name;
        l_task.details_link_target     := case l_row.curr_objt_tag_name
                                              when 'bpmn:userTask' then
                                                flow_usertask_pkg.get_url
                                                (
                                                  pi_prcs_id  => l_row.prcs_id
                                                , pi_sbfl_id  => l_row.sbfl_id
                                                , pi_objt_id  => l_row.curr_objt_id   
                                                , pi_step_key => l_row.sbfl_step_key
                                                , pi_scope    => l_row.sbfl_scope
                                                )
                                              else null 
                                              end;
        l_task.due_on                  := l_row.sbfl_due_on;
        l_task.due_in_hours            := l_row.sbfl_due_in_hours;
        l_task.due_in                  := apex_util.get_since( l_row.sbfl_due_on );
        l_task.due_code                := case
                                              when l_row.sbfl_due_in_hours <   0 then 'OVERDUE'
                                              when l_row.sbfl_due_in_hours <   1 then 'NEXT_HOUR'
                                              when l_row.sbfl_due_in_hours <  24 then 'NEXT_24_HOURS'
                                              when l_row.sbfl_due_in_hours < 168 then 'NEXT_7_DAYS'
                                              when l_row.sbfl_due_in_hours < 720 then 'NEXT_30_DAYS'
                                              else                               'MORE_THAN_30_DAYS'
                                          end;
        l_task.priority                := l_row.sbfl_priority;
        l_task.priority_level          := case l_row.sbfl_priority
                                              when 1 then 'urgent'
                                              when 2 then 'high'
                                              when 3 then 'medium'
                                              when 4 then 'low'
                                              when 5 then 'lowest'
                                          end;
        l_task.initiator               := l_row.prcs_init_by;
        l_task.initiator_lower         := lower(l_row.prcs_init_by);
        l_task.initiator_can_complete  := 'Y';
        l_task.actual_owner            := l_row.sbfl_reservation;
        l_task.actual_owner_lower      := lower (l_row.sbfl_reservation);
        l_task.potential_owners        := l_row.sbfl_potential_users;
        l_task.potential_groups        := l_row.sbfl_potential_groups;
        l_task.excluded_owners         := l_row.sbfl_excluded_users;
        l_task.badge_css_classes       := --> no class, if unassigned or assigned (also see next case)
                                          case 
                                              when l_row.sbfl_status = flow_constants_pkg.gc_sbfl_status_error 
                                                  then 'u-danger'
                                          end;
        l_task.badge_text              := case 
                                            when p_context = flow_constants_pkg.gc_task_list_context_my_tasks then
                                                case 
                                                  when l_row.sbfl_status = flow_constants_pkg.gc_sbfl_status_error 
                                                      then flow_constants_pkg.gc_sbfl_status_error
                                                  when l_row.sbfl_reservation is null
                                                      then 'unassigned'
                                                end
                                            when p_context = flow_constants_pkg.gc_task_list_context_single then
                                                case
                                                  when l_row.sbfl_reservation is not null
                                                    then 'assigned : '||l_row.sbfl_reservation
                                                  when l_row.sbfl_reservation is null 
                                                    then
                                                      case when l_row.sbfl_potential_users is not null then 'potential users : ' end ||
                                                      l_row.sbfl_potential_users ||
                                                      case when l_row.sbfl_potential_groups is not null then ' potential groups : ' end ||
                                                      l_row.sbfl_potential_groups ||
                                                      case when l_row.sbfl_excluded_users is not null then ' excluded users : ' end ||
                                                      l_row.sbfl_excluded_users
                                                end
                                          end;
        l_task.state_code              := null;
        l_task.state                   := l_row.sbfl_status;
        l_task.is_completed            := 'N';
        l_task.outcome_code            := null;
        l_task.outcome                 := null;

        l_task.created_ago_hours       := floor((sysdate - cast(l_row.sbfl_became_current as date) )*24);
        l_task.created_ago             := apex_util.get_since( l_row.sbfl_became_current );
        l_task.created_by              := l_row.prcs_init_by;
        l_task.created_on              := l_row.sbfl_became_current;
        l_task.last_updated_by         := l_row.sbfl_last_update_by;
        l_task.last_updated_on         := l_row.sbfl_last_update;
        l_task.process_id              := l_row.prcs_id;
        l_task.subflow_id              := l_row.sbfl_id;
        l_task.step_key                := l_row.sbfl_step_key;
        l_task.current_obj             := l_row.sbfl_current;

    end process_row;

    function user_is_eligible
    ( p_task            in flow_api_pkg.t_task_list_item
    , p_user            in varchar2
    , p_current_groups  in apex_t_varchar2
    ) return boolean
    is
      l_potential_users   apex_t_varchar2;
      l_potential_groups  apex_t_varchar2;
      l_group_intersect   apex_t_varchar2;
    begin 
      if p_task.potential_owners is not null then
        l_potential_users    := apex_string.split ( p_str => p_task.potential_owners
                                                  , p_sep => ':' 
                                                  );
        if p_user member of l_potential_users then
          return true;
        end if;
      end if;

      if p_task.potential_groups is not null then
         l_potential_groups  := apex_string.split ( p_str => p_task.potential_groups
                                                  , p_sep => ':'
                                                  );
          l_group_intersect   := l_potential_groups multiset intersect p_current_groups;
          if l_group_intersect is not empty then
            return true;
          end if;
      end if;
      return false;
    end user_is_eligible;


  begin
        l_user    := upper(coalesce( p_user, v('APP_USER')));

        if p_groups is not null then
          l_current_groups  := apex_string.split ( p_str => p_groups
                                                 , p_sep => ':'
                                                 );
        else
          select roles.role_static_id
          bulk   collect into l_current_groups
            from apex_appl_acl_user_roles roles
           where roles.user_name     = v('APP_USER')
             and roles.workspace_id  = v('WORKSPACE_ID')
          ;
        end if;

        l_task := flow_api_pkg.t_task_list_item 
                  ( null, null, null, null, null, null, null, null, null, null
                  , null, null, null, null, null, null, null, null, null, null
                  , null, null, null, null, null, null, null, null, null, null
                  , null, null, null, null, null, null, null, null, null, null 
                  );
        l_cur  := get_tasks
                  ( p_context  => p_context
                  , p_prcs_id  => p_prcs_id
                  , p_user     => l_user
                  , p_groups   => p_groups
                  );


        loop
            fetch l_cur into l_row;
            exit when l_cur%notfound;
            pragma inline(process_row, 'YES');
            process_row;
            if    p_context = flow_constants_pkg.gc_task_list_context_single
               or user_is_eligible  ( p_task            => l_task
                                    , p_user            => l_user
                                    , p_current_groups  => l_current_groups
                                    ) 
            then 
               pipe row( l_task );
            end if;
        end loop;

        if l_cur%isopen then
            close l_cur;
        end if;

  exception
    when no_data_needed then
        close l_cur;
    when others then
        if l_cur%isopen then
            close l_cur;
        end if;
        raise;
  end get_current_tasks;
      

  procedure return_approval_result
    ( p_process_id    in flow_processes.prcs_id%type
    , p_apex_task_id  in number
    , p_result        in flow_process_variables.prov_var_vc2%type default null
    )
  is
  begin
    flow_usertask_pkg.return_approval_result  ( p_process_id    => p_process_id
                                              , p_apex_task_id  => p_apex_task_id
                                              , p_result        => p_result
                                              );
  end return_approval_result;

  procedure return_task_state_outcome
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_step_key      in flow_subflows.sbfl_step_key%type 
    , p_apex_task_id  in number
    , p_state_code    in apex_tasks.state_code%type 
    , p_outcome       in flow_process_variables.prov_var_vc2%type default null
    )
  is
  begin
    flow_usertask_pkg.return_task_state_outcome   ( p_process_id    => p_process_id
                                                  , p_subflow_id    => p_subflow_id
                                                  , p_step_key      => p_step_key
                                                  , p_apex_task_id  => p_apex_task_id
                                                  , p_state_code    => p_state_code
                                                  , p_outcome       => p_outcome
                                                  );
  end return_task_state_outcome;

  function get_task_potential_owners 
   ( p_process_id in flow_processes.prcs_id%type 
   , p_subflow_id in flow_subflows.sbfl_id%type   
   , p_step_key   in flow_subflows.sbfl_step_key%type 
   , p_separator  in varchar2 default ','  
   ) return flow_process_variables.prov_var_vc2%type
  is
  begin
    return flow_usertask_pkg.get_task_potential_owners
           ( p_process_id => p_process_id
           , p_subflow_id => p_subflow_id
           , p_step_key   => p_step_key
           , p_separator  => p_separator
           );
  end get_task_potential_owners;
  
  function get_task_business_admins 
   ( p_process_id         in flow_processes.prcs_id%type 
   , p_subflow_id         in flow_subflows.sbfl_id%type 
   , p_step_key           in flow_subflows.sbfl_step_key%type 
   , p_separator          in varchar2 default ',' 
   , p_add_diagram_admin  in boolean default false
   , p_add_instance_admin in boolean default false
   ) return flow_process_variables.prov_var_vc2%type
  is
  begin
    return flow_usertask_pkg.get_task_business_admins
           ( p_process_id => p_process_id
           , p_subflow_id => p_subflow_id
           , p_step_key   => p_step_key
           , p_separator  => p_separator
           );
  end get_task_business_admins;

  procedure receive_message
  ( p_message_name  flow_message_subscriptions.msub_message_name%type
  , p_key_name      flow_message_subscriptions.msub_key_name%type
  , p_key_value     flow_message_subscriptions.msub_key_value%type
  , p_payload       clob default null
  )
  is
  begin
    -- Note:  Unlike other API calls, we cannot create an  APEX session here if this has come in from outside APEX
    -- as we do not yet have Flows information.  Wait until correlation completed to 
    -- create a session (inside flow_message_flow.receive_message)
    flow_message_flow.receive_message ( p_message_name  =>p_message_name
                                          , p_key_name  =>  p_key_name
                                          , p_key_value  => p_key_value
                                          , p_payload  => p_payload 
                                          );
  end receive_message;

  function intervalDStoSec (
    p_intervalDS  interval day to second
  ) return number
  is
    l_sec number;
  begin
    return ( extract( day   from p_intervalDS) * 86400
           + extract( hour  from p_intervalDS) *  3600
           + extract(minute from p_intervalDS) *    60
           + extract(second from p_intervalDS)        
           );
  end intervalDStoSec;

  function intervalDStoHours (
    p_intervalDS  interval day to second
  ) return number
  is
    l_sec number;
  begin
    return ( extract( day   from p_intervalDS) * 24
           + extract( hour  from p_intervalDS)      
           );
  end intervalDStoHours;

-- Manually Step Forward Timers

  procedure step_timers
  is
  begin
    flow_timers_pkg.step_timers;
  end;

end flow_api_pkg;
/

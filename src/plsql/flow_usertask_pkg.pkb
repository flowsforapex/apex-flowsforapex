create or replace package body flow_usertask_pkg
as
/* 
-- Flows for APEX - flow_usertask_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 12-Nov-2020 Moritz Klein (MT AG) 
-- Edited  13-Apr-2022 Richard Allen (Oracle)
-- Edited  23-May-2022 Moritz Klein (MT AG)
--
*/
  e_lock_timeout exception;
  pragma exception_init (e_lock_timeout, -3006);
  
  function get_url
  (
    pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type
  , pi_objt_id  in flow_objects.objt_id%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type default 0
  ) return varchar2
  as
    l_application        flow_types_pkg.t_bpmn_attribute_vc2;
    l_page               flow_types_pkg.t_bpmn_attribute_vc2;
    l_request            flow_types_pkg.t_bpmn_attribute_vc2;
    l_clear_cache        flow_types_pkg.t_bpmn_attribute_vc2;
    l_items              flow_types_pkg.t_bpmn_attribute_vc2;
    l_values             flow_types_pkg.t_bpmn_attribute_vc2;
    l_form_template_item flow_types_pkg.t_bpmn_attribute_vc2;
    l_form_template_id   flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    select max(ut_application)
         , max(ut_page_id)
         , max(ut_request)
         , max(ut_clear_cache)
         , listagg( ut_item_name, ',' ) within group ( order by order_key ) as item_names
         , listagg( ut_item_value, ',' ) within group ( order by order_key ) as item_values
         , max(ut_form_template_item)
         , max(ut_form_template_id)
      into l_application
         , l_page
         , l_request
         , l_clear_cache
         , l_items
         , l_values
         , l_form_template_item
         , l_form_template_id
      from flow_objects objt
      join json_table( objt.objt_attributes
           , '$.apex'
             columns
               ut_application        varchar2(4000) path '$.applicationId'
             , ut_page_id            varchar2(4000) path '$.pageId'
             , ut_request            varchar2(4000) path '$.request'
             , ut_clear_cache        varchar2(4000) path '$.cache'
             , nested path '$.pageItems[*]'
                 columns ( order_key for ordinality
                         , ut_item_name varchar2(4000) path '$.name'
                         , ut_item_value varchar2(4000) path '$.value'
                         )
             , ut_form_template_item varchar2(4000) path '$.formTemplateItem'
             , ut_form_template_id   varchar2(4000) path '$.formTemplateId'
           ) jt
        on objt.objt_id = pi_objt_id
    ;

    -- substitution for all attributes (was values only pre-23.1)
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_application );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_page );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_request );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_clear_cache );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_items );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_values );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_form_template_item );
    flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_step_key => pi_step_key, pi_scope => pi_scope, pio_string  => l_form_template_id );

    -- apex_simple_form
    if l_form_template_id is not null
       and
       l_form_template_item is not null
    then
      -- append item name
      if l_items is null then
        l_items := l_form_template_item;
      else
        l_items := l_items || ',' || l_form_template_item;
      end if;
      -- append item value
      if l_values is null then
        l_values := l_form_template_id;
      else
        l_values := l_values || ',' || l_form_template_id;
      end if;
    end if;

    return
      apex_page.get_url
      (
        p_application => l_application
      , p_page        => l_page
      , p_request     => l_request
      , p_clear_cache => l_clear_cache
      , p_items       => l_items
      , p_values      => l_values
      )
    ;
  end get_url;

  procedure process_apex_page_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_priority_json           flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority                flow_subflows.sbfl_priority%type;
    l_due_on_json             flow_types_pkg.t_bpmn_attribute_vc2;
    l_due_on                  flow_subflows.sbfl_due_on%type;
    l_potential_users_json    flow_types_pkg.t_bpmn_attribute_vc2;
    l_potential_users         flow_subflows.sbfl_potential_users%type;
    l_potential_users_t       apex_t_varchar2;
    l_potential_groups_json   flow_types_pkg.t_bpmn_attribute_vc2;
    l_potential_groups        flow_subflows.sbfl_potential_groups%type;
    l_excluded_users_json     flow_types_pkg.t_bpmn_attribute_vc2;
    l_excluded_users          flow_subflows.sbfl_excluded_users%type;
    l_reservation             flow_subflows.sbfl_reservation%type;
    l_is_unallocated          varchar2(10) := flow_constants_pkg.gc_vcbool_true;
  begin
    apex_debug.enter 
    ( 'process_APEX_page_task'
    , 'p_step_info.target_objt_tag'   , p_step_info.target_objt_tag 
    , 'p_step_info.target_objt_subtag', p_step_info.target_objt_subtag 
    );
      -- get the userTask subtype  
    select objt.objt_attributes."apex"."priority"
         , objt.objt_attributes."apex"."dueOn"
         , objt.objt_attributes."apex"."potentialUsers"
         , objt.objt_attributes."apex"."potentialGroups"
         , objt.objt_attributes."apex"."excludedUsers"
      into l_priority_json
         , l_due_on_json
         , l_potential_users_json
         , l_potential_groups_json 
         , l_excluded_users_json
      from flow_objects objt
     where objt.objt_bpmn_id = p_step_info.target_objt_ref
       and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
       ;

      if l_priority_json is not null then
        l_priority := flow_settings.get_priority 
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_sbfl_id => p_sbfl_info.sbfl_id
                      , pi_expr    => l_priority_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
      end if;
      if l_due_on_json is not null then 
        l_due_on   := flow_settings.get_due_on 
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_sbfl_id => p_sbfl_info.sbfl_id
                      , pi_expr    => l_due_on_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
      end if;

      if l_potential_groups_json is not null then 
        l_potential_groups := flow_settings.get_vc2_expression
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_sbfl_id => p_sbfl_info.sbfl_id
                      , pi_expr    => l_potential_groups_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
        l_is_unallocated := flow_constants_pkg.gc_vcbool_false;
      end if;
      if l_excluded_users_json is not null then 
        l_excluded_users := flow_settings.get_vc2_expression
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_sbfl_id => p_sbfl_info.sbfl_id
                      , pi_expr    => l_excluded_users_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
        l_is_unallocated := flow_constants_pkg.gc_vcbool_false;
      end if;
      if l_potential_users_json is not null then 
        l_potential_users := flow_settings.get_vc2_expression 
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_sbfl_id => p_sbfl_info.sbfl_id
                      , pi_expr    => l_potential_users_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
        l_is_unallocated := flow_constants_pkg.gc_vcbool_false;
        -- check if only 1 potential user & if so, auto-reserve
        if l_potential_groups is null then
          l_potential_users_t := apex_string.split ( p_str => l_potential_users, p_sep => ':');
          if l_potential_users_t is not null then
            if l_potential_users_t.count = 1 then
              if not apex_string_util.phrase_exists (p_phrase => l_potential_users_t(1), p_string => l_excluded_users) then
                -- only 1 potential user who is not excluded so auto-reserve
                l_reservation := l_potential_users_t(1);
              end if;
            end if;
          end if;
        end if;       
      end if;

      -- if no specific task allocation was found, (i.e., l_is_unallocated is true ) use the lane role already set on the subflow 
      -- as the potential_group if it has a lane role

      update flow_subflows sbfl
         set sbfl.sbfl_last_update        = systimestamp
           , sbfl.sbfl_priority           = l_priority
           , sbfl.sbfl_due_on             = l_due_on
           , sbfl.sbfl_reservation        = l_reservation
           , sbfl.sbfl_potential_users    = l_potential_users
           , sbfl.sbfl_potential_groups   = coalesce ( l_potential_groups
                                                     , case 
                                                       when l_is_unallocated = flow_constants_pkg.gc_vcbool_true 
                                                        and sbfl_lane_isRole = flow_constants_pkg.gc_vcbool_true
                                                       then 
                                                         sbfl_lane_role
                                                       else null end
                                                      , null )                                                         
           , sbfl.sbfl_excluded_users     = l_excluded_users
           , sbfl.sbfl_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
       where sbfl.sbfl_id       = p_sbfl_info.sbfl_id
         and sbfl.sbfl_prcs_id  = p_sbfl_info.sbfl_prcs_id
      ;
  end process_apex_page_task;

  function apex_task_pk_is_required
  ( p_app_id          flow_types_pkg.t_bpmn_attribute_vc2
  , p_task_static_id  flow_types_pkg.t_bpmn_attribute_vc2
  ) return boolean
  is
    l_task_pk_required  boolean;
    l_static_id            apex_appl_taskdefs.static_id%type;
    l_actions_table_name   apex_appl_taskdefs.actions_table_name%type;
    l_actions_sql_query    apex_appl_taskdefs.actions_sql_query%type;
  begin
    --
    --  See if  the APEX Task needs a PK to be supplied. (for Actions Source Table or Actions Source Query)
    --

    select td.static_id
         , td.actions_table_name
         , td.actions_sql_query
      into l_static_id
         , l_actions_table_name
         , l_actions_sql_query 
      from apex_appl_taskdefs td
     where td.application_id = p_app_id
       and td.static_id      = p_task_static_id;
  
    return (l_actions_sql_query is not null) or (l_actions_table_name is not null);

  end apex_task_pk_is_required;

  procedure process_apex_approval_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_prcs_id                 flow_processes.prcs_id%type      := p_sbfl_info.sbfl_prcs_id;
    l_sbfl_id                 flow_subflows.sbfl_id%type       := p_sbfl_info.sbfl_id;
    l_scope                   flow_subflows.sbfl_scope%type    := p_sbfl_info.sbfl_scope;
    l_step_key                flow_subflows.sbfl_step_key%type := p_sbfl_info.sbfl_step_key;
    l_app_id                  flow_types_pkg.t_bpmn_attribute_vc2;
    l_static_id               flow_types_pkg.t_bpmn_attribute_vc2;
    l_subject                 flow_types_pkg.t_bpmn_attribute_vc2;
    l_parameters              flow_types_pkg.t_bpmn_attribute_vc2;
    l_business_ref            flow_types_pkg.t_bpmn_attribute_vc2;
    l_initiator               flow_types_pkg.t_bpmn_attribute_vc2;
    l_initiator_can_complete  flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority_setting        flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority                flow_subflows.sbfl_priority%type;
    l_due_on_setting          flow_types_pkg.t_bpmn_attribute_vc2; 
    l_due_on                  flow_subflows.sbfl_due_on%type;
    l_potential_users_setting flow_types_pkg.t_bpmn_attribute_vc2;
    l_potential_users         flow_subflows.sbfl_potential_users%type;
    l_business_admin_setting  flow_types_pkg.t_bpmn_attribute_vc2;
    l_business_admin          flow_subflows.sbfl_business_admin%type;
    l_result_var              flow_types_pkg.t_bpmn_attribute_vc2;
    l_apex_task_id            number;

    e_priority_invalid   exception;
    e_business_ref_null  exception;

    l_task_parameters  apex_human_task.t_task_parameters := apex_human_task.t_task_parameters();
    l_task_parameter   apex_human_task.t_task_parameter;
  begin
    apex_debug.enter 
    ( 'process_apex_approval_task'
    , 'step_bpmn_id: ', p_step_info.target_objt_ref
    );

    -- get the parameters for the Approval Task creation
    select objt.objt_attributes."apex"."applicationId"
         , objt.objt_attributes."apex"."taskStaticId"
         , objt.objt_attributes."apex"."subject"
         , objt.objt_attributes."apex"."parameters"
         , objt.objt_attributes."apex"."businessRef"
         , objt.objt_attributes."apex"."resultVariable"
         , objt.objt_attributes."apex"."initiator"  
         , objt.objt_attributes."apex"."customExtension"."initiatorCanComplete"  --TODO: Change once parser is fixed
         , objt.objt_attributes."apex"."priority"
         , objt.objt_attributes."apex"."dueOn"
         , objt.objt_attributes."apex"."potentialUsers"
         , objt.objt_attributes."apex"."customExtension"."businessAdmin" --TODO: Change once parser is fixed
      into l_app_id
         , l_static_id
         , l_subject
         , l_parameters
         , l_business_ref
         , l_result_var
         , l_initiator
         , l_initiator_can_complete
         , l_priority_setting
         , l_due_on_setting
         , l_potential_users_setting
         , l_business_admin_setting
      from flow_objects objt
     where objt.objt_bpmn_id = p_step_info.target_objt_ref
       and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
    ;
    apex_debug.info 
      ( p_message => 'APEX Approval Task parameter  %0 '
      , p0 => l_parameters
      );
    -- do substitutions
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_app_id);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_static_id);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_subject);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_parameters);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_business_ref);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_result_var);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_initiator);
    flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_business_admin);

    if l_priority_setting is not null then
      l_priority := flow_settings.get_priority ( pi_prcs_id  => l_prcs_id
                                               , pi_sbfl_id  => l_sbfl_id
                                               , pi_expr     => l_priority_setting
                                               , pi_scope    => l_scope
                                               );
    end if;

    if l_due_on_setting is not null then                                          
      l_due_on :=   flow_settings.get_due_on   ( pi_prcs_id  => l_prcs_id
                                               , pi_sbfl_id  => l_sbfl_id
                                               , pi_expr     => l_due_on_setting
                                               , pi_scope    => l_scope
                                               );
    end if; 

    if l_potential_users_setting is not null then 
      l_potential_users := flow_settings.get_vc2_expression 
                           ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                           , pi_sbfl_id => p_sbfl_info.sbfl_id
                           , pi_expr    => l_potential_users_setting
                           , pi_scope   => p_sbfl_info.sbfl_scope
                           );
    end if;

    if l_business_admin_setting is not null then
       l_business_admin := flow_settings.get_vc2_expression 
                           ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                           , pi_sbfl_id => p_sbfl_info.sbfl_id
                           , pi_expr    => l_business_admin_setting
                           , pi_scope   => p_sbfl_info.sbfl_scope
                           );
    end if;

    -- update subflow with potential users and business admin info so that APEX Human Task can call back...
    if l_potential_users is not null 
    or l_business_admin is not null then

      update flow_subflows sbfl
         set sbfl.sbfl_last_update        = systimestamp
           , sbfl.sbfl_potential_users    = l_potential_users
           , sbfl.sbfl_business_admin     = l_business_admin
           , sbfl.sbfl_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
       where sbfl.sbfl_id       = l_sbfl_id
         and sbfl.sbfl_prcs_id  = l_prcs_id
      ;

    end if;

    -- create parameters table
    for parameters in (
      select static_id
           , data_type
           , value
      from json_table (l_parameters, '$[*]'
                       columns(
                                static_id path '$.parStaticId',
                                data_type path '$.parDataType',
                                value     path '$.parValue'
                              )
                      )
    )
    loop
      l_task_parameter.static_id    := parameters.static_id;
      l_task_parameter.string_value := parameters.value;
      l_task_parameters(l_task_parameters.count+1) := l_task_parameter;
      apex_debug.info 
      ( p_message => 'APEX Approval Task parameter created - parameter %0 value %1'
      , p0 => parameters.static_id
      , p1 => parameters.value
      );
    end loop;
    -- check that priority is a valid priority 1-5 before passing
    begin
      if l_priority is not null then
        if l_priority not between 1 and 5 then
          raise e_priority_invalid;
        end if;
      end if;
    exception
      when value_error then
        apex_debug.error
        ( p_message => 'APEX Approval Task priority (%0) must be between 1 and 5'
        , p0 => l_priority
        );
        raise e_priority_invalid;
    end;
    -- check that business_ref is not null before passing (prevents "lost" tasks in APEX)
    l_business_ref := coalesce(l_business_ref, flow_globals.business_ref);
    if l_business_ref is null then
      if apex_task_pk_is_required (p_app_id => l_app_id, p_task_static_id => l_static_id) then 
        apex_debug.error
        ( p_message => 'APEX Approval Task business ref is null'
        , p0 => coalesce(l_business_ref, flow_globals.business_ref)
        );
        raise e_business_ref_null;
      end if;
    end if;

    begin
      l_apex_task_id := apex_human_task.create_task
                     ( p_application_id     => l_app_id
                     , p_task_def_static_id => l_static_id
                     , p_subject            => l_subject
                     , p_detail_pk          => coalesce(l_business_ref, flow_globals.business_ref) 
                     , p_parameters         => l_task_parameters
                     , p_initiator          => coalesce ( l_initiator
                                                  , sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  ) 
                     , p_priority           => l_priority
                     , p_due_date           => l_due_on
                     );
      apex_debug.info 
      ( p_message => 'APEX Human Task created - APEX Task Reference %0 created'
      , p0 => l_apex_task_id
      );  

      -- set the status to 'waiting for approval'
      update flow_subflows sbfl
         set sbfl.sbfl_last_update    = systimestamp
           , sbfl.sbfl_apex_task_id   = l_apex_task_id
           , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_waiting_approval
           , sbfl.sbfl_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
       where sbfl.sbfl_id       = l_sbfl_id
         and sbfl.sbfl_prcs_id  = l_prcs_id
      ;
    exception
      when e_priority_invalid then
        apex_debug.info 
        ( p_message => ' --- Error creating Approval Task.  Priority should evaluate to number between 1 and 5.  Priority: %0'
        , p0 => l_priority
        );  
        flow_errors.handle_instance_error
        ( pi_prcs_id        => l_prcs_id
        , pi_message_key    => 'apex-task-priority-error'
        , p0 => l_priority
        );  
        -- $F4AMESSAGE 'apex-task-priority-error' || 'Error creating APEX Human task - invalid priority %0.'    
      when e_business_ref_null then
        apex_debug.info
        ( p_message => ' --- Error creating Approval Task - Business Ref / System of Record Primary Key must be not null.'
        );
        flow_errors.handle_instance_error
        ( pi_prcs_id        => l_prcs_id
        , pi_message_key    => 'apex-task-business-ref-null'
        );  
        -- $F4AMESSAGE 'apex-task-business-ref-null' || 'Error creating Approval Task - Business Ref / System of Record Primary Key must be not null.'             
      when others then
        apex_debug.info 
        ( p_message => ' --- Error creating APEX Approval Task.  AppID %0 TaskStaticID %1 Subject %2 DetailPK %3 Initiator %4 Priority %5.'
        , p0 => l_app_id
        , p1 => l_static_id
        , p2 => l_subject
        , p3 => coalesce(l_business_ref, flow_globals.business_ref, null) 
        , p4 => l_initiator
        , p5 => l_priority
        );  
        flow_errors.handle_instance_error
        ( pi_prcs_id        => l_prcs_id
        , pi_sbfl_id        => l_sbfl_id
        , pi_message_key    => 'apex-task-creation-error'
        , p0 => l_static_id
        , p1 => l_app_id
        );  
        -- $F4AMESSAGE 'apex-task-creation-error' || 'Error creating APEX Human Task %0 in application %1.  see debug for details.' 
    end; 
      
  end process_apex_approval_task;

  function get_task_potential_owners
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type
  , p_separator     in varchar2 default ','
  ) return flow_process_variables.prov_var_vc2%type
  is
    l_potential_owners flow_process_variables.prov_var_vc2%type;
  begin
    select sbfl.sbfl_potential_users
      into l_potential_owners
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id     = p_subflow_id
       and sbfl.sbfl_step_key = p_step_key
    ;
    -- Flows for APEX uses default separator ':' for potential owners
    -- but APEX uses ',' as separator for potential owners

    -- so we need to replace ':' with ',' in the potential owners string
    if l_potential_owners is not null then
      l_potential_owners := replace ( l_potential_owners,':', p_separator);
    end if;

    return l_potential_owners;
  end get_task_potential_owners;

  function get_task_business_admin
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type
  , p_separator     in varchar2 default ','
  ) return flow_process_variables.prov_var_vc2%type
    is
    l_business_admin flow_process_variables.prov_var_vc2%type;
  begin
    select sbfl.sbfl_apex_business_admin
      into l_business_admin
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id     = p_subflow_id
       and sbfl.sbfl_step_key = p_step_key
    ;
    -- Flows for APEX uses default separator ':' for business admins
    -- but APEX uses ',' as separator for business admins

    -- so we need to replace ':' with ',' in the business admins string
    if l_business_admin is not null then
      l_business_admin := replace ( l_business_admin,':', p_separator);
    end if;

    return l_business_admin;
  end get_task_business_admin;

  procedure cancel_apex_task
    ( p_process_id          in flow_processes.prcs_id%type
    , p_objt_bpmn_id        in flow_objects.objt_bpmn_id%type
    , p_apex_task_id        in number    
    , p_apex_business_admin in flow_subflows.sbfl_business_admin%type default null
    )
  is
  begin
    apex_debug.enter 
    ( 'cancel_apex_task'
    , 'apex task_id: ', p_apex_task_id 
    , 'apex business admin: ', p_apex_business_admin 
    );
    -- check if current user is the task originator or business admin
--    if p_apex_business_admin is not null then
--      if not apex_human_task.is_task_originator ( p_task_id => p_apex_task_id, p_user => v('APP_USER') ) then
--        raise flow_errors.e_not_authorized;
--      end if;
--    end if;


    -- cancel task
    apex_human_task.cancel_task (p_task_id => p_apex_task_id);
    apex_debug.info 
    ( p_message => 'APEX Human Task : %0  cancelled on object : %1'
    , p0 => p_apex_task_id
    , p1 => p_objt_bpmn_id
    );
  exception
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_message_key => 'apex-task-cancelation-error'
      , p0 => p_objt_bpmn_id
      , p1 => p_apex_task_id
      , p2 => sqlerrm
      );
      -- $F4AMESSAGE 'apex-task-cancelation-error' || 'Error attempting to cancel APEX workflow task (task_id: %1 ) for process step : %0.)' 
  end cancel_apex_task;

  procedure return_approval_result
    ( p_process_id    in flow_processes.prcs_id%type
    , p_apex_task_id  in number
    , p_result        in flow_process_variables.prov_var_vc2%type default null
    )
    is
      l_sbfl_id             flow_subflows.sbfl_id%type;
      l_dgrm_id             flow_subflows.sbfl_dgrm_id%type;
      l_current_bpmn_id     flow_objects.objt_bpmn_id%type;
      l_scope               flow_subflows.sbfl_scope%type;
      l_step_key            flow_subflows.sbfl_step_key%type;
      l_var_name            flow_process_variables.prov_var_name%type;
      l_potential_current   flow_objects.objt_bpmn_id%type;
      l_result_var          flow_process_variables.prov_var_name%type;

      e_task_id_proc_var_not_found  exception;
      e_task_id_duplicate_found     exception;
      e_task_not_current_step       exception;
      e_task_no_return_var          exception;
    begin
      apex_debug.enter
      (p_routine_name => 'return_approval_outcome'
      );

      begin
        -- find and lock the subflow
        select sbfl.sbfl_id
             , sbfl.sbfl_step_key
             , sbfl.sbfl_dgrm_id
             , sbfl.sbfl_scope
             , sbfl.sbfl_current
          into l_sbfl_id
             , l_step_key
             , l_dgrm_id
             , l_scope
             , l_current_bpmn_id 
          from flow_subflows sbfl
         where sbfl.sbfl_prcs_id = p_process_id
           and sbfl.sbfl_apex_task_id = p_apex_task_id
        for update of sbfl.sbfl_step_key wait 5;
      exception
        when no_data_found then
          if p_state_code != apex_human_task.c_task_state_cancelled then
            -- task was cancelled - do nothing
            l_cancelled_not_current := true;
          else
            raise e_task_id_not_found;
          end if;
        when too_many_rows then
          raise e_task_id_duplicate_found;
        when e_lock_timeout then
          raise e_lock_timeout;
      end;
      apex_debug.info 
      ( p_message => '--- Returning Approval Outcome - Found Subflow %0 step Key %1 Diagram %2'
      , p0 => l_sbfl_id
      , p1 => l_step_key
      , p2 => l_dgrm_id
      );
      -- get name of return variable
      begin
        select objt.objt_attributes."apex"."resultVariable"
          into l_result_var
          from flow_objects objt
         where objt.objt_bpmn_id = l_current_bpmn_id 
           and objt.objt_dgrm_id = l_dgrm_id;
        apex_debug.info 
        ( p_message => '--- Returning Approval Outcome - Found result variable id %0'
        , p0 => l_result_var
        );
      exception
        when no_data_found then
          raise e_task_no_return_var;
      end;

      -- create result variable
      flow_proc_vars_int.set_var
       ( pi_prcs_id       => p_process_id
       , pi_var_name      => l_result_var
       , pi_scope         => l_scope
       , pi_vc2_value     => p_result
       , pi_sbfl_id       => l_sbfl_id
       , pi_objt_bpmn_id  => l_potential_current
       );
      -- do next step
      flow_engine.flow_complete_step
        ( p_process_id    => p_process_id
        , p_subflow_id    => l_sbfl_id
        , p_step_key      => l_step_key
        );
    exception
      when e_lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => l_sbfl_id
        , pi_message_key => 'timeout_locking_subflow'
        , p0 => l_sbfl_id
        );
      when e_task_id_proc_var_not_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => l_sbfl_id
        , pi_message_key => 'apex-task-not-found'
        , p0 => p_apex_task_id 
        );
      when e_task_id_duplicate_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => l_sbfl_id
        , pi_message_key => 'apex-task-on-multiple-steps'
        , p0 => p_apex_task_id
        );
      when e_task_not_current_step then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => l_sbfl_id
        , pi_message_key => 'apex-task-not-current-step'
        , p0 => p_apex_task_id
        );
      when e_task_no_return_var then
        flow_errors.handle_instance_error
        ( pi_prcs_id     => p_process_id
        , pi_sbfl_id     => l_sbfl_id
        , pi_message_key => 'apex-task-invalid-return-var'
        , p0 => p_apex_task_id
        );      
    end return_approval_result;

end flow_usertask_pkg;
/

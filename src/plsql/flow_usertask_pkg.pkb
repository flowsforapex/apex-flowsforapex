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
    l_application flow_types_pkg.t_bpmn_attribute_vc2;
    l_page        flow_types_pkg.t_bpmn_attribute_vc2;
    l_request     flow_types_pkg.t_bpmn_attribute_vc2;
    l_clear_cache flow_types_pkg.t_bpmn_attribute_vc2;
    l_items       flow_types_pkg.t_bpmn_attribute_vc2;
    l_values      flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    select max(ut_application)
         , max(ut_page_id)
         , max(ut_request)
         , max(ut_clear_cache)
         , listagg( ut_item_name, ',' ) within group ( order by order_key ) as item_names
         , listagg( ut_item_value, ',' ) within group ( order by order_key ) as item_values
      into l_application
         , l_page
         , l_request
         , l_clear_cache
         , l_items
         , l_values
      from flow_objects objt
      join json_table( objt.objt_attributes
           , '$.apex'
             columns
               ut_application varchar2(4000) path '$.applicationId'
             , ut_page_id     varchar2(4000) path '$.pageId'
             , ut_request     varchar2(4000) path '$.request'
             , ut_clear_cache varchar2(4000) path '$.cache'
             , nested path '$.pageItems[*]'
                 columns ( order_key for ordinality
                         , ut_item_name varchar2(4000) path '$.name'
                         , ut_item_value varchar2(4000) path '$.value'
                         )
           ) jt
        on objt.objt_id = pi_objt_id
    ;

    -- itemValues will run through substitution
    -- other attributes not (yet?)
    flow_proc_vars_int.do_substitution
    ( 
      pi_prcs_id  => pi_prcs_id
    , pi_sbfl_id  => pi_sbfl_id
    , pi_step_key => pi_step_key
    , pio_string  => l_values 
    , pi_scope    => pi_scope
    );

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

  procedure process_apex_approval_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_prcs_id          flow_processes.prcs_id%type      := p_sbfl_info.sbfl_prcs_id;
    l_sbfl_id          flow_subflows.sbfl_id%type       := p_sbfl_info.sbfl_id;
    l_scope            flow_subflows.sbfl_scope%type    := p_sbfl_info.sbfl_scope;
    l_step_key         flow_subflows.sbfl_step_key%type := p_sbfl_info.sbfl_step_key;
    l_app_id           flow_types_pkg.t_bpmn_attribute_vc2;
    l_static_id        flow_types_pkg.t_bpmn_attribute_vc2;
    l_subject          flow_types_pkg.t_bpmn_attribute_vc2;
    l_parameters       flow_types_pkg.t_bpmn_attribute_vc2;
    l_business_ref     flow_types_pkg.t_bpmn_attribute_vc2;
    l_task_comment     flow_types_pkg.t_bpmn_attribute_vc2;
    l_apex_task_id     number;
    $IF flow_apex_env.ver_le_21 $THEN
      -- only need this for testing as apex_approval should fail if attempt to run without apex 22.1+
      type t_task_parameter  is record
      ( static_id     varchar2(255)
      , string_value  varchar2(255)
      );
      type t_task_parameters is table of t_task_parameter;
      l_task_parameter    t_task_parameter;
      l_task_parameters   t_task_parameters := t_task_parameters();
    $else
      -- APEX 22.1 supports Approval Components and has apex_approval package
      l_task_parameters  apex_approval.t_task_parameters := apex_approval.t_task_parameters();
      l_task_parameter   apex_approval.t_task_parameter;
    $end
  begin
    apex_debug.enter 
    ( 'process_apex_approval_task'
    , 'step_bpmn_id: ', p_step_info.target_objt_ref
    );
    -- check that APEX is >= v22.1 (required for APEX approval component)
    if flow_apex_env.ver_le_21_2 then 
      flow_errors.handle_instance_error
      ( pi_prcs_id        => l_prcs_id
      , pi_sbfl_id        => l_sbfl_id
      , pi_message_key    => 'apex-task-not-supported'
      , p0 => '22.1'
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'apex-task-not-supported' || 'APEX Workflow Feature use requires Oracle APEX v%0.'
    else
      -- get the parameters for the Approval Task creation
      select objt.objt_attributes."apex"."applicationId"
           , objt.objt_attributes."apex"."taskStaticId"
           , objt.objt_attributes."apex"."subject"
           , objt.objt_attributes."apex"."parameters"
           , objt.objt_attributes."apex"."businessRef"
           , objt.objt_attributes."apex"."taskComment"
        into l_app_id
           , l_static_id
           , l_subject
           , l_parameters
           , l_business_ref
           , l_task_comment
        from flow_objects objt
       where objt.objt_bpmn_id = p_step_info.target_objt_ref
         and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
         ;
      -- do substitutions
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_app_id);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_static_id);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_subject);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_parameters);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_business_ref);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_task_comment);
      -- create parameters table
      for parameters in (
        select static_id
             , data_type
             , value
        from json_table (l_parameters, '$.parameters[*]'
                         columns(
                                  static_id path '$.static_id',
                                  data_type path '$.data_type',
                                  value path '$.value'
                                )
                        )
      )
      loop
        l_task_parameter.static_id    := parameters.static_id;
        l_task_parameter.string_value := parameters.value;
        l_task_parameters(l_task_parameters.count+1) := l_task_parameter;
      end loop;

      $IF flow_apex_env.ver_le_21_2 $THEN
        -- dummy for testing before APEX v22.1...
        l_apex_task_id := 99999999;
      $ELSE
        -- create the task in APEX Approvals if after APEX v22.1
        l_apex_task_id := apex_approval.create_task
                       ( p_application_id     => l_app_id
                       , p_task_def_static_id => l_static_id
                       , p_subject            => l_subject
                       , p_detail_pk          => coalesce(l_business_ref, flow_globals.business_ref, null) 
                       , p_parameters         => l_task_parameters
                       );
      $END

      flow_proc_vars_int.set_var 
      ( pi_prcs_id      => l_prcs_id
      , pi_scope        => l_scope
      , pi_var_name     => p_step_info.target_objt_ref||flow_constants_pkg.gc_prov_suffix_task_id
      , pi_num_value    => l_apex_task_id
      , pi_sbfl_id      => l_sbfl_id
      , pi_objt_bpmn_id => p_step_info.target_objt_ref
      );
      -- Add a comment to the task if included in the definition
     -- exceptions
      -- APEX workflow Task not supported on this APEX release
      -- APEX Task with Static ID %0 not found in Application %1 in this APEX Workspace
      -- APEX Task cannot be started with these parameters
    end if;
  end process_apex_approval_task;

  procedure cancel_apex_task
    ( p_process_id    in flow_processes.prcs_id%type
    , p_objt_bpmn_id  in flow_objects.objt_bpmn_id%type
    , p_apex_task_id  in number    
    )
  is
  begin
    apex_debug.enter 
    ( 'cancel_apex_task'
    , 'apex task_id: ', p_apex_task_id 
    );
    $IF flow_apex_env.ver_le_21_2 $THEN
      null;
    $ELSE
      -- cancel task
      apex_approval.cancel_task (p_task_id => p_apex_task_id);
    $END
     apex_debug.info 
    ( p_message => 'APEX Workflow Task : %0  cancelled on object : %1'
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
     l_current_bpmn_id     flow_objects.objt_bpmn_id%type;
     l_scope               flow_subflows.sbfl_scope%type;
     l_step_key            flow_subflows.sbfl_step_key%type;
     l_var_name            flow_process_variables.prov_var_name%type;
     l_potential_current   flow_objects.objt_bpmn_id%type;

     e_task_id_proc_var_not_found  exception;
     e_task_id_duplicate_found     exception;
     e_task_not_current_step       exception;
   begin
     apex_debug.enter
     (p_routine_name => 'return_approval_result'
     );
     -- check task belongs to this process
     begin
       select prov.prov_var_name
            , replace (prov.prov_var_name , flow_constants_pkg.gc_prov_suffix_task_id) l_potential_current
            , prov.prov_scope
         into l_var_name
            , l_potential_current
            , l_scope
         from flow_process_variables prov
        where prov.prov_prcs_id = p_process_id
          and prov.prov_var_num = p_apex_task_id
          and prov.prov_var_type = flow_constants_pkg.gc_prov_var_type_number
          and prov.prov_var_name like '%'||flow_constants_pkg.gc_prov_suffix_task_id
       ;
     exception
       when no_data_found then
         raise e_task_id_proc_var_not_found;
       when too_many_rows then
         raise e_task_id_duplicate_found;
     end;
     begin
       -- find and lock the subflow
       select sbfl.sbfl_id
            , sbfl.sbfl_step_key
         into l_sbfl_id
            , l_step_key
         from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
          and sbfl.sbfl_scope = l_scope
          and sbfl.sbfl_current = l_potential_current
       for update of sbfl.sbfl_step_key wait 5;
     exception
       when no_data_found then
         raise e_task_not_current_step;
       when e_lock_timeout then
         raise e_lock_timeout;
     end;
     -- create result variable
     flow_proc_vars_int.set_var
      ( pi_prcs_id       => p_process_id
      , pi_var_name      => l_potential_current||flow_constants_pkg.gc_prov_suffix_result
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
   end return_approval_result;

end flow_usertask_pkg;
/

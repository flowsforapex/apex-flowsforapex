create or replace package body flow_apex_session
as

  type t_session_parameters    is record 
  ( app_id   flow_types_pkg.t_bpmn_attribute_vc2
  , page_id  flow_types_pkg.t_bpmn_attribute_vc2
  , username flow_types_pkg.t_bpmn_attribute_vc2
  );
  e_apex_session_missing_param exception;

  function get_session_parameters 
  ( p_dgrm_id         flow_diagrams.dgrm_id%type
  )
  return t_session_parameters
  as
    l_var_value             flow_subflows.sbfl_current%type;
    l_session_parameters    t_session_parameters;
  begin
  
    select jt.app_id
         , jt.page_id
         , jt.username
      into l_session_parameters
      from flow_objects objt
         , json_table( objt.objt_attributes, '$.apex'
             columns
               app_id   varchar2(4000) path '$.applicationId'
             , page_id  varchar2(4000) path '$.pageId'
             , username varchar2(4000) path '$.username'
           ) jt
     where objt.objt_dgrm_id = p_dgrm_id
       and objt.objt_objt_id is null
       and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
    ;

    if (  l_session_parameters.app_id is null
       or l_session_parameters.page_id is null 
       or l_session_parameters.username is null
       ) then
      -- attribute not set at process diagram level - try system config
      l_session_parameters.app_id   := flow_engine_util.get_config_value 
                        ( p_config_key    => flow_constants_pkg.gc_config_default_application
                        , p_default_value => null
                        );
      l_session_parameters.page_id  := flow_engine_util.get_config_value 
                        ( p_config_key    => flow_constants_pkg.gc_config_default_pageid 
                        , p_default_value => null
                        );
      l_session_parameters.username := flow_engine_util.get_config_value 
                        ( p_config_key    => flow_constants_pkg.gc_config_default_username
                        , p_default_value => null
                        );
    end if;

    if (  l_session_parameters.app_id is null
       or l_session_parameters.page_id is null 
       or l_session_parameters.username is null
       ) then
      -- attribute not set at system config level - throw error   
      raise e_apex_session_missing_param;
    end if;
    return l_session_parameters;
  end get_session_parameters;

  procedure set_async_proc_vars
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  )
  is 
    l_current                flow_subflows.sbfl_current%type;
    l_sbfl_dgrm_id           flow_subflows.sbfl_dgrm_id%type;
    l_session_parameters     t_session_parameters;
    l_timer_scope            flow_subflows.sbfl_scope%type;   
  begin
    -- get the current object (and scope) as timer object name
    select sbfl.sbfl_current
         , sbfl.sbfl_dgrm_id
         , sbfl.sbfl_scope
      into l_current
         , l_sbfl_dgrm_id
         , l_timer_scope
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id      = p_subflow_id
    ;
    -- check if required process variables exist in current scope 
    if flow_proc_vars_int.get_var_vc2 ( pi_prcs_id  => p_process_id
                                     , pi_var_name => l_current || ':' || flow_constants_pkg.gc_async_parameter_applicationId
                                     , pi_scope    => l_timer_scope
                                     ) is null  
    or flow_proc_vars_int.get_var_vc2 ( pi_prcs_id  => p_process_id
                                     , pi_var_name => l_current || ':' || flow_constants_pkg.gc_async_parameter_pageId
                                     , pi_scope    => l_timer_scope
                                     ) is null
    or flow_proc_vars_int.get_var_vc2 ( pi_prcs_id  => p_process_id
                                     , pi_var_name => l_current || ':' || flow_constants_pkg.gc_async_parameter_username
                                     , pi_scope    => l_timer_scope
                                     ) is null
    then
      l_session_parameters := get_session_parameters (p_dgrm_id => l_sbfl_dgrm_id);

      flow_proc_vars_int.set_var
          ( pi_prcs_id      => p_process_id
          , pi_var_name     => l_current || ':' || flow_constants_pkg.gc_async_parameter_applicationId
          , pi_scope        => l_timer_scope
          , pi_vc2_value    => l_session_parameters.app_id
          , pi_sbfl_id      => p_subflow_id
          , pi_objt_bpmn_id => l_current
          );
      flow_proc_vars_int.set_var
          ( pi_prcs_id      => p_process_id
          , pi_var_name     => l_current || ':' || flow_constants_pkg.gc_async_parameter_pageId
          , pi_scope        => l_timer_scope
          , pi_vc2_value    => l_session_parameters.page_id
          , pi_sbfl_id      => p_subflow_id
          , pi_objt_bpmn_id => l_current
          );
      flow_proc_vars_int.set_var
          ( pi_prcs_id      => p_process_id
          , pi_var_name     => l_current || ':' || flow_constants_pkg.gc_async_parameter_username
          , pi_scope        => l_timer_scope
          , pi_vc2_value    => l_session_parameters.username
          , pi_sbfl_id      => p_subflow_id
          , pi_objt_bpmn_id => l_current
          );
    end if;
  exception
      when e_apex_session_missing_param then
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_subflow_id
          , pi_message_key  => 'apex-session-params-not-set'
          , p0              => l_current
          );
          -- $F4AMESSAGE 'apex-session-params-not-set' || 'Asynchronous connection details for timer %0 need to be set in process variables, diagram async connection details, or system config details.' 
  end set_async_proc_vars;

 function create_async_session
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number
  is 
    l_timer_name             flow_subflows.sbfl_current%type;
    l_timer_scope            flow_subflows.sbfl_scope%type;
    l_app_id                 flow_types_pkg.t_bpmn_attribute_vc2;
    l_page_id                flow_types_pkg.t_bpmn_attribute_vc2;
    l_username               flow_types_pkg.t_bpmn_attribute_vc2;
    l_session_id             number;
  begin
    flow_globals.set_is_recursive_step (p_is_recursive_step => true);
    -- get the current object (and scope) as timer object name
    select sbfl.sbfl_current
         , sbfl.sbfl_scope
      into l_timer_name
         , l_timer_scope
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id      = p_subflow_id
    ;
    -- get async process variable details 
    l_username  := flow_proc_vars_int.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_username
                      , pi_scope     => l_timer_scope
                      );
    l_app_id    := flow_proc_vars_int.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_applicationId
                      , pi_scope     => l_timer_scope
                      );
    l_page_id   := flow_proc_vars_int.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_pageId
                      , pi_scope     => l_timer_scope
                      );         
    -- check all process variables are set in case they have been deleted since timer was set
    if l_username is null then
      flow_errors.handle_instance_error
          ( pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_subflow_id
          , pi_message_key  => 'async-no-username'
          , p0              => l_timer_name
          );
    end if;
    if l_app_id is null then
      flow_errors.handle_instance_error
          ( pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_subflow_id
          , pi_message_key  => 'async-no-appid'
          , p0              => l_timer_name
          );
    end if;
    if l_page_id is null then
      flow_errors.handle_instance_error
          ( pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_subflow_id
          , pi_message_key  => 'async-no-pageid'
          , p0              => l_timer_name
          );
    end if;
    -- create apex session
    begin
      apex_session.create_session 
        ( p_app_id   => l_app_id
        , p_page_id  => l_page_id
        , p_username => l_username 
        );
    exception
      when flow_constants_pkg.ge_invalid_session_params then
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_process_id
          , pi_sbfl_id      => p_subflow_id
          , pi_message_key  => 'async-invalid_params'
          , p0              => l_timer_name
          );
          raise flow_constants_pkg.ge_invalid_session_params;
    end;
    return v('APP_SESSION');
  end create_async_session;

 function create_api_session
  ( p_dgrm_id         in flow_diagrams.dgrm_id%type
  , p_prcs_id         in flow_processes.prcs_id%type
  ) return number
  is 
    l_session_id             number;
    l_session_parameters     t_session_parameters;
  begin
    -- get session parameters from process diagram or system config
    l_session_parameters := get_session_parameters ( p_dgrm_id => p_dgrm_id);
  
    -- create apex session
    begin
      apex_session.create_session 
        ( p_app_id   => l_session_parameters.app_id
        , p_page_id  => l_session_parameters.page_id
        , p_username => l_session_parameters.username 
        );
    exception
      when flow_constants_pkg.ge_invalid_session_params then
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_prcs_id
          , pi_message_key  => 'async-invalid_params'
          , p0              => 'API Call'
          );
          raise flow_constants_pkg.ge_invalid_session_params;
    end;
    return v('APP_SESSION');
  end create_api_session;

  function create_api_session
  ( p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number
  is 
    l_dgrm_id      flow_diagrams.dgrm_id%type;
    l_prcs_id      flow_processes.prcs_id%type;
  begin
    select sbfl.sbfl_dgrm_id
         , sbfl.sbfl_prcs_id
      into l_dgrm_id
         , l_prcs_id
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
    ;
    return create_api_session (p_dgrm_id => l_dgrm_id, p_prcs_id => l_prcs_id);
  end create_api_session;

  function create_api_session
  ( p_process_id         in flow_processes.prcs_id%type
  ) return number
  is 
    l_dgrm_id      flow_diagrams.dgrm_id%type;
  begin
    select prcs.prcs_dgrm_id
      into l_dgrm_id
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;
    return create_api_session (p_dgrm_id => l_dgrm_id, p_prcs_id => p_process_id);
  end create_api_session;

  procedure delete_session
  ( p_session_id         in number)
  is 
  begin
    apex_session.delete_session ( p_session_id => p_session_id);
  end;

end flow_apex_session;
/

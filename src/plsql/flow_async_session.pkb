create or replace package body flow_async_session
as


  procedure set_async_proc_var
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  , p_var_name           in flow_process_variables.prov_var_name%type
  , p_obat_key           in flow_object_attributes.obat_key%type
  , p_config_key         in flow_configuration.cfig_key%type
  , p_message_key        in flow_messages.fmsg_message_key%type
  , p_timer_name         in flow_objects.objt_bpmn_id%type
-- , p_scope              in flow_subflows.sbfl_scope%type
  )
  is 
    l_var_value             flow_subflows.sbfl_current%type;
  begin
    -- check if required process variables exist in current scope 
    if flow_process_vars.get_var_vc2 ( pi_prcs_id  => p_process_id
                                     , pi_var_name => p_var_name
--                                     , pi_scope    => l_timer_scope
                                     ) is null 
    then 
      begin
        -- set using process attribute
        select obat.obat_vc_value
          into l_var_value
          from flow_object_attributes obat
          join flow_objects objt
            on objt.objt_id = obat.obat_objt_id
          join flow_subflows sbfl
            on sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
         where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
           and obat.obat_key = p_obat_key
           and sbfl.sbfl_id = p_subflow_id
        ;
      exception 
        when no_data_found then
          -- attribute not set at process diagram leve - try system config
          l_var_value := flow_engine_util.get_config_value 
                            ( p_config_key    => p_config_key
                            , p_default_value => null
                            );
          if l_var_value is null then
            flow_errors.handle_instance_error
                ( pi_prcs_id      => p_process_id
                , pi_sbfl_id      => p_subflow_id
                , pi_message_key  => p_message_key
                , p0              => p_timer_name
                );
          end if;
      end;
      -- set the process variable
      flow_process_vars.set_var 
          ( pi_prcs_id      => p_process_id
          , pi_var_name     => p_var_name
--          , pi_scope        => l_timer_scope
          , pi_vc2_value    => l_var_value
          , pi_sbfl_id      => p_subflow_id
          , pi_objt_bpmn_id => p_timer_name
          );

    end if;
  end set_async_proc_var;

  procedure set_async_proc_vars
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  )
  is 
    l_timer_name             flow_subflows.sbfl_current%type;
    -- l_timer_scope            flow_subflows.sbfl_scope%type;   uncomment after merging

  begin
    -- get the current object (and scope) as timer object name
    select sbfl.sbfl_current
  --       , sbfl.sbfl_scope
      into l_timer_name
  --       , l_timer_scope
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id      = p_subflow_id
    ;

    -- set username
    set_async_proc_var
        ( p_process_id    => p_process_id 
        , p_subflow_id    => p_subflow_id
        , p_var_name      => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_username
        , p_obat_key      => flow_constants_pkg.gc_apex_process_username
        , p_config_key    => flow_constants_pkg.gc_config_default_username
        , p_message_key   => 'async-no-username'
        , p_timer_name    => l_timer_name
  --      , p_scope         => l_timer_scope
        );
    -- set appID
    set_async_proc_var
        ( p_process_id    => p_process_id 
        , p_subflow_id    => p_subflow_id
        , p_var_name      => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_applicationId
        , p_obat_key      => flow_constants_pkg.gc_apex_process_application_id
        , p_config_key    => flow_constants_pkg.gc_config_default_application
        , p_message_key   => 'async-no-appid'
        , p_timer_name    => l_timer_name
  --      , p_scope         => l_timer_scope
        );  
    -- set pageID
    set_async_proc_var
        ( p_process_id    => p_process_id 
        , p_subflow_id    => p_subflow_id
        , p_var_name      => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_pageId
        , p_obat_key      => flow_constants_pkg.gc_apex_process_page_id
        , p_config_key    => flow_constants_pkg.gc_config_default_pageid
        , p_message_key   => 'async-no-pageid'
        , p_timer_name    => l_timer_name
  --      , p_scope         => l_timer_scope
        );

  end set_async_proc_vars;

 function create_async_apex_session
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number
  is 
    l_timer_name             flow_subflows.sbfl_current%type;
    -- l_timer_scope            flow_subflows.sbfl_scope%type;   uncomment after merging
    l_app_id                 flow_object_attributes.obat_vc_value%type;
    l_page_id                flow_object_attributes.obat_vc_value%type;
    l_username               flow_object_attributes.obat_vc_value%type;
    l_session_id             number;
  begin
    flow_globals.set_is_recursive_step (p_is_recursive_step => true);
    -- get the current object (and scope) as timer object name
    select sbfl.sbfl_current
  --       , sbfl.sbfl_scope
      into l_timer_name
  --       , l_timer_scope
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id      = p_subflow_id
    ;
    -- get async process variable details 
    l_username  := flow_process_vars.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_username
--                      , pi_scope     => l_timer_scope
                      );
    l_app_id    := flow_process_vars.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_applicationId
--                      , pi_scope     => l_timer_scope
                      );
    l_page_id   := flow_process_vars.get_var_vc2
                      ( pi_prcs_id   => p_process_id
                      , pi_var_name  => l_timer_name || ':' || flow_constants_pkg.gc_async_parameter_pageId
--                      , pi_scope     => l_timer_scope
                      );         
    -- check all process variables are set in case they have been delted since timer was set
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
  end;


  procedure delete_async_apex_session
  ( p_session_id         in number)
  is 
  begin
    apex_session.delete_session ( p_session_id => p_session_id);
  end;

end flow_async_session;
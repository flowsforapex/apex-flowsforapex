create or replace package body flow_globals
/* 
-- Flows for APEX - flow_globals.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Limited and / or its affiliates. 2026.
--
-- Created    25-Aug-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
-- Modified   16-Feb-2026  Richard Allen (Flowquest)
--
*/
as

  g_error_on_step  boolean := false;  
  -- g_error_on_step starts false when every step is processed but is set true if an error
  -- occurs in the engine during processing.  It is then used to determine whether to 
  -- commit or rollback the engine transaction at the end of step processing
  g_is_recursive_step boolean := false;
  -- g_recursive_step is set to false for steps that are being performed by the user, and true
  -- for subsequent recursive steps that are performed by the engine (such as gateway steps, scriptTasks, etc.)
  g_is_async_session boolean := false;
  -- g_is_async_session is true for the lifetime of an AQ-driven async callback session.


  procedure set_context
  ( pi_prcs_id          in flow_processes.prcs_id%type
  , pi_sbfl_id          in flow_subflows.sbfl_id%type default null
  , pi_step_key         in flow_subflows.sbfl_step_key%type default null
  , pi_scope            in flow_subflows.sbfl_scope%type default null
  , pi_loop_counter     in flow_subflows.sbfl_loop_counter%type default null
  , pi_input_parameters in flow_subflows.sbfl_task_input_parameters%type default null
  )
  is
  begin 
    process_id        := pi_prcs_id;
    subflow_id        := pi_sbfl_id;
    step_key          := pi_step_key;
    scope             := pi_scope;
    loop_counter      := pi_loop_counter;
    input_parameters  := pi_input_parameters;    
    output_parameters := null; -- Initialize as empty for each task execution  
  end set_context;

  procedure set_context
  ( pi_sbfl_rec   in flow_subflows%rowtype
  )
  is
  begin
    set_context ( pi_prcs_id          => pi_sbfl_rec.sbfl_prcs_id
                , pi_sbfl_id          => pi_sbfl_rec.sbfl_id
                , pi_step_key         => pi_sbfl_rec.sbfl_step_key
                , pi_scope            => pi_sbfl_rec.sbfl_scope
                , pi_loop_counter     => pi_sbfl_rec.sbfl_loop_counter
                , pi_input_parameters => pi_sbfl_rec.sbfl_task_input_parameters
                );
  end set_context;

  procedure set_step_error
  ( p_has_error  in boolean default false)
  is
  begin
    /*apex_debug.enter
    ( 'set_step_error'
    , 'p_has_error', case when p_has_error then 'true' else 'false' end
    );*/
    g_error_on_step := p_has_error;
  end set_step_error;

  function get_step_error return boolean
  is
  begin
    /*apex_debug.enter
    ( 'get_step_error'
    , 'g_error_on_step', case when g_error_on_step then 'true' else 'false' end
    );*/
    return g_error_on_step;
  end get_step_error; 

  procedure set_is_recursive_step
  ( p_is_recursive_step  in boolean default false)
  is
  begin
    g_is_recursive_step := p_is_recursive_step;
  end set_is_recursive_step;

  function get_is_recursive_step return boolean
  is
  begin
    return g_is_recursive_step;
  end get_is_recursive_step; 

  procedure set_is_async_session
  ( p_is_async_session  in boolean default false)
  is
  begin
    g_is_async_session := p_is_async_session;
  end set_is_async_session;

  function get_is_async_session return boolean
  is
  begin
    return g_is_async_session;
  end get_is_async_session;
  
  procedure set_output_parameter
  ( pi_parameter_name in varchar2
  , pi_value          in varchar2
  )
  is
    l_json_obj json_object_t;
  begin
    -- Initialize JSON object if needed
    if output_parameters is null or output_parameters is not json then
      l_json_obj := json_object_t();
    else
      l_json_obj := json_object_t(output_parameters);
    end if;
    
    -- Set the parameter value
    l_json_obj.put(pi_parameter_name, pi_value);
    
    -- Update the global variable
    output_parameters := l_json_obj.to_clob();
  exception
    when others then
      -- If JSON operations fail, create new JSON object with just this parameter
      l_json_obj := json_object_t();
      l_json_obj.put(pi_parameter_name, pi_value);
      output_parameters := l_json_obj.to_clob();
  end set_output_parameter;

  procedure set_output_parameter_object
  ( pi_parameter_name  in varchar2
  , pi_key1            in varchar2 default null
  , pi_value1          in varchar2 default null
  , pi_key2            in varchar2 default null
  , pi_value2          in varchar2 default null
  , pi_key3            in varchar2 default null
  , pi_value3          in varchar2 default null
  , pi_key4            in varchar2 default null
  , pi_value4          in varchar2 default null
  , pi_key5            in varchar2 default null
  , pi_value5          in varchar2 default null
  , pi_key6            in varchar2 default null
  , pi_value6          in varchar2 default null
  )
  is
    l_nested_obj   json_object_t;
  begin
    l_nested_obj := json_object_t();

    if pi_key1 is not null then
      l_nested_obj.put(pi_key1, pi_value1);
    end if;
    if pi_key2 is not null then
      l_nested_obj.put(pi_key2, pi_value2);
    end if;
    if pi_key3 is not null then
      l_nested_obj.put(pi_key3, pi_value3);
    end if;
    if pi_key4 is not null then
      l_nested_obj.put(pi_key4, pi_value4);
    end if;
    if pi_key5 is not null then
      l_nested_obj.put(pi_key5, pi_value5);
    end if;
    if pi_key6 is not null then
      l_nested_obj.put(pi_key6, pi_value6);
    end if;

    set_output_parameter_object
    ( pi_parameter_name  => pi_parameter_name
    , pi_object_json     => l_nested_obj.to_clob()
    );
  end set_output_parameter_object;

  procedure set_output_parameter_object
  ( pi_parameter_name  in varchar2
  , pi_object_json     in clob
  )
  is
    l_json_obj     json_object_t;
    l_nested_obj   json_object_t;
  begin
    -- Initialize main JSON object, falling back to empty object if existing JSON is invalid.
    begin
      if output_parameters is null or output_parameters is not json then
        l_json_obj := json_object_t();
      else
        l_json_obj := json_object_t(output_parameters);
      end if;
    exception
      when others then
        l_json_obj := json_object_t();
    end;
    
    -- Parse payload as object; empty object if null/invalid.
    begin
      if pi_object_json is not null and pi_object_json is json then
        l_nested_obj := json_object_t(pi_object_json);
      else
        l_nested_obj := json_object_t();
      end if;
    exception
      when others then
        l_nested_obj := json_object_t();
    end;
    
    -- Add the nested object to the main object
    l_json_obj.put(pi_parameter_name, l_nested_obj);
    
    -- Update the global variable
    output_parameters := l_json_obj.to_clob();
  end set_output_parameter_object;

  function get_output_parameters
  return flow_subflows.sbfl_task_output_parameters%type
  is
  begin
    return output_parameters;
  end get_output_parameters;

  function input_parameter
  ( pi_parameter_name in varchar2
  ) return varchar2
  is
    l_json_obj json_object_t;
  begin
    if input_parameters is null or input_parameters is not json then
      return null;
    end if;
    
    l_json_obj := json_object_t(input_parameters);
    
    if l_json_obj.has(pi_parameter_name) then
      return l_json_obj.get_string(pi_parameter_name);
    else
      return null;
    end if;
  exception
    when others then
      return null;
  end input_parameter;

  function business_ref
  (pi_scope       flow_subflows.sbfl_scope%type default 0)
  return flow_process_variables.prov_var_vc2%type
  is
  begin
    return flow_proc_vars_int.get_business_ref 
                              ( pi_prcs_id => process_id
                              , pi_scope   => pi_scope
                              );
  end business_ref;

  function business_ref
  (pi_sbfl_id     flow_subflows.sbfl_id%type)
  return flow_process_variables.prov_var_vc2%type
  is
    l_scope     flow_subflows.sbfl_scope%type;
  begin
    l_scope := flow_engine_util.get_scope ( p_process_id => process_id
                                          , p_subflow_id => pi_sbfl_id);             
    return business_ref ( pi_scope   => l_scope );
  end business_ref;

  procedure set_call_origin
  (
    p_origin in varchar2
  )
  as
  begin
    case p_origin
      when 'REST' then
        rest_call := true;
      else
        null;
    end case;
  end set_call_origin;

  procedure unset_call_origin
  as
  begin
    rest_call := false;
  end unset_call_origin;

end flow_globals;
/

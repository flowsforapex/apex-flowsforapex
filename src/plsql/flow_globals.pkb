/* 
-- Flows for APEX - flow_globals.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    25-Aug-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
--
*/

create or replace package body flow_globals
as


  g_error_on_step  boolean := false;  
  -- g_error_on_step starts false when every step is processed but is set true if an error
  -- occurs in the engine during processing.  It is then used to determine whether to 
  -- commit or rollback the engine transaction at the end of step processing
  g_is_recursive_step boolean;
  -- g_recursive_step is set to false for steps that are being performed by the user, and true
  -- for subsequent recursive steps that are performed by the engine (such as gateway steps, scriptTasks, etc.)


  procedure set_context
  ( pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type default null
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type default null
  )
  is
  begin 
    process_id := pi_prcs_id;
    subflow_id := pi_sbfl_id;
    step_key   := pi_step_key;
    scope      := pi_scope;
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

end flow_globals;
/

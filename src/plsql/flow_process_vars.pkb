create or replace package body flow_process_vars as
/* 
-- Flows for APEX - flow_process_vars.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created september-2020  Richard Allen (Flowquest) 
-- Edited  April 2022 - Richard Allen (Oracle)
--
*/
  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);



-- Signature 1a - set varchar2 process variable with known or default scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
)
is 
  l_current     flow_subflows.sbfl_current%type;
  e_bad_scope   exception;
begin
  -- if scope is not 0, validate
  if pi_scope = 0 
  or  flow_proc_vars_int.scope_is_valid (pi_prcs_id => pi_prcs_id, pi_scope => pi_scope) then
    -- call internal set_var signature 1
    flow_proc_vars_int.set_var
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_name     => pi_var_name
      , pi_vc2_value    => pi_vc2_value
      , pi_scope        => pi_scope
      );
  else
    raise e_bad_scope;
  end if;
exception
  when e_bad_scope then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'var-bad-scope'
      , p0 => pi_scope
      , p1 => pi_var_name 
      );
      -- $F4AMESSAGE 'var-bad-scope' || 'Invalid scope (%0) supplied for process variable %1.'  
end set_var;

-- signature 1b - set varchar2 process variable using subflow_id for scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type
, pi_sbfl_id    in flow_subflows.sbfl_id%type 
)
is 
  l_scope       flow_process_variables.prov_scope%type;
  l_current     flow_subflows.sbfl_current%type;
begin
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
       , sbfl.sbfl_current
    into l_scope
       , l_current
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  -- call internal set_var signature 1
  flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_var_name     => pi_var_name
    , pi_vc2_value    => pi_vc2_value
    , pi_scope        => l_scope
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => l_current
    );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_prcs_id
      , p1 => pi_sbfl_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end set_var;

-- Signature 2a - set number process variable with known or default scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_num_value  in flow_process_variables.prov_var_num%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
)
is 
  l_current     flow_subflows.sbfl_current%type;
  e_bad_scope   exception;
begin
  -- if scope is not 0, validate
  if pi_scope = 0 
  or  flow_proc_vars_int.scope_is_valid (pi_prcs_id => pi_prcs_id, pi_scope => pi_scope) then
    -- call internal set_var signature 2
    flow_proc_vars_int.set_var
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_name     => pi_var_name
      , pi_num_value    => pi_num_value
      , pi_scope        => pi_scope
      );
  else
    raise e_bad_scope;
  end if;
exception
  when e_bad_scope then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'var-bad-scope'
      , p0 => pi_scope
      , p1 => pi_var_name 
      );
      -- $F4AMESSAGE 'var-bad-scope' || 'Invalid scope (%0) supplied for process variable %1.'  
end set_var;

-- signature 2b - set number process variable using subflow_id for scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_num_value  in flow_process_variables.prov_var_num%type
, pi_sbfl_id    in flow_subflows.sbfl_id%type 
)
is 
  l_scope       flow_process_variables.prov_scope%type;
  l_current     flow_subflows.sbfl_current%type;
begin
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
       , sbfl.sbfl_current
    into l_scope
       , l_current
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  -- call internal set_var signature 2
  flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_var_name     => pi_var_name
    , pi_num_value    => pi_num_value
    , pi_scope        => l_scope
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => l_current
    );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end set_var;

-- Signature 3a - set date process variable with known or default scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
)
is 
  l_current     flow_subflows.sbfl_current%type;
  e_bad_scope   exception;
begin
  if pi_scope = 0 
  or  flow_proc_vars_int.scope_is_valid (pi_prcs_id => pi_prcs_id, pi_scope => pi_scope) then
    -- call internal set_var signature 3
    flow_proc_vars_int.set_var
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_name     => pi_var_name
      , pi_date_value   => pi_date_value
      , pi_scope        => pi_scope
      );
  else
    raise e_bad_scope;
  end if;
exception
  when e_bad_scope then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'var-bad-scope'
      , p0 => pi_scope
      , p1 => pi_var_name 
      );
      -- $F4AMESSAGE 'var-bad-scope' || 'Invalid scope (%0) supplied for process variable %1.'  
end set_var;

-- signature 3b - set date process variable using subflow_id for scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_sbfl_id    in flow_subflows.sbfl_id%type 
)
is 
  l_scope       flow_process_variables.prov_scope%type;
  l_current     flow_subflows.sbfl_current%type;
begin
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
       , sbfl.sbfl_current
    into l_scope
       , l_current
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  -- call internal set_var signature 3
  flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_var_name     => pi_var_name
    , pi_date_value   => pi_date_value
    , pi_scope        => l_scope
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => l_current
    );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end set_var;

-- Signature 4a - set CLOB process variable with known or default scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
)
is 
  l_current     flow_subflows.sbfl_current%type;
  e_bad_scope   exception;
begin
  -- if scope is not 0, validate
  if pi_scope = 0 
  or  flow_proc_vars_int.scope_is_valid (pi_prcs_id => pi_prcs_id, pi_scope => pi_scope) then
    -- call internal set_var signature 4
    flow_proc_vars_int.set_var
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_name     => pi_var_name
      , pi_clob_value   => pi_clob_value
      , pi_scope        => pi_scope
      );
  else
    raise e_bad_scope;
  end if;
exception
  when e_bad_scope then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'var-bad-scope'
      , p0 => pi_scope
      , p1 => pi_var_name 
      );
      -- $F4AMESSAGE 'var-bad-scope' || 'Invalid scope (%0) supplied for process variable %1.'  
end set_var;

-- signature 4b - set CLOB process variable using subflow_id for scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_clob_value  in flow_process_variables.prov_var_clob%type
, pi_sbfl_id    in flow_subflows.sbfl_id%type 
)
is 
  l_scope       flow_process_variables.prov_scope%type;
  l_current     flow_subflows.sbfl_current%type;
begin
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
       , sbfl.sbfl_current
    into l_scope
       , l_current
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  -- call internal set_var signature 4
  flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_var_name     => pi_var_name
    , pi_clob_value   => pi_clob_value
    , pi_scope        => l_scope
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => l_current
    );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end set_var;

-- Signature 5a - set timestamp process variable with known or default scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_tstz_value   in flow_process_variables.prov_var_tstz%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
)
is 
  l_current     flow_subflows.sbfl_current%type;
  e_bad_scope   exception;
begin
  if pi_scope = 0 
  or  flow_proc_vars_int.scope_is_valid (pi_prcs_id => pi_prcs_id, pi_scope => pi_scope) then
    -- call internal set_var signature 3
    flow_proc_vars_int.set_var
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_name     => pi_var_name
      , pi_tstz_value   => pi_tstz_value
      , pi_scope        => pi_scope
      );
  else
    raise e_bad_scope;
  end if;
exception
  when e_bad_scope then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'var-bad-scope'
      , p0 => pi_scope
      , p1 => pi_var_name 
      );
      -- $F4AMESSAGE 'var-bad-scope' || 'Invalid scope (%0) supplied for process variable %1.'  
end set_var;

-- signature 5b - set timestamp process variable using subflow_id for scope

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_tstz_value in flow_process_variables.prov_var_tstz%type
, pi_sbfl_id    in flow_subflows.sbfl_id%type 
)
is 
  l_scope       flow_process_variables.prov_scope%type;
  l_current     flow_subflows.sbfl_current%type;
begin
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
       , sbfl.sbfl_current
    into l_scope
       , l_current
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  -- call internal set_var signature 5
  flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_var_name     => pi_var_name
    , pi_tstz_value   => pi_tstz_value
    , pi_scope        => l_scope
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => l_current
    );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end set_var;

-- getters return

-- get_var_vc2:  varchar2 type - signature 1 - scope (or no scope) supplied

function get_var_vc2
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_scope              in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_vc2%type
is 
begin
  return flow_proc_vars_int.get_var_vc2
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_vc2;

-- get_var_vc2:  varchar2 type - signature 2 - subflow_id supplied

function get_var_vc2
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_sbfl_id            in flow_subflows.sbfl_id%type
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_vc2%type
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_vc2
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_vc2;

-- get_var_num:  number type - signature 1 - scope (or no scope) supplied

function get_var_num
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_scope              in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_num%type
is 
begin
  return flow_proc_vars_int.get_var_num
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_num;

-- get_var_num:  number type - signature 2 - subflow_id supplied

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type
is
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_num
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_num;

-- get_var_date: date type - signature 1 - scope (or no scope) supplied

function get_var_date
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_scope              in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_date%type
is 
begin
  return flow_proc_vars_int.get_var_date
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_date;

-- get_var_date: date type - signature 2 - subflow_id supplied

function get_var_date
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_date%type
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_date
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_date;

-- get_var_CLOB:  CLOB type - signature 1 - scope (or no scope) supplied

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type
is 
begin
  return flow_proc_vars_int.get_var_clob
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_clob;

-- get_var_CLOB:  CLOB type - signature 2 - subflow_id supplied

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_clob
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_clob;

-- get_var_date: timestamp type - signature 1 - scope (or no scope) supplied

function get_var_tstz
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_scope              in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_tstz%type
is 
begin
  return flow_proc_vars_int.get_var_tstz
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_tstz;

-- get_var_date: timestamp type - signature 2 - subflow_id supplied

function get_var_tstz
( pi_prcs_id            in flow_processes.prcs_id%type
, pi_var_name           in flow_process_variables.prov_var_name%type
, pi_sbfl_id            in flow_subflows.sbfl_id%type
, pi_exception_on_null  in boolean default false
) return flow_process_variables.prov_var_tstz%type
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_tstz
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_tstz;

-- get type of a variable - signature 1 - with scope including default scope

function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type
is 
begin
  return flow_proc_vars_int.get_var_type
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
end get_var_type;

-- get_var_type - signature 2 - subflow_id supplied

function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  return flow_proc_vars_int.get_var_type
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              , pi_exception_on_null  => pi_exception_on_null
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
    raise;
end get_var_type;

-- delete a variable - signature 1 - with scope including default scope

procedure delete_var 
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is
begin
  flow_proc_vars_int.delete_var
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => pi_scope
              );
end delete_var;

-- get_var_type - signature 2 - subflow_id supplied

procedure delete_var 
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
)
is 
  l_scope       flow_process_variables.prov_scope%type;
begin 
  -- get the scope and current object for the supplied subflow
  select sbfl.sbfl_scope
    into l_scope
    from flow_subflows sbfl
   where sbfl.sbfl_id = pi_sbfl_id
     and sbfl.sbfl_prcs_id = pi_prcs_id
  ;
  flow_proc_vars_int.delete_var
              ( pi_prcs_id            => pi_prcs_id
              , pi_var_name           => pi_var_name
              , pi_scope              => l_scope
              );
exception
  when no_data_found then
    flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_sbfl_id     => pi_sbfl_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => pi_sbfl_id
      , p1 => pi_prcs_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
end delete_var;


-- special cases / built-in standard variables

-- set_business_ref - signature 1 - in scope 0 or in a known scope

  procedure set_business_ref
  ( pi_prcs_id    in flow_processes.prcs_id%type
  , pi_vc2_value  in flow_process_variables.prov_var_vc2%type
  , pi_scope      in flow_subflows.sbfl_scope%type default 0
  )
  is
  begin
    flow_proc_vars_int.set_business_ref
    ( pi_prcs_id      => pi_prcs_id
    , pi_scope        => pi_scope
    , pi_vc2_value    => pi_vc2_value
    );
  end set_business_ref;

-- set_business_ref - signature 2 - in scope determined by given subflow id

  procedure set_business_ref
  ( pi_prcs_id    in flow_processes.prcs_id%type
  , pi_vc2_value  in flow_process_variables.prov_var_vc2%type
  , pi_sbfl_id    in flow_subflows.sbfl_id%type
  )
  is
    l_scope  flow_subflows.sbfl_scope%type;
  begin
    l_scope := flow_engine_util.get_scope
                 ( p_process_id => pi_prcs_id
                 , p_subflow_id => pi_sbfl_id
                 );
    flow_proc_vars_int.set_business_ref
    ( pi_prcs_id      => pi_prcs_id
    , pi_scope        => l_scope
    , pi_vc2_value    => pi_vc2_value
    );
  end set_business_ref;

-- get_business_ref - signature 1 - in scope 0 or in a known scope

  function get_business_ref
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_scope in flow_subflows.sbfl_scope%type default 0
  )
  return flow_process_variables.prov_var_vc2%type
  is 
  begin
    return flow_proc_vars_int.get_business_ref 
           ( pi_prcs_id => pi_prcs_id
           , pi_scope   => pi_scope
           );
  end get_business_ref;

-- get_business_ref - signature 2 - in scope determined by given subflow id

  function get_business_ref
  ( pi_prcs_id    in flow_processes.prcs_id%type
  , pi_sbfl_id    in flow_subflows.sbfl_id%type
  )
  return flow_process_variables.prov_var_vc2%type
  is
    l_scope  flow_subflows.sbfl_scope%type;
  begin
    l_scope := flow_engine_util.get_scope
                 ( p_process_id => pi_prcs_id
                 , p_subflow_id => pi_sbfl_id
                 );
    return flow_proc_vars_int.get_business_ref 
           ( pi_prcs_id => pi_prcs_id
           , pi_scope   => l_scope
           );
  end get_business_ref;

end flow_process_vars;
/

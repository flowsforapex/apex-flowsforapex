create or replace package body flow_proc_vars_int
as

/* 
-- Flows for APEX - flow_proc_vars_int.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright Flowquest Consulting Limited. 2024
--
-- Created    12-Apr-2022  Richard Allen (Oracle)
-- Modified   11-Aug-2022  Moritz Klein (MT AG)
-- Modified   11-jan-2024  Richard Allen (Flowquest Consulting Ltd)
--
*/

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

function scope_is_valid
( pi_prcs_id in flow_processes.prcs_id%type
, pi_scope   in flow_subflows.sbfl_scope%type
) return boolean
is 
  l_count number;
begin
  -- first check if the scope is valid from a call activity
  select count(prdg_id)
    into l_count
    from flow_instance_diagrams
   where prdg_prcs_id = pi_prcs_id
     and prdg_diagram_level = pi_scope;
  -- if not, check if it comes from an iteration
  -- initially check by seeing if a variable already exists in the scope
  -- replace this later with a check on the iteration scopes
  if l_count = 0 then 
    select count (prov_var_name)
      into l_count
      from flow_process_variables
     where prov_prcs_id = pi_prcs_id
       and prov_scope   = pi_scope;
  end if;
  return (l_count > 0);
end;

-- set_var signature 1 - set varchar2

procedure set_var
( pi_prcs_id      in flow_processes.prcs_id%type
, pi_scope        in flow_process_variables.prov_scope%type default 0
, pi_var_name     in flow_process_variables.prov_var_name%type
, pi_vc2_value    in flow_process_variables.prov_var_vc2%type
, pi_sbfl_id      in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set     in flow_object_expressions.expr_set%type default null
)
is 
  l_action  varchar2(20);
begin
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_vc2
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_varchar2 
      , pi_vc2_value
      );      
  exception
    when dup_val_on_index then
      l_action := 'var-update-error';
      update flow_process_variables prov 
         set prov.prov_var_vc2          = pi_vc2_value
       where prov.prov_prcs_id          = pi_prcs_id
         and prov.prov_scope            = pi_scope
         and upper(prov.prov_var_name)  = upper(pi_var_name)
         and prov.prov_var_type         = flow_constants_pkg.gc_prov_var_type_varchar2 
           ;
    when others
    then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_varchar2 
  , p_var_vc2           => pi_vc2_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
    -- $F4AMESSAGE 'var-update-error' || 'Error updating process variable %0 for process id %1 in scope %2.'   
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_num
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_number
      , pi_num_value
      );
  exception
    when dup_val_on_index then
      l_action := 'var-update-error';
      update flow_process_variables prov 
         set prov.prov_var_num          = pi_num_value
       where prov.prov_prcs_id          = pi_prcs_id
         and prov.prov_scope            = pi_scope
         and upper(prov.prov_var_name)  = upper(pi_var_name)
         and prov.prov_var_type         = flow_constants_pkg.gc_prov_var_type_number
           ;
    when others then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_number
  , p_var_num           => pi_num_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
    -- $F4AMESSAGE 'var-update-error' || 'Error updating process variable %0 for process id %1 in scope %2.'   
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_date
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_date
      , pi_date_value
      );
  exception
    when dup_val_on_index then
      l_action := 'var-update-error';
      update flow_process_variables prov 
         set prov.prov_var_date         = pi_date_value
       where prov.prov_prcs_id          = pi_prcs_id
         and prov.prov_scope            = pi_scope
         and upper(prov.prov_var_name)  = upper(pi_var_name)
         and prov.prov_var_type         = flow_constants_pkg.gc_prov_var_type_date
           ;
    when others
    then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_date 
  , p_var_date          => pi_date_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
    -- $F4AMESSAGE 'var-update-error' || 'Error updating process variable %0 for process id %1 in scope %2.'   
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_clob
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_clob
      , pi_clob_value
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_clob          = pi_clob_value
       where prov.prov_prcs_id           = pi_prcs_id
         and prov.prov_scope             = pi_scope
         and upper(prov.prov_var_name)   = upper(pi_var_name)
         and prov.prov_var_type          = flow_constants_pkg.gc_prov_var_type_clob
           ;
    when others then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_clob 
  , p_var_clob           => pi_clob_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_tstz_value in flow_process_variables.prov_var_tstz%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_tstz
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_tstz
      , pi_tstz_value
      );
  exception
    when dup_val_on_index then
      l_action := 'var-update-error';
      update flow_process_variables prov 
         set prov.prov_var_tstz         = pi_tstz_value
       where prov.prov_prcs_id          = pi_prcs_id
         and prov.prov_scope            = pi_scope
         and upper(prov.prov_var_name)  = upper(pi_var_name)
         and prov.prov_var_type         = flow_constants_pkg.gc_prov_var_type_tstz
           ;
    when others
    then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_tstz 
  , p_var_tstz          => pi_tstz_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
    -- $F4AMESSAGE 'var-update-error' || 'Error updating process variable %0 for process id %1 in scope %2.'   
end set_var;

procedure set_var
( pi_prcs_id      in flow_processes.prcs_id%type
, pi_var_name     in flow_process_variables.prov_var_name%type
, pi_json_value   in flow_process_variables.prov_var_json%type
, pi_sbfl_id      in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set     in flow_object_expressions.expr_set%type default null
, pi_scope        in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_json
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_name
      , flow_constants_pkg.gc_prov_var_type_json
      , pi_json_value
      );
  exception
    when dup_val_on_index then
      l_action := 'var-update-error';
      update flow_process_variables prov 
         set prov.prov_var_json         = pi_json_value
       where prov.prov_prcs_id          = pi_prcs_id
         and prov.prov_scope            = pi_scope
         and upper(prov.prov_var_name)  = upper(pi_var_name)
         and prov.prov_var_type         = flow_constants_pkg.gc_prov_var_type_json
           ;
    when others
    then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_json 
  , p_var_json          => pi_json_value
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
    -- $F4AMESSAGE 'var-update-error' || 'Error updating process variable %0 for process id %1 in scope %2.'   
end set_var;

procedure set_var
( pi_prcs_id      in flow_processes.prcs_id%type
, pi_var_name     in flow_process_variables.prov_var_name%type
, pi_json_element in sys.json_element_t
, pi_sbfl_id      in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set     in flow_object_expressions.expr_set%type default null
, pi_scope        in flow_process_variables.prov_scope%type default 0
)
is
  l_json_val      clob;
begin 
  l_json_val := pi_json_element.to_clob;

  set_var
  ( pi_prcs_id      => pi_prcs_id 
  , pi_var_name     => pi_var_name
  , pi_json_value   => l_json_val
  , pi_sbfl_id      => pi_sbfl_id
  , pi_objt_bpmn_id => pi_objt_bpmn_id
  , pi_expr_set     => pi_expr_set
  , pi_scope        => pi_scope 
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => 'var-set-error'         
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_value in t_proc_var_value
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is 
  l_action  varchar2(20);
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_scope
      , prov_var_name
      , prov_var_type
      , prov_var_vc2
      , prov_var_num
      , prov_var_date
      , prov_var_tstz
      , prov_var_clob
      , prov_var_json
      ) values
      ( pi_prcs_id
      , pi_scope
      , pi_var_value.var_name
      , pi_var_value.var_type
      , pi_var_value.var_vc2
      , pi_var_value.var_num
      , pi_var_value.var_date
      , pi_var_value.var_tstz
      , pi_var_value.var_clob
      , pi_var_value.var_json
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_type          = pi_var_value.var_type
           , prov.prov_var_vc2           = pi_var_value.var_vc2
           , prov.prov_var_num           = pi_var_value.var_num
           , prov.prov_var_date          = pi_var_value.var_date
           , prov.prov_var_clob          = pi_var_value.var_clob
           , prov.prov_var_tstz          = pi_var_value.var_tstz
       where prov.prov_prcs_id           = pi_prcs_id
         and prov.prov_scope             = pi_scope
         and upper(prov.prov_var_name)   = upper(pi_var_value.var_name)
      ;
    when others then
      l_action := 'var-set-error';
      raise;
  end;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope
  , p_var_name          => pi_var_value.var_name
  , p_objt_bpmn_id      => pi_objt_bpmn_id
  , p_subflow_id        => pi_sbfl_id
  , p_expr_set          => pi_expr_set
  , p_var_type          => pi_var_value.var_type 
  , p_var_vc2           => pi_var_value.var_vc2
  , p_var_num           => pi_var_value.var_num
  , p_var_date          => pi_var_value.var_date
  , p_var_clob          => pi_var_value.var_clob
  , p_var_tstz          => pi_var_value.var_tstz
  , p_var_json          => pi_var_value.var_json
  );
exception
  when others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_sbfl_id        => pi_sbfl_id
    , pi_message_key    => l_action         
    , p0 => pi_var_value.var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-set-error' || 'Error setting process variable %0 for process id %1 in scope %2.'
end set_var;

-- getters return

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_vc2%type
is 
   po_vc2_value  flow_process_variables.prov_var_vc2%type;
begin 
   select prov.prov_var_vc2
     into po_vc2_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_vc2_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
    -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_vc2;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type
is 
   po_num_value  flow_process_variables.prov_var_num%type;
begin 
   select prov.prov_var_num
     into po_num_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_num_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_num;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_date%type
is 
   po_date_value  flow_process_variables.prov_var_date%type;
begin 
   select prov.prov_var_date
     into po_date_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_date_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_date;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type
is 
   po_clob_value  flow_process_variables.prov_var_clob%type;
begin 
   select prov.prov_var_clob
     into po_clob_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_clob_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_clob;

function get_var_tstz
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_tstz%type
is 
   po_tstz_value  flow_process_variables.prov_var_tstz%type;
begin 
   select prov.prov_var_tstz
     into po_tstz_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_tstz_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_tstz;

function get_var_json
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_json%type
is 
   po_json_value  flow_process_variables.prov_var_json%type;
begin 
   select prov.prov_var_json
     into po_json_value
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return po_json_value;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_json;

function get_var_json_element
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return sys.json_element_t
is 
   l_json_value   flow_process_variables.prov_var_json%type;
begin 
   l_json_value := get_var_json ( pi_prcs_id            => pi_prcs_id
                                , pi_var_name           => pi_var_name
                                , pi_scope              => pi_scope
                                , pi_exception_on_null  => pi_exception_on_null
                                );
   return sys.json_element_t.parse(l_json_value);
end get_var_json_element;

function get_var_value
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return t_proc_var_value
is 
   l_value_rec  t_proc_var_value;
begin 
   select prov.prov_var_name
        , prov.prov_var_type
        , prov.prov_var_vc2
        , prov.prov_var_num
        , prov.prov_var_date
        , prov.prov_var_clob
        , prov.prov_var_tstz
        , prov.prov_var_json
     into l_value_rec
     from flow_process_variables prov
    where prov.prov_prcs_id         = pi_prcs_id
      and prov.prov_scope           = pi_scope
      and upper(prov.prov_var_name) = upper(pi_var_name)
        ;
   return l_value_rec;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_value;

-- get type of a variable

function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type
is 
   l_var_type  flow_process_variables.prov_var_clob%type;
begin 
   select prov.prov_var_type
     into l_var_type
     from flow_process_variables prov
    where prov.prov_prcs_id           = pi_prcs_id
      and prov.prov_scope             = pi_scope
      and upper(prov.prov_var_name)   = upper(pi_var_name)
        ;
   return l_var_type;
exception
  when no_data_found then
    if pi_exception_on_null then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-get-error'      
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-get-error' || 'Error getting process variable %0 for process id %1 with scope %2.'
      raise;
    else
      return null;
    end if;
end get_var_type;

-- delete a variable

procedure delete_var 
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
)
is
  l_var_type   flow_process_variables.prov_var_type%type;
begin 
  select prov_var_type
    into l_var_type
    from flow_process_variables prov
   where prov.prov_prcs_id          = pi_prcs_id
     and prov.prov_scope            = pi_scope
     and upper(prov.prov_var_name)  = upper(pi_var_name)
     for update wait 2;

  delete 
    from flow_process_variables prov
   where prov.prov_prcs_id          = pi_prcs_id
     and prov.prov_scope            = pi_scope
     and upper(prov.prov_var_name)  = upper(pi_var_name)
  ;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope               
  , p_var_name          => pi_var_name
  , p_var_type          => l_var_type
  );
exception
  when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'var-delete-error'        
      , p0 => pi_var_name
      , p1 => pi_prcs_id
      , p2 => pi_scope
      );
      -- $F4AMESSAGE 'var-delete-error' || 'Error deleting process variable %0 for process id %1 with scope %2.'
  when lock_timeout then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_message_key    => 'var-lock-error'       
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-lock-error' || 'Error locking process variable %0 for process id %1.'
end delete_var;

-- special cases / built-in standard variables

  procedure set_business_ref
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_vc2_value in flow_process_variables.prov_var_vc2%type
  , pi_scope in flow_subflows.sbfl_scope%type default 0
  , pi_sbfl_id in flow_subflows.sbfl_id%type default null
  , pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
  , pi_expr_set in flow_object_expressions.expr_set%type default null
  )
  is
  begin
    flow_proc_vars_int.set_var
    ( pi_prcs_id      => pi_prcs_id
    , pi_scope        => pi_scope 
    , pi_var_name     => flow_constants_pkg.gc_prov_builtin_business_ref
    , pi_vc2_value    => pi_vc2_value
    , pi_sbfl_id      => pi_sbfl_id
    , pi_objt_bpmn_id => pi_objt_bpmn_id
    , pi_expr_set     => pi_expr_set
    );
  end set_business_ref;

  function get_business_ref
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_scope   in flow_subflows.sbfl_scope%type default 0
  )
  return flow_process_variables.prov_var_vc2%type
  is 
  begin
    return get_var_vc2 
           ( pi_prcs_id  => pi_prcs_id
           , pi_var_name => flow_constants_pkg.gc_prov_builtin_business_ref
           , pi_scope    => pi_scope
           );
  end get_business_ref;

function lock_var 
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
) return boolean
is
  l_is_locked   boolean;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  select prov_prcs_id
    into l_prcs_id
    from flow_process_variables
   where prov_prcs_id  = pi_prcs_id
     and upper(prov_var_name)  = upper(pi_var_name)
     and prov_scope    = pi_scope
  for update of prov_var_type wait 2;
  return true;
exception
  when  others then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_message_key    => 'var-lock-error'       
    , p0 => pi_var_name
    , p1 => pi_prcs_id
    , p2 => pi_scope
    );
    -- $F4AMESSAGE 'var-lock-error' || 'Error locking process variable %0 for process id %1.'
    return false;
end lock_var;

  procedure set_vars_from_json_object
  ( pi_prcs_id      in  flow_processes.prcs_id%type
  , pi_sbfl_id      in  flow_subflows.sbfl_id%type default null
  , pi_scope        in  flow_subflows.sbfl_scope%type default 0
  , pi_json         in  sys.json_object_t
  , pi_objt_bpmn_id in  flow_objects.objt_bpmn_id%type default null
  )
  is
    l_key               varchar2(4000);
    l_keys              json_key_list;
    l_element_type      varchar2(50);
    l_var               t_proc_var_value;
  begin
    l_keys := pi_json.get_keys;

    for i in 1..l_keys.count loop
      l_var             := t_proc_var_value();

      l_var.var_name     := l_keys(i);

      l_element_type := pi_json.get_type(l_keys(i));

      apex_debug.info
      ( p_message => 'Creating proc var name %0 Json type %1'
      , p0        => l_var.var_name
      , p1        => l_element_type
      );

      case l_element_type
      when 'SCALAR' then 
        case 
        when pi_json.get(l_keys(i)).is_string then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_varchar2;
          l_var.var_vc2   := pi_json.get_string(l_keys(i));
        when pi_json.get(l_keys(i)).is_number then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_number;
          l_var.var_num   := pi_json.get_number(l_keys(i));      
        when pi_json.get(l_keys(i)).is_date then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_date;
          l_var.var_date  := pi_json.get_date(l_keys(i));  
        when pi_json.get(l_keys(i)).is_timestamp then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_tstz;
          l_var.var_tstz  := pi_json.get_timestamp(l_keys(i));  
        end case;
      when 'OBJECT' then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_json;
          l_var.var_json  := pi_json.get_object(l_keys(i)).to_clob;
      when 'ARRAY' then
          l_var.var_type  := flow_constants_pkg.gc_prov_var_type_json;
          l_var.var_json   := pi_json.get_array(l_keys(i)).to_clob;
      end case;

      apex_debug.info
      ( p_message => 'Creating proc var name %0 Proc var type %1'
      , p0        => l_var.var_name
      , p1        => l_var.var_type
      );

      set_var 
      ( pi_prcs_id      => pi_prcs_id
      , pi_var_value    => l_var
      , pi_sbfl_id      => pi_sbfl_id
      , pi_objt_bpmn_id => pi_objt_bpmn_id
      , pi_expr_set     => 'Iteration '|| to_char(i,'9999')
      , pi_scope        => pi_scope
      );
    end loop;
  end set_vars_from_json_object;

-- group delete for all vars in a process (used at process deletion, process reset)

  procedure delete_all_for_process
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_retain_builtins in boolean default false
  )
  is
  begin
    if pi_retain_builtins then 
      delete
        from flow_process_variables prov
       where prov.prov_prcs_id = pi_prcs_id
         and prov.prov_var_name not in ( flow_constants_pkg.gc_prov_builtin_business_ref )
      ;
    else
      delete
        from flow_process_variables prov
       where prov.prov_prcs_id = pi_prcs_id
      ;
    end if;
  end delete_all_for_process;

  procedure do_substitution
  (
    pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type
  , pi_scope    in flow_subflows.sbfl_scope%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pio_string  in out nocopy varchar2
  )
  as
    l_f4a_substitutions apex_t_varchar2;
    l_replacement_value flow_types_pkg.t_bpmn_attribute_vc2;
  
    function get_replacement_pattern
    (
      pi_substitution_variable in varchar2
    ) return varchar2
    as
    begin
      return
        flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier || 
        pi_substitution_variable || flow_constants_pkg.gc_substitution_postfix
      ;
    end get_replacement_pattern;
  begin
    l_f4a_substitutions :=
      apex_string.grep
      (
        p_str           => pio_string
      , p_pattern       => flow_constants_pkg.gc_substitution_pattern
      , p_modifier      => 'i'
      , p_subexpression => '1'
      )
    ;
    if l_f4a_substitutions is not null then
      for i in 1..l_f4a_substitutions.count
      loop
        case upper(l_f4a_substitutions(i))
          when flow_constants_pkg.gc_substitution_process_id then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_prcs_id );
          when flow_constants_pkg.gc_substitution_subflow_id then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_sbfl_id );
          when flow_constants_pkg.gc_substitution_step_key then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_step_key );
          when flow_constants_pkg.gc_substitution_process_priority then
            pio_string := replace ( pio_string
                                  , get_replacement_pattern( l_f4a_substitutions(i) )
                                  , flow_instances.priority (p_process_id => pi_prcs_id)
                                  );
          else
            -- own implementation of get_vc_var
            -- Reason:
            -- The general implementation immediately adds to APEX error stack
            begin
              select prov.prov_var_vc2
                into l_replacement_value
                from flow_process_variables prov
               where prov.prov_prcs_id          = pi_prcs_id
                 and prov.prov_scope            = pi_scope
                 and upper(prov.prov_var_name)  = upper(l_f4a_substitutions(i))
              ;
              pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), l_replacement_value );
            exception
              when no_data_found then
                -- no data found will be ignored
                -- do like APEX and leave original in place
                null;
            end;
        end case;
      end loop;
    end if;
  end do_substitution;

  procedure do_substitution
  (
    pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pio_string  in out nocopy clob
  )
  as
    l_f4a_substitutions apex_t_varchar2;
    l_replacement_value flow_types_pkg.t_bpmn_attribute_vc2;
  
    function get_replacement_pattern
    (
      pi_substitution_variable in varchar2
    ) return varchar2
    as
    begin
      return
        flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier || 
        pi_substitution_variable || flow_constants_pkg.gc_substitution_postfix
      ;
    end get_replacement_pattern;
  begin
    l_f4a_substitutions :=
      apex_string.grep
      (
        p_str           => pio_string
      , p_pattern       => flow_constants_pkg.gc_substitution_pattern
      , p_modifier      => 'i'
      , p_subexpression => '1'
      )
    ;
    if l_f4a_substitutions is not null then
      for i in 1..l_f4a_substitutions.count
      loop
        case upper(l_f4a_substitutions(i))
          when flow_constants_pkg.gc_substitution_process_id then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_prcs_id );
          when flow_constants_pkg.gc_substitution_subflow_id then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_sbfl_id );
          when flow_constants_pkg.gc_substitution_step_key then
            pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), pi_step_key );
          when flow_constants_pkg.gc_substitution_process_priority then
            pio_string := replace ( pio_string
                                  , get_replacement_pattern( l_f4a_substitutions(i) )
                                  , flow_instances.priority (p_process_id => pi_prcs_id)
                                  );
          else
            l_replacement_value :=
              get_var_as_vc2
              (
                pi_prcs_id           => pi_prcs_id
              , pi_var_name          => l_f4a_substitutions(i)
              , pi_scope             => pi_scope
              , pi_exception_on_null => false
              );
            if l_replacement_value is not null then
              pio_string := replace( pio_string, get_replacement_pattern( l_f4a_substitutions(i) ), l_replacement_value );
            end if;
        end case;
      end loop;
    end if;
  end do_substitution;

/*
  procedure get_var_as_parameter
  (
    pi_prcs_id            in flow_process_variables.prov_prcs_id%type
  , pi_var_name           in flow_process_variables.prov_var_name%type
  , pi_scope              in flow_process_variables.prov_scope%type
  , pi_exception_on_null  in boolean default true
  , po_data_type         out apex_exec.t_data_type
  , po_value             out apex_exec.t_value
  )
  as
  begin
    select case prov.prov_var_type
             when flow_constants_pkg.gc_prov_var_type_varchar2 then 1
             when flow_constants_pkg.gc_prov_var_type_number   then 2
             when flow_constants_pkg.gc_prov_var_type_date     then 3
             when flow_constants_pkg.gc_prov_var_type_clob     then 11
             when flow_constants_pkg.gc_prov_var_type_tstz     then 5
             else 1
           end as data_type
         , prov.prov_var_vc2
         , prov.prov_var_num
         , prov.prov_var_date
         , prov.prov_var_clob
      into po_data_type
         , po_value.varchar2_value
         , po_value.number_value
         , po_value.date_value
         , po_value.clob_value
      from flow_process_variables prov
     where prov.prov_prcs_id    = pi_prcs_id
       and prov.prov_scope      = pi_scope
       and upper(prov_var_name) = upper(pi_var_name)
    ;
  exception
    when no_data_found then
      if pi_exception_on_null then
        flow_errors.handle_instance_error
        ( 
          pi_prcs_id     => pi_prcs_id
        , pi_message_key => 'var-get-error'      
        , p0             => pi_var_name
        , p1             => pi_prcs_id
        , p2             => pi_scope
        );
      end if;
  end get_var_as_parameter;
  */

  function get_var_as_parameter
  (
    pi_prcs_id            in flow_process_variables.prov_prcs_id%type
  , pi_var_name           in flow_process_variables.prov_var_name%type
  , pi_scope              in flow_process_variables.prov_scope%type
  , pi_exception_on_null  in boolean default true
  ) return apex_exec.t_parameter 
  is 
    l_parameter          apex_exec.t_parameter := apex_exec.t_parameter();
  begin
    begin
      select case prov.prov_var_type
               when flow_constants_pkg.gc_prov_var_type_varchar2 then apex_exec.c_data_type_varchar2
               when flow_constants_pkg.gc_prov_var_type_number   then apex_exec.c_data_type_number
               when flow_constants_pkg.gc_prov_var_type_date     then apex_exec.c_data_type_date
               when flow_constants_pkg.gc_prov_var_type_tstz     then apex_exec.c_data_type_timestamp_tz
               when flow_constants_pkg.gc_prov_var_type_clob     then apex_exec.c_data_type_clob
               when flow_constants_pkg.gc_prov_var_type_json     then apex_exec.c_data_type_json
               else 1
             end as data_type
           , prov.prov_var_vc2
           , prov.prov_var_num
           , prov.prov_var_date
           , prov.prov_var_tstz
           , case prov.prov_var_type
               when flow_constants_pkg.gc_prov_var_type_clob     then prov.prov_var_clob
               when flow_constants_pkg.gc_prov_var_type_json     then prov.prov_var_json
               else null
             end 
           , upper(prov.prov_var_name)
        into l_parameter.data_type
           , l_parameter.value.varchar2_value
           , l_parameter.value.number_value
           , l_parameter.value.date_value
           , l_parameter.value.timestamp_tz_value
           , l_parameter.value.clob_value
           , l_parameter.name
        from flow_process_variables prov
       where prov.prov_prcs_id    = pi_prcs_id
         and prov.prov_scope      = pi_scope
         and upper(prov_var_name) = upper(pi_var_name)
      ;
    exception
      when no_data_found then
        if pi_exception_on_null then
          flow_errors.handle_instance_error
          ( 
            pi_prcs_id     => pi_prcs_id
          , pi_message_key => 'var-get-error'      
          , p0             => pi_var_name
          , p1             => pi_prcs_id
          , p2             => pi_scope
          );
        end if;
    end;
    return l_parameter;
  end get_var_as_parameter;

  function get_var_as_vc2
  (
    pi_prcs_id           in flow_process_variables.prov_prcs_id%type
  , pi_var_name          in flow_process_variables.prov_var_name%type
  , pi_scope             in flow_process_variables.prov_scope%type
  , pi_exception_on_null in boolean default true
  ) return varchar2
  as
    l_return flow_process_variables.prov_var_vc2%type;
  begin
    select case prov.prov_var_type
             when flow_constants_pkg.gc_prov_var_type_varchar2 then prov.prov_var_vc2
             when flow_constants_pkg.gc_prov_var_type_number   then to_char(prov.prov_var_num)
             when flow_constants_pkg.gc_prov_var_type_date     then to_char(prov.prov_var_date, flow_constants_pkg.gc_prov_default_date_format)
             when flow_constants_pkg.gc_prov_var_type_tstz     then to_char(prov.prov_var_tstz, flow_constants_pkg.gc_prov_default_tstz_format)
             else null
           end as prov_var_value
      into l_return
      from flow_process_variables prov
     where prov.prov_prcs_id    = pi_prcs_id
       and prov.prov_scope      = pi_scope
       and upper(prov_var_name) = upper(pi_var_name)
    ;

    return l_return;
  exception
    when no_data_found then
      if pi_exception_on_null then
        flow_errors.handle_instance_error
        ( 
          pi_prcs_id     => pi_prcs_id
        , pi_message_key => 'var-get-error'      
        , p0             => pi_var_name
        , p1             => pi_prcs_id
        , p2             => pi_scope
        );
      else
        return null;
      end if;
  end get_var_as_vc2;

  function get_bind_list
  (
    pi_expr in clob
  , pi_prcs_id  in  flow_processes.prcs_id%type
  , pi_sbfl_id  in  flow_subflows.sbfl_id%type
  , pi_scope    in  flow_subflows.sbfl_scope%type
  ) return apex_plugin_util.t_bind_list
  is
    l_bind                  apex_plugin_util.t_bind;
    l_bind_list             apex_plugin_util.t_bind_list;
    l_var_list              apex_t_varchar2 := apex_t_varchar2();
    l_indx                  pls_integer;
  begin
    l_bind_list := apex_plugin_util.c_empty_bind_list;
    l_var_list  := apex_string.grep 
                ( p_str => pi_expr
                , p_pattern =>  flow_constants_pkg.gc_bind_pattern
                , p_modifier => 'i'
                , p_subexpression => '1'
                );
    if l_var_list is not null then
      l_indx := l_var_list.first;
      -- create bind list and get bind values
      apex_debug.info('Expression : ' ||pi_expr|| ' Contains Bind Tokens : '|| apex_string.join(l_var_list, ':'));
      while l_indx is not null 
      loop
        l_bind.name  := flow_constants_pkg.gc_substitution_flow_identifier || l_var_list(l_indx);
        case upper(l_var_list(l_indx))
          when flow_constants_pkg.gc_substitution_process_id then
            l_bind.value := pi_prcs_id;
          when flow_constants_pkg.gc_substitution_subflow_id then
            l_bind.value := pi_sbfl_id;
          when flow_constants_pkg.gc_substitution_scope then
            l_bind.value := pi_scope;   
          when flow_constants_pkg.gc_substitution_process_priority then
            l_bind.value := flow_instances.priority (p_process_id => pi_prcs_id);   
          else  
            l_bind.value := get_var_as_vc2
                          ( pi_prcs_id            => pi_prcs_id
                          , pi_var_name           => l_var_list(l_indx)
                          , pi_scope              => pi_scope
                          , pi_exception_on_null  => false
                          );
          end case;

        apex_debug.info (p_message => 'bind variables found : %0 value : %1 scope : %2 '
          , p0 => l_bind.name
          , p1 => l_bind.value
          , p2 => pi_scope
          );                              
        l_bind_list(l_indx) := l_bind;
        l_indx := l_var_list.next (l_indx);
      end loop; 
    end if;
    return l_bind_list;
  end get_bind_list; 

  function get_parameter_list
  (
    pi_expr     in  varchar2
  , pi_prcs_id  in  flow_processes.prcs_id%type
  , pi_sbfl_id  in  flow_subflows.sbfl_id%type
  , pi_scope    in  flow_subflows.sbfl_scope%type
  , pi_state_params   in  apex_exec.t_parameters default apex_exec.c_empty_parameters
  ) return apex_exec.t_parameters
  is
    l_parameter             apex_exec.t_parameter;
    l_parameters            apex_exec.t_parameters;
    l_var_list              apex_t_varchar2 := apex_t_varchar2();
    l_indx                  pls_integer;
    l_bind_name             apex_exec.t_column_name;

    function check_state_params
    ( pi_state_params  in  apex_exec.t_parameters default apex_exec.c_empty_parameters
    , pi_var           in  varchar2    
    ) return apex_exec.t_parameter
    is 
      l_value     apex_exec.t_parameter;
    begin
      for i in pi_state_params.first..pi_state_params.last loop
        if upper(pi_var) = pi_state_params(i).name then
          apex_debug.message ('Found State Param %0', p0=> pi_var);
          return pi_state_params(i);
        end if;
      end loop;
      return null;
    end check_state_params;

  begin
    l_parameters := apex_exec.t_parameters();
    apex_debug.info('t_parameters initialised');
    l_var_list  := apex_string.grep 
                ( p_str => pi_expr
                , p_pattern =>  flow_constants_pkg.gc_bind_pattern
                , p_modifier => 'i'
                , p_subexpression => '1'
                );
    if l_var_list is not null then
      l_indx := l_var_list.first;
      -- create bind list and get bind values
      apex_debug.info('Expression : ' ||pi_expr|| ' Contains Bind Tokens : '|| apex_string.join(l_var_list, ':'));
      while l_indx is not null 
      loop
        l_parameter.name  := flow_constants_pkg.gc_substitution_flow_identifier || l_var_list(l_indx);
        l_bind_name := upper(l_var_list(l_indx));
        case 
          when l_bind_name = flow_constants_pkg.gc_substitution_process_id then
            l_parameter.value.number_value  := pi_prcs_id;
            l_parameter.data_type           := apex_exec.c_data_type_number;
          when l_bind_name = flow_constants_pkg.gc_substitution_subflow_id then
            l_parameter.value.number_value  := pi_sbfl_id;
            l_parameter.data_type           := apex_exec.c_data_type_number;
          when l_bind_name = flow_constants_pkg.gc_substitution_scope then
            l_parameter.value.number_value  := pi_scope;
            l_parameter.data_type           := apex_exec.c_data_type_number;      
          when l_bind_name = flow_constants_pkg.gc_substitution_process_priority then
            l_parameter.value.number_value  := flow_instances.priority (p_process_id => pi_prcs_id);
            l_parameter.data_type           := apex_exec.c_data_type_number;   
          when l_bind_name  in ( flow_constants_pkg.gc_substitution_loop_counter 
                               , flow_constants_pkg.gc_substitution_total_instances
                               , flow_constants_pkg.gc_substitution_active_instances
                               , flow_constants_pkg.gc_substitution_completed_instances
                               , flow_constants_pkg.gc_substitution_terminated_instances ) then
            l_parameter := check_state_params ( pi_state_params => pi_state_params
                                              , pi_var => upper(l_var_list(l_indx)));  
            l_parameter.name := flow_constants_pkg.gc_substitution_flow_identifier||l_parameter.name;                            
          else  
            l_parameter := get_var_as_parameter
                          ( pi_prcs_id            => pi_prcs_id
                          , pi_var_name           => l_var_list(l_indx) 
                          , pi_scope              => pi_scope
                          , pi_exception_on_null  => false
                          );
            l_parameter.name := flow_constants_pkg.gc_substitution_flow_identifier||l_parameter.name;
          end case;

        apex_debug.info (p_message => 'bind variables found : %0 scope : %5 data type: %2 numvalue : %1  dateval : %3 vc2val : %4'
          , p0 => l_parameter.name
          , p1 => to_char(l_parameter.value.number_value)
          , p2 => l_parameter.data_type
          , p3 => to_char(l_parameter.value.date_value)
          , p4 => l_parameter.value.varchar2_value
          , p5 => pi_scope
          );                              
        l_parameters(l_indx) := l_parameter;
        l_indx := l_var_list.next (l_indx);
      end loop; 
    else
      apex_debug.info('Parameter list is empty');
    end if;
    return l_parameters;
  end get_parameter_list; 

  function get_vars_as_json_object
  ( pi_prcs_id   in flow_processes.prcs_id%type
  , pi_scope     in flow_subflows.sbfl_scope%type
  , pi_var_list  in flow_types_pkg.t_bpmn_attribute_vc2
  ) return sys.json_object_t
  is
    l_var_list   apex_t_varchar2;
    l_var_value  t_proc_var_value;
    l_var_obj    sys.json_object_t;
  begin
    apex_debug.enter ( 'get_vars_as_json_object'
    ,'pi_prcs_id', pi_prcs_id
    ,'pi_scope', pi_scope
    ,'pi_var_list', pi_var_list
    );
    -- split var list
    l_var_list := apex_string.split ( p_str => pi_var_list, p_sep => ':');

    l_var_obj := new sys.json_object_t;
    if l_var_list.count > 0 then 
      for i in l_var_list.first..l_var_list.last Loop
        apex_debug.message ('Var name %0', p0 => l_var_list(i));
        l_var_value := get_var_value  ( pi_prcs_id   => pi_prcs_id
                                      , pi_var_name  => l_var_list(i)
                                      , pi_scope     => pi_scope
                                      );
        apex_debug.message ('Var type: %0 vc2: %1 num: %2', 
        p0 => l_var_value.var_type, p1 => l_var_value.var_vc2, p2 => l_var_value.var_num
        );
        case l_var_value.var_type
        when flow_constants_pkg.gc_prov_var_type_varchar2 then
          l_var_obj.put(l_var_value.var_name,l_var_value.var_vc2);
        when flow_constants_pkg.gc_prov_var_type_date then
          l_var_obj.put(l_var_value.var_name,l_var_value.var_date);
        when flow_constants_pkg.gc_prov_var_type_number then
          l_var_obj.put(l_var_value.var_name,l_var_value.var_num);
        when flow_constants_pkg.gc_prov_var_type_tstz then
          l_var_obj.put(l_var_value.var_name,cast( l_var_value.var_tstz as timestamp));
        when flow_constants_pkg.gc_prov_var_type_json then
          l_var_obj.put(l_var_value.var_name,l_var_value.var_json);
        when flow_constants_pkg.gc_prov_var_type_clob then
          l_var_obj.put(l_var_value.var_name,l_var_value.var_clob);
        else
          l_var_obj.put_null(l_var_list(i));
        end case;
      end loop;
    end if;
    return l_var_obj;
  end get_vars_as_json_object;

end flow_proc_vars_int;
/

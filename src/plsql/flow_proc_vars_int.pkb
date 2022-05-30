/* 
-- Flows for APEX - flow_proc_vars_int.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    12-Apr-2022  Richard Allen (Oracle)
--
*/
create or replace package body flow_proc_vars_int
as

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

function scope_is_valid
( pi_prcs_id in flow_processes.prcs_id%type
, pi_scope   in flow_subflows.sbfl_scope%type
) return boolean
is 
  l_count number;
begin
  select count(prdg_id)
    into l_count
    from flow_instance_diagrams
   where prdg_prcs_id = pi_prcs_id
     and prdg_diagram_level = pi_scope
  ;
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
         set prov.prov_var_vc2  = pi_vc2_value
       where prov.prov_prcs_id  = pi_prcs_id
         and prov.prov_scope    = pi_scope
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = flow_constants_pkg.gc_prov_var_type_varchar2 
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
  when others
  then
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
         set prov.prov_var_num  = pi_num_value
       where prov.prov_prcs_id  = pi_prcs_id
         and prov.prov_scope    = pi_scope
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = flow_constants_pkg.gc_prov_var_type_number
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
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_number
  , p_var_num           => pi_num_value
  );
exception
  when others
  then
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
         set prov.prov_var_date = pi_date_value
       where prov.prov_prcs_id  = pi_prcs_id
         and prov.prov_scope    = pi_scope
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = flow_constants_pkg.gc_prov_var_type_date
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
  when others
  then
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
         set prov.prov_var_clob = pi_clob_value
       where prov.prov_prcs_id  = pi_prcs_id
         and prov.prov_scope    = pi_scope
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = flow_constants_pkg.gc_prov_var_type_clob
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
  , p_var_type          => flow_constants_pkg.gc_prov_var_type_clob 
  , p_var_clob           => pi_clob_value
  );
exception
  when others
  then
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
    where prov.prov_prcs_id = pi_prcs_id
      and prov.prov_var_name = pi_var_name
      and prov.prov_scope = pi_scope
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
    where prov.prov_prcs_id = pi_prcs_id
      and prov.prov_var_name = pi_var_name
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
    where prov.prov_prcs_id = pi_prcs_id
      and prov.prov_var_name = pi_var_name
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
    where prov.prov_prcs_id = pi_prcs_id
      and prov.prov_var_name = pi_var_name
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
    else
      return null;
    end if;
end get_var_clob;

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
    where prov.prov_prcs_id   = pi_prcs_id
      and prov.prov_var_name  = pi_var_name
      and prov.prov_scope     = pi_scope
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
   where prov.prov_prcs_id = pi_prcs_id
     and prov.prov_var_name = pi_var_name
     and prov.prov_scope = pi_scope
     for update wait 2;

  delete 
    from flow_process_variables prov
   where prov.prov_prcs_id  = pi_prcs_id
     and prov.prov_var_name = pi_var_name
     and prov.prov_scope    = pi_scope
  ;
  flow_logging.log_variable_event
  ( p_process_id        => pi_prcs_id
  , p_scope             => pi_scope               
  , p_var_name          => pi_var_name
  , p_var_type          => l_var_type
  );
exception
  when  no_data_found then
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
           ( pi_prcs_id => pi_prcs_id
           , pi_var_name => flow_constants_pkg.gc_prov_builtin_business_ref
           , pi_scope => pi_scope
           );
  end get_business_ref;

-- group delete for all vars in a process (used at process deletion, process reset)

  procedure delete_all_for_process
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_retain_builtins in boolean default false
  )
  is
  begin
    if pi_retain_builtins then 
      delete from flow_process_variables prov
      where prov.prov_prcs_id = pi_prcs_id
        and prov.prov_var_name not in ( flow_constants_pkg.gc_prov_builtin_business_ref )
      ;
    else
      delete from flow_process_variables prov
      where prov.prov_prcs_id = pi_prcs_id;
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
          else
            -- own implementation of get_vc_var
            -- Reason:
            -- The general implementation immediately adds to APEX error stack
            begin
              select prov.prov_var_vc2
                into l_replacement_value
                from flow_process_variables prov
               where prov.prov_prcs_id  = pi_prcs_id
                 and prov.prov_scope    = pi_scope
                 and upper(prov.prov_var_name) = upper(l_f4a_substitutions(i))
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
  , pi_sbfl_id  in flow_subflows.sbfl_id%type
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
        p_str            => pio_string
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
          else
            -- own implementation of get_vc_var
            -- Reason:
            -- The general implementation immediately adds to APEX error stack
            begin
              select prov.prov_var_vc2
                into l_replacement_value
                from flow_process_variables prov
               where prov.prov_prcs_id  = pi_prcs_id
                 and prov.prov_scope    = pi_scope
                 and upper(prov.prov_var_name) = upper(l_f4a_substitutions(i))
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

end flow_proc_vars_int;
/

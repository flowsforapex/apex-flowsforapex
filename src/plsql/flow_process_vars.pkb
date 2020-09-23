create or replace package body flow_process_vars
as

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
)
is 
begin
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_var_name
      , prov_var_type
      , prov_var_vc2
      ) values
      ( pi_prcs_id
      , pi_var_name
      , 'VARCHAR2'
      , pi_vc2_value
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_vc2 = pi_vc2_value
       where prov.prov_prcs_id = pi_prcs_id
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = 'VARCHAR2'
           ;
    when others
    then
      apex_error.add_error
          ( p_message => 'Error creating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
          , p_display_location => apex_error.c_on_error_page
          );
  end;
exception
  when others
  then
      apex_error.add_error
      ( p_message => 'Error updating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
      , p_display_location => apex_error.c_on_error_page
      );
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
)
is 
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_var_name
      , prov_var_type
      , prov_var_num
      ) values
      ( pi_prcs_id
      , pi_var_name
      , 'NUMBER'
      , pi_num_value
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_num = pi_num_value
       where prov.prov_prcs_id = pi_prcs_id
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = 'NUMBER'
           ;
    when others
    then
      apex_error.add_error
          ( p_message => 'Error creating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
          , p_display_location => apex_error.c_on_error_page
          );
  end;
exception
  when others
  then
      apex_error.add_error
      ( p_message => 'Error updating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
      , p_display_location => apex_error.c_on_error_page
      );
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
)
is 
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_var_name
      , prov_var_type
      , prov_var_date
      ) values
      ( pi_prcs_id
      , pi_var_name
      , 'DATE'
      , pi_date_value
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_date = pi_date_value
       where prov.prov_prcs_id = pi_prcs_id
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = 'DATE'
           ;
    when others
    then
      apex_error.add_error
          ( p_message => 'Error creating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
          , p_display_location => apex_error.c_on_error_page
          );
  end;
exception
  when others
  then
      apex_error.add_error
      ( p_message => 'Error updating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
      , p_display_location => apex_error.c_on_error_page
      );
end set_var;

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
)
is 
begin 
  begin
      insert into flow_process_variables 
      ( prov_prcs_id
      , prov_var_name
      , prov_var_type
      , prov_var_clob
      ) values
      ( pi_prcs_id
      , pi_var_name
      , 'CLOB'
      , pi_clob_value
      );
  exception
    when dup_val_on_index then
      update flow_process_variables prov 
         set prov.prov_var_clob = pi_clob_value
       where prov.prov_prcs_id = pi_prcs_id
         and prov.prov_var_name = pi_var_name
         and prov.prov_var_type = 'CLOB'
           ;
    when others
    then
      apex_error.add_error
          ( p_message => 'Error creating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
          , p_display_location => apex_error.c_on_error_page
          );
  end;
exception
  when others
  then
      apex_error.add_error
      ( p_message => 'Error updating process variable '||pi_var_name||' for process id '||pi_prcs_id||'.'
      , p_display_location => apex_error.c_on_error_page
      );
end set_var;

-- getters return

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_vc2%type
is 
   po_vc2_value  flow_process_variables.prov_var_vc2%type;
begin 
   select prov.prov_var_vc2
     into po_vc2_value
     from flow_process_variables prov
    where prov.prov_prcs_id = pi_prcs_id
      and prov.prov_var_name = pi_var_name
        ;
   return po_vc2_value;
exception
  when no_data_found then
     if pi_var_name like 'Route:%' 
     then
        -- special case error handling for FFA41 to permit next_branch to work.
        -- remove if...then...else and have all cases do the <else> action  in FFA50
         return null;
     else
      apex_error.add_error
      ( p_message => 'Process variable '||pi_var_name||' for process id '||pi_prcs_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
     end if;
end get_var_vc2;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_num%type
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
      apex_error.add_error
      ( p_message => 'Process variable '||pi_var_name||' for process id '||pi_prcs_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
end get_var_num;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_date%type
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
      apex_error.add_error
      ( p_message => 'Process variable '||pi_var_name||' for process id '||pi_prcs_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
end get_var_date;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_clob%type
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
      apex_error.add_error
      ( p_message => 'Process variable '||pi_var_name||' for process id '||pi_prcs_id||' not found.'
      , p_display_location => apex_error.c_on_error_page
      );
end get_var_clob;

-- group delete for all vars in a process (used at process deletion, process reset)

procedure delete_all_for_process
( pi_prcs_id in flow_processes.prcs_id%type
)
is
begin
  delete from flow_process_variables prov
  where prov.prov_prcs_id = pi_prcs_id;
end delete_all_for_process;

end flow_process_vars;

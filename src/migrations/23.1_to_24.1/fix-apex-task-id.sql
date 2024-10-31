/*
  Migration Script for Feature xxx - Fix APEX Task Id

  Created  RAllen, Flowquest    15 Oct 2024


  (c) Copyright Flowquest Limited and/or its affiliates.  2024.

*/
PROMPT >> Move APEX Human Task IDs into flow_subflows

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_APEX_TASK_ID'
     and upper(table_name)  = 'FLOW_SUBFLOWS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows add (sbfl_apex_task_id number)';
  end if;
end;
/

declare
  l_num_active_apex_tasks  number ;
begin
  select count(sbfl_id)
    into l_num_active_apex_tasks
    from flow_subflows
   where sbfl_status = 'waiting for approval';

  if l_num_active_apex_tasks > 0 then 

    update  flow_subflows
    set     sbfl_apex_task_id = flow_proc_vars_int.get_var_num ( pi_prcs_id => sbfl_prcs_id
                                                               , pi_var_name => sbfl_current ||flow_constants_pkg.gc_prov_suffix_task_id
                                                               , pi_scope   => sbfl_scope
                                                               )
    where sbfl_status = 'waiting for approval';

    commit;

  end if;
end;
/


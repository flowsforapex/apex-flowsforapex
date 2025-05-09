/*
  Migration Script for Rewind Feature xxx - Suspend, Rewind and Resume

  Created  RAllen, Flowquest    21 Feb 2025 


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Schema Changes for Rewind and Event Logging Feature
PROMPT >> ---------------------------------------------------

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGPR_SBFL_ID'
     and upper(table_name)  = 'FLOW_INSTANCE_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_instance_event_log 
                          add ( lgpr_sbfl_id    NUMBER
                              , lgpr_step_key   VARCHAR2(50)
                              , lgpr_apex_task_id NUMBER
                              , lgpr_severity    NUMBER
                              )';
      execute immediate 'alter table flow_instance_event_log 
                         modify lgpr_prcs_name null ';
  end if;
end;
/

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_MATCHING_OBJECT'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log 
                          add ( sflg_matching_object VARCHAR2(50)
                              )';
  end if;
end;
/

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGPR_SBFL_ID'
     and upper(table_name)  = 'FLOW_INSTANCE_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_instance_event_log 
                          add ( lgpr_sbfl_id    NUMBER
                              , lgpr_step_key   VARCHAR2(50)
                              , lgpr_apex_task_id NUMBER
                              , lgpr_severity    NUMBER
                              )';
      execute immediate 'alter table flow_instance_event_log 
                         modify lgpr_prcs_name null ';
  end if;
end;
/

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_MATCHING_OBJECT'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log 
                          add ( sflg_matching_object VARCHAR2(50)
                              )';
  end if;
end;
/

declare
  v_column_exists          number := 0; 
  l_existing_logging_level flow_configuration.cfig_value%type;
  l_new_logging_level      number := 0;
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'PRCS_WAS_ALTERED'
     and upper(table_name)  = 'FLOW_PROCESSES';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_processes 
                          add ( prcs_was_altered varchar2(1)
                              , constraint prcs_was_altered_ck   check (prcs_was_altered in (''Y'', ''N''))
                              , prcs_logging_level  NUMBER
                              , constraint prcs_logging_level_ck check (prcs_logging_level between 0 and 8)
                              )';

  end if;

end;
/

declare
  v_column_exists          number := 0; 
  l_existing_logging_level flow_configuration.cfig_value%type;
  l_new_logging_level      number := 0;
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGSF_APEX_TASK_ID'
     and upper(table_name)  = 'FLOW_STEP_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_step_event_log
                          add ( lgsf_apex_task_id number
                              )';
  end if;

end;
/

PROMPT >>> Table flow_processes altered 

PROMPT >>> Migrate logging configuration for flow_processes and flow_configuration

begin
  update flow_processes
    set prcs_logging_level = ( select case nvl(cfig_value, 'none')
                                        when 'none'     then '0'
                                        when 'standard' then '6'
                                        when 'secure'   then '6'
                                        when 'full'     then '8' 
                                        else '0'
                                      end
                                  from flow_configuration
                                where cfig_key = 'logging_level')
  where prcs_status in ('created', 'running', 'suspended', 'error')
    and prcs_logging_level is null;

  insert into flow_configuration (cfig_key, cfig_value)
  select 'logging_default_level',  -- new key
        case nvl(cfig_value, 'none')
          when 'none'     then '0'
          when 'standard' then '6'
          when 'secure'   then '6'
          when 'full'     then '8'
          else '0'           -- new value
          end
    from flow_configuration
  where cfig_key = 'logging_level';

  insert into flow_configuration (cfig_key, cfig_value)
  select 'logging_bpmn_enabled',  -- new key
        case nvl(cfig_value, 'none')
          when 'none'     then 'false'
          when 'standard' then 'false'
          when 'secure'   then 'true'
          when 'full'     then 'true'
          else 'false'           -- new value
          end
    from flow_configuration
  where cfig_key = 'logging_level';

  insert into flow_configuration (cfig_key, cfig_value) values ('logging_bpmn_retain_days', '365');

  commit;
end;
/

PROMPT >>> Diagram logging configuration migrated based on existing settings in flow_configuration

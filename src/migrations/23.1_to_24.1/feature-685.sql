PROMPT >> MessageFlow - add message Start, message Boundary Events and message End Events

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'MSUB_DGRM_ID'
     and upper(table_name)  = 'FLOW_MESSAGE_SUBSCRIPTIONS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_message_subscriptions add 
        ( msub_DGRM_ID number
        , constraint flow_msub_dgrm_fk FOREIGN KEY ( msub_dgrm_id )
          references flow_diagrams (dgrm_id) ON DELETE CASCADE
        )';
  end if;
end;
/

comment on column flow_message_subscriptions.msub_id                is 'Message Subscription ID';
comment on column flow_message_subscriptions.msub_message_name      is 'Message Name that must be supplied with received message';
comment on column flow_message_subscriptions.msub_key_name          is 'Message Key Name that must be supplied with intermediate message';
comment on column flow_message_subscriptions.msub_key_value         is 'Message Key Value that must be supplied with intermediate message';
comment on column flow_message_subscriptions.msub_prcs_id           is 'Process ID to call back for intermediate message';
comment on column flow_message_subscriptions.msub_sbfl_id           is 'Subflow ID to call back for intermediate message';
comment on column flow_message_subscriptions.msub_step_key          is 'Step Key  to call back for intermediate message';
comment on column flow_message_subscriptions.msub_dgrm_id           is 'Diagram ID to use for message start event';
comment on column flow_message_subscriptions.msub_callback          is 'routine to use for callback';
comment on column flow_message_subscriptions.msub_callback_par      is 'parameter to use on callback';
comment on column flow_message_subscriptions.msub_payload_var       is 'process variable to return payload variable into';
comment on column flow_message_subscriptions.msub_created           is 'timestamp of subscription creation';
/

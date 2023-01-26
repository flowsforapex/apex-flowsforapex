

 -- add completed_ts column to flow_processes

 alter table flow_processes
 add (
  prcs_start_ts      timestamp with time zone,
  prcs_complete_ts   timestamp with time zone
 );

 comment on column flow_processes.prcs_complete_ts is 
 'Timestamp for process end when instance is in states "completed" or "terminated".';

  comment on column flow_processes.prcs_start_ts is 
 'Timestamp for process start.  Resets if process instance is reset.';

 alter table flow_instance_event_log 
 add ( lgpr_duration interval day(3) to second (3));

 -- approximate start_ts to instance creation_ts.   accurate unless instance has been reset
 -- so should be good approximation for any production systems.

 update flow_processes
    set prcs_start_ts = prcs_init_ts 
  where prcs_start_ts is null
    and prcs_status != 'created';

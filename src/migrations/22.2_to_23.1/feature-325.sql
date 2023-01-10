

 -- add completed_ts column to flow_processes

 alter table flow_processes
 add (
  prcs_complete_ts   timestamp with time zone
 );

 comment on column flow_processes.prcs_complete_ts is 
 'Timestamp for process end when instance is in states "completed" or "terminated".';
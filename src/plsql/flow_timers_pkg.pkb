
create or replace package body flow_timers_pkg as

 
/******************************************************************************
  STEP_TIMERS
******************************************************************************/
  procedure step_timers is

    -- Cycle timers
    cursor c1 is
    select *
      from flow_timers
     where timr_status in (c_created, c_active)
       and timr_cycle_string is not null
    for update of timr_last_run
                , timr_run_count
                , timr_status;

    -- duration timers
    cursor c2 is
    select *
      from flow_timers
     where timr_status = c_created
       and timr_duration_string is not null
    for update of timr_last_run
                , timr_run_count
                , timr_status;

    -- date timers
    cursor c3 is
      select *
        from flow_timers
       where timr_status = c_created
         and timr_date_string is not null
    for update of timr_last_run
                , timr_run_count
                , timr_status;

  begin
    -- get/set the timers (cycle)
    for c1_row in c1 loop
      if c1_row.timr_start_on + (c1_row.timr_interval_ym * nvl(c1_row.timr_run_count, 1))
                              + (c1_row.timr_interval_ds * nvl(c1_row.timr_run_count, 1)) <= systimestamp then
        update flow_timers
        set timr_last_run = systimestamp
          , timr_run_count = timr_run_count + 1
          , timr_status = case when (timr_run_count + 1) = timr_repeat_times then c_ended
                          else c_active end
        where current of c1;

        -- return timer event to flow_api_pkg
        flow_api_pkg.flow_handle_event (
          p_process_id => c1_row.timr_prcs_id
        , p_subflow_id => c1_row.timr_sbfl_id
        );
      end if;
    end loop;

  -- Get/set timers (duration)
    for c2_row in c2 loop
      if c2_row.timr_start_on <= systimestamp then
        update flow_timers
        set timr_last_run = systimestamp
          , timr_run_count = timr_run_count + 1
          , timr_status = c_ended
        where current of c2;

        -- return timer event to flow_api_pkg
        flow_api_pkg.flow_handle_event (
          p_process_id => c2_row.timr_prcs_id
        , p_subflow_id => c2_row.timr_sbfl_id
        );
      end if;
    end loop;

  -- get/set timers (date)
    for c3_row in c3 loop
      if c3_row.timr_start_on <= systimestamp then
        update flow_timers
        set timr_last_run = systimestamp
          , timr_run_count = timr_run_count + 1
          , timr_status = c_ended
        where current of c3;

        -- return timer event to flow_api_pkg
        flow_api_pkg.flow_handle_event (
          p_process_id => c3_row.timr_prcs_id
        , p_subflow_id => c3_row.timr_sbfl_id
        );
      end if;
    end loop;
  end step_timers;

/******************************************************************************
  GET_DURATION
******************************************************************************/

  procedure get_duration (
    in_string            in      varchar2
  , in_start_ts          in     timestamp with time zone default null
  , out_start_ts            out timestamp with time zone
  , out_interv_ym        in out interval year to month
  , out_interv_ds        in out interval day to second
  ) is
    l_int_years     number;
    l_int_months    number;
    l_int_days      number;
    l_int_contains  varchar2 (2);
  begin
    if regexp_replace (in_string, '[0-9]', '') like 'PYM%' then
      l_int_contains  := 'M';
      l_int_years     := substr (in_string, 2, instr (in_string, 'Y', 1) - 2);
      l_int_months    := substr (in_string, instr (in_string, 'Y', 1) + 1, instr (in_string, 'M', 1) - instr (in_string, 'Y', 1) - 1);

    elsif regexp_replace (in_string, '[0-9]', '') like 'PY%' then
      l_int_contains  := 'Y';
      l_int_years     := substr (in_string, 2, instr (in_string, 'Y', 1) - 2);

    elsif regexp_replace (in_string, '[0-9]', '') like 'PM%' then
      l_int_contains  := 'M';
      l_int_months    := substr (in_string, 2, instr (in_string, 'M', 1) - 2);

    end if;

    if regexp_replace (in_string, '[0-9]', '') like 'PT%' then
      l_int_contains  := 'PT';
      out_interv_ds   := nvl (to_dsinterval (substr (in_string, instr (in_string, l_int_contains, 1))), INTERVAL '0' HOUR);

    else 
      l_int_contains  := 'T';
      out_interv_ds := nvl (to_dsinterval (substr (in_string, instr (in_string, l_int_contains, 1))), INTERVAL '0' HOUR);

    end if;

    out_interv_ym := numtoyminterval (nvl (l_int_years, 0), 'YEAR') + numtoyminterval (nvl (l_int_months, 0), 'MONTH');
    out_start_ts  := nvl (in_start_ts, systimestamp) + out_interv_ym + out_interv_ds;

  end get_duration;

/******************************************************************************
  START_TIMER
******************************************************************************/

  procedure start_timer (
    p_process_id  in  flow_processes.prcs_id%type
  , p_subflow_id  in  flow_subflows.sbfl_id%type
  ) is

    l_time_date           flow_timers.timr_date_string%type;
    l_time_duration       flow_timers.timr_duration_string%type;
    l_time_cycle          flow_timers.timr_cycle_string%type;
    l_parsed_ts           timestamp with time zone;
    l_parsed_duration_ym  interval year to month;
    l_parsed_duration_ds  interval day to second;
    l_scheduler_string    varchar2(256);
    l_repeat_n_times      number;
  begin
    select objt_timer_date
         , objt_timer_duration
         , objt_timer_cycle
    into   l_time_date
         , l_time_duration
         , l_time_cycle
    from flow_objects objt
    join flow_subflows sbfl on sbfl.sbfl_current = objt.objt_bpmn_id
    where sbfl.sbfl_id = p_subflow_id
      and sbfl.sbfl_prcs_id = p_process_id
        ;

    -- date timers
    if l_time_date is not null then
      l_parsed_ts := to_timestamp_tz (replace (l_time_date, 'T', ' '), 'YYYY-MM-DD HH24:MI:SS TZR');

      insert into flow_timers (
          timr_prcs_id
        , timr_sbfl_id
        , timr_created_on
        , timr_status
        , timr_date_string
        , timr_start_on
      ) values ( 
        p_process_id
      , p_subflow_id
      , systimestamp
      , c_created
      , l_time_date
      , l_parsed_ts
      );      

    -- duration timers
    elsif l_time_duration is not null then
      get_duration (in_string            => l_time_duration
                  , in_start_ts          => systimestamp
                  , out_start_ts         => l_parsed_ts
                  , out_interv_ym        => l_parsed_duration_ym
                  , out_interv_ds        => l_parsed_duration_ds
                  );

      insert into flow_timers (
          timr_prcs_id
        , timr_sbfl_id
        , timr_created_on
        , timr_status
        , timr_duration_string
        , timr_start_on
      ) values (
        p_process_id
      , p_subflow_id
      , systimestamp
      , c_created
      , l_time_duration
      , l_parsed_ts
      );

    -- cycle timers
    elsif l_time_cycle is not null then
      l_repeat_n_times := substr(l_time_cycle,
                                 2,
                                 instr(l_time_cycle, '/', 1, 1) - 2);

      l_time_duration := substr(l_time_cycle,
                                instr(l_time_cycle, '/', 1, 1) + 1);

      get_duration (in_string            => l_time_duration
                  , in_start_ts          => systimestamp
                  , out_start_ts         => l_parsed_ts
                  , out_interv_ym        => l_parsed_duration_ym
                  , out_interv_ds        => l_parsed_duration_ds
                  );

      insert into flow_timers 
        ( timr_prcs_id
        , timr_sbfl_id
        , timr_created_on
        , timr_status
        , timr_cycle_string
        , timr_start_on
        , timr_interval_ym
        , timr_interval_ds
        , timr_repeat_times
      ) values 
        ( p_process_id
        , p_subflow_id
        , systimestamp
        , c_created
        , l_time_cycle
        , l_parsed_ts
        , l_parsed_duration_ym
        , l_parsed_duration_ds
        , l_repeat_n_times
        );

    end if;

  end start_timer;

/******************************************************************************
  EXPIRE_TIMER
******************************************************************************/

  procedure expire_timer (
    p_process_id  in  flow_processes.prcs_id%type
  , p_subflow_id  in  flow_subflows.sbfl_id%type 
  ) is
  begin
    update flow_timers
    set timr_status = c_expired
    where timr_prcs_id = p_process_id
      and timr_sbfl_id = p_subflow_id
      and timr_status not in (c_ended, c_expired, c_terminated);
  end expire_timer;

/******************************************************************************
  TERMINATE_TIMER
******************************************************************************/

  procedure terminate_timer (
      p_process_id    in   flow_processes.prcs_id%type
    , p_subflow_id    in   flow_subflows.sbfl_id%type
    , p_return_code   out  number
    ) is
  begin
    update flow_timers
       set timr_status = c_terminated
     where timr_prcs_id = p_process_id
       and timr_sbfl_id = p_subflow_id
       and timr_status not in (c_ended, c_expired, c_terminated);
  end terminate_timer;

/******************************************************************************
  TERMINATE_PROCESS_TIMERS
******************************************************************************/

  procedure terminate_process_timers (
      p_process_id    in   flow_processes.prcs_id%type
    , p_return_code   out  number
    ) is
  begin
    update flow_timers
    set timr_status = c_terminated
    where timr_prcs_id = p_process_id
      and timr_status not in (c_ended, c_expired, c_terminated);
  end terminate_process_timers;

/******************************************************************************
  TERMINATE_ALL_TIMERS
******************************************************************************/

  procedure terminate_all_timers (
    p_return_code  out  number
  ) is
  begin
    update flow_timers
    set timr_status = c_terminated
    where timr_status not in (c_ended, c_expired, c_terminated);
  end terminate_all_timers;

/******************************************************************************
  delete_process_timers
    delete all the timers of a process.
******************************************************************************/

  procedure delete_process_timers (
    p_process_id    in   flow_processes.prcs_id%type
  , p_return_code  out  number
  ) is 
  begin
    delete from flow_timers
    where timr_prcs_id = p_process_id;
  end delete_process_timers;



/******************************************************************************
  DISABLE_SCHEDULED_JOB
******************************************************************************/

  procedure disable_scheduled_job is
  begin
    dbms_scheduler.disable (name => 'apex_flow_step_timers_j');
  end;

/******************************************************************************
  ENABLE_SCHEDULED_JOB
******************************************************************************/

  procedure enable_scheduled_job is
  begin
    dbms_scheduler.enable (name => 'apex_flow_step_timers_j');
  end;

end flow_timers_pkg;
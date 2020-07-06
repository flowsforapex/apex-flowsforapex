CREATE OR REPLACE PACKAGE BODY flow_timers_pkg AS

/******************************************************************************
  RUN_JOB
******************************************************************************/

  PROCEDURE run_job (
    p_process_id       IN  VARCHAR2
  , p_subflow_id       IN  VARCHAR2
  , p_start_date       IN  TIMESTAMP WITH TIME ZONE DEFAULT NULL
  , p_repeat_interval  IN  VARCHAR2 DEFAULT NULL
  , p_repeat_n_times   IN  NUMBER DEFAULT NULL
  ) IS
    l_name VARCHAR2 (64) := dbms_scheduler.generate_job_name ('FLOW_APEX_TIMER');
  BEGIN
    apex_debug.message(p_message => 'Begin run_job for subflow '||p_subflow_id , p_level => 3) ;
    
    dbms_scheduler.create_job (job_name => l_name, program_name => 'FLOW_START_TIMER_P', job_style => 'IN_MEMORY_RUNTIME'
                             , start_date => p_start_date, repeat_interval => p_repeat_interval, enabled => false);

    IF p_repeat_n_times IS NOT NULL THEN
      dbms_scheduler.set_attribute (name => l_name, attribute => 'max_runs', value => p_repeat_n_times);

    END IF;

    dbms_scheduler.set_job_argument_value (job_name => l_name, argument_name => 'P_PROCESS_ID', argument_value => p_process_id);
    dbms_scheduler.set_job_argument_value (job_name => l_name, argument_name => 'P_SUBFLOW_ID', argument_value => p_subflow_id);

    dbms_scheduler.enable (l_name);
  END run_job;



/******************************************************************************
  GET_DURATION
******************************************************************************/

  PROCEDURE get_duration (
    in_string      IN      VARCHAR2
  , in_start_ts    IN      TIMESTAMP WITH TIME ZONE DEFAULT NULL
  , out_start_ts   OUT     TIMESTAMP WITH TIME ZONE
  , out_interv_ym  IN OUT  INTERVAL YEAR TO MONTH
  , out_interv_ds  IN OUT  INTERVAL DAY TO SECOND
  ) IS
    l_int_years     NUMBER;
    l_int_months    NUMBER;
    l_int_days      NUMBER;
    l_int_contains  VARCHAR2 (1);
  BEGIN
    IF regexp_replace (in_string, '[0-9]', '') LIKE 'PYM%' THEN
      l_int_contains  := 'M';
      l_int_years     := substr (in_string, 2, instr (in_string, 'Y', 1) - 2);
      l_int_months    := substr (in_string, instr (in_string, 'Y', 1) + 1, instr (in_string, 'M', 1) - instr (in_string, 'Y', 1) - 1);

    ELSIF regexp_replace (in_string, '[0-9]', '') LIKE 'PY%' THEN
      l_int_contains  := 'Y';
      l_int_years     := substr (in_string, 2, instr (in_string, 'Y', 1) - 2);

    ELSIF regexp_replace (in_string, '[0-9]', '') LIKE 'PM%' THEN
      l_int_contains  := 'M';
      l_int_months    := substr (in_string, 2, instr (in_string, 'M', 1) - 2);

    END IF;

    out_interv_ym  := numtoyminterval (nvl (l_int_years, 0), 'YEAR') + numtoyminterval (nvl (l_int_months, 0), 'MONTH');

    out_interv_ds  := nvl (to_dsinterval (substr (in_string, instr (in_string, l_int_contains, 1) + 1)), INTERVAL '0' HOUR);

    out_start_ts   := nvl (in_start_ts, systimestamp) + out_interv_ym + out_interv_ds;
      /*out_start_ts :=  in_start_ts + numtoyminterval(nvl(l_int_years, 0), 'YEAR')
                                   + numtoyminterval(nvl(l_int_months, 0), 'MONTH')
                                   + nvl(to_dsinterval(substr(in_string
                                                             ,instr(in_string, l_int_contains, 1) + 1))
                                        ,interval '0' HOUR);*/
  END get_duration;

  

/******************************************************************************
  START_TIMER
******************************************************************************/

  PROCEDURE start_timer (
    p_process_id  IN  VARCHAR2
  , p_subflow_id  IN  VARCHAR2 -- add parameter
  ) IS
    l_process_id          flow_processes.prcs_id%TYPE := p_process_id;
    l_subflow_id          flow_subflows.sbfl_id%TYPE := p_subflow_id;
    l_time_date           flow_objects.objt_timer_date%TYPE;
    l_time_duration       flow_objects.objt_timer_duration%TYPE;
    l_time_cycle          flow_objects.objt_timer_cycle%TYPE;
    l_parsed_ts           TIMESTAMP WITH TIME ZONE;
    l_parsed_duration_ym  INTERVAL YEAR TO MONTH;
    l_parsed_duration_ds  INTERVAL DAY TO SECOND;
    l_repeat_n_times      NUMBER;
  BEGIN
     apex_debug.message(p_message => 'Begin start_timer for subflow '||p_subflow_id , p_level => 3) ;
/*    SELECT timr_timer_id
         , timr_time_date
         , timr_time_duration
         , timr_time_cycle
    INTO
      l_timer_id
    , l_time_date
    , l_time_duration
    , l_time_cycle
    FROM flow_timers
    WHERE timr_timer_id = p_timer_id; */
      -- get timer info for the current timer object
      select l_curr_objt_id
           , objt_timer_date
           , objt_timer_duration
           , objt_timer_cycle
        into l_timer_id
           , l_time_date
           , l_time_duration
           , l_time_cycle
        from flow_objects objt 
        join flow_subflows sbfl on sbfl.sbfl_current = objt.objt_bpmn_id

    IF l_time_date IS NOT NULL THEN
      l_parsed_ts := to_timestamp_tz (replace (l_time_date, 'TZ', '  '), 'YYYY-MM-DD HH24:MI:SS TZR');
      run_job (p_process_id => l_process_id, p_subflow_id => p_subflow_id, p_start_date => l_parsed_ts);
    ELSIF l_time_duration IS NOT NULL THEN
      get_duration (in_string => l_time_duration, in_start_ts => systimestamp, out_start_ts => l_parsed_ts
                  , out_interv_ym => l_parsed_duration_ym, out_interv_ds => l_parsed_duration_ds);

      run_job (p_process_id => l_process_id, p_subflow_id => l_subflow_id, p_start_date => l_parsed_ts);
    ELSIF l_time_cycle IS NOT NULL THEN -- to be implemented using get_duration().
      NULL;/* WORKING ON THIS, BROKEN...
      l_repeat_n_times := substr(l_time_cycle,
                                 2,
                                 instr(l_time_cycle, '/', 1, 1) - 2);
      l_parsed_ts := substr(l_time_cycle,
                            instr(l_time_cycle, '/', 1, 2) + 2);
                           
      run_job ( p_timer_id        => l_timer_id
              , p_process_id      => l_process_id
              , p_start_date      => l_parsed_ts
              , p_repeat_interval => l_parsed_duration_ym + l_parsed_duration_ds
              , p_repeat_n_times  => l_repeat_n_times
              );*/
    END IF;

  END start_timer;
  


/******************************************************************************
  TIMER_EXPIRED
******************************************************************************/

  PROCEDURE timer_expired (
    p_process_id  IN  VARCHAR2
  , p_subflow_id  IN  VARCHAR2 
  ) IS
  BEGIN
    apex_debug.message(p_message => 'Begin timer_expired for subflow '||p_subflow_id , p_level => 3) ;
    -- set subflow status to running & call next step
    update flow_subflows sbfl 
       set sbfl.sbfl_status = 'running'
         , sbfl.sbfl_last_update = sysdate
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
         ;

    flow_api_pkg.flow_next_step (
      p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_forward_route => null
    )
  END timer_expired;



/******************************************************************************
  KILL_TIMER
******************************************************************************/

  PROCEDURE kill_timer (
    p_process_id    IN   VARCHAR2
  , p_subflow_id    IN   VARCHAR2
  , out_return_code  OUT  NUMBER
  ) IS
  BEGIN
    NULL; -- Implement here the removal of the job
  END kill_timer;



/******************************************************************************
  KILL_PROCESS_TIMERS
******************************************************************************/

  PROCEDURE kill_process_timers (
    p_process_id    IN   VARCHAR2
  , out_return_code  OUT  NUMBER
  ) IS
  BEGIN
    NULL; -- Implement here the removal of the job
  END kill_process_timers;



/******************************************************************************
  KILL_ALL_TIMERS
******************************************************************************/

  PROCEDURE kill_all_timers (
  , out_return_code  OUT  NUMBER
  ) IS
  BEGIN
    NULL; -- Implement here the removal of the jobs
  END kill_all_timers;

END flow_timers_pkg;
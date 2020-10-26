
create or replace package body flow_timers_pkg
as

  procedure get_timer_definition
  (
    pi_prcs_id    in         flow_processes.prcs_id%type
  , pi_sbfl_id    in         flow_subflows.sbfl_id%type
  , po_timer_type out nocopy flow_object_attributes.obat_vc_value%type
  , po_timer_def  out nocopy flow_object_attributes.obat_vc_value%type
  )
  is
    l_objt_with_timer     flow_objects.objt_id%type;
  begin
    -- get objt that timers are attached to (object or attached boundaryEvent)
    begin 
      select objt.objt_id
        into l_objt_with_timer
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id
        join flow_objects objt
          on objt.objt_bpmn_id = sbfl.sbfl_current
         and objt.objt_dgrm_id = prcs.prcs_dgrm_id
       where sbfl.sbfl_id = pi_sbfl_id
         and sbfl.sbfl_prcs_id = pi_prcs_id
         and objt.objt_sub_tag_name = 'bpmn:timerEventDefinition'
         ;
    exception
      when no_data_found then
        -- check for an interupting timer boundary event attached
        begin
          select boundary_objt.objt_id
            into l_objt_with_timer
            from flow_subflows sbfl
            join flow_processes prcs
              on prcs.prcs_id = sbfl.sbfl_prcs_id
            join flow_objects main_objt
              on main_objt.objt_bpmn_id = sbfl.sbfl_current
             and main_objt.objt_dgrm_id = prcs.prcs_dgrm_id
            join flow_objects boundary_objt
              on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
           where sbfl.sbfl_id = pi_sbfl_id
             and sbfl.sbfl_prcs_id = pi_prcs_id
             and boundary_objt.objt_sub_tag_name = 'bpmn:timerEventDefinition'
             and boundary_objt.objt_interrupting = 1
             ;
        exception
          when no_data_found then
            apex_error.add_error
            ( p_message => 'Error finding object with timer in get_timer_definition. Subflow '||pi_sbfl_id||' .'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
    end;
    apex_debug.message(p_message => 'get_timer_definition.  Getting timer definition for object '||l_objt_with_timer||
                       ' on subflow '|| pi_sbfl_id, p_level => 4) ;
    begin 
      for rec in (
                  select obat.obat_key
                        , obat.obat_vc_value
                    from flow_object_attributes obat
                    where obat.obat_objt_id = l_objt_with_timer
                  )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_timer_type_key then
            po_timer_type := rec.obat_vc_value;
          when flow_constants_pkg.gc_timer_def_key then
            po_timer_def := rec.obat_vc_value;
          else
            null;
        end case;
      end loop;
    exception
      when no_data_found then
            apex_error.add_error
            ( p_message => 'No timer definitions found in get_timer_definition for object '||l_objt_with_timer||' .'
            , p_display_location => apex_error.c_on_error_page
            );
    end;
  end get_timer_definition;

/******************************************************************************
  STEP_TIMERS
******************************************************************************/
  procedure step_timers
  is
    cursor timr_cur is
      select *
        from flow_timers
        where timr_status in (c_created, c_active)
          for update of timr_last_run
                      , timr_run_count
                      , timr_status
    ;
  begin
    for rec in timr_cur
    loop
      case rec.timr_type
        when flow_constants_pkg.gc_timer_type_cycle then
          if (   rec.timr_start_on
               + ( rec.timr_interval_ym * coalesce( rec.timr_run_count, 1) )
               + ( rec.timr_interval_ds * coalesce(rec.timr_run_count, 1) )
             ) <= systimestamp
          then
            update flow_timers
               set timr_last_run = systimestamp
                 , timr_run_count = timr_run_count + 1
                 , timr_status = case when timr_run_count + 1 = timr_repeat_times then c_ended else c_active end
             where current of timr_cur
            ;
            -- return timer event to flow_api_pkg
            flow_engine.flow_handle_event
            (
              p_process_id => rec.timr_prcs_id
            , p_subflow_id => rec.timr_sbfl_id
            );
          end if;
        else
          if rec.timr_start_on <= systimestamp then
            update flow_timers
               set timr_last_run = systimestamp
                 , timr_run_count = timr_run_count + 1
                 , timr_status = c_ended
             where current of timr_cur
            ;
            flow_engine.flow_handle_event
            (
              p_process_id => rec.timr_prcs_id
            , p_subflow_id => rec.timr_sbfl_id
            );
          end if;
      end case;  
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

  procedure start_timer
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  )
  is
    l_parsed_ts           flow_timers.timr_start_on%type;
    l_parsed_duration_ym  flow_timers.timr_interval_ym%type;
    l_parsed_duration_ds  flow_timers.timr_interval_ds%type;
    l_repeat_times        flow_timers.timr_repeat_times%type;

    l_timer_type flow_object_attributes.obat_vc_value%type;
    l_timer_def  flow_object_attributes.obat_vc_value%type;
  begin
    get_timer_definition
    (
      pi_prcs_id    => pi_prcs_id
    , pi_sbfl_id    => pi_sbfl_id
    , po_timer_type => l_timer_type
    , po_timer_def  => l_timer_def
    );
    apex_debug.message(p_message => 'starting timer on subflow '||pi_sbfl_id||' type '||l_timer_type||' def '||l_timer_def, p_level => 4) ;
    case l_timer_type
      when flow_constants_pkg.gc_timer_type_date then
        l_parsed_ts := to_timestamp_tz( replace ( l_timer_def, 'T', ' ' ), 'YYYY-MM-DD HH24:MI:SS TZR' );
      when flow_constants_pkg.gc_timer_type_duration then
        get_duration
        (
          in_string     => l_timer_def
        , in_start_ts   => systimestamp
        , out_start_ts  => l_parsed_ts
        , out_interv_ym => l_parsed_duration_ym
        , out_interv_ds => l_parsed_duration_ds
        );
      when flow_constants_pkg.gc_timer_type_cycle then
        l_repeat_times := substr( l_timer_def, 2, instr( l_timer_def, '/', 1, 1 ) - 2 );
        l_timer_def    := substr( l_timer_def, instr( l_timer_def, '/', 1, 1 ) + 1 );
        get_duration
        (
          in_string     => l_timer_def
        , in_start_ts   => systimestamp
        , out_start_ts  => l_parsed_ts
        , out_interv_ym => l_parsed_duration_ym
        , out_interv_ds => l_parsed_duration_ds
        );
      when others then
            apex_error.add_error
            ( p_message => 'No timer definitions found in start_timer on subflow '||pi_sbfl_id||' type '||l_timer_type||' def '||l_timer_def
            , p_display_location => apex_error.c_on_error_page
            );

    end case;

    insert into flow_timers
      (
        timr_prcs_id
      , timr_sbfl_id
      , timr_type
      , timr_created_on
      , timr_status
      , timr_start_on
      , timr_interval_ym
      , timr_interval_ds
      , timr_repeat_times
      )
      values
      (
        pi_prcs_id
      , pi_sbfl_id
      , l_timer_type
      , systimestamp
      , c_created
      , l_parsed_ts
      , l_parsed_duration_ym
      , l_parsed_duration_ds
      , l_repeat_times
      )
    ;
  end start_timer;

/******************************************************************************
  EXPIRE_TIMER
******************************************************************************/

  procedure expire_timer
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type 
  )
  is
  begin
    update flow_timers
    set timr_status = c_expired
    where timr_prcs_id = pi_prcs_id
      and timr_sbfl_id = pi_sbfl_id
      and timr_status not in (c_ended, c_expired, c_terminated);
  end expire_timer;

/******************************************************************************
  TERMINATE_TIMER
******************************************************************************/

  procedure terminate_timer
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , pi_sbfl_id      in flow_subflows.sbfl_id%type
  , po_return_code out number
  )
  is
  begin
    update flow_timers
       set timr_status = c_terminated
     where timr_prcs_id = pi_prcs_id
       and timr_sbfl_id = pi_sbfl_id
       and timr_status not in (c_ended, c_expired, c_terminated);
  end terminate_timer;

/******************************************************************************
  TERMINATE_PROCESS_TIMERS
******************************************************************************/

  procedure terminate_process_timers
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , po_return_code out number
  )
  is
  begin
    update flow_timers
    set timr_status = c_terminated
    where timr_prcs_id = pi_prcs_id
      and timr_status not in (c_ended, c_expired, c_terminated);
  end terminate_process_timers;

/******************************************************************************
  TERMINATE_ALL_TIMERS
******************************************************************************/

  procedure terminate_all_timers
  (
    po_return_code  out  number
  )
  is
  begin
    update flow_timers
       set timr_status = c_terminated
     where timr_status not in (c_ended, c_expired, c_terminated)
    ;
  end terminate_all_timers;

/******************************************************************************
  delete_process_timers
    delete all the timers of a process.
******************************************************************************/

  procedure delete_process_timers
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , po_return_code out number
  )
  is 
  begin
    delete
      from flow_timers
     where timr_prcs_id = pi_prcs_id
    ;
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
/

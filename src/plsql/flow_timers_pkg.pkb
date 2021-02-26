
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
         and objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
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
             and boundary_objt.objt_dgrm_id = prcs.prcs_dgrm_id
           where sbfl.sbfl_id = pi_sbfl_id
             and prcs.prcs_id = pi_prcs_id
             and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
             and boundary_objt.objt_interrupting = 1
          ;
        exception
          when no_data_found then
            apex_error.add_error
            ( 
              p_message => 'Error finding object with timer in get_timer_definition. Subflow '||pi_sbfl_id||' .'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
    end;
    apex_debug.info
    (
      p_message => 'get_timer_definition.  Getting timer definition for object %s on subflow %s'
    , p0        => l_objt_with_timer
    , p1        => pi_sbfl_id
    );

    begin
      for rec in (
                   select obat.obat_key
                        , obat.obat_vc_value
                     from flow_object_attributes obat
                    where obat.obat_objt_id = l_objt_with_timer
                      and obat.obat_key in ( flow_constants_pkg.gc_timer_type_key, flow_constants_pkg.gc_timer_def_key )
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

  procedure step_timers
  is
    cursor timr_cur is
      select *
        from flow_timers
       where timr_status in ( c_created, c_active )
     order by timr_created_on
          for update of timr_last_run
                      , timr_run_count
                      , timr_status
    ;

    e_timer_already_removed exception;
    pragma exception_init( e_timer_already_removed, -8006 );
  begin
    for rec in timr_cur loop
      begin
        case rec.timr_type
          when flow_constants_pkg.gc_timer_type_cycle then
            if (   rec.timr_start_on
                 + ( rec.timr_interval_ym * coalesce( rec.timr_run_count, 1 ) )
                 + ( rec.timr_interval_ds * coalesce( rec.timr_run_count, 1 ) )
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
      exception
        when e_timer_already_removed then
          -- Timers can disappear while we're processing a list of timers.
          -- This is in the nature of timers as one might fire,
          -- cleans up a whole subflow including any timers on that subflow.
          null;
        when others then
          -- Some exception happened during processing the timer
          -- We trap it here and mark respective timer as broken.
          update flow_timers
             set timr_status = c_broken
           where current of timr_cur
          ;
      end;
    end loop;
  end step_timers;

  procedure get_duration
  (
    in_string     in     varchar2
  , in_start_ts   in     timestamp with time zone default null
  , out_start_ts     out timestamp with time zone
  , out_interv_ym in out interval year to month
  , out_interv_ds in out interval day to second
  )
  as
    type t_duration_components is table of number index by varchar2(1 char);

    l_start_pos_time  pls_integer;
    l_token_count     pls_integer;
    l_before_t        varchar2(200 char);
    l_after_t         varchar2(200 char);
    l_ym_part         varchar2(200 char);
    l_ds_part         varchar2(200 char);

    l_cur_component   varchar2(200 char);    
  begin
    -- first split the string to year-month and day-second parts
    -- afterwards operate on both separately
    -- because M before T means months and M after T means minutes

    l_start_pos_time := instr( in_string, 'T' );
    if l_start_pos_time = 0 then
      l_before_t := in_string;
    else
      l_before_t       := substr( in_string, 1, l_start_pos_time - 1 );
      l_after_t        := substr( in_string, l_start_pos_time);
    end if;

    -- The day indicator comes before the "T"
    -- however day needs to be handle with ds_interval
    l_token_count := regexp_count( l_before_t, '\d+\w' );
    for i in 1..l_token_count loop
      l_cur_component := regexp_substr(l_before_t, '\d+\w', 1, i);

      case substr(l_cur_component, -1)
        when 'Y' then l_ym_part := l_ym_part || l_cur_component;
        when 'M' then l_ym_part := l_ym_part || l_cur_component;
        when 'D' then l_ds_part := l_ds_part || l_cur_component;
        else null;
      end case;
    end loop;

    l_ds_part := l_ds_part || l_after_t;

    out_interv_ym := to_yminterval( 'P' || coalesce(l_ym_part, '0Y') );
    out_interv_ds := to_dsinterval( 'P' || coalesce(l_ds_part, '0D') );

    out_start_ts  := coalesce( in_start_ts, systimestamp ) + out_interv_ym + out_interv_ds;

  end get_duration;

/******************************************************************************
  START_TIMER
******************************************************************************/

  procedure start_timer
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  )
  as
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
    apex_debug.info
    (
      p_message => 'starting timer on subflow %s, type %s, def %s'
    , p0        => pi_sbfl_id
    , p1        => l_timer_type
    , p2        => l_timer_def
    );
    case l_timer_type
      when flow_constants_pkg.gc_timer_type_date then
        -- check for substitution of process variable
        if upper(substr(l_timer_def,1,5)) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
          l_parsed_ts :=
            flow_process_vars.get_var_date
            ( 
              pi_prcs_id  => pi_prcs_id
            , pi_var_name => substr(l_timer_def,6,length(l_timer_def)-6)
            )
          ;
        else
          l_parsed_ts := to_timestamp_tz( replace ( l_timer_def, 'T', ' ' ), 'YYYY-MM-DD HH24:MI:SS TZR' );
        end if;
      when flow_constants_pkg.gc_timer_type_duration then
        -- check for substitution of process variable
        if upper(substr(l_timer_def,1,5)) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
          l_timer_def :=
            flow_process_vars.get_var_vc2
            ( 
              pi_prcs_id  => pi_prcs_id
            , pi_var_name => substr(l_timer_def,6,length(l_timer_def)-6)
            )
          ;
        end if;     
        get_duration
        (
          in_string     => l_timer_def
        , in_start_ts   => systimestamp
        , out_start_ts  => l_parsed_ts
        , out_interv_ym => l_parsed_duration_ym
        , out_interv_ds => l_parsed_duration_ds
        );
      when flow_constants_pkg.gc_timer_type_cycle then
        if upper( substr( l_timer_def, 1, 5 ) ) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
          l_timer_def :=
            flow_process_vars.get_var_vc2
            ( pi_prcs_id  => pi_prcs_id
            , pi_var_name => substr( l_timer_def, 6, length(l_timer_def) - 6 )
            )
          ;
        end if;
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
      else
        apex_error.add_error
        ( 
          p_message => 'No timer definitions found in start_timer on subflow '||pi_sbfl_id||' type '||l_timer_type||' def '||l_timer_def
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
       and timr_status not in (c_ended, c_expired, c_terminated)
    ;
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
       and timr_status not in (c_ended, c_expired, c_terminated)
    ;
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
       and timr_status not in (c_ended, c_expired, c_terminated)
    ;
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

  procedure disable_scheduled_job
  as
  begin
    execute immediate
    q'[begin
    dbms_scheduler.disable( name => 'apex_flow_step_timers_j' );
    end;
    /]';
  end;

  procedure enable_scheduled_job
  as
  begin
    execute immediate
    q'[begin
    dbms_scheduler.enable( name => 'apex_flow_step_timers_j' );
    end;
    /]';
  end;

end flow_timers_pkg;
/

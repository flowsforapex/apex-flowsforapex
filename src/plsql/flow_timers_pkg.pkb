create or replace package body flow_timers_pkg
as

  lock_timeout             exception;
  e_invalid_duration       exception;
  pragma exception_init (lock_timeout, -3006);  

  type t_timer_def is record
  ( timer_type            flow_types_pkg.t_bpmn_attribute_vc2
  , timer_definition      flow_types_pkg.t_bpmn_attribute_vc2
  , oracle_date           flow_types_pkg.t_bpmn_attribute_vc2
  , oracle_format_mask    flow_types_pkg.t_bpmn_attribute_vc2
  , oracle_duration_ds    flow_types_pkg.t_bpmn_attribute_vc2
  , oracle_duration_ym    flow_types_pkg.t_bpmn_attribute_vc2
  , start_interval_ds     flow_types_pkg.t_bpmn_attribute_vc2
  , repeat_interval_ds    flow_types_pkg.t_bpmn_attribute_vc2
  , max_runs              flow_types_pkg.t_bpmn_attribute_vc2
  );

  function timer_exists
  (
    pi_timr_id in flow_timers.timr_id%type
  ) return boolean
  as
    l_cnt number;
  begin
    select count(*)
      into l_cnt
      from flow_timers
     where timr_id = pi_timr_id
    ;
    return ( l_cnt = 1 );
  end timer_exists;

  procedure lock_timer
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  , pi_sbfl_id  in  flow_subflows.sbfl_id%type
  )
  as
    cursor c_lock is 
      select timr.timr_id 
        from flow_timers timr
       where timr.timr_prcs_id = pi_prcs_id
         and timr.timr_sbfl_id = pi_sbfl_id
      for update of timr.timr_id wait 2;
  begin
    open c_lock;
    close c_lock;
  exception
    when lock_timeout then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'timer-lock-timeout'
      , p0 => pi_sbfl_id         
      );
      -- $F4AMESSAGE 'timer-lock-timeout' || 'Timer for subflow %0 currently locked by another user.  Try again later.'
  end lock_timer;

  procedure lock_process_timers
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  )
  as
    cursor c_lock is 
      select timr.timr_id 
        from flow_timers timr
       where timr.timr_prcs_id = pi_prcs_id
       order by timr.timr_id
      for update of timr.timr_id;
  begin
    open c_lock;
    close c_lock;
  exception
  when lock_timeout then
    flow_errors.handle_instance_error
    ( pi_prcs_id        => pi_prcs_id
    , pi_message_key    => 'timers-lock-timeout'
    , p0 => pi_prcs_id        
    );
    -- $F4AMESSAGE 'timers-lock-timeout' || 'Timers for process %0 currently locked by another user.  Try again later.'
  end lock_process_timers;

  function get_timer_definition
  (
    pi_prcs_id    in         flow_processes.prcs_id%type
  , pi_sbfl_id    in         flow_subflows.sbfl_id%type
  --, po_timer_type out nocopy flow_object_attributes.obat_vc_value%type
  --, po_timer_def  out nocopy flow_object_attributes.obat_vc_value%type
  ) return t_timer_def
  is
    l_timer_def                   t_timer_def;
    l_objt_with_timer             flow_objects.objt_id%type;
    l_objt_with_timer_bpmn_id     flow_objects.objt_bpmn_id%type;
  begin
    -- get objt that timers are attached to (object or attached boundaryEvent)
    begin 
      select objt.objt_id
           , objt.objt_bpmn_id
        into l_objt_with_timer
           , l_objt_with_timer_bpmn_id
        from flow_subflows sbfl
        join flow_objects objt
          on objt.objt_bpmn_id = sbfl.sbfl_current
         and objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
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
            join flow_objects main_objt
              on main_objt.objt_bpmn_id = sbfl.sbfl_current
             and main_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
            join flow_objects boundary_objt
              on boundary_objt.objt_attached_to = main_objt.objt_bpmn_id
             and boundary_objt.objt_dgrm_id = sbfl.sbfl_dgrm_id
           where sbfl.sbfl_id = pi_sbfl_id
             and sbfl.sbfl_prcs_id = pi_prcs_id
             and boundary_objt.objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition
             and boundary_objt.objt_interrupting = 1
          ;
        exception
          when no_data_found then
            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'timer-object-not-found'
            , p0 => pi_sbfl_id          
            );
            -- $F4AMESSAGE 'timer-object-not-found' || 'Object with timer not found in get_timer_definition. Subflow %0.'
        end;
    end;
    apex_debug.info
    (
      p_message => 'get_timer_definition.  Getting timer definition for object %s on subflow %s'
    , p0        => l_objt_with_timer_bpmn_id
    , p1        => pi_sbfl_id
    );
    
    select jt.timer_type
         , jt.timer_definition
         , jt.oracle_date
         , jt.oracle_format_mask
         , jt.oracle_duration_ds
         , jt.oracle_duration_ym
         , jt.start_interval_ds
         , jt.repeat_interval_ds
         , jt.max_runs
      into l_timer_def
      from flow_objects objt
         , json_table( objt.objt_attributes, '$'
             columns
               timer_type         varchar2(4000) path '$.timerType'
             , timer_definition   varchar2(4000) path '$.timerDefinition'
             , oracle_date        varchar2(4000) path '$.apex.date'
             , oracle_format_mask varchar2(4000) path '$.apex.formatMask'
             , oracle_duration_ds varchar2(4000) path '$.apex.intervalDS'
             , oracle_duration_ym varchar2(4000) path '$.apex.intervalYM'
             , start_interval_ds  varchar2(4000) path '$.apex.startIntervalDS'
             , repeat_interval_ds varchar2(4000) path '$.apex.repeatIntervalDS'
             , max_runs           varchar2(4000) path '$.apex.maxRuns'
           ) jt
     where objt.objt_id = l_objt_with_timer
    ;

    if l_timer_def.timer_type is null
       or
       ( l_timer_def.timer_type in  ( flow_constants_pkg.gc_timer_type_date 
                                    , flow_constants_pkg.gc_timer_type_duration
                                    , flow_constants_pkg.gc_timer_type_cycle
                                    )
         and  l_timer_def.timer_definition is null )
       or 
       ( l_timer_def.timer_type = flow_constants_pkg.gc_timer_type_oracle_date
         and  (l_timer_def.oracle_date is null 
              or l_timer_def.oracle_format_mask is null )
       )
       or 
       ( l_timer_def.timer_type = flow_constants_pkg.gc_timer_type_oracle_duration
         and  l_timer_def.oracle_duration_ds is null 
         and  l_timer_def.oracle_duration_ym is null
       )
       or 
       ( l_timer_def.timer_type = flow_constants_pkg.gc_timer_type_oracle_cycle
         and  (l_timer_def.start_interval_ds is null 
              or l_timer_def.repeat_interval_ds is null 
               )  -- note - maxRuns is allowed to be null (means no limit)
       )
    then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'timer-incomplete-definition'
      , p0 => l_objt_with_timer_bpmn_id         
	    , p1 => coalesce ( l_timer_def.timer_type,  '!NULL!')
      , p2 => coalesce ( l_timer_def.timer_definition, l_timer_def.oracle_date
                       , l_timer_def.oracle_duration_ds, l_timer_def.start_interval_ds , '!NULL!')
      , p3 => coalesce ( l_timer_def.oracle_format_mask
                       , l_timer_def.oracle_duration_ym, l_timer_def.repeat_interval_ds,'!NULL!')
      , p4 => coalesce ( l_timer_def.max_runs,'!NULL!')                       
      );
      -- $F4AMESSAGE 'timer-incomplete-definition' || 'Incomplete timer definitions for object %0. Type: %1; Value1: %2 Value2: %3  Value3: %4'
    end if;
    return l_timer_def;
  end get_timer_definition;

  procedure step_timers
  as
    e_resource_timeout      exception;
    pragma                  exception_init(e_resource_timeout, -30006);

    l_timers                flow_timers%rowtype;
    l_run_time              flow_timers.timr_last_run%type := systimestamp;
    l_new_status            flow_timers.timr_status%type;
    l_timr_id               flow_timers.timr_id%type;
    l_timr_run              flow_timers.timr_run%type;
    l_apex_session          number;
  begin
    -- set error_handling to recursive step mode
    flow_globals.set_is_recursive_step (p_is_recursive_step => true);
    loop -- until no records found
      -- could add a functional index on flow_timers to improve performance of this query
      -- eg. create index flow_timr_n1 on flow_timers (
      --          case when timr_status in ( 'C', 'A' ) then coalesce( timr_last_run, timr_created_on ) end);
      select * into l_timers
        from flow_timers
       where rowid in (
          select max(rowid) keep (dense_rank first order by coalesce( timr_last_run, timr_created_on )) trowid
            from flow_timers
           where timr_status = c_created
             --and coalesce( timr_last_run, timr_created_on )  < l_run_time 
             and timr_start_on <= l_run_time
          )
      for update wait 5
      ;

      update flow_timers
      set timr_last_run = systimestamp
          , timr_status = c_ended
      where timr_id = l_timers.timr_id
        and timr_run = l_timers.timr_run
      ;

      begin
        -- create an APEX session for the timer operation
        l_apex_session := flow_apex_session.create_async_session  ( p_process_id => l_timers.timr_prcs_id
                                                                  , p_subflow_id => l_timers.timr_sbfl_id
                                                                  );

        -- ideally the flow_engine should lock the subflow and this procedure should handle the resource 
        -- timeout, deadlock and not found exceptions. This would happen if the subflow is locked waiting 
        -- to delete the timer through a cascade delete.
        if l_timers.timr_type in  ( flow_constants_pkg.gc_timer_type_cycle
                                  , flow_constants_pkg.gc_timer_type_oracle_cycle 
                                  ) 
        then 
          -- repeating / cycle timer.  If unlimited or less than max repeats, run again...∏
          if l_timers.timr_run < l_timers.timr_repeat_times 
          or l_timers.timr_repeat_times is null then 
            l_timr_id   := l_timers.timr_id;
            l_timr_run  := l_timers.timr_run;
          end if;
        else
          l_timr_id   := null;      
          l_timr_run  := null;
        end if;
        flow_engine.flow_handle_event
        (
          p_process_id => l_timers.timr_prcs_id
        , p_subflow_id => l_timers.timr_sbfl_id
        , p_step_key   => l_timers.timr_step_key
        , p_timr_id    => l_timr_id
        , p_run        => l_timr_run
        );
        -- drop the session
        if l_apex_session is not null then
          flow_apex_session.delete_session ( p_session_id => l_apex_session );
        end if;
        commit;
      exception 
        -- Some exception happened during processing the timer
        -- We trap it here and mark respective timer as broken.
        when others then
          update flow_timers
            set timr_status = c_broken
          where timr_id = l_timers.timr_id
            and timr_run = l_timers.timr_run
          ;
          flow_errors.handle_instance_error
          ( pi_prcs_id    => l_timers.timr_prcs_id
          , pi_sbfl_id    => l_timers.timr_sbfl_id
          , pi_message_key => 'timer-broken'
          , p0 => l_timers.timr_id
          , p1 => l_timers.timr_prcs_id
          , p2 => l_timers.timr_sbfl_id
          , p3 => l_timers.timr_run
          );
          -- $F4AMESSAGE 'timer-broken' || 'Timer %0 Run %4 broken in process %1 , subflow : %2.  See error_info.'
          -- set error status on subflow & Process
          flow_errors.set_error_status ( pi_prcs_id  => l_timers.timr_prcs_id 
                                       , pi_sbfl_id  => l_timers.timr_sbfl_id
                                       );
          commit;
      end;

    end loop;
    exception 
      when no_data_found then return;
      when e_resource_timeout then
        -- record requiring update is locked by another process, could put some logging in here
        rollback;
        return;

  end step_timers;

  procedure get_iso_duration
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

    if l_ym_part is not null or l_ds_part is not null then
      out_interv_ym := to_yminterval( 'P' || coalesce(l_ym_part, '0Y') );
      out_interv_ds := to_dsinterval( 'P' || coalesce(l_ds_part, '0D') );

      out_start_ts  := coalesce( in_start_ts, systimestamp ) + out_interv_ym + out_interv_ds;
    else
      raise e_invalid_duration;
    end if;

  end get_iso_duration;

/******************************************************************************
  START_TIMER
******************************************************************************/

  procedure start_new_timer
  (
    pi_prcs_id    in flow_processes.prcs_id%type
  , pi_sbfl_id    in flow_subflows.sbfl_id%type 
  , pi_step_key   in flow_subflows.sbfl_step_key%type default null
  )
  as
    l_parsed_ts           flow_timers.timr_start_on%type;
    l_parsed_duration_ym  flow_timers.timr_interval_ym%type;
    l_parsed_duration_ds  flow_timers.timr_interval_ds%type;
    l_repeat_times        flow_timers.timr_repeat_times%type;
    l_repeat_def          varchar2(200);
    l_timer_def           t_timer_def;
    l_time_string         varchar2(20);
    e_invalid_repeat      exception;
    l_scope               flow_subflows.sbfl_scope%type;
  begin
    apex_debug.enter 
    ( 'start_new_timer'
    , 'prcs_id', pi_prcs_id
    , 'sbfl_id', pi_sbfl_id
    , 'step_key', pi_step_key
    );
    -- preset async session parameters in proc variables
    flow_apex_session.set_async_proc_vars
        ( p_process_id  => pi_prcs_id
        , p_subflow_id  => pi_sbfl_id
        );
    -- set up scheduled firing time
    l_timer_def := get_timer_definition
                  (
                    pi_prcs_id    => pi_prcs_id
                  , pi_sbfl_id    => pi_sbfl_id
                  );
    apex_debug.info
    (
      p_message => 'starting new timer on subflow %0, type %1, key1: %2, key2 : %3 , key3: %4'
    , p0        => pi_sbfl_id
    , p1        => l_timer_def.timer_type
    , p2        => coalesce( l_timer_def.timer_definition , l_timer_def.oracle_date
                           , l_timer_def.oracle_duration_DS,  l_timer_def.start_Interval_DS , '<null>')
    , p3        => coalesce( l_timer_def.oracle_format_mask, l_timer_def.repeat_interval_ds, '<null>')
    , p4        => coalesce( l_timer_def.max_runs, '<null>')
    );

    l_scope := flow_engine_util.get_scope (p_process_id => pi_prcs_id, p_subflow_id => pi_sbfl_id );

    begin
      case l_timer_def.timer_type
        when flow_constants_pkg.gc_timer_type_date then
          -- ISO 8601 date - check for substitution of process variable
          if upper(substr(l_timer_def.timer_definition,1,5)) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
            case flow_proc_vars_int.get_var_type ( pi_prcs_id  => pi_prcs_id
                                                 , pi_var_name => substr(l_timer_def.timer_definition,6,length(l_timer_def.timer_definition)-6)
                                                 , pi_scope    => l_scope
                                                )
            when flow_constants_pkg.gc_prov_var_type_date then
                -- substitution parameter is a date process var = already an Oracle date
                l_parsed_ts :=
                  flow_proc_vars_int.get_var_date
                  ( 
                    pi_prcs_id  => pi_prcs_id
                  , pi_var_name => substr(l_timer_def.timer_definition,6,length(l_timer_def.timer_definition)-6)
                  , pi_scope    => l_scope
                  )
                ;
            when flow_constants_pkg.gc_prov_var_type_varchar2 then
                l_parsed_ts := to_timestamp_tz ( flow_proc_vars_int.get_var_vc2
                                                 ( pi_prcs_id  => pi_prcs_id
                                                 , pi_var_name => substr  ( l_timer_def.timer_definition,6
                                                                          , length(l_timer_def.timer_definition)-6
                                                                          )
                                                 , pi_scope    => l_scope
                                                 )
                                                , flow_constants_pkg.gc_prov_default_date_format
                                                );
            end case;
          elsif substr(l_timer_def.timer_definition,1,1) = 'T' then
            -- check for just an ISO Time, and then get next time that time of day occurs (today/tomorrow)
            l_time_string := substr(l_timer_def.timer_definition,2,8);
            case 
              when  (sysdate - to_date(to_char(sysdate,'YYYY-MM-DD ')||l_time_string,'YYYY-MM-DD HH24:MI:SS')) < 0 then
                -- today
                l_parsed_ts := to_timestamp_tz( to_char (sysdate,'YYYY-MM-DD ')||l_time_string, 'YYYY-MM-DD HH24:MI:SS');
              else
                -- tomorrow
                l_parsed_ts := to_timestamp_tz(to_char ( sysdate+1,'YYYY-MM-DD ')||l_time_string,'YYYY-MM-DD HH24:MI:SS');
            end case;

          else
            -- assume we have an ISO date-time
            l_parsed_ts := to_timestamp_tz( replace ( l_timer_def.timer_definition, 'T', ' ' ), 'YYYY-MM-DD HH24:MI:SS TZR' );
          end if;
        when flow_constants_pkg.gc_timer_type_duration then
          -- ISO 8601 Duration - check for substitution of process variable
          if upper(substr(l_timer_def.timer_definition,1,5)) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
            l_timer_def.timer_definition :=
              flow_proc_vars_int.get_var_vc2
              ( 
                pi_prcs_id  => pi_prcs_id
              , pi_var_name => substr(l_timer_def.timer_definition,6,length(l_timer_def.timer_definition)-6)
              , pi_scope    => l_scope
              )
            ;
          end if;     
          get_iso_duration
          (
            in_string     => l_timer_def.timer_definition
          , in_start_ts   => systimestamp
          , out_start_ts  => l_parsed_ts
          , out_interv_ym => l_parsed_duration_ym
          , out_interv_ds => l_parsed_duration_ds
          );
        when flow_constants_pkg.gc_timer_type_cycle then
          -- ISO 8601 Cycle - check for substitution of process variable
          flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                             , pi_sbfl_id => pi_sbfl_id
                                             , pi_scope   => l_scope
                                             , pio_string => l_timer_def.timer_definition
                                             );
          l_repeat_def := regexp_substr (l_timer_def.timer_definition, '^'||'R([0-9]*|-1)\/'); -- using concatenation to prevent substitution on installation via script
          if l_repeat_def is null then
            raise e_invalid_repeat;
          end if;
          l_repeat_times := substr ( l_timer_def.timer_definition, 2
                                   , instr( l_timer_def.timer_definition, '/', 1, 1 ) - 2 
                                   );
          if l_repeat_times = -1 or l_repeat_times is null then 
            -- ISO8601 repeat -1 means unlimited so set repeat_times to max cycles
            l_repeat_times := flow_engine_util.get_config_value 
            ( p_config_key    => flow_constants_pkg.gc_config_timer_max_cycles
            , p_default_value => flow_constants_pkg.gc_config_default_timer_max_cycles
            );
          elsif l_repeat_times = 0 then
            -- according to ISO 8601 it should run 1 time but not repeat
            l_repeat_times := 1;
          end if;

          l_timer_def.timer_definition := substr  ( l_timer_def.timer_definition
                                                  , instr( l_timer_def.timer_definition, '/', 1, 1 ) + 1  
                                                  );
          get_iso_duration
          (
            in_string     => l_timer_def.timer_definition
          , in_start_ts   => systimestamp
          , out_start_ts  => l_parsed_ts
          , out_interv_ym => l_parsed_duration_ym
          , out_interv_ds => l_parsed_duration_ds
          );
        when flow_constants_pkg.gc_timer_type_oracle_date then

          if upper(substr(l_timer_def.oracle_date,1,5)) = flow_constants_pkg.gc_substitution_prefix || flow_constants_pkg.gc_substitution_flow_identifier then
            case flow_proc_vars_int.get_var_type ( pi_prcs_id  => pi_prcs_id
                                                 , pi_var_name => substr(l_timer_def.oracle_date,6,length(l_timer_def.oracle_date)-6)
                                                 , pi_scope    => l_scope
                                                 )
            when flow_constants_pkg.gc_prov_var_type_date then
                -- substitution parameter is a date process var = already an Oracle date
                l_parsed_ts :=
                  flow_proc_vars_int.get_var_date
                  ( 
                    pi_prcs_id  => pi_prcs_id
                  , pi_var_name => substr(l_timer_def.oracle_date,6,length(l_timer_def.oracle_date)-6)
                  , pi_scope    => l_scope
                  )
                ;
            when flow_constants_pkg.gc_prov_var_type_varchar2 then
                -- substitution parameter is a vc2 - use the specified format mask
                l_parsed_ts := to_timestamp_tz ( flow_proc_vars_int.get_var_vc2
                                                  ( pi_prcs_id  => pi_prcs_id
                                                  , pi_var_name => substr  ( l_timer_def.oracle_date,6
                                                                           , length(l_timer_def.oracle_date)-6
                                                                           )
                                                  , pi_scope    => l_scope
                                                  )
                                                , l_timer_def.oracle_format_mask
                                                );
            end case;
          else
            -- just use the specified date and format mask
            l_parsed_ts := to_timestamp ( l_timer_def.oracle_date, l_timer_def.oracle_format_mask);
          end if;
        when flow_constants_pkg.gc_timer_type_oracle_duration then 
          -- handle possible vc2-typed subsitutions for both parameters
          flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                             , pi_sbfl_id => pi_sbfl_id
                                             , pio_string => l_timer_def.oracle_duration_ds
                                             , pi_scope   => l_scope
                                             );
          flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                             , pi_sbfl_id => pi_sbfl_id
                                             , pio_string => l_timer_def.oracle_duration_ym
                                             , pi_scope   => l_scope
                                             );
          l_parsed_duration_ds := to_dsinterval ( nvl ( l_timer_def.oracle_duration_ds , '000 00:00:00') );
          l_parsed_duration_ym := to_yminterval ( nvl( l_timer_def.oracle_duration_ym, '0-0') );
          l_parsed_ts := systimestamp + l_parsed_duration_ym + l_parsed_duration_ds;

        when flow_constants_pkg.gc_timer_type_oracle_cycle then
          -- oracle cycle timer - all 3 parameters can be substituted with vc2-type proc var
          flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                             , pi_sbfl_id => pi_sbfl_id
                                             , pi_scope   => l_scope
                                             , pio_string => l_timer_def.start_interval_ds
                                             );
          flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                             , pi_sbfl_id => pi_sbfl_id
                                             , pi_scope   => l_scope
                                             , pio_string => l_timer_def.repeat_interval_ds
                                             ); 
          if l_timer_def.max_runs is not null then            
            flow_proc_vars_int.do_substitution ( pi_prcs_id => pi_prcs_id
                                               , pi_sbfl_id => pi_sbfl_id
                                               , pi_scope   => l_scope
                                               , pio_string => l_timer_def.max_runs
                                               );                                                       
            l_repeat_times  := to_number ( l_timer_def.max_runs );
          else
            l_repeat_times := flow_engine_util.get_config_value 
                              ( p_config_key    => flow_constants_pkg.gc_config_timer_max_cycles
                              , p_default_value => flow_constants_pkg.gc_config_default_timer_max_cycles
                              );
          end if;
          l_parsed_ts           := systimestamp + to_dsinterval ( l_timer_def.start_interval_ds );
          l_parsed_duration_ym  := to_yminterval ('0-0');  -- UI currently does not allow YM input so set to 0
          l_parsed_duration_ds  := to_dsinterval ( l_timer_def.repeat_interval_ds );
        else
          flow_errors.handle_instance_error
          ( pi_prcs_id        => pi_prcs_id
          , pi_sbfl_id        => pi_sbfl_id
          , pi_message_key    => 'timer-incomplete-definition'
          , p0 => pi_sbfl_id         
	        , p1 => l_timer_def.timer_type
          , p2 => l_timer_def.timer_definition
          );
          -- $F4AMESSAGE 'timer-incomplete-definition' || 'Incomplete timer definitions for object %0. Type: %1; Value: %2'
      end case;
    exception
      when e_invalid_repeat or e_invalid_duration then
        flow_errors.handle_instance_error
        (
          pi_prcs_id     => pi_prcs_id
        , pi_sbfl_id     => pi_sbfl_id
        , pi_message_key => 'timer_definition_error'
        , p0             => pi_prcs_id
        , p1             => pi_sbfl_id
        , p2             => l_timer_def.timer_type
        , p3             => l_timer_def.timer_definition
        );
      when others then
        flow_errors.handle_instance_error
        (
          pi_prcs_id     => pi_prcs_id
        , pi_sbfl_id     => pi_sbfl_id
        , pi_message_key => 'timer_definition_error'
        , p0             => pi_prcs_id
        , p1             => pi_sbfl_id
        , p2             => l_timer_def.timer_type
        , p3             => l_timer_def.timer_definition
        );
    end;    

    insert into flow_timers
      (
        timr_prcs_id
      , timr_sbfl_id
      , timr_step_key
      , timr_run
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
      , pi_step_key
      , 1
      , l_timer_def.timer_type
      , systimestamp
      , c_created
      , l_parsed_ts
      , l_parsed_duration_ym
      , l_parsed_duration_ds
      , l_repeat_times
      )
    ;

  end start_new_timer;

  procedure start_repeat_timer
  (
    pi_prcs_id    in flow_processes.prcs_id%type
  , pi_sbfl_id    in flow_subflows.sbfl_id%type 
  , pi_step_key   in flow_subflows.sbfl_step_key%type default null
  , pi_run        in flow_timers.timr_run%type default 1 -- 1 original, 2-> repeats
  , pi_timr_id    in flow_timers.timr_id%type default null -- only set on repeats
  )
  as
    l_parsed_ts           flow_timers.timr_start_on%type;
    l_parsed_duration_ym  flow_timers.timr_interval_ym%type;
    l_parsed_duration_ds  flow_timers.timr_interval_ds%type;
    l_repeat_times        flow_timers.timr_repeat_times%type;
    l_timer_def           t_timer_def;
  begin
    apex_debug.enter 
    ( 'start_repeat_timer'
    , 'prcs_id', pi_prcs_id
    , 'sbfl_id', pi_sbfl_id
    , 'step_key', pi_step_key
    , 'timr_id (repeats)', pi_timr_id
    , 'run', pi_run
    );

    insert into flow_timers
    ( timr_id
    , timr_run
    , timr_prcs_id
    , timr_sbfl_id
    , timr_step_key
    , timr_type
    , timr_created_on
    , timr_status
    , timr_start_on
    , timr_interval_ym
    , timr_interval_ds
    , timr_repeat_times
    ) 
    select
      pi_timr_id
    , pi_run
    , pi_prcs_id
    , pi_sbfl_id
    , pi_step_key
    , old_timr.timr_type
    , systimestamp
    , c_created
    , systimestamp + nvl(old_timr.timr_interval_ym,'0-0') + nvl(old_timr.timr_interval_ds,'0 00:00:00')
    , old_timr.timr_interval_ym
    , old_timr.timr_interval_ds
    , old_timr.timr_repeat_times
    from flow_timers old_timr
    where old_timr.timr_id = pi_timr_id
      and old_timr.timr_run = pi_run - 1
      and old_timr.timr_prcs_id = pi_prcs_id
    ;

  end start_repeat_timer;

  procedure start_timer
  (
    pi_prcs_id    in flow_processes.prcs_id%type
  , pi_sbfl_id    in flow_subflows.sbfl_id%type 
  , pi_step_key   in flow_subflows.sbfl_step_key%type default null
  , pi_run        in flow_timers.timr_run%type default 1 -- 1 original, 2-> repeats
  , pi_timr_id    in flow_timers.timr_id%type default null -- only set on repeats
  )
  as
    l_parsed_ts           flow_timers.timr_start_on%type;
    l_parsed_duration_ym  flow_timers.timr_interval_ym%type;
    l_parsed_duration_ds  flow_timers.timr_interval_ds%type;
    l_repeat_times        flow_timers.timr_repeat_times%type;
    l_timer_def           t_timer_def;
  begin
    apex_debug.enter 
    ( 'start_timer'
    , 'prcs_id', pi_prcs_id
    , 'sbfl_id', pi_sbfl_id
    , 'step_key', pi_step_key
    , 'timr_id (repeats)', pi_timr_id
    , 'timer run', pi_run
    );
    if pi_run = 1 and pi_timr_id is null then
      -- starting the first run of a new timer
      start_new_timer
      ( pi_prcs_id   => pi_prcs_id   
      , pi_sbfl_id   => pi_sbfl_id  
      , pi_step_key  => pi_step_key 
      );
    elsif pi_run > 1 and pi_timr_id is not null then
        -- starting a repeat cycle of a existing timer (on a new sbfl)
      start_repeat_timer
      ( pi_prcs_id   => pi_prcs_id   
      , pi_sbfl_id   => pi_sbfl_id  
      , pi_step_key  => pi_step_key 
      , pi_run       => pi_run
      , pi_timr_id   => pi_timr_id
      );  
    else
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'timer-internal-error'
        , p0 => pi_sbfl_id         
	      , p1 => pi_run
        , p2 => pi_timr_id
        );
        -- $F4AMESSAGE 'timer-internal-error' || 'Timer internal error  for object %0. Type: %1; Value: %2'
    end if;
  end start_timer;

/******************************************************************************
  RESCHEDULE_TIMER
*******************************************************************************/

procedure reschedule_timer
(
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_is_immediate  in boolean default false
  , p_new_timestamp in flow_timers.timr_start_on%type default null
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
)
is
  l_timer_rec       flow_timers%rowtype;
  e_bad_new_timer   exception;
  l_current_object  flow_subflows.sbfl_current%type;
begin
  apex_debug.enter 
  ( 'reschedule_timer'
  , 'Process ID',  p_process_id
  , 'Subflow ID', p_subflow_id
  , 'Step Key', p_step_key
  , 'Immediate', case when p_is_immediate then 'true' else 'false' end
  , 'New Timestamp', p_new_timestamp
  );
  -- lock the timer
  select *
    into l_timer_rec
    from flow_timers timr 
   where timr.timr_prcs_id = p_process_id
     and timr.timr_sbfl_id = p_subflow_id
     for update wait 5
  ;
  if flow_engine_util.step_key_valid( pi_prcs_id  => p_process_id
                                    , pi_sbfl_id  => p_subflow_id
                                    , pi_step_key_supplied  => p_step_key
                                    , pi_step_key_required  => l_timer_rec.timr_step_key) then 
    if p_is_immediate then
      l_timer_rec.timr_start_on := systimestamp;
    elsif p_new_timestamp >= systimestamp then
      l_timer_rec.timr_start_on := p_new_timestamp;
    elsif not p_is_immediate  and p_new_timestamp is null then
      raise e_bad_new_timer;
    end if;

    update flow_timers
       set timr_start_on = l_timer_rec.timr_start_on
         , timr_status = c_created
     where timr_id = l_timer_rec.timr_id
       and timr_run = l_timer_rec.timr_run
    ;

    select sbfl.sbfl_current
      into l_current_object
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;

    flow_logging.log_instance_event
    ( p_process_id  => p_process_id
    , p_objt_bpmn_id  => l_current_object
    , p_event  => flow_constants_pkg.gc_prcs_event_rescheduled
    , p_comment  => p_comment
    );

  end if;
exception
  when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_sbfl_id     => p_subflow_id
      , pi_message_key => 'engine-util-sbfl-not-found'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'engine-util-sbfl-not-found' || 'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'  
  when lock_timeout then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_sbfl_id     => p_subflow_id
      , pi_message_key => 'timeout_locking_subflow'
      , p0 => p_subflow_id
      );
      -- $F4AMESSAGE 'timeout_locking_subflow' || 'Unable to lock subflow %0 as currently locked by another user.  Retry your transaction later.'  
  when e_bad_new_timer then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_sbfl_id        => p_subflow_id
        , pi_message_key    => 'timer-incomplete-definition'
        , p0 => p_subflow_id       
	      , p1 => case when p_is_immediate then 'true' else 'false' end
        , p2 => p_new_timestamp
        );
        -- $F4AMESSAGE 'timer-incomplete-definition' || 'Incomplete timer definitions for object %0. Type: %1; Value: %2'

end reschedule_timer;




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
    sys.dbms_scheduler.disable( name => 'apex_flow_step_timers_j' );
    end;]';
  end;

  procedure enable_scheduled_job
  as
  begin
    execute immediate
    q'[begin
    sys.dbms_scheduler.enable( name => 'apex_flow_step_timers_j' );
    end;]';
  end;

end flow_timers_pkg;
/

create or replace package body flow_statistics
as
/* 
-- Flows for APEX - flow_statistics.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    11-Jan-2023  Richard Allen (Oracle)
--
*/




------------------
---  collect daily step stats
-------------------
  procedure create_daily_step_summary
  ( p_start_date   in   date
  )
  is
  begin
      insert into flow_step_stats 
          ( stsf_dgrm_id
          , stsf_tag_name
          , stsf_objt_bpmn_id
          , stsf_period_start
          , stsf_period
          , stsf_duration_10pc_ivl
          , stsf_duration_50pc_ivl
          , stsf_duration_90pc_ivl
          , stsf_duration_max_ivl
          , stsf_duration_10pc_sec
          , stsf_duration_50pc_sec
          , stsf_duration_90pc_sec
          , stsf_duration_max_sec
          , stsf_waiting_10pc_ivl
          , stsf_waiting_50pc_ivl
          , stsf_waiting_90pc_ivl
          , stsf_waiting_max_ivl
          , stsf_waiting_10pc_sec
          , stsf_waiting_50pc_sec
          , stsf_waiting_90pc_sec
          , stsf_waiting_max_sec  
          , stsf_completed
          ) 
      with ivl_stats as
        ( select  lgsf_sbfl_dgrm_id                                                   as dgrm_id
                  , objt.objt_tag_name                                                as objt_tag_name
                  , lgsf_objt_id                                                      as objt_bpmn_id
                  , trunc (sys_extract_utc ( lgsf_completed ))                        as period_start
                  , approx_percentile (0.10 )
                      within group (order by (lgsf_completed - lgsf_was_current) ASC) as duration_10pc_ivl
                  , approx_percentile (0.50 )
                      within group (order by lgsf_completed - lgsf_was_current ASC)   as duration_50pc_ivl
                  , approx_percentile (0.90 )
                      within group (order by lgsf_completed - lgsf_was_current ASC)   as duration_90pc_ivl
                  , max ( lgsf_completed - lgsf_was_current)                          as duration_max_ivl
                  , approx_percentile (0.10 )
                      within group (order by (lgsf_started - lgsf_was_current) ASC)   as waiting_10pc_ivl
                  , approx_percentile (0.50 )
                      within group (order by lgsf_started - lgsf_was_current ASC)     as waiting_50pc_ivl
                  , approx_percentile (0.90 )
                      within group (order by lgsf_started - lgsf_was_current ASC)     as waiting_90pc_ivl
                  , max ( lgsf_started - lgsf_was_current)                            as waiting_max_ivl
                  , count (*)                                                         as completed
             from flow_step_event_log lgsf
        left join flow_objects objt
               on objt.objt_dgrm_id = lgsf.lgsf_sbfl_dgrm_id
              and objt.objt_bpmn_id = lgsf.lgsf_objt_id
            where objt.objt_tag_name in ( 'bpmn:userTask', 'bpmn:serviceTask', 'bpmn:manualTask'
                                        , 'bpmn:subProcess', 'bpmn:callActivity', 'bpmn:scriptTask', 'bpmn:task')
         group by lgsf_sbfl_dgrm_id, objt.objt_tag_name, lgsf_objt_id, trunc (sys_extract_utc ( lgsf_completed ))
        )
      select i.dgrm_id
           , i.objt_tag_name
           , i.objt_bpmn_id
           , i.period_start
           , flow_constants_pkg.gc_stats_period_day 
           , i.duration_10pc_ivl
           , i.duration_50pc_ivl
           , i.duration_90pc_ivl
           , i.duration_max_ivl
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.duration_10pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.duration_50pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.duration_90pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.duration_max_ivl)
           , i.waiting_10pc_ivl
           , i.waiting_50pc_ivl
           , i.waiting_90pc_ivl
           , i.waiting_max_ivl
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.waiting_10pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.waiting_50pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.waiting_90pc_ivl)
           , flow_api_pkg.intervaldstosec (p_intervalds  => i.waiting_max_ivl) 
           , i.completed 
      from ivl_stats i
      where i.period_start between p_start_date and trunc(sysdate)-1
      ;
  end create_daily_step_summary;
  
  
  procedure create_monthly_step_summaries
  ( p_start_date in date
  )
  is
  begin
    -- delete existing MTD summaries
    -- delete and recreate, rather than update,  because not all instances might have a MTD summary for this month yet
    delete from flow_step_stats
     where stsf_period = 'MTD';
    -- now create 'MONTH' summaries for any month that doesn't yet exist and MTD to current month
    insert into flow_step_stats 
            ( stsf_dgrm_id
            , stsf_tag_name
            , stsf_objt_bpmn_id
            , stsf_period_start
            , stsf_period
            , stsf_duration_10pc_ivl
            , stsf_duration_50pc_ivl
            , stsf_duration_90pc_ivl
            , stsf_duration_max_ivl
            , stsf_duration_10pc_sec
            , stsf_duration_50pc_sec
            , stsf_duration_90pc_sec
            , stsf_duration_max_sec
            , stsf_waiting_10pc_ivl
            , stsf_waiting_50pc_ivl
            , stsf_waiting_90pc_ivl
            , stsf_waiting_max_ivl
            , stsf_waiting_10pc_sec
            , stsf_waiting_50pc_sec
            , stsf_waiting_90pc_sec
            , stsf_waiting_max_sec  
            , stsf_completed
            )
    with mon as 
    (
      select stsf_dgrm_id, 
             stsf_tag_name,
             stsf_objt_bpmn_id,
             trunc(stsf_period_start, 'MM') period_start, 
             sum ( ds.stsf_duration_10pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_10pc_sec,
             sum ( ds.stsf_duration_50pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_50pc_sec, 
             sum ( ds.stsf_duration_90pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_90pc_sec, 
             sum ( ds.stsf_duration_max_sec  * ds.stsf_completed ) / sum (ds.stsf_completed) duration_max_sec,
             sum ( ds.stsf_waiting_10pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_10pc_sec,
             sum ( ds.stsf_waiting_50pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_50pc_sec, 
             sum ( ds.stsf_waiting_90pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_90pc_sec, 
             sum ( ds.stsf_waiting_max_sec  * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_max_sec,
             sum ( stsf_completed) stsf_completed
      from   flow_step_stats ds
      where  ds.stsf_period = 'DAY'
      group by stsf_dgrm_id, stsf_tag_name, stsf_objt_bpmn_id, trunc(stsf_period_start, 'MM')
      order by stsf_dgrm_id, stsf_tag_name, stsf_objt_bpmn_id, trunc(stsf_period_start, 'MM')
    )
    select mon.stsf_dgrm_id
         , mon.stsf_tag_name
         , mon.stsf_objt_bpmn_id
         , mon.period_start
         , case when mon.period_start = trunc(sys_extract_utc(systimestamp),'MM') then 'MTD'
                else 'MONTH' end as period
         , numtodsinterval (mon.duration_10pc_sec , 'SECOND') as duration_10pc_ivl
         , numtodsinterval (mon.duration_50pc_sec , 'SECOND') as duration_50pc_ivl
         , numtodsinterval (mon.duration_90pc_sec , 'SECOND') as duration_90pc_ivl
         , numtodsinterval (mon.duration_max_sec  , 'SECOND') as duration_max_ivl
         , mon.duration_10pc_sec
         , mon.duration_50pc_sec
         , mon.duration_90pc_sec
         , mon.duration_max_sec
         , numtodsinterval (mon.waiting_10pc_sec , 'SECOND') as waiting_10pc_ivl
         , numtodsinterval (mon.waiting_50pc_sec , 'SECOND') as waiting_50pc_ivl
         , numtodsinterval (mon.waiting_90pc_sec , 'SECOND') as waiting_90pc_ivl
         , numtodsinterval (mon.waiting_max_sec  , 'SECOND') as waiting_max_ivl
         , mon.waiting_10pc_sec
         , mon.waiting_50pc_sec
         , mon.waiting_90pc_sec
         , mon.waiting_max_sec
         , mon.stsf_completed
    from mon
    where mon.period_start >= trunc(p_start_date,'MM');
  
  end create_monthly_step_summaries; 

  -- quarter step stats

  procedure create_quarterly_step_summaries  
  ( p_start_date   in date
  )
  is
  begin
    insert into flow_step_stats 
        ( stsf_dgrm_id
        , stsf_tag_name
        , stsf_objt_bpmn_id
        , stsf_period_start
        , stsf_period
        , stsf_duration_10pc_ivl
        , stsf_duration_50pc_ivl
        , stsf_duration_90pc_ivl
        , stsf_duration_max_ivl
        , stsf_duration_10pc_sec
        , stsf_duration_50pc_sec
        , stsf_duration_90pc_sec
        , stsf_duration_max_sec
        , stsf_waiting_10pc_ivl
        , stsf_waiting_50pc_ivl
        , stsf_waiting_90pc_ivl
        , stsf_waiting_max_ivl
        , stsf_waiting_10pc_sec
        , stsf_waiting_50pc_sec
        , stsf_waiting_90pc_sec
        , stsf_waiting_max_sec  
        , stsf_completed
        )
    with mon as 
    (
    select stsf_dgrm_id, 
           stsf_tag_name,
           stsf_objt_bpmn_id,
           trunc(stsf_period_start, 'Q') period_start, 
           sum ( ds.stsf_duration_10pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_10pc_sec,
           sum ( ds.stsf_duration_50pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_50pc_sec, 
           sum ( ds.stsf_duration_90pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) duration_90pc_sec, 
           sum ( ds.stsf_duration_max_sec  * ds.stsf_completed ) / sum (ds.stsf_completed) duration_max_sec,
           sum ( ds.stsf_waiting_10pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_10pc_sec,
           sum ( ds.stsf_waiting_50pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_50pc_sec, 
           sum ( ds.stsf_waiting_90pc_sec * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_90pc_sec, 
           sum ( ds.stsf_waiting_max_sec  * ds.stsf_completed ) / sum (ds.stsf_completed) waiting_max_sec,
           sum ( stsf_completed) stsf_completed
     from  flow_step_stats ds
    where  ds.stsf_period = 'MONTH'
      and  ds.stsf_period_start >= p_start_date
    group by stsf_dgrm_id, stsf_tag_name, stsf_objt_bpmn_id, trunc(stsf_period_start, 'Q')
    order by stsf_dgrm_id, stsf_tag_name, stsf_objt_bpmn_id, trunc(stsf_period_start, 'Q')
    )
    select mon.stsf_dgrm_id
         , mon.stsf_tag_name
         , mon.stsf_objt_bpmn_id
         , mon.period_start
         , 'QUARTER' as period
         , numtodsinterval (mon.duration_10pc_sec , 'SECOND') as duration_10pc_ivl
         , numtodsinterval (mon.duration_50pc_sec , 'SECOND') as duration_50pc_ivl
         , numtodsinterval (mon.duration_90pc_sec , 'SECOND') as duration_90pc_ivl
         , numtodsinterval (mon.duration_max_sec  , 'SECOND') as duration_max_ivl
         , mon.duration_10pc_sec
         , mon.duration_50pc_sec
         , mon.duration_90pc_sec
         , mon.duration_max_sec
         , numtodsinterval (mon.waiting_10pc_sec , 'SECOND') as waiting_10pc_ivl
         , numtodsinterval (mon.waiting_50pc_sec , 'SECOND') as waiting_50pc_ivl
         , numtodsinterval (mon.waiting_90pc_sec , 'SECOND') as waiting_90pc_ivl
         , numtodsinterval (mon.waiting_max_sec  , 'SECOND') as waiting_max_ivl
         , mon.waiting_10pc_sec
         , mon.waiting_50pc_sec
         , mon.waiting_90pc_sec
         , mon.waiting_max_sec
         , mon.stsf_completed
    from mon
    where mon.period_start between p_start_date and add_months ( trunc( sys_extract_utc (systimestamp), 'Q' ), -3)
    ;
  end create_quarterly_step_summaries;

  ------------------
  ---  collect daily process stats
  -------------------
  procedure create_daily_instance_summary
  ( p_start_date   in   date
  )
  is
  begin
    insert into flow_instance_stats
        ( stpr_dgrm_id    
        , stpr_period_start  
        , stpr_period
        , stpr_created    
        , stpr_started    
        , stpr_error      
        , stpr_completed  
        , stpr_terminated 
        , stpr_reset      
        , stpr_duration_10pc_ivl
        , stpr_duration_50pc_ivl
        , stpr_duration_90pc_ivl
        , stpr_duration_max_ivl 
        , stpr_duration_10pc_sec
        , stpr_duration_50pc_sec
        , stpr_duration_90pc_sec
        , stpr_duration_max_sec 
        )
    with daily_event_completion_times as
        (   select lgpr_dgrm_id dgrm_id
                 , trunc (sys_extract_utc (lgpr_timestamp )) period_start
                 , lgpr_prcs_event event
                 , count (*) times
                 , approx_percentile (0.10 )
                        within group (order by (lgpr_duration) ASC) duration_10pc_ivl
                 , approx_percentile (0.50 )
                        within group (order by (lgpr_duration) ASC) duration_50pc_ivl
                 , approx_percentile (0.90 )
                        within group (order by (lgpr_duration) ASC) duration_90pc_ivl
                 , max (lgpr_duration) duration_Max_ivl
            from flow_instance_event_log lgpr
            where lgpr.lgpr_prcs_event in ('created','started', 'error', 'completed', 'terminated', 'reset')
            group by lgpr_dgrm_id
                   , trunc (sys_extract_utc (lgpr_timestamp )) 
                   , lgpr_prcs_event
            order by lgpr_dgrm_id
                   , trunc (sys_extract_utc (lgpr_timestamp )) 
                   , lgpr_prcs_event 
        ),
    prcs_pivot_totals as 
        (    select * from 
                (select dgrm_id, period_start, event, times 
                from daily_event_completion_times
                ) tot pivot (sum (times)
                for event in ( 'created' as CREATED, 'started' as STARTED, 'error' as ERROR
                             , 'completed' as COMPLETED, 'terminated' as TERMINATED, 'reset' as RESET))
            order by dgrm_id  
        )
    select t.dgrm_id
         , t.period_start
         , flow_constants_pkg.gc_stats_period_day 
         , p.created, p.started, p.error, p.completed, p.terminated, p.reset
         , t.duration_10pc_ivl
         , t.duration_50pc_ivl
         , t.duration_90pc_ivl
         , t.duration_Max_ivl
         , flow_api_pkg.intervalDStoSec (t.duration_10pc_ivl) duration_10pc_sec
         , flow_api_pkg.intervalDStoSec (t.duration_50pc_ivl) duration_50pc_sec
         , flow_api_pkg.intervalDStoSec (t.duration_90pc_ivl) duration_90pc_sec
         , flow_api_pkg.intervalDStoSec (t.duration_max_ivl ) duration_max_sec
     from  prcs_pivot_totals p
     join  daily_event_completion_times t
       on  t.dgrm_id = p.dgrm_id
      and  t.period_start = p.period_start
    where  t.event = 'completed'
      and  t.period_start between p_start_date and trunc(sysdate)-1
    ;
  end create_daily_instance_summary;


  -- creeate monthly instance summaries
  procedure create_monthly_instance_summaries
  ( p_start_date in date
  )
  is
  begin
    -- delete existing MTD summaries
    -- delete and recreate, rather than update,  because not all instances might have a MTD summary for this month yet
    delete from flow_instance_stats
     where stpr_period = 'MTD';
    -- now create 'MONTH' summaries for any month that doesn't yet exist and MTD to current month
    insert into flow_instance_stats
        ( stpr_dgrm_id    
        , stpr_period_start  
        , stpr_period
        , stpr_created    
        , stpr_started    
        , stpr_error      
        , stpr_completed  
        , stpr_terminated 
        , stpr_reset      
        , stpr_duration_10pc_ivl
        , stpr_duration_50pc_ivl
        , stpr_duration_90pc_ivl
        , stpr_duration_max_ivl 
        , stpr_duration_10pc_sec
        , stpr_duration_50pc_sec
        , stpr_duration_90pc_sec
        , stpr_duration_max_sec 
        )
    with mon as 
    (
    select stpr_dgrm_id, 
           trunc(stpr_period_start, 'MM') period_start, 
           sum (stpr_created) stpr_created,
           sum (stpr_started) stpr_started,
           sum (stpr_error) stpr_error,
           sum (stpr_completed) stpr_completed,
           sum (stpr_terminated) stpr_terminated,
           sum (stpr_reset) stpr_reset,
           sum ( ds.stpr_duration_10pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_10pc_sec,
           sum ( ds.stpr_duration_50pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_50pc_sec, 
           sum ( ds.stpr_duration_90pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_90pc_sec, 
           sum ( ds.stpr_duration_max_sec * ds.stpr_completed  ) / sum (ds.stpr_completed) duration_max_sec
    from   flow_instance_stats ds
    where  ds.stpr_period = 'DAY'
    group by stpr_dgrm_id, trunc(stpr_period_start, 'MM')
    order by stpr_dgrm_id, trunc(stpr_period_start, 'MM')
    )
    select mon.stpr_dgrm_id
         , mon.period_start
         , case when mon.period_start = trunc(sys_extract_utc(systimestamp),'MM') then 'MTD'
                else 'MONTH' end as period
         , mon.stpr_created
         , mon.stpr_started
         , mon.stpr_error
         , mon.stpr_completed
         , mon.stpr_terminated
         , mon.stpr_reset
         , numtoDSinterval( mon.duration_10pc_sec, 'SECOND' )
         , numtoDSinterval( mon.duration_50pc_sec, 'SECOND' )
         , numtoDSinterval( mon.duration_90pc_sec, 'SECOND' )
         , numtoDSinterval( mon.duration_max_sec , 'SECOND' )
         , mon.duration_10pc_sec
         , mon.duration_50pc_sec
         , mon.duration_90pc_sec
         , mon.duration_max_sec
    from mon
    where mon.period_start >= trunc(p_start_date,'MM');

  end create_monthly_instance_summaries;

  -- quarter summary

  procedure create_quarterly_instance_summaries  
  ( p_start_date   in date
  )
  is
  begin

    insert into flow_instance_stats
      ( stpr_dgrm_id    
      , stpr_period_start  
      , stpr_period
      , stpr_created    
      , stpr_started    
      , stpr_error      
      , stpr_completed  
      , stpr_terminated 
      , stpr_reset      
      , stpr_duration_10pc_ivl
      , stpr_duration_50pc_ivl
      , stpr_duration_90pc_ivl
      , stpr_duration_max_ivl 
      , stpr_duration_10pc_sec
      , stpr_duration_50pc_sec
      , stpr_duration_90pc_sec
      , stpr_duration_max_sec 
      )
    with mon as 
    (
    select stpr_dgrm_id, 
         trunc(stpr_period_start, 'Q') period_start, 
         sum (stpr_created) stpr_created,
         sum (stpr_started) stpr_started,
         sum (stpr_error) stpr_error,
         sum (stpr_completed) stpr_completed,
         sum (stpr_terminated) stpr_terminated,
         sum (stpr_reset) stpr_reset,
         sum ( ds.stpr_duration_10pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_10pc_sec,
         sum ( ds.stpr_duration_50pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_50pc_sec, 
         sum ( ds.stpr_duration_90pc_sec * ds.stpr_completed ) / sum (ds.stpr_completed) duration_90pc_sec, 
         sum ( ds.stpr_duration_max_sec * ds.stpr_completed  ) / sum (ds.stpr_completed) duration_max_sec
    from   flow_instance_stats ds
    where  ds.stpr_period = 'MONTH'
      and  ds.stpr_period_start >= p_start_date
    group by stpr_dgrm_id, trunc(stpr_period_start, 'Q')
    order by stpr_dgrm_id, trunc(stpr_period_start, 'Q')
    )
    select mon.stpr_dgrm_id
       , mon.period_start
       , 'QUARTER' as period
       , mon.stpr_created
       , mon.stpr_started
       , mon.stpr_error
       , mon.stpr_completed
       , mon.stpr_terminated
       , mon.stpr_reset
       , numtoDSinterval( mon.duration_10pc_sec, 'SECOND' )
       , numtoDSinterval( mon.duration_50pc_sec, 'SECOND' )
       , numtoDSinterval( mon.duration_90pc_sec, 'SECOND' )
       , numtoDSinterval( mon.duration_max_sec , 'SECOND' )
       , mon.duration_10pc_sec
       , mon.duration_50pc_sec
       , mon.duration_90pc_sec
       , mon.duration_max_sec
    from mon
    where mon.period_start between p_start_date and add_months ( trunc( sys_extract_utc (systimestamp), 'Q' ), -3)
    ;

  end create_quarterly_instance_summaries;

/*-- instance stats query - showing quarterly, monthly and daily summaries

-- used to drive process performance history charts on engine app p16
--  current day statistics are based on live data
--  next previous 6 days summaries 
--  current month and previous 3-6 months summary data (depending on where month lies in the quarter)
--  quarterly summary data before that for upto 4 quarters
--  note that label value is in a specific format so that all of the sets sort into the correct calender order

with summary_dates as
(
    select trunc(sysdate) - 7 + level dt, 'DAY' as period, 8-level sort_order
    from dual
    connect by level <= ( sysdate - sysdate +7)
    union
    select add_months( trunc(sysdate,'MM')
                     , - floor (months_between ( trunc ( sysdate)
                                               , trunc ( add_months(sysdate,-6) , 'Q')
                                               ) - 3
                                ) + level-1
                     )
                     ,'MONTH'
                     , 10*(7-level)
    from dual
    connect by level <= ( sysdate - sysdate + floor (months_between ( trunc (sysdate)
                                                                    , trunc (add_months ( sysdate ,-6) , 'Q')
                                                                    ) - 2
                                                    )
                        )
    union 
    select add_months(trunc(sysdate,'Q'), -3 - (3*level)),'QUARTER', 100*level
    from dual
    connect by level <= (sysdate -sysdate +4)
)
select sd.dt, 
       sd.period, 
       case sd.period
          when 'DAY'     then to_char(dt,'YYYY-MM-DD')
          when 'MONTH'   then to_char(dt,'YYYY-MM')
          when 'QUARTER' then to_char(dt,'YYYY-"0"Q')
       end PeriodLabel,
       sd.sort_order,
       ist.stpr_created,
       ist.stpr_started,
       ist.stpr_completed,
       ist.stpr_error,
       ist.stpr_terminated,
       ist.stpr_reset,
       ist.stpr_duration_10pc_sec,
       ist.stpr_duration_50pc_sec,
       ist.stpr_duration_90pc_sec,
       ist.stpr_duration_max_sec
  from summary_dates sd
  left join flow_instance_stats ist
    on sd.dt     = ist.stpr_period_start
   and sd.period = ist.stpr_period
 where ist.stpr_dgrm_id = :P16_DGRM_ID
 order by sd.sort_order desc
union all
   select trunc(sysdate)
        , 'DAY'
        , to_char (sysday,'YYYY-MM-DD')
        , 0
        , sum ( case lgpr_prcs_event when 'created'    then 1 else 0 end) num_created
        , sum ( case lgpr_prcs_event when 'started'    then 1 else 0 end) num_started
        , sum ( case lgpr_prcs_event when 'completed'  then 1 else 0 end) num_completed
        , sum ( case lgpr_prcs_event when 'error    '  then 1 else 0 end) num_error
        , sum ( case lgpr_prcs_event when 'terminated' then 1 else 0 end) num_terminated
        , sum ( case lgpr_prcs_event when 'reset'      then 1 else 0 end) num_reset
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )
               within group (order by (lgpr_duration) ASC)) duration_10pc_sec
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )
               within group (order by (lgpr_duration) ASC)) duration_50pc_sec             
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )
               within group (order by (lgpr_duration) ASC)) duration_90pc_sec             
        , flow_api_pkg.intervaldstosec ( max (lgpr_duration)) duration_max_sec                                  
         from flow_instance_event_log lgpr
        where lgpr.lgpr_prcs_event in ('created','started', 'error', 'completed', 'terminated', 'reset')
        and   trunc (sys_extract_utc(lgpr_timestamp)) = trunc(sysdate)
        and  lgpr_dgrm_id = :P16_DGRM_ID
        group by lgpr_dgrm_id
        order by lgpr_dgrm_id
;

-- step stats query - showing quarterly, monthly and daily summaries

-- used to drive process performance history charts on engine app p17
--  current day statistics are based on live data
--  next previous 6 days summaries 
--  current month and previous 3-6 months summary data (depending on where month lies in the quarter)
--  quarterly summary data before that for upto 4 quarters
--  note that label value is in a specific format so that all of the sets sort into the correct calender order

with summary_dates as
(
    select trunc(sysdate) - 7 + level dt, 'DAY' as period, 8-level sort_order
    from dual
    connect by level <= ( sysdate - sysdate +7)
    union
    select add_months( trunc(sysdate,'MM')
                     , - floor (months_between ( trunc ( sysdate)
                                               , trunc ( add_months(sysdate,-6) , 'Q')
                                               ) - 3
                                ) + level-1
                     )
                     ,'MONTH'
                     , 10*(7-level)
    from dual
    connect by level <= ( sysdate - sysdate + floor (months_between ( trunc (sysdate)
                                                                    , trunc (add_months ( sysdate ,-6) , 'Q')
                                                                    ) - 2
                                                    )
                        )
    union 
    select add_months(trunc(sysdate,'Q'), -3 - (3*level)),'QUARTER', 100*level
    from dual
    connect by level <= (sysdate -sysdate +4)
)
select sd.dt, 
       sd.period, 
       case sd.period
          when 'DAY'     then to_char(dt,'YYYY-MM-DD')
          when 'MONTH'   then to_char(dt,'YYYY-MM')
          when 'QUARTER' then to_char(dt,'YYYY-"0"Q')
       end PeriodLabel,
       sd.sort_order,
       ist.stsf_completed,
       ist.stsf_duration_10pc_sec,
       ist.stsf_duration_50pc_sec,
       ist.stsf_duration_90pc_sec,
       ist.stsf_duration_max_sec,
       ist.stsf_waiting_10pc_sec,
       ist.stsf_waiting_50pc_sec,
       ist.stsf_waiting_90pc_sec,
       ist.stsf_waiting_max_sec
  from summary_dates sd
  left join flow_step_stats ist
    on sd.dt     = ist.stsf_period_start
   and sd.period = ist.stsf_period
 where ist.stsf_dgrm_id = :P17_DGRM_ID
   and ist.stsf_objt_bpmn_id = :P17_OBJT_BPMN_ID
union all
   select trunc(sysdate)
        , 'DAY'
        , to_char (sysdate,'YYYY-MM-DD')
        , 0
        , count(lgsf_prcs_id) num_completed
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )
               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_10pc_sec
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )
               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_50pc_sec             
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )
               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_90pc_sec             
        , flow_api_pkg.intervaldstosec ( max (lgsf_completed - lgsf_was_current)) duration_max_sec                                  
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )
               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_10pc_sec
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )
               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_50pc_sec             
        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )
               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_90pc_sec             
        , flow_api_pkg.intervaldstosec ( max (lgsf_started - lgsf_was_current)) waiting_max_sec           
        from flow_step_event_log lgsf
        where trunc (sys_extract_utc(lgsf_completed)) = trunc(sysdate)
        and  lgsf_sbfl_dgrm_id = :P17_DGRM_ID
        and  lgsf_objt_id = :P17_OBJT_BPMN_ID
        group by lgsf_sbfl_dgrm_id, lgsf_objt_id
*/

       function get_last_successful_summary
       ( p_type  flow_stats_history.sths_type%type)
       return date
       is
         l_last_successful_summary  date;
       begin
         select nvl( trunc( max( sths.sths_date)), to_date('01-JAN-2020','DD-MON-YYYY'))
             -- deemed start of Flows for APEX epoch!
           into l_last_successful_summary
           from flow_stats_history sths
          where sths.sths_type = p_type
            and sths.sths_status = flow_constants_pkg.gc_stats_outcome_success
         ;
         return l_last_successful_summary;
       exception
         when no_data_found then
           return to_date('01-JAN-2020','DD-MON-YYYY'); -- deemed start of Flows for APEX epoch!
       end get_last_successful_summary;



       procedure create_daily_summaries
       ( p_start_date    in  date
       )
       is
       begin
         -- creates daily Summaries for all days between last successful run up to yesterday
         -- create daily instance summary
         create_daily_instance_summary (p_start_date => p_start_date);
         -- create daily step summary
         create_daily_step_summary (p_start_date => p_start_date);
       end create_daily_summaries;

       procedure create_monthly_summaries
       ( p_start_date   in date)
       is
       begin
         -- creates monthly Summaries for all months between last successful run up to yesterday
         -- create monthly instance summary
         create_monthly_instance_summaries (p_start_date => p_start_date);
         -- create monthly step summary
         create_monthly_step_summaries (p_start_date => p_start_date);         --
       end create_monthly_summaries;

       procedure create_quarterly_summaries
       is
         l_last_summary_date  date;
         l_start_date         date;
         l_final_quarter      date;  -- final quarter start date included in this new summary
       begin
         -- get last successful quarterly summmary date
         l_last_summary_date := get_last_successful_summary (p_type => flow_constants_pkg.gc_stats_period_quarter);
         l_start_date := add_months (l_last_summary_date, 3);
         -- create quarterly instance summary
         create_quarterly_instance_summaries (p_start_date => l_start_date);
         -- create quarterly step summary
         create_quarterly_step_summaries (p_start_date => l_start_date);     
         -- set last quarterly summary in hstory
         l_final_quarter := add_months( trunc(sysdate,'Q') , -3);

         insert into flow_stats_history
         ( sths_date 
         , sths_status
         , sths_type
         , sths_errors
         , sths_created_on
         )
         values 
         ( l_final_quarter
         , flow_constants_pkg.gc_stats_outcome_success
         , flow_constants_pkg.gc_stats_period_quarter
         , null
         , systimestamp
         )
         ;

       end create_quarterly_summaries;       

       procedure run_daily_stats
       is
         l_last_successful_daily     date;
       begin
         -- get last successfully completed day
         l_last_successful_daily := get_last_successful_summary 
                                          (p_type => flow_constants_pkg.gc_stats_period_day);
         -- make daily summaries from last successfully completed day to yesterday night
         create_daily_summaries (p_start_date => l_last_successful_daily +1 );
         -- run monthly and MTD summary
         create_monthly_summaries (p_start_date => l_last_successful_daily +1 );
         -- run quartlies if required
         if trunc(l_last_successful_daily,'Q') != trunc(sysdate,'Q') then
              create_quarterly_summaries ;
         end if;
         -- if successful update Stats history
         insert into flow_stats_history
         ( sths_date 
         , sths_status
         , sths_type
         , sths_errors
         , sths_created_on
         )
         values 
         ( trunc(sys_extract_utc(systimestamp))-1
         , flow_constants_pkg.gc_stats_outcome_success
         , flow_constants_pkg.gc_stats_period_day
         , null
         , systimestamp
         );
         -- end
       end run_daily_stats;

  procedure purge_statistics
  is
    l_daily_summary_purge_date      date;
    l_monthly_summary_purge_date    date;
    l_quarterly_summary_purge_date  date;
  begin
    apex_debug.enter(p_routine_name  => 'purge_statistics');

    l_daily_summary_purge_date      := sysdate - flow_engine_util.get_config_value
                                      ( p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_daily 
                                      , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_daily   
                                      );
    l_monthly_summary_purge_date    := add_months ( sysdate, -1 * flow_engine_util.get_config_value
                                                      ( p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_month 
                                                      , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_month  
                                                      )
                                                  );                                      
    l_quarterly_summary_purge_date  := add_months ( sysdate, -1 * flow_engine_util.get_config_value
                                                      ( p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_qtr 
                                                      , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_qtr  
                                                      )
                                                  );

    apex_debug.message
    ( p_message => 'Statistics purge starting for daily before %0, monthly before %1 and quarterly before %2'
    , p0 => to_char(l_daily_summary_purge_date)
    , p1 => to_char(l_monthly_summary_purge_date)
    , p2 => to_char(l_quarterly_summary_purge_date)
    );
    --
    begin
      -- dailies
      delete from flow_instance_stats
      where stpr_period = flow_constants_pkg.gc_stats_period_day
      and stpr_period_start < l_daily_summary_purge_date;

      delete from flow_step_stats
      where stsf_period = flow_constants_pkg.gc_stats_period_day
      and stsf_period_start < l_daily_summary_purge_date;

      -- monthlies
      delete from flow_instance_stats
      where stpr_period = flow_constants_pkg.gc_stats_period_month
      and stpr_period_start < l_monthly_summary_purge_date;

      delete from flow_step_stats
      where stsf_period = flow_constants_pkg.gc_stats_period_month
      and stsf_period_start < l_monthly_summary_purge_date;

      -- quarterlies
      delete from flow_instance_stats
      where stpr_period = flow_constants_pkg.gc_stats_period_quarter
      and stpr_period_start < l_quarterly_summary_purge_date;

      delete from flow_step_stats
      where stsf_period = flow_constants_pkg.gc_stats_period_quarter
      and stsf_period_start < l_quarterly_summary_purge_date;
      --
      insert into flow_stats_history
        ( sths_date
        , sths_status
        , sths_type
        , sths_comments
        , sths_created_on
        )
      values
        ( sysdate
        , flow_constants_pkg.gc_stats_outcome_success
        , flow_constants_pkg.gc_stats_period_day
        , 'purge completed'
        , systimestamp
        );        
    end;
    exception
      when others then
        insert into flow_stats_history
        ( sths_date
        , sths_status
        , sths_type
        , sths_comments
        , sths_errors
        , sths_created_on
        )
        values
        ( sysdate
        , flow_constants_pkg.gc_stats_outcome_error
        , flow_constants_pkg.gc_stats_period_day
        , 'error on purge'
        , dbms_utility.format_error_stack
        , systimestamp
        ); 
        raise;  
  end purge_statistics;


end flow_statistics;
/

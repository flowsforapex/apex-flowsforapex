create or replace package body flow_engine
as 

function get_dgrm_id
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_dgrm_id%type
  as
    l_prcs_dgrm_id flow_processes.prcs_dgrm_id%type;
  begin
    
    select prcs.prcs_dgrm_id
      into l_prcs_dgrm_id
      from flow_processes prcs
     where prcs.prcs_id = p_prcs_id
    ;
    
    return l_prcs_dgrm_id;
    
end get_dgrm_id;

procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type
  )
  is 
  begin
    insert into flow_subflow_log sflg
    ( sflg_prcs_id
    , sflg_objt_id
    , sflg_sbfl_id
    , sflg_last_updated
    , sflg_notes
    )
    values 
    ( p_process_id
    , p_completed_object
    , p_subflow_id
    , sysdate
    , p_notes
    );
  exception
    when others then
      apex_error.add_error
      ( p_message => 'Flows - Internal error logging step completion'
      , p_display_location => apex_error.c_on_error_page
      );
      raise;
  end log_step_completion;

function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_bpmn_id%type -- an object in the subprocess
  ) return number
  is
    l_parent_subflow          flow_subflows.sbfl_id%type;
    l_parent_subproc_activity flow_objects.objt_bpmn_id%type;
    l_dgrm_id                 flow_diagrams.dgrm_id%type;
  begin

    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );  

    -- get parent bpmn:subProcess object
    select par_objt.objt_bpmn_id
      into l_parent_subproc_activity
      from flow_objects objt
      join flow_objects par_objt
        on par_objt.objt_id = objt.objt_objt_id
     where objt.objt_bpmn_id = p_current
       and objt.objt_dgrm_id = l_dgrm_id
    ;
    -- try to get parent subflow
    begin
      select sbfl.sbfl_id
        into l_parent_subflow
        from flow_subflows sbfl
       where sbfl.sbfl_current = l_parent_subproc_activity
         and sbfl.sbfl_status = 'in subprocess'
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    exception
      when no_data_found then
        -- no subflow found running the parent process 
        l_parent_subflow := null;
    end;
    return l_parent_subflow;
end get_subprocess_parent_subflow;

procedure get_number_of_connections
    ( pi_dgrm_id in flow_diagrams.dgrm_id%type
    , pi_target_objt_id flow_connections.conn_tgt_objt_id%type
    , po_num_forward_connections out number
    , po_num_back_connections out number
    )
is 
begin   
    select count(*)
      into po_num_back_connections
      from flow_connections conn 
     where conn.conn_tgt_objt_id = pi_target_objt_id
       and conn.conn_tag_name = 'bpmn:sequenceFlow'
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
    select count(*)
      into po_num_forward_connections
      from flow_connections conn 
     where conn.conn_src_objt_id = pi_target_objt_id
       and conn.conn_tag_name = 'bpmn:sequenceFlow'
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
end get_number_of_connections;

function get_exclusiveGateway_route
    ( pi_process_id     in flow_processes.prcs_id%type
    , pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
    ) return flow_connections.conn_bpmn_id%type
is
    l_forward_route     flow_connections.conn_bpmn_id%type;
begin
   -- check if route is in process variable
   l_forward_route := flow_process_vars.get_var_vc2(pi_process_id, 'Route:'||pi_objt_bpmn_id);
/*   if l_forward_route is null
   then
      -- check default route  -- fix FFA41
      -- haven't parsed default route yet so just error
      apex_error.add_error
          ( p_message => 'No default route supplied on exclusiveGateway '||pi_objt_bpmn_id
          , p_display_location => apex_error.c_on_error_page
          );
    end if; */
    return l_forward_route;
end get_exclusiveGateway_route;

function subflow_start
  ( 
    p_process_id      in flow_processes.prcs_id%type
  , p_parent_subflow  in flow_subflows.sbfl_id%type
  , p_starting_object in flow_objects.objt_bpmn_id%type
  , p_current_object  in flow_objects.objt_bpmn_id%type
  , p_route           in flow_subflows.sbfl_route%type
  , p_last_completed  in flow_objects.objt_bpmn_id%type
  , p_status       in flow_subflows.sbfl_status%type default 'running'
  ) return flow_subflows.sbfl_id%type
  is 
    l_ret flow_subflows.sbfl_id%type;
  begin
    apex_debug.message(p_message => 'Begin subflow_start', p_level => 3) ;
    insert
      into flow_subflows
         ( sbfl_prcs_id
         , sbfl_sbfl_id
         , sbfl_starting_object
         , sbfl_route
         , sbfl_last_completed
         , sbfl_current
         , sbfl_status
         , sbfl_last_update
         )
    values
         ( p_process_id
         , p_parent_subflow
         , p_starting_object
         , p_route
         , p_last_completed
         , p_current_object
         , p_status
         , systimestamp
         )
      returning sbfl_id into l_ret
    ;
    apex_debug.message(p_message => 'Subflow '||l_ret||' started', p_level => 3) ;
    return l_ret;
end subflow_start;

procedure subflow_complete
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  )
  is
    l_remaining_subflows number;
    l_remaining_siblings number;
    l_current_object flow_subflows.sbfl_current%type;
    l_current_subflow_status flow_subflows.sbfl_status%type;
    l_parent_subflow_id flow_subflows.sbfl_sbfl_id%type;
    l_parent_subflow_status flow_subflows.sbfl_status%type;
    l_parent_subflow_last_completed flow_subflows.sbfl_last_completed%type;
    l_parent_subflow_current flow_subflows.sbfl_current%type;
  begin
    apex_debug.message(p_message => 'Begin subflow_complete', p_level => 3) ;
    
    select sbfl.sbfl_sbfl_id
         , sbfl.sbfl_current
         , sbfl.sbfl_status
      into l_parent_subflow_id
         , l_current_object
         , l_current_subflow_status
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ; 
    
    if l_parent_subflow_id is not null then   
      -- get parent subflow info
      select sbfl.sbfl_status
           , sbfl.sbfl_last_completed
           , sbfl.sbfl_current
        into l_parent_subflow_status
           , l_parent_subflow_last_completed
           , l_parent_subflow_current
        from flow_subflows sbfl
       where sbfl.sbfl_id = l_parent_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
    end if;

    -- delete the completed subflow and log it as complete
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
       ;  
      -- log current step as completed
    log_step_completion
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_completed_object => l_current_object
    , p_notes => ''
    );
    -- if subflow has parent with   
    -- a)  status 'split' 
    -- b)  no other children, AND
    -- c)  is not a merging gateway
    -- then we have an ophan parent process to clean up (all opening gateway paths have run to conclusion)
    if l_parent_subflow_id is not null then   
        
      select count(*)
        into l_remaining_siblings
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = l_parent_subflow_last_completed
      ;
      
      if (   l_remaining_siblings = 0
         and l_parent_subflow_status = 'split'  
         and l_current_subflow_status != 'waiting at gateway'
         )
      then
        
        delete
          from flow_subflows sbfl
         where sbfl.sbfl_prcs_id = p_process_id
          and sbfl.sbfl_id = l_parent_subflow_id
        ;       
      end if;  
    end if;

    -- check if there are ANY remaining subflows.  If not, close process
    select count(*)
      into l_remaining_subflows
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
    if l_remaining_subflows = 0 then 
      -- No remaining subflows so process has completed
      update flow_processes prcs 
         set prcs.prcs_status = 'completed'
           , prcs.prcs_last_update = sysdate
           , prcs.prcs_main_subflow = null
       where prcs.prcs_id = p_process_id
      ;
      apex_debug.message(p_message => 'Process Completed: Process '||p_process_id, p_level => 4) ;
    end if;
end subflow_complete;

procedure flow_start_process
( p_process_id    in flow_processes.prcs_id%type
)
is
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_objt_bpmn_id    flow_objects.objt_bpmn_id%type;
    l_objt_sub_tag_name flow_objects.objt_sub_tag_name%type;
    l_main_subflow_id flow_subflows.sbfl_id%type;
    l_new_subflow_status flow_subflows.sbfl_status%type;
begin
    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
    begin
        -- called from flow_api_pkg.flow_start (only)
        -- get the object to start with
        select objt.objt_bpmn_id
             , objt.objt_sub_tag_name
          into l_objt_bpmn_id
             , l_objt_sub_tag_name
          from flow_objects objt
          join flow_objects parent
            on objt.objt_objt_id = parent.objt_id
         where objt.objt_dgrm_id = l_dgrm_id
           and parent.objt_dgrm_id = l_dgrm_id
           and objt.objt_tag_name = 'bpmn:startEvent'
           and parent.objt_tag_name = 'bpmn:process'
        ;
    exception
        when too_many_rows then
            apex_error.add_error
            ( p_message => 'You have multiple starting events defined. Make sure your diagram has only one starting event.'
            , p_display_location => apex_error.c_on_error_page
            );
        when no_data_found then
            apex_error.add_error
            ( p_message => 'No starting event was defined.'
            , p_display_location => apex_error.c_on_error_page
            );
    end;
    -- check if start has a timer?  
    if l_objt_sub_tag_name = 'bpmn:timerEventDefinition'
    then 
        l_new_subflow_status := 'waiting for timer';
    else
        l_new_subflow_status := 'running';
    end if;

    l_main_subflow_id := flow_engine.subflow_start 
      ( p_process_id => p_process_id
      , p_parent_subflow => null
      , p_starting_object => l_objt_bpmn_id
      , p_current_object => l_objt_bpmn_id
      , p_route => 'main'
      , p_last_completed => null
      , p_status => l_new_subflow_status 
      );

    if l_objt_sub_tag_name = 'bpmn:timerEventDefinition'
    then 
      -- eventStart must be delayed with the timer 
      flow_timers_pkg.start_timer(
          p_process_id => p_process_id
        , p_subflow_id => l_main_subflow_id
      );
    elsif l_objt_sub_tag_name is null
    then
      -- plain startEvent, step into first step
      flow_next_step  
      ( p_process_id => p_process_id
      , p_subflow_id => l_main_subflow_id
      , p_forward_route => null
      );
    else 
        apex_error.add_error
        ( p_message => 'You have an unsupported starting event type. Only (standard) Start Event and Timer Start Event are currently supported.'
        , p_display_location => apex_error.c_on_error_page
        );
    end if;
    -- update process status
    update flow_processes prcs
       set prcs.prcs_status = 'running'
         , prcs.prcs_last_update = sysdate
         , prcs.prcs_main_subflow = l_main_subflow_id
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;
end flow_start_process;

procedure flow_terminate
    ( p_process_id  in  flow_processes.prcs_id%type)
is
    l_return_code number;
begin
    apex_debug.message(p_message => 'Begin flow_terminate', p_level => 3) ;
    flow_timers_pkg.terminate_process_timers
      ( p_process_id => p_process_id
      , p_return_code => l_return_code
      );
    delete  from flow_subflows sbfl 
    where sbfl.sbfl_prcs_id = p_process_id
    ;
end flow_terminate;

procedure flow_run_sync_plsql
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_current       in flow_subflows.sbfl_current%type
)
is  
  l_scrp_rec flow_scripts%rowtype;
  l_prcs_rec flow_processes%rowtype;
  l_args_list varchar2(2000);
  l_arg1 varchar2(200);
  l_arg2 varchar2(200);
  l_arg3 varchar2(200);
  l_proc varchar2(200);
  l_call varchar2(2000);
begin
  apex_debug.message(p_message => 'Begin flow_run_sync_plsql', p_level => 3) ;
  select *
    into l_scrp_rec
    from flow_scripts scrp
   where scrp.scrp_objt_bpmn_id = p_current
    ;
  select * 
    into l_prcs_rec
    from flow_processes proc 
   where proc.prcs_id = p_process_id
   ;
  -- build procedure call
  begin
    l_args_list := '(pi_process_id => '||p_process_id||','||'pi_subflow_id =>'||p_subflow_id;
    apex_debug.message(p_message => 'args_list_phase1'|| l_args_list, p_level => 4) ;

        select ','||listagg( scrv_parameter_name || ' => ' ||
            case scrv_value_type 
            when 'literal' then ''''||scrv_value ||''''
            when 'process_var_vc2' then flow_process_vars.get_var_vc2(pi_prcs_id => p_process_id, pi_var_name => scrv_value)
            when 'process_var_num' then to_char(flow_process_vars.get_var_num(pi_prcs_id => p_process_id, pi_var_name => scrv_value))
            when 'process_var_date' then ''''||to_char(flow_process_vars.get_var_date(pi_prcs_id => p_process_id, pi_var_name => scrv_value))||''''
            when 'PK' then to_char(l_prcs_rec.prcs_ref_obj_id)
            end   ,',')
        into l_arg1
        from flow_script_parameters scrv
        where scrv_scrp_id = l_scrp_rec.scrp_id;

    l_args_list := l_args_list || l_arg1 ||'); ';
        apex_debug.message(p_message => 'args_list_phase2'|| l_args_list, p_level => 4) ;
    if l_scrp_rec.scrp_package is not null
    then 
        l_proc := l_scrp_rec.scrp_package||'.'||l_scrp_rec.scrp_procedure;
    else 
        l_proc := l_scrp_rec.scrp_procedure;
    end if;
    l_call := 'begin '||l_proc||l_args_list||' end;';
  exception
    when others then
            apex_error.add_error
            ( p_message => 'Error building PL/SQL script arguments.'
            , p_display_location => apex_error.c_on_error_page
            );
  end;
  begin
    apex_debug.message(p_message => 'Assembled procedure call in flow_run_sync_plsql : '|| l_call, p_level => 3) ;
    execute immediate l_call;
  exception
    when others then
        apex_error.add_error
            ( p_message => 'Error running application  PL/SQL script; '||l_proc||' .'
            , p_display_location => apex_error.c_on_error_page
            );
  end;
  begin
    flow_next_step (p_process_id => p_process_id, p_subflow_id => p_subflow_id);
  end;

end flow_run_sync_plsql;

/*
============================================================================================
  B P M N   O B J E C T   P R O C E S S O R S 
============================================================================================
*/

procedure process_task
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
begin
   apex_debug.message(p_message => 'Begin process_task for object: '||p_step_info.target_objt_tag, p_level => 3) ;
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'running'
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
        ;
end process_task;


procedure process_endEvent
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
  l_sbfl_id_par          flow_subflows.sbfl_id%type;  

begin
    --next step can be either end of process or sub-process returning to it's parent

    -- see if there is a parent process running
    l_sbfl_id_par := get_subprocess_parent_subflow
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_current    => p_sbfl_info.sbfl_current
            );
    -- log the current endEvent as completed
    log_step_completion
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            , p_completed_object => p_step_info.target_objt_ref
            , p_notes => ''
            );
    subflow_complete
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );
    if l_sbfl_id_par is null 
    then   
        apex_debug.message(p_message => 'Next Step is Process End '||p_step_info.target_objt_ref, p_level => 4) ;
        -- check for Terminate sub-Event
        if p_step_info.target_objt_subtag = 'bpmn:terminateEventDefinition'
        then
            flow_terminate (p_process_id => p_process_id);
        end if;
    else  
        apex_debug.message(p_message => 'Next Step was Sub-Process End '||p_step_info.target_objt_ref||
                    ' Resuming Parent Subflow : '||l_sbfl_id_par, p_level => 4) ; 
    
        -- return parent flow to running and do next step
        flow_next_step 
            ( p_process_id => p_process_id
            , p_subflow_id => l_sbfl_id_par
            , p_forward_route => null
            );   
    end if 
    ;
end process_endEvent;

procedure process_parallelGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
    l_gateway_forward_status    varchar2(10);
    l_sbfl_id                   flow_subflows.sbfl_id%type;
    l_sbfl_id_sub               flow_subflows.sbfl_id%type;
    l_sbfl_id_par               flow_subflows.sbfl_id%type; 
    l_num_back_connections      number;   -- number of connections leading into object
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_unfinished_subflows   number;
begin
         apex_debug.message(p_message => 'Next Step is parallelGateway '||p_step_info.target_objt_ref, p_level => 4) ;
        -- test if this is splitting or merging (or both) gateway
        get_number_of_connections
        ( pi_dgrm_id => p_step_info.dgrm_id
        , pi_target_objt_id => p_step_info.target_objt_id
        , po_num_back_connections => l_num_back_connections
        , po_num_forward_connections => l_num_forward_connections
        );
        l_gateway_forward_status := 'proceed';
        l_sbfl_id  := p_subflow_id;

        if l_num_back_connections >= 2 then
          apex_debug.message(p_message => 'Merging Parallel Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       
          -- we have merging gateway
          l_gateway_forward_status := 'wait';
          -- set current subflow to status waiting,       
          update flow_subflows sbfl
            set sbfl.sbfl_status = 'waiting at gateway'
              , sbfl.sbfl_last_update = sysdate 
              , sbfl.sbfl_current = p_step_info.target_objt_ref
          where sbfl.sbfl_id = p_subflow_id
            and sbfl.sbfl_prcs_id = p_process_id
          ;
          -- check if we are waiting for other flows or can proceed
          select count(*)
            into l_num_unfinished_subflows
            from flow_subflows sbfl
           where sbfl.sbfl_prcs_id = p_process_id
             and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
             and ( sbfl.sbfl_current != p_step_info.target_objt_ref
                 or sbfl.sbfl_status != 'waiting at gateway' )
               ;
          if l_num_unfinished_subflows = 0 then
            -- all merging tasks completed.  proceed from gateway
            for completed_subflows in (
               select sbfl.sbfl_id
                 from flow_subflows sbfl 
                where sbfl.sbfl_prcs_id = p_process_id
                  and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                  and sbfl.sbfl_current = p_step_info.target_objt_ref 
                  and sbfl.sbfl_status = 'waiting at gateway'
            )
            loop
              subflow_complete
              ( p_process_id => p_process_id
              , p_subflow_id => completed_subflows.sbfl_id
              );
            end loop;
            l_gateway_forward_status := 'proceed';
  
            --log gateway object as complete
  
            -- switch to parent subflow
            l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
            --restart parent split subflow
            update flow_subflows sbfl
               set sbfl.sbfl_status = 'proceed from gateway'
                 , sbfl.sbfl_current = p_step_info.target_objt_ref
                 , sbfl.sbfl_last_update = sysdate
             where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
               and sbfl.sbfl_status = 'split'
               and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
            ;
          end if;
        end if;
        -- now do forward path, if you have token to 'proceed'
        if l_gateway_forward_status = 'proceed' then 
          if l_num_forward_connections > 1
          then
            -- we have splitting gateway going forward
            begin
            -- get all forward parallel paths and create subflows for them
            -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
            for new_path in (
                select conn.conn_bpmn_id route
                     , objt.objt_bpmn_id target
                  from flow_connections conn
                  join flow_objects objt
                    on objt.objt_id = conn.conn_tgt_objt_id
                 where conn.conn_dgrm_id = p_step_info.dgrm_id
                   and conn.conn_tag_name = 'bpmn:sequenceFlow'
                   and conn.conn_src_objt_id = p_step_info.target_objt_id
            )
            loop
                  l_sbfl_id_sub := subflow_start
                      ( p_process_id =>  p_process_id         
                      , p_parent_subflow =>  l_sbfl_id        
                      , p_starting_object =>  p_step_info.target_objt_ref         
                      , p_current_object => p_step_info.target_objt_ref          
                      , p_route =>  new_path.route         
                      , p_last_completed =>  p_step_info.target_objt_ref        
                      );
                  -- step into first step on the new path
                  flow_next_step    
                      (p_process_id => p_process_id
                      ,p_subflow_id => l_sbfl_id_sub
                      ,p_forward_route => new_path.route
                      );
            end loop;
              -- set current subflow to status split, current = null       
              update flow_subflows sbfl
                set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
                  , sbfl.sbfl_current = ''
                  , sbfl.sbfl_status = 'split'
                  , sbfl.sbfl_last_update = sysdate 
              where sbfl.sbfl_id = l_sbfl_id
                and sbfl.sbfl_prcs_id = p_process_id
                  ;
            exception
              when no_data_found then
                apex_error.add_error
                ( p_message => 'No forward paths found for opening Parallel Gateway'
                , p_display_location => apex_error.c_on_error_page
                );
              when too_many_rows then  -- is this necessary?
                apex_error.add_error
                ( p_message => 'Too many forward paths found  opening Parallel Gateway'
                , p_display_location => apex_error.c_on_error_page
                );
            end;
          elsif l_num_forward_connections = 1 then
            -- only single path going forward
            update  flow_subflows sbfl
                set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
                  , sbfl.sbfl_current = p_step_info.target_objt_ref
                  , sbfl.sbfl_status = 'running'
                  , sbfl.sbfl_last_update = sysdate 
              where sbfl.sbfl_id = l_sbfl_id
                and sbfl.sbfl_prcs_id = p_process_id
            ;
            -- step into first step on the new path
            flow_next_step   
            ( p_process_id => p_process_id
            , p_subflow_id => l_sbfl_id
            , p_forward_route => null
            );
          end if;  -- single path
        end if;  -- forward token
end process_parallelGateway;

procedure process_inclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
    l_sbfl_id                   flow_subflows.sbfl_id%type;
    l_sbfl_id_sub               flow_subflows.sbfl_id%type;
    l_sbfl_id_par               flow_subflows.sbfl_id%type; 
    l_num_back_connections      number;   -- number of connections leading into object
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_unfinished_subflows   number;
    l_forward_routes             varchar2(2000);
    l_new_subflow         flow_subflows.sbfl_id%type;
begin
        -- handles opening and closing but not closing and reopening  --FFA41
        apex_debug.message(p_message => 'Next Step is inclusiveGateway '||p_step_info.target_objt_ref, p_level => 4) ;
        -- test if this is splitting or merging (or both) gateway
        get_number_of_connections
        ( pi_dgrm_id => p_step_info.dgrm_id
        , pi_target_objt_id => p_step_info.target_objt_id
        , po_num_back_connections => l_num_back_connections
        , po_num_forward_connections => l_num_forward_connections
        );
        if l_num_back_connections = 1
        then
            -- this is opening inclusiveGateway.  Step into it.  Forward paths will get opened by flow_next_step
            -- after user decision.
            l_forward_routes := flow_process_vars.get_var_vc2(p_process_id, 'Route:'||p_step_info.target_objt_ref);
            apex_debug.message(p_message => 'Forward routes for inclusiveGateway '||p_step_info.target_objt_ref ||' :'||l_forward_routes, p_level => 4) ;
            begin
                for new_path in (
                    select conn.conn_bpmn_id                route
                         , ultimate_tgt_objt.objt_bpmn_id   target
                      from flow_connections conn
                      join flow_objects ultimate_tgt_objt
                        on ultimate_tgt_objt.objt_id = conn.conn_tgt_objt_id
                     where conn.conn_dgrm_id = p_step_info.dgrm_id
                       and conn.conn_src_objt_id = p_step_info.target_objt_id
                       and conn.conn_bpmn_id in (select * from table(apex_string.split(':'||l_forward_routes||':',':')))
                )
                loop
                    -- path is included in list of chosen forward paths.
                    apex_debug.message(p_message => 'starting parallel flow for inclusiveGateway', p_level => 3) ;
                    l_new_subflow := flow_engine.subflow_start
                        ( p_process_id =>  p_process_id         
                        , p_parent_subflow =>  p_subflow_id        
                        , p_starting_object =>  p_step_info.target_objt_ref        
                        , p_current_object => p_step_info.target_objt_ref          
                        , p_route =>  new_path.route         
                        , p_last_completed =>  p_step_info.target_objt_ref        
                        );
                    -- step into first step on the new path
                    flow_next_step 
                        (p_process_id => p_process_id
                        ,p_subflow_id => l_new_subflow
                        ,p_forward_route => new_path.route
                        );
                end loop;
                -- set current subflow to status split, current = null       
                update flow_subflows sbfl
                set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
                    , sbfl.sbfl_current = ''
                    , sbfl.sbfl_status = 'split'
                    , sbfl.sbfl_last_update = sysdate 
                where sbfl.sbfl_id = p_subflow_id
                and sbfl.sbfl_prcs_id = p_process_id
                    ;
            exception
                when no_data_found then
                apex_error.add_error
                ( p_message => 'No forward paths found for opening Inclusive Gateway'
                , p_display_location => apex_error.c_on_error_page
                );
            end;
        elsif (l_num_back_connections > 1 AND l_num_forward_connections >1)
        then
            -- diagram has closing and re-opening inclusiveGateway which is not supported
            apex_error.add_error
                ( p_message => 'Inclusive Gateway with multiple inputs and multiple outputs not supported.  Re-draw as two gateways.'
                , p_display_location => apex_error.c_on_error_page
                );
        elsif (l_num_forward_connections = 1 AND l_num_back_connections >1)
        then
            -- merging gateway.  
            -- note actual number of subflows chosen could be 1 or more and need not be all of defined routes 
            -- forward paths from the diagram may have been started.  So always work on running subflows
            -- not connections from the diagram.
            apex_debug.message(p_message => 'Merging Inclusive Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       

            -- set current subflow to status waiting,       
            update flow_subflows sbfl
              set sbfl.sbfl_status = 'waiting at gateway'
                , sbfl.sbfl_last_update = sysdate 
                , sbfl.sbfl_current = p_step_info.target_objt_ref
            where sbfl.sbfl_id = p_subflow_id
              and sbfl.sbfl_prcs_id = p_process_id
            ;
            -- check if we are waiting for other flows or can proceed
            select count(*)
              into l_num_unfinished_subflows
              from flow_subflows sbfl
            where sbfl.sbfl_prcs_id = p_process_id
              and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
              and ( sbfl.sbfl_current != p_step_info.target_objt_ref
                  or sbfl.sbfl_status != 'waiting at gateway' )
                ;
            if l_num_unfinished_subflows = 0 then
                -- all merging tasks completed.  proceed from gateway
                for completed_subflows in (
                  select sbfl.sbfl_id
                    from flow_subflows sbfl 
                    where sbfl.sbfl_prcs_id = p_process_id
                      and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                      and sbfl.sbfl_current = p_step_info.target_objt_ref 
                      and sbfl.sbfl_status = 'waiting at gateway'
                )
                loop
                  subflow_complete
                  ( p_process_id => p_process_id
                  , p_subflow_id => completed_subflows.sbfl_id
                  );
                end loop;     
                --log gateway object as complete
      
                -- switch to parent subflow
                l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
                --restart parent split subflow
                update flow_subflows sbfl
                  set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
                    , sbfl.sbfl_current = p_step_info.target_objt_ref
                    , sbfl.sbfl_status = 'running'
                    , sbfl.sbfl_last_update = sysdate
                where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
                  and sbfl.sbfl_status = 'split'
                  and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
                ;
                -- step into first step on the new path
                flow_next_step     
                ( p_process_id => p_process_id
                , p_subflow_id => l_sbfl_id
                , p_forward_route => null
                );
            end if;    -- merging finished      
        end if;  -- operation type
end process_inclusiveGateway;

procedure process_exclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_back_connections      number;   -- number of connections back from object
    l_forward_route             flow_connections.conn_bpmn_id%type;
begin
    -- handles opening and closing and closing and reopening
    apex_debug.message(p_message => 'Begin process_exclusiveGateway for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );
    if l_num_forward_connections > 1
    then -- opening gateway - get choice
        l_forward_route := get_exclusiveGateway_route(p_process_id, p_step_info.target_objt_ref);
    else -- closing gateway - keep going
        l_forward_route := null;
    end if;  

    update flow_subflows sbfl
        set sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'running'
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;  
    flow_next_step   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_forward_route => l_forward_route
    );

end process_exclusiveGateway;

procedure process_subProcess
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is
   l_target_objt_sub        flow_objects.objt_bpmn_id%type; --target object in subprocess
   l_sbfl_id_sub            flow_subflows.sbfl_id%type;   
begin
     apex_debug.message(p_message => 'Begin process_subprocess for object: '||p_step_info.target_objt_tag, p_level => 3) ;
     begin
        select objt.objt_bpmn_id
          into l_target_objt_sub
          from flow_objects objt
         where objt.objt_objt_id  = p_step_info.target_objt_id
           and objt.objt_tag_name = 'bpmn:startEvent'
           and objt.objt_dgrm_id  = p_step_info.dgrm_id
        ;
     exception
          when NO_DATA_FOUND  
          then
              apex_error.add_error
              ( p_message => 'Unable to find Sub-Process Start Event.'
              , p_display_location => apex_error.c_on_error_page
              );
          when TOO_MANY_ROWS
          then
              apex_error.add_error
              ( p_message => 'More than one Sub-Process Start found..'
              , p_display_location => apex_error.c_on_error_page
              );
      end;
      -- start subflow for the sub-process
      l_sbfl_id_sub :=  subflow_start
              ( p_process_id => p_process_id
              , p_parent_subflow => p_subflow_id
              , p_starting_object => p_step_info.target_objt_ref -- parent subProc activity
              , p_current_object => l_target_objt_sub -- subProc startEvent
              , p_route => 'sub main'
              , p_last_completed => p_sbfl_info.sbfl_last_completed -- previous activity on parent proc
              );
      -- step into sub_process
      flow_next_step   
            (p_process_id => p_process_id
            ,p_subflow_id => l_sbfl_id_sub
            ,p_forward_route => null
            );
      -- update parent subflow
      update flow_subflows sbfl
      set   sbfl.sbfl_current = p_step_info.target_objt_ref -- parent subProc Activity
          , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
          , sbfl.sbfl_last_update = sysdate
          , sbfl.sbfl_status = 'in subprocess'
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
      ;  
 end process_subProcess; 
  
procedure process_eventBasedGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
  l_sbfl_id_sub          flow_subflows.sbfl_id%type;
begin
    -- eventGateway can have multiple inputs and outputs, but there is no waiting, etc.
    -- incoming subflow continues on the first output path.
    -- additional output paths create new subflows
    apex_debug.message(p_message => 'Begin process_EventBasedGateway for object'
                         ||p_step_info.target_objt_ref, p_level => 4) ;
    begin
        -- get all forward parallel paths and create subflows for them
        -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
        for new_path in (
            select conn.conn_bpmn_id route
                    , objt.objt_bpmn_id target
                from flow_connections conn
                join flow_objects objt
                on objt.objt_id = conn.conn_tgt_objt_id
                where conn.conn_dgrm_id = p_step_info.dgrm_id
                and conn.conn_tag_name = 'bpmn:sequenceFlow'
                and conn.conn_src_objt_id = p_step_info.target_objt_id
        )
        loop
            -- create new subflows for forward event paths starting here
            l_sbfl_id_sub := subflow_start
                ( p_process_id =>  p_process_id         
                , p_parent_subflow =>  p_subflow_id       
                , p_starting_object =>  p_step_info.target_objt_ref         
                , p_current_object => p_step_info.target_objt_ref          
                , p_route =>  new_path.route         
                , p_last_completed =>  p_step_info.target_objt_ref 
                , p_status => 'waiting for event'       
                );
            -- step into first step on the new path
            flow_next_step   
                    (p_process_id => p_process_id
                    ,p_subflow_id => l_sbfl_id_sub
                    ,p_forward_route => new_path.route
                    );
        end loop;
        -- set current subflow to status split, current = eBG       
        update flow_subflows sbfl
            set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
            , sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_status = 'split'
            , sbfl.sbfl_last_update = sysdate 
        where sbfl.sbfl_id = p_subflow_id
            and sbfl.sbfl_prcs_id = p_process_id
            ;
    exception
            when no_data_found then
            apex_error.add_error
            ( p_message => 'No forward paths found for event Gateway'
            , p_display_location => apex_error.c_on_error_page
            );
    end;
end process_eventBasedGateway;

procedure process_intermediateCatchEvent
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
begin
    -- then we make everything behave like a simple activity unless specifically supported
    -- currently only supports timer and without checking its type is timer
    -- but this will have a case type = timer, emailReceive. ....
    -- this is currently just a stub.
    apex_debug.message(p_message => 'Begin process_IntermediateCatchEvent '||p_step_info.target_objt_ref, p_level => 4) ;
    if p_step_info.target_objt_subtag = 'bpmn:timerEventDefinition'
    then
        -- we have a timer.  Set status to waiting and schedule the timer.
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'waiting for timer'
        where sbfl.sbfl_id = p_subflow_id
            and sbfl.sbfl_prcs_id = p_process_id
        ;
        flow_timers_pkg.start_timer
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );
    else
        -- not a timer.  Just set it to running for now.  (other types to be implemented later)
        update flow_subflows sbfl
        set   sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'running'
        where sbfl.sbfl_id = p_subflow_id
            and sbfl.sbfl_prcs_id = p_process_id
        ;
    end if;
    
end process_intermediateCatchEvent;

procedure process_userTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
begin
    -- current implementation is limited to one userTask type, which is to run a user defined APEX page
    -- future userTask types could include parameterised, standarised template pages , e.g., for approvals??  template scripts ??
    -- current implementation is implemented via the process inbox view.  
    apex_debug.message(p_message => 'Begin process_userTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
    set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = sysdate
         , sbfl.sbfl_status = 'running'
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
end process_userTask;

procedure process_scriptTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
begin
    apex_debug.message(p_message => 'Begin process_scriptTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    -- current implementation is limited to one scriptTask type, which is to run a user defined PL/SQL script
    -- future scriptTask types could include standarised template scripts ??
    -- current implementation is limited to synchronous script execution (i.e., script is run as part of Flows for APEX process)
    -- future implementations could include async scriptTasks, where script execution is queued.
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = sysdate
         , sbfl.sbfl_status = 'running'
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    flow_run_sync_plsql 
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_current => p_step_info.target_objt_ref
        )
    ;
end process_scriptTask;

procedure process_sendTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
begin
     apex_debug.message(p_message => 'Begin process_sendTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
    set   sbfl.sbfl_current = p_step_info.target_objt_ref
        , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
        , sbfl.sbfl_last_update = sysdate
        , sbfl.sbfl_status = 'running'
    where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- current implementation is limited to one sendTask type, which is for apex message template sent from user defined PL/SQL script
    -- future sendTask types could include text message, tweet, AOP document via email, etc.
    -- current implementation is limited to synchronous send (i.e., email sent as part of Flows for APEX process).begin
    -- future implementations could include async sendTask, where message generation is queued.

    flow_run_sync_plsql 
        ( p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        , p_current =>  p_step_info.target_objt_ref
        )
    ;
end process_sendTask;

procedure process_manualTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_step_info
  )
is 
begin
    apex_debug.message(p_message => 'Begin process_manualTask for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = sysdate
         , sbfl.sbfl_status = 'running'
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
end process_manualTask;

/* 
================================================================================
   E V E N T   H A N D L I N G 
================================================================================
*/

procedure handle_event_gateway_event
  ( p_process_id         in flow_processes.prcs_id%type
  , p_parent_subflow_id  in flow_subflows.sbfl_id%type
  , p_cleared_subflow_id in flow_subflows.sbfl_id%type
  )
is 
    l_forward_route         flow_connections.conn_id%type;
    l_current_object        flow_subflows.sbfl_current%type;
    l_child_starting_object flow_subflows.sbfl_starting_object%type;
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_parent_sbfl           flow_subflows.sbfl_id%type;
    l_return                varchar2(50);
begin
    apex_debug.message(p_message => 'Begin handle_event_gateway_event', p_level => 3) ;
    -- called from any event that has cleared (so expired timer, received message or signal, etc) to move eBG forwards
    -- procedure has to:
    -- - check that gateway has not already been cleared by another event
    -- - resume the incoming subflow on the path of the first event to occur and call next_step
    -- - stop / terminate all of the child subflows that were created to wait for other events
    -- - including making sure any timers, message receivers, etc., are cleared up.

    begin
      select sbfl.sbfl_id
        into l_parent_sbfl
        from flow_subflows sbfl
       where sbfl.sbfl_id = p_parent_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_status = 'split'
          ;
     exception
       when no_data_found then
        -- gateway aready cleared
         raise; 
     end;
     -- make the incoming (main) (split) parent subflow proceed along the path of the cleared event.clear(
    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
     select conn.conn_id
          , sbfl.sbfl_current
          , sbfl.sbfl_starting_object
       into l_forward_route
          , l_current_object
          , l_child_starting_object
       from flow_objects objt
       join flow_subflows sbfl on sbfl.sbfl_current = objt.objt_bpmn_id
       join flow_connections conn on conn.conn_src_objt_id = objt.objt_id
      where sbfl.sbfl_id = p_cleared_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
        and objt.objt_dgrm_id = l_dgrm_id
        and conn.conn_dgrm_id = l_dgrm_id
        and conn.conn_tag_name = 'bpmn:sequenceFlow'
          ;
     update flow_subflows sbfl
        set sbfl_status = 'running'
          , sbfl_current = l_current_object
          , sbfl_last_update = sysdate
      where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_parent_subflow_id
        and sbfl.sbfl_status = 'split'
          ;
       flow_next_step           
          ( p_process_id => p_process_id
          , p_subflow_id => p_parent_subflow_id
          , p_forward_route => null
          );
    -- now clear up all of the sibling subflows
    begin
      for child_subflows in (
        select sbfl.sbfl_id
             , sbfl.sbfl_current
             , objt.objt_sub_tag_name
          from flow_subflows sbfl
          join flow_objects objt on sbfl.sbfl_current = objt.objt_bpmn_id
         where sbfl.sbfl_sbfl_id = p_parent_subflow_id
           and sbfl.sbfl_starting_object = l_child_starting_object
           and objt.objt_dgrm_id = l_dgrm_id
      )
      loop
          -- clean up any event handlers (timers, etc.) (add more here when supporting messageEvent, SignalEvent, etc.)
          if child_subflows.objt_sub_tag_name = 'bpmn:timerEventDefinition'
          then
            flow_timers_pkg.terminate_timer
                ( p_process_id => p_process_id
                , p_subflow_id => child_subflows.sbfl_id
                , p_return_code => l_return
                );
          end if;
          -- delete the completed subflow and log it as complete
              
          delete
            from flow_subflows sbfl
          where sbfl.sbfl_prcs_id = p_process_id
            and sbfl.sbfl_id = child_subflows.sbfl_id
              ;
          -- logging - tbd
      end loop;
    end;  -- cleanup block
end handle_event_gateway_event;

procedure handle_intermediate_catch_event
     ( p_process_id in flow_processes.prcs_id%type
     , p_subflow_id in flow_subflows.sbfl_id%type
     ) 
is
begin
      apex_debug.message(p_message => 'Begin handle_intermediate_catch_event', p_level => 3) ;
      update flow_subflows sbfl 
         set sbfl.sbfl_status = 'running'
           , sbfl.sbfl_last_update = sysdate
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_id = p_subflow_id
           ;
      flow_next_step 
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_forward_route => null
      );
end handle_intermediate_catch_event;


procedure flow_handle_event
     ( p_process_id in flow_processes.prcs_id%type
     , p_subflow_id in flow_subflows.sbfl_id%type
    ) is
    l_parent_subflow        flow_subflows.sbfl_id%type;
    l_prev_objt_tag_name    flow_objects.objt_tag_name%type;
    l_curr_objt_tag_name    flow_objects.objt_tag_name%type;
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_sbfl_current          flow_subflows.sbfl_current%type;
begin
    apex_debug.message(p_message => 'Begin flow_handle_event', p_level => 3) ;
    -- look at current event to check if it is a startEvent.  (this also has no previous event!)
    -- if not, examine previous event on the subflow to determine if it was eventBasedGateway (eBG)
    -- an intermediateCatchEvent (iCE) following an eBG will always have exactly 1 input (from the eBG)
    -- an independant iCE (not following an eBG) can have >1 inputs
    -- so look for preceding eBG.  If previous event not eBG or there are multiple prev events, it did not follow an eBG.
    l_dgrm_id := get_dgrm_id (p_prcs_id => p_process_id);

      select curr_objt.objt_tag_name
           , sbfl.sbfl_sbfl_id
           , sbfl.sbfl_current
        into l_curr_objt_tag_name
           , l_parent_subflow
           , l_sbfl_current
      from flow_objects curr_objt 
      join flow_subflows sbfl on sbfl.sbfl_current = curr_objt.objt_bpmn_id
      where sbfl.sbfl_id = p_subflow_id
      and   sbfl.sbfl_prcs_id = p_process_id
      and   curr_objt.objt_dgrm_id = l_dgrm_id
        ;

    if l_curr_objt_tag_name = 'bpmn:startEvent' -- startEvent with associated event.
    then
        -- required functionality same as iCE currently
        handle_intermediate_catch_event (
          p_process_id => p_process_id
        , p_subflow_id => p_subflow_id
        );
    else
      begin
        select prev_objt.objt_tag_name
          into l_prev_objt_tag_name
          from flow_connections conn 
          join flow_objects curr_objt on conn.conn_tgt_objt_id = curr_objt.objt_id 
          join flow_objects prev_objt on conn.conn_src_objt_id = prev_objt.objt_id
         where conn.conn_dgrm_id = l_dgrm_id
           and   curr_objt.objt_bpmn_id = l_sbfl_current
           and   curr_objt.objt_dgrm_id = l_dgrm_id
           and   prev_objt.objt_dgrm_id = l_dgrm_id
            ;
      exception
        when too_many_rows then
            l_prev_objt_tag_name := 'other';
      end;
      if  l_curr_objt_tag_name = 'bpmn:intermediateCatchEvent' and 
            l_prev_objt_tag_name = 'bpmn:eventBasedGateway'  -- we have an eventBasedGateway
      then 
          handle_event_gateway_event (
            p_process_id => p_process_id
          , p_parent_subflow_id => l_parent_subflow
          , p_cleared_subflow_id => p_subflow_id
          );
      elsif l_curr_objt_tag_name = 'bpmn:intermediateCatchEvent'
      then
          -- independant iCE not following an eBG
          -- set subflow status to running and call next step
          handle_intermediate_catch_event (
            p_process_id => p_process_id
          , p_subflow_id => p_subflow_id
          );
      end if;
    end if;
end flow_handle_event;

/************************************************************************************************************
****
****                       SUBFLOW FUNCTIONS (START, NEXT_STEP, STOP,  DELETE)
****
*************************************************************************************************************/


procedure flow_next_step
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_forward_route in flow_connections.conn_bpmn_id%type default null
)
is
  l_sbfl_rec              flow_subflows%rowtype;
  l_step_info             flow_engine.flow_step_info;
  l_dgrm_id               flow_diagrams.dgrm_id%type;
  l_prcs_check_id         flow_processes.prcs_id%type;
begin
  apex_debug.message(p_message => 'Begin flow_next_step', p_level => 3) ;
  l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
  -- Get current object and current subflow info
  begin
    begin
        select *
        into l_sbfl_rec
        from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
            ;
    exception
        when no_data_found then
        -- check if subflow valid in process
        select sbfl.sbfl_prcs_id
          into l_prcs_check_id
          from flow_subflows sbfl
         where sbfl.sbfl_id = p_subflow_id
         ;
        if l_prcs_check_id != p_process_id
        then
            apex_error.add_error
            ( p_message => 'Application Error: Subflow ID supplied ( '||p_subflow_id||' ) exists but is not child of Process ID Supplied ( '||p_process_id||' ).'
            , p_display_location => apex_error.c_on_error_page
            );
        end if;
    end;
  exception
    when no_data_found then
            apex_error.add_error
            ( p_message => 'Application Error: Subflow ID supplied ( '||p_subflow_id||' ) not found .'
            , p_display_location => apex_error.c_on_error_page
            );
  end;
  -- Find next subflow step
  begin
    select l_dgrm_id
         , objt_source.objt_tag_name
         , conn.conn_tgt_objt_id
         , objt_target.objt_bpmn_id
         , objt_target.objt_tag_name    
         , objt_target.objt_sub_tag_name
      into l_step_info
      from flow_connections conn
      join flow_objects objt_source
        on conn.conn_src_objt_id = objt_source.objt_id
      join flow_objects objt_target
        on conn.conn_tgt_objt_id = objt_target.objt_id
      join flow_subflows sbfl
        on sbfl.sbfl_current = objt_source.objt_bpmn_id 
     where conn.conn_dgrm_id = l_dgrm_id
       and conn.conn_tag_name = 'bpmn:sequenceFlow'
       and conn.conn_bpmn_id like nvl2( p_forward_route, p_forward_route, '%' )
       and sbfl.sbfl_prcs_id = p_process_id
      and sbfl.sbfl_id = p_subflow_id
    ;
  exception
  when no_data_found then
    null;
  when too_many_rows then
    apex_error.add_error
    ( p_message => 'More than 1 forward path found when only 1 allowed'
    , p_display_location => apex_error.c_on_error_page
    );
  end;
  
  -- log current step as completed
  log_step_completion   
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_completed_object => l_sbfl_rec.sbfl_current
  , p_notes => ''
  );
  l_sbfl_rec.sbfl_last_completed := l_sbfl_rec.sbfl_current;

    apex_debug.message(p_message => 'Before CASE ' || coalesce(l_step_info.target_objt_tag, '!NULL!'), p_level => 3) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.dgrm_id : ' || l_step_info.dgrm_id, p_level => 4) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.source_objt_tag : ' || l_step_info.source_objt_tag, p_level => 4) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_id : ' || l_step_info.target_objt_id, p_level => 4) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_ref : ' || l_step_info.target_objt_ref, p_level => 4) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_tag : ' || l_step_info.target_objt_tag, p_level => 4) ;
    apex_debug.message(p_message => 'Before CASE : l_step_info.target_objt_subtag : ' || l_step_info.target_objt_subtag, p_level => 4) ;
    
    apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_id : ' || l_sbfl_rec.sbfl_id, p_level => 4) ;    
    apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_last_completed : ' || l_sbfl_rec.sbfl_last_completed, p_level => 4) ;    
    apex_debug.message(p_message => 'Before CASE : l_sbfl_rec.sbfl_prcs_id : ' || l_sbfl_rec.sbfl_prcs_id, p_level => 4) ;    
   
  case (l_step_info.target_objt_tag)
    when 'bpmn:endEvent'  --next step is either end of process or sub-process returning to its parent
    then
      flow_engine.process_endEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when 'bpmn:exclusiveGateway'
    then
      flow_engine.process_exclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when 'bpmn:inclusiveGateway'
    then
      flow_engine.process_inclusiveGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when 'bpmn:parallelGateway' 
    then
      flow_engine.process_parallelGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when 'bpmn:subProcess' then
      flow_engine.process_subProcess
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when 'bpmn:eventBasedGateway'
    then
        flow_engine.process_eventBasedGateway
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  'bpmn:intermediateCatchEvent' 
    then 
        flow_engine.process_intermediateCatchEvent
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         ); 
    when  'bpmn:task' 
    then 
        flow_engine.process_task
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  'bpmn:userTask' 
    then
        flow_engine.process_userTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  'bpmn:scriptTask' 
    then 
        flow_engine.process_scriptTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  'bpmn:manualTask' 
    then 
        flow_engine.process_manualTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    when  'bpmn:sendTask' 
    then flow_engine.process_sendTask
         ( p_process_id => p_process_id
         , p_subflow_id => p_subflow_id
         , p_sbfl_info => l_sbfl_rec
         , p_step_info => l_step_info
         );
    end case;
exception
    when CASE_NOT_FOUND
    then
      apex_error.add_error
      ( p_message => 'Process Model Error: Process BPMN model next step uses unsupported object: '||l_step_info.target_objt_tag
      , p_display_location => apex_error.c_on_error_page
      );
    when NO_DATA_FOUND
    then
      apex_error.add_error
      ( p_message => 'Next step does not exist.'
      , p_display_location => apex_error.c_on_error_page
      );
end flow_next_step;

/************************************************************************************************************
****
****                       PROCESS INSTANCE FUNCTIONS (START, STOP, RESET, DELETE)
****
*************************************************************************************************************/

procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  )
is
        l_return_code   number;
begin
    apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;
  
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

        
    -- kill any timers sill running in the process
    flow_timers_pkg.terminate_process_timers(
        p_process_id => p_process_id
      , p_return_code => l_return_code
    );  
    
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
--    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
--    commented out during testing of inc/exclusive gateways and before run scriptTask is working
--    put this back in before FFA50
--    process variables are NOT being cleared when the process is reset without this

    update flow_processes prcs
       set prcs.prcs_last_update = sysdate
         , prcs.prcs_status = 'created'
     where prcs.prcs_id = p_process_id
    ;
end flow_reset;

procedure flow_delete
  (
    p_process_id in flow_processes.prcs_id%type
  )
is
    l_return_code   number;
begin
    apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers(
        p_process_id => p_process_id
      , p_return_code => l_return_code
    );  

    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;

    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
    
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;
end flow_delete;

end flow_engine;
/

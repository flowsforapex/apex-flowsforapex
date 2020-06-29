create or replace package body flow_api_pkg
as
-- get diagram name
  function get_dgrm_name
  (
    p_process_id in flow_processes.prcs_id%type
  ) return varchar2
  is
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
    apex_debug.message(p_message => 'Begin dgrm_name', p_level => 3) ;
    select prcs.prcs_dgrm_name
      into l_dgrm_name
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;

    return l_dgrm_name;
  exception
    when others then
      raise;
  end get_dgrm_name;

  function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_id%type -- an object in the subprocess
  ) return number
  is
      l_parent_subflow flow_subflows.sbfl_id%type;
      l_parent_subproc_activity flow_objects.objt_id%type;
      l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
      l_dgrm_name := get_dgrm_name(p_process_id);
      -- get parent bpmn:subProcess object
      select objt.objt_origin
        into l_parent_subproc_activity
        from flow_objects objt
      where objt.objt_id = p_current
        and objt.objt_dgrm_name = l_dgrm_name
          ;
      -- try to get parent subflow
      begin
          select sbfl.sbfl_id
            into l_parent_subflow
            from flow_subflows sbfl
          where sbfl.sbfl_current = l_parent_subproc_activity
            and sbfl.sbfl_status = 'in subprocess'
            and sbfl.sbfl_parent_process = p_process_id
              ;
      exception
          when NO_DATA_FOUND
          then
              -- no subflow found running the parent process 
              return null;
          when others
          then 
              raise;
      end;
      return l_parent_subflow;
  exception
      when others 
      then
          raise;
  end get_subprocess_parent_subflow;

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
  end log_step_completion;

  function flow_create
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_process_name in flow_processes.prcs_name%type default null
  ) return number
  is
    l_ret number;
  begin
       apex_debug.message(p_message => 'Begin flow_create', p_level => 3) ;
      insert 
        into  flow_processes prcs
            ( prcs.prcs_name
            , prcs.prcs_dgrm_name
            , prcs.prcs_status
            , prcs.prcs_init_date
            , prcs.prcs_last_update
            )
      values
            ( p_process_name
            , p_diagram_name
            , 'created'
            , sysdate
            , sysdate
            )
    returning prcs.prcs_id
        into l_ret
            ;
      apex_debug.message(p_message => 'End flow_create', p_level => 3) ;
    return l_ret;
  exception
    when others
    then
      raise;
  end flow_create;


function subflow_start
( p_process_id in flow_processes.prcs_id%type
, p_parent_subflow in flow_subflows.sbfl_id%type
, p_starting_object in flow_objects.objt_id%type
, p_current_object in flow_objects.objt_id%type
, p_route in flow_connections.conn_id%type
, p_last_completed in flow_objects.objt_id%type
--, p_lane
) return number
is 
    l_ret number;
begin
    apex_debug.message(p_message => 'Begin subflow_start', p_level => 3) ;
    insert
      into flow_subflows sbfl
         ( sbfl.sbfl_parent_subflow
         , sbfl.sbfl_parent_process
         , sbfl.sbfl_starting_object
         , sbfl.sbfl_route
         , sbfl.sbfl_last_completed
         , sbfl.sbfl_current
         , sbfl.sbfl_status
         , sbfl.sbfl_last_update
         )
    values
         ( p_parent_subflow
         , p_process_id
         , p_starting_object
         , p_route
         , p_last_completed
         , p_current_object
         , 'running'
         , sysdate
         )
    returning sbfl.sbfl_id
      into l_ret;
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
    l_parent_subflow_id flow_subflows.sbfl_id%type;
    l_parent_subflow_status flow_subflows.sbfl_status%type;
    l_parent_subflow_last_completed flow_subflows.sbfl_last_completed%type;
    l_parent_subflow_current flow_subflows.sbfl_current%type;
begin
    apex_debug.message(p_message => 'Begin subflow_complete', p_level => 3) ;

    select sbfl.sbfl_parent_subflow
         , sbfl.sbfl_current
         , sbfl.sbfl_status
      into l_parent_subflow_id
         , l_current_object
         , l_current_subflow_status
      from flow_subflows sbfl
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_parent_process = p_process_id
         ; 
    if l_parent_subflow_id is not null 
    then   
        -- get parent subflow info
        select sbfl.sbfl_status
             , sbfl.sbfl_last_completed
             , sbfl.sbfl_current
          into l_parent_subflow_status
             , l_parent_subflow_last_completed
             , l_parent_subflow_current
          from flow_subflows sbfl
         where sbfl.sbfl_id = l_parent_subflow_id
           and sbfl.sbfl_parent_process = p_process_id
            ;
    end if;
    -- delete the completed subflow and log it as complete
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_parent_process = p_process_id
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

    if l_parent_subflow_id is not null 
    then   

        select count(sbfl.sbfl_id)
        into l_remaining_siblings
        from flow_subflows sbfl
        where sbfl.sbfl_parent_process = p_process_id
        and sbfl.sbfl_starting_object = l_parent_subflow_last_completed
            ;
        if l_remaining_siblings = 0 and l_parent_subflow_status = 'split'  
           and l_current_subflow_status != 'waiting at gateway'
        then
            delete
            from flow_subflows sbfl
            where sbfl.sbfl_parent_process = p_process_id
            and sbfl.sbfl_id = l_parent_subflow_id
            ;       
            -- log current step as completed
            /*log_step_completion
                ( p_process_id => p_process_id
                , p_subflow_id => l_parent_subflow_id
                , p_completed_object => l_parent_subflow_current
                , p_notes => ''
                );*/
        end if;  
    end if;
    -- check if there are ANY remaining subflows.  If not, close process
    select count(*)
      into l_remaining_subflows
      from flow_subflows sbfl
     where sbfl.sbfl_parent_process = p_process_id
          ;
    if l_remaining_subflows = 0
    then 
        -- No remaining subflows so process has completed
        update flow_processes prcs 
           set prcs.prcs_status = 'completed'
             , prcs.prcs_last_update = sysdate
             , prcs.prcs_main_subflow = ''
         where prcs.prcs_id = p_process_id
             ;
        apex_debug.message(p_message => 'Process Completed: Process '||p_process_id, p_level => 4) ;

    end if
    ;

end subflow_complete;

  function next_step_exists -- not using this now.  Needs checking. remove PROCESS
  ( p_process_id in flow_processes.prcs_id%type
  ,  p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean
  is
    l_next_count number;
    l_dgrm_name   flow_diagrams.dgrm_name%type;
  begin
    apex_debug.message(p_message => 'Begin next_step_exists', p_level => 3) ;
    l_dgrm_name:= get_dgrm_name(p_process_id => p_process_id);
    if p_subflow_id is not null
    then
      select count(*)                        
        into l_next_count
        from flow_subflows sbfl
          , flow_objects   objt
      where sbfl.sbfl_parent_process = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        and  objt.objt_dgrm_name = l_dgrm_name
        and  objt.objt_id = sbfl.sbfl_current
        and (  objt.objt_tag_name != 'bpmn:endEvent'
            or (   objt.objt_tag_name = 'bpmn:endEvent'
                and objt.objt_type != 'PROCESS'
                )
                or objt.objt_tag_name = 'bpmn:startEvent'
            )
            ;
        if l_next_count > 0
        then
          return true;
        else
          return false;
        end if;
    else 
      return false;
    end if;
  exception
    when others
    then
      raise;
  end next_step_exists;

  function next_step_exists_yn 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2
  is
      l_ret boolean;
  begin
      l_ret := next_step_exists
              ( p_process_id => p_process_id
              , p_subflow_id => p_subflow_id
              );
      if l_ret = true
      then
          return 'y';
      else 
          return 'n';
      end if;
  end;

function next_multistep_exists 
( p_process_id in flow_processes.prcs_id%type
, p_subflow_id in flow_subflows.sbfl_id%type
) return boolean
-- returns true if next step requires a choice of direction (i.e., has a tag of
-- - an Opening Exclusive Gateway
-- - an Opening Optional Gateway
is
  l_next_count number;
  l_dgrm_name   flow_diagrams.dgrm_name%type;
begin
  apex_debug.message(p_message => 'Begin next_multistep_exists', p_level => 3) ;
  if (p_subflow_id is not null and p_process_id is not null)
  then
    l_dgrm_name:= get_dgrm_name(p_process_id => p_process_id);
    select count(*)                        
      into l_next_count
      from flow_subflows   sbfl
         , flow_connections conn
     where sbfl.sbfl_parent_process = p_process_id
       and sbfl.sbfl_id = p_subflow_id
       and conn.conn_dgrm_name = l_dgrm_name
       and conn.conn_source_ref = sbfl.sbfl_current
         ;

      if l_next_count > 1
      then
        return true;
      else
        return false;
      end if;
  else
    return false;
  end if;
exception
  when others
  then
    raise;
end next_multistep_exists;

function next_multistep_exists_yn 
( p_process_id in flow_processes.prcs_id%type
, p_subflow_id in flow_subflows.sbfl_id%type
) return varchar2
is
    l_ret boolean;
begin
    l_ret := next_multistep_exists
            ( p_process_id => p_process_id
            , p_subflow_id => p_subflow_id
            );
    if l_ret = true
    then
        return 'y';
    else 
        return 'n';
    end if;
end;

function get_current_progress -- creates the markings for the bpmn viewer to show current progress
( p_process_id in flow_processes.prcs_id%type
) return varchar2
is 
    l_marker_json varchar2(2000);
begin
    apex_debug.message(p_message => 'Begin get_current_progress', p_level => 3) ;
    WITH markings AS 
    (
    select 
          sflg.sflg_objt_id bpmnObject
         ,'completed-node-bpmn' marking
         ,'1' layer
      from flow_subflow_log sflg 
     where sflg.sflg_prcs_id = p_process_id
    UNION
    select distinct 
          sbfl.sbfl_last_completed bpmnObject 
        ,'last-completed-node-bpmn'  marking
        , '2' layer
     from flow_subflows sbfl
    where sbfl.sbfl_last_completed is not null
      and sbfl.sbfl_parent_process = p_process_id
    UNION
    select distinct 
          sbfl.sbfl_current bpmnObject 
        ,'current-node-bpmn'  marking
        , '3' layer
     from flow_subflows sbfl
    where sbfl.sbfl_current is not null
      and sbfl.sbfl_parent_process = p_process_id
    )
    select JSON_ARRAYAGG
            ( JSON_OBJECT
                ( KEY 'bpmnObject' VALUE m.bpmnObject
                , KEY 'marking' VALUE m.marking
                ) order by m.layer asc
            )
      into l_marker_json  
      from markings m
    ;
    return l_marker_json;

end get_current_progress;

procedure flow_start
( p_process_id in flow_processes.prcs_id%type
)
is
  l_dgrm_name        flow_diagrams.dgrm_name%type;
  l_objt_id          flow_objects.objt_id%type;
  l_main_subflow_id  flow_subflows.sbfl_id%type;
  l_process_status   flow_processes.prcs_status%type;
begin
  l_dgrm_name:= get_dgrm_name( p_process_id => p_process_id);
  begin
    apex_debug.message(p_message => 'Begin flow_start', p_level => 3) ;
    -- check the process isn't already running & return error if it is
    begin
      select prcs.prcs_status
        into l_process_status
        from flow_processes prcs 
      where prcs.prcs_id = p_process_id
          ;
      if l_process_status != 'created'
      then
          apex_error.add_error
          ( p_message => 'You tried to start a process that is already running'
          , p_display_location => apex_error.c_on_error_page
          );  
      end if;
    exception
      when no_data_found then
          apex_error.add_error
          ( p_message => 'You tried to start a non-existant process.'
          , p_display_location => apex_error.c_on_error_page
          );  
      when TOO_MANY_ROWS then
          apex_error.add_error
          ( p_message => 'Multiple copies of the process already running'
          , p_display_location => apex_error.c_on_error_page
          );  
    end ;
    -- get the object to start with
    select objt.objt_id
      into l_objt_id
      from flow_objects objt
     where objt.objt_id not in (select conn.conn_target_ref from flow_connections conn)
       and objt.objt_dgrm_name = l_dgrm_name
       and objt.objt_tag_name = 'bpmn:startEvent'
       and objt.objt_type = 'PROCESS'
         ;
  exception
  when TOO_MANY_ROWS
  then
    apex_error.add_error
    ( p_message => 'You have multiple starting events defined. Make sure your diagram has only one starting event.'
    , p_display_location => apex_error.c_on_error_page
    );
  when NO_DATA_FOUND
  then
    apex_error.add_error
    ( p_message => 'No starting event was defined.'
    , p_display_location => apex_error.c_on_error_page
    );
  end;
  l_main_subflow_id := subflow_start 
    ( p_process_id => p_process_id
    , p_parent_subflow => null
    , p_starting_object => l_objt_id
    , p_current_object => l_objt_id
    , p_route => 'main'
    , p_last_completed => null
  );
  -- step into first step
  flow_next_step 
        (p_process_id => p_process_id
        ,p_subflow_id => l_main_subflow_id
        ,p_forward_route => null
        );
  -- update process status
  update flow_processes prcs
     set 
     --  prcs.prcs_current = l_objt_id
         prcs.prcs_status = 'running'
       , prcs.prcs_last_update = sysdate
       , prcs.prcs_main_subflow = l_main_subflow_id
   where prcs.prcs_dgrm_name = l_dgrm_name 
     and prcs.prcs_id = p_process_id
       ;

end flow_start;

procedure flow_next_step
( p_process_id in flow_processes.prcs_id%type
, p_subflow_id in flow_subflows.sbfl_id%type
, p_forward_route in flow_connections.conn_id%type
)
is
  l_dgrm_name            flow_diagrams.dgrm_name%type;
  l_sbfl_last_completed  flow_subflows.sbfl_last_completed%type;
  l_sbfl_current         flow_subflows.sbfl_current%type;
  l_sbfl_starting_object flow_subflows.sbfl_starting_object%type;
  l_sbfl_status          flow_subflows.sbfl_status%type;
  l_sbfl_id_sub          flow_subflows.sbfl_id%type;
  l_sbfl_id_par          flow_subflows.sbfl_id%type;
  l_sbfl_id              flow_subflows.sbfl_id%type;
  l_conn_target_ref      flow_connections.conn_target_ref%type;
  l_source_objt_type     flow_objects.objt_type%TYPE;
  l_target_objt_type     flow_objects.objt_type%TYPE;
  l_source_objt_tag      flow_objects.objt_tag_name%TYPE;
  l_target_objt_tag      flow_objects.objt_tag_name%TYPE;
  l_target_objt_sub      flow_objects.objt_type%TYPE; --target object in subprocess
  l_num_back_connections    number;   -- number of connections leading into object
  l_num_forward_connections number;   -- number of connections forward from object
  l_num_unfinished_subflows    number;
  l_gateway_forward_status varchar2(10);
begin
  apex_debug.message(p_message => 'Begin flow_next_step', p_level => 3) ;
  l_dgrm_name:= get_dgrm_name( p_process_id => p_process_id);
  -- Get current object and current subflow info
  select sbfl.sbfl_current
       , sbfl.sbfl_starting_object
       , sbfl.sbfl_last_completed
       , sbfl.sbfl_status
       , sbfl.sbfl_parent_subflow
    into l_sbfl_current
       , l_sbfl_starting_object
       , l_sbfl_last_completed
       , l_sbfl_status
       , l_sbfl_id_par
    from flow_subflows sbfl
   where sbfl.sbfl_parent_process = p_process_id
     and sbfl.sbfl_id = p_subflow_id
       ;
  -- Find next subflow step
  begin
      select conn.conn_target_ref
          , objt_source.objt_type
          , objt_target.objt_type
          , objt_source.objt_tag_name
          , objt_target.objt_tag_name
        into l_conn_target_ref
          , l_source_objt_type
          , l_target_objt_type
          , l_source_objt_tag
          , l_target_objt_tag
        from flow_connections conn
        join flow_objects objt_source on (conn.conn_source_ref = objt_source.objt_id)
        join flow_objects objt_target on (conn.conn_target_ref = objt_target.objt_id)
      where conn.conn_source_ref = l_sbfl_current
        and conn.conn_dgrm_name = l_dgrm_name
        and conn.conn_id like nvl2(p_forward_route,p_forward_route,'%')
          ;
  exception
  when NO_DATA_FOUND
  then
    null;
  when TOO_MANY_ROWS
  then
    apex_error.add_error
            ( p_message => 'More than 1 forward path found when only 1 allowed'
            , p_display_location => apex_error.c_on_error_page
            );
  end;
  -- log current step as completed
  log_step_completion
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_completed_object => l_sbfl_current
  , p_notes => ''
  );
  l_sbfl_last_completed := l_sbfl_current;

    case (l_target_objt_tag)

    when 'bpmn:startEvent'  -- next step is either first process step or beginning of a sub-process
    then
        if l_target_objt_type = 'PROCESS'
        then
            apex_debug.message(p_message => 'Next Step is Process Start '||l_conn_target_ref, p_level => 4) ;
            -- shouldn't get here - start handled by subflow_start
        elsif l_target_objt_type = 'SUBPROCESS'
        then
            apex_debug.message(p_message => 'Next Step is SubProcess Start '||l_conn_target_ref, p_level => 4) ;
            -- shouldn't get here either - subprocess start handled by its parent bpmn:subProcess 
        end if
        ;
    when 'bpmn:endEvent'  --next step is either end of process or sub-process returning to it's parent
    then
        -- see if there is a parent process running
        l_sbfl_id_par := get_subprocess_parent_subflow
                ( p_process_id => p_process_id
                , p_subflow_id => p_subflow_id
                , p_current    => l_sbfl_current
                );
        -- log the current endEvent as completed
        log_step_completion
              ( p_process_id => p_process_id
              , p_subflow_id => p_subflow_id
              , p_completed_object => l_conn_target_ref
              , p_notes => ''
              );
        subflow_complete
              ( p_process_id => p_process_id
              , p_subflow_id => p_subflow_id
              );
        if l_sbfl_id_par is null 
        then   
            apex_debug.message(p_message => 'Next Step is Process End '||l_conn_target_ref, p_level => 4) ;
        else  
            apex_debug.message(p_message => 'Next Step is Sub-Process End '||l_conn_target_ref, p_level => 4) ;

            -- return parent flow to running & do next step
            flow_next_step 
                ( p_process_id => p_process_id
                , p_subflow_id => l_sbfl_id_par
                , p_forward_route => null
                );   
        end if 
        ;
    when 'bpmn:exclusiveGateway'
    then
        -- handles opening and closing (but not combined)
        apex_debug.message(p_message => 'Next Step is exclusiveGateway '||l_conn_target_ref, p_level => 4) ;
        update flow_subflows sbfl
        set   sbfl.sbfl_current = l_conn_target_ref
            , sbfl.sbfl_last_completed = l_sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'running'
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_parent_process = p_process_id
        ;      
    when 'bpmn:parallelGateway'
    then
        apex_debug.message(p_message => 'Next Step is parallelGateway '||l_conn_target_ref, p_level => 4) ;
        -- test if this is splitting or merging (or both) gateway
        select count(*)
          into l_num_back_connections
          from flow_connections conn 
         where conn.conn_target_ref = l_conn_target_ref
           and conn.conn_dgrm_name = l_dgrm_name
        ;
          select count(*)
          into l_num_forward_connections
          from flow_connections conn 
         where conn.conn_source_ref = l_conn_target_ref
           and conn.conn_dgrm_name = l_dgrm_name
        ;
        l_gateway_forward_status := 'proceed';
        l_sbfl_id  := p_subflow_id;

        if l_num_back_connections >= 2 
        then
            apex_debug.message(p_message => 'Merging Parallel Gateway'||l_conn_target_ref, p_level => 4) ;       
            -- we have merging gateway
            l_gateway_forward_status := 'wait';
            -- set current subflow to status waiting,       
            update flow_subflows sbfl
              set sbfl.sbfl_status = 'waiting at gateway'
                , sbfl.sbfl_last_update = sysdate 
                , sbfl.sbfl_current = l_conn_target_ref
            where sbfl.sbfl_id = p_subflow_id
              and sbfl.sbfl_parent_process = p_process_id
                ;
            -- check if we are waiting for other flows or can proceed
            select count(*)
              into l_num_unfinished_subflows
              from flow_subflows sbfl
             where sbfl.sbfl_parent_process = p_process_id
               and sbfl.sbfl_starting_object = l_sbfl_starting_object
               and ( sbfl.sbfl_current != l_conn_target_ref
                   or sbfl.sbfl_status != 'waiting at gateway' )
                 ;
            if l_num_unfinished_subflows = 0
            then
              -- all merging tasks completed.  proceed from gateway
              for completed_subflows in (
                 select sbfl.sbfl_id
                   from flow_subflows sbfl 
                  where sbfl.sbfl_parent_process = p_process_id
                    and sbfl.sbfl_starting_object = l_sbfl_starting_object
                    and sbfl.sbfl_current = l_conn_target_ref 
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
              l_sbfl_id := l_sbfl_id_par;
              --restart parent split subflow
              update flow_subflows sbfl
                 set sbfl.sbfl_status = 'proceed from gateway'
                   , sbfl.sbfl_current = l_conn_target_ref
                   , sbfl.sbfl_last_update = sysdate
               where sbfl.sbfl_last_completed = l_sbfl_starting_object
                 and sbfl.sbfl_status = 'split'
                 and sbfl.sbfl_id = l_sbfl_id_par
                   ;
            end if;
        end if;
        -- now do forward path, if you have token to 'proceed'
        if l_gateway_forward_status = 'proceed'
        then 
            if l_num_forward_connections > 1
            then
                -- we have splitting gateway going forward
                begin
                -- get all forward parallel paths & create subflows for them
                -- these are paths forward of l_conn_target_ref as we are doing double step
                for new_path in (
                    select conn.conn_id route
                          , conn.conn_target_ref target
                      from flow_connections conn 
                      where conn.conn_dgrm_name = l_dgrm_name
                        and conn.conn_source_ref = l_conn_target_ref
                )
                loop
                      l_sbfl_id_sub := subflow_start
                          ( p_process_id =>  p_process_id         
                          , p_parent_subflow =>  l_sbfl_id        
                          , p_starting_object =>  l_conn_target_ref         
                          , p_current_object => l_conn_target_ref          
                          , p_route =>  new_path.route         
                          , p_last_completed =>  l_conn_target_ref        
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
                    set sbfl.sbfl_last_completed = l_conn_target_ref
                      , sbfl.sbfl_current = ''
                      , sbfl.sbfl_status = 'split'
                      , sbfl.sbfl_last_update = sysdate 
                  where sbfl.sbfl_id = l_sbfl_id
                    and sbfl.sbfl_parent_process = p_process_id
                      ;
                exception
                  when NO_DATA_FOUND then
                        apex_error.add_error
                          ( p_message => 'No forward paths found for opening Parallel Gateway'
                          , p_display_location => apex_error.c_on_error_page
                          );
                  when TOO_MANY_ROWS then
                        apex_error.add_error
                          ( p_message => 'Too many forward paths found  opening Parallel Gateway'
                          , p_display_location => apex_error.c_on_error_page
                          );
                end;
            elsif l_num_forward_connections = 1
            then
                -- only single path going forward
                update  flow_subflows sbfl
                    set sbfl.sbfl_last_completed = l_conn_target_ref
                      , sbfl.sbfl_current = l_conn_target_ref
                      , sbfl.sbfl_status = 'running'
                      , sbfl.sbfl_last_update = sysdate 
                  where sbfl.sbfl_id = l_sbfl_id
                    and sbfl.sbfl_parent_process = p_process_id
                      ;
                -- step into first step on the new path
                flow_next_step 
                          (p_process_id => p_process_id
                          ,p_subflow_id => l_sbfl_id
                          ,p_forward_route => null
                          );
            end if;  -- single path
        end if;  -- forward token
    when 'bpmn:subProcess'
    then
        apex_debug.message(p_message => 'Next Step is subProcess start '||l_conn_target_ref, p_level => 4) ;   
        -- find subProcess startEvent
        begin
            select objt.objt_id
              into l_target_objt_sub
              from flow_objects objt
             where objt.objt_origin = l_conn_target_ref 
               and objt.objt_tag_name = 'bpmn:startEvent'
               and objt.objt_dgrm_name = l_dgrm_name
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
                , p_starting_object => l_conn_target_ref -- parent subProc activity
                , p_current_object => l_target_objt_sub -- subProc startEvent
                , p_route => 'sub main'
                , p_last_completed => l_sbfl_last_completed -- previous activity on parent proc
                );
        -- step into sub_process
        flow_next_step 
              (p_process_id => p_process_id
              ,p_subflow_id => l_sbfl_id_sub
              ,p_forward_route => null
              );
        -- update parent subflow
        update flow_subflows sbfl
        set   sbfl.sbfl_current = l_conn_target_ref -- parent subProc Activity
            , sbfl.sbfl_last_completed = l_sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'in subprocess'
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_parent_process = p_process_id
        ;  
    when  'bpmn:task' --- next step is a simple activity / task
    then 
        -- should this be when others?  
        -- then we make everything behave like a simple activity unless specifically supported
        -- currently any tag fails unless explicitly supported
        apex_debug.message(p_message => 'Next Step is task '||l_conn_target_ref, p_level => 4) ;
        update flow_subflows sbfl
        set   sbfl.sbfl_current = l_conn_target_ref
            , sbfl.sbfl_last_completed = l_sbfl_last_completed
            , sbfl.sbfl_last_update = sysdate
            , sbfl.sbfl_status = 'running'
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_parent_process = p_process_id
        ;
    end case;

exception
  when TOO_MANY_ROWS
  then
    apex_error.add_error
    ( p_message => 'Branch instead of next step was found.'
    , p_display_location => apex_error.c_on_error_page
    );
  when NO_DATA_FOUND
  then
    apex_error.add_error
    ( p_message => 'Next step does not exist.'
    , p_display_location => apex_error.c_on_error_page
    );
  when others
  then
    raise;
end flow_next_step;


procedure flow_next_branch
( p_process_id  in flow_processes.prcs_id%type
, p_subflow_id in flow_subflows.sbfl_id%type
, p_branch_name in varchar2
)
is
  l_dgrm_name            flow_diagrams.dgrm_name%type;
  l_conn_target_ref      flow_connections.conn_target_ref%type;
  l_sbfl_current         flow_subflows.sbfl_current%type;
  l_current_tag_name    flow_objects.objt_tag_name%type;
  l_new_subflow         flow_subflows.sbfl_id%type;
begin
  apex_debug.message(p_message => 'Begin flow_next_branch', p_level => 3) ;
  -- get diagram name and current state
  select prcs.prcs_dgrm_name
       , sbfl.sbfl_current
    into l_dgrm_name
       , l_sbfl_current
    from flow_subflows sbfl
    join flow_processes prcs on (sbfl.sbfl_parent_process = prcs.prcs_id)
   where sbfl.sbfl_parent_process = p_process_id
     and sbfl.sbfl_id = p_subflow_id
       ;
  --get current object tag type
  select objt.objt_tag_name
    into l_current_tag_name
    from flow_objects objt
   where objt.objt_id = l_sbfl_current
     and objt.objt_dgrm_name = l_dgrm_name
       ;
  case l_current_tag_name 
  when 'bpmn:exclusiveGateway'
  then
    -- only only path chosen.  Keep existing subflow but switch to chosen path
        begin

            -- log current step as completed
            log_step_completion
                ( p_process_id => p_process_id
                , p_subflow_id => p_subflow_id
                , p_completed_object => l_sbfl_current
                , p_notes => ''
                );

            select conn.conn_target_ref
            into l_conn_target_ref
            from flow_connections conn
            where conn.conn_source_ref = l_sbfl_current
            and conn.conn_dgrm_name = l_dgrm_name
            and conn.conn_id = p_branch_name
                ;
            -- possibly change this to call flow_next_step?
            update flow_subflows sbfl
            set   sbfl.sbfl_current = l_conn_target_ref
                , sbfl.sbfl_last_completed = l_sbfl_current
                , sbfl.sbfl_last_update = sysdate
                , sbfl.sbfl_status = 'running'
            where sbfl.sbfl_id  = p_subflow_id
              and sbfl.sbfl_parent_process = p_process_id
                ;
        exception
        when NO_DATA_FOUND 
        then
            apex_error.add_error
            ( p_message => 'No branch was found.'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
  when 'bpmn:parallelGateway'
  then
        apex_debug.message(p_message => 'Begin creating parallelFlows', p_level => 3) ;
        begin
           -- get all forward parallel paths & create subflows for them
           for new_path in (
               select conn.conn_name route
                    , conn.conn_target_ref target
                 from flow_connections conn 
                where conn.conn_dgrm_name = l_dgrm_name
                  and conn.conn_source_ref = l_sbfl_current
           )
           loop
                l_new_subflow := subflow_start
                    ( p_process_id =>  p_process_id         
                    , p_parent_subflow =>  p_subflow_id         
                    , p_starting_object =>  l_sbfl_current         
                    , p_current_object => new_path.target          
                    , p_route =>  new_path.route         
                    , p_last_completed =>  l_sbfl_current         
                    );
           end loop;
        end;
        -- set current subflow to status split, current = null       
        update flow_subflows sbfl
           set sbfl.sbfl_last_completed = l_sbfl_current
             , sbfl.sbfl_current = ''
             , sbfl.sbfl_status = 'split'
             , sbfl.sbfl_last_update = sysdate 
         where sbfl.sbfl_id = p_subflow_id
           and sbfl.sbfl_parent_process = p_process_id
             ;

    when 'bpmn:optionalGateway'
  then
        apex_debug.message(p_message => 'Begin creating optional Flows', p_level => 3) ;
        -- to be implemented
        -- parse returned branches list
        -- step through all forward parallel paths
           -- create subflow & initialise
           -- set current subflow to status split, current = null
  end case;

end flow_next_branch;

procedure flow_reset
( p_process_id in flow_processes.prcs_id%type
)
is
begin
  apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;

-- clear out run-time object_log
-- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
-- into log audit trail  (not yet planned feature!)
  delete from flow_subflow_log sflg 
   where sflg_prcs_id = p_process_id
       ;
  delete from flow_subflows sbfl
   where sbfl.sbfl_parent_process = p_process_id
       ;
  update flow_processes prcs
     set prcs.prcs_last_update = sysdate
       , prcs.prcs_status = 'created'
   where prcs.prcs_id = p_process_id
       ;

end flow_reset;

procedure flow_delete
( p_process_id in flow_processes.prcs_id%type
)
is
begin
  apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
-- clear out run-time object_log
-- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
-- into log audit trail  (not yet planned feature!)
  delete from flow_subflow_log sflg 
   where sflg_prcs_id = p_process_id
       ;
  delete
    from flow_subflows sbfl
   where sbfl.sbfl_parent_process = p_process_id
       ;
  delete
    from flow_processes prcs
   where prcs.prcs_id = p_process_id
       ;

end flow_delete;

end flow_api_pkg;
/
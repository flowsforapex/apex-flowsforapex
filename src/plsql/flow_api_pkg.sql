create or replace package flow_api_pkg
as

  function flow_create
  ( 
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_process_name in flow_processes.prcs_name%type default null
  ) return number;
  
  function next_step_exists
  ( 
    p_process_id in number
  ) return boolean;
  
  function next_multistep_exists
  ( 
    p_process_id in number
  ) return boolean;
  
  procedure flow_start
  (
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_next_step
  (
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_next_branch
  ( 
    p_process_id  in flow_processes.prcs_id%type
  , p_branch_name in varchar2
  );
  
  procedure flow_reset
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_delete
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  
end flow_api_pkg;
/

create or replace package body flow_api_pkg
as
-- get diagram name
  function get_dgrm_name
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2
  is
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
    select prcs.prcs_dgrm_name
      into l_dgrm_name
      from flow_processes prcs
     where prcs.prcs_id = p_prcs_id
    ;
         
    return l_dgrm_name;
  exception
    when others then
      raise;
  end get_dgrm_name;

  function flow_create
  (
    p_diagram_name in flow_diagrams.dgrm_name%type
  , p_process_name in flow_processes.prcs_name%type default null
  ) return number
  is
    l_ret number;
  begin
       insert 
         into flow_processes prcs
            ( prcs.prcs_name
            , prcs.prcs_dgrm_name
            , prcs.prcs_current
            , prcs.prcs_init_date
            , prcs.prcs_last_update
            )
       values
            ( p_process_name
            , p_diagram_name
            , null
            , sysdate
            , sysdate
            )
    returning prcs.prcs_id
         into l_ret
            ;
    return l_ret;
  exception
    when others then
      raise;
  end flow_create;

  function next_step_exists
  ( p_process_id in number
  ) return boolean
  is
    l_next_count number;
    l_dgrm_name   flow_diagrams.dgrm_name%type;
  begin
    l_dgrm_name:= get_dgrm_name(p_prcs_id => p_process_id);
    if p_process_id is not null
    then
      select count(*)                        
        into l_next_count
        from flow_processes prcs
           , flow_objects   objt
       where prcs.prcs_id = p_process_id
         and  objt.objt_dgrm_name = l_dgrm_name
         and  objt.objt_id = prcs.prcs_current
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
    end if;
  exception
    when others
    then
      raise;
  end next_step_exists;
  function next_multistep_exists
  ( p_process_id in number
  ) return boolean
  is
    l_next_count number;
    l_dgrm_name   flow_diagrams.dgrm_name%type;
  begin
    l_dgrm_name:= get_dgrm_name(p_prcs_id => p_process_id);
    if p_process_id is not null
    then
      select count(*)                        
        into l_next_count
        from flow_processes   prcs
           , flow_connections conn
       where prcs.prcs_id = p_process_id
         and conn.conn_dgrm_name = l_dgrm_name
         and conn.conn_source_ref = prcs.prcs_current
           ;
        if l_next_count > 1
        then
          return true;
        else
          return false;
        end if;
    end if;
  exception
    when others
    then
      raise;
  end next_multistep_exists;
  procedure flow_start
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
    l_dgrm_name     flow_diagrams.dgrm_name%type;
    l_objt_id       flow_objects.objt_id%type;
  begin
    l_dgrm_name:= get_dgrm_name( p_prcs_id => p_process_id);
    begin
      -- get the object to start with
      select objt.objt_id
        into l_objt_id
        from flow_objects objt
       where objt.objt_id not in (select conn.conn_target_ref from flow_connections conn)
         and objt.objt_dgrm_name = l_dgrm_name
         and objt.objt_tag_name = 'bpmn:startEvent'
         and objt.objt_type = 'PROCESS'
         and objt.objt_origin = 'Process_0rxermh' -- if multiple processes were defined, get the main one which always has this static ID
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
    update flow_processes prcs
       set prcs.prcs_current = l_objt_id
         , prcs.prcs_last_update = sysdate
     where prcs.prcs_dgrm_name = l_dgrm_name 
       and prcs.prcs_id = p_process_id
         ;
  exception
    when others
    then
      raise;
  end flow_start;
  procedure flow_next_step
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
    l_dgrm_name        flow_diagrams.dgrm_name%type;
    l_prcs_current     flow_processes.prcs_current%type;
    l_conn_target_ref  flow_connections.conn_target_ref%type;
    l_source_objt_type flow_objects.objt_type%TYPE;
    l_target_objt_type flow_objects.objt_type%TYPE;
  begin
    l_dgrm_name:= get_dgrm_name( p_prcs_id => p_process_id);
    select prcs.prcs_current
      into l_prcs_current
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
         ;
    -- Go to next process step
    -- From process to process or subprocess to subprocess
    begin
        select conn.conn_target_ref
             , objt_source.objt_type
             , objt_target.objt_type
          into l_conn_target_ref
             , l_source_objt_type
             , l_target_objt_type
          from flow_connections conn
          join flow_objects objt_source on (conn.conn_source_ref = objt_source.objt_id)
          join flow_objects objt_target on (conn.conn_target_ref = objt_target.objt_id)
         where conn.conn_source_ref = l_prcs_current
           and conn.conn_dgrm_name = l_dgrm_name
      group by conn.conn_target_ref
             , objt_source.objt_type
             , objt_target.objt_type
             ;
    exception
    when NO_DATA_FOUND
    then
      null;
    end;
    -- Enter subprocees and go to first step
    if (l_source_objt_type = 'PROCESS' and l_target_objt_type = 'SUB_PROCESS')
    then
      select objt.objt_id
        into l_conn_target_ref
        from flow_objects objt
       where objt.objt_incoming IS NULL
         and objt.objt_origin = 
             ( select conn.conn_target_ref
                 from flow_connections conn
                 join flow_objects objt_source on (conn.conn_source_ref = objt_source.objt_id)
                 join flow_objects objt_target on (conn.conn_target_ref = objt_target.objt_id)
                where conn.conn_source_ref = l_prcs_current
                  and conn.conn_dgrm_name = l_dgrm_name
             );
    
    -- Exit subprocess and go to next step
    elsif l_target_objt_type is null
    then
      select conn.conn_target_ref
        into l_conn_target_ref
        from flow_connections conn
       where conn.conn_source_ref = 
             ( select objt.objt_origin
                 from flow_objects objt
                where objt.objt_id = l_prcs_current
                  and conn.conn_dgrm_name = l_dgrm_name
             );
    end if;
    update flow_processes prcs
       set prcs.prcs_current = l_conn_target_ref
         , prcs.prcs_last_update = sysdate
     where prcs.prcs_dgrm_name = l_dgrm_name
       and prcs.prcs_id = p_process_id
         ;
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
  , p_branch_name in varchar2
  )
  is
    l_dgrm_name       flow_diagrams.dgrm_name%type;
    l_conn_target_ref flow_connections.conn_target_ref%type;
    l_prcs_current    flow_processes.prcs_current%type;
  begin
    -- get diagram name and current state
    select prcs.prcs_dgrm_name
         , prcs.prcs_current
      into l_dgrm_name
         , l_prcs_current
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
         ;
    begin
      select conn.conn_target_ref
        into l_conn_target_ref
        from flow_connections conn
       where conn.conn_source_ref = l_prcs_current
         and conn.conn_dgrm_name = l_dgrm_name
         and conn.conn_name = p_branch_name
           ;
      update flow_processes prcs
         set prcs.prcs_current = l_conn_target_ref
           , prcs.prcs_last_update = sysdate
       where prcs.prcs_dgrm_name = l_dgrm_name
         and prcs.prcs_id = p_process_id
           ;
    exception
    when NO_DATA_FOUND 
    then
      apex_error.add_error
      ( p_message => 'No branch was found.'
      , p_display_location => apex_error.c_on_error_page
      );
    end;
    
  exception
    when others
    then
      raise;
  end flow_next_branch;
  procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
  begin
    update flow_processes prcs
       set prcs.prcs_current = null
         , prcs.prcs_last_update = sysdate
     where prcs.prcs_id = p_process_id
         ;
  exception
    when others
    then
      raise;
  end flow_reset;
  procedure flow_delete
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
  begin
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
         ;
         
  exception
    when others
    then
      raise;
  end flow_delete;

end flow_api_pkg;
/
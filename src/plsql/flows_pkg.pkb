create or replace package body flows_pkg
as

function flow_create
( p_diagram_name in diagrams.dgm_name%type
, p_process_name in processes.prc_name%type default null
) return number
is

  l_ret number;

begin
     insert 
       into processes prc
          ( prc.prc_name
          , prc.prc_dgm_name
          , prc.prc_current
          , prc.prc_init_date
          , prc.prc_last_update
          )
     values
          ( p_process_name
          , p_diagram_name
          , null
          , sysdate
          , sysdate
          )
  returning prc.prc_id
       into l_ret
          ;
  return l_ret;

exception
  when others
  then
    raise;
end flow_create;


procedure flow_start
( p_process_id in processes.prc_id%type
)
is
                         
  l_dgm_name     diagrams.dgm_name%type;
  l_obj_id       objects.obj_id%type;

begin
  -- get diagram name
  select prc.prc_dgm_name
    into l_dgm_name
    from processes prc
   where prc.prc_id = p_process_id
       ;
    
  begin
    -- get the object to start with
    select obj.obj_id
      into l_obj_id
      from objects obj
     where obj.obj_id not in (select con.con_target_ref from connections con)
       and obj.obj_dgm_name = l_dgm_name
       and obj.obj_id like 'StartEvent%'
         ;
  exception
  when TOO_MANY_ROWS
  then
    apex_error.add_error(p_message => 'You have multiple starting events defined. Make sure your diagram has only one starting event.', p_display_location => apex_error.c_on_error_page);
  when NO_DATA_FOUND
  then
    apex_error.add_error(p_message => 'No starting event was defined.', p_display_location => apex_error.c_on_error_page);
  end;
    
  update processes prc
     set prc.prc_current = l_obj_id
       , prc.prc_last_update = sysdate
   where prc.prc_dgm_name = l_dgm_name 
     and prc.prc_id = p_process_id
       ;
exception
  when others
  then
    raise;
end flow_start;


procedure flow_next_step
( p_process_id in processes.prc_id%type
)
is

  l_dgm_name       diagrams.dgm_name%type;
  l_con_target_ref connections.con_target_ref%type;
  l_prc_current    processes.prc_current%type;

begin
  -- get diagram name
  select prc.prc_dgm_name
    into l_dgm_name
    from processes prc
   where prc.prc_id = p_process_id
       ;
  -- get current state
  select prc.prc_current
    into l_prc_current
    from processes prc
   where prc.prc_dgm_name = l_dgm_name
     and prc.prc_id = p_process_id
       ;
    
  begin
    select con.con_target_ref
      into l_con_target_ref
      from connections con
     where con.con_source_ref = l_prc_current
       and con.con_dgm_name = l_dgm_name
         ;
        
    update processes prc
       set prc.prc_current = l_con_target_ref
         , prc.prc_last_update = sysdate
     where prc.prc_dgm_name = l_dgm_name
       and prc.prc_id = p_process_id
         ;
    
  exception
  when TOO_MANY_ROWS
  then
    apex_error.add_error(p_message => 'Branch instead of next step was found.', p_display_location => apex_error.c_on_error_page);
        
  when NO_DATA_FOUND
  then
    apex_error.add_error(p_message => 'Next step does not exist.', p_display_location => apex_error.c_on_error_page);
  end;
exception
  when others
  then
    raise;                     
end flow_next_step;


procedure flow_next_branch
( p_process_id  in processes.prc_id%type
, p_branch_name in varchar2
)
is
  l_dgm_name       diagrams.dgm_name%type;
  l_con_target_ref connections.con_target_ref%type;
  l_prc_current    processes.prc_current%type;
begin
  -- get diagram name
  select prc.prc_dgm_name
    into l_dgm_name
    from processes prc
   where prc.prc_id = p_process_id
       ;
       
  select prc.prc_current
    into l_prc_current
    from processes prc
   where prc.prc_dgm_name = l_dgm_name
     and prc.prc_id = p_process_id
       ;
    
  begin
    select con.con_target_ref
      into l_con_target_ref
      from connections con
     where con.con_source_ref = l_prc_current
       and con.con_dgm_name = l_dgm_name
       and con.con_name = p_branch_name
         ;
    update processes prc
       set prc.prc_current = l_con_target_ref
         , prc.prc_last_update = sysdate
     where prc.prc_dgm_name = l_dgm_name
       and prc.prc_id = p_process_id
         ;
        
  exception
  when NO_DATA_FOUND 
  then
    apex_error.add_error(p_message => 'No branch was found.', p_display_location => apex_error.c_on_error_page);
  end;
exception
  when others
  then
    raise;
end flow_next_branch;


procedure flow_reset
( p_process_id in processes.prc_id%type
)
is
begin
  update processes prc
     set prc.prc_current = null
       , prc.prc_last_update = sysdate
   where prc.prc_id = p_process_id
       ;
exception
  when others
  then
    raise;
end flow_reset;
procedure flow_delete
( p_process_id in processes.prc_id%type
)
is
begin
  delete
    from processes prc
   where prc.prc_id = p_process_id
       ;
exception
  when others
  then
    raise;
end flow_delete;


procedure flow_parse
( p_diagram_name  in diagrams.dgm_name%type
, p_flow_string   in varchar2
, p_object_string in varchar2
)
is

  v_count NUMBER;
  v_clob CLOB;

  v_flowString varchar2(4000);
  v_objectString varchar2(4000);
   
  l_flowArray apex_t_varchar2;
  l_objectArray apex_t_varchar2;
    
  l_data varchar2(1000);
  l_data_id varchar2(50);
  l_data_name varchar2(200);
  l_data_source_ref varchar2(50);
  l_data_target_ref varchar2(50);
    
  v_firstComma number;
  v_secondComma number;
  v_thirdComma number;

begin
    /***** save diagram *****/
    select count(*)
      into v_count
      from diagrams
     where dgm_name = p_diagram_name
         ;
    
    select clob001
      into v_clob
      from apex_collections
     where collection_name = 'CLOB_CONTENT'
         ;
    
    if v_count = 0
    then    
      insert
        into diagrams(dgm_name, dgm_content)
      values(p_diagram_name, v_clob)
      ;
    
    elsif v_count > 0
    then
      update diagrams
         set dgm_content = v_clob
       where dgm_name = p_diagram_name
      ;
    end if;
    
    /***** save objects & connections *****/
    v_flowString := p_flow_string;
    v_objectString := p_object_string;

    l_flowArray := apex_string.split(p_str => v_flowString, p_sep => '|');
    l_objectArray := apex_string.split(p_str => v_objectString, p_sep => '|');
    
    delete from CONNECTIONS where CON_DGM_NAME = p_diagram_name;
    delete from OBJECTS where OBJ_DGM_NAME = p_diagram_name;
    
    for i in 1 .. l_objectArray.count
    loop
      l_data := apex_string.format(l_objectArray(i));
        
      v_firstComma := instr(l_data, ',', 1, 1);
      v_secondComma := instr(l_data, ',', 1, 2);
      v_thirdComma := instr(l_data, ',', 1, 3);
        
      l_data_id := substr(l_data, 1, v_firstComma-1);
      l_data_name := substr(l_data, v_firstComma+1, v_secondComma-v_firstComma-1);
      l_data_source_ref := substr(l_data, v_secondComma+1, v_thirdComma-v_secondComma-1);
      l_data_target_ref := substr(l_data, v_thirdComma+1);        
        
      insert
        into objects (obj_id, obj_name, obj_dgm_name)
      values (l_data_id, l_data_name, p_diagram_name)
           ;
    end loop;

    for i in 1 .. l_flowArray.count
    loop
      l_data:= apex_string.format(l_flowArray(i));
      v_firstComma:= instr(l_data, ',', 1, 1);
      v_secondComma:= instr(l_data, ',', 1, 2);
      v_thirdComma:= instr(l_data, ',', 1, 3);
      l_data_id := substr(l_data, 1, v_firstComma-1);
      l_data_name := substr(l_data, v_firstComma+1, v_secondComma-v_firstComma-1);
      l_data_source_ref := substr(l_data, v_secondComma+1, v_thirdComma-v_secondComma-1);
      l_data_target_ref := substr(l_data, v_thirdComma+1);        
        
      insert
        into connections (con_id, con_name, con_source_ref, con_target_ref, con_dgm_name)
      values (l_data_id, l_data_name, l_data_source_ref, l_data_target_ref, p_diagram_name)
      ;
    end loop;
    
    -- delete annotations as they are not part of the flow
    delete
      from objects
     where obj_id like 'TextAnnotation%'
       and obj_dgm_name = p_diagram_name
         ;

exception
  when others
  then
    raise;
end flow_parse;

end flows_pkg;
/
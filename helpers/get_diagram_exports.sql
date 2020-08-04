/*
  Exports all Diagram sources for script load.
  Enable serveroutput before running this script.
*/

declare
  l_split   apex_t_varchar2;
begin

  for rec in (
  select dgrm_name
       , dgrm_content
    from flow_diagrams
  ) loop
  
    -- Splits at Linefeed or when max varchar2 size reached
    l_split := apex_string.split( p_str => rec.dgrm_content );

    dbms_output.put_line('PROMPT >> Loading Example "' || rec.dgrm_name || '"');    
    dbms_output.put_line('begin');
    
    dbms_output.put_line('insert into flow_diagrams( dgrm_name, dgrm_content)');
    dbms_output.put_line(' values (');
    dbms_output.put_line('''' || rec.dgrm_name || ''',');
    dbms_output.put_line('apex_string.join_clob(');
    dbms_output.put_line('  apex_t_varchar2(');
    
    for i in 1..l_split.count loop
      if i = 1 then
        dbms_output.put_line('  ''' || l_split(i) || '''');
      else
        dbms_output.put_line('  , ''' || l_split(i) || '''');
      end if;
    end loop;
    dbms_output.put_line('  )');
    dbms_output.put_line('));');
    dbms_output.put_line('commit;');
    dbms_output.put_line('end;');
    dbms_output.put_line('/');
    dbms_output.put_line( ' ' );
    dbms_output.put_line('PROMPT >> Example "' || rec.dgrm_name ||'" loaded.');
    dbms_output.put_line('PROMPT >> ========================================================');
    dbms_output.put_line( ' ' );
  end loop;

end;
/

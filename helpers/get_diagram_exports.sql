/*
  Exports all Diagram sources for script load.
  Enable serveroutput before running this script.
*/

set serveroutput on size unlimited

declare
  l_split   apex_t_varchar2;
begin
  sys.dbms_output.put_line('set define off');
  sys.dbms_output.put_line('PROMPT >> Loading Exported Diagrams');
  for rec in ( select dgrm_name
                    , dgrm_content
                    , dgrm_version
                    , dgrm_category
                    , dgrm_last_update
                 from flow_diagrams
                where dgrm_content is not null
             )
  loop
    begin
      -- Splits at Linefeed or when max varchar2 size reached
      l_split := apex_string.split( p_str => rec.dgrm_content );

      sys.dbms_output.put_line('PROMPT >> Loading Example "' || rec.dgrm_name || '"');    
      sys.dbms_output.put_line('begin');
      
      sys.dbms_output.put_line( 'insert into flow_diagrams( dgrm_name, dgrm_version, dgrm_category, dgrm_last_update, dgrm_content )' );
      sys.dbms_output.put_line( ' values (' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(rec.dgrm_name) || ',' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(rec.dgrm_version) || ',' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(rec.dgrm_category) || ',' );
      sys.dbms_output.put_line( 'TIMESTAMP ' || dbms_assert.enquote_literal(to_char( rec.dgrm_last_update, 'yyyy-mm-dd hh24:mi:ssxff TZH:TZM', 'NLS_NUMERIC_CHARACTERS = ''.,''' )) || ',' );
      sys.dbms_output.put_line( 'apex_string.join_clob(' );
      sys.dbms_output.put_line( '  apex_t_varchar2(' );
    
      for i in 1..l_split.count loop
        if i = 1 then
          sys.dbms_output.put_line('  q''[' || l_split(i) || ']''');
        else
          sys.dbms_output.put_line('  , q''[' || l_split(i) || ']''');
        end if;
      end loop;
      sys.dbms_output.put_line('  )');
      sys.dbms_output.put_line('));');
      sys.dbms_output.put_line('commit;');
      sys.dbms_output.put_line('end;');
      sys.dbms_output.put_line('/');
      sys.dbms_output.put_line( ' ' );
      sys.dbms_output.put_line('PROMPT >> Example "' || rec.dgrm_name || ' - v' || rec.dgrm_version || '" loaded.');
      sys.dbms_output.put_line('PROMPT >> ========================================================');
      sys.dbms_output.put_line( ' ' );
    exception
      when value_error then
        sys.dbms_output.put_line( 'WARNING >> Export of Diagram ' || rec.dgrm_name || ' failed. Export manually.' );
    end;
  end loop;

end;
/

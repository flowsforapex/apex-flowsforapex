/*
  Exports all Flows for APEX messages for script load.
  Enable serveroutput before running this script.
*/

set serveroutput on size unlimited
set define '^'
set concat '.'

ACCEPT lang_name char default 'en' PROMPT 'Enteer Language to export: [en]'


begin
  sys.dbms_output.put_line('PROMPT >> Loading Exported Messages');

  sys.dbms_output.put_line('begin');

  for msg in ( select fmsg_message_key
                    , fmsg_lang
                    , fmsg_message_content
                 from flow_messages
                where fmsg_lang = '^lang_name.'
                order by fmsg_lang, fmsg_message_key
             )
  loop
    begin
      
      sys.dbms_output.put_line( 'insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )' );
      sys.dbms_output.put_line( ' values (' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(msg.fmsg_message_key) || ',' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(msg.fmsg_lang) || ',' );
      sys.dbms_output.put_line( dbms_assert.enquote_literal(msg.fmsg_message_content)) ;
      sys.dbms_output.put_line( ');' );
      sys.dbms_output.put_line(' ');
    exception
      when value_error then
        sys.dbms_output.put_line( 'WARNING >> Export of Message ' || msg.fmsg_message_key || ' failed. Export manually.' );
    end;
  end loop;
  sys.dbms_output.put_line( ' ');
  sys.dbms_output.put_line( ' ');
  sys.dbms_output.put_line('commit;');

  sys.dbms_output.put_line('end;');
  sys.dbms_output.put_line('/');
end;
/

/*
  Remove all objects with prefix FLOWS_ from current schema.
  !! USE WITH CAUTION !!
*/

PROMPT >> Removing Packages

begin

  for rec in ( select object_name from user_objects where object_type = 'PACKAGE' and object_name like 'FLOW\_%' escape '\' )
  loop
    execute immediate 'drop package ' || rec.object_name;
  end loop;
  
end;
/


PROMPT >> Removing Views
begin
  for rec in ( select view_name from user_views where view_name like 'FLOW\_%' escape '\' )
  loop
    execute immediate 'drop view ' || rec.view_name;
  end loop;
end;
/

PROMPT >> Removing Tables
begin
  for rec in ( select table_name from user_tables where table_name like 'FLOW\_%' escape '\' )
  loop
    execute immediate 'drop table ' || rec.table_name || ' cascade constraints';
  end loop;
end;
/

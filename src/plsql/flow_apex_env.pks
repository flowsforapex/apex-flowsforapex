declare
  lf  varchar2(1) := chr(10);
  vr  number;
  v   number;
  r   number;
  blk varchar(4000);

  procedure add_line ( p_line in varchar2 ) is
  begin
    blk := blk || case when blk is not null then lf end || p_line;
  end;

  function add_bool ( p_current_version in number, p_a_version in number ) return varchar2 is
  begin
    return case when p_current_version <= p_a_version then 'true' else 'false' end;
  end; 
begin
  select to_number(substr(version_no, 1, instr(version_no, '.', 1, 2) - 1), '99D9','NLS_NUMERIC_CHARACTERS=''.,''')
       , to_number(substr(version_no, 1, instr(version_no, '.', 1, 1) - 1))
       , to_number(substr(version_no, instr(version_no, '.', 1, 1) + 1, instr(version_no, '.', 1, 1) - 2))
    into vr
       , v
       , r
    from apex_release
  ;

  add_line( 'create or replace package flow_apex_env authid definer is' );
  add_line( '  version     constant pls_integer := ' || v || ';' );
  add_line( '  release     constant pls_integer := ' || r || ';' );
  add_line( '  ee          constant boolean := false;');
   
  for yr in 19..v+5 loop
    add_line('  ver_le_' || yr || '   constant boolean     := ' || add_bool(trunc(vr), yr    ) || ';');
    add_line('  ver_le_' || yr || '_1 constant boolean     := ' || add_bool(vr       , yr +.1) || ';');
    add_line('  ver_le_' || yr || '_2 constant boolean     := ' || add_bool(vr       , yr +.2) || ';');
  end loop;
   
  add_line('end;');
   
  execute immediate blk;
end;
/

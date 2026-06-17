/*
Upgrades the APEX version enviroment and recompiles all PL/SQL packages
Run this after an APEX version upgrade
*/

PROMPT >> Update Flows for APEX after an APEX Version Change
PROMPT >> =================
PROMPT >> Upgrading APEX Version Info
declare
  lf  varchar2(1) := chr(10);
  vr  number;
  v   number;
  r   number;
  blk varchar(4000);
  l_ee_flag varchar2(5 char) := 'false';

  procedure add_line ( p_line in varchar2 ) is
  begin
    blk := blk || case when blk is not null then lf end || p_line;
  end;

  function add_bool ( p_current_version in number, p_a_version in number ) return varchar2 is
  begin
    return case when p_current_version <= p_a_version then 'true' else 'false' end;
  end; 

begin
  begin
    l_ee_flag := case 
                 when flow_apex_env.ee then 'true' 
                 else 'false' 
                 end; 
  exception
    when others then
      l_ee_flag := 'false';
  end;

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
  add_line( '  ee          constant boolean := ' || l_ee_flag || ';');
   
  for yr in 19..v+4 loop
    add_line('  ver_le_' || yr || '   constant boolean     := ' || add_bool(trunc(vr), yr    ) || ';');
    add_line('  ver_le_' || yr || '_1 constant boolean     := ' || add_bool(vr       , yr +.1) || ';');
    add_line('  ver_le_' || yr || '_2 constant boolean     := ' || add_bool(vr       , yr +.2) || ';');
  end loop;
   
  add_line('end;');
   
  execute immediate blk;
end;
/

PROMPT >> Recompiling Package Specifications
PROMPT >>
PROMPT >> Recompiling FLOW_% and TEST_% package specifications
declare
  procedure compile_spec (p_package_name in varchar2) is
  begin
    execute immediate 'alter package ' || p_package_name || ' compile specification';
  exception
    when others then
      dbms_output.put_line('Failed to compile package specification ' || p_package_name || ': ' || sqlerrm);
  end compile_spec;
begin
  -- mandatory order for environment/type constants
  compile_spec('FLOW_APEX_ENV');
  compile_spec('FLOW_TYPES_PKG');
  compile_spec('FLOW_CONSTANTS_PKG');

  -- compile remaining target package specifications alphabetically
  for r_pkg in (
    select object_name
      from user_objects
     where object_type = 'PACKAGE'
       and (object_name like 'FLOW%' or object_name like 'TEST%')
       and object_name not in ('FLOW_APEX_ENV', 'FLOW_TYPES_PKG', 'FLOW_CONSTANTS_PKG')
     order by object_name
  ) loop
    compile_spec(r_pkg.object_name);
  end loop;
end;
/

PROMPT >> Recompiling FLOW_% and TEST_% package bodies
declare
  procedure compile_body (p_package_name in varchar2) is
  begin
    execute immediate 'alter package ' || p_package_name || ' compile body';
  exception
    when others then
      dbms_output.put_line('Failed to compile package body ' || p_package_name || ': ' || sqlerrm);
  end compile_body;
begin
  for r_pkg in (
    select object_name
      from user_objects
     where object_type = 'PACKAGE BODY'
       and (object_name like 'FLOW%' or object_name like 'TEST%')
     order by object_name
  ) loop
    compile_body(r_pkg.object_name);
  end loop;
end;
/

PROMPT >> Flows for APEX Packages recompiled
PROMPT >> =============================

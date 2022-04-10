
-- varchar2 variable smoke test

-- set a variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstVC2'
, pi_vc2_value => 'MyFirstVC2value'
);
end;

-- update the variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstVC2'
, pi_vc2_value => 'UpdatedMyFirstVC2value'
);
end;

-- set another variable without specifying scope (should default to scope 0)

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2VC2'
, pi_vc2_value => 'Test2VC2value'
);
end;

-- update the variable - happy case - providing scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'Test2VC2'
, pi_vc2_value => 'UpdatedTest2VC2value'
);
end;

-- update the variable - happy case - defaulting scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2VC2'
, pi_vc2_value => 'UpdatedAgainTest2VC2value'
);
end;

-- repeat for num typed variables

-- set a variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstNum'
, pi_num_value => 1
);
end;

-- update the variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstNum'
, pi_num_value => 2
);
end;

-- set another variable without specifying scope (should default to scope 0)

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2Num'
, pi_num_value => 10
);
end;

-- update the variable - happy case - providing scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'Test2Num'
, pi_num_value => 11
);
end;

-- update the variable - happy case - defaulting scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2Num'
, pi_num_value => 12
);
end;

-- repeat for date typed variables

-- set a variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstDate'
, pi_date_value => to_date( '01-JAN-2022', 'DD-MON-YYYY'));
end;

-- update the variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstDate'
, pi_date_value => to_date( '11-JAN-2022', 'DD-MON-YYYY'));
end;

-- set another variable without specifying scope (should default to scope 0)

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2Date'
, pi_date_value => to_date( '21-JAN-2022', 'DD-MON-YYYY')
);
end;

-- update the variable - happy case - providing scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'Test2Date'
, pi_date_value => to_date( '22-JAN-2022', 'DD-MON-YYYY')
);
end;

-- update the variable - happy case - defaulting scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2Date'
, pi_date_value => to_date( '23-JAN-2022', 'DD-MON-YYYY')
);
end;

-- repeat for CLOB typed variables

-- set a variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstCLOB'
, pi_clob_value => 'MyFirstCLOBValue'
);
end;

-- update the variable - happy case

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstCLOB'
, pi_clob_value => 'EdittedMyFirstCLOBValue'
);
end;

-- set another variable without specifying scope (should default to scope 0)

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2CLOB'
, pi_clob_value => 'MyBigCLOBv1'
);
end;

-- update the variable - happy case - providing scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'Test2CLOB'
, pi_clob_value => 'MyBigCLOBv2'
);
end;

-- update the variable - happy case - defaulting scope

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_var_name => 'Test2CLOB'
, pi_clob_value => 'MyBigCLOBv3'
);
end;

-----------------------------------------------------------------------
--
--  Getters
--
-----------------------------------------------------------------------


---------------- varchar2 type

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstVC2'
, pi_vc2_value => 'MyFirstVC2value'
);
end;

declare
  l_vc2 varchar2(50);
begin
  l_vc2 := flow_process_vars.get_var_vc2
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstVC2'
              );
  dbms_output.put_line ( l_vc2 );

end;


declare
  l_vc2 varchar2(50);
begin
  l_vc2 := flow_process_vars.get_var_vc2
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstVC2'
              , pi_scope => 0
              );
  dbms_output.put_line ( l_vc2 );

end;


declare
  l_vc2 varchar2(50);
begin
  l_vc2 := flow_process_vars.get_var_vc2
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstVC2'
              , pi_sbfl_id =>240
              );
  dbms_output.put_line ( l_vc2 );

end;

declare
  l_vc2 varchar2(50);
begin
  l_vc2 := flow_process_vars.get_var_vc2
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstVC2'
              , pi_sbfl_id =>270    --- invalid subflow_id - will throw error
              );
  dbms_output.put_line ( l_vc2 );

end;

------------------  Number Type

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstNum'
, pi_num_value => 42
);
end;

declare
  l_num number;
begin
  l_num := flow_process_vars.get_var_num
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstNum'
              );
  dbms_output.put_line ( l_vc2 );

end;


declare
 l_num number;
begin
  l_num := flow_process_vars.get_var_num
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstNum'
              , pi_scope => 0
              );
  dbms_output.put_line ( l_num );

end;


declare
  l_num number;
begin
  l_num := flow_process_vars.get_var_num
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstNum'
              , pi_sbfl_id =>240
              );
  dbms_output.put_line ( l_num );

end;

declare
  l_num number;
begin
  l_num := flow_process_vars.get_var_num
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstNum'
              , pi_sbfl_id =>270      --- invalid subflow_id - will throw error
              );
  dbms_output.put_line ( l_num );

end;

------------------  Date Type  

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstDate'
, pi_date_value => to_date( '01-JAN-2022', 'DD-MON-YYYY')
);
end;

declare
  l_date date;
begin
  l_date := flow_process_vars.get_var_date
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              );
  dbms_output.put_line ( to_char(l_date,'DD-MON-YYYY') );

end;


declare
 l_date date;
begin
  l_date := flow_process_vars.get_var_date
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_scope => 0
              );
  dbms_output.put_line ( to_char(l_date,'DD-MON-YYYY') );

end;


declare
  l_date date;
begin
  l_date := flow_process_vars.get_var_date
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_sbfl_id =>240
              );
  dbms_output.put_line ( to_char(l_date,'DD-MON-YYYY') );

end;

declare
  l_date date;
begin
  l_date := flow_process_vars.get_var_date
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_sbfl_id =>270    --- invalid subflow_id - will throw error
              );
  dbms_output.put_line ( to_char(l_date,'DD-MON-YYYY') );

end;

------------------  CLOB Type  

begin 
flow_process_vars.set_var
( pi_prcs_id => 25
, pi_scope => 0
, pi_var_name => 'MyFirstDate'
, pi_clob_value => 'MyFirstCLOBValue'
);
end;

declare
  l_clob clob;
begin
  l_clob := flow_process_vars.get_var_clob
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              );
  dbms_output.put_line ( l_clob );

end;


declare
 l_clob clob;
begin
  l_clob := flow_process_vars.get_var_clob
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_scope => 0
              );
  dbms_output.put_line ( l_clob );

end;


declare
  l_clob clob;
begin
  l_clob := flow_process_vars.get_var_clob
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_sbfl_id =>240
              );
  dbms_output.put_line ( l_clob );

end;

declare
  l_clob clob;
begin
  l_clob := flow_process_vars.get_var_clob
              ( pi_prcs_id => 25
              , pi_var_name => 'MyFirstDate'
              , pi_sbfl_id =>270    --- invalid subflow_id - will throw error
              );
  dbms_output.put_line ( l_clob );

end;


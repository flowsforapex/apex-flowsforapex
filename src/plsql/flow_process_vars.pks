/* 
-- Flows for APEX - flow_process_vars.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 22-SEP-2020  Richard Allen (Flowquest) 
-- Edited  13-APR-2022 - Richard Allen (Oracle)
--
*/
/*
**
**        PROCESS VARIABLE SYSTEM (get / set / etc)
**        Process Variable System API for Application Developers
**
*/ 
 
create or replace package flow_process_vars
  authid definer
as 
/**
PROCESS VARIABLE SYSTEM API
===========================

The `flow_process_vars` package give you access to be able to set and get Process Variables making up the Flows for APEX Process Variable System.help

**/

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type         -- Value of variable (VARCHAR2)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0 
);
/**
SIGNATURE 1a - VARCHAR2 - Using Scope.

This procedure is used to set a VARCHAR2 value of a process variable using a supplied scope (defaulting to 0, the top level scope) 

EXAMPLE

This example will set the value of the process variable "MY_VAR" to "MY_VAR_VALUE" in the process instance ID 1 in scope 0.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id   => 1
      , pi_var_name  => 'MY_VAR'
      , pi_scope     => 0
      , pi_vc2_value => 'MY_VAR_VALUE'
   );
end;
```
**/

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type   -- Value of variable (VARCHAR2)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
/**
SIGNATURE 1b - VARCHAR2 - Using Subflow_id.

This procedure is used to set a VARCHAR2 value of a process variable, using the current `subflow_id` to set the correct scope.   This will look up the current scope for this subflow, before setting the process variable.

EXAMPLE

This example will set the value of the process variable "MY_VAR" to "MY_VAR_VALUE" in the process instance ID 1, with a scope used in subflow 12.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id   => 1
      , pi_var_name  => 'MY_VAR'
      , pi_sbfl_id   => 12
      , pi_vc2_value => 'MY_VAR_VALUE'
   );
end;
```

**/
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_num_value  in flow_process_variables.prov_var_num%type          -- Value of variable (NUMBER)
, pi_scope      in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
);
/**
SIGNATURE 2a - NUMBER - Using Scope.

This procedure is used to set a NUMBER value of a process variable using a supplied scope (defaulting to 0, the top level scope) 

EXAMPLE

This example will set the value of the process variable "MY_VAR" to 1234 in the process instance ID 1 in scope 0.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id   => 1
      , pi_var_name  => 'MY_VAR'
      , pi_scope     => 0
      , pi_num_value => 1234
   );
end;
```
**/

procedure set_var
( pi_prcs_id   in flow_processes.prcs_id%type               -- Process ID
, pi_var_name  in flow_process_variables.prov_var_name%type -- Name of the process variable
, pi_num_value in flow_process_variables.prov_var_num%type  -- Value of the variable (NUMBER)
, pi_sbfl_id   in flow_subflows.sbfl_id%type                -- Subflow ID, used to set scope
);
/**
SIGNATURE 2b - NUMBER - Using Subflow_id.

This procedure is used to set a NUMBER value of a process variable using a supplied using the current `subflow_id` to set the correct scope.   This will look up the current scope for this subflow, before setting the process variable.

EXAMPLE

This example will set the value of the process variable "MY_VAR" to 1234 in the process instance ID 1, with a scope used in subflow 12.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id   => 1
      , pi_var_name  => 'MY_VAR'
      , pi_sbfl_id   => 12
      , pi_num_value => 1234
   );
end;
```
**/

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_date_value in flow_process_variables.prov_var_date%type        -- Value of the variable (DATE)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0
);
/**
SIGNATURE 3a - DATE - Using Scope.

This procedure is used to set a DATE value of a process variable using a supplied scope (defaulting to 0, the top level scope) 

EXAMPLE

This example will set the value of the process variable "MY_DATE" to the current date, sysdate, in the process instance ID 1 in scope 0.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id    => 1
      , pi_var_name   => 'MY_DATE'
      , pi_scope      => 0
      , pi_date_value => sysdate
   );
end;
```
**/


procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_date_value in flow_process_variables.prov_var_date%type  -- Value of the variable (DATE)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
/**
SIGNATURE 3b - DATE - Using Subflow_id.

This procedure is used to set a DATE value of a process variable usingthe current `subflow_id` to set the correct scope.   This will look up the current scope for this subflow, before setting the process variable.

EXAMPLE

This example will set the value of the process variable "MY_DATE" to the current date, sysdate, in the process instance ID 1, with a scope used in subflow 12.
```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id    => 1
      , pi_var_name   => 'MY_DATE'
      , pi_sbfl_id    => 1
      , pi_date_value => sysdate
   );
end;
```
**/
  
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_clob_value in flow_process_variables.prov_var_clob%type        -- Value of the variable (CLOB)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0
);
/**
SIGNATURE 4a - CLOB - Using Scope.

This procedure is used to set a CLOB value of a process variable using a supplied scope (defaulting to 0, the top level scope) 

EXAMPLE

This example will set the value of the process variable "MY_CLOB" to the CLOB provided for the process instance ID 1 in scope 0.

```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id    => 1
      , pi_var_name   => 'MY_CLOB'
      , pi_scope      => 0
      , pi_clob_value => to_clob('This is a long text')
   );
end;
```
**/

procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_clob_value in flow_process_variables.prov_var_clob%type  -- Value of the variable (CLOB)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
/**
SIGNATURE 4b - CLOB - Using Subflow_id.

This procedure is used to set a CLOB value of a process variable usingthe current `subflow_id` to set the correct scope.   This will look up the current scope for this subflow, before setting the process variable.

EXAMPLE

This example will set the value of the process variable "MY_CLOB" to the CLOB provided in the process instance ID 1, with a scope used in subflow 12.
```sql
begin
   flow_process_vars.set_var(
        pi_prcs_id    => 1
      , pi_var_name   => 'MY_CLOB'
      , pi_sbfl_id    => 12
      , pi_clob_value => to_clob('This is a long text')
   );
end;
```
**/

-- getters return

-- get_var_vc2:  varchar2 type - SIGNATURE 1

function get_var_vc2
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID 
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_vc2%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the value of a VARCHAR2 process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR" in the main diagram scope.

```sql
declare
   l_value flow_process_variables.prov_var_vc2%type;
begin
   l_value := flow_process_vars.get_var_vc2(
                   pi_prcs_id   => 1
                 , pi_scope     => 0
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/


function get_var_vc2
( pi_prcs_id           in flow_processes.prcs_id%type                -- Process ID 
, pi_var_name          in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                      -- If true, return an exception if null
) return flow_process_variables.prov_var_vc2%type;
/**
SIGNATURE 2 - Using Subflow_id

This function is used to get the value of a VARCHAR2 process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR", in the scope used in subflow 12.

```sql
declare
   l_value flow_process_variables.prov_var_vc2%type;
begin
   l_value := flow_process_vars.get_var_vc2(
                   pi_prcs_id   => 1
                 , pi_sbfl_id   => 12
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/

function get_var_num
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_num%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the value of a NUMBER process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR" in the main diagram scope.

```sql
declare
   l_value flow_process_variables.prov_var_num%type;
begin
   l_value := flow_process_vars.get_var_num(
                   pi_prcs_id   => 1
                 , pi_scope     => 0
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type                    -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type     -- Name of the process variable
, pi_sbfl_id in flow_subflows.sbfl_id%type                     -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                -- If true, return an exception if null
) return flow_process_variables.prov_var_num%type;
/**
SIGNATURE 2 - Using Subflow_id.

This function is used to get the value of a NUMBER process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR", in the scope used in subflow 12.

```sql
declare
   l_value flow_process_variables.prov_var_num%type;
begin
   l_value := flow_process_vars.get_var_num(
                   pi_prcs_id   => 1
                 , pi_sbfl_id   => 12
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/


function get_var_date
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_date%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the value of a DATE process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR" in the main diagram scope.

```sql
declare
   l_value flow_process_variables.prov_var_date%type;
begin
   l_value := flow_process_vars.get_var_date(
                   pi_prcs_id   => 1
                 , pi_scope     => 0
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/

function get_var_date
( pi_prcs_id           in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                       -- If true, return an exception if null
) return flow_process_variables.prov_var_date%type;
/**
SIGNATURE 2 - Using Subflow_id.

This function is used to get the value of a DATE process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR", in the scope used in subflow 12.


```sql
declare
   l_value flow_process_variables.prov_var_date%type;
begin
   l_value := flow_process_vars.get_var_date(
                   pi_prcs_id   => 1
                 , pi_sbfl_id   => 12
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/


function get_var_clob
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_clob%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the value of a CLOB process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR" in the main diagram scope.

```sql
declare
   l_value flow_process_variables.prov_var_clob%type;
begin
   l_value := flow_process_vars.get_var_clob(
                   pi_prcs_id   => 1
                 , pi_scope     => 0
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/


function get_var_clob
( pi_prcs_id           in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                       -- If true, return an exception if null
) return flow_process_variables.prov_var_clob%type;
/**
SIGNATURE 2 - Using Subflow_id.

This function is used to get the value of a CLOB process variable.

EXAMPLE

This example will get the value of the process variable "MY_VAR", in the scope used in subflow 12.

```sql
declare
   l_value flow_process_variables.prov_var_clob%type;
begin
   l_value := flow_process_vars.get_var_clob(
                   pi_prcs_id   => 1
                 , pi_sbfl_id   => 12
                 , pi_var_name  => 'MY_VAR'
              );
end;
```
**/
function get_var_type
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_type%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the type of the given process variable, using scope to explicitly identify the variable. If not supplied, the scope defaults to scope 0, the top level for this process instance.

EXAMPLE 

This example will get the type of the process variable "MY_VARIABLE" in process instance ID 1.
```sql
declare
   l_prov_var_type flow_process_variables.prov_var_type%type;
begin
   l_prov_var_type := flow_process_vars.get_var_type( 
        pi_prcs_id   => 1 
      , pi_scope     => 0
      , pi_var_name => 'MY_VARIABLE'
   );
end;
```

**/

function get_var_type
( pi_prcs_id           in flow_processes.prcs_id%type                -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                      -- If true, return an exception if null
) return flow_process_variables.prov_var_type%type;
/**
SIGNATURE 2 - Using Subflow_id.

This function is used to get the type of the given process variable, using a `subflow ID` to identify the variable's scope. 

EXAMPLE 

This example will get the type of the process variable "MY_VARIABLE" in process instance ID 1 in the same scope as subflow 12.
```sql
declare
   l_prov_var_type flow_process_variables.prov_var_type%type;
begin
   l_prov_var_type := flow_process_vars.get_var_type( 
        pi_prcs_id   => 1 
      , pi_sbfl_id   => 12
      , pi_var_name => 'MY_VARIABLE'
   );
end;
```

**/

procedure delete_var    
( pi_prcs_id  in flow_processes.prcs_id%type                        -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type          -- Name of the process variable
, pi_scope    in flow_process_variables.prov_scope%type default 0   -- Variable Scope, defaults to 0
);
/**
SIGNATURE 1 - Using Scope

This procedure is used to delete a process variable, using scope to explicitly identify the variable. If not supplied, the scope defaults to scope 0, the top level for this process instance.

EXAMPLE 

This example will delete the process variable "MY_VAR" in process instance ID 1.
```sql
begin
   flow_process_vars.delete_var(
        pi_prcs_id   => 1
      , pi_scope     => 0
      , pi_var_name  => 'MY_VAR'
   );
end;
```

**/
-- delete_var - SIGNATURE 2 - by subflow_id

procedure delete_var
( pi_prcs_id  in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id  in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
);
/**
SIGNATURE 2 - Using Subflow_id.

This procedure is used to delete a process variable, using a `subflow ID` to identify the variable's scope. 

EXAMPLE 

This example will delete the process variable "MY_VAR" in process instance ID 1, in the scope used by subflow 12.
```sql
begin
   flow_process_vars.delete_var(
        pi_prcs_id   => 1
      , pi_sbfl_id   => 12
      , pi_var_name  => 'MY_VAR'
   );
end;
```
 **/


procedure set_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type               -- Process ID
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type  -- Business Reference (underlying PK) (VARCHAR2)
, pi_scope      in flow_subflows.sbfl_scope%type default 0   -- Variable Scope, defaults to 0
);
/**
SIGNATURE 1 - Usinfg Scope.

This function is used to set the value of the built-in BUSINESS_REF process variable in scope 0.

EXAMPLE 

This example will set the value of the process variable "BUSINESS_REFERENCE" in process instance ID 1.
```sql
begin
   flow_process_vars.set_business_ref( 
        pi_prcs_id   => 1 
      , pi_scope     => 0
      , pi_vc2_value => 'NEW_VALUE'
   );
end;
```

**/

procedure set_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type               -- Process ID
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type  -- Business Reference (underlying PK) (VARCHAR2)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                -- Subflow ID, used to set scope
);
/**
SIGNATURE 2 - Using Subflow_id.

This function is used to set the value of the built-in BUSINESS_REF process variable in scope used by the given `subflow_id`.

EXAMPLE 

This example will set the value of the process variable "BUSINESS_REFERENCE" in process instance ID 1.
```sql
begin
   flow_process_vars.set_business_ref( 
        pi_prcs_id   => 1 
      , pi_sbfl_id   => 12
      , pi_vc2_value => 'NEW_VALUE'
   );
end;
```

**/
function get_business_ref
( pi_prcs_id in flow_processes.prcs_id%type                 -- Process ID
, pi_scope   in flow_subflows.sbfl_scope%type default 0     -- Variable Scope, defaults to 0
)
return flow_process_variables.prov_var_vc2%type;
/**
SIGNATURE 1 - Using Scope.

This function is used to get the value of the built-in BUSINESS_REF process variable.

EXAMPLE 

This example will get the value of the process variable "BUSINESS_REFERENCE" in process instance ID 1 in scope 0.
```sql
declare
   l_business_ref flow_process_variables.prov_var_vc2%type;
begin
   l_business_ref := flow_process_vars.get_business_ref( pi_prcs_id => 1, pi_scope => 0);
end;
```

**/
function get_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type  -- Process ID
, pi_sbfl_id    in flow_subflows.sbfl_id%type   -- Subflow ID, used to set scope
)
return flow_process_variables.prov_var_vc2%type;
/**
SIGNATURE 2 - Using Subflow_ID.

This function is used to get the value of the built-in BUSINESS_REF process variable.

EXAMPLE 

This example will get the value of the process variable "BUSINESS_REFERENCE" in process instance ID 1 in scope 0.
```sql
declare
   l_business_ref flow_process_variables.prov_var_vc2%type;
begin
   l_business_ref := flow_process_vars.get_business_ref( pi_prcs_id => 1, pi_sbfl_id => 12);
end;
```

**/


end flow_process_vars;
/

<!-- DO NOT EDIT THIS FILE DIRECTLY - it is generated from source file src/plsql/flow_process_vars.pks -->
<!-- markdownlint-disable MD003 MD012 MD024 MD033 -->

PROCESS VARIABLE SYSTEM API
===========================

- [Package flow_process_vars](#package-flow_process_vars)
- [Procedure set_var](#procedure-set_var)
- [Procedure set_var](#procedure-set_var-1)
- [Procedure set_var](#procedure-set_var-2)
- [Procedure set_var](#procedure-set_var-3)
- [Procedure set_var](#procedure-set_var-4)
- [Procedure set_var](#procedure-set_var-5)
- [Procedure set_var](#procedure-set_var-6)
- [Procedure set_var](#procedure-set_var-7)
- [Function get_var_vc2](#function-get_var_vc2)
- [Function get_var_vc2](#function-get_var_vc2-1)
- [Function get_var_num](#function-get_var_num)
- [Function get_var_num](#function-get_var_num-1)
- [Function get_var_date](#function-get_var_date)
- [Function get_var_date](#function-get_var_date-1)
- [Function get_var_clob](#function-get_var_clob)
- [Function get_var_clob](#function-get_var_clob-1)
- [Function get_var_type](#function-get_var_type)
- [Function get_var_type](#function-get_var_type-1)
- [Procedure delete_var](#procedure-delete_var)
- [Procedure delete_var](#procedure-delete_var-1)
- [Procedure set_business_ref](#procedure-set_business_ref)
- [Procedure set_business_ref](#procedure-set_business_ref-1)
- [Function get_business_ref](#function-get_business_ref)
- [Function get_business_ref](#function-get_business_ref-1)


## Package flow_process_vars

The `flow_process_vars` package give you access to be able to set and get Process Variables making up the Flows for APEX Process Variable System.help

SIGNATURE

```sql
package flow_process_vars as
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type         -- Value of variable (VARCHAR2)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0 
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type   -- Value of variable (VARCHAR2)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_num_value  in flow_process_variables.prov_var_num%type          -- Value of variable (NUMBER)
, pi_scope      in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id   in flow_processes.prcs_id%type               -- Process ID
, pi_var_name  in flow_process_variables.prov_var_name%type -- Name of the process variable
, pi_num_value in flow_process_variables.prov_var_num%type  -- Value of the variable (NUMBER)
, pi_sbfl_id   in flow_subflows.sbfl_id%type                -- Subflow ID, used to set scope
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_date_value in flow_process_variables.prov_var_date%type        -- Value of the variable (DATE)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_date_value in flow_process_variables.prov_var_date%type  -- Value of the variable (DATE)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                      -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type        -- Name of the process variable
, pi_clob_value in flow_process_variables.prov_var_clob%type        -- Value of the variable (CLOB)
, pi_scope      in flow_process_variables.prov_scope%type default 0 -- Variable Scope, defaults to 0
);
```


## Procedure set_var

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

SIGNATURE

```sql
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type                -- Process ID
, pi_var_name   in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_clob_value in flow_process_variables.prov_var_clob%type  -- Value of the variable (CLOB)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
);
```


## Function get_var_vc2

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

SIGNATURE

```sql
function get_var_vc2
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID 
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_vc2%type;
```


## Function get_var_vc2

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

SIGNATURE

```sql
function get_var_vc2
( pi_prcs_id           in flow_processes.prcs_id%type                -- Process ID 
, pi_var_name          in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                      -- If true, return an exception if null
) return flow_process_variables.prov_var_vc2%type;
```


## Function get_var_num

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

SIGNATURE

```sql
function get_var_num
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_num%type;
```


## Function get_var_num

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

SIGNATURE

```sql
function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type                    -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type     -- Name of the process variable
, pi_sbfl_id in flow_subflows.sbfl_id%type                     -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                -- If true, return an exception if null
) return flow_process_variables.prov_var_num%type;
```


## Function get_var_date

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

SIGNATURE

```sql
function get_var_date
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_date%type;
```


## Function get_var_date

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

SIGNATURE

```sql
function get_var_date
( pi_prcs_id           in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                       -- If true, return an exception if null
) return flow_process_variables.prov_var_date%type;
```


## Function get_var_clob

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

SIGNATURE

```sql
function get_var_clob
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_clob%type;
```


## Function get_var_clob

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

SIGNATURE

```sql
function get_var_clob
( pi_prcs_id           in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                       -- If true, return an exception if null
) return flow_process_variables.prov_var_clob%type;
```


## Function get_var_type

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

SIGNATURE

```sql
function get_var_type
( pi_prcs_id           in flow_processes.prcs_id%type                       -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type         -- Name of the process variable
, pi_scope             in flow_process_variables.prov_scope%type default 0  -- Variable Scope, defaults to 0
, pi_exception_on_null in boolean default false                             -- If true, return an exception if null
) return flow_process_variables.prov_var_type%type;
```


## Function get_var_type

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

SIGNATURE

```sql
function get_var_type
( pi_prcs_id           in flow_processes.prcs_id%type                -- Process ID
, pi_var_name          in flow_process_variables.prov_var_name%type  -- Name of the process variable
, pi_sbfl_id           in flow_subflows.sbfl_id%type                 -- Subflow ID, used to set scope
, pi_exception_on_null in boolean default false                      -- If true, return an exception if null
) return flow_process_variables.prov_var_type%type;
```


## Procedure delete_var

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

SIGNATURE

```sql
procedure delete_var    
( pi_prcs_id  in flow_processes.prcs_id%type                        -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type          -- Name of the process variable
, pi_scope    in flow_process_variables.prov_scope%type default 0   -- Variable Scope, defaults to 0
);
```


## Procedure delete_var

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

SIGNATURE

```sql
procedure delete_var
( pi_prcs_id  in flow_processes.prcs_id%type                 -- Process ID
, pi_var_name in flow_process_variables.prov_var_name%type   -- Name of the process variable
, pi_sbfl_id  in flow_subflows.sbfl_id%type                  -- Subflow ID, used to set scope
);
```


## Procedure set_business_ref

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

SIGNATURE

```sql
procedure set_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type               -- Process ID
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type  -- Business Reference (underlying PK) (VARCHAR2)
, pi_scope      in flow_subflows.sbfl_scope%type default 0   -- Variable Scope, defaults to 0
);
```


## Procedure set_business_ref

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

SIGNATURE

```sql
procedure set_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type               -- Process ID
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type  -- Business Reference (underlying PK) (VARCHAR2)
, pi_sbfl_id    in flow_subflows.sbfl_id%type                -- Subflow ID, used to set scope
);
```


## Function get_business_ref

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

SIGNATURE

```sql
function get_business_ref
( pi_prcs_id in flow_processes.prcs_id%type                 -- Process ID
, pi_scope   in flow_subflows.sbfl_scope%type default 0     -- Variable Scope, defaults to 0
)
return flow_process_variables.prov_var_vc2%type;
```


## Function get_business_ref

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

SIGNATURE

```sql
function get_business_ref
( pi_prcs_id    in flow_processes.prcs_id%type  -- Process ID
, pi_sbfl_id    in flow_subflows.sbfl_id%type   -- Subflow ID, used to set scope
)
return flow_process_variables.prov_var_vc2%type;
```


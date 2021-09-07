# Declarative Process Variable Expressions

### Introduction

Declarative Process Variable Expressions is a new feature in Flows for APEX v21.1.

Declarative Process variable expressions allow you to define one or more process variable assignments to be made before and after each instance step is executed.  This allows you to set up process variables, record process state, lookup values from the database, and otherwise set and process Process Variables as your instance steps through its Flow model.

Process Variable Expressions are defined in the Flow Modeler, and processed in the Flow Engine as the Instance progresses.

### Expression Types

#### 1. Static

Static assignment allows you to set a variable with a static value supplied in the model.

Data-types Supported:  varchar2, number, date, clob

Substitutions Allowed: The static string can contain Flows for APEX substitution variables, including `&F4A$process_id.`, `&F4A$subflow_id.`, `&F4A$<process_var_name>.`

Format issues:

- Static values supplied for number type variables must be character strings in a format that will convert into an Oracle number field using a standard Oracle  to_number conversion.
- Static values supplied for date type variables must be character strings that comply to the Oracle format mask 'YYYY-MM-DD HH24:MI:SS'.

#### 2. Copy of Process Variable

Copy of Process Variable allows you to set a variable to the current contents of another Process Variable.

Data-types Supported:  varchar2, number, date, clob

Substitutions Allowed:  none

Format issues: None.  Process Variables are copied in-type from the source prrocess variable to the destination process variable.

#### 3. SQL Returning Single Value

Static assignment allows you to set a variable from the result of a SQL query returning one row.

Data-types Supported:  varchar2, number, date

Substitutions Allowed: The query definition can contain Flows for APEX substitution variables, including `&F4A$process_id.`, `&F4A$subflow_id.`, `&F4A$<process_var_name>.`

Format issues:  The query must return a value of the correct type to match the variable.

Example:

1. Variable King_Job defined as varchar2 with SQL query as select job from emp where ename = 'KING';  creates a varchar2 variable with content PRESIDENT.

#### 4. SQL Returning Delimited List

SQL Returning Multiple Values allows you to set a variable as a delimited list of multiple values.  The delimiter is ':' (colon).

Data-types Supported:  varchar2 only

Substitutions Allowed: The static string can contain Flows for APEX substitution variables, including `&F4A$process_id.`, `&F4A$subflow_id.`, `&F4A$<process_var_name.`

Format issues:  The query must return one or more varchar2 values, which will be concatenated using ':' (colon) separators into a single varchar2 process variable.

Example:

1. Variable Sales_staff defined as select ename from emp where deptno = 30 creates a variable Sales-staff of type varchar2 with content BLAKE:ALLEN:WARD:MARTIN:TURNER:JAMES

#### 5. Expression

Expression allows you to set a variable to the result of a PL/SQL expression clause.  The PL/SQL expression must return a string of type varchar2.  If the variable is a number or a date, this string must convert to an Oracle number or to a date using the required format mask (see below).

Data-types Supported:  varchar2, number, date

Substitutions Allowed: Substitution is not allowed.

Format issues:

- Static values supplied for number type variables must be character strings in a format that will convert into an Oracle number field using a standard Oracle  to_number conversion.
- Static values supplied for date type variables must be character strings that strictly comply to the Oracle format mask 'YYYY-MM-DD HH24:MI:SS'.

#### 6. Function Body

Function Body allows you to set a variable to the return value of a PL/SQL function body.  The PL/SQL function body must contain a RETURN clause that returns a value of type varchar2.   If the variable is a number or a date, this string must convert to an Oracle number or to a date using the required format mask (see below).

Data-types Supported:  varchar2, number, date

Substitutions Allowed: Substitution is not allowed.

Format issues:

- Static values supplied for number type variables must be character strings in a format that will convert into an Oracle number field using a standard Oracle  to_number conversion.
- Static values supplied for date type variables must be character strings that strictly comply to the Oracle format mask 'YYYY-MM-DD HH24:MI:SS'.
### Trigger Points

Variable expressions are, in general, triggered before and after each object in the Flow diagram.  Each trigger point can contain a set of zero or more expressions that are evaluated as part of the *expression set*.

- For Task-type BPMN objects, ( i.e., bpmn:task, bpmn:scriptTask, bpmn:manualTask, bpmn:serviceTask, bpmn:userTask), variable expressions can be executed ***before-task*** and ***after-task***.
- For Gateway type BPMN objects, ( i.e., bpmn:exclusiveGateway, bpmn:inclusiveGateway, bpmn:parallel Gateway, and bpmn:eventBasedGateway), variable expressions can operate **before-split**** and **after-merge****.
- For Event-type BPMN objects (i.e., bpmn:startEvent, bpmn:endEvent, bpmn:intermediateCatchEvent, bpmn:intermediateThrowEvents, bpmn:boundaryEvents), variable expressions can be evaluated ***on-event***.  In addition, as there can be a long interval between a timer event becoming current and the timer firing, timer events can be triggered when they become current using the ***before-event*** triggering point.

### Handling Errors in Variable Expressions

Variable expression evaluation can fail if the expression definition contains an error, if they encounter data that is incorrect or not in the expected format, or for other reasons.
If errors occur while processing process variable expressions, the behaviour depends on whether the failing expression is in the user's current step, or on a later step that has been automatically triggered by completing the current step.

- if the error is in the user's current step, Flows for APEX will present an error message to the user, and typically not allow the user's current transaction to complete.
- if the error is in a step triggered by the user's current step, for example in a gateway or a scriptTask following on from the user's current task, the user's transaction will be allowed to proceed;  any following steps that complete successfully will complete, but the step containing the error will be put into `error` status and will rollback.  After an administrator fixes the underlying problem, the failed step can be restarted from the Flow Monitor.



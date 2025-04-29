# Flows for APEX Release 25.1 APEX Human Task Enhancements.

## Version Info

| Version| Date | Author | Comments
| -- | -- | --| --|
| 0.1 | 13-Apr-25 | R Allen | Initial Draft |

## Background

The APEX Approval sub-type of BPMN UserTask was first written in 2022, shortly after the initial release of APEX Approval Tasks by Oracle in APEX 22.1.  We made minor enhancements in Flows 22.2 to support due dates and priorities, but haven't upgraded it since.  The current implementation has the following limitations:
 - Flows for APEX doesn't have Business Admin privileges on the Approval Task, and so can't assign potential owners to a task.
 - Flows for APEX doesn't have Business Admin privileges on the Approval Task, and so can't always Cancel an Approval Task if the workflow needs to (for example, as a result of an Interrupting Boundary Event causing the task to be cancelled).
 - APEX Human Tasks doesn't currently accept Groups or Excluded Users for Task Assignment - only potential users.   We should remove these from the Task Assignment details in Flows.
  
In addition, the APEX Human Task has evolved since APEX 22.1, with the following new capabilities that we could/ should support;
- The `APEX_APPROVAL` API is deprecated and replaced by `APEX_HUMAN_TASK`.  Functionality is maintained.
- With the addition of APEX Action Tasks, APEX Human Tasks are no longer just 'approvals'.  We should change our terminology to reflect our support for APEX Human Tasks.
- Approvals  originally could not be owned by their originator (to prevent self-approval).  This restriction has been removed for Action Tasks and for Approval Tasks with the `Task can be assigned to Originator` flag set.  
  

## Enhancements

### 1.  House Keeping / Tech Debt

 - [x] Update all calls from `APEX_APPROVAL` to `APEX_HUMAN_TASK`.
 - [ ] Remove conditional compiles for APEX versions < 24.1
 - [ ] Update Task Type in flow_apex_my_combined_task_list_vw for APEX Action Tasks & Flows.

### 2. Add a Business Owner into our UserTask Definition to Enable Task Assignment and Task Cancelation

As with Async sessions run from timers currently, we need a 3 tier definition of APEX Business Admin to be used on tasks.
  - On an `bpmn:userTask` sub-type `APEX Approval`, a Flows for APEX Expression / expression type allowing static, process variable, SQL Query Single and Multiple, Expression and Function containing an expression for the APEX Business Admin to use for that task.
  - Within a flow diagram, as a Child of `BPMN:process` we should have `apex:processBusinessAdmin` (in 'Background Task Session' region, or it a new region?).  This should accept a Static which can be substituted.
 - As a system configuration parameter, this should be a Single username.  Config parameter `default_business_admin`.
  
The Business Admin shall be evaluated at task creation time by looking for a Task-level definition.   If that is not successful, then look for a bpmn:process level one from the diagram, then a system-wide configuration parameter if that is not successful.

The Business Admin selected for a task should be validated using `APEX_HUMAN_TASK.IS_ALLOWED` to ensure it is a valid Business Admin after any substitution has been performed.

The business Admin used for a task should then be stored on `FLOW_SUBFLOWS` as a varchar2 colon delimited list so that it can be used for subsequent task assignment or task cancellation functions. Add a column `flow_subflows.sbfl_apex_task_business_admin` as a `varchar2(4000)`.

#### Tasks:

 - [*] Add system config parameter `default_apex_business_admin` into config and migration scripts.
 - [ ] Add `default_apex_business_admin` to Engine App Config pages.
 - [ ] Add `apex:businessAdmin` as an in-line attribute of `BPMN:process` in Modeler ('Background Task Session' region), labeled 'Default APEX Business Admin'.
 - [ ] Support `apex:businessAdmin` in BPMN parser.
 - [ ] Add `apex:businessAdmin` as an attribute inside <bpmn:userTask><bpmn:extensionElements><apex:apexApproval>.
 - [ ] Support task-level `apex:businessAdmin` in BPMN parser.
 - [ ] Create `flow_usertasks.get_apex_business_admin` function.
 - [ ] Extend flow_subflows table with column `flow_subflows.sbfl_apex_task_business_admin` as a `varchar2(4000)` (ddl + migration).  Migration value - left as null.

### 3.  Support Initiator can Complete

- [ ] Add Switch on BPMN:UserTask sub-type 'APEX Approval' region to allow task initiator to complete task. Save in BPMN inside `apex:approvalTask` as `apex:initiatorCanComplete`.
- [x] Add this to `flow_create_apex_task` and its call to `apex_human_task.create_task` call.

### 4. Task Assignment

- [ ] We create two new functions in flow_api_pkg, task_potential_owners and task_business_admins which return a comma-delimited list of task potential owners and business admins, respectively.  The underlying functions, in `flow_usertask_pkg`, get the potential owners and business admins from flow_subflows and convert the separator from ':' to ','.  A user can then use these in an APEX Task Definition to specify the potential owners and business admins for their task.  APEX create task will call these functions in Flows for APEX during task creation.
- [ ] Remove Groups and Excluded Users from the Properties Panel for APEX Tasks.
  

### 5. Task Cancel.

APEX Task cancellation can be performed by either the task originator or a business admin. When a task requires cancellation, we should see if the current user has the ability to cancel the task (using `apex_human_task.is_allowed`).  If not, we'll use a `dbms_scheduler` job, scheduled immediately, to connect to APEX as a business admin for the task and cancel it.

- [x] create a dbms scheduler job to connect as a Business Admin to cancel a task.
- [x] Add task cancelation to Process Reset, Termination, and Deletion.
- [x] Add APEX$TASK_STATE to plugin callback..

### 6. UI Integration

- [ ] Check UI integration with APEX tasks and APEX Task List in 24.1 and 24.2 (think it changed in 24.2).  
- [ ] Add documentation on Task List Integration
- [ ] Update and publish Task List Integration Blog on this....
- [ ] Write Blog on APEX Human Task Upgrade...


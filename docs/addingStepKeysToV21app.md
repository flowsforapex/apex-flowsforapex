# Adding Step Keys To An Existing Application

*** Notes on Migrating a V5 or v21 Application to v22.1 or Later

## Overview

The Step Keys feature introduced in v22.1 prevents user collisions when, for example, two users simultaneously submit a `flow_step_complete` operation - each unaware that the other is also moving the process forward.  This could create the situation where both the process moves forward two steps.  With the step Keys feature active, the first user to have their step processed would be able to complete the step; the second user would be given an error, annd be told that the process step that they were trying to complete had already been performed by another transaction.

The context information supplied to the flow engine prior to v22 was the `process_id` and the `subflow_id`.

From v22.1 onwards, the context information that must be supplied to the flow engine is the `process_id`, the `subflow_id`, and the `step_key`.

Typically this context information is passed to a User Task as parameters in the page URL, and is stored in the APEX application either as Application Items, Page 0 Page Items, or as Page Items on the page being called.  Then when the application processes a Step Complete operation, it passes these values back to the Flows for APEX engine as parameters.


## Migration Steps.

### Add an Application Item or Page Item to Store the Step Key

1.  Find how your application stored Process ID and Subflow ID.  Look first in Shared Components >> Application Items.  If not, look on Page 0.  If not, look on the page being called.
2.  Add a parallel item STEP_KEY

### Upgrade the Flows for APEX Process Plugins in your Application

New, v22.1 Plugins are supplied as part of the Flows for APEX application when you install the upgrade.  

1.  In your application, go to Shared Components >> Plug Ins
2.  Import the 4 new v22.1 plugins to your app from the Flows for APEX application.
    - Flows for APEX - Manage Flow Instance plugin.
    - Flows for APEX - Manage Flow Instance Step plugin.
    - Flows for APEX - Manage Flow Instance Variable plugin.
    - Flows for APEX - Viewer

In each place where the 'Flows for APEX - Manage Flow Instance Step' plugin is used, hook up the Step Key field to the Application Item or Page Item that you created to store the Step Key.

### Upgrade any PL/SQL Packages, Procedures and Functions that make Step operations directly.

Wherever you have used direct PL/SQL calls to the Flows for APEX engine to perform Step operations (reserve, release, start, complete), add the Step Key parameter.   This might be in your application logic, or in any called PL/SQL pacges containing the application logic.

### Add Step Keys to UserTasks in your BPMN Model.

Go to the Flows for APEX application >> Flow Modeler.

Edit your Process Diagram to add the Step Key parameter to each UserTask on your model.  In the same way that you passed the process_id and subflow_id as parameters to the APEX page being called, add the Step Key to the list of passed parameters.
The parameter to be set is the Application Item or Page Item that we added to the app earlier.
The value to be sent can be got from the substitution parameter `&F4A$STEP_KEY.`. (Don't forget the final `.`!).

### Test your System.

When a system is migrated, use of Step Keys is not enforced.  However, any Step Keys that are supplied are checked and the engine will raise an error if it encounters an invalid, non-null Step Key.  

Enforcement is controlled by the `duplicate_step_prevention` parameter, which has values of `legacy` and `strict`.

So run your system initially to test in `legacy` mode.  Once you are satisfied that it is working correctly and you want to enforce valid step keys, change this to `strict`.

We would recommend that all new systems start in `strict` mode, and that all existing apps migrate to `strict` mode as soon as practical.



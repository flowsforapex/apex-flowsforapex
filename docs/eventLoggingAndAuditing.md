# Event Logging and Auditing

### Introduction

Flows for APEX v21.1 introduces an optional event logging and auditing capability that will be further developed in subsequent releases.

Events are logged for three main purposes:

- to provide an audit trail for security or forensic purposes
- to provide monitoring information on currently running flow instances
- to provide data about many flow instances that can be used for process redesign and enhancement, sometimes called Process Performance Management (PPM).

Like all event logging and audit trails, capturing and storing event trails uses processing power and fills storage resources -- so you should 'log only what you need to log' and 'retain only what you need to retain for as long as you need it'!

### Logging Model Events

Model Events are not currently logged in V21.1.

### Logging Instance Events

Instance Events provide information on the major events occurring for the execution of an instance.  These include:

- Instance Creation
- Instance Start
- Instance Completion
- Instance Reset
- Instance Termination
- Instance Errors & Restarts

In the event of an error occurring on a step which causes the instance to be put into `error` status, the Instance Event Log contains a column error_info which will contain as much of the error stack from Flows for APEX, APEX, and Oracle as we are able to collect.  This is particularly useful for debugging errors on steps that are performed outside of the user's current step, such as errors from timers, scriptTasks, or process variable expression execution.

### Logging Step Events

The Step Event Log contains one record for each completed process step, and includes information on:

- the preceding task
- time at which the step became the current task
- time at which work started (splitting waiting time from processing time) if the flow_start_work call is used.
- time at which the step was completed
- process status on completion
- subflow and subProcess information.

### Logging Process Variable Changes

The Process Variable Event Log records the new value every time a process variable is set (created or updated).

### Configuring Event Logging

Event logging is currently designed to be configurable, so that an installation can capture more or less event data depending upon business ad security needs.

Logging is configured using Flows for APEX configuration parameters, which are stored in the FLOW_CONFIGURATION table.


| parameter           | possible values | behavior                                                                                                                                                                                                   | default |
| --------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| logging_level       | off             | logging is disabled                                                                                                                                                                                        |         |
|                     | standard        | logs instance and step events                                                                                                                                                                              | yes     |
|                     | secure          | logs model, instance and step events                                                                                                                                                                       |         |
|                     | full            | logs model, instance, step and process variable events                                                                                                                                                     |         |
|                     |                 |                                                                                                                                                                                                            |         |
| logging_hide_userid | true            | does not capture user information about the step                                                                                                                                                           |         |
|                     | false           | captures userid of the process step as known to the Flow Engine                                                                                                                                            | yes     |
|                     |                 |                                                                                                                                                                                                            |         |
| logging_language    | en              | error messages generated in the Flows for APEX engine will be placed in the Instance Event Log in this language.  If the message is not available in the required language, it will appear in English (en) | yes     |
|                     | fr              | event log messages in French (fr)                                                                                                                                                                          |         |

### Managing Your Event Logs

Like any audit trail and event log, the Flows for APEX event log can rapidly collect a large volume of data.  Some users will need to retain this for many years to meet their site security policy, while others will want to delete this periodically to prevent the logs from becoming too large and from either slowing system performance or from filling their storage device!

Flows for APEX will operate without event logging enabled, and after any event logging data has been deleted -- so nothing is required for execution of BPMN instances.  However, the Flow Monitor is unable to show detailed history, including error messages for tasks performed outside the users current step, unless the event logging data is captured and is still stored in the database. So you can delete anything you want from the event log tables, and Flows for APEX will continue to work.

You should consider deleting or moving to archival storage event logging data for instances which have been completed or deleted for some period of time.  As at v21.1, Flows for APEX doesn't contain any tools to help you manage event logs archive or destruction.

# Flows for APEX Configuration Parameter Options

Configuration parameters can be changed from the Flows for APEX application.

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

### Configuring Diagram Versioning

| parameter       | possible values | behavior                                                                                                                    | default |
| ----------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------- |
| engine_app_mode | production      | versioning controls are strictly enforced.`released` models cannot be edited and resaved, except by creating a new version. | yes     |
|                 | development     | versioning controls are not strictly enforced. diagrams in`released` status can be edited and re-saved.                     |         |
|                 |                 |                                                                                                                             |         |

### General System Configuration

| parameter                 | possible values                                                                                                                                                                                   | behavior                                                                                                                                                                                        | default                   |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| duplicate_step_prevention | strict                                                                                                                                                                                            | requires step keys to be provided on all step operations, thus preventing multiple users from attempting to make the same step transition but instead moving the process forward multiple steps | yes (new installations)   |
|                           | legacy                                                                                                                                                                                            | allows null step keys.  Incorrect step keys will still cause an error.  Only use this until you migrate your v21 and earlier apps to use Step Keys                                              | only for migrated systems |
| version_initial_installed | | records the version first installed (do not change)                                                                                                                                               |                                                                                                                                                                                                 |                           |
| version_now_installed  |   | records the current version installed, after any migrations have occured                                                                                                                          |                                                                                                                                                                                                 |                           |
| default_workspace       |  | should be set to your default APEX workspace used for Flows for APEX.  This is used as a last-resort for scriptTasks and serviceTasks when creating an APEX session or looking for mail templates |                                                                                                                                                                                                 |                           |
| default_email_sender     |  | should be set to your default email sender, in case outbound mail serviceTasks do not have a sender defined                                                                                       |                                                                                                                                                                                                 |                           |


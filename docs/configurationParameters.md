# Flows for APEX Configuration Parameter Options

### Configuring Event Logging

Event logging is currently designed to be configurable, so that an installation can capture more or less event data depending upon business ad security needs.

Logging is configured using Flows for APEX configuration parameters, which are stored in the FLOW_CONFIGURATION table.

| parameter           | possible values | behaviour                                                                                                                                                                                                  | default |
| --------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| logging_level       | off             | logging is disabled                                                                                                                                                                                        |         |
|                     | standard        | logs instance and step events                                                                                                                                                                              | yes     |
|                     | secure          | logs model, instance and step events                                                                                                                                                                        |         |
|                     | full            | logs model, instance, step and process variable events                                                                                                                                                      |         |
|                     |                 |                                                                                                                                                                                                            |         |
| logging_hide_userid | true            | does not capture user information about the step                                                                                                                                                           |         |
|                     | false           | captures userid of the process step as known to the Flow Engine                                                                                                                                            | yes     |
|                     |                 |                                                                                                                                                                                                            |         |
| logging_language    | en              | error messages generated in the Flows for APEX engine will be placed in the Instance Event Log in this language.  If the message is not available in the required language, it will appear in English (en) | yes     |
|                     | fr              | event log messages in French (fr)                                                                                                                                                                          |         |


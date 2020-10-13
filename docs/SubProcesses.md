## Sub Processes

### General

BPMN allows encapsulation and detail hiding through the use of Sub Processes.  These can be defined in a diagram, allowing the details of a process to be hidden from the top level process.

Flows for APEX allows you to create sub processes within your process.  Sub processes can contain other sub processes, and so a deep hierarchy of processes and sub processes can be built.  There is no arbitrary limit to how deep sub processes can be stacked -- although everything must be contained in a single BPMN diagram currently.

![Nested Sub Processes](images/nestedSubProcesses.png "Nested Sub Processes")

### Creating Sub Processes

Sub Processes are created using the modeller, as usual.

### Boundary Events on Sub Processes

Starting with Flows for APEX V5.0, Sub Processes can have Timer and Error Boundary Events added to them.  See [behaviour Of Boundary Events in SubProcesses](behaviourOfBoundaryEventsinSubProcesses.md)

### Terminate End Events in Sub Processes

Starting with Flows for APEX V5.0, a Sub Process can contain a Terminate End Event.  If a Terminate End Event is reached, all processing in the sub process, along with any nested child sub processes running inside it, are terminated.  Control passes to the next event in the normal exit path to the sub process in its immediate parent process.

## Current Limitations

#### 1. Sub Processes must have 1 Start Event and 1 End Event

A Sub Process must start with a single Start Event, which should be a simple Start Event (i.e., without any associated Timer, etc. event).

A sub process must have a single, standard End Event.  (It may have additional non-standard end events, such as error end events, etc.).

#### 2. A Sub Processes must operate in a single Lane

As is good BPMN style, a sub process must operate in a single lane.




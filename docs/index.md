## Welcome to Flows for APEX

#### Create workflows in Low-Code style

This application enables every APEX developer to create and run process flows for their APEX apps. Have a look yourself what Flows for APEX can do for you!

![Example Process running](images/runningMyBigShippingExample.png)

## Flows for APEX documentation

### Latest Documentation

The most updated version of this documentation is maintained online using Github Pages and can be read at the [APEX-FlowsforAPEX doc site.](https://mt-ag.github.io/apex-flowsforapex/)

### Getting Started?

There is a Tutorial and Demo to help you get started.

#### Tutorial

The Flows for APEX distribution includes a set of BPMN models that act as a tutorial.

To install, either run a SQL script bpmn_tutorials/install_tutorials.sql or import the BPMN files in bpmn_tutorials/xml into your Flows for APEX system.

To run, start with Tutorial 0.  Open the BPMN file in the Flows for APEX Modeler, read through the model including the attached comments and look at any settings in the Properties Panel.  Most of the models can then be run in the Flow Monitor, allowing you to see how a model is processed.  Work your way through the 11 tutorial files in order to get a good introduction to BPMN and how to use it in Flows for APEX.

### How to use BPMN features when building BPMN Processes:

- [Starting and Stopping Flows](StartingAndStoppingFlows.md)
- [Tasks Implement Your Process](usingTasksToImplementYourProcess.md)
- [Gateways and Parallel Flows](GatewaysAndParallelFlows.md)
- [Using Sub Processes](SubProcesses.md)
- [Boundary Events in Sub Processes](behaviourOfBoundaryEventsInSubProcesses.md)
- [Using Timer Events](UsingTimerEvents.md)
- [Using Lanes](UsingLanes.md)
- [Task Reservation](reservations.md)
- [Link Events](linkEvents.md)

The diagram below gives a full definition of the BPMN syntax supported in the current release of Flows for APEX.  The diagram is reasonably self-documenting, explaining how each symbol can be used.  The diagram and associated BPMN/XML is included in the shipped BPMN examples.

![Full syntax Supported](images/FlowsForAPEXv50FullSyntax.png)

### Using the Flows for APEX PL/SQL API

- [The Flows for APEX PL/SQL API](FlowsforAPEX_PLSQL_API.md)
- [The Process Variable System](processVariables.md)
- [Declarative Process Variable Expressions](variableExpressions.md)🆕
- [Event Logging and Audit Trail](eventLoggingAndAuditing.md)🆕
- [Flows for APEX Configuration Parameters](configurationParameters.md)🆕

### Understanding Flows for APEX Concepts

- [About Subflows](AboutSubflows.md)
- [Process Versioning](diagramVersioning.md) 🆕

## Frequently Asked Questions (FAQ)

See the [FAQ](FAQ.md)


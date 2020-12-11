## Flows for APEX Tutorial

We've created a series of short tutorials to take developers through the basics of creating and running a business process model in BPMN, using the <b><i>Flows for APEX</i></b> Modeller and Flow Monitor.

If you work through these 9 quick tutorials, you'll be able to use <b><i>Flows for APEX</i></b> to model your business processes, and then execute processes in APEX.
Each tutorial is a Flows for APEX model that explains how it runs and how it is constructed.

### The Tutorials

* Tutorial 0 - Getting Started
* Tutorial 1 - The Gateway Tutorial - how to have conditional task routing
* Tutorial 2 - Parallel Gateways - how to create sections of your process that execute in parallel
* Tutorial 3 - Inclusive Gateways - but not always all of the parallel sections...
* Tutorial 4 - Tasks Get your Work Done - How to call APEX pages, scripts, and send emails in your process
* Tutorial 5 - Sub Processes - Encapsulating part of yiour process into a sub Process
* Tutorial 6 - Errors and Escalatiuons - How to handle things needing help or going wrong in your process
* Tutorial 7 - It's about Time - Adding timers to create reminders, process closing flows, process timeouts, etc.,
* Tutorial 8 - Lanes and Reservations - modelling who does what


Each tutorial is a Flows for APEX model that explains how it runs and how it is constructed.  You can open each model in the Process Modeler, to see how it has been configured.  You can modify and save your own copy of the model if you want to experiment.  And you can execute the model using the Flow Monitor, stepping through the model, step by step.</p>

#### Getting Started

1. Start off in the Workflow Editor.  Select this from the APEX Navigation Menu on the Left.
2. Using the 'File Open' icon in the top right menu, select 'AA0 - Tutorial - Getting Started'
3. Read the model text.  Use the Properties Panel on the Right Hand Side if you want to see the detailed configurations.
4. If you have edited the model & want to execute it, use the 'Save As New' icon to save your own copy.  This saves the BPMN model as an XML object into the database, and creates a parsed copy of it in the <b><i>Flows for APEX</i></b> tables ready for execution.
5. Go to the Flow Monitor tab using the APEX Navigation Menu on the Left.
6. From the Flow Monitor, click the '+ Create a New Instance' button (Top Right), select your process from the pull-down menu, and give the process instance some name.
7. In the Flow Control region, view Flow Instances table, you'll see that your process is now listed.  Click the 'Play' button to start executing the process flow.  Notice a copy of your process diagram in the Flow Monitor region at. the bottom of your screen.
8. In the Flow Control region, now select the Subflows tab.  You will see the execution subflows within your process instance.  Use the 'Step Completed' button to move the process forward to the next process state.  Notice the progress of your flow in the Flow Monitor.  The Current Task(s) are shown in Green, completed tasks are shaded Grey.
9. Step through your Model until it completes.  Note then that there are no subflows still running.

If you wish to re-run the model, you can return to the Flow Instances tab, and click the 'Reset' button to restart your process.  Note that this is not something you would do with a production process - you'd run a new instance of the process -  but it's useful as you learn how <i><b>Flows for APEX</b></i> works.

#### Next Steps

Now you've got the basics of how to build a process model using BPMN for <b><i>Flows for APEX</i></b>, take a look at our demo application.  This uses an example Business Process of the ordering and fulfillment process for a webstore selling T Shirts.
Before you go to the demo app, you can look at the process model for our Order Shipping process.  Just like you did for the tutorial models above, look for our model called 'Shipment_Process' in the Process Modeler.  
You can step through this process model using the Flow Monitor, if you want.

And then go to the demo application, at  https://apex.oracle.com/pls/apex/mt_flows/r/flowsforapexdemo [using this link](https://apex.oracle.com/pls/apex/mt_flows/r/flowsforapexdemo "Flows for APEX demo") , to see how this might look as an APEX app.


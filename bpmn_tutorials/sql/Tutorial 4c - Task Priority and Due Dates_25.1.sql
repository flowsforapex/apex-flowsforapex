declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="25.1.0">]'
      ,q'[  <bpmn:process id="Process_Tutorial4c" name="Tutorial 4c" isExecutable="true" apex:isStartable="true" apex:minLoggingLevel="0" apex:manualInput="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:dueOn>]'
      ,q'[        <apex:expressionType>interval</apex:expressionType>]'
      ,q'[      </apex:dueOn>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:startEvent id="Event_1g4stqi">]'
      ,q'[      <bpmn:outgoing>Flow_16pfhkf</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_04hvvpj" name="Priorities and Due Dates">]'
      ,q'[      <bpmn:incoming>Flow_16pfhkf</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0ts4odn</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_16pfhkf" sourceRef="Event_1g4stqi" targetRef="Activity_04hvvpj" />]'
      ,q'[    <bpmn:task id="Activity_03fe5g1" name="1.  Process&#10; Instance&#10; Priority and &#10;Due Date">]'
      ,q'[      <bpmn:incoming>Flow_0ts4odn</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1q9tj7w</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0ts4odn" sourceRef="Activity_04hvvpj" targetRef="Activity_03fe5g1" />]'
      ,q'[    <bpmn:task id="Activity_0k5mueu" name="Setting Process Priority and Due Date">]'
      ,q'[      <bpmn:incoming>Flow_1q9tj7w</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_04kfywn</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1q9tj7w" sourceRef="Activity_03fe5g1" targetRef="Activity_0k5mueu" />]'
      ,q'[    <bpmn:task id="Activity_1sx6tny" name="2 Task Priority and Due Date">]'
      ,q'[      <bpmn:incoming>Flow_04kfywn</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1htpo8q</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_04kfywn" sourceRef="Activity_0k5mueu" targetRef="Activity_1sx6tny" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1htpo8q" sourceRef="Activity_1sx6tny" targetRef="Activity_0133nx5" />]'
      ,q'[    <bpmn:userTask id="Activity_0133nx5" name="Setting Task Priority and Due Date" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:incoming>Flow_1htpo8q</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1r3ufvw</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[    <bpmn:endEvent id="Event_1yl8fo0" name="End Scheduling">]'
      ,q'[      <bpmn:incoming>Flow_1r3ufvw</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1r3ufvw" sourceRef="Activity_0133nx5" targetRef="Event_1yl8fo0" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0t4o8e4">]'
      ,q'[      <bpmn:text>To be able to track and schedule process instances and tasks, you can set a PRIORITY and a DUE DATE for both a PROCESS INSTANCE and for a USER TASK.]'
      ,q'[]'
      ,q'[These values are then shown in the Task Inbox, and can be used to determine what tasks to perform next.]'
      ,q'[]'
      ,q'[We'll start by looking at how to set PROCESS PRIORITY and DUE DATE, then look at how this can be done for a TASK...</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1ltq2yb" sourceRef="Activity_04hvvpj" targetRef="TextAnnotation_0t4o8e4" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_06r02b3">]'
      ,q'[      <bpmn:text>1.  Open this model in the Flow Modeler.]'
      ,q'[2.  Click on the background canvas behind the model - so that the properties panel shows the Process object.]'
      ,q'[3.  Select 'Scheduling' on the Process Properties Panel]'
      ,q'[4.  Select 'Priority' inside the 'Scheduling' region.]'
      ,q'[5.  The Priority can be set by several different methods:]'
      ,q'[]'
      ,q'[- Static Value - Set to 1 (Highest) down to 5 (Lowest).]'
      ,q'[- Process Variable - Enter the name of a Process Variable that contains your chosen process priority]'
      ,q'[- SQL - Enter a SQL Query that can return the required priority (1-5).]'
      ,q'[- Expression - Enter a PL/SQL expression that returns your required process priority]'
      ,q'[- Function Body - Enter a PL/SQL function body that returns your required process priority.]'
      ,q'[]'
      ,q'[Remember the Priority must be between 1 (Highest) and 5 (Lowest).</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_0iesp4f" sourceRef="Activity_0k5mueu" targetRef="TextAnnotation_06r02b3" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_18hjgsv">]'
      ,q'[      <bpmn:text>The Process Due Date can also be specified, in a similar way to the Priority.]'
      ,q'[]'
      ,q'[Due Date must be specified using a TIMESTAMP WITH TIME ZONE - so that it is fully defined when the completion is required if some users or your database server is in a different time zone to some other users.  ]'
      ,q'[]'
      ,q'[A Simple DATE or DATE/TIME without a specified Time Zone may be converted using the time zone of the User or with UTC time zone -- and shouldn't be used.]'
      ,q'[]'
      ,q'[In addition to the methods for Priority, the Due Date can also be specified using these additional methods:]'
      ,q'[]'
      ,q'[- As an Interval - specifying how long after start it is required to complete.   For example, an instance is due 12 Hours after it is started, or after 30 days.  These intervals can be specified in Oracle Interval (Day to Second ) format:]'
      ,q'[   DDD HH24:MI:SS]'
      ,q'[   e.g., '000 12:00:00' or '030 00:00:00']'
      ,q'[or in ISO 8601 Duration / Period Format format:]'
      ,q'[   P(ddD)(T)(hh24H)(miM)(ssS) ]'
      ,q'[   e.g., PT12H or P30D]'
      ,q'[- Using Oracle Scheduler Syntax (see documentation for DBMS_SCHEDULER)</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_012d9xr" sourceRef="Activity_0k5mueu" targetRef="TextAnnotation_18hjgsv" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0810uji">]'
      ,q'[      <bpmn:text>Priority and Due Date can be set for User Tasks (Human Tasks).]'
      ,q'[]'
      ,q'[1.  Select the UserTask]'
      ,q'[2.  In the Properties Panel for the UserTask, select 'Scheduling']'
      ,q'[3.  Then in the 'Scheduling' Region, select the 'Priority' item.]'
      ,q'[]'
      ,q'[Same setting methods exist as for the Instance Priority.]'
      ,q'[]'
      ,q'[Note that the Process Instance priority (defining the whole process) is available to you as a Process Variable named 'PROCESS_PRIORITY'.]'
      ,q'[]'
      ,q'[So if you want the Task to have the same priority as the process instance, choose 'Process Variable' input method, and set the Process Variable name to 'PROCESS_PRIORITY'.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_16lpjbj" sourceRef="Activity_0133nx5" targetRef="TextAnnotation_0810uji" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_1yf8nam">]'
      ,q'[      <bpmn:text>...And similar for setting the Due Date.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1mrs5e3" sourceRef="Activity_0133nx5" targetRef="TextAnnotation_1yf8nam" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_Tutorial4c">]'
      ,q'[      <bpmndi:BPMNShape id="Event_1g4stqi_di" bpmnElement="Event_1g4stqi">]'
      ,q'[        <dc:Bounds x="312" y="412" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_04hvvpj_di" bpmnElement="Activity_04hvvpj" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="400" y="390" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_03fe5g1_di" bpmnElement="Activity_03fe5g1" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="560" y="390" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0k5mueu_di" bpmnElement="Activity_0k5mueu" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="720" y="390" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1sx6tny_di" bpmnElement="Activity_1sx6tny" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1110" y="390" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0d46kjr_di" bpmnElement="Activity_0133nx5" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1260" y="390" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1yl8fo0_di" bpmnElement="Event_1yl8fo0" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1412" y="412" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1391" y="455" width="78" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0t4o8e4_di" bpmnElement="TextAnnotation_0t4o8e4">]'
      ,q'[        <dc:Bounds x="380" y="140" width="240" height="208" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_06r02b3_di" bpmnElement="TextAnnotation_06r02b3">]'
      ,q'[        <dc:Bounds x="740" y="60" width="400" height="270" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_18hjgsv_di" bpmnElement="TextAnnotation_18hjgsv">]'
      ,q'[        <dc:Bounds x="570" y="540" width="520" height="330" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0810uji_di" bpmnElement="TextAnnotation_0810uji">]'
      ,q'[        <dc:Bounds x="1260" y="60" width="350" height="270" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_1yf8nam_di" bpmnElement="TextAnnotation_1yf8nam">]'
      ,q'[        <dc:Bounds x="1260" y="540" width="100" height="54" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_16pfhkf_di" bpmnElement="Flow_16pfhkf">]'
      ,q'[        <di:waypoint x="348" y="430" />]'
      ,q'[        <di:waypoint x="400" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0ts4odn_di" bpmnElement="Flow_0ts4odn">]'
      ,q'[        <di:waypoint x="500" y="430" />]'
      ,q'[        <di:waypoint x="560" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1q9tj7w_di" bpmnElement="Flow_1q9tj7w">]'
      ,q'[        <di:waypoint x="660" y="430" />]'
      ,q'[        <di:waypoint x="720" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_04kfywn_di" bpmnElement="Flow_04kfywn">]'
      ,q'[        <di:waypoint x="820" y="430" />]'
      ,q'[        <di:waypoint x="1110" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1htpo8q_di" bpmnElement="Flow_1htpo8q">]'
      ,q'[        <di:waypoint x="1210" y="430" />]'
      ,q'[        <di:waypoint x="1260" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1r3ufvw_di" bpmnElement="Flow_1r3ufvw">]'
      ,q'[        <di:waypoint x="1360" y="430" />]'
      ,q'[        <di:waypoint x="1412" y="430" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1ltq2yb_di" bpmnElement="Association_1ltq2yb">]'
      ,q'[        <di:waypoint x="400" y="407" />]'
      ,q'[        <di:waypoint x="300" y="360" />]'
      ,q'[        <di:waypoint x="300" y="244" />]'
      ,q'[        <di:waypoint x="380" y="244" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_0iesp4f_di" bpmnElement="Association_0iesp4f">]'
      ,q'[        <di:waypoint x="741" y="390" />]'
      ,q'[        <di:waypoint x="690" y="320" />]'
      ,q'[        <di:waypoint x="690" y="190" />]'
      ,q'[        <di:waypoint x="740" y="190" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_012d9xr_di" bpmnElement="Association_012d9xr">]'
      ,q'[        <di:waypoint x="727" y="469" />]'
      ,q'[        <di:waypoint x="670" y="520" />]'
      ,q'[        <di:waypoint x="450" y="520" />]'
      ,q'[        <di:waypoint x="450" y="690" />]'
      ,q'[        <di:waypoint x="570" y="690" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_16lpjbj_di" bpmnElement="Association_16lpjbj">]'
      ,q'[        <di:waypoint x="1264" y="393" />]'
      ,q'[        <di:waypoint x="1210" y="350" />]'
      ,q'[        <di:waypoint x="1210" y="94" />]'
      ,q'[        <di:waypoint x="1260" y="94" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1mrs5e3_di" bpmnElement="Association_1mrs5e3">]'
      ,q'[        <di:waypoint x="1310" y="470" />]'
      ,q'[        <di:waypoint x="1310" y="540" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Tutorial 4c - Task Priority and Due Dates',
    pi_dgrm_short_description => 'Flows for APEX BPMN Tutorials - part 4c - shows how you can set priority and due dates for user tasks to keep things getting done on time.',
    pi_dgrm_description => 'The BPMN (Business Process Model and Notation) provided outlines a structured approach for managing process priorities and due dates within a business workflow. This model is designed to enable businesses to effectively manage and track the scheduling of both process instances and individual tasks, enhancing operational efficiency and task management.

### Business Summary

**Objective:**  
The model provides a structured framework for assigning and managing priorities and due dates to process instances and user tasks within a business process. By incorporating priority levels and due dates, organizations can ensure timely task execution and efficient resource allocation.

**Key Components:**

**Start Event:**

*   Initiates the process flow to set priorities and due dates for tasks.

**Tasks:**

*   Several tasks including "Priorities and Due Dates," "Process Instance Priority and Due Date," and "Task Priority and Due Date," guide users through configuring priorities and due dates.
*   Tasks are linked by sequence flows, ensuring a logical progression from setting instance priorities to task-specific priorities.

**User Task:**

*   Allows for interactive input regarding task priorities and due dates, utilizing the "apexPage" attribute for integration with the Flows for APEX framework.

**End Event:**

*   Marks the completion of the scheduling process, ensuring every task has a defined priority and deadline.

**Annotations and Instructions:**  
The model includes detailed text annotations providing step-by-step instructions for setting priorities and due dates. Users are instructed on methods to establish these settings using static values, process variables, SQL queries, and expressions. It emphasizes ensuring that due dates include time zone specifications for consistent scheduling across different regions.

**Business Benefits:**

*   **Enhanced Task Management:** By systematically prioritizing tasks, businesses can optimize the order in which tasks are tackled, focusing on high-priority actions first.
*   **Operational Efficiency:** Clear due dates help maintain schedules and meet deadlines, which is crucial for time-sensitive projects.
*   **Improved Resource Allocation:** Understanding task priorities helps allocate resources more effectively, minimizing downtime and resource wastage.
*   **Scalability:** The process model is adaptable to various business sizes and complexities, allowing for customization as business requirements grow.

Overall, this BPMN model serves as a guide for businesses to streamline workflows and ensure that critical tasks are executed in a timely manner with appropriate urgency.',
    pi_dgrm_icon => 'fa-notebook fam-information fam-is-info',
    pi_dgrm_version => '25.1',
    pi_dgrm_category => 'Tutorials',
    pi_dgrm_content => l_dgrm_content
);
end;
/

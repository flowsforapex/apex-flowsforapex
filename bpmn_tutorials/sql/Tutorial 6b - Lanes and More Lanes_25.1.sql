declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="25.1.0">]'
      ,q'[  <bpmn:collaboration id="Collaboration_05ia5zp">]'
      ,q'[    <bpmn:participant id="Participant_0sxtbbr" name="My Revenue Process" processRef="Process_cr2unkh0" />]'
      ,q'[    <bpmn:group id="Group_1vb8gzv" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0qxito5">]'
      ,q'[      <bpmn:text>Note now that a Lane can be divided into a further set of Lanes by adding a CHILD LANESET inside a LANE</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1ffrhyq" sourceRef="Group_1vb8gzv" targetRef="TextAnnotation_0qxito5" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_1b5twef">]'
      ,q'[      <bpmn:text>2 Concepts in this Tutorial.]'
      ,q'[]'
      ,q'[1.  Lanes can be sub-divided into sub-lanes.]'
      ,q'[]'
      ,q'[2.  Lanes can be mapped to an APEX Role - or not, as required.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_0idyme6" sourceRef="Activity_173wq6m" targetRef="TextAnnotation_1b5twef" />]'
      ,q'[  </bpmn:collaboration>]'
      ,q'[  <bpmn:process id="Process_cr2unkh0" isExecutable="true" apex:isStartable="true" apex:minLoggingLevel="0">]'
      ,q'[    <bpmn:laneSet id="LaneSet_0t97tel">]'
      ,q'[      <bpmn:lane id="Lane_1fip85k" name="Sales" apex:isRole="false" apex:role="SALES">]'
      ,q'[        <bpmn:flowNodeRef>Event_0vw62ey</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_173wq6m</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[      <bpmn:lane id="Lane_11jtvuj" name="Finance" apex:isRole="false">]'
      ,q'[        <bpmn:flowNodeRef>Activity_022oq4a</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_1f73a9g</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_0c5yeyr</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_1f18qvf</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_047jt22</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:childLaneSet id="LaneSet_149q3g6">]'
      ,q'[          <bpmn:lane id="Lane_17hsgq6" name="Revenue Recognition Team" apex:isRole="false">]'
      ,q'[            <bpmn:flowNodeRef>Activity_1f18qvf</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_047jt22</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:childLaneSet id="LaneSet_12eax3z">]'
      ,q'[              <bpmn:lane id="Lane_0g7r886" name="Clerk" apex:isRole="true" apex:role="FIN-REV-REC-CLERK">]'
      ,q'[                <bpmn:flowNodeRef>Activity_1f18qvf</bpmn:flowNodeRef>]'
      ,q'[              </bpmn:lane>]'
      ,q'[              <bpmn:lane id="Lane_16vkzwu" name="Manager" apex:isRole="true" apex:role="FIN-REV-REC-MANAGER">]'
      ,q'[                <bpmn:flowNodeRef>Activity_047jt22</bpmn:flowNodeRef>]'
      ,q'[              </bpmn:lane>]'
      ,q'[            </bpmn:childLaneSet>]'
      ,q'[          </bpmn:lane>]'
      ,q'[          <bpmn:lane id="Lane_1ok0dgu" name="Sales Compensation" apex:isRole="true" apex:role="FINANCE-COMP-AP">]'
      ,q'[            <bpmn:flowNodeRef>Activity_022oq4a</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_1f73a9g</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_0c5yeyr</bpmn:flowNodeRef>]'
      ,q'[          </bpmn:lane>]'
      ,q'[        </bpmn:childLaneSet>]'
      ,q'[      </bpmn:lane>]'
      ,q'[    </bpmn:laneSet>]'
      ,q'[    <bpmn:startEvent id="Event_0vw62ey">]'
      ,q'[      <bpmn:outgoing>Flow_0sm1nql</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_173wq6m" name="Enter Sales Deal">]'
      ,q'[      <bpmn:incoming>Flow_0sm1nql</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0ufs4r3</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0sm1nql" sourceRef="Event_0vw62ey" targetRef="Activity_173wq6m" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0ufs4r3" sourceRef="Activity_173wq6m" targetRef="Activity_1f18qvf" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1csiktc" sourceRef="Activity_1f18qvf" targetRef="Activity_047jt22" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0k0njn0" sourceRef="Activity_047jt22" targetRef="Activity_022oq4a" />]'
      ,q'[    <bpmn:task id="Activity_022oq4a" name="Setup Commission Payment">]'
      ,q'[      <bpmn:incoming>Flow_0k0njn0</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0it1bo5</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0it1bo5" sourceRef="Activity_022oq4a" targetRef="Activity_1f73a9g" />]'
      ,q'[    <bpmn:callActivity id="Activity_1f73a9g" name="Make Staff Payment" apex:manualInput="false" apex:calledDiagramVersionSelection="latestVersion">]'
      ,q'[      <bpmn:incoming>Flow_0it1bo5</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_03pg83c</bpmn:outgoing>]'
      ,q'[    </bpmn:callActivity>]'
      ,q'[    <bpmn:endEvent id="Event_0c5yeyr">]'
      ,q'[      <bpmn:incoming>Flow_03pg83c</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_03pg83c" sourceRef="Activity_1f73a9g" targetRef="Event_0c5yeyr" />]'
      ,q'[    <bpmn:userTask id="Activity_1f18qvf" name="Confirm Sales Team Engagement Plan" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:incoming>Flow_0ufs4r3</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1csiktc</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[    <bpmn:userTask id="Activity_047jt22" name="Approve Commission Payment" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:incoming>Flow_1csiktc</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0k0njn0</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0v3fgmw">]'
      ,q'[      <bpmn:text>Some BPMN Lanes map nicely to ROLES in your Privilege Management System  (database / OIM / AD, etc.).  But some are more like useful process modelling concepts and aren't useful for routing a particular task to a specific person / group in your organization.]'
      ,q'[]'
      ,q'[Now if you select the LANE Object, look in the Properties Panel under 'APEX Role', and you can see a Switch to denote that this Lane maps to an APEX Role, and if so, allows you to specify the default ROLE that tasks in this lane will be assigned to.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_04blk6w" sourceRef="Activity_047jt22" targetRef="TextAnnotation_0v3fgmw" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_05ia5zp">]'
      ,q'[      <bpmndi:BPMNShape id="Participant_0sxtbbr_di" bpmnElement="Participant_0sxtbbr" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="330" y="120" width="1480" height="760" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_11jtvuj_di" bpmnElement="Lane_11jtvuj" isHorizontal="true" bioc:stroke="#205022" bioc:fill="#c8e6c9" color:background-color="#c8e6c9" color:border-color="#205022">]'
      ,q'[        <dc:Bounds x="360" y="450" width="1450" height="430" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1ok0dgu_di" bpmnElement="Lane_1ok0dgu" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="390" y="690" width="1420" height="190" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_17hsgq6_di" bpmnElement="Lane_17hsgq6" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="390" y="450" width="1420" height="240" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_16vkzwu_di" bpmnElement="Lane_16vkzwu" isHorizontal="true" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="420" y="570" width="1390" height="120" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_0g7r886_di" bpmnElement="Lane_0g7r886" isHorizontal="true" bioc:stroke="#0d4372" bioc:fill="#bbdefb" color:background-color="#bbdefb" color:border-color="#0d4372">]'
      ,q'[        <dc:Bounds x="420" y="450" width="1390" height="120" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1fip85k_di" bpmnElement="Lane_1fip85k" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="360" y="120" width="1450" height="330" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0vw62ey_di" bpmnElement="Event_0vw62ey">]'
      ,q'[        <dc:Bounds x="482" y="282" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_173wq6m_di" bpmnElement="Activity_173wq6m">]'
      ,q'[        <dc:Bounds x="570" y="260" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_022oq4a_di" bpmnElement="Activity_022oq4a">]'
      ,q'[        <dc:Bounds x="1050" y="740" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1xva8lv_di" bpmnElement="Activity_1f73a9g">]'
      ,q'[        <dc:Bounds x="1210" y="740" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0c5yeyr_di" bpmnElement="Event_0c5yeyr">]'
      ,q'[        <dc:Bounds x="1372" y="762" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1lsy29w_di" bpmnElement="Activity_1f18qvf">]'
      ,q'[        <dc:Bounds x="730" y="470" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0kto05l_di" bpmnElement="Activity_047jt22">]'
      ,q'[        <dc:Bounds x="890" y="590" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0v3fgmw_di" bpmnElement="TextAnnotation_0v3fgmw">]'
      ,q'[        <dc:Bounds x="980" y="230" width="520" height="150" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0sm1nql_di" bpmnElement="Flow_0sm1nql">]'
      ,q'[        <di:waypoint x="518" y="300" />]'
      ,q'[        <di:waypoint x="570" y="300" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0ufs4r3_di" bpmnElement="Flow_0ufs4r3">]'
      ,q'[        <di:waypoint x="670" y="300" />]'
      ,q'[        <di:waypoint x="690" y="300" />]'
      ,q'[        <di:waypoint x="690" y="510" />]'
      ,q'[        <di:waypoint x="730" y="510" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1csiktc_di" bpmnElement="Flow_1csiktc">]'
      ,q'[        <di:waypoint x="830" y="510" />]'
      ,q'[        <di:waypoint x="860" y="510" />]'
      ,q'[        <di:waypoint x="860" y="630" />]'
      ,q'[        <di:waypoint x="890" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0k0njn0_di" bpmnElement="Flow_0k0njn0">]'
      ,q'[        <di:waypoint x="990" y="630" />]'
      ,q'[        <di:waypoint x="1020" y="630" />]'
      ,q'[        <di:waypoint x="1020" y="780" />]'
      ,q'[        <di:waypoint x="1050" y="780" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0it1bo5_di" bpmnElement="Flow_0it1bo5">]'
      ,q'[        <di:waypoint x="1150" y="780" />]'
      ,q'[        <di:waypoint x="1210" y="780" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_03pg83c_di" bpmnElement="Flow_03pg83c">]'
      ,q'[        <di:waypoint x="1310" y="780" />]'
      ,q'[        <di:waypoint x="1372" y="780" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_04blk6w_di" bpmnElement="Association_04blk6w">]'
      ,q'[        <di:waypoint x="949" y="590" />]'
      ,q'[        <di:waypoint x="998" y="380" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Group_1vb8gzv_di" bpmnElement="Group_1vb8gzv" bioc:stroke="#5b176d" bioc:fill="#e1bee7" color:background-color="#e1bee7" color:border-color="#5b176d">]'
      ,q'[        <dc:Bounds x="230" y="410" width="300" height="300" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0qxito5_di" bpmnElement="TextAnnotation_0qxito5">]'
      ,q'[        <dc:Bounds x="-10" y="190" width="260" height="54" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_1b5twef_di" bpmnElement="TextAnnotation_1b5twef">]'
      ,q'[        <dc:Bounds x="640" y="-40" width="520" height="82" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1ffrhyq_di" bpmnElement="Association_1ffrhyq">]'
      ,q'[        <di:waypoint x="236" y="410" />]'
      ,q'[        <di:waypoint x="77" y="244" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_0idyme6_di" bpmnElement="Association_0idyme6">]'
      ,q'[        <di:waypoint x="629" y="260" />]'
      ,q'[        <di:waypoint x="676" y="42" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Tutorial 6b - Lanes and More Lanes',
    pi_dgrm_short_description => 'Flows for APEX BPMN Tutorial - Part 6b - looks in more detail at BPMN lanes, and shows how they can be sub-divided into sub lanes.',
    pi_dgrm_description => '**Introduction to Child Lanes and Role Mapping**

---

Welcome to the Flows for APEX tutorial, where we''ll explore the use of child lanes within a BPMN model and demonstrate how certain lanes can be mapped to APEX roles. This tutorial will help you understand how to structure your processes using lanes and child lanes, providing clear role assignments within your applications.

**Tutorial Overview: My Revenue Process**

In this tutorial, we are focusing on a process model called "My Revenue Process." This model illustrates a streamlined approach to handling sales deals and the subsequent financial processes, like commission payments. By using lanes and sub-lanes (child lanes), you can create a detailed representation of functional roles and responsibilities within your organization.

### Key Concepts:

**Lanes and Child Lanes:**

*   **Lanes:** These are used to represent different departments or functional areas such as Sales and Finance in a process model.
*   **Child Lanes:** These are subdivisions within a parent lane that allow for finer granularity. For example, within the Finance lane, you can have a child lane for the "Revenue Recognition Team."

**Mapping Lanes to APEX Roles:**

*   Lanes can be associated with specific roles defined in your privilege management system (e.g., APEX).
*   This role mapping facilitates task assignment, ensuring that tasks are directed to individuals or teams with the appropriate access and responsibilities.

### Process Flow Explanation:

**Sales Lane:**

*   **Activities:** This lane includes tasks like "Enter Sales Deal" and "Confirm Sales Team Engagement Plan."
*   **APEX Role Mapping:** Not mapped to a specific role in this example, as it is more of a conceptual lane for process illustration.

**Finance Lane:**

**Parent Lane:** Represents the overall Finance department.

**Child Lanes:**

*   **Revenue Recognition Team:**
    *   **Sub-Lanes:**
        *   **Clerk Role:** Mapped to `FIN-REV-REC-CLERK`, responsible for initial tasks in the revenue recognition process.
        *   **Manager Role:** Mapped to `FIN-REV-REC-MANAGER`, focusing on task approval and oversight.
*   **Sales Compensation:**
    *   **Role:** Mapped to `FINANCE-COMP-AP`, handling tasks like "Setup Commission Payment" and "Make Staff Payment."

### Tutorial Steps:

**Creating Lanes and Child Lanes:**

*   In your BPMN tool, define a LaneSet and add lanes such as "Sales" and "Finance."
*   To create child lanes, insert a CHILD LANESET within a parent lane (e.g., within Finance, add a child laneset for the Revenue Recognition Team).

**Assigning APEX Roles:**

*   Select the appropriate lane or sub-lane.
*   In the Properties Panel, specify if the lane maps to an APEX Role.
*   Choose the default ROLE for tasks in this lane (e.g., `FIN-REV-REC-CLERK` for the Clerk sub-lane).

**Utilizing Lanes in Process Design:**

*   Use lanes to assign tasks to the right roles to ensure streamlined task routing and execution.
*   Review the process flow ensuring all activities are logically connected and assigned to the correct lanes/sub-lanes.

By the end of this tutorial, you should be able to effectively utilize lanes and child lanes in Flows for APEX, create logical process structures and ensure appropriate task assignments through role mapping. This enables a more organized and role-specific workflow execution within your organization''s processes.',
    pi_dgrm_icon => 'fa-notebook fam-information fam-is-info',
    pi_dgrm_version => '25.1',
    pi_dgrm_category => 'Tutorials',
    pi_dgrm_content => l_dgrm_content
);
end;
/

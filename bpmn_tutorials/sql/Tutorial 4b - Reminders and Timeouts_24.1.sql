declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="24.1.0">]'
      ,q'[  <bpmn:process id="Process_Tutorial_4b" name="Tutorial 4b - Timer Boundary Events" isExecutable="true" apex:isCallable="false" apex:isStartable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_063wz8j" name="Start 4b">]'
      ,q'[      <bpmn:outgoing>Flow_03t16bn</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_0a56gp5" name="Concept 1:&#10;Setting Reminders">]'
      ,q'[      <bpmn:incoming>Flow_03t16bn</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1kxjxrj</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_03t16bn" sourceRef="Event_063wz8j" targetRef="Activity_0a56gp5" />]'
      ,q'[    <bpmn:task id="Activity_0aiaz74" name="Do Homework">]'
      ,q'[      <bpmn:incoming>Flow_1kxjxrj</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_031kd26</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1kxjxrj" sourceRef="Activity_0a56gp5" targetRef="Activity_0aiaz74" />]'
      ,q'[    <bpmn:boundaryEvent id="Event_0m96t82" name="Non Interrupting Timer (20sec)" cancelActivity="false" attachedToRef="Activity_0aiaz74">]'
      ,q'[      <bpmn:outgoing>Flow_07810n8</bpmn:outgoing>]'
      ,q'[      <bpmn:timerEventDefinition id="TimerEventDefinition_05trzil">]'
      ,q'[        <bpmn:timeDuration xsi:type="bpmn:tFormalExpression">PT20S</bpmn:timeDuration>]'
      ,q'[      </bpmn:timerEventDefinition>]'
      ,q'[    </bpmn:boundaryEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_07810n8" sourceRef="Event_0m96t82" targetRef="Activity_0qo0apq" />]'
      ,q'[    <bpmn:endEvent id="Event_0v5aniw" name="Reminder Sent">]'
      ,q'[      <bpmn:incoming>Flow_110va1r</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_110va1r" sourceRef="Activity_0qo0apq" targetRef="Event_0v5aniw" />]'
      ,q'[    <bpmn:scriptTask id="Activity_0qo0apq" name="Send Reminder" apex:type="executePlsql">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:executePlsql>]'
      ,q'[          <apex:plsqlCode>null;</apex:plsqlCode>]'
      ,q'[        </apex:executePlsql>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_07810n8</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_110va1r</bpmn:outgoing>]'
      ,q'[    </bpmn:scriptTask>]'
      ,q'[    <bpmn:task id="Activity_07yt4el" name="Concept 2: Time-outs or Deadlines">]'
      ,q'[      <bpmn:incoming>Flow_031kd26</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0wu1yf9</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_031kd26" sourceRef="Activity_0aiaz74" targetRef="Activity_07yt4el" />]'
      ,q'[    <bpmn:task id="Activity_1x99lgf" name="Submit budget">]'
      ,q'[      <bpmn:incoming>Flow_0wu1yf9</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1mqgk8a</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0wu1yf9" sourceRef="Activity_07yt4el" targetRef="Activity_1x99lgf" />]'
      ,q'[    <bpmn:boundaryEvent id="Event_1kdqlxk" name="Interrupting Timer (20 sec)" attachedToRef="Activity_1x99lgf">]'
      ,q'[      <bpmn:outgoing>Flow_1oasbbc</bpmn:outgoing>]'
      ,q'[      <bpmn:timerEventDefinition id="TimerEventDefinition_15c4olo">]'
      ,q'[        <bpmn:timeDuration xsi:type="bpmn:tFormalExpression">PT20S</bpmn:timeDuration>]'
      ,q'[      </bpmn:timerEventDefinition>]'
      ,q'[    </bpmn:boundaryEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1oasbbc" name="Time-Out Path" sourceRef="Event_1kdqlxk" targetRef="Activity_1iauqss" />]'
      ,q'[    <bpmn:exclusiveGateway id="Gateway_1vauko0">]'
      ,q'[      <bpmn:incoming>Flow_1mqgk8a</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_0cwunbe</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0mm3511</bpmn:outgoing>]'
      ,q'[    </bpmn:exclusiveGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1mqgk8a" name="Usual Path" sourceRef="Activity_1x99lgf" targetRef="Gateway_1vauko0" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0cwunbe" sourceRef="Activity_1iauqss" targetRef="Gateway_1vauko0" />]'
      ,q'[    <bpmn:task id="Activity_1qsrfjy" name="Concept 3:">]'
      ,q'[      <bpmn:incoming>Flow_0mm3511</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1fsfn01</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0mm3511" sourceRef="Gateway_1vauko0" targetRef="Activity_1qsrfjy" apex:sequence="10" />]'
      ,q'[    <bpmn:scriptTask id="Activity_1iauqss" name="Default Budget Submitted" apex:type="executePlsql">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:executePlsql>]'
      ,q'[          <apex:plsqlCode>null;</apex:plsqlCode>]'
      ,q'[        </apex:executePlsql>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1oasbbc</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0cwunbe</bpmn:outgoing>]'
      ,q'[    </bpmn:scriptTask>]'
      ,q'[    <bpmn:endEvent id="Event_02k0a5w" name="End 4b">]'
      ,q'[      <bpmn:incoming>Flow_1fsfn01</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1fsfn01" sourceRef="Activity_1qsrfjy" targetRef="Event_02k0a5w" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0a1jfb0">]'
      ,q'[      <bpmn:text>Tutorial 4b: Timer Boundary Events]'
      ,q'[]'
      ,q'[What happens if your task sits there and doesn't get completed?]'
      ,q'[]'
      ,q'[Boundary Events allow you to attach an event to a Task, in this case 'Do Homework'.  This Boundary Event is defined as a Non-Interrupting Timer Boundary Event - which is a very long way to say that if the task is not completed by a certain time, a new path gets started which doesn't interrupt the original task.    So if the Homework has not been completed by a specified time, a Reminder is set.   The Homework task remains the current task on its path.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_09shi0r" sourceRef="Event_063wz8j" targetRef="TextAnnotation_0a1jfb0" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0o1h1es">]'
      ,q'[      <bpmn:text>To Add a Non-Interrupting Timer Boundary Event:]'
      ,q'[]'
      ,q'[1.   Drag an Intermediate / Boundary Event from the side toolbar (double circle) onto the Task]'
      ,q'[2.  Use the Spanner Tool to change it to a Timer Boundary Event (Non-Interrupting).]'
      ,q'[3.  Configure the Delay in the Properties Panel.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_08jokvv" sourceRef="Event_0m96t82" targetRef="TextAnnotation_0o1h1es" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_16muge5">]'
      ,q'[      <bpmn:text>Tip:  A Non-Interrupting Timer can be configured to fire repetitively -- so that it continues to send reminders until the task gets done!]'
      ,q'[]'
      ,q'[You can set this reminder to go off, for example, everyday, or every 3* weeks, or upto a maximum of 15* times. (all numbers configurable).]'
      ,q'[]'
      ,q'[Read the documentation pages to see all of the details of how to configure these...</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_0pmrlzv" sourceRef="Event_0m96t82" targetRef="TextAnnotation_16muge5" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_12a9y6k">]'
      ,q'[      <bpmn:text>Our second Timer Boundary Event is an INTERRUPTING one. (Note the circles are solid, unlike the dashed circle for the non-interrupting one).]'
      ,q'[]'
      ,q'[Our business case here is a budget submission process.  If the manager doesn't submit his budget by the task deadline, a default budget is submitted for him instead.]'
      ,q'[]'
      ,q'[So the timer is set to the deadline.]'
      ,q'[]'
      ,q'[When the deadline occurs and the timer fires, the process stops waiting for the 'Submit Budget' task to be completed.  And instead of proceeding on the 'Usual Path', the process goes forward on the 'Time-Out Path' - which executes a Script Task 'Default Budget Submitted' which automatically submits a default budget instead.]'
      ,q'[]'
      ,q'[Interrupting Timers can be used to close submission periods, execute time-outs, etc.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1rfb5m6" sourceRef="Activity_07yt4el" targetRef="TextAnnotation_12a9y6k" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_12bqilh">]'
      ,q'[      <bpmn:text>Here we have only put Timers onto Tasks - but we will see later in the tutorials that these can also be added to Sub Processes and Call Activities...</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_0rh9i9v" sourceRef="Activity_1qsrfjy" targetRef="TextAnnotation_12bqilh" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0597ztx">]'
      ,q'[      <bpmn:text>Try running through this model several times...]'
      ,q'[]'
      ,q'[If you do the Homework Quickly, No Reminder fires.]'
      ,q'[]'
      ,q'[If you leave the Homework for &gt; 20 sec, then refresh - the Reminder path will become active.]'
      ,q'[]'
      ,q'[Submit the Budget in &lt; 20 sec, take the Usual Path.]'
      ,q'[]'
      ,q'[Don't Submit the Budget on time &amp; watch ge default get submitted instead.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_15xdauq" sourceRef="Event_02k0a5w" targetRef="TextAnnotation_0597ztx" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_Tutorial_4b">]'
      ,q'[      <bpmndi:BPMNShape id="Event_063wz8j_di" bpmnElement="Event_063wz8j">]'
      ,q'[        <dc:Bounds x="362" y="532" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="361" y="575" width="38" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0a56gp5_di" bpmnElement="Activity_0a56gp5" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="450" y="510" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0aiaz74_di" bpmnElement="Activity_0aiaz74" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="610" y="510" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0v5aniw_di" bpmnElement="Event_0v5aniw" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="882" y="652" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="864" y="695" width="74" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0nfsr52_di" bpmnElement="Activity_0qo0apq" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="730" y="630" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_07yt4el_di" bpmnElement="Activity_07yt4el" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="960" y="510" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1x99lgf_di" bpmnElement="Activity_1x99lgf" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1200" y="510" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_1vauko0_di" bpmnElement="Gateway_1vauko0" isMarkerVisible="true" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1445" y="525" width="50" height="50" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1qsrfjy_di" bpmnElement="Activity_1qsrfjy" bioc:stroke="#205022" bioc:fill="#c8e6c9" color:background-color="#c8e6c9" color:border-color="#205022">]'
      ,q'[        <dc:Bounds x="1640" y="510" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0yu2m2s_di" bpmnElement="Activity_1iauqss" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1350" y="630" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_02k0a5w_di" bpmnElement="Event_02k0a5w" bioc:stroke="#205022" bioc:fill="#c8e6c9" color:background-color="#c8e6c9" color:border-color="#205022">]'
      ,q'[        <dc:Bounds x="1892" y="532" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1893" y="575" width="35" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0a1jfb0_di" bpmnElement="TextAnnotation_0a1jfb0">]'
      ,q'[        <dc:Bounds x="480" y="60" width="700" height="152" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0o1h1es_di" bpmnElement="TextAnnotation_0o1h1es">]'
      ,q'[        <dc:Bounds x="580" y="250" width="550.9926147460938" height="91.98529052734375" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_16muge5_di" bpmnElement="TextAnnotation_16muge5">]'
      ,q'[        <dc:Bounds x="550" y="760" width="360" height="170" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_12a9y6k_di" bpmnElement="TextAnnotation_12a9y6k">]'
      ,q'[        <dc:Bounds x="1140" y="200" width="490" height="251" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_12bqilh_di" bpmnElement="TextAnnotation_12bqilh">]'
      ,q'[        <dc:Bounds x="1750" y="360" width="220" height="100" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0597ztx_di" bpmnElement="TextAnnotation_0597ztx">]'
      ,q'[        <dc:Bounds x="1890" y="640" width="365.9742431640625" height="174.9816131591797" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0fpbkka_di" bpmnElement="Event_1kdqlxk" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="1232" y="572" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1147" y="596" width="87" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1u7uib4_di" bpmnElement="Event_0m96t82">]'
      ,q'[        <dc:Bounds x="642" y="572" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="542" y="596" width="76" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_03t16bn_di" bpmnElement="Flow_03t16bn">]'
      ,q'[        <di:waypoint x="398" y="550" />]'
      ,q'[        <di:waypoint x="450" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1kxjxrj_di" bpmnElement="Flow_1kxjxrj">]'
      ,q'[        <di:waypoint x="550" y="550" />]'
      ,q'[        <di:waypoint x="610" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_07810n8_di" bpmnElement="Flow_07810n8">]'
      ,q'[        <di:waypoint x="660" y="608" />]'
      ,q'[        <di:waypoint x="660" y="670" />]'
      ,q'[        <di:waypoint x="730" y="670" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_110va1r_di" bpmnElement="Flow_110va1r">]'
      ,q'[        <di:waypoint x="830" y="670" />]'
      ,q'[        <di:waypoint x="882" y="670" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_031kd26_di" bpmnElement="Flow_031kd26">]'
      ,q'[        <di:waypoint x="710" y="550" />]'
      ,q'[        <di:waypoint x="960" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0wu1yf9_di" bpmnElement="Flow_0wu1yf9">]'
      ,q'[        <di:waypoint x="1060" y="550" />]'
      ,q'[        <di:waypoint x="1200" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1oasbbc_di" bpmnElement="Flow_1oasbbc">]'
      ,q'[        <di:waypoint x="1250" y="608" />]'
      ,q'[        <di:waypoint x="1250" y="670" />]'
      ,q'[        <di:waypoint x="1350" y="670" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1265" y="643" width="69" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1mqgk8a_di" bpmnElement="Flow_1mqgk8a">]'
      ,q'[        <di:waypoint x="1300" y="550" />]'
      ,q'[        <di:waypoint x="1445" y="550" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1347" y="532" width="52" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0cwunbe_di" bpmnElement="Flow_0cwunbe">]'
      ,q'[        <di:waypoint x="1450" y="670" />]'
      ,q'[        <di:waypoint x="1470" y="670" />]'
      ,q'[        <di:waypoint x="1470" y="575" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0mm3511_di" bpmnElement="Flow_0mm3511">]'
      ,q'[        <di:waypoint x="1495" y="550" />]'
      ,q'[        <di:waypoint x="1640" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1fsfn01_di" bpmnElement="Flow_1fsfn01">]'
      ,q'[        <di:waypoint x="1740" y="550" />]'
      ,q'[        <di:waypoint x="1892" y="550" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_09shi0r_di" bpmnElement="Association_09shi0r">]'
      ,q'[        <di:waypoint x="381" y="532" />]'
      ,q'[        <di:waypoint x="400" y="136" />]'
      ,q'[        <di:waypoint x="480" y="136" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_08jokvv_di" bpmnElement="Association_08jokvv">]'
      ,q'[        <di:waypoint x="652" y="574" />]'
      ,q'[        <di:waypoint x="520" y="296" />]'
      ,q'[        <di:waypoint x="580" y="296" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_0pmrlzv_di" bpmnElement="Association_0pmrlzv">]'
      ,q'[        <di:waypoint x="648" y="603" />]'
      ,q'[        <di:waypoint x="480" y="787" />]'
      ,q'[        <di:waypoint x="550" y="787" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1rfb5m6_di" bpmnElement="Association_1rfb5m6">]'
      ,q'[        <di:waypoint x="1025" y="510" />]'
      ,q'[        <di:waypoint x="1090" y="340" />]'
      ,q'[        <di:waypoint x="1140" y="340" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_0rh9i9v_di" bpmnElement="Association_0rh9i9v">]'
      ,q'[        <di:waypoint x="1696" y="510" />]'
      ,q'[        <di:waypoint x="1710" y="410" />]'
      ,q'[        <di:waypoint x="1750" y="410" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_15xdauq_di" bpmnElement="Association_15xdauq">]'
      ,q'[        <di:waypoint x="1899" y="564" />]'
      ,q'[        <di:waypoint x="1830" y="655" />]'
      ,q'[        <di:waypoint x="1890" y="655" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Tutorial 4b - Reminders and Timeouts',
    pi_dgrm_version => '24.1',
    pi_dgrm_category => 'Tutorials',
    pi_dgrm_content => l_dgrm_content
);
end;
/
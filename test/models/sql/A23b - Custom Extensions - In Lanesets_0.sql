declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:collaboration id="Collaboration_0ho7t0d">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:customExtension>{"object":"collaboration"}</apex:customExtension>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:participant id="Participant_1qiexsk" name="My Process" processRef="Process_9i61gtwo" />]'
      ,q'[  </bpmn:collaboration>]'
      ,q'[  <bpmn:process id="Process_9i61gtwo" name="Process_A23b" isExecutable="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:customExtension>{"object":"process"}</apex:customExtension>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:laneSet id="LaneSet_1rh04lm">]'
      ,q'[      <bpmn:lane id="Lane_1nhwmfv" name="Sales" apex:isRole="false">]'
      ,q'[        <bpmn:extensionElements>]'
      ,q'[          <apex:customExtension>{"object":"lane"}</apex:customExtension>]'
      ,q'[        </bpmn:extensionElements>]'
      ,q'[        <bpmn:flowNodeRef>Event_startEvent</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_task</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_userTask</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_serviceTask</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_0mhneim</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_timerBE</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_13hzk5f</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[      <bpmn:lane id="Lane_13po8am" name="Finance" apex:isRole="false">]'
      ,q'[        <bpmn:flowNodeRef>Activity_callActivity</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_exclusive</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_parallelGateway</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0f8ir35</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0p52srl</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_EndD</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_sendTask</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0s1satj</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_messageCatch</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_messageThrow</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_inclusiveGateway</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_ICE</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_eventBasedGateway</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_messageCatch2</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_timerICE</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:childLaneSet id="LaneSet_1r9mioi">]'
      ,q'[          <bpmn:lane id="Lane_1b4xxlq" name="AR" apex:isRole="false">]'
      ,q'[            <bpmn:extensionElements>]'
      ,q'[              <apex:customExtension>{"object":"lane"}</apex:customExtension>]'
      ,q'[            </bpmn:extensionElements>]'
      ,q'[            <bpmn:flowNodeRef>Activity_callActivity</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Gateway_exclusive</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_0p52srl</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_EndD</bpmn:flowNodeRef>]'
      ,q'[          </bpmn:lane>]'
      ,q'[          <bpmn:lane id="Lane_0zqczf5" name="AP" apex:isRole="false">]'
      ,q'[            <bpmn:flowNodeRef>Gateway_parallelGateway</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_0f8ir35</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_sendTask</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Activity_0s1satj</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_messageCatch</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_messageThrow</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Gateway_inclusiveGateway</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_ICE</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Gateway_eventBasedGateway</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_messageCatch2</bpmn:flowNodeRef>]'
      ,q'[            <bpmn:flowNodeRef>Event_timerICE</bpmn:flowNodeRef>]'
      ,q'[          </bpmn:lane>]'
      ,q'[        </bpmn:childLaneSet>]'
      ,q'[      </bpmn:lane>]'
      ,q'[    </bpmn:laneSet>]'
      ,q'[    <bpmn:startEvent id="Event_startEvent" name="Start">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"startEvent"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:outgoing>Flow_1n0wbru</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_task" name="task">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"task"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1n0wbru</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0o9xpgd</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1n0wbru" sourceRef="Event_startEvent" targetRef="Activity_task" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0o9xpgd" sourceRef="Activity_task" targetRef="Gateway_exclusive" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_B" name=":F4A$path = &#39;B&#39;" sourceRef="Gateway_exclusive" targetRef="Activity_userTask" apex:sequence="10">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"flowB"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$path = 'B'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:userTask id="Activity_userTask" name="userTask" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"userTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_B</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_11fy01h</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_11fy01h" sourceRef="Activity_userTask" targetRef="Activity_serviceTask" />]'
      ,q'[    <bpmn:serviceTask id="Activity_serviceTask" name="serviceTask" apex:type="executePlsql">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"serviceTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_11fy01h</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1onfvqf</bpmn:outgoing>]'
      ,q'[    </bpmn:serviceTask>]'
      ,q'[    <bpmn:endEvent id="Event_0mhneim" name="EndB">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"endEvent"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1onfvqf</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1onfvqf" sourceRef="Activity_serviceTask" targetRef="Event_0mhneim" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_D" name=":F4A$path = &#39;D&#39;" sourceRef="Gateway_exclusive" targetRef="Activity_0p52srl" apex:sequence="20">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"flowD"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$path = 'D'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:subProcess id="Activity_0p52srl" name="subProcess">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"subProcess"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_D</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0paewmr</bpmn:outgoing>]'
      ,q'[      <bpmn:startEvent id="Event_1po0at6" name="subStart">]'
      ,q'[        <bpmn:outgoing>Flow_1ftxv7c</bpmn:outgoing>]'
      ,q'[      </bpmn:startEvent>]'
      ,q'[      <bpmn:sequenceFlow id="Flow_1ftxv7c" sourceRef="Event_1po0at6" targetRef="Activity_businessRuleTask" />]'
      ,q'[      <bpmn:endEvent id="Event_11h9ord" name="subEnd">]'
      ,q'[        <bpmn:incoming>Flow_0uaf93n</bpmn:incoming>]'
      ,q'[      </bpmn:endEvent>]'
      ,q'[      <bpmn:sequenceFlow id="Flow_0uaf93n" sourceRef="Activity_businessRuleTask" targetRef="Event_11h9ord" />]'
      ,q'[      <bpmn:businessRuleTask id="Activity_businessRuleTask" name="businessRuleTask" apex:type="executePlsql">]'
      ,q'[        <bpmn:extensionElements>]'
      ,q'[          <apex:customExtension>{"object":"businessRuleTask"}</apex:customExtension>]'
      ,q'[        </bpmn:extensionElements>]'
      ,q'[        <bpmn:incoming>Flow_1ftxv7c</bpmn:incoming>]'
      ,q'[        <bpmn:outgoing>Flow_0uaf93n</bpmn:outgoing>]'
      ,q'[      </bpmn:businessRuleTask>]'
      ,q'[    </bpmn:subProcess>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0paewmr" sourceRef="Activity_0p52srl" targetRef="Activity_callActivity" />]'
      ,q'[    <bpmn:callActivity id="Activity_callActivity" name="callActivity" apex:manualInput="false" apex:calledDiagramVersionSelection="latestVersion">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"callActivity"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0paewmr</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0lo519q</bpmn:outgoing>]'
      ,q'[    </bpmn:callActivity>]'
      ,q'[    <bpmn:endEvent id="Event_EndD" name="EndD">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"endEvent"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0lo519q</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0lo519q" sourceRef="Activity_callActivity" targetRef="Event_EndD" />]'
      ,q'[    <bpmn:exclusiveGateway id="Gateway_exclusive" name="exclusiveGateway" default="Flow_D">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"exclusiveGateway"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0o9xpgd</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_B</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_D</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_07b2l54</bpmn:outgoing>]'
      ,q'[    </bpmn:exclusiveGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_07b2l54" sourceRef="Gateway_exclusive" targetRef="Gateway_parallelGateway" apex:sequence="30" />]'
      ,q'[    <bpmn:parallelGateway id="Gateway_parallelGateway" name="parallelGateway">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"parallelGateway"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_07b2l54</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0rn6vdx</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_1lpmk0k</bpmn:outgoing>]'
      ,q'[    </bpmn:parallelGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0rn6vdx" sourceRef="Gateway_parallelGateway" targetRef="Activity_0f8ir35" />]'
      ,q'[    <bpmn:manualTask id="Activity_0f8ir35" name="manualTask">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"manualTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0rn6vdx</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0aan4va</bpmn:outgoing>]'
      ,q'[    </bpmn:manualTask>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1lpmk0k" sourceRef="Gateway_parallelGateway" targetRef="Activity_sendTask" />]'
      ,q'[    <bpmn:sendTask id="Activity_sendTask" name="sendTask" apex:type="basicApexMessage">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"sendTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1lpmk0k</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_08ky0ip</bpmn:outgoing>]'
      ,q'[    </bpmn:sendTask>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_08ky0ip" sourceRef="Activity_sendTask" targetRef="Activity_0s1satj" />]'
      ,q'[    <bpmn:receiveTask id="Activity_0s1satj" name="receiveTask" apex:type="basicApexMessage">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"receiveTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_08ky0ip</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1eimn9s</bpmn:outgoing>]'
      ,q'[    </bpmn:receiveTask>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1eimn9s" sourceRef="Activity_0s1satj" targetRef="Event_messageCatch" />]'
      ,q'[    <bpmn:intermediateCatchEvent id="Event_messageCatch" name="messageCatch" apex:type="basicApexMessage">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"messageCatch"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1eimn9s</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1ycneiw</bpmn:outgoing>]'
      ,q'[      <bpmn:messageEventDefinition id="MessageEventDefinition_1qpiv0y" />]'
      ,q'[    </bpmn:intermediateCatchEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1ycneiw" sourceRef="Event_messageCatch" targetRef="Event_messageThrow" />]'
      ,q'[    <bpmn:intermediateThrowEvent id="Event_messageThrow" name="messageThrow" apex:type="basicApexMessage">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"messageThrow"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1ycneiw</bpmn:incoming>]'
      ,q'[      <bpmn:messageEventDefinition id="MessageEventDefinition_1eb7lxd" />]'
      ,q'[    </bpmn:intermediateThrowEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0aan4va" sourceRef="Activity_0f8ir35" targetRef="Gateway_inclusiveGateway" />]'
      ,q'[    <bpmn:inclusiveGateway id="Gateway_inclusiveGateway" name="inclusiveGateway">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"inclusiveGateway"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0aan4va</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0q0puwi</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_0w9zb7l</bpmn:outgoing>]'
      ,q'[    </bpmn:inclusiveGateway>]'
      ,q'[    <bpmn:intermediateThrowEvent id="Event_ICE" name="ICE">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"ICE"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0q0puwi</bpmn:incoming>]'
      ,q'[    </bpmn:intermediateThrowEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0q0puwi" sourceRef="Gateway_inclusiveGateway" targetRef="Event_ICE" apex:sequence="10" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0w9zb7l" sourceRef="Gateway_inclusiveGateway" targetRef="Gateway_eventBasedGateway" apex:sequence="20" />]'
      ,q'[    <bpmn:eventBasedGateway id="Gateway_eventBasedGateway" name="eventBasedGateway">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"eventBasedGateway"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0w9zb7l</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1twmwb0</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_0xjmsrp</bpmn:outgoing>]'
      ,q'[    </bpmn:eventBasedGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1twmwb0" sourceRef="Gateway_eventBasedGateway" targetRef="Event_messageCatch2" />]'
      ,q'[    <bpmn:intermediateCatchEvent id="Event_messageCatch2" name="messageCatch2" apex:type="basicApexMessage">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"messageCatch2"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_1twmwb0</bpmn:incoming>]'
      ,q'[      <bpmn:messageEventDefinition id="MessageEventDefinition_163jb3h" />]'
      ,q'[    </bpmn:intermediateCatchEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0xjmsrp" sourceRef="Gateway_eventBasedGateway" targetRef="Event_timerICE" />]'
      ,q'[    <bpmn:intermediateCatchEvent id="Event_timerICE" name="timerICE">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"timerICE"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0xjmsrp</bpmn:incoming>]'
      ,q'[      <bpmn:timerEventDefinition id="TimerEventDefinition_0xgmy3g" />]'
      ,q'[    </bpmn:intermediateCatchEvent>]'
      ,q'[    <bpmn:boundaryEvent id="Event_timerBE" name="timerBE" attachedToRef="Activity_userTask">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:customExtension>{"object":"timerBE"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:outgoing>Flow_03p3lhl</bpmn:outgoing>]'
      ,q'[      <bpmn:timerEventDefinition id="TimerEventDefinition_1rkslz4" />]'
      ,q'[    </bpmn:boundaryEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_03p3lhl" sourceRef="Event_timerBE" targetRef="Activity_13hzk5f" />]'
      ,q'[    <bpmn:scriptTask id="Activity_13hzk5f" name="scriptTask" apex:type="executePlsql">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:executePlsql>]'
      ,q'[          <apex:plsqlCode>null;</apex:plsqlCode>]'
      ,q'[        </apex:executePlsql>]'
      ,q'[        <apex:customExtension>{"object":"scriptTask"}</apex:customExtension>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_03p3lhl</bpmn:incoming>]'
      ,q'[    </bpmn:scriptTask>]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_0ho7t0d">]'
      ,q'[      <bpmndi:BPMNShape id="Participant_1qiexsk_di" bpmnElement="Participant_1qiexsk" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="225" y="162" width="1075" height="748" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_13po8am_di" bpmnElement="Lane_13po8am" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="255" y="440" width="1045" height="470" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_0zqczf5_di" bpmnElement="Lane_0zqczf5" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="285" y="570" width="1015" height="340" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1b4xxlq_di" bpmnElement="Lane_1b4xxlq" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="285" y="440" width="1015" height="130" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1nhwmfv_di" bpmnElement="Lane_1nhwmfv" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="255" y="162" width="1045" height="278" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1acbdcv_di" bpmnElement="Event_startEvent">]'
      ,q'[        <dc:Bounds x="352" y="292" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="358" y="335" width="24" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1eayzsk_di" bpmnElement="Activity_task">]'
      ,q'[        <dc:Bounds x="440" y="270" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0f8hk4b_di" bpmnElement="Activity_userTask">]'
      ,q'[        <dc:Bounds x="700" y="270" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1v1awpc_di" bpmnElement="Activity_serviceTask">]'
      ,q'[        <dc:Bounds x="860" y="270" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0mhneim_di" bpmnElement="Event_0mhneim">]'
      ,q'[        <dc:Bounds x="1022" y="292" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1027" y="335" width="27" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1ev3qgu_di" bpmnElement="Activity_0p52srl">]'
      ,q'[        <dc:Bounds x="700" y="460" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0bwyry3_di" bpmnElement="Activity_callActivity">]'
      ,q'[        <dc:Bounds x="860" y="460" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0ghqgj6_di" bpmnElement="Event_EndD">]'
      ,q'[        <dc:Bounds x="1022" y="482" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1026" y="525" width="28" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_0yy0mfh_di" bpmnElement="Gateway_exclusive" isMarkerVisible="true">]'
      ,q'[        <dc:Bounds x="595" y="475" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="515" y="463" width="89" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_09evqby_di" bpmnElement="Gateway_parallelGateway">]'
      ,q'[        <dc:Bounds x="665" y="675" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="580" y="713" width="79" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0oeev56_di" bpmnElement="Activity_0f8ir35">]'
      ,q'[        <dc:Bounds x="740" y="590" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_048yjg0_di" bpmnElement="Activity_sendTask">]'
      ,q'[        <dc:Bounds x="740" y="770" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0jhmlbn_di" bpmnElement="Activity_0s1satj">]'
      ,q'[        <dc:Bounds x="870" y="770" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0af8woi_di" bpmnElement="Event_messageCatch">]'
      ,q'[        <dc:Bounds x="1002" y="792" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="984" y="835" width="74" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0ul7i0h_di" bpmnElement="Event_messageThrow">]'
      ,q'[        <dc:Bounds x="1102" y="792" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1083" y="835" width="76" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_0omjr77_di" bpmnElement="Gateway_inclusiveGateway">]'
      ,q'[        <dc:Bounds x="865" y="605" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="847" y="581" width="86" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0lhe0hn_di" bpmnElement="Event_ICE">]'
      ,q'[        <dc:Bounds x="942" y="612" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="951" y="655" width="19" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_0s71mky_di" bpmnElement="Gateway_eventBasedGateway">]'
      ,q'[        <dc:Bounds x="995" y="695" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="909" y="686" width="82" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_06fasw2_di" bpmnElement="Event_messageCatch2">]'
      ,q'[        <dc:Bounds x="1102" y="702" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1081" y="745" width="80" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0qbnjfn_di" bpmnElement="Event_timerICE">]'
      ,q'[        <dc:Bounds x="1102" y="612" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1099" y="655" width="43" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0kbwzvz_di" bpmnElement="Activity_13hzk5f">]'
      ,q'[        <dc:Bounds x="1070" y="340" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_16u5wmh_di" bpmnElement="Event_timerBE">]'
      ,q'[        <dc:Bounds x="742" y="332" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="741" y="375" width="40" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1n0wbru_di" bpmnElement="Flow_1n0wbru">]'
      ,q'[        <di:waypoint x="388" y="310" />]'
      ,q'[        <di:waypoint x="440" y="310" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0o9xpgd_di" bpmnElement="Flow_0o9xpgd">]'
      ,q'[        <di:waypoint x="490" y="350" />]'
      ,q'[        <di:waypoint x="490" y="505" />]'
      ,q'[        <di:waypoint x="596" y="501" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1g6zbrf_di" bpmnElement="Flow_B">]'
      ,q'[        <di:waypoint x="620" y="475" />]'
      ,q'[        <di:waypoint x="620" y="310" />]'
      ,q'[        <di:waypoint x="700" y="310" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="602" y="283" width="75" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_11fy01h_di" bpmnElement="Flow_11fy01h">]'
      ,q'[        <di:waypoint x="800" y="310" />]'
      ,q'[        <di:waypoint x="860" y="310" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1onfvqf_di" bpmnElement="Flow_1onfvqf">]'
      ,q'[        <di:waypoint x="960" y="310" />]'
      ,q'[        <di:waypoint x="1022" y="310" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_192jy2b_di" bpmnElement="Flow_D">]'
      ,q'[        <di:waypoint x="645" y="500" />]'
      ,q'[        <di:waypoint x="700" y="500" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="632" y="443" width="76" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0paewmr_di" bpmnElement="Flow_0paewmr">]'
      ,q'[        <di:waypoint x="800" y="500" />]'
      ,q'[        <di:waypoint x="860" y="500" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0lo519q_di" bpmnElement="Flow_0lo519q">]'
      ,q'[        <di:waypoint x="960" y="500" />]'
      ,q'[        <di:waypoint x="1022" y="500" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_07b2l54_di" bpmnElement="Flow_07b2l54">]'
      ,q'[        <di:waypoint x="620" y="525" />]'
      ,q'[        <di:waypoint x="620" y="700" />]'
      ,q'[        <di:waypoint x="665" y="700" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0rn6vdx_di" bpmnElement="Flow_0rn6vdx">]'
      ,q'[        <di:waypoint x="690" y="675" />]'
      ,q'[        <di:waypoint x="690" y="630" />]'
      ,q'[        <di:waypoint x="740" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1lpmk0k_di" bpmnElement="Flow_1lpmk0k">]'
      ,q'[        <di:waypoint x="690" y="725" />]'
      ,q'[        <di:waypoint x="690" y="810" />]'
      ,q'[        <di:waypoint x="740" y="810" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_08ky0ip_di" bpmnElement="Flow_08ky0ip">]'
      ,q'[        <di:waypoint x="840" y="810" />]'
      ,q'[        <di:waypoint x="870" y="810" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1eimn9s_di" bpmnElement="Flow_1eimn9s">]'
      ,q'[        <di:waypoint x="970" y="810" />]'
      ,q'[        <di:waypoint x="1002" y="810" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1ycneiw_di" bpmnElement="Flow_1ycneiw">]'
      ,q'[        <di:waypoint x="1038" y="810" />]'
      ,q'[        <di:waypoint x="1102" y="810" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0aan4va_di" bpmnElement="Flow_0aan4va">]'
      ,q'[        <di:waypoint x="840" y="630" />]'
      ,q'[        <di:waypoint x="865" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0q0puwi_di" bpmnElement="Flow_0q0puwi">]'
      ,q'[        <di:waypoint x="915" y="630" />]'
      ,q'[        <di:waypoint x="942" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0w9zb7l_di" bpmnElement="Flow_0w9zb7l">]'
      ,q'[        <di:waypoint x="890" y="655" />]'
      ,q'[        <di:waypoint x="890" y="720" />]'
      ,q'[        <di:waypoint x="995" y="720" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1twmwb0_di" bpmnElement="Flow_1twmwb0">]'
      ,q'[        <di:waypoint x="1045" y="720" />]'
      ,q'[        <di:waypoint x="1102" y="720" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0xjmsrp_di" bpmnElement="Flow_0xjmsrp">]'
      ,q'[        <di:waypoint x="1020" y="695" />]'
      ,q'[        <di:waypoint x="1020" y="630" />]'
      ,q'[        <di:waypoint x="1102" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_03p3lhl_di" bpmnElement="Flow_03p3lhl">]'
      ,q'[        <di:waypoint x="760" y="368" />]'
      ,q'[        <di:waypoint x="760" y="380" />]'
      ,q'[        <di:waypoint x="1070" y="380" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_0afta5x">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_0y2bw5d" bpmnElement="Activity_0p52srl">]'
      ,q'[      <bpmndi:BPMNShape id="Event_1po0at6_di" bpmnElement="Event_1po0at6">]'
      ,q'[        <dc:Bounds x="-488" y="-158" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="-490" y="-115" width="41" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_11h9ord_di" bpmnElement="Event_11h9ord">]'
      ,q'[        <dc:Bounds x="-248" y="-158" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="-249" y="-115" width="38" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0n4k1wl_di" bpmnElement="Activity_businessRuleTask">]'
      ,q'[        <dc:Bounds x="-400" y="-180" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1ftxv7c_di" bpmnElement="Flow_1ftxv7c">]'
      ,q'[        <di:waypoint x="-452" y="-140" />]'
      ,q'[        <di:waypoint x="-400" y="-140" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0uaf93n_di" bpmnElement="Flow_0uaf93n">]'
      ,q'[        <di:waypoint x="-300" y="-140" />]'
      ,q'[        <di:waypoint x="-248" y="-140" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A23b - Custom Extensions - In Lanesets',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content
);
end;
/
declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:collaboration id="Collaboration_7a">]'
      ,q'[    <bpmn:participant id="Participant_11y0cdc" name="My Process" processRef="Tutorial_7a" />]'
      ,q'[    <bpmn:participant id="Participant_1n4c4l0" name="This is an &#39;Empty Pool&#39; and represents another process as a &#39;Black Box&#39; - i.e., we don&#39;t know about the internal implementation details." />]'
      ,q'[    <bpmn:participant id="Participant_0qabxrw" name="Another Empty Pool..." />]'
      ,q'[    <bpmn:messageFlow id="Flow_1mf0t72" sourceRef="Activity_0izlkl1" targetRef="Participant_1n4c4l0" />]'
      ,q'[    <bpmn:messageFlow id="Flow_19l2sy0" sourceRef="Participant_1n4c4l0" targetRef="Activity_0izlkl1" />]'
      ,q'[    <bpmn:messageFlow id="Flow_0hqqiiu" sourceRef="Activity_0mhkzh2" targetRef="Participant_1n4c4l0" />]'
      ,q'[    <bpmn:messageFlow id="Flow_1rtp00p" sourceRef="Participant_1n4c4l0" targetRef="Activity_0zzol2u" />]'
      ,q'[    <bpmn:messageFlow id="Flow_1h2ekkn" sourceRef="Event_0m1a6k2" targetRef="Participant_0qabxrw" />]'
      ,q'[    <bpmn:messageFlow id="Flow_13gq3gc" sourceRef="Participant_0qabxrw" targetRef="Event_02gdru8" />]'
      ,q'[  </bpmn:collaboration>]'
      ,q'[  <bpmn:process id="Tutorial_7a" name="Tutorial 7a - MessageFlow Basics" isExecutable="false">]'
      ,q'[    <bpmn:laneSet id="LaneSet_0zv5eda">]'
      ,q'[      <bpmn:lane id="Lane_136ry9p" apex:isRole="false">]'
      ,q'[        <bpmn:flowNodeRef>Event_0s323xl</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0izlkl1</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_1u4gq6u</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_1gb2wji</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0mhkzh2</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_12krons</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0zzol2u</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_1cmxdp7</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Gateway_0zba19v</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0s2za6d</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[      <bpmn:lane id="Lane_0uo74go" apex:isRole="false">]'
      ,q'[        <bpmn:flowNodeRef>Event_0m1a6k2</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0fixygu</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_02gdru8</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_04nvebw</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_0t1ev9d</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_1id6b5x</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[    </bpmn:laneSet>]'
      ,q'[    <bpmn:startEvent id="Event_0s323xl">]'
      ,q'[      <bpmn:outgoing>Flow_17b6g1h</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_0izlkl1" name="Messageflow allows you to pass messages into or out of a process">]'
      ,q'[      <bpmn:incoming>Flow_17b6g1h</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0xtgyk0</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_17b6g1h" sourceRef="Event_0s323xl" targetRef="Activity_0izlkl1" />]'
      ,q'[    <bpmn:task id="Activity_1u4gq6u" name="A Receiver subscribes to a message then waits for it to arrive">]'
      ,q'[      <bpmn:incoming>Flow_0xtgyk0</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1bw7mvj</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0xtgyk0" sourceRef="Activity_0izlkl1" targetRef="Activity_1u4gq6u" />]'
      ,q'[    <bpmn:exclusiveGateway id="Gateway_1gb2wji">]'
      ,q'[      <bpmn:incoming>Flow_1bw7mvj</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0a9vat2</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_111ldh8</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_0wa3yvx</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_1u9z9zl</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_02w8qhh</bpmn:outgoing>]'
      ,q'[    </bpmn:exclusiveGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1bw7mvj" sourceRef="Activity_1u4gq6u" targetRef="Gateway_1gb2wji" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0a9vat2" sourceRef="Gateway_1gb2wji" targetRef="Activity_0mhkzh2" apex:sequence="10" />]'
      ,q'[    <bpmn:sendTask id="Activity_0mhkzh2" name="SendTask" apex:type="simpleMessage">]'
      ,q'[      <bpmn:incoming>Flow_0a9vat2</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1co4h5b</bpmn:outgoing>]'
      ,q'[    </bpmn:sendTask>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_111ldh8" sourceRef="Gateway_1gb2wji" targetRef="Activity_0zzol2u" apex:sequence="20" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0wa3yvx" sourceRef="Gateway_1gb2wji" targetRef="Event_0m1a6k2" apex:sequence="30" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1u9z9zl" sourceRef="Gateway_1gb2wji" targetRef="Event_02gdru8" apex:sequence="40" />]'
      ,q'[    <bpmn:intermediateThrowEvent id="Event_0m1a6k2" name="Message Throw Event" apex:type="simpleMessage">]'
      ,q'[      <bpmn:incoming>Flow_0wa3yvx</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0umsd4h</bpmn:outgoing>]'
      ,q'[      <bpmn:messageEventDefinition id="MessageEventDefinition_0v9snn7" />]'
      ,q'[    </bpmn:intermediateThrowEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_02w8qhh" sourceRef="Gateway_1gb2wji" targetRef="Activity_0fixygu" apex:sequence="50" />]'
      ,q'[    <bpmn:task id="Activity_0fixygu" name="..or you can use message Events (better practice)">]'
      ,q'[      <bpmn:incoming>Flow_02w8qhh</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1pxnz40</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1co4h5b" sourceRef="Activity_0mhkzh2" targetRef="Gateway_12krons" />]'
      ,q'[    <bpmn:exclusiveGateway id="Gateway_12krons">]'
      ,q'[      <bpmn:incoming>Flow_1co4h5b</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_149xi7o</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_1pxnz40</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_0umsd4h</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_0vmcx38</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0g67vgs</bpmn:outgoing>]'
      ,q'[    </bpmn:exclusiveGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_149xi7o" sourceRef="Activity_0zzol2u" targetRef="Gateway_12krons" apex:sequence="10" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1pxnz40" sourceRef="Activity_0fixygu" targetRef="Gateway_12krons" apex:sequence="10" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0umsd4h" sourceRef="Event_0m1a6k2" targetRef="Gateway_12krons" apex:sequence="10" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0vmcx38" sourceRef="Event_02gdru8" targetRef="Gateway_12krons" apex:sequence="10" />]'
      ,q'[    <bpmn:receiveTask id="Activity_0zzol2u" name="ReceiveTask" apex:type="simpleMessage">]'
      ,q'[      <bpmn:incoming>Flow_111ldh8</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_149xi7o</bpmn:outgoing>]'
      ,q'[    </bpmn:receiveTask>]'
      ,q'[    <bpmn:intermediateCatchEvent id="Event_02gdru8" name="Message Catch Event" apex:type="simpleMessage">]'
      ,q'[      <bpmn:incoming>Flow_1u9z9zl</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0vmcx38</bpmn:outgoing>]'
      ,q'[      <bpmn:messageEventDefinition id="MessageEventDefinition_10qaiem" />]'
      ,q'[    </bpmn:intermediateCatchEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1inbmjx" sourceRef="Gateway_0zba19v" targetRef="Activity_1cmxdp7" apex:sequence="10" />]'
      ,q'[    <bpmn:task id="Activity_1cmxdp7" name="A Message Has to exactly match the subscription created for it">]'
      ,q'[      <bpmn:incoming>Flow_1inbmjx</bpmn:incoming>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0g67vgs" sourceRef="Gateway_12krons" targetRef="Gateway_0zba19v" apex:sequence="20" />]'
      ,q'[    <bpmn:parallelGateway id="Gateway_0zba19v">]'
      ,q'[      <bpmn:incoming>Flow_0g67vgs</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1inbmjx</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_0p4dldk</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_05lb32a</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_1h798dh</bpmn:outgoing>]'
      ,q'[    </bpmn:parallelGateway>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0p4dldk" sourceRef="Gateway_0zba19v" targetRef="Activity_0s2za6d" />]'
      ,q'[    <bpmn:task id="Activity_0s2za6d" name="A subscription must be created by the receiver before the message is sent">]'
      ,q'[      <bpmn:incoming>Flow_0p4dldk</bpmn:incoming>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_05lb32a" sourceRef="Gateway_0zba19v" targetRef="Activity_04nvebw" />]'
      ,q'[    <bpmn:task id="Activity_04nvebw" name="in 23.1 message flow is only between processes in the same workspace">]'
      ,q'[      <bpmn:incoming>Flow_05lb32a</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0vmjyh0</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0vmjyh0" sourceRef="Activity_04nvebw" targetRef="Activity_0t1ev9d" />]'
      ,q'[    <bpmn:task id="Activity_0t1ev9d" name="....but we hope to add more capabilities soon!">]'
      ,q'[      <bpmn:incoming>Flow_0vmjyh0</bpmn:incoming>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:task id="Activity_1id6b5x" name="Tutorials 7b and 7c can be run to show message flow..">]'
      ,q'[      <bpmn:incoming>Flow_1h798dh</bpmn:incoming>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1h798dh" sourceRef="Gateway_0zba19v" targetRef="Activity_1id6b5x" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0iqi3gb">]'
      ,q'[      <bpmn:text>MessageFlow only works BETWEEN processes and CANNOT be used WITHIN a process - where you use Sequence Flow (solid lines)</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_10wi0mu" sourceRef="Activity_0izlkl1" targetRef="TextAnnotation_0iqi3gb" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0g76b8t">]'
      ,q'[      <bpmn:text>Don't run this tutorial.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_055qq8e" sourceRef="Event_0s323xl" targetRef="TextAnnotation_0g76b8t" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_7a">]'
      ,q'[      <bpmndi:BPMNShape id="Participant_11y0cdc_di" bpmnElement="Participant_11y0cdc" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="210" y="340" width="1430" height="570" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_136ry9p_di" bpmnElement="Lane_136ry9p" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="240" y="340" width="1400" height="275" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_0uo74go_di" bpmnElement="Lane_0uo74go" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="240" y="615" width="1400" height="295" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0iqi3gb_di" bpmnElement="TextAnnotation_0iqi3gb">]'
      ,q'[        <dc:Bounds x="340" y="660" width="160" height="96" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0g76b8t_di" bpmnElement="TextAnnotation_0g76b8t">]'
      ,q'[        <dc:Bounds x="260" y="380" width="100" height="40" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0s323xl_di" bpmnElement="Event_0s323xl">]'
      ,q'[        <dc:Bounds x="282" y="502" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0izlkl1_di" bpmnElement="Activity_0izlkl1">]'
      ,q'[        <dc:Bounds x="370" y="480" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1u4gq6u_di" bpmnElement="Activity_1u4gq6u">]'
      ,q'[        <dc:Bounds x="530" y="480" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_1gb2wji_di" bpmnElement="Gateway_1gb2wji" isMarkerVisible="true">]'
      ,q'[        <dc:Bounds x="695" y="495" width="50" height="50" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1cxnaxb_di" bpmnElement="Activity_0mhkzh2">]'
      ,q'[        <dc:Bounds x="780" y="360" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1euj7p8_di" bpmnElement="Event_0m1a6k2">]'
      ,q'[        <dc:Bounds x="782" y="722" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="830" y="746" width="79" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0fixygu_di" bpmnElement="Activity_0fixygu">]'
      ,q'[        <dc:Bounds x="780" y="620" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_12krons_di" bpmnElement="Gateway_12krons" isMarkerVisible="true">]'
      ,q'[        <dc:Bounds x="955" y="495" width="50" height="50" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1jcn5z7_di" bpmnElement="Activity_0zzol2u">]'
      ,q'[        <dc:Bounds x="830" y="480" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0vatlax_di" bpmnElement="Event_02gdru8">]'
      ,q'[        <dc:Bounds x="882" y="812" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="881" y="775.5" width="77" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1cmxdp7_di" bpmnElement="Activity_1cmxdp7">]'
      ,q'[        <dc:Bounds x="1220" y="410" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_04a3o2p_di" bpmnElement="Gateway_0zba19v">]'
      ,q'[        <dc:Bounds x="1055" y="495" width="50" height="50" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0s2za6d_di" bpmnElement="Activity_0s2za6d">]'
      ,q'[        <dc:Bounds x="1220" y="530" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_04nvebw_di" bpmnElement="Activity_04nvebw">]'
      ,q'[        <dc:Bounds x="1220" y="650" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0t1ev9d_di" bpmnElement="Activity_0t1ev9d">]'
      ,q'[        <dc:Bounds x="1360" y="650" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1id6b5x_di" bpmnElement="Activity_1id6b5x">]'
      ,q'[        <dc:Bounds x="1220" y="810" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_10wi0mu_di" bpmnElement="Association_10wi0mu">]'
      ,q'[        <di:waypoint x="412" y="560" />]'
      ,q'[        <di:waypoint x="393" y="660" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_055qq8e_di" bpmnElement="Association_055qq8e">]'
      ,q'[        <di:waypoint x="293" y="503" />]'
      ,q'[        <di:waypoint x="260" y="420" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_17b6g1h_di" bpmnElement="Flow_17b6g1h">]'
      ,q'[        <di:waypoint x="318" y="520" />]'
      ,q'[        <di:waypoint x="370" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0xtgyk0_di" bpmnElement="Flow_0xtgyk0">]'
      ,q'[        <di:waypoint x="470" y="520" />]'
      ,q'[        <di:waypoint x="530" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1bw7mvj_di" bpmnElement="Flow_1bw7mvj">]'
      ,q'[        <di:waypoint x="630" y="520" />]'
      ,q'[        <di:waypoint x="695" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0a9vat2_di" bpmnElement="Flow_0a9vat2">]'
      ,q'[        <di:waypoint x="720" y="495" />]'
      ,q'[        <di:waypoint x="720" y="400" />]'
      ,q'[        <di:waypoint x="780" y="400" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_111ldh8_di" bpmnElement="Flow_111ldh8">]'
      ,q'[        <di:waypoint x="745" y="520" />]'
      ,q'[        <di:waypoint x="830" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0wa3yvx_di" bpmnElement="Flow_0wa3yvx">]'
      ,q'[        <di:waypoint x="720" y="545" />]'
      ,q'[        <di:waypoint x="720" y="740" />]'
      ,q'[        <di:waypoint x="782" y="740" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1u9z9zl_di" bpmnElement="Flow_1u9z9zl">]'
      ,q'[        <di:waypoint x="720" y="545" />]'
      ,q'[        <di:waypoint x="720" y="830" />]'
      ,q'[        <di:waypoint x="882" y="830" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_02w8qhh_di" bpmnElement="Flow_02w8qhh">]'
      ,q'[        <di:waypoint x="720" y="545" />]'
      ,q'[        <di:waypoint x="720" y="660" />]'
      ,q'[        <di:waypoint x="780" y="660" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1co4h5b_di" bpmnElement="Flow_1co4h5b">]'
      ,q'[        <di:waypoint x="880" y="400" />]'
      ,q'[        <di:waypoint x="980" y="400" />]'
      ,q'[        <di:waypoint x="980" y="495" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_149xi7o_di" bpmnElement="Flow_149xi7o">]'
      ,q'[        <di:waypoint x="930" y="520" />]'
      ,q'[        <di:waypoint x="955" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1pxnz40_di" bpmnElement="Flow_1pxnz40">]'
      ,q'[        <di:waypoint x="880" y="660" />]'
      ,q'[        <di:waypoint x="980" y="660" />]'
      ,q'[        <di:waypoint x="980" y="545" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0umsd4h_di" bpmnElement="Flow_0umsd4h">]'
      ,q'[        <di:waypoint x="818" y="740" />]'
      ,q'[        <di:waypoint x="980" y="740" />]'
      ,q'[        <di:waypoint x="980" y="545" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0vmcx38_di" bpmnElement="Flow_0vmcx38">]'
      ,q'[        <di:waypoint x="918" y="830" />]'
      ,q'[        <di:waypoint x="980" y="830" />]'
      ,q'[        <di:waypoint x="980" y="545" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1inbmjx_di" bpmnElement="Flow_1inbmjx">]'
      ,q'[        <di:waypoint x="1080" y="495" />]'
      ,q'[        <di:waypoint x="1080" y="450" />]'
      ,q'[        <di:waypoint x="1220" y="450" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0g67vgs_di" bpmnElement="Flow_0g67vgs">]'
      ,q'[        <di:waypoint x="1005" y="520" />]'
      ,q'[        <di:waypoint x="1055" y="520" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0p4dldk_di" bpmnElement="Flow_0p4dldk">]'
      ,q'[        <di:waypoint x="1080" y="545" />]'
      ,q'[        <di:waypoint x="1080" y="570" />]'
      ,q'[        <di:waypoint x="1220" y="570" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_05lb32a_di" bpmnElement="Flow_05lb32a">]'
      ,q'[        <di:waypoint x="1080" y="545" />]'
      ,q'[        <di:waypoint x="1080" y="690" />]'
      ,q'[        <di:waypoint x="1220" y="690" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0vmjyh0_di" bpmnElement="Flow_0vmjyh0">]'
      ,q'[        <di:waypoint x="1320" y="690" />]'
      ,q'[        <di:waypoint x="1360" y="690" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1h798dh_di" bpmnElement="Flow_1h798dh">]'
      ,q'[        <di:waypoint x="1080" y="545" />]'
      ,q'[        <di:waypoint x="1080" y="850" />]'
      ,q'[        <di:waypoint x="1220" y="850" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Participant_0wxmvig_di" bpmnElement="Participant_1n4c4l0" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="210" y="230" width="1240" height="60" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Participant_1hmqsf2_di" bpmnElement="Participant_0qabxrw" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="210" y="990" width="1240" height="90" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1mf0t72_di" bpmnElement="Flow_1mf0t72">]'
      ,q'[        <di:waypoint x="400" y="480" />]'
      ,q'[        <di:waypoint x="400" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_19l2sy0_di" bpmnElement="Flow_19l2sy0">]'
      ,q'[        <di:waypoint x="440" y="290" />]'
      ,q'[        <di:waypoint x="440" y="480" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0hqqiiu_di" bpmnElement="Flow_0hqqiiu">]'
      ,q'[        <di:waypoint x="830" y="360" />]'
      ,q'[        <di:waypoint x="830" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1rtp00p_di" bpmnElement="Flow_1rtp00p">]'
      ,q'[        <di:waypoint x="900" y="290" />]'
      ,q'[        <di:waypoint x="900" y="480" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1h2ekkn_di" bpmnElement="Flow_1h2ekkn">]'
      ,q'[        <di:waypoint x="800" y="758" />]'
      ,q'[        <di:waypoint x="800" y="990" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_13gq3gc_di" bpmnElement="Flow_13gq3gc">]'
      ,q'[        <di:waypoint x="900" y="990" />]'
      ,q'[        <di:waypoint x="900" y="848" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Tutorial 7a - MessageFlow Concepts',
    pi_dgrm_version => '23.1',
    pi_dgrm_category => 'Tutorials',
    pi_dgrm_content => l_dgrm_content
);
end;
/

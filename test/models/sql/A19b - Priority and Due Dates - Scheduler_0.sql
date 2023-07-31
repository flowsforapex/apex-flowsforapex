declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:process id="Process_A19b" name="A19b - Priority and Due Dates - Scheduler" isExecutable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:priority>]'
      ,q'[        <apex:expressionType>static</apex:expressionType>]'
      ,q'[        <apex:expression>3</apex:expression>]'
      ,q'[      </apex:priority>]'
      ,q'[      <apex:dueOn>]'
      ,q'[        <apex:expressionType>oracleScheduler</apex:expressionType>]'
      ,q'[        <apex:expression>FREQ=HOURLY;INTERVAL=5</apex:expression>]'
      ,q'[      </apex:dueOn>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:startEvent id="Event_0jpu8h5" name="start">]'
      ,q'[      <bpmn:outgoing>Flow_1t6bruk</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_1t6bruk</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1dmebxb</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1t6bruk" sourceRef="Event_0jpu8h5" targetRef="Activity_A" />]'
      ,q'[    <bpmn:endEvent id="Event_0ys24c1" name="end">]'
      ,q'[      <bpmn:incoming>Flow_1dmebxb</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1dmebxb" sourceRef="Activity_A" targetRef="Event_0ys24c1" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_A19b">]'
      ,q'[      <bpmndi:BPMNShape id="Event_0jpu8h5_di" bpmnElement="Event_0jpu8h5">]'
      ,q'[        <dc:Bounds x="332" y="272" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="339" y="315" width="22" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1sxned1_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="420" y="250" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0ys24c1_di" bpmnElement="Event_0ys24c1">]'
      ,q'[        <dc:Bounds x="572" y="272" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="581" y="315" width="19" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1t6bruk_di" bpmnElement="Flow_1t6bruk">]'
      ,q'[        <di:waypoint x="368" y="290" />]'
      ,q'[        <di:waypoint x="420" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1dmebxb_di" bpmnElement="Flow_1dmebxb">]'
      ,q'[        <di:waypoint x="520" y="290" />]'
      ,q'[        <di:waypoint x="572" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A19b - Priority and Due Dates - Scheduler',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:process id="Process_A19d" name="A19d - Priority and Due Dates - Proc Var" isExecutable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:priority>]'
      ,q'[        <apex:expressionType>processVariable</apex:expressionType>]'
      ,q'[        <apex:expression>My_Priority</apex:expression>]'
      ,q'[      </apex:priority>]'
      ,q'[      <apex:dueOn>]'
      ,q'[        <apex:expressionType>processVariable</apex:expressionType>]'
      ,q'[        <apex:expression>My_Deadline</apex:expression>]'
      ,q'[      </apex:dueOn>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_061z8w3</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_061z8w3</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1g6sfix</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_061z8w3" sourceRef="Event_Start" targetRef="Activity_A" />]'
      ,q'[    <bpmn:endEvent id="Event_End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_1g6sfix</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1g6sfix" sourceRef="Activity_A" targetRef="Event_End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_A19d">]'
      ,q'[      <bpmndi:BPMNShape id="Event_1rp939d_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="422" y="332" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="428" y="375" width="24" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1jtuexd_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="510" y="310" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0akvgzs_di" bpmnElement="Event_End">]'
      ,q'[        <dc:Bounds x="662" y="332" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="670" y="375" width="20" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_061z8w3_di" bpmnElement="Flow_061z8w3">]'
      ,q'[        <di:waypoint x="458" y="350" />]'
      ,q'[        <di:waypoint x="510" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1g6sfix_di" bpmnElement="Flow_1g6sfix">]'
      ,q'[        <di:waypoint x="610" y="350" />]'
      ,q'[        <di:waypoint x="662" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A19d - Priority and Due Dates - Proc Var',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content
);
end;
/

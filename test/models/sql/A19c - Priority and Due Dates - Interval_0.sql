declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:collaboration id="Collaboration_1j0a7z3">]'
      ,q'[    <bpmn:participant id="Participant_0wdmhml" name="My Participation" processRef="Process_19c" />]'
      ,q'[  </bpmn:collaboration>]'
      ,q'[  <bpmn:process id="Process_19c" name="A19c - Priority and Due Dates - Interval" isExecutable="false" apex:manualInput="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:priority>]'
      ,q'[        <apex:expressionType>static</apex:expressionType>]'
      ,q'[        <apex:expression>5</apex:expression>]'
      ,q'[      </apex:priority>]'
      ,q'[      <apex:dueOn>]'
      ,q'[        <apex:expressionType>interval</apex:expressionType>]'
      ,q'[        <apex:expression>P1D</apex:expression>]'
      ,q'[      </apex:dueOn>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_1to5sre</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_1to5sre</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0g1bc72</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1to5sre" sourceRef="Event_Start" targetRef="Activity_A" />]'
      ,q'[    <bpmn:endEvent id="Event_End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_0g1bc72</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0g1bc72" sourceRef="Activity_A" targetRef="Event_End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_1j0a7z3">]'
      ,q'[      <bpmndi:BPMNShape id="Participant_0wdmhml_di" bpmnElement="Participant_0wdmhml" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="420" y="170" width="600" height="250" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1rasel7_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="532" y="272" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="538" y="315" width="24" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1m6tmwl_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="620" y="250" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1vqb732_di" bpmnElement="Event_End">]'
      ,q'[        <dc:Bounds x="772" y="272" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="781" y="315" width="20" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1to5sre_di" bpmnElement="Flow_1to5sre">]'
      ,q'[        <di:waypoint x="568" y="290" />]'
      ,q'[        <di:waypoint x="620" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0g1bc72_di" bpmnElement="Flow_0g1bc72">]'
      ,q'[        <di:waypoint x="720" y="290" />]'
      ,q'[        <di:waypoint x="772" y="290" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A19c - Priority and Due Dates - Interval',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

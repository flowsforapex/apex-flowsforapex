declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.1.0">]'
      ,q'[  <bpmn:process id="Process_0rxermh" isExecutable="false">]'
      ,q'[    <bpmn:startEvent id="Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_0e7q139</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_0e7q139</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0i5wcjm</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0e7q139" sourceRef="Start" targetRef="A" />]'
      ,q'[    <bpmn:task id="B" name="B">]'
      ,q'[      <bpmn:incoming>Flow_0i5wcjm</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0e53n28</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0i5wcjm" sourceRef="A" targetRef="B" />]'
      ,q'[    <bpmn:endEvent id="End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_0e53n28</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0e53n28" sourceRef="B" targetRef="End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_0rxermh">]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0e7q139_di" bpmnElement="Flow_0e7q139">]'
      ,q'[        <di:waypoint x="208" y="260" />]'
      ,q'[        <di:waypoint x="310" y="260" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0i5wcjm_di" bpmnElement="Flow_0i5wcjm">]'
      ,q'[        <di:waypoint x="410" y="260" />]'
      ,q'[        <di:waypoint x="490" y="260" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0e53n28_di" bpmnElement="Flow_0e53n28">]'
      ,q'[        <di:waypoint x="590" y="260" />]'
      ,q'[        <di:waypoint x="682" y="260" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0fhqg78_di" bpmnElement="Start">]'
      ,q'[        <dc:Bounds x="172" y="242" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="178" y="285" width="24" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0ajtv1q_di" bpmnElement="A">]'
      ,q'[        <dc:Bounds x="310" y="220" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0ky6p0n_di" bpmnElement="B">]'
      ,q'[        <dc:Bounds x="490" y="220" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0wbyjbg_di" bpmnElement="End">]'
      ,q'[        <dc:Bounds x="682" y="242" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="691" y="285" width="19" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A04a - Basic Model',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content
);
end;
/

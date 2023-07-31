declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:apex="https://flowsforapex.org" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.1.0">]'
      ,q'[  <bpmn:process id="Process_Test_03a" name="Test Start with no Start Event" isExecutable="false" apex:isCallable="false" apex:manualInput="false">]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:outgoing>Flow_0pfvqri</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:endEvent id="Event_EndA" name="End A">]'
      ,q'[      <bpmn:incoming>Flow_0pfvqri</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0pfvqri" sourceRef="Activity_A" targetRef="Event_EndA" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_Test_03a">]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0pfvqri_di" bpmnElement="Flow_0pfvqri">]'
      ,q'[        <di:waypoint x="430" y="440" />]'
      ,q'[        <di:waypoint x="482" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0klbm0x_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="330" y="400" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0v82hni_di" bpmnElement="Event_EndA">]'
      ,q'[        <dc:Bounds x="482" y="422" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="486" y="465" width="29" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A03a - Model with No Start Event',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.2.0">]'
      ,q'[  <bpmn:process id="Process_V" name="Process V" isExecutable="false" apex:isCallable="false" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_StartV" name="StartV">]'
      ,q'[      <bpmn:outgoing>Flow_0vyk8y4</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_V1" name="V1">]'
      ,q'[      <bpmn:incoming>Flow_0vyk8y4</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_15v9ikf</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0vyk8y4" sourceRef="Event_StartV" targetRef="Activity_V1" />]'
      ,q'[    <bpmn:endEvent id="Event_EndV" name="EndV">]'
      ,q'[      <bpmn:incoming>Flow_15v9ikf</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_15v9ikf" sourceRef="Activity_V1" targetRef="Event_EndV" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_V">]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0vyk8y4_di" bpmnElement="Flow_0vyk8y4">]'
      ,q'[        <di:waypoint x="418" y="530" />]'
      ,q'[        <di:waypoint x="470" y="530" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_15v9ikf_di" bpmnElement="Flow_15v9ikf">]'
      ,q'[        <di:waypoint x="570" y="530" />]'
      ,q'[        <di:waypoint x="622" y="530" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_17aiqrl_di" bpmnElement="Event_StartV">]'
      ,q'[        <dc:Bounds x="382" y="512" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="385" y="555" width="30" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0obcc4o_di" bpmnElement="Activity_V1">]'
      ,q'[        <dc:Bounds x="470" y="490" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0tv3n6x_di" bpmnElement="Event_EndV">]'
      ,q'[        <dc:Bounds x="622" y="512" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="627" y="555" width="26" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A09v - Called Non-Callable Model',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

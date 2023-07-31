declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.2.0">]'
      ,q'[  <bpmn:process id="Process_T" name="Process T" isExecutable="false" apex:isCallable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_StartT" name="StartT">]'
      ,q'[      <bpmn:outgoing>Flow_0vyk8y4</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0vyk8y4" sourceRef="Event_StartT" targetRef="Activity_CallR" />]'
      ,q'[    <bpmn:endEvent id="Event_EndT" name="EndT">]'
      ,q'[      <bpmn:incoming>Flow_15v9ikf</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_15v9ikf" sourceRef="Activity_CallR" targetRef="Event_EndT" />]'
      ,q'[    <bpmn:callActivity id="Activity_CallR" name="CallR" apex:manualInput="false" apex:calledDiagram="A09r - Recursive Chain RSTR Top" apex:calledDiagramVersionSelection="latestVersion">]'
      ,q'[      <bpmn:incoming>Flow_0vyk8y4</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_15v9ikf</bpmn:outgoing>]'
      ,q'[    </bpmn:callActivity>]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_T">]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_15v9ikf_di" bpmnElement="Flow_15v9ikf">]'
      ,q'[        <di:waypoint x="570" y="530" />]'
      ,q'[        <di:waypoint x="622" y="530" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0vyk8y4_di" bpmnElement="Flow_0vyk8y4">]'
      ,q'[        <di:waypoint x="418" y="530" />]'
      ,q'[        <di:waypoint x="470" y="530" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_17aiqrl_di" bpmnElement="Event_StartT">]'
      ,q'[        <dc:Bounds x="382" y="512" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="387" y="555" width="29" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0tv3n6x_di" bpmnElement="Event_EndT">]'
      ,q'[        <dc:Bounds x="622" y="512" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="630" y="555" width="26" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_09is0yx_di" bpmnElement="Activity_CallR">]'
      ,q'[        <dc:Bounds x="470" y="490" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A09t - Recursive Chain RSTR Bottom',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

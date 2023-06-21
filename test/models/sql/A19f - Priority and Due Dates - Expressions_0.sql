declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:process id="Process_A19f" name="A19f - Priority and Due Dates - Expressions" isExecutable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:extensionElements>]'
      ,q'[      <apex:priority>]'
      ,q'[        <apex:expressionType>plsqlRawExpression</apex:expressionType>]'
      ,q'[        <apex:expression>(2+2)/2+1</apex:expression>]'
      ,q'[      </apex:priority>]'
      ,q'[      <apex:dueOn>]'
      ,q'[        <apex:expressionType>plsqlRawExpression</apex:expressionType>]'
      ,q'[        <apex:expression>to_timestamp_tz('2023-06-21 23:59:59 AMERICA/LOS_ANGELES','YYYY-MM-DD HH24:MI:SS TZR') + to_dsinterval('010 06:00:00')]'
      ,q'[</apex:expression>]'
      ,q'[      </apex:dueOn>]'
      ,q'[    </bpmn:extensionElements>]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_1glrne1</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_1glrne1</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_18wgddz</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1glrne1" sourceRef="Event_Start" targetRef="Activity_A" />]'
      ,q'[    <bpmn:endEvent id="Event_End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_18wgddz</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_18wgddz" sourceRef="Activity_A" targetRef="Event_End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_A19f">]'
      ,q'[      <bpmndi:BPMNShape id="Event_1r74j9c_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="352" y="352" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="358" y="395" width="24" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0v2ucpo_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="440" y="330" width="100" height="80" />]'
      ,q'[        <bpmndi:BPMNLabel />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1a4yofo_di" bpmnElement="Event_End">]'
      ,q'[        <dc:Bounds x="592" y="352" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="600" y="395" width="20" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1glrne1_di" bpmnElement="Flow_1glrne1">]'
      ,q'[        <di:waypoint x="388" y="370" />]'
      ,q'[        <di:waypoint x="440" y="370" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_18wgddz_di" bpmnElement="Flow_18wgddz">]'
      ,q'[        <di:waypoint x="540" y="370" />]'
      ,q'[        <di:waypoint x="592" y="370" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A19f - Priority and Due Dates - Expressions',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content
);
end;
/

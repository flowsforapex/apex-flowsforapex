declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="23.1.0">]'
      ,q'[  <bpmn:process id="Process_NoLanesCallsLanes" name="No Lanes Calls Lanes" isExecutable="false" apex:isCallable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_07ridqj</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_07ridqj" sourceRef="Event_Start" targetRef="Activity_X" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0sdat5i" sourceRef="Activity_X" targetRef="Activity_YCall" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0ddttlp" sourceRef="Activity_YCall" targetRef="Activity_Z" />]'
      ,q'[    <bpmn:endEvent id="Event_End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_19re1gj</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_19re1gj" sourceRef="Activity_Z" targetRef="Event_End" />]'
      ,q'[    <bpmn:callActivity id="Activity_YCall" name="YCall" apex:manualInput="false" apex:calledDiagram="A06c - Lanes and Assignment - Lanes with SubProcs" apex:calledDiagramVersionSelection="latestVersion">]'
      ,q'[      <bpmn:incoming>Flow_0sdat5i</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0ddttlp</bpmn:outgoing>]'
      ,q'[    </bpmn:callActivity>]'
      ,q'[    <bpmn:userTask id="Activity_X" name="X" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:apexPage>]'
      ,q'[          <apex:applicationId>100</apex:applicationId>]'
      ,q'[          <apex:pageId>3</apex:pageId>]'
      ,q'[        </apex:apexPage>]'
      ,q'[        <apex:potentialUsers>]'
      ,q'[          <apex:expressionType>sqlQuerySingle</apex:expressionType>]'
      ,q'[          <apex:expression>select 'BILL:TED' as value]'
      ,q'[from dual;</apex:expression>]'
      ,q'[        </apex:potentialUsers>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_07ridqj</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0sdat5i</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[    <bpmn:userTask id="Activity_Z" name="Z" apex:type="apexPage" apex:manualInput="false">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:apexPage>]'
      ,q'[          <apex:applicationId>100</apex:applicationId>]'
      ,q'[          <apex:pageId>3</apex:pageId>]'
      ,q'[        </apex:apexPage>]'
      ,q'[        <apex:potentialUsers>]'
      ,q'[          <apex:expressionType>static</apex:expressionType>]'
      ,q'[          <apex:expression>REAPER</apex:expression>]'
      ,q'[        </apex:potentialUsers>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_0ddttlp</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_19re1gj</bpmn:outgoing>]'
      ,q'[    </bpmn:userTask>]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_NoLanesCallsLanes">]'
      ,q'[      <bpmndi:BPMNShape id="Event_0kij9in_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="202" y="332" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="209" y="375" width="23" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1fd3gql_di" bpmnElement="Event_End">]'
      ,q'[        <dc:Bounds x="772" y="332" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="781" y="375" width="19" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_04qxrwa_di" bpmnElement="Activity_YCall">]'
      ,q'[        <dc:Bounds x="450" y="310" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0cwei30_di" bpmnElement="Activity_X">]'
      ,q'[        <dc:Bounds x="290" y="310" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0pw1baq_di" bpmnElement="Activity_Z">]'
      ,q'[        <dc:Bounds x="610" y="310" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_07ridqj_di" bpmnElement="Flow_07ridqj">]'
      ,q'[        <di:waypoint x="238" y="350" />]'
      ,q'[        <di:waypoint x="290" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0sdat5i_di" bpmnElement="Flow_0sdat5i">]'
      ,q'[        <di:waypoint x="390" y="350" />]'
      ,q'[        <di:waypoint x="450" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0ddttlp_di" bpmnElement="Flow_0ddttlp">]'
      ,q'[        <di:waypoint x="550" y="350" />]'
      ,q'[        <di:waypoint x="610" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_19re1gj_di" bpmnElement="Flow_19re1gj">]'
      ,q'[        <di:waypoint x="710" y="350" />]'
      ,q'[        <di:waypoint x="772" y="350" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A06e - Lanes and Assignment - No Lanes calls Laned Dgrm',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

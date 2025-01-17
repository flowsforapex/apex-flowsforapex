declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:apex="https://flowsforapex.org" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.2.0">]'
      ,q'[  <bpmn:collaboration id="Collaboration_02j4aad">]'
      ,q'[    <bpmn:participant id="Participant_Z" name="ParticipantZ" processRef="Process_TwoLanes" />]'
      ,q'[  </bpmn:collaboration>]'
      ,q'[  <bpmn:process id="Process_TwoLanes" name="TwoLanes" isExecutable="false" apex:isCallable="true" apex:manualInput="false">]'
      ,q'[    <bpmn:laneSet id="LaneSet_08p8mf1">]'
      ,q'[      <bpmn:lane id="Lane_X" name="LaneX">]'
      ,q'[        <bpmn:flowNodeRef>Activity_A</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Event_Start</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[      <bpmn:lane id="Lane_Y" name="LaneY">]'
      ,q'[        <bpmn:flowNodeRef>Event_End</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_Y</bpmn:flowNodeRef>]'
      ,q'[        <bpmn:flowNodeRef>Activity_B</bpmn:flowNodeRef>]'
      ,q'[      </bpmn:lane>]'
      ,q'[    </bpmn:laneSet>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_10nm1ff" sourceRef="Activity_B" targetRef="Activity_Y" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0ik3brk" sourceRef="Activity_A" targetRef="Activity_B" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_00a38h7" sourceRef="Event_Start" targetRef="Activity_A" />]'
      ,q'[    <bpmn:subProcess id="Activity_B" name="B">]'
      ,q'[      <bpmn:incoming>Flow_0ik3brk</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_10nm1ff</bpmn:outgoing>]'
      ,q'[      <bpmn:startEvent id="Event_BStart" name="B Start">]'
      ,q'[        <bpmn:outgoing>Flow_1v90qkk</bpmn:outgoing>]'
      ,q'[      </bpmn:startEvent>]'
      ,q'[      <bpmn:sequenceFlow id="Flow_1v90qkk" sourceRef="Event_BStart" targetRef="Activity_B1" />]'
      ,q'[      <bpmn:subProcess id="Activity_B2" name="B2">]'
      ,q'[        <bpmn:incoming>Flow_12edai9</bpmn:incoming>]'
      ,q'[        <bpmn:outgoing>Flow_19fnup4</bpmn:outgoing>]'
      ,q'[        <bpmn:startEvent id="Event_B2Start" name="B2Start">]'
      ,q'[          <bpmn:outgoing>Flow_1kyqvsw</bpmn:outgoing>]'
      ,q'[        </bpmn:startEvent>]'
      ,q'[        <bpmn:sequenceFlow id="Flow_1kyqvsw" sourceRef="Event_B2Start" targetRef="Activity_Call15a" />]'
      ,q'[        <bpmn:sequenceFlow id="Flow_0ye62pn" sourceRef="Activity_Call15a" targetRef="Event_B2End" />]'
      ,q'[        <bpmn:endEvent id="Event_B2End" name="B2End">]'
      ,q'[          <bpmn:incoming>Flow_0ye62pn</bpmn:incoming>]'
      ,q'[        </bpmn:endEvent>]'
      ,q'[        <bpmn:callActivity id="Activity_Call15a" name="Call 15a" apex:calledDiagram="A15a - Single Diagram Lanes with SubProcs" apex:calledDiagramVersionSelection="latestVersion">]'
      ,q'[          <bpmn:incoming>Flow_1kyqvsw</bpmn:incoming>]'
      ,q'[          <bpmn:outgoing>Flow_0ye62pn</bpmn:outgoing>]'
      ,q'[        </bpmn:callActivity>]'
      ,q'[      </bpmn:subProcess>]'
      ,q'[      <bpmn:task id="Activity_B1" name="B1">]'
      ,q'[        <bpmn:incoming>Flow_1v90qkk</bpmn:incoming>]'
      ,q'[        <bpmn:outgoing>Flow_12edai9</bpmn:outgoing>]'
      ,q'[      </bpmn:task>]'
      ,q'[      <bpmn:sequenceFlow id="Flow_12edai9" sourceRef="Activity_B1" targetRef="Activity_B2" />]'
      ,q'[      <bpmn:endEvent id="Event_BEnd" name="BEnd">]'
      ,q'[        <bpmn:incoming>Flow_19fnup4</bpmn:incoming>]'
      ,q'[      </bpmn:endEvent>]'
      ,q'[      <bpmn:sequenceFlow id="Flow_19fnup4" sourceRef="Activity_B2" targetRef="Event_BEnd" />]'
      ,q'[    </bpmn:subProcess>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_00a38h7</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0ik3brk</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_00a38h7</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:endEvent id="Event_End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_0l9b8zn</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:task id="Activity_Y" name="Y">]'
      ,q'[      <bpmn:incoming>Flow_10nm1ff</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0l9b8zn</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0l9b8zn" sourceRef="Activity_Y" targetRef="Event_End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_02j4aad">]'
      ,q'[      <bpmndi:BPMNShape id="Participant_1sy8ges_di" bpmnElement="Participant_Z" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="110" y="190" width="1480" height="730" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1lhp1iy_di" bpmnElement="Lane_Y" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="140" y="430" width="1450" height="490" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Lane_1u0o7by_di" bpmnElement="Lane_X" isHorizontal="true">]'
      ,q'[        <dc:Bounds x="140" y="190" width="1450" height="240" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0l9b8zn_di" bpmnElement="Flow_0l9b8zn">]'
      ,q'[        <di:waypoint x="1470" y="710" />]'
      ,q'[        <di:waypoint x="1522" y="710" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_00a38h7_di" bpmnElement="Flow_00a38h7">]'
      ,q'[        <di:waypoint x="238" y="320" />]'
      ,q'[        <di:waypoint x="270" y="320" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0ik3brk_di" bpmnElement="Flow_0ik3brk">]'
      ,q'[        <di:waypoint x="320" y="360" />]'
      ,q'[        <di:waypoint x="320" y="630" />]'
      ,q'[        <di:waypoint x="420" y="630" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_10nm1ff_di" bpmnElement="Flow_10nm1ff">]'
      ,q'[        <di:waypoint x="1320" y="710" />]'
      ,q'[        <di:waypoint x="1370" y="710" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0i6y1bh_di" bpmnElement="Activity_B" isExpanded="true">]'
      ,q'[        <dc:Bounds x="420" y="540" width="900" height="320" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_19fnup4_di" bpmnElement="Flow_19fnup4">]'
      ,q'[        <di:waypoint x="1150" y="670" />]'
      ,q'[        <di:waypoint x="1222" y="670" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_12edai9_di" bpmnElement="Flow_12edai9">]'
      ,q'[        <di:waypoint x="630" y="600" />]'
      ,q'[        <di:waypoint x="710" y="600" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1v90qkk_di" bpmnElement="Flow_1v90qkk">]'
      ,q'[        <di:waypoint x="498" y="600" />]'
      ,q'[        <di:waypoint x="530" y="600" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1uc2r9j_di" bpmnElement="Event_BStart">]'
      ,q'[        <dc:Bounds x="462" y="582" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="463" y="625" width="33" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_13btp5y_di" bpmnElement="Activity_B2" isExpanded="true">]'
      ,q'[        <dc:Bounds x="710" y="570" width="440" height="230" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0ye62pn_di" bpmnElement="Flow_0ye62pn">]'
      ,q'[        <di:waypoint x="990" y="670" />]'
      ,q'[        <di:waypoint x="1092" y="670" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1kyqvsw_di" bpmnElement="Flow_1kyqvsw">]'
      ,q'[        <di:waypoint x="788" y="670" />]'
      ,q'[        <di:waypoint x="890" y="670" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1u3ia93_di" bpmnElement="Event_B2Start">]'
      ,q'[        <dc:Bounds x="752" y="652" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="753" y="695" width="36" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0330g94_di" bpmnElement="Event_B2End">]'
      ,q'[        <dc:Bounds x="1092" y="652" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1094" y="695" width="32" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_073pnto_di" bpmnElement="Activity_Call15a">]'
      ,q'[        <dc:Bounds x="890" y="630" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0pba0eg_di" bpmnElement="Activity_B1">]'
      ,q'[        <dc:Bounds x="530" y="560" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1n0l2hv_di" bpmnElement="Event_BEnd">]'
      ,q'[        <dc:Bounds x="1222" y="652" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1228" y="695" width="26" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0hq9g3i_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="270" y="280" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0syqjwb_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="202" y="302" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="209" y="345" width="23" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0oulqoo_di" bpmnElement="Event_End">]'
      ,q'[        <dc:Bounds x="1522" y="692" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1531" y="735" width="19" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0gpcwxh_di" bpmnElement="Activity_Y">]'
      ,q'[        <dc:Bounds x="1370" y="670" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A15d - Calling Diagram with Lanes',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
);
end;
/

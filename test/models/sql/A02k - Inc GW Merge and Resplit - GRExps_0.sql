declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:apex="https://flowsforapex.org" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="22.2.0">]'
      ,q'[  <bpmn:process id="Process_12i" name="Test Model 12i - Merge Split Inc Gateways" isExecutable="false" apex:isCallable="false" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_194r471</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_194r471" sourceRef="Event_Start" targetRef="Activity_Pre" />]'
      ,q'[    <bpmn:inclusiveGateway id="Gateway_Split" name="Gateway Split">]'
      ,q'[      <bpmn:incoming>Flow_0wbb8yo</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_X</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_Y</bpmn:outgoing>]'
      ,q'[    </bpmn:inclusiveGateway>]'
      ,q'[    <bpmn:task id="Activity_X" name="X">]'
      ,q'[      <bpmn:incoming>Flow_X</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0xmwnsp</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_X" name=":F4A$GW_Split_Var like &#39;%X%&#39;" sourceRef="Gateway_Split" targetRef="Activity_X" apex:sequence="20">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$GW_Split_Var like '%X%'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0xmwnsp" sourceRef="Activity_X" targetRef="Gateway_MergeSplit" />]'
      ,q'[    <bpmn:inclusiveGateway id="Gateway_MergeSplit" name="Gateway MergeSplit">]'
      ,q'[      <bpmn:incoming>Flow_0xmwnsp</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_01prxwy</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_B</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_C</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_A</bpmn:outgoing>]'
      ,q'[    </bpmn:inclusiveGateway>]'
      ,q'[    <bpmn:task id="Activity_Y" name="Y">]'
      ,q'[      <bpmn:incoming>Flow_Y</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_01prxwy</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_Y" name=":F4A$GW_Split_Var like &#39;%Y%&#39;" sourceRef="Gateway_Split" targetRef="Activity_Y" apex:sequence="30">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$GW_Split_Var like '%Y%'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_01prxwy" sourceRef="Activity_Y" targetRef="Gateway_MergeSplit" />]'
      ,q'[    <bpmn:task id="Activity_B" name="B">]'
      ,q'[      <bpmn:incoming>Flow_B</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1x0kegj</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_B" name=":F4A$GW_ReSplit_Var like &#39;%B%&#39;" sourceRef="Gateway_MergeSplit" targetRef="Activity_B" apex:sequence="30">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$GW_ReSplit_Var like '%B%'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:task id="Activity_C" name="C">]'
      ,q'[      <bpmn:incoming>Flow_C</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_1xhau1w</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_C" name=":F4A$GW_ReSplit_Var like &#39;%C%&#39;" sourceRef="Gateway_MergeSplit" targetRef="Activity_C" apex:sequence="40">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$GW_ReSplit_Var like '%C%'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:task id="Activity_A" name="A">]'
      ,q'[      <bpmn:incoming>Flow_A</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_08ltn03</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_A" name=":F4A$GW_ReSplit_Var like &#39;%A%&#39;" sourceRef="Gateway_MergeSplit" targetRef="Activity_A" apex:sequence="10">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression" sequence="10">:F4A$GW_ReSplit_Var like '%A%'</bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      ,q'[    <bpmn:endEvent id="Event_EndA" name="EndA">]'
      ,q'[      <bpmn:incoming>Flow_08ltn03</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_08ltn03" sourceRef="Activity_A" targetRef="Event_EndA" />]'
      ,q'[    <bpmn:endEvent id="Event_EndB" name="EndB">]'
      ,q'[      <bpmn:incoming>Flow_1x0kegj</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1x0kegj" sourceRef="Activity_B" targetRef="Event_EndB" />]'
      ,q'[    <bpmn:endEvent id="Event_EndC" name="EndC">]'
      ,q'[      <bpmn:incoming>Flow_1xhau1w</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_1xhau1w" sourceRef="Activity_C" targetRef="Event_EndC" />]'
      ,q'[    <bpmn:task id="Activity_Pre" name="Activity_Pre">]'
      ,q'[      <bpmn:incoming>Flow_194r471</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0wbb8yo</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0wbb8yo" sourceRef="Activity_Pre" targetRef="Gateway_Split" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_12i">]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0wbb8yo_di" bpmnElement="Flow_0wbb8yo">]'
      ,q'[        <di:waypoint x="340" y="480" />]'
      ,q'[        <di:waypoint x="395" y="480" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0nw9ma2_di" bpmnElement="Flow_A">]'
      ,q'[        <di:waypoint x="725" y="480" />]'
      ,q'[        <di:waypoint x="750" y="480" />]'
      ,q'[        <di:waypoint x="750" y="360" />]'
      ,q'[        <di:waypoint x="890" y="360" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="757" y="333" width="87" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_18utc2b_di" bpmnElement="Flow_C">]'
      ,q'[        <di:waypoint x="725" y="480" />]'
      ,q'[        <di:waypoint x="750" y="480" />]'
      ,q'[        <di:waypoint x="750" y="590" />]'
      ,q'[        <di:waypoint x="890" y="590" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="786" y="563" width="87" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1nowoj9_di" bpmnElement="Flow_B">]'
      ,q'[        <di:waypoint x="725" y="480" />]'
      ,q'[        <di:waypoint x="890" y="480" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="769" y="446" width="87" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_01prxwy_di" bpmnElement="Flow_01prxwy">]'
      ,q'[        <di:waypoint x="660" y="590" />]'
      ,q'[        <di:waypoint x="700" y="590" />]'
      ,q'[        <di:waypoint x="700" y="505" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1k4vll4_di" bpmnElement="Flow_Y">]'
      ,q'[        <di:waypoint x="420" y="505" />]'
      ,q'[        <di:waypoint x="420" y="590" />]'
      ,q'[        <di:waypoint x="560" y="590" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="439" y="545" width="86" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0xmwnsp_di" bpmnElement="Flow_0xmwnsp">]'
      ,q'[        <di:waypoint x="660" y="390" />]'
      ,q'[        <di:waypoint x="700" y="390" />]'
      ,q'[        <di:waypoint x="700" y="455" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1czj7yc_di" bpmnElement="Flow_X">]'
      ,q'[        <di:waypoint x="420" y="455" />]'
      ,q'[        <di:waypoint x="420" y="390" />]'
      ,q'[        <di:waypoint x="560" y="390" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="439" y="346" width="86" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_194r471_di" bpmnElement="Flow_194r471">]'
      ,q'[        <di:waypoint x="178" y="480" />]'
      ,q'[        <di:waypoint x="240" y="480" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1x0kegj_di" bpmnElement="Flow_1x0kegj">]'
      ,q'[        <di:waypoint x="990" y="480" />]'
      ,q'[        <di:waypoint x="1032" y="480" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_1xhau1w_di" bpmnElement="Flow_1xhau1w">]'
      ,q'[        <di:waypoint x="990" y="590" />]'
      ,q'[        <di:waypoint x="1032" y="590" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="912" y="572" width="28" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_08ltn03_di" bpmnElement="Flow_08ltn03">]'
      ,q'[        <di:waypoint x="990" y="360" />]'
      ,q'[        <di:waypoint x="1032" y="360" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNShape id="Event_083kw68_di" bpmnElement="Event_Start">]'
      ,q'[        <dc:Bounds x="142" y="462" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="149" y="505" width="23" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_0mibtpu_di" bpmnElement="Gateway_Split">]'
      ,q'[        <dc:Bounds x="395" y="455" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="337" y="433" width="66" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Gateway_1e99cbp_di" bpmnElement="Gateway_MergeSplit">]'
      ,q'[        <dc:Bounds x="675" y="455" width="50" height="50" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="605" y="466" width="51" height="27" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1lhi4zo_di" bpmnElement="Activity_Pre">]'
      ,q'[        <dc:Bounds x="240" y="440" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_08fxb0u_di" bpmnElement="Activity_X">]'
      ,q'[        <dc:Bounds x="560" y="350" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0sexfio_di" bpmnElement="Activity_Y">]'
      ,q'[        <dc:Bounds x="560" y="550" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0cc3rtq_di" bpmnElement="Activity_B">]'
      ,q'[        <dc:Bounds x="890" y="440" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1ebr62n_di" bpmnElement="Activity_C">]'
      ,q'[        <dc:Bounds x="890" y="550" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1mhvq0l_di" bpmnElement="Activity_A">]'
      ,q'[        <dc:Bounds x="890" y="320" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0mdcz4r_di" bpmnElement="Event_EndA">]'
      ,q'[        <dc:Bounds x="1032" y="342" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1038" y="385" width="26" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_0sfuiu4_di" bpmnElement="Event_EndB">]'
      ,q'[        <dc:Bounds x="1032" y="462" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1038" y="505" width="26" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_1ohlzoq_di" bpmnElement="Event_EndC">]'
      ,q'[        <dc:Bounds x="1032" y="572" width="36" height="36" />]'
      ,q'[        <bpmndi:BPMNLabel>]'
      ,q'[          <dc:Bounds x="1037" y="615" width="27" height="14" />]'
      ,q'[        </bpmndi:BPMNLabel>]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'A02k - Inc GW Merge and Resplit - GRExps',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content
);
end;
/
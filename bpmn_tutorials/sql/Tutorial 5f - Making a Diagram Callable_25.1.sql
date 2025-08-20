declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:apex="https://flowsforapex.org" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="24.1.0">]'
      ,q'[  <bpmn:process id="Process_Tutorial5f" name="Tutorial 5F - Making a Diagram Callable" isExecutable="false" apex:isCallable="false" apex:manualInput="false">]'
      ,q'[    <bpmn:startEvent id="Event_13pm9fl">]'
      ,q'[      <bpmn:outgoing>Flow_0nyyjkj</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="Activity_1w86o6c" name="Step A">]'
      ,q'[      <bpmn:incoming>Flow_0nyyjkj</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0u3mznx</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0nyyjkj" sourceRef="Event_13pm9fl" targetRef="Activity_1w86o6c" />]'
      ,q'[    <bpmn:task id="Activity_0irzelz" name="Step B">]'
      ,q'[      <bpmn:incoming>Flow_175gkh6</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_0jlmtjb</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0u3mznx" sourceRef="Activity_1w86o6c" targetRef="Activity_1kv9zax" />]'
      ,q'[    <bpmn:endEvent id="Event_18an09f">]'
      ,q'[      <bpmn:incoming>Flow_11ko7k8</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_0jlmtjb" sourceRef="Activity_0irzelz" targetRef="Activity_0vygmu9" />]'
      ,q'[    <bpmn:task id="Activity_1kv9zax" name="Set is Callable = Yes">]'
      ,q'[      <bpmn:incoming>Flow_0u3mznx</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_175gkh6</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_175gkh6" sourceRef="Activity_1kv9zax" targetRef="Activity_0irzelz" />]'
      ,q'[    <bpmn:task id="Activity_0vygmu9" name="Set In/Out Variable Specs">]'
      ,q'[      <bpmn:incoming>Flow_0jlmtjb</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_11ko7k8</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_11ko7k8" sourceRef="Activity_0vygmu9" targetRef="Event_18an09f" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_006k1ua">]'
      ,q'[      <bpmn:text>1. Click on the modeler background to select the Process object.]'
      ,q'[2.In the Properties Panel &gt; General -  set Execution - Is Callable to 'yes'</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1bpdyqv" sourceRef="Activity_1kv9zax" targetRef="TextAnnotation_006k1ua" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_1smzwql">]'
      ,q'[      <bpmn:text>In the Properties Panel &gt; In/Out Mapping,]'
      ,q'[define the required Input &amp; Output variables to be passed in and returned after completion.</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1o407ht" sourceRef="Activity_0vygmu9" targetRef="TextAnnotation_1smzwql" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_0prrv7o">]'
      ,q'[      <bpmn:text>Tutorial 5f: Setting a Diagram to be Callable]'
      ,q'[]'
      ,q'[It's very easy to make a diagram callable by other diagrams.....</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_18c814z" sourceRef="Event_13pm9fl" targetRef="TextAnnotation_0prrv7o" />]'
      ,q'[    <bpmn:textAnnotation id="TextAnnotation_16jzotv">]'
      ,q'[      <bpmn:text>experiment by making this diagram callable....</bpmn:text>]'
      ,q'[    </bpmn:textAnnotation>]'
      ,q'[    <bpmn:association id="Association_1wsaj6b" sourceRef="Event_18an09f" targetRef="TextAnnotation_16jzotv" />]'
      ,q'[  </bpmn:process>]'
      ,q'[  <bpmndi:BPMNDiagram id="BPMNDiagram_1">]'
      ,q'[    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_Tutorial5f">]'
      ,q'[      <bpmndi:BPMNShape id="Event_13pm9fl_di" bpmnElement="Event_13pm9fl">]'
      ,q'[        <dc:Bounds x="372" y="422" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1w86o6c_di" bpmnElement="Activity_1w86o6c" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="460" y="400" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0irzelz_di" bpmnElement="Activity_0irzelz" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="815" y="400" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Event_18an09f_di" bpmnElement="Event_18an09f">]'
      ,q'[        <dc:Bounds x="1202" y="422" width="36" height="36" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_1kv9zax_di" bpmnElement="Activity_1kv9zax" bioc:stroke="#6b3c00" bioc:fill="#ffe0b2" color:background-color="#ffe0b2" color:border-color="#6b3c00">]'
      ,q'[        <dc:Bounds x="600" y="400" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="Activity_0vygmu9_di" bpmnElement="Activity_0vygmu9" bioc:stroke="#831311" bioc:fill="#ffcdd2" color:background-color="#ffcdd2" color:border-color="#831311">]'
      ,q'[        <dc:Bounds x="960" y="400" width="100" height="80" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_006k1ua_di" bpmnElement="TextAnnotation_006k1ua">]'
      ,q'[        <dc:Bounds x="710" y="220" width="309.9815979003906" height="67.99632263183594" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_1smzwql_di" bpmnElement="TextAnnotation_1smzwql">]'
      ,q'[        <dc:Bounds x="1080" y="220" width="249.99998474121094" height="67.99632263183594" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_0prrv7o_di" bpmnElement="TextAnnotation_0prrv7o">]'
      ,q'[        <dc:Bounds x="550" y="70" width="589.9999389648438" height="53.98896789550781" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNShape id="TextAnnotation_16jzotv_di" bpmnElement="TextAnnotation_16jzotv">]'
      ,q'[        <dc:Bounds x="1240" y="340" width="99.99999237060547" height="67.99632263183594" />]'
      ,q'[      </bpmndi:BPMNShape>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0nyyjkj_di" bpmnElement="Flow_0nyyjkj">]'
      ,q'[        <di:waypoint x="408" y="440" />]'
      ,q'[        <di:waypoint x="460" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0u3mznx_di" bpmnElement="Flow_0u3mznx">]'
      ,q'[        <di:waypoint x="560" y="440" />]'
      ,q'[        <di:waypoint x="600" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_0jlmtjb_di" bpmnElement="Flow_0jlmtjb">]'
      ,q'[        <di:waypoint x="915" y="440" />]'
      ,q'[        <di:waypoint x="960" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_175gkh6_di" bpmnElement="Flow_175gkh6">]'
      ,q'[        <di:waypoint x="700" y="440" />]'
      ,q'[        <di:waypoint x="815" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Flow_11ko7k8_di" bpmnElement="Flow_11ko7k8">]'
      ,q'[        <di:waypoint x="1060" y="440" />]'
      ,q'[        <di:waypoint x="1202" y="440" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1bpdyqv_di" bpmnElement="Association_1bpdyqv">]'
      ,q'[        <di:waypoint x="671" y="400" />]'
      ,q'[        <di:waypoint x="732" y="288" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1o407ht_di" bpmnElement="Association_1o407ht">]'
      ,q'[        <di:waypoint x="1010" y="400" />]'
      ,q'[        <di:waypoint x="1091" y="288" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_18c814z_di" bpmnElement="Association_18c814z">]'
      ,q'[        <di:waypoint x="399" y="425" />]'
      ,q'[        <di:waypoint x="577" y="124" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[      <bpmndi:BPMNEdge id="Association_1wsaj6b_di" bpmnElement="Association_1wsaj6b">]'
      ,q'[        <di:waypoint x="1231" y="426" />]'
      ,q'[        <di:waypoint x="1246" y="408" />]'
      ,q'[      </bpmndi:BPMNEdge>]'
      ,q'[    </bpmndi:BPMNPlane>]'
      ,q'[  </bpmndi:BPMNDiagram>]'
      ,q'[</bpmn:definitions>]'
      ,q'[]'
  ));
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Tutorial 5f - Making a Diagram Callable',
    pi_dgrm_short_description => 'Flows for APEX BPMN Tutorial - Part 5f - is a simple tutorial to show how a diagram containing a business process can be used as part of other process definitions by making it callable.',
    pi_dgrm_description => '**Making a Diagram Callable**

**Overview:**  
The process described in this BPMN (Business Process Model and Notation) diagram, titled "Tutorial 5F - Making a Diagram Callable," provides a systematic procedure for configuring a BPMN diagram to become callable by other diagrams. This tutorial is designed to guide users through a step-by-step approach to enhance model interoperability within BPMN workflows.

**Process Steps:**

**Initiation:**

*   The process begins with a Start Event, signaling the commencement of making a diagram callable.

**Step A:**

*   Execute the task labeled "Step A," initiating the fundamental changes needed for setup.

**Setting Callable Properties:**

*   The task "Set is Callable = Yes" instructs users to navigate to the Properties Panel and set the Execution parameter to ''Is Callable = Yes.'' This step emphasizes the process object''s selection and adjustment to ensure it can be invoked by other processes.

**In/Out Variable Specifications:**

*   In the task "Set In/Out Variable Specs," users are instructed to define essential input and output variables within the Properties Panel. This step is crucial for establishing the communication protocols necessary for a callable diagram.

**Completion:**

*   The process concludes with an End Event, indicating the successful implementation of a callable configuration, ready to be utilized by other BPMN diagrams.

**Annotations and Notes:**

*   The diagram includes several text annotations offering detailed instructions, such as selecting process objects, specifying input/output mappings, and opening statements regarding the ease and purpose of making a diagram callable.

**Value Proposition:**  
By providing a clear, structured methodology for making BPMN diagrams callable, this tutorial empowers business process designers to enhance workflow flexibility and reusability. It enables the seamless integration of processes, facilitating efficient process execution across various BPMN projects. This capability is particularly valuable for organizations aiming to optimize their business process management by leveraging modular, reusable BPMN components.',
    pi_dgrm_icon => 'fa-notebook fam-information fam-is-info',
    pi_dgrm_version => '25.1',
    pi_dgrm_category => 'Tutorials',
    pi_dgrm_content => l_dgrm_content
);
end;
/

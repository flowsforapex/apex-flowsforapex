-- insert_bpmn_type_data.sql
-- Flows for APEX - insert_bpmn_type_data.sql
--
-- (c) Copyright, Flowquest Limited and / or its affiliates.  2025

-- created 29 July 2025.   Richard Allen, Flowquest
--
-- This script inserts data into the FLOW_BPMN_TYPES table for various BPMN types, and maps BPMN object types to type icons and super-types
--

REM INSERTING into FLOW_BPMN_TYPES

PROMPT >> Recreate FLOW_BPMN_TYPES Data

begin
  delete from flow_bpmn_types;

  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'LINKEND','link end event','bpmn:endEvent','bpmn:linkEventDefinition','bpmn-icon-end-event-link','event','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MSGEND','message end event','bpmn:endEvent','bpmn:messageEventDefinition','bpmn-icon-end-event-message','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TERMEND','terminate end event','bpmn:endEvent','bpmn:terminateEventDefinition','bpmn-icon-end-event-terminate','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'END','end event','bpmn:endEvent', null,'bpmn-icon-end-event-none','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'LINKCATCH','link catch event','bpmn:intermediateCatchEvent','bpmn:linkEventDefinition','bpmn-icon-intermediate-event-catch-link','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'LINKTHROW','link throw event','bpmn:intermediateCatchEvent','bpmn:linkEventDefinition','bpmn-icon-intermediate-event-throw-link','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MSGCATCHICE','intermediate message catch event','bpmn:intermediateCatchEvent','bpmn:messageEventDefinition','bpmn-icon-intermediate-event-catch-message','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TIMERICE','intermediate timer event','bpmn:intermediateCatchEvent','bpmn:timerEventDefinition','bpmn-icon-intermediate-event-catch-timer','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ICE','intermediate catch event','bpmn:intermediateCatchEvent', null,'bpmn-icon-intermediate-event-none','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ESCTHROWICE','intermediate escalation throw event','bpmn:intermediateThrowEvent','bpmn:escalationEventDefinition','bpmn-icon-intermediate-event-throw-escalation','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MSGTHROWICE','intermediate message throw event','bpmn:intermediateThrowEvent','bpmn:messageEventDefinition','bpmn-icon-intermediate-event-throw-message','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ERRSTART','error start event','bpmn:startEvent','bpmn:errorEventDefinition','bpmn-icon-start-event-error','event','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ESCSTART','escalation start event','bpmn:startEvent','bpmn:escalationEventDefinition','bpmn-icon-start-event-escalation','event','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MSGSTART','message start event','bpmn:startEvent','bpmn:messageEventDefinition','bpmn-icon-start-event-message','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TIMSTART','timer start event','bpmn:startEvent','bpmn:timerEventDefinition','bpmn-icon-start-event-timer','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'START','start event','bpmn:startEvent', null,'bpmn-icon-start-event-none','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'COMPGW','complex gateway','bpmn:complexGateway', null,'bpmn-icon-gateway-complex','gateway','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'EBGW','event-based gateway','bpmn:eventBasedGateway', null,'bpmn-icon-gateway-eventbased','gateway','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'EXCGW','exclusive gateway','bpmn:exclusiveGateway', null,'bpmn-icon-gateway-or','gateway','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'GW','gateway','bpmn:gateway', null,'bpmn-icon-gateway-none','gateway','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'INCGW','inclusive gateway','bpmn:inclusiveGateway', null,'bpmn-icon-gateway-xor','gateway','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'PARGW','parallel gateway','bpmn:parallelGateway', null,'bpmn-icon-gateway-parallel','gateway','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ADHOCSP','adhoc sub process','bpmn:adHocSubProcess', null,'bpmn-icon-ad-hoc-marker','activity','N', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'GRP','group','bpmn:group', null,'bpmn-icon-group','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TXTANN','text annotation','bpmn:textAnnotation', null,'bpmn-icon-text-annotation','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'LOOP','loop', null, null,'bpmn-icon-loop-marker','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'PARMI','parallel multi-instance', null, null,'bpmn-icon-parallel-mi-marker','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'SEQMI','sequential multi instance', null, null,'bpmn-icon-sequential-mi-marker','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'DEFAULT','default path', null, null,'bpmn-icon-default-flow','other','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'BRT','business rule task','bpmn:businessRuleTask', null,'bpmn-icon-business-rule-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'CA','call activity','bpmn:callActivity', null,'bpmn-icon-call-activity','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'EVSP','event sub process','bpmn:eventSubProcess', null,'bpmn-icon-event-subprocess-expanded','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MT','manual task','bpmn:manualTask', null,'bpmn-icon-manual-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'RT','receive task','bpmn:receiveTask','bpmn:messageEventDefinition','bpmn-icon-receive-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'SCRIPT','script task','bpmn:scriptTask', null,'bpmn-icon-script-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'SEND','send task','bpmn:sendTask','bpmn:messageEventDefinition','bpmn-icon-send-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'SVC','service task','bpmn:serviceTask', null,'bpmn-icon-service-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'SP','sub process','bpmn:subProcess', null,'bpmn-icon-subprocess-collapsed','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TASK','task','bpmn:task', null,'bpmn-icon-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'UT','user task','bpmn:userTask', null,'bpmn-icon-user-task','activity','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'LANE','lane','bpmn:lane', null,'bpmn-icon-lane','collaboration','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'PART','participant','bpmn:participant', null,'bpmn-icon-participant','collaboration','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'PRCS','process','bpmn:process', null,'bpmn-icon-lane-divide-three','collaboration','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ERRBE','error boundary event','bpmn:boundaryEvent','bpmn:errorEventDefinition','bpmn-icon-intermediate-event-catch-error','event','Y',1);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ESCBE','interrupting escalation boundary event','bpmn:boundaryEvent','bpmn:escalationEventDefinition','bpmn-icon-intermediate-event-catch-escalation','event','Y',1);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'NIESCBE','non-interrupting escalation catch boundary event','bpmn:boundaryEvent','bpmn:escalationEventDefinition','bpmn-icon-intermediate-event-catch-non-interrupting-escalation','event','Y',0);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'NIMSGBE','non-interrupting message catch boundary event','bpmn:boundaryEvent','bpmn:messageEventDefinition','bpmn-icon-intermediate-event-catch-non-interrupting-message','event','Y',0);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'MSGBE','interrupting message catch boundary event','bpmn:boundaryEvent','bpmn:messageEventDefinition','bpmn-icon-intermediate-event-catch-message','event','Y',1);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'NITIMBE','non-interrupting timer boundary event','bpmn:boundaryEvent','bpmn:timerEventDefinition','bpmn-icon-intermediate-event-catch-non-interrupting-timer','event','Y',0);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'TIMBE','interrupting timer boundary event','bpmn:boundaryEvent','bpmn:timerEventDefinition','bpmn-icon-intermediate-event-catch-timer','event','Y',1);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ERREND','error end event','bpmn:endEvent','bpmn:errorEventDefinition','bpmn-icon-end-event-error','event','Y', null);
  insert into FLOW_BPMN_TYPES 
    ( BPMN_CODE,BPMN_OBJECT_NAME,BPMN_TAG_NAME,BPMN_SUB_TAG_NAME,BPMN_ICON,BPMN_SUPER_TYPE,BPMN_IS_SUPPORTED,BPMN_INTERRUPTING )
    values 
    ( 'ESCEND','escalation end event','bpmn:endEvent','bpmn:escalationEventDefinition','bpmn-icon-end-event-escalation','event','Y', null);
  commit;
end;
/

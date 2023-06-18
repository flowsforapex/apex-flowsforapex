create or replace package test_021_messageFlow_basics as
/* 
-- Flows for APEX - test_021_messageFlow_basics.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 17-Apr-2023   Richard Allen - Oracle
--
*/

  -- uses models A21a

  --%suite(21 MessageFlow Basics)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests A: Basic Send to Waiting Catch - With Payload - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(A1 - Send to Receive with Payload)
  procedure basic_receive_send_payload;

  --%test(A2 - ITE to Receive with Payload)
  procedure basic_receive_ITE_payload;

  --%test(A3 - Send to ICE with Payload)
  procedure basic_ICE_send_payload;

  --%test(A4 - ITE to ICE with Payload)
  procedure basic_ICE_ITE_payload;  

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests B: Basic Send to Waiting Catch - Without Payloads - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(B1 - Send to Receive with No Payload)
  procedure basic_receive_send_no_payload;

  --%test(B2 - ITE to Receive with No Payload)
  procedure basic_receive_ITE_no_payload;

  --%test(B3 - Send to ICE with No Payload)
  procedure basic_ICE_send_no_payload;

  --%test(B4 - ITE to ICE with No Payload)
  procedure basic_ICE_ITE_no_payload;  

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests C: Throw to No Catch - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(C1 - Send without Receive with  Payload)
  procedure basic_send_without_receive_payload;

  --%test(C2 - Throw without Receive with  Payload)
  procedure basic_ITE_without_receive_payload;


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests D: Restorability of Send task after non-correlation error fixed
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(D1 - Error Restart after Send without Receive with Payload)
  procedure basic_send_without_receive_payload_restart;

  --%test(D2 - Error restart after Throw without Receive with Payload)
  procedure basic_ITE_without_receive_payload_restart;


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests E: Bad Endpoints on Senders
 -- 
 ---------------------------------------------------------------------------------------------------------------
  
  --%test(E1 - Send with bad endpoint)
  procedure bad_endpoint_send;

 --%test(E2 - Send with bad endpoint)
  procedure bad_endpoint_ITE;

 
 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests F: Mismatched Payloads (send unexpected payload / missing expected payload)
 -- 
 ---------------------------------------------------------------------------------------------------------------
   
  --%test(F1 - Send to Receive with Unexpected Payload)
  procedure basic_receive_send_unexpected_payload;

  --%test(F2 - ITE to ICE with Unexpected Payload)
  procedure basic_ICE_ITE_unexpected_payload;

  --%test(F3 - Send to Receive with Missing Payload)
  procedure basic_receive_send_missing_payload;

  --%test(F4 - ITE to ICE with Missing Payload)
  procedure basic_ICE_ITE_missing_payload;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests G: Basic Send to Waiting Catch - With Payload - All combinations of {send, Throw} to {receive, catch}
 --   (reruns set A with a diagram including Lanes and an empty pool)
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(G1 - Collaboration with Send to Receive with Payload)
  procedure colab_receive_send_payload;

  --%test(G2 - Collaboration with ITE to Receive with Payload)
  procedure colab_receive_ITE_payload;

  --%test(G3 - Collaboration with Send to ICE with Payload)
  procedure colab_ICE_send_payload;

  --%test(G4 - Collaboration with ITE to ICE with Payload)
  procedure colab_ICE_ITE_payload;  


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests H: subscription Cancellation (check subscription gets cancelled when areceive Task gets cancelled)
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(H - Subscription Cancellation)
  procedure subscription_cancellation;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests I: MessageFlow ReceiveTask and ICE Following an Event Based Gateway
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(I1 - Messageflow after EBG - ReceiveTask wins)
  procedure afterEBG_receiveTask;

  --%test(I2 - Messageflow after EBG - MessageICE1 wins)
  procedure afterEBG_messageICE1;

    --%test(I3 - Messageflow after EBG - MessageICE2 wins)
  procedure afterEBG_messageICE2;

    --%test(I4 - Messageflow after EBG - Timer wins)
  procedure afterEBGtimer;

  --%afterall
  procedure tear_down_tests;


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests J: Timer Boundary Events on ReceiveTask
 -- 
 ---------------------------------------------------------------------------------------------------------------

  --%test(J1 - Timer BE on ReceiveTask - both not firing)
  procedure receivetask_timer_be_no_timers;

  --%test(J2 - Timer BE on ReceiveTask - Int Fires)
  procedure receivetask_timer_be_int_timers;

  --%test(J3 - Timer BE on ReceiveTask - NonInt Fires)
  procedure receivetask_timer_be_nonint_timers;

  --%test(J4 - Timer BE on ReceiveTask - Both Fire)
  procedure receivetask_timer_be_both_timers;

end test_021_messageFlow_basics;
/

create or replace package test_helper as
/* 
-- Flows for APEX - test_helper.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright Flowquest Limited and/or its affiliates,  2024.

--
-- Created 18-May-2022   Richard Allen, Oracle
-- Edited  02-Aug-2024   Richard Allen, Flowquest Limited
--
*/

  -- basic model setup and movement

   function set_dgrm_id( pi_dgrm_name in varchar2) 
   return flow_diagrams.dgrm_id%type;

  -- step the model forward (gets the step key & then uses it to step forward)

   procedure step_forward 
   ( pi_prcs_id in  flow_processes.prcs_id%type
   , pi_sbfl_id in  flow_subflows.sbfl_id%type
   );

  -- step the model forward from an object given the object ID
   procedure step_forward 
   ( pi_prcs_id   in  flow_processes.prcs_id%type
   , pi_current   in  flow_subflows.sbfl_current%type
   );

  -- step the model forward from an object given the object ID and iteration ID
   procedure step_forward 
   ( pi_prcs_id         in  flow_processes.prcs_id%type
   , pi_current         in  flow_subflows.sbfl_current%type
   , pi_iteration_path  in  flow_iterations.iter_display_name%type
   );

  -- restart and step the model forward from an object given the object ID
   procedure restart_forward 
   ( pi_prcs_id   in  flow_processes.prcs_id%type
   , pi_current   in  flow_subflows.sbfl_current%type
   );

  -- restart and step the model forward from an object given the subflow ID
   procedure restart_forward 
   ( pi_prcs_id      in  flow_processes.prcs_id%type
   , pi_sbfl_id      in  flow_subflows.sbfl_id%type
   );

  -- get the subflow that has pi_current as the current object.

   function get_sbfl_id
   ( pi_prcs_id       in flow_processes.prcs_id%type
   , pi_current       in flow_objects.objt_bpmn_id%type
   ) return flow_subflows.sbfl_id%type;

   -- check subflow log to see if an object in main diagram has completed

   function has_step_completed 
    ( pi_prcs_id        flow_processes.prcs_id%type
    , pi_objt_bpmn_id   flow_objects.objt_bpmn_id%type
    ) return boolean;   

   -- check subflow log to see if an object in a called activity has completed

   function has_called_step_completed 
    ( pi_prcs_id        flow_processes.prcs_id%type
    , pi_calling_objt   flow_objects.objt_bpmn_id%type
    , pi_objt_bpmn_id   flow_objects.objt_bpmn_id%type
    ) return boolean;

end test_helper;
/
/* 
-- Flows for APEX - test_helper.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2020,2022.
--
-- Created 18-May-2022   Richard Allen, Oracle
--
*/
create or replace package body test_helper as

  -- basic model setup and movement

  function set_dgrm_id
  ( pi_dgrm_name in varchar2
  ) return flow_diagrams.dgrm_id%type
  is
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
    select dgrm_id
      into l_dgrm_id
      from flow_diagrams
     where dgrm_name = pi_dgrm_name;
    return l_dgrm_id;
  end set_dgrm_id;

  -- step the model forward (gets the step key & then uses it to step forward)

  procedure step_forward 
  ( pi_prcs_id in  flow_processes.prcs_id%type
  , pi_sbfl_id in  flow_subflows.sbfl_id%type
  )
  is
    l_step_key   flow_subflows.sbfl_step_key%type;
  begin
    -- get step key
    select sbfl_step_key
    into l_step_key
    from flow_subflows
    where sbfl_id = pi_sbfl_id;
    --step forward on subflow
    flow_api_pkg.flow_complete_step
    ( p_process_id => pi_prcs_id
    , p_subflow_id => pi_sbfl_id
    , p_step_key => l_step_key);
  end step_forward;

    -- step the model forward from an object given the object ID
   procedure step_forward 
   ( pi_prcs_id  in  flow_processes.prcs_id%type
   , pi_current  in  flow_subflows.sbfl_current%type
   )
   is
     l_subflow     flow_subflows.sbfl_id%type;
   begin
     -- find the subflow having pi_sbfl_current as its current object
       select sbfl.sbfl_id
         into l_subflow
         from flow_subflows sbfl
        where sbfl.sbfl_prcs_id = pi_prcs_id
          and sbfl.sbfl_current = pi_current;
     -- step it forward
      step_forward 
      ( pi_prcs_id => pi_prcs_id
      , pi_sbfl_id => l_subflow
      );
   end step_forward;

  -- get the subflow that has pi_current as the current object.

   function get_sbfl_id
   ( pi_prcs_id       in flow_processes.prcs_id%type
   , pi_current       in flow_objects.objt_bpmn_id%type
   ) return flow_subflows.sbfl_id%type
   is 
     l_sbfl_id flow_subflows.sbfl_id%type;
   begin
     select sbfl_id
       into l_sbfl_id
       from flow_subflows
      where sbfl_prcs_id = pi_prcs_id
        and sbfl_current = pi_current;
     return l_sbfl_id;
   end get_sbfl_id;
  

  -- check subflow log to see if an object in main diagram has completed

  function has_step_completed 
    ( pi_prcs_id        flow_processes.prcs_id%type
    , pi_objt_bpmn_id   flow_objects.objt_bpmn_id%type
    ) return boolean
  is
    l_exists number;
  begin
    select count(pi_objt_bpmn_id)
      into l_exists
      from flow_subflow_log sflg
     where sflg.sflg_objt_id = pi_objt_bpmn_id
       and sflg.sflg_prcs_id = pi_prcs_id
       and sflg.sflg_diagram_level = 0
    ;
    if (l_exists = 1) then 
      return true;
    else 
      return false;
    end if;
  end; 

   -- check subflow log to see if an object in a called activity has completed

  function has_called_step_completed 
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_calling_objt   flow_objects.objt_bpmn_id%type
  , pi_objt_bpmn_id   flow_objects.objt_bpmn_id%type
  ) return boolean
  is
    l_exists number;
  begin
    select count(pi_objt_bpmn_id)
      into l_exists
      from flow_subflow_log sflg
      join flow_instance_diagrams prdg
        on prdg.prdg_prcs_id = sflg.sflg_prcs_id
       and prdg.prdg_diagram_level = sflg.sflg_diagram_level
       and prdg.prdg_dgrm_id = sflg.sflg_dgrm_id
     where prdg.prdg_calling_objt = pi_calling_objt
       and sflg.sflg_objt_id = pi_objt_bpmn_id
       and sflg.sflg_prcs_id = pi_prcs_id
    ;
    if (l_exists = 1) then 
      return true;
    else 
      return false;
    end if;
  end;

end test_helper;
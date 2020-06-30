create or replace package flow_api_pkg
as

  function flow_create
  ( 
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_prcs_name in flow_processes.prcs_name%type default null
  ) return flow_processes.prcs_id%type;

  function flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type default null
  ) return flow_processes.prcs_id%type;

  procedure flow_create
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_prcs_name in flow_processes.prcs_name%type
  );

  procedure flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type
  );

  function next_step_exists
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  function next_step_exists_yn
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2;

  function next_multistep_exists
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  function next_multistep_exists_yn
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2;
    
  function get_current_progress -- creates the markings for the bpmn viewer to show current progress 
  ( 
    p_process_id in flow_processes.prcs_id%type 
  ) return varchar2;

  procedure flow_start
  (
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_next_branch
  ( p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_branch_name in varchar2
  );
    
  procedure flow_next_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_forward_route in varchar2
  );
  procedure flow_reset
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_delete
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  
end flow_api_pkg;
/

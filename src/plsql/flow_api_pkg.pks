create or replace package flow_api_pkg
as

  gc_step          constant varchar2(50 char) := 'simple-step';
  gc_single_choice constant varchar2(50 char) := 'single-choice';
  gc_multi_choice  constant varchar2(50 char) := 'multi-choice';

/********************************************************************************
**
**        FLOW OPERATIONS (Create, Start, Next_step, Reset, Stop, Delete)
**
********************************************************************************/

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

  procedure flow_start
  (
    p_process_id in flow_processes.prcs_id%type
  );

    procedure flow_reserve_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_reservation   in flow_subflows.sbfl_reservation%type
  );  

     procedure flow_release_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

   procedure flow_complete_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

  -- Note: flow_next_branch no longer required or supported in V5.0
  procedure flow_next_branch
  ( p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_branch_name in varchar2
  );
  
  -- Note: flow_next_step no longer supported in V5.0.  Use flow_complete_step.  See doc.
  procedure flow_next_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_forward_route in varchar2 default null
  );

-- Note: flow_reset only for debug / test / use.  
-- For production usage, always delete and start a new process
  procedure flow_reset
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  
  procedure flow_delete
  ( 
    p_process_id in flow_processes.prcs_id%type
  );



 /********************************************************************************
**
**        APPLICATION HELPERS (Progress, Next Step needs Decisions, etc.)
**
********************************************************************************/ 

  function next_multistep_exists
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  function next_multistep_exists_yn
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2;

  function next_step_type
  (
    p_sbfl_id in flow_subflows.sbfl_id%type
  ) return varchar2;

end flow_api_pkg;
/

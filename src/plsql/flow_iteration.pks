create or replace package flow_iteration
as
/* 
-- Flows for APEX Enterprise Edition - flow_iteration.pks
-- 
-- (c) Copyright Flowquest Consulting Limited, 2024.
--
-- Created    30-Jan-2024  Richard Allen (Flowquest)
--
*/

  procedure add_iteration_to_step_info
  ( p_step_info             in out NOCOPY flow_types_pkg.flow_step_info
  , p_sbfl_rec              in            flow_subflows%rowtype
  );

  procedure parallel_split
  ( p_subflow_id            in flow_subflows.sbfl_id%type 
  , p_sbfl_info             in flow_subflows%rowtype
  , p_step_info             in flow_types_pkg.flow_step_info
  );

  function parallel_merge
  ( p_sbfl_info             in flow_subflows%rowtype
  , p_step_info             in flow_types_pkg.flow_step_info
  ) return varchar2; -- returns forward status 'wait' or 'proceed'

  function sequential_init
  ( p_sbfl_info             in flow_subflows%rowtype
  , p_step_info             in flow_types_pkg.flow_step_info
  ) return flow_subflows.sbfl_loop_total_instances%type;

  procedure sequential_start_step
  ( p_sbfl_info             in flow_subflows%rowtype
  );

  function sequential_complete_step
  ( p_sbfl_info             in flow_subflows%rowtype
  ) return flow_types_pkg.t_iteration_status;

  function loop_init
  ( p_sbfl_info             in flow_subflows%rowtype
  , p_step_info             in flow_types_pkg.flow_step_info
  ) return flow_subflows.sbfl_loop_total_instances%type;

  procedure loop_start_step
  ( p_sbfl_info             in flow_subflows%rowtype
  );

  function loop_complete_step
  ( p_sbfl_info             in flow_subflows%rowtype
  ) return flow_types_pkg.t_iteration_status;
  
  function get_iteration_array
  ( pi_prcs_id              in flow_processes.prcs_id%type
  , pi_sbfl_id              in flow_subflows.sbfl_id%type
  , pi_scope                in flow_subflows.sbfl_scope%type 
  , pi_prov_var_name        in flow_process_variables.prov_var_name%type 
  ) return sys.json_array_t;  


  procedure set_iteration_array_status 
  ( pi_prcs_id          in flow_processes.prcs_id%type
  , pi_sbfl_id          in flow_subflows.sbfl_id%type default null
  , pi_step_key         in flow_subflows.sbfl_step_key%type default null
  , pi_scope            in flow_subflows.sbfl_scope%type
  , pi_prov_var_name    in flow_process_variables.prov_var_name%type
  , pi_loop_counter     in flow_subflows.sbfl_loop_counter%type
  , pi_iteration_path   in flow_subflows.sbfl_iteration_path%type default null
  , pi_new_status       in varchar2
  );

end flow_iteration;
/

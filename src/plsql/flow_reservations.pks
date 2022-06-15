create or replace package flow_reservations
  authid definer
  accessible by (flow_api_pkg, flow_engine)
as 

    procedure reserve_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type
    , p_reservation        in flow_subflows.sbfl_reservation%type
    , p_called_internally  in boolean default false
    );

    procedure release_step
    ( p_process_id         in flow_processes.prcs_id%type
    , p_subflow_id         in flow_subflows.sbfl_id%type
    , p_step_key           in flow_subflows.sbfl_step_key%type default null
    , p_called_internally  in boolean default false
    );

end flow_reservations;
/

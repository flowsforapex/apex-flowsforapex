create or replace package flow_instances 
accessible by (flow_api_pkg, flow_engine)
as

  function create_process
    ( p_dgrm_id   in flow_diagrams.dgrm_id%type
    , p_prcs_name in flow_processes.prcs_name%type
    ) return flow_processes.prcs_id%type
    ;

  procedure start_process
    ( p_process_id    in flow_processes.prcs_id%type
    );

  procedure reset_process
    ( p_process_id in flow_processes.prcs_id%type
    );

  procedure terminate_process
    ( p_process_id in flow_processes.prcs_id%type
    );

  procedure delete_process
    (
      p_process_id in flow_processes.prcs_id%type
    );

end flow_instances;
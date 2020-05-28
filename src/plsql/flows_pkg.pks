create or replace package flows_pkg
as

function flow_create
( p_diagram_name in diagrams.dgm_name%type
, p_process_name in processes.prc_name%type default null
) return number;

procedure flow_start
( p_process_id in processes.prc_id%type
);

procedure flow_next_step
( p_process_id in processes.prc_id%type
);
   
procedure flow_next_branch
( p_process_id  in processes.prc_id%type
, p_branch_name in varchar2
);

procedure flow_reset
( p_process_id in processes.prc_id%type
);
    
procedure flow_delete
( p_process_id in processes.prc_id%type
);

procedure flow_parse
( p_diagram_name  in diagrams.dgm_name%type
, p_flow_string   in varchar2
, p_object_string in varchar2
);

end flows_pkg;
/
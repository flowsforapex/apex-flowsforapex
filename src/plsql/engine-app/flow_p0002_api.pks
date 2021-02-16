create or replace package flow_p0002_api
  authid definer
as
    procedure delete_diagram(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_cascade in varchar2
    );

    function add_diagram_version(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_dgrm_version in flow_diagrams.dgrm_version%type
    ) return flow_diagrams.dgrm_id%type;


    procedure update_diagram_status(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_dgrm_status in flow_diagrams.dgrm_version%type
    );


    procedure handle_ajax(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_action in varchar2
    );

end flow_p0002_api;
/

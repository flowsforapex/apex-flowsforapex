create or replace package flow_p0007_api
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

    procedure add_default_xml(
        pi_dgrm_id in flow_diagrams.dgrm_id%type
    );

    procedure update_diagram_category(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_dgrm_category in flow_diagrams.dgrm_category%type
    );

end flow_p0007_api;
/

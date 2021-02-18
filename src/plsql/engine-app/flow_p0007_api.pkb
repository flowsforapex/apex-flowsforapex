create or replace package body flow_p0007_api
as
    function get_error_message(
        pi_sqlcode in number,
        pi_sqlerrm in varchar2)
    return varchar2
    is
    l_constraint_name varchar2(255);
    l_constraint_message varchar2(32767);
    l_error_message varchar2(32767);
    begin
    if pi_sqlcode in (-1, -2091, -2290, -2291, -2292) then
        l_constraint_name := substr(pi_sqlerrm, instr(pi_sqlerrm, '(')+1, instr( pi_sqlerrm, ')') - instr( pi_sqlerrm,'(') -1);
        l_constraint_name := substr(l_constraint_name, instr(l_constraint_name, '.')+1);
        l_constraint_message := apex_lang.message(p_name => l_constraint_name);
        if (l_constraint_message != l_constraint_name) then
            l_error_message := l_constraint_message;
        end if;
    end if;
    if (l_error_message is null) then
        l_error_message := pi_sqlerrm;
    end if;

    return l_error_message;
    end get_error_message;

    procedure delete_diagram(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_cascade in varchar2
    )
    is
    begin
        if  pi_cascade = 'Y' then
            delete from flow_processes where prcs_dgrm_id = pi_dgrm_id;
        end if;
        delete from flow_diagrams where dgrm_id = pi_dgrm_id;
    end delete_diagram;

    function add_diagram_version(
        pi_dgrm_id in flow_diagrams.dgrm_id%type,
        pi_dgrm_version in flow_diagrams.dgrm_version%type
    ) return flow_diagrams.dgrm_id%type
    is
        l_dgrm_id flow_diagrams.dgrm_id%type;
        r_diagrams flow_diagrams%rowtype;
        l_dgrm_exist number;
    begin
        select * 
        into r_diagrams
        from flow_diagrams
        where dgrm_id = pi_dgrm_id;
        
        select count(*)
        into l_dgrm_exist
        from flow_diagrams
        where dgrm_name = r_diagrams.dgrm_name
        and dgrm_version = pi_dgrm_version;
        
        if (l_dgrm_exist = 0) then
            l_dgrm_id := flow_bpmn_parser_pkg.upload_diagram (
                pi_dgrm_name => r_diagrams.dgrm_name
                , pi_dgrm_version => pi_dgrm_version
                , pi_dgrm_category => r_diagrams.dgrm_category
                , pi_dgrm_content => r_diagrams.dgrm_content
                , pi_dgrm_status => flow_constants_pkg.gc_dgrm_status_draft
            );
            flow_bpmn_parser_pkg.parse(
                pi_dgrm_id => l_dgrm_id
            );
            return l_dgrm_id;
        else
            raise_application_error(-20000, '');
        end if;
    end add_diagram_version;

end flow_p0007_api;
/

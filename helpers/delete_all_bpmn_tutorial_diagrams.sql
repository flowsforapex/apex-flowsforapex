select 'flow_diagram.delete_diagram ( pi_dgrm_id => ' || dgrm_id || ', pi_cascade => ''Y'');'
 from flow_diagrams_vw
 where dgrm_name like 'Tutorial%'
   and dgrm_version = '25.1'
    and dgrm_category = 'Tutorials'
 order by dgrm_name;

 
begin
flow_diagram.delete_diagram ( pi_dgrm_id => 36, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 37, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 38, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 39, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 40, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 41, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 42, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 43, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 44, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 45, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 46, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 47, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 48, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 49, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 50, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 51, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 52, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 53, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 54, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 55, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 57, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 58, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 59, pi_cascade => 'Y');
flow_diagram.delete_diagram ( pi_dgrm_id => 60, pi_cascade => 'Y');
end;
/
commit;
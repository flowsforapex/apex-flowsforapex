create or replace view flow_instance_scopes_vw
as
  select prdg_prcs_id         iscp_prcs_id
       , prdg_diagram_level   iscp_valid_scope
    from flow_instance_diagrams
   where prdg_diagram_level is not null
  union
  select distinct iter_prcs_id iscp_prcs_id
       , iter_scope            iscp_valid_scope
    from flow_iterations
with read only;

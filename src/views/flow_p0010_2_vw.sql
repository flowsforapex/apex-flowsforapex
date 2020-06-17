create view FLOW_P0010_2_VW
as 
   select prcs.prcs_id
        , prcs.prcs_name
        , prcs.prcs_dgrm_name
        , case
          when prcs.prcs_current is not null
          then
            objt.objt_name
          when prcs.prcs_current is null
          then
            'n.a.'
          end as prcs_current
        , prcs.prcs_init_date
        , prcs.prcs_last_update
        , null  as start_link
        , null  as reset_link
        , null  as delete_link
     from flow_processes prcs
left join flow_objects   objt on 
          (   prcs.prcs_current = objt.objt_id
          and prcs.prcs_dgrm_name = objt.objt_dgrm_name
          )
/
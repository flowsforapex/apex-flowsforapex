create view FLOW_P0010_2_VW
as 
   select prcs.prcs_id
        , prcs.prcs_name
        , prcs.prcs_dgrm_name
        , prcs.prcs_main_subflow
        , prcs.prcs_status
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
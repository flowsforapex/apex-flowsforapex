create or replace view flow_p0010_instances_vw
as
   select prcs.prcs_id
        , prcs.prcs_name
        , dgrm.dgrm_name as prcs_dgrm_name
        , prcs.prcs_main_subflow
        , prcs.prcs_status
        , prcs.prcs_init_ts as prcs_init_date
        , prcs.prcs_last_update
        , null  as start_link
        , null  as reset_link
        , null  as delete_link
     from flow_processes prcs
     join flow_diagrams dgrm
       on dgrm.dgrm_id = prcs.prcs_dgrm_id
;

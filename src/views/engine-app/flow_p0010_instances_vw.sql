create or replace view flow_p0010_instances_vw
as
   select null as view_process
        , prcs_id
        , prcs_name
        , prcs_dgrm_name
        , prcs_dgrm_version
        , prcs_dgrm_status
        , prcs_dgrm_category
        , prcs_status
        , prcs_init_date
        , prcs_last_update
        , '<button type="button" title="' || btn_title || '" aria-label="' || btn_title || '"' ||
          ' class="clickable-action t-Button t-Button--noLabel t-Button--icon"' ||
          ' data-prcs="' || prcs_id || '" data-action="' || btn_action || '"' ||
          '><span aria-hidden="true" class="' || btn_icon_class || '"></span></button>' ||
          '<button type="button" title="Delete Process Instance" aria-label="Delete Process Instance"' ||
          ' class="clickable-action t-Button t-Button--noLabel t-Button--icon"' ||
          ' data-prcs="' || prcs_id || '" data-action="delete"' ||
          '><span aria-hidden="true" class="t-Icon fa fa-trash"></span></button>' ||
          '<button type="button" title="Create new Instance" aria-label="Create new Instance"' ||
          ' class="t-Button t-Button--noLabel t-Button--icon"' ||
          ' onclick="' || apex_page.get_url( p_page => '11', p_items => 'P11_DGRM_ID', p_values => dgrm_id ) || '">' ||
          '<span class="t-Icon fa fa-plus" aria-hidden="true"></span></button>'
          as btn
     from ( select prcs_id
                 , prcs_name
                 , dgrm_id
                 , dgrm_name as prcs_dgrm_name
                 , dgrm_version as prcs_dgrm_version
                 , dgrm_status as prcs_dgrm_status
                 , dgrm_category as prcs_dgrm_category
                 , prcs_status
                 , prcs_init_ts as prcs_init_date
                 , prcs_last_update
                 , case prcs_status
                     when 'running' then 'Reset Process'
                     when 'created' then 'Start Process'
                     when 'completed' then 'Reset Process'
                   end as btn_title
                 , 't-Icon fa ' ||
                   case prcs_status
                     when 'running' then 'fa-undo'
                     when 'created' then 'fa-play'
                     when 'completed' then 'fa-undo'
                   end as btn_icon_class
                 , case prcs_status
                     when 'running' then 'reset'
                     when 'created' then 'start'
                     when 'completed' then 'reset'
                   end as btn_action
              from flow_instances_vw
          )
with read only
;

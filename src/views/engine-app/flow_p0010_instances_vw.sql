create or replace view flow_p0010_instances_vw
as
   select null as view_process
        , prcs_id
        , prcs_name
        , prcs_dgrm_id
        , prcs_dgrm_name
        , prcs_dgrm_version
        , prcs_dgrm_status
        , prcs_dgrm_category
        , prcs_status
        , prcs_status_icon
        , prcs_init_date
        , prcs_last_update
        , prcs_business_ref
        , '<button type="button" title="' || btn_title || '" aria-label="' || btn_title || '"' ||
          ' class="clickable-action t-Button t-Button--noLabel t-Button--icon"' ||
          ' data-prcs="' || prcs_id || '" data-action="' || btn_action || '"' ||
          '><span aria-hidden="true" class="' || btn_icon_class || '"></span></button>' ||
          term_btn ||
          '<button type="button" title="' || apex_lang.message(p_name => 'APP_DELETE_INSTANCE') || '" aria-label="' || apex_lang.message(p_name => 'APP_DELETE_INSTANCE') || '"' ||
          ' class="clickable-action t-Button t-Button--noLabel t-Button--icon"' ||
          ' data-prcs="' || prcs_id || '" data-action="delete"' ||
          '><span aria-hidden="true" class="t-Icon fa fa-trash"></span></button>'
          as btn
        , apex_item.checkbox2(p_idx => 1, p_value => prcs_id, p_attributes => 'data-prcs = "' || prcs_id || '" data-status = "' || prcs_status ||'"') as checkbox
        , '<button type="button" class="t-Button t-Button--icon t-Button--iconLeft t-Button--link js-actionButton"'||
          ' data-prcs="' || prcs_id || '" data-name="' || prcs_name || '" data-action="view-flow-instance"' ||
          '><span aria-hidden="true" class="t-Icon t-Icon--left fa fa-eye"></span>View</button>' as view_instance
     from ( select prcs_id
                 , prcs_name
                 , dgrm_id as prcs_dgrm_id
                 , dgrm_name as prcs_dgrm_name
                 , dgrm_version as prcs_dgrm_version
                 , dgrm_status as prcs_dgrm_status
                 , dgrm_category as prcs_dgrm_category
                 , prcs_status
                 , prcs_init_ts as prcs_init_date
                 , prcs_last_update
                 , prcs_business_ref
                 , case prcs_status
                     when 'running' then apex_lang.message(p_name => 'APP_RESET_INSTANCE')
                     when 'created' then apex_lang.message(p_name => 'APP_START_INSTANCE')
                     when 'completed' then apex_lang.message(p_name => 'APP_RESET_INSTANCE')
                     when 'error' then apex_lang.message(p_name => 'APP_RESET_INSTANCE')
                   end as btn_title
                 , 't-Icon fa ' ||
                   case prcs_status
                     when 'running' then 'fa-undo'
                     when 'created' then 'fa-play'
                     when 'completed' then 'fa-undo'
                     when 'error' then 'fa-undo'
                   end as btn_icon_class
                 , case prcs_status
                     when 'running' then 'reset'
                     when 'created' then 'start'
                     when 'completed' then 'reset'
                     when 'error' then 'reset'
                   end as btn_action
                 , case prcs_status
                     when 'running' then 'fa-play'
                     when 'created' then 'fa-plus'
                     when 'completed' then 'fa-check'
                     when 'terminated' then 'fa-stop-circle-o'
                     when 'error' then 'fa-warning'
                   end as prcs_status_icon
                 , case 
                     when prcs_status in ('running', 'error') then 
                      '<button type="button" class="clickable-action t-Button t-Button--noLabel t-Button--icon" ' ||
                      'title="' || apex_lang.message(p_name => 'APP_TERMINATE_INSTANCE') || '" aria-label="' || apex_lang.message(p_name => 'APP_TERMINATE_INSTANCE') || '" ' ||
                      ' data-prcs="' || prcs_id || '" data-action="terminate"' ||
                      '><span aria-hidden="true" class="t-Icon fa fa-stop-circle"></span></button>'  
                     else
                       null  
                   end as term_btn 
              from flow_instances_vw
          )
with read only
;

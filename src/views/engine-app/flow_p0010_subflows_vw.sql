create or replace view flow_p0010_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_current_name as sbfl_current
       , sbfl.sbfl_starting_object_name as sbfl_starting_object
       , sbfl.sbfl_last_update
       , sbfl.sbfl_status
       , sbfl.sbfl_current_lane_name as sbfl_current_lane
       , sbfl.sbfl_reservation
       , case
          when sbfl.sbfl_status in ('split', 'in subprocess', 'waiting at gateway', 'waiting for event', 'waiting for timer') then
            '<span class="' ||
            case sbfl.sbfl_status
              when 'split' then 'fa fa-share-alt'
              when 'in subprocess' then 'fa fa-share-alt'
              when 'waiting at gateway' then 'fa fa-hand-stop-o'
              when 'waiting for timer' then 'fa fa-clock-o'
              when 'waiting for event' then 'fa fa-hand-stop-o'
            end ||
            '"></span>'
          else
            '<button type="button" class="clickable-action t-Button t-Button--noLabel t-Button--icon" ' ||
            'title="' || apex_lang.message(p_name => 'APP_COMPLETE_STEP') || '" aria-label="' || apex_lang.message(p_name => 'APP_COMPLETE_STEP') || '" ' ||
            'data-prcs="' || sbfl.sbfl_prcs_id || '" data-sbfl="' || sbfl.sbfl_id || 
            '" data-action="next_step"><span aria-hidden="true" class="fa fa-sign-out"></span></button>' 
         end as action_html
       , case 
          when sbfl.sbfl_status = 'running' then 
            '<button type="button" class="clickable-action t-Button t-Button--noLabel t-Button--icon" ' ||
            case 
                when sbfl.sbfl_reservation is null then 'title="' || apex_lang.message(p_name => 'APP_RESERVE_STEP') ||'" aria-label="' || apex_lang.message(p_name => 'APP_RESERVE_STEP') ||'" '
                when sbfl.sbfl_reservation is not null then 'title="' || apex_lang.message(p_name => 'APP_RELEASE_STEP') ||'" aria-label="' || apex_lang.message(p_name => 'APP_RELEASE_STEP') ||'" '
            end || 'data-prcs="' || sbfl.sbfl_prcs_id || '" data-sbfl="' || sbfl.sbfl_id || '" data-action="' ||
            case 
                when sbfl.sbfl_reservation is null then 'reserve'
                when sbfl.sbfl_reservation is not null then 'release'
              end || '"><span aria-hidden="true" class="' ||
              case
                when sbfl.sbfl_reservation is null then  'fa fa-lock'
                when sbfl.sbfl_reservation is not null then 'fa fa-unlock'
              end || '"></span></button>'  
          else
            null  
         end as reservation_html
    from flow_subflows_vw sbfl
with read only
;

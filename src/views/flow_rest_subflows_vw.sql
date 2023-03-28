create or replace view flow_rest_subflows_vw
      (
         prcs_id
       , sbfl_id
       , sbfl_sbfl_id
       , process_level
       , diagram_level
       , calling_sbfl
       , scope
       , "current"
       , step_key
       , status
       , became_current
       , reservation
       , links
      )
  as
  select p.prcs_id
       , s.sbfl_id
       , s.sbfl_sbfl_id
       , s.sbfl_process_level   as process_level
       , s.sbfl_diagram_level   as diagram_level
       , s.sbfl_calling_sbfl    as calling_sbfl
       , s.sbfl_scope           as scope
       , s.sbfl_current         as "current"
       , s.sbfl_step_key        as step_key
       , s.sbfl_status          as status
       , s.sbfl_became_current  as became_current
       , s.sbfl_reservation     as reservation
       , json_array(
           flow_rest_api_v1.get_links_string_http_GET('step',s.sbfl_id) format json
         ) links
  from flow_processes p
  join flow_subflows s on p.prcs_id = s.sbfl_prcs_id;
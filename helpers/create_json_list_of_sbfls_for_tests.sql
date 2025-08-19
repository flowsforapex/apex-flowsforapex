    with sbfl_list as (
           select json_object
                   ( 'current'        value sf.sbfl_current
                   , 'iteration_type' value sf.sbfl_iteration_type
                   , 'iteration_path' value it.iter_display_name
                   , 'status'         value sf.sbfl_status
                   ) subflows
                 , sf.sbfl_prcs_id 
                 , sf.sbfl_current 
                 , it.iter_display_name sbfl_iteration_path     
           from flow_subflows sf
           left join flow_iterations it
             on sf.sbfl_iter_id = it.iter_id
           order by sbfl_current, it.iter_display_name
           )
    select json_arrayagg (sl.subflows order by sl.sbfl_current asc, sl.sbfl_iteration_path asc returning clob pretty) sbfl_array
    from sbfl_list sl
    join flow_processes p
      on p.prcs_id = sl.sbfl_prcs_id
    where p.prcs_id = 13543;
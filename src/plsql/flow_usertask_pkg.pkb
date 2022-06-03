/* 
-- Flows for APEX - flow_usertask_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 12-Nov-2020 Moritz Klein (MT AG) 
-- Edited  13-Apr-2022 Richard Allen (Oracle)
-- Edited  23-May-2022 Moritz Klein (MT AG)
--
*/

create or replace package body flow_usertask_pkg
as

  function get_url
  (
    pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type
  , pi_objt_id  in flow_objects.objt_id%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type default 0
  ) return varchar2
  as
    l_application flow_types_pkg.t_bpmn_attribute_vc2;
    l_page        flow_types_pkg.t_bpmn_attribute_vc2;
    l_request     flow_types_pkg.t_bpmn_attribute_vc2;
    l_clear_cache flow_types_pkg.t_bpmn_attribute_vc2;
    l_items       flow_types_pkg.t_bpmn_attribute_vc2;
    l_values      flow_types_pkg.t_bpmn_attribute_vc2;
  begin
    select max(ut_application)
         , max(ut_page_id)
         , max(ut_request)
         , max(ut_clear_cache)
         , listagg( ut_item_name, ',' ) as item_names
         , listagg( ut_item_value, ',' ) as item_values
      into l_application
         , l_page
         , l_request
         , l_clear_cache
         , l_items
         , l_values
      from flow_objects objt
      join json_table( objt.objt_attributes
           , '$.apex'
             columns
               ut_application varchar2(4000) path '$.applicationId'
             , ut_page_id     varchar2(4000) path '$.pageId'
             , ut_request     varchar2(4000) path '$.request'
             , ut_clear_cache varchar2(4000) path '$.cache'
             , nested path '$.pageItems[*]'
                 columns ( ut_item_name varchar2(4000) path '$.name', ut_item_value varchar2(4000) path '$.value' )
           ) jt
        on objt.objt_id = pi_objt_id
    ;

    -- itemValues will run through substitution
    -- other attributes not (yet?)
    flow_proc_vars_int.do_substitution
    ( 
      pi_prcs_id  => pi_prcs_id
    , pi_sbfl_id  => pi_sbfl_id
    , pi_step_key => pi_step_key
    , pio_string  => l_values 
    , pi_scope    => pi_scope
    );

    return
      apex_page.get_url
      (
        p_application => l_application
      , p_page        => l_page
      , p_request     => l_request
      , p_clear_cache => l_clear_cache
      , p_items       => l_items
      , p_values      => l_values
      )
    ;
  end get_url;

end flow_usertask_pkg;
/

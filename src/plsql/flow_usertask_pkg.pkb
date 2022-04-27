/* 
-- Flows for APEX - flow_usertask_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 12-Nov-2020  Moritz Klein ( MT AG) 
-- Edited  13-Apr-2022 - Richard Allen (Oracle)
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
    l_application flow_object_attributes.obat_vc_value%type;
    l_page        flow_object_attributes.obat_vc_value%type;
    l_request     flow_object_attributes.obat_vc_value%type;
    l_clear_cache flow_object_attributes.obat_vc_value%type;
    l_items       flow_object_attributes.obat_vc_value%type;
    l_values      flow_object_attributes.obat_vc_value%type;
  begin
    for rec in (
      select obat.obat_key
           , obat.obat_vc_value
        from flow_object_attributes obat
       where obat.obat_objt_id = pi_objt_id
         and obat.obat_key in ( flow_constants_pkg.gc_apex_usertask_application_id
                              , flow_constants_pkg.gc_apex_usertask_page_id
                              , flow_constants_pkg.gc_apex_usertask_request
                              , flow_constants_pkg.gc_apex_usertask_cache
                              , flow_constants_pkg.gc_apex_usertask_item
                              , flow_constants_pkg.gc_apex_usertask_value
                              )
    )
    loop
      case rec.obat_key
        when flow_constants_pkg.gc_apex_usertask_application_id then
          l_application := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_page_id then
          l_page := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_request then
          l_request := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_cache then
          l_clear_cache := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_item then
          l_items := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_value then
          l_values := rec.obat_vc_value;
          flow_proc_vars_int.do_substitution ( pi_prcs_id  => pi_prcs_id
                                             , pi_sbfl_id  => pi_sbfl_id
                                             , pi_step_key => pi_step_key
                                             , pio_string  => l_values 
                                             , pi_scope    => pi_scope
                                             );
        else
          null;
      end case;
    end loop;

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

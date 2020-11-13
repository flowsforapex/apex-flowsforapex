create or replace package body flow_usertask_pkg
as

  function get_url
  (
    pi_objt_id in flow_objects.objt_id%type
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
         and obat.obat_key in ( flow_constants_pkg.gc_apex_usertask_application
                              , flow_constants_pkg.gc_apex_usertask_page
                              , flow_constants_pkg.gc_apex_usertask_request
                              , flow_constants_pkg.gc_apex_usertask_cache
                              , flow_constants_pkg.gc_apex_usertask_item
                              , flow_constants_pkg.gc_apex_usertask_value
                              )
    )
    loop
      case rec.obat_key
        when flow_constants_pkg.gc_apex_usertask_application then
          l_application := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_page then
          l_page := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_request then
          l_request := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_cache then
          l_clear_cache := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_item then
          l_items := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_usertask_value then
          l_values := rec.obat_vc_value;
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

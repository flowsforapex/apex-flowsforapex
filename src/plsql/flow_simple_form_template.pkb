create or replace package body flow_simple_form_template
as
/* 
-- Flows for APEX - flow_simple_form_template.pkb
-- 
-- (c) Copyright Hyand, 2024
--
-- Created  20-Aug-2024  Dennis Amthor - Hyand
--
*/
  function create_template(
    pi_sfte_name      in flow_simple_form_templates.sfte_name%type
  , pi_sfte_static_id in flow_simple_form_templates.sfte_static_id%type
  , pi_sfte_content   in flow_simple_form_templates.sfte_content%type)
  return flow_simple_form_templates.sfte_id%type
  as
    l_template_exists binary_integer;
    l_sfte_id flow_simple_form_templates.sfte_id%type;
  begin
    select count(*)
      into l_template_exists
      from dual
     where exists(
           select null
             from flow_simple_form_templates
            where sfte_static_id = pi_sfte_static_id);

    if l_template_exists = 0 then
      insert into flow_simple_form_templates
        (sfte_name, sfte_static_id, sfte_content)
      values
        (pi_sfte_name, pi_sfte_static_id, pi_sfte_content)
      returning
        sfte_id into l_sfte_id;
    else
      raise template_exists;
    end if;
    return l_sfte_id;

  end create_template;
  
  
  procedure edit_template(
    pi_sfte_id        in flow_simple_form_templates.sfte_id%type
  , pi_sfte_name      in flow_simple_form_templates.sfte_name%type
  , pi_sfte_static_id in flow_simple_form_templates.sfte_static_id%type
  , pi_sfte_content   in flow_simple_form_templates.sfte_content%type)
  as
  begin
    update flow_simple_form_templates
       set sfte_name = pi_sfte_name
         , sfte_static_id = pi_sfte_static_id
         , sfte_content = pi_sfte_content
     where sfte_id = pi_sfte_id;

  end edit_template;


  procedure delete_template(
    pi_sfte_id in flow_simple_form_templates.sfte_id%type)
  as
  begin
    delete from flow_simple_form_templates 
     where sfte_id = pi_sfte_id;

  end delete_template;

end flow_simple_form_template;
/

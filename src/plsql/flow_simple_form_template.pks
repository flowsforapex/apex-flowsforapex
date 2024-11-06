/* 
-- Flows for APEX - flow_simple_form_template.pks
-- 
-- (c) Copyright Hyand, 2024
--
-- Created  20-Aug-2024  Dennis Amthor - Hyand
--
*/
create or replace package flow_simple_form_template
  authid definer
as
  template_exists exception;
  pragma exception_init(template_exists, -20003);

  function create_template(
    pi_sfte_name      in flow_simple_form_templates.sfte_name%type
  , pi_sfte_static_id in flow_simple_form_templates.sfte_static_id%type
  , pi_sfte_content   in flow_simple_form_templates.sfte_content%type)
  return flow_simple_form_templates.sfte_id%type;

  procedure edit_template(
    pi_sfte_id        in flow_simple_form_templates.sfte_id%type
  , pi_sfte_name      in flow_simple_form_templates.sfte_name%type
  , pi_sfte_static_id in flow_simple_form_templates.sfte_static_id%type
  , pi_sfte_content   in flow_simple_form_templates.sfte_content%type);

  procedure delete_template(
    pi_sfte_id in flow_simple_form_templates.sfte_id%type);

end flow_simple_form_template;
/

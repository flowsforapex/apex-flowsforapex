/* 
-- Flows for APEX - flow_services.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  21-Nov-2021  Louis Moreaux (Insum, for MT AG) 
-- Edited   13-Apr-2022  Richard Allen (Oracle)
-- Modified 01-Jun-2022  Moritz Klein (MT AG)
--
*/

create or replace package body flow_services
as
  g_workspace varchar2(100) := flow_engine_util.get_config_value(
                                   p_config_key    => 'default_workspace'
                                 , p_default_value => flow_constants_pkg.gc_config_default_default_workspace
                               );

  g_email_sender varchar2(100) := flow_engine_util.get_config_value(
                                   p_config_key    => 'default_email_sender'
                                 , p_default_value => ''  
                               );

  procedure set_workspace_id
  (
    p_workspace_name in varchar2
  )
  is
    l_workspace_id number;
  begin
    l_workspace_id := apex_util.find_security_group_id (p_workspace => p_workspace_name);
    if (l_workspace_id is null) then
      raise e_wrong_default_workspace;
    end if;
    apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
  end set_workspace_id;

  procedure get_config
  (
    pi_objt_id           in flow_objects.objt_id%type
  , po_from             out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_to               out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_cc               out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_bcc              out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_reply_to         out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_use_template     out nocopy boolean
  , po_template_id      out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_placeholders     out nocopy clob
  , po_immediate        out nocopy boolean
  , po_application_id   out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_subject          out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  , po_body             out nocopy clob
  , po_body_html        out nocopy clob
  , po_attachment_query out nocopy flow_types_pkg.t_bpmn_attribute_vc2
  )
  as
    l_plain_config     clob;
    l_json_config      sys.json_object_t;
    l_body             sys.json_array_t;
    l_body_html        sys.json_array_t;
    l_attachment_query sys.json_array_t;
    l_placeholders     sys.json_object_t;
    procedure json_array_to_clob
    (
      pi_array  in sys.json_array_t
    , po_clob  out nocopy clob
    )
    as
    begin
      for i in 0..pi_array.get_size - 1 loop
        po_clob := po_clob || pi_array.get_string(i) || apex_application.lf;
      end loop;
    end json_array_to_clob;
  begin
    select json_query( objt.objt_attributes format json, '$.apex' returning clob ) as json_data
      into l_plain_config
      from flow_objects objt
     where objt.objt_id = pi_objt_id
    ;
    l_json_config      := sys.json_object_t.parse( l_plain_config );

    po_from           := l_json_config.get_string( 'emailFrom' );
    po_to             := l_json_config.get_string( 'emailTo' );
    po_cc             := l_json_config.get_string( 'emailCC' );
    po_bcc            := l_json_config.get_string( 'emailBCC' );
    po_reply_to       := l_json_config.get_string( 'emailReplyTo' );
    po_use_template   := coalesce( l_json_config.get_boolean( 'useTemplate' ), false );
    po_application_id := l_json_config.get_string( 'applicationId' );
    po_template_id    := l_json_config.get_string( 'templateId' );
    po_subject        := l_json_config.get_string( 'subject' );
    po_immediate      := coalesce( l_json_config.get_boolean( 'immediately' ), false );

    if l_json_config.has( 'placeholder' ) then
      l_placeholders  := l_json_config.get_object( 'placeholder' );
      po_placeholders := l_placeholders.to_clob;
    end if;

    json_array_to_clob( pi_array => l_json_config.get_array( 'bodyText' ),   po_clob => po_body );
    json_array_to_clob( pi_array => l_json_config.get_array( 'bodyHTML' ),   po_clob => po_body_html );
    json_array_to_clob( pi_array => l_json_config.get_array( 'attachment' ), po_clob => po_attachment_query );

  end get_config;

  procedure send_email
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  , pi_objt_id in flow_objects.objt_id%type
  )
  is
    l_from             flow_types_pkg.t_bpmn_attribute_vc2;
    l_to               flow_types_pkg.t_bpmn_attribute_vc2;
    l_cc               flow_types_pkg.t_bpmn_attribute_vc2;
    l_bcc              flow_types_pkg.t_bpmn_attribute_vc2;
    l_reply_to         flow_types_pkg.t_bpmn_attribute_vc2;
    l_use_template     boolean := false;
    l_template_id      flow_types_pkg.t_bpmn_attribute_vc2;
    l_placeholders     clob;
    l_immediate        boolean := false;
    l_application_id   flow_types_pkg.t_bpmn_attribute_vc2;
    l_subject          flow_types_pkg.t_bpmn_attribute_vc2;
    l_body             clob;
    l_body_html        clob;
    l_attachment_query flow_types_pkg.t_bpmn_attribute_vc2;
    l_mail_id          number;
    type t_attachment  is record (file_name varchar2(200), mime_type varchar2(200), blob_content blob );
    type t_attachments is table of t_attachment;
    l_attachments      t_attachments;
    l_workspace        varchar2(100);
    l_session          varchar2(20) := v('APP_SESSION');
    l_json_object      sys.json_object_t;
    l_scope            flow_subflows.sbfl_scope%type;
  begin
    apex_debug.enter( p_routine_name => 'send_email', p_name01 => 'pi_objt_id', p_value01 => pi_objt_id );

    l_scope := flow_engine_util.get_scope ( p_process_id => pi_prcs_id, p_subflow_id => pi_sbfl_id );
    flow_globals.set_context( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope );

    -- Pull all configuration from objt_attributes JSON structure
    get_config
    (
      pi_objt_id          => pi_objt_id
    , po_from             => l_from
    , po_to               => l_to
    , po_cc               => l_cc
    , po_bcc              => l_bcc
    , po_reply_to         => l_reply_to
    , po_use_template     => l_use_template
    , po_template_id      => l_template_id
    , po_placeholders     => l_placeholders
    , po_immediate        => l_immediate
    , po_application_id   => l_application_id
    , po_subject          => l_subject
    , po_body             => l_body
    , po_body_html        => l_body_html
    , po_attachment_query => l_attachment_query
    );

    -- Substitute process variables where needed
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_from );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_to );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_cc );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_bcc );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_reply_to );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_application_id );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_template_id );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_placeholders );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_subject );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_body );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_body_html );
    flow_proc_vars_int.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pi_scope => l_scope, pio_string => l_attachment_query );

    l_from := coalesce( l_from, g_email_sender );
    -- Raise error if needed
    -- no sender
    if l_from is null then
        raise e_email_no_from;
    end if;
    --no recipient
    if l_to is null then
      raise e_email_no_to;
    end if;

    -- Set the workspace if no session
    -- Useful for timers
    if ( l_session is null ) then
      if ( l_use_template ) then
        begin
          select workspace 
            into l_workspace
            from apex_applications
           where application_id = l_application_id;
        exception when no_data_found then
          raise e_workspace_not_found;
        end;
      else
        l_workspace := g_workspace;         
      end if;

      set_workspace_id(p_workspace_name => l_workspace);
    end if;

    if l_use_template then
      if l_application_id is null or l_template_id is null then
        raise e_email_no_template;
      end if;

      apex_debug.message('sys.dbms_lob.getlength(l_placeholders) ' ||sys.dbms_lob.getlength(l_placeholders));
      if sys.dbms_lob.getlength(l_placeholders) > 0  then
        begin
          l_json_object := json_object_t(l_placeholders);
        exception
          when others then
            raise e_json_not_valid;
        end;
      end if;

      l_mail_id := apex_mail.send(
        p_template_static_id => l_template_id,
        p_placeholders       => l_placeholders,
        p_to                 => l_to,
        p_cc                 => l_cc,
        p_bcc                => l_bcc,
        p_from               => l_from,
        p_replyto            => l_reply_to,
        p_application_id     => l_application_id
      );

    else

      if l_body is null then
        raise e_email_no_body;
      end if;

      l_mail_id := apex_mail.send(
        p_to        => l_to, 
        p_from      => l_from,
        p_cc        => l_cc,
        p_bcc       => l_bcc,
        p_replyto   => l_reply_to,
        p_body      => l_body,
        p_body_html => l_body_html,
        p_subj      => l_subject
      );

    end if;

    if (l_attachment_query is not null ) then

      execute immediate l_attachment_query 
      bulk collect into  l_attachments;

      for i in 1..l_attachments.count()
      loop
        apex_mail.add_attachment(
          p_mail_id    => l_mail_id,
          p_attachment => l_attachments(i).blob_content,
          p_filename   => l_attachments(i).file_name,
          p_mime_type  => l_attachments(i).mime_type
        );
      end loop;
    end if;

    if (l_immediate ) then
      apex_mail.push_queue;
    end if;
    
  exception
    when e_wrong_default_workspace then
      apex_debug.error
      (
        p_message => 'Default workspace %s is not valid'
      , p0        => g_workspace
      );
      raise e_wrong_default_workspace;
    when e_workspace_not_found then
      apex_debug.error
      (
        p_message => 'Unable to find the workspace for application id %s'
      , p0        => l_application_id
      );
      raise e_workspace_not_found;
    when e_email_no_from then 
      apex_debug.error
      (
        p_message => 'Email service task requires from attribute'
      );
      raise e_email_no_from; 
    when e_email_no_to then 
      apex_debug.error
      (
        p_message => 'Email service task requires to attribute'
      );
      raise e_email_no_to;  
    when e_email_no_template then
      apex_debug.error
      (
        p_message => 'Email service task use email template but no template id define'
      );
      raise e_email_no_template;  
    when e_email_no_body then
      apex_debug.error
      (
        p_message => 'Email service task body is missing'
      );
      raise e_email_no_body;
    when e_json_not_valid then
      apex_debug.error
      (
        p_message => 'Placeholder JSON object is invalid.'
      );
      apex_debug.log_long_message
      (
          p_message => l_placeholders
        , p_level   => apex_debug.c_log_level_error
      );
      raise e_json_not_valid;
    when others then
      apex_debug.error
      (
        p_message => 'Error during flow_services.send_email. SQLERRM: %s'
      , p0        => sqlerrm
      );
      raise e_email_failed;

    end send_email;

end flow_services;
/

create or replace package body flow_services
as
  g_workspace varchar2(100) := flow_engine_util.get_config_value(
                                   p_config_key    => 'default_workspace'
                                 , p_default_value => flow_constants_pkg.gc_config_default_default_workspace
                               );

  procedure set_workspace_id(
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

  procedure send_email(
      pi_prcs_id in flow_processes.prcs_id%type
    , pi_sbfl_id in flow_subflows.sbfl_id%type
    , pi_objt_id in flow_objects.objt_id%type
   )
    is
      l_from             flow_object_attributes.obat_vc_value%type;
      l_to               flow_object_attributes.obat_vc_value%type;
      l_cc               flow_object_attributes.obat_vc_value%type;
      l_bcc              flow_object_attributes.obat_vc_value%type;
      l_reply_to         flow_object_attributes.obat_vc_value%type;
      l_use_template     flow_object_attributes.obat_vc_value%type;
      l_template_id      flow_object_attributes.obat_vc_value%type;
      l_placeholders     flow_object_attributes.obat_clob_value%type;
      l_immediate        flow_object_attributes.obat_vc_value%type;
      l_application_id   flow_object_attributes.obat_vc_value%type;
      l_subject          flow_object_attributes.obat_vc_value%type;
      l_body             flow_object_attributes.obat_clob_value%type;
      l_body_html        flow_object_attributes.obat_clob_value%type;
      l_attachment_query flow_object_attributes.obat_vc_value%type;
      l_mail_id          number;
      type t_attachment  is record (file_name varchar2(200), mime_type varchar2(200), blob_content blob );
      type t_attachments is table of t_attachment;
      l_attachments      t_attachments;
      l_workspace        varchar2(100);
      l_session          varchar2(20) := v('APP_SESSION');
    begin
      apex_debug.enter 
      ( 'send_email'
      , 'pi_objt_id', pi_objt_id
      );

      flow_globals.set_context 
      ( pi_prcs_id => pi_prcs_id
      , pi_sbfl_id => pi_sbfl_id 
      );

      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          , obat.obat_clob_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_email_from,
                                 flow_constants_pkg.gc_apex_servicetask_email_to,            
                                 flow_constants_pkg.gc_apex_servicetask_email_cc,            
                                 flow_constants_pkg.gc_apex_servicetask_email_bcc,     
                                 flow_constants_pkg.gc_apex_servicetask_email_reply_to,      
                                 flow_constants_pkg.gc_apex_servicetask_use_template,  
                                 flow_constants_pkg.gc_apex_servicetask_application_id,
                                 flow_constants_pkg.gc_apex_servicetask_template_id,   
                                 flow_constants_pkg.gc_apex_servicetask_placeholder,
                                 flow_constants_pkg.gc_apex_servicetask_immediately,
                                 flow_constants_pkg.gc_apex_servicetask_subject,
                                 flow_constants_pkg.gc_apex_servicetask_body_text,
                                 flow_constants_pkg.gc_apex_servicetask_body_html,
                                 flow_constants_pkg.gc_apex_servicetask_attachment
                              )
      )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_apex_servicetask_email_from then
            l_from := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_from );
          when flow_constants_pkg.gc_apex_servicetask_email_to then
            l_to := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_to );
          when flow_constants_pkg.gc_apex_servicetask_email_cc then
            l_cc := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_cc );
          when flow_constants_pkg.gc_apex_servicetask_email_bcc then
            l_bcc := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_bcc );
          when flow_constants_pkg.gc_apex_servicetask_email_reply_to then
            l_reply_to := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_reply_to );
          when flow_constants_pkg.gc_apex_servicetask_use_template then
            l_use_template := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_application_id then
            l_application_id := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_template_id then
            l_template_id := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_placeholder then
            l_placeholders := rec.obat_clob_value;
          when flow_constants_pkg.gc_apex_servicetask_immediately then
            l_immediate := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_subject then
            l_subject := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_subject );
          when flow_constants_pkg.gc_apex_servicetask_body_text then
            l_body := rec.obat_clob_value;
          when flow_constants_pkg.gc_apex_servicetask_body_html then
            l_body_html := rec.obat_clob_value;
          when flow_constants_pkg.gc_apex_servicetask_attachment then
            l_attachment_query := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_attachment_query );
        else
          null;
        end case;
      end loop;

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

        if l_use_template = 'false' then
          l_workspace := g_workspace;
          if (l_workspace is null) then
            raise e_no_default_workspace;
          end if;
        else
          begin
            select workspace 
            into l_workspace
            from apex_applications
            where application_id = l_application_id;
          exception when no_data_found then
            raise e_workspace_not_found;
          end;
        end if;

        set_workspace_id(p_workspace_name => l_workspace);
      end if;

      if (l_use_template = 'true') then
        if l_application_id is null or l_template_id is null then
          raise e_email_no_template;
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

      if (l_immediate = 'true') then
        apex_mail.push_queue;
      end if;
    
    exception
    when e_no_default_workspace then
      apex_debug.error
      (
        p_message => 'Default workspace is empty'
      , p0        => sqlerrm
      );
      raise e_no_default_workspace;
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

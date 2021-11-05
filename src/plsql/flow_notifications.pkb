create or replace package body flow_notifications
as
  g_workspace varchar2(100) := flow_engine_util.get_config_value(
                                   p_config_key    => 'default_workspace'
                                 , p_default_value => flow_constants_pkg.gc_config_default_default_workspace
                               );

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
      l_placeholders     flow_object_attributes.obat_vc_value%type;
      l_immediate        flow_object_attributes.obat_vc_value%type;
      l_app_alias        flow_object_attributes.obat_vc_value%type;
      l_subject          flow_object_attributes.obat_vc_value%type;
      l_body             flow_object_attributes.obat_vc_value%type;
      l_body_html        flow_object_attributes.obat_vc_value%type;
      l_attachment_query flow_object_attributes.obat_vc_value%type;
      l_workspace_id     number;
      l_workspace        varchar2(100);
      l_mail_id          number;
      type t_attachment  is record (file_name varchar2(200), mime_type varchar2(200), blob_content blob );
      type t_attachments is table of t_attachment;
      l_attachments      t_attachments;
      l_application_id   number;
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
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_from,
                                 flow_constants_pkg.gc_apex_servicetask_to,            
                                 flow_constants_pkg.gc_apex_servicetask_cc,            
                                 flow_constants_pkg.gc_apex_servicetask_bcc,     
                                 flow_constants_pkg.gc_apex_servicetask_reply_to,      
                                 flow_constants_pkg.gc_apex_servicetask_use_template,  
                                 flow_constants_pkg.gc_apex_servicetask_app_alias,
                                 flow_constants_pkg.gc_apex_servicetask_template_id,   
                                 flow_constants_pkg.gc_apex_servicetask_placeholders,
                                 flow_constants_pkg.gc_apex_servicetask_send_immediate,
                                 flow_constants_pkg.gc_apex_servicetask_subject,
                                 flow_constants_pkg.gc_apex_servicetask_body,
                                 flow_constants_pkg.gc_apex_servicetask_body_html,
                                 flow_constants_pkg.gc_apex_servicetask_attachments
                              )
      )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_apex_servicetask_from then
            l_from := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_from );
          when flow_constants_pkg.gc_apex_servicetask_to then
            l_to := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_to );
          when flow_constants_pkg.gc_apex_servicetask_cc then
            l_cc := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_cc );
          when flow_constants_pkg.gc_apex_servicetask_bcc then
            l_bcc := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_bcc );
          when flow_constants_pkg.gc_apex_servicetask_reply_to then
            l_reply_to := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_reply_to );
          when flow_constants_pkg.gc_apex_servicetask_use_template then
            l_use_template := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_app_alias then
            l_app_alias := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_template_id then
            l_template_id := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_template_id );
          when flow_constants_pkg.gc_apex_servicetask_placeholders then
            l_placeholders := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_placeholders );
          when flow_constants_pkg.gc_apex_servicetask_send_immediate then
            l_immediate := rec.obat_vc_value;
          when flow_constants_pkg.gc_apex_servicetask_subject then
            l_subject := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_subject );
          when flow_constants_pkg.gc_apex_servicetask_body then
            l_body := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_body );
          when flow_constants_pkg.gc_apex_servicetask_body_html then
            l_body_html := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_body_html );
          when flow_constants_pkg.gc_apex_servicetask_attachments then
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

      if ( l_session is null ) then
        if l_app_alias is null then
          l_workspace := g_workspace;
        else
          select workspace 
          into l_workspace
          from apex_applications
          where alias = l_app_alias;
        end if;

        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      if (l_use_template = 'true') then
        if l_app_alias is null or l_template_id is null then
          raise e_email_no_template;
        end if;

        select application_id
        into l_application_id
        from apex_applications
        where alias = l_app_alias;

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
    when e_email_no_from then 
      apex_debug.error
      (
        p_message => 'Email service task requires from attribute'
      , p0        => sqlerrm
      );
      raise e_email_no_from; 
    when e_email_no_to then 
      apex_debug.error
      (
        p_message => 'Email service task requires to attribute'
      , p0        => sqlerrm
      );
      raise e_email_no_to;  
    when e_email_no_template then
      apex_debug.error
      (
        p_message => 'Email service task use email template but no template define'
      , p0        => sqlerrm
      );
      raise e_email_no_template;  
    when e_email_no_body then
      apex_debug.error
      (
        p_message => 'Email service task body is missing'
      , p0        => sqlerrm
      );
      raise e_email_no_body;  
    when others then
      apex_debug.error
      (
        p_message => 'Error during flow_notifications.send_email. SQLERRM: %s'
      , p0        => sqlerrm
      );
      raise e_email_failed;

    end send_email;

    procedure send_slack_message(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_slack_channel flow_object_attributes.obat_vc_value%type;
      l_slack_url     flow_object_attributes.obat_vc_value%type;
      l_slack_message flow_object_attributes.obat_vc_value%type;
      l_response      clob;
      l_session       varchar2(20) := v('APP_SESSION');
      l_workspace_id  number;
      l_workspace     varchar2(100);
      l_body          json_object_t;
    begin
      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_slack_channel,
                                 flow_constants_pkg.gc_apex_servicetask_slack_url,            
                                 flow_constants_pkg.gc_apex_servicetask_slack_message
                              )
      )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_apex_servicetask_slack_channel then
            l_slack_channel := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_slack_channel );
          when flow_constants_pkg.gc_apex_servicetask_slack_url then
            l_slack_url := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_slack_url );
          when flow_constants_pkg.gc_apex_servicetask_slack_message then
            l_slack_message := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_slack_message );
          else
          null;
        end case;
      end loop;

      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := 'application/json';
      
      l_body := json_object_t('{}');
      l_body.put('channel', l_slack_channel);
      l_body.put('text', l_slack_message);

      l_response := apex_web_service.make_rest_request(
        p_url => l_slack_url,
        p_http_method => 'POST',
        p_body => l_body.to_Clob()
      );

      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);
    end send_slack_message;

    procedure send_teams_message(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_teams_url     flow_object_attributes.obat_vc_value%type;
      l_teams_message flow_object_attributes.obat_vc_value%type;
      l_response      clob;
      l_session       varchar2(20) := v('APP_SESSION');
      l_workspace_id  number;
      l_workspace     varchar2(100);
    begin
      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_teams_url,
                                 flow_constants_pkg.gc_apex_servicetask_teams_message         
                              )
      )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_apex_servicetask_teams_url then
            l_teams_url := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_teams_url );
          when flow_constants_pkg.gc_apex_servicetask_teams_message then
            l_teams_message := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_teams_message );
          else
          null;
        end case;
      end loop;
      
      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := 'application/json';

      l_response := apex_web_service.make_rest_request(
        p_url => l_teams_url,
        p_http_method => 'POST',
        p_body => l_teams_message
      );
 
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);
    end send_teams_message;

    procedure send_gchat_message(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_gchat_url     flow_object_attributes.obat_vc_value%type;
      l_gchat_message flow_object_attributes.obat_vc_value%type;
      l_response            clob;
      l_session             varchar2(20) := v('APP_SESSION');
      l_workspace_id        number;
      l_workspace           varchar2(100);
    begin
      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_gchat_url,
                                 flow_constants_pkg.gc_apex_servicetask_gchat_message         
                              )
      )
      loop
        case rec.obat_key
          when flow_constants_pkg.gc_apex_servicetask_gchat_url then
            l_gchat_url := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_gchat_url );
          when flow_constants_pkg.gc_apex_servicetask_gchat_message then
            l_gchat_message := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_gchat_message );
          else
          null;
        end case;
      end loop;
      
      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := 'application/json';

      l_response := apex_web_service.make_rest_request(
        p_url => l_gchat_url,
        p_http_method => 'POST',
        p_body => l_gchat_message
      );
 
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);
    end send_gchat_message;

    procedure twilio_send_sms(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_twilio_url               flow_object_attributes.obat_vc_value%type;
      l_twilio_messaging_service flow_object_attributes.obat_vc_value%type;
      l_twilio_to                flow_object_attributes.obat_vc_value%type;
      l_twilio_message           flow_object_attributes.obat_vc_value%type;
      l_response                 clob;
      l_session                  varchar2(20) := v('APP_SESSION');
      l_workspace_id             number;
      l_workspace                varchar2(100);
    begin
      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_twilio_url,
                                 flow_constants_pkg.gc_apex_servicetask_twilio_messaging_service,
                                 flow_constants_pkg.gc_apex_servicetask_twilio_to,
                                 flow_constants_pkg.gc_apex_servicetask_twilio_message       
                              )
      )
      loop
        case rec.obat_key
        
          when flow_constants_pkg.gc_apex_servicetask_twilio_url then
            l_twilio_url := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_twilio_url );
          when flow_constants_pkg.gc_apex_servicetask_twilio_messaging_service then
            l_twilio_messaging_service := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_twilio_messaging_service );
          when flow_constants_pkg.gc_apex_servicetask_twilio_to then
            l_twilio_to := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_twilio_to );
          when flow_constants_pkg.gc_apex_servicetask_twilio_message then
            l_twilio_message := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_twilio_message );
          else
          null;
        end case;
      end loop;

      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';

      l_response := apex_web_service.make_rest_request(
        p_url => l_twilio_url,
        p_http_method => 'POST',
        p_parm_name => apex_util.string_to_table( 'Body:MessagingServiceSid:To' ),
        p_parm_value => apex_util.string_to_table( l_twilio_message || ':' || l_twilio_messaging_service || ':' || l_twilio_to ),
        p_credential_static_id => 'Twilio'
      );

      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);

    end twilio_send_sms;


    procedure upload_file_to_dropbox(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_refresh_token      varchar2(4000) := 'RFUqrAw3AFMAAAAAAAAAASJi95QUob-OJB_HnN1eujw6Cx0d68dSMD9_ITotOb-g';
      l_acess_token        varchar2(4000);
      l_token_url          varchar2(200) := 'https://api.dropboxapi.com/oauth2/token';
      l_upload_url         varchar2(200) := 'https://content.dropboxapi.com/2/files/upload';
      l_last_token_refresh number;
      l_response           clob;
      l_session            varchar2(20) := v('APP_SESSION');
      l_workspace_id       number;
      l_workspace          varchar2(100); 
      l_obj                json_object_t;
      l_file_name          varchar2(4000);
      l_blob_content       blob;
      l_file_query         varchar2(4000);
    begin

      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      select (sysdate - last_updated_on) * 24 * 60 * 60
      into l_last_token_refresh
      from apex_workspace_credentials
      where static_id = 'Dropbox_Bearer';

      if l_last_token_refresh > 14000 then
        --need refresh
        apex_web_service.g_request_headers.delete();

        l_response := apex_web_service.make_rest_request(
          p_url => l_token_url,
          p_http_method => 'POST',
          p_parm_name => apex_util.string_to_table( 'grant_type:refresh_token' ),
          p_parm_value => apex_util.string_to_table( 'refresh_token' || ':' || l_refresh_token ),
          p_credential_static_id => 'Dropbox_Basic'
        );

        flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'TOKEN_CODE', pi_num_value => apex_web_service.g_status_code);
        flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'TOKEN_RESPONSE', pi_clob_value => l_response); 

        if (apex_web_service.g_status_code = 200) then
          l_obj := json_object_t(l_response);
          l_acess_token := l_obj.get_String('access_token');
        
          apex_credential.set_persistent_credentials (
              p_credential_static_id  => 'Dropbox_Bearer',
              p_client_id             => 'Authorization',
              p_client_secret         => 'Bearer ' || l_acess_token 
          );
        end if;
      end if;

      l_file_query := q'[select '/logo/logo_' ||to_char(sysdate, 'YYYYMMDD_HH24MISS') ||'.png', blob_content
      from apex_application_files
      where id = '6422679803629985005']';

      execute immediate l_file_query into l_file_name, l_blob_content;
      
      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := 'application/octet-stream';
      apex_web_service.g_request_headers(2).name := 'Dropbox-API-Arg';  
      apex_web_service.g_request_headers(2).value := '{"path":"' || l_file_name || '"}';
      
      l_response := apex_web_service.make_rest_request(
          p_url => l_upload_url,
          p_http_method => 'POST',
          p_body_blob => l_blob_content,
          p_credential_static_id => 'Dropbox_Bearer'
        );

      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);  

    end upload_file_to_dropbox;

    procedure upload_file_to_oci(  
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_upload_url         varchar2(200) := 'https://objectstorage.eu-frankfurt-1.oraclecloud.com/n/frhgzrirrszr/';
      l_bucket_name        varchar2(200) := 'apex_file_storage';
      l_response           clob;
      l_session            varchar2(20) := v('APP_SESSION');
      l_workspace_id       number;
      l_workspace          varchar2(100); 
      l_file_name          varchar2(4000);
      l_mime_type          varchar(200);
      l_blob_content       blob;
      l_file_query         varchar2(4000);
    begin

      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      l_file_query := q'[select 'logo_' ||to_char(sysdate, 'YYYYMMDD_HH24MISS') ||'.png', 'image/png', blob_content
      from apex_application_files
      where id = '6422679803629985005']';

      execute immediate l_file_query into l_file_name, l_mime_type, l_blob_content;
      
      apex_web_service.g_request_headers.delete();
      apex_web_service.g_request_headers(1).name := 'Content-Type';  
      apex_web_service.g_request_headers(1).value := l_mime_type;
      
      l_response := apex_web_service.make_rest_request(
          p_url => l_upload_url || 'b/' || l_bucket_name || '/o/' || apex_util.url_encode(l_file_name),
          p_http_method => 'PUT',
          p_body_blob => l_blob_content,
          p_credential_static_id => 'OCI_API_ACCESS'
        );

      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
      flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);  

      
    end upload_file_to_oci;

    procedure upload_file_to_onedrive(
        pi_prcs_id in flow_processes.prcs_id%type
      , pi_sbfl_id in flow_subflows.sbfl_id%type
      , pi_objt_id in flow_objects.objt_id%type
    )
    is
      l_context            apex_exec.t_context;
      l_acess_token        varchar2(4000);
      l_token_base_url     varchar2(200) := 'https://login.microsoftonline.com';
      l_token_endpoint     varchar2(200) := '/oauth2/v2.0/token';
      l_base_url           varchar2(200) := 'https://graph.microsoft.com/v1.0';
      l_last_token_refresh number;
      l_response           clob;
      l_session            varchar2(20) := v('APP_SESSION');
      l_workspace_id       number;
      l_workspace          varchar2(100); 
      l_object             json_object_t;
      l_array              json_array_t;
      l_element            json_element_t;
      l_file_name          varchar2(4000);
      l_blob_content       blob;
      l_file_query         varchar2(4000);
      l_microsoft_tenant   flow_object_attributes.obat_vc_value%type;
      l_microsoft_site     flow_object_attributes.obat_vc_value%type;
      l_microsoft_folder   flow_object_attributes.obat_vc_value%type;
      l_microsoft_files    flow_object_attributes.obat_vc_value%type;  
      l_site_id            varchar2(500);
    begin
      apex_debug.message('>>> start');
      for rec in (
      select obat.obat_key
          , obat.obat_vc_value
          from flow_object_attributes obat
      where obat.obat_objt_id = pi_objt_id
          and obat.obat_key in ( flow_constants_pkg.gc_apex_servicetask_microsoft_tenant,
                                 flow_constants_pkg.gc_apex_servicetask_microsoft_site,
                                 flow_constants_pkg.gc_apex_servicetask_microsoft_folder,
                                 flow_constants_pkg.gc_apex_servicetask_microsoft_files    
                              )
      )
      loop
        case rec.obat_key
        
          when flow_constants_pkg.gc_apex_servicetask_microsoft_tenant then
            l_microsoft_tenant := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_microsoft_tenant );
          when flow_constants_pkg.gc_apex_servicetask_microsoft_site then
            l_microsoft_site := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_microsoft_site );
          when flow_constants_pkg.gc_apex_servicetask_microsoft_folder then
            l_microsoft_folder := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_microsoft_folder );
          when flow_constants_pkg.gc_apex_servicetask_microsoft_files then
            l_microsoft_files := rec.obat_vc_value;
            flow_process_vars.do_substitution( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id, pio_string => l_microsoft_files );
          else
          null;
        end case;
      end loop;

      apex_debug.message('>>> l_microsoft_tenant '|| l_microsoft_tenant);
      apex_debug.message('>>> l_microsoft_site '|| l_microsoft_site);
      apex_debug.message('>>> l_microsoft_folder '|| l_microsoft_folder);
      apex_debug.message('>>> l_microsoft_files '|| l_microsoft_files);

      if ( l_session is null ) then
        l_workspace := g_workspace;
        l_workspace_id := apex_util.find_security_group_id (p_workspace => l_workspace);
        apex_util.set_security_group_id (p_security_group_id => l_workspace_id);
      end if;

      apex_debug.message('>>> workspace ok');

      select (sysdate - last_updated_on) * 24 * 60 * 60
      into l_last_token_refresh
      from apex_workspace_credentials
      where static_id = 'Microsoft_Bearer';

      apex_debug.message('>>> l_last_token_refresh ' || l_last_token_refresh);

      if l_last_token_refresh > 3500 then
        --need refresh
        apex_debug.message('>>> token need refresh '); 
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';  
        apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';

        l_response := apex_web_service.make_rest_request(
          p_url => l_token_base_url|| '/' || l_microsoft_tenant || l_token_endpoint,
          p_http_method => 'POST',
          p_parm_name => apex_util.string_to_table( 'grant_type:scope' ),
          p_parm_value => apex_util.string_to_table( 'client_credentials,https://graph.microsoft.com/.default', ',' ),
          p_credential_static_id => 'Microsoft_Basic'
        );
        
        flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
        flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);  

        if (apex_web_service.g_status_code = 200) then
          l_object := json_object_t(l_response);
          l_acess_token := l_object.get_String('access_token');
        
          apex_credential.set_persistent_credentials (
              p_credential_static_id  => 'Microsoft_Bearer',
              p_client_id             => 'Authorization',
              p_client_secret         => 'Bearer ' || l_acess_token 
          );
        end if;
      end if;

      apex_debug.message('>>> token ok or refreshed'); 

      --Find the site id
      apex_web_service.g_request_headers.delete();
      l_response := apex_web_service.make_rest_request(
        p_url => l_base_url || '/sites',
        p_http_method => 'GET',
        p_parm_name => apex_util.string_to_table( 'select:search' ),
        p_parm_value => apex_util.string_to_table( 'name,id:' || l_microsoft_site ),
        p_credential_static_id => 'Microsoft_Bearer'
      );

      if (apex_web_service.g_status_code = 200) then
        l_object := json_object_t(l_response);
        l_array := l_object.get_array('value');
        --To do raise error if not found or found more than 1
        l_element := l_array.get(0);
        if l_element.is_object then
          l_object := treat(l_element as json_object_t);
          l_site_id := l_object.get_String('id');
        else
          --to do raise error
          null;
        end if;
      end if;

      apex_debug.message('>>> l_site_id '||l_site_id);

      --Check if folder exists
      --raise error if not
      
      l_context         := 
        apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
         , p_sql_query  => l_microsoft_files
        );

        while apex_exec.next_row(l_context) loop
          l_file_name    := apex_exec.get_varchar2( l_context, 1 );
          l_blob_content := apex_exec.get_blob( l_context, 2);

          apex_web_service.g_request_headers.delete();
          apex_web_service.g_request_headers(1).name := 'Content-Type';  
          apex_web_service.g_request_headers(1).value := 'application/json';
            
          l_response := apex_web_service.make_rest_request(
              p_url => l_base_url 
                       || '/sites/' 
                       || l_site_id 
                       || '/drive/root:/' 
                       || l_microsoft_folder
                       || '/' || l_file_name 
                       || ':/content',
              p_http_method => 'PUT',
              p_body_blob => l_blob_content,
              p_credential_static_id => 'Microsoft_Bearer'
            );

          flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'CODE', pi_num_value => apex_web_service.g_status_code);
          flow_process_vars.set_var(pi_prcs_id => pi_prcs_id, pi_var_name => 'RESPONSE', pi_clob_value => l_response);  
         end loop;
         apex_exec.close(l_context);
         apex_debug.message('>>> upload complete');
    end upload_file_to_onedrive;

end flow_notifications;
/

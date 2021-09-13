create or replace PACKAGE  "EXPENSE_PKG" as 
 
procedure advise_employee; 
 
procedure make_payment; 
 
procedure send_reminder; 
 
procedure finish_expense;

function check_limit return varchar2;
 
end; 
/

create or replace PACKAGE BODY  "EXPENSE_PKG" as 
 
    procedure advise_employee as 
        l_prcs_id number;
        l_business_ref number;
        l_expe_name expenses.expe_name%type; 
        l_expe_created_by expenses.expe_created_by%type; 
        l_email varchar2(255);
        l_body clob; 
    begin 
        -- retrieve process id 
        l_prcs_id := flow_plsql_runner_pkg.get_current_prcs_id; 

        -- retrieve business ref
        l_business_ref := flow_process_vars.get_var_vc2(l_prcs_id, 'BUSINESS_REF');
 
        -- retrieve expense name and employee name 
        select expe_name, expe_created_by into l_expe_name, l_expe_created_by from expenses where expe_id = l_business_ref; 
 
        -- retrieve users email 
        l_email := apex_util.get_email(p_username => l_expe_created_by); 
         
        -- build email text 
        l_body := 'Your expense report ' || l_expe_name ||  ' has been rejected.' ||utl_tcp.crlf; 
         
        -- send email 
        apex_mail.send( 
            p_to   => l_email, 
            p_from => l_email, 
            p_body => l_body, 
            p_subj => 'Your expense report'); 
    end; 
 
    procedure make_payment as 
        l_prcs_id number;
        l_business_ref number;
    begin 
        -- retrieve process id 
        l_prcs_id := flow_plsql_runner_pkg.get_current_prcs_id;

        -- retrieve business ref
        l_business_ref := flow_process_vars.get_var_vc2(l_prcs_id, 'BUSINESS_REF');
         
        -- set expense status 
        update expenses 
        set expe_status = 'paid' 
        where expe_id = l_business_ref;
    end; 
 
    procedure send_reminder as 
        l_prcs_id number;
        l_business_ref number;
        l_expe_name expenses.expe_name%type;
        l_expe_created_by expenses.expe_created_by%type;
        l_email varchar2(255); 
        l_email_sender varchar2(255); 
        l_body clob; 
    begin 
        -- retrieve process id 
        l_prcs_id := flow_plsql_runner_pkg.get_current_prcs_id;

        -- retrieve business ref
        l_business_ref := flow_process_vars.get_var_vc2(l_prcs_id, 'BUSINESS_REF');
 
        -- reset Workspace after timer
        apex_util.set_workspace (p_workspace => v('WORKSPACE_ID'));
         
        -- retrieve expense name and employee name 
        select expe_name, expe_created_by into l_expe_name, l_expe_created_by from expenses where expe_id = l_business_ref; 
 
        -- retrieve users email 
        l_email_sender := apex_util.get_email(p_username => l_expe_created_by); 
         
        -- retrieve responsible users emails 
        select listagg(apex_util.get_email(p_username => user_name),',') within group (order by user_name) into l_email 
        from apex_appl_acl_user_roles join flow_task_inbox_vw on sbfl_current_lane = role_static_id 
        where sbfl_prcs_id = l_prcs_id; 
 
        -- build email text 
        l_body := 'Reminder Review expense report ' || l_expe_name ||  '.' ||utl_tcp.crlf; 
         
        -- send email 
        apex_mail.send( 
            p_to   => l_email, 
            p_from => l_email_sender, 
            p_body => l_body, 
            p_subj => 'Reminder Review expense report'); 
    end; 
 
    procedure finish_expense as  
        l_prcs_id number; 
        l_business_ref number; 
        l_expe_name expenses.expe_name%type; 
        l_expe_created_by varchar2(255);  
        l_email varchar2(255);  
        l_body clob;  
    begin  
        -- retrieve process id  
        l_prcs_id := flow_plsql_runner_pkg.get_current_prcs_id; 
 
        -- retrieve business ref 
        l_business_ref := flow_process_vars.get_var_vc2(l_prcs_id, 'BUSINESS_REF'); 
  
        -- retrieve expense name and employee name  
        select expe_name, expe_created_by into l_expe_name, l_expe_created_by from expenses where expe_id = l_business_ref;  
  
        -- retrieve users email  
        l_email := apex_util.get_email(p_username => l_expe_created_by);  
  
        -- build email text  
        l_body := 'Your expense report ' || l_expe_name ||  ' has been paid.' ||utl_tcp.crlf;  
  
        -- send email  
        apex_mail.send(  
            p_to   => l_email,  
            p_from => l_email,  
            p_body => l_body,  
            p_subj => 'Your expense report');  
    end;

    function check_limit return varchar2 
    as 
        l_prcs_id       number;
        l_business_ref number;
        l_value        number; 
        l_bpmn_conn_id  varchar2(20 char); 
    begin 
        l_bpmn_conn_id:= ''; 
        -- retrieve process id  
        l_prcs_id:= flow_globals.process_id;
        -- retrieve business ref  
        l_business_ref := flow_process_vars.get_var_vc2(l_prcs_id, 'BUSINESS_REF'); 
        -- retrieve amount 
        l_value:= flow_process_vars.get_var_num(l_prcs_id, 'VALUE'); 
       
       apex_debug.info('business_ref: %s', l_business_ref);
       
        case 
            when l_value > 50 
        then 
            l_bpmn_conn_id:= 'yes';
        else 
            l_bpmn_conn_id:= 'no';
            update expenses set expe_status = 'approved' where expe_id = l_business_ref;
        end case; 
   
        return l_bpmn_conn_id; 
    end;
 
end;
/
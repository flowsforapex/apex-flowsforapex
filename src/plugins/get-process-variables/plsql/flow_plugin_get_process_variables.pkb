create or replace package body flow_plugin_get_process_variables as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result                   apex_plugin.t_process_exec_result;

      e_var_config     exception;
      e_var_name       exception;

    --attributes
      l_attribute1      p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2      p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3      p_process.attribute_03%type := p_process.attribute_03; -- Subflow ID (APEX item)
      l_attribute4      p_process.attribute_04%type := p_process.attribute_04; -- SQL query (2 columns process id and subflow id)
      l_attribute5      p_process.attribute_05%type := p_process.attribute_05; -- Process Variable(s) Name(s)
      l_attribute6      p_process.attribute_06%type := p_process.attribute_06; -- APEX item(s)


      l_process_id      flow_processes.prcs_id%type;
      l_subflow_id      flow_subflows.sbfl_id%type;

      l_context         apex_exec.t_context;
      l_idx_process_id  pls_integer;
      l_idx_subflow_id  pls_integer;

      l_split_prcs_var apex_t_varchar2;
      l_split_items    apex_t_varchar2;

      type t_prcs_var is table of varchar2(50) index by varchar2(50);
      l_prcs_var t_prcs_var;
      l_prcs_var_type flow_process_variables.prov_var_type%type;
      l_prcs_var_name flow_process_variables.prov_var_name%type;
      l_item_name varchar2(100);

      l_format_mask apex_application_page_items.format_mask%type;
   begin

    --debug
      if apex_application.g_debug then
         apex_plugin_util.debug_process(
            p_plugin   => p_plugin
          , p_process  => p_process
         );
      end if;

      -- Get process Id and subflow Id
      if ( l_attribute1 = 'item' ) then
         l_process_id  := apex_util.get_session_state(p_item => l_attribute2);
         l_subflow_id  := apex_util.get_session_state(p_item => l_attribute3);
      elsif ( l_attribute1 = 'sql' ) then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute4
         );
         l_idx_process_id  := apex_exec.get_column_position(l_context, 'PROCESS_ID');
         l_idx_subflow_id  := apex_exec.get_column_position(l_context, 'SUBFLOW_ID');

         while apex_exec.next_row(l_context) loop
            l_process_id  := apex_exec.get_number(l_context, l_idx_process_id);
            l_subflow_id  := apex_exec.get_number(l_context, l_idx_subflow_id);
         end loop;
         apex_exec.close(l_context);
      end if;

      -- Get process variable(s) name(s)
      l_split_prcs_var := apex_string.split(l_attribute5, ',');

      -- Get APEX item(s) name(s)
      l_split_items := apex_string.split(l_attribute6, ',');

      --Raise exception if number of process variables is not the same of APEX items
      if ( l_split_prcs_var.count() != l_split_items.count() ) then
         raise e_var_config;
      end if;

      -- Get process variables types
      for rec in (
         select prov_var_name, prov_var_type
         from flow_process_variables prov
        where prov.prov_prcs_id = l_process_id
          and prov.prov_var_name in (
             select trim(column_value)
             from apex_string.split(l_attribute5, ',')
          )
      )
      loop
         l_prcs_var(rec.prov_var_name) := rec.prov_var_type;
      end loop;

      --Raise exception when process variable is not define
      if ( l_prcs_var.count != l_split_prcs_var.count ) then
         raise e_var_name;
      end if;

      -- Loop through variables
      for i in l_split_prcs_var.first..l_split_prcs_var.last
      loop
         -- Get process variable name and type
         l_prcs_var_name := trim( l_split_prcs_var( i ) );
         l_prcs_var_type := l_prcs_var( l_prcs_var_name );
         
         --Get APEX item name
         l_item_name := trim( l_split_items( i ) );
        
         if ( l_prcs_var_type = 'VARCHAR2' ) then
            apex_util.set_session_state( 
                 p_name  => l_item_name
               , p_value => flow_process_vars.get_var_vc2(
                                 pi_prcs_id  => l_process_id
                               , pi_var_name => l_prcs_var_name
                            ) 
            );

         elsif ( l_prcs_var_type = 'NUMBER' ) then
            apex_util.set_session_state( 
                 p_name  => l_item_name
               , p_value => flow_process_vars.get_var_num(
                                 pi_prcs_id  => l_process_id
                               , pi_var_name => l_prcs_var_name
                            ) 
            );

         elsif ( l_prcs_var_type = 'DATE' ) then
            --Get format mask for page item
            begin
              select format_mask
              into l_format_mask
              from apex_application_page_items
              where application_id = v('APP_ID')
              and item_name = trim( l_split_items( i ) );

            exception 
               --Handle no_data_found exception for application items
               when no_data_found then
                  l_format_mask := null;
            end;

            -- Use application globalization
            if ( l_format_mask is null ) then
               l_format_mask := v('APP_DATE_TIME_FORMAT');
            end if;
            --Use fixed format if globalization not set
            if ( l_format_mask is null ) then
               l_format_mask := 'dd.mm.yyyy hh24:mi:ss';
            end if;

            apex_util.set_session_state( 
                 p_name  => l_item_name
               , p_value => to_char(flow_process_vars.get_var_date(
                                 pi_prcs_id  => l_process_id
                               , pi_var_name => l_prcs_var_name
                            ), l_format_mask)
            );

         elsif ( l_prcs_var_type = 'CLOB' ) then
            apex_exec.execute_plsql('begin
            :' || l_item_name || q'[ := ']' || flow_process_vars.get_var_clob(
                                 pi_prcs_id  => l_process_id
                               , pi_var_name => l_prcs_var_name
                            ) || q'[';
            end;]');
         end if;
      end loop;

      return l_result;
   exception 
      when e_var_config then
         apex_error.add_error( 
              p_message => 'Wrong number of APEX item(s) or process variable(s).'
            , p_display_location => apex_error.c_on_error_page
         );
      when e_var_name then
         apex_error.add_error( 
              p_message => 'One or more process variable(s) do not exists.'
            , p_display_location => apex_error.c_on_error_page
         );
   end execution;

end flow_plugin_get_process_variables;
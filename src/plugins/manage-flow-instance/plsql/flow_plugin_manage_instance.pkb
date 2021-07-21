create or replace package body flow_plugin_manage_instance as

   procedure log_attributes(
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   )
   is
   begin

      apex_debug.info(
           p_message => ' > Process plug-in attributes'
      );
      apex_debug.info(
           p_message => '...Action: %s'
         , p0        => p_process.attribute_01
      );
      
      apex_debug.info(
           p_message => '...Flow %s define by: %s'
         , p0        => case 
                           when p_process.attribute_01 in ( 'create', 'create_and_start' ) then  
                              'Diagram'
                           else 
                              'Instance ID'
                        end
         , p1        => p_process.attribute_03
      );

      if p_process.attribute_03 = 'item' then 
         apex_debug.info(
            p_message => '......Item used: %s - Session state value: %s'
            , p0        => p_process.attribute_04
            , p1        => apex_util.get_session_state(p_item => p_process.attribute_02)
         );
      elsif p_process.attribute_03 = 'sql'  then
         apex_debug.info(
            p_message => '......Query'
         );
         apex_debug.log_long_message(
              p_message => p_process.attribute_06
            , p_level   => apex_debug.c_log_level_info
         );
      elsif p_process.attribute_03 = 'static'  then
         apex_debug.info(
              p_message => '......Static value: %s'
            , p0        => p_process.attribute_05
         );
      elsif p_process.attribute_03 = 'component' then
        apex_debug.info(
            p_message => '......Component Setting: %s'
            , p0        => p_plugin.attribute_01
         );
      end if;

      if p_process.attribute_09 is not null then
         apex_debug.info(
            p_message => '...Return Instance ID into: %s'
            , p0        => p_process.attribute_09
         );
      end if;

      if p_process.attribute_01 in ( 'create', 'create_and_start' ) then

         if p_process.attribute_08 is not null then
            apex_debug.info(
               p_message => '...Process Variable BUSINESS_REF set with item: %s - Session State Value: %s'
               , p0        => p_process.attribute_08
               , p1        => apex_util.get_session_state( p_process.attribute_08 )
            );
         end if;
      end if;

      if p_process.attribute_01 in ( 'create', 'create_and_start', 'start' ) then
         apex_debug.info(
            p_message => '...Set Process Variables: %s'
            , p0        => p_process.attribute_10
         );
         if p_process.attribute_10 = 'json' then
            apex_debug.info(
               p_message => '......JSON'
            );
            apex_debug.log_long_message(
               p_message => p_process.attribute_11
               , p_level   => apex_debug.c_log_level_info
            );
         elsif p_process.attribute_10 = 'sql' then
            apex_debug.info(
               p_message => '......Query'
            );
            apex_debug.log_long_message(
               p_message => p_process.attribute_12
               , p_level   => apex_debug.c_log_level_info
            );
         end if;
      end if;

      apex_debug.info(
           p_message => ' < Process plug-in attributes'
      );
   end log_attributes;

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result          apex_plugin.t_process_exec_result;

      --exceptions
      e_missing_version          exception;
      e_incorrect_variable_type  exception;

      --attributes
      l_attribute1      p_process.attribute_01%type := p_process.attribute_01; -- Action (create/start/create_and_start/reset/delete)
      l_attribute2      p_process.attribute_02%type := p_process.attribute_02; -- Flow Instance Name
      l_attribute3      p_process.attribute_03%type := p_process.attribute_03; -- Select Flow using (static/item/sql/component)
      l_attribute4      p_process.attribute_04%type := p_process.attribute_04; -- APEX item(s) for Instance or Diagram
      l_attribute5      p_process.attribute_05%type := p_process.attribute_05; -- Static Text for Instance or Diagram
      l_attribute6      p_process.attribute_06%type := p_process.attribute_06; -- SQL Query for Instance or Diagram
      l_attribute7      p_process.attribute_07%type := p_process.attribute_07; -- Flow (Diagram) selection based on
      l_attribute8      p_process.attribute_08%type := p_process.attribute_08; -- Set Business Reference
      l_attribute9      p_process.attribute_09%type := p_process.attribute_09; -- Return Instance ID
      l_attribute10     p_process.attribute_10%type := p_process.attribute_10; -- Set Process Variables (json/sql)
      l_attribute11     p_process.attribute_11%type := p_process.attribute_11; -- JSON (variables)
      l_attribute12     p_process.attribute_12%type := p_process.attribute_12; -- SQL (variables)

      l_g_attribute1    p_plugin.attribute_01%type  := p_plugin.attribute_01;  -- Global Flow

      l_context                  apex_exec.t_context;
      l_dgrm_id                  flow_diagrams.dgrm_id%type;
      l_dgrm_name                flow_diagrams.dgrm_name%type;
      l_dgrm_version             flow_diagrams.dgrm_version%type;
      l_prcs_name                flow_processes.prcs_name%type;
      l_prcs_id                  flow_processes.prcs_id%type;
      l_json                     clob;
      l_process_variables        json_array_t;
      l_process_variables_count  number;
      l_process_variable         json_object_t;
      l_var_name                 varchar2(4000);
      l_var_type                 varchar2(4000);
      l_split_values             apex_t_varchar2;

   begin

      --debug
      log_attributes(
           p_plugin   => p_plugin
         , p_process  => p_process
      );

      apex_debug.info(
         p_message => ' > Start %s instance.'
         , p0      => case l_attribute1
                         when 'start' then 'starting'
                         when 'delete' then 'deleting'
                         when 'reset' then 'reseting'
                         when 'create' then 'creating'
                         when 'create_and_start' then 'creating and starting'
                      end  
      );

      if l_attribute3 = 'item' then
         if l_attribute1 in ( 'start', 'delete', 'reset' ) then
            l_prcs_id  := apex_util.get_session_state( p_item => l_attribute4 );
         else
            --Flow is define by name only
            if l_attribute7 = 'name' then
               l_dgrm_name := apex_util.get_session_state( p_item => l_attribute4 );
            --Flow is define by name and version
            elsif l_attribute7 = 'name_and_version' then
               --Value is coma separated
               l_split_values  := apex_string.split( l_attribute4, ',' );
               --Check if item value contains two values otherwise raise error
               if (l_split_values.count != 2) then
                  raise e_missing_version;
               end if;
               l_dgrm_name     := apex_util.get_session_state(p_item => l_split_values(1));
               l_dgrm_version  := apex_util.get_session_state(p_item => l_split_values(2));
            -- Flow is define by id
            elsif l_attribute7 = 'id' then
               --Add test number to raise error
               l_dgrm_id := apex_util.get_session_state( p_item => l_attribute4 );
            end if;
         end if;
   
      elsif l_attribute3 = 'sql' then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
         , p_sql_query  => l_attribute6
         );

         while apex_exec.next_row(l_context) loop
            if l_attribute1 in ( 'start', 'delete', 'reset' ) then
               l_prcs_id  := apex_exec.get_number(l_context, 1);
            else
               if l_attribute7 in ( 'name', 'name_and_version' ) then
                  l_dgrm_name := apex_exec.get_varchar2( l_context, 1 );
                  -- Flow is define by name & version, second column contains flow version
                  if l_attribute7 = 'name_and_version' then
                     l_dgrm_version := apex_exec.get_varchar2( l_context, 2 );
                  end if;
               else
                  -- Flow is define by id, first column contains flow id
                  l_dgrm_id := apex_exec.get_number( l_context, 1 );
               end if;
            end if;
         end loop;
         apex_exec.close(l_context);

      elsif l_attribute3 = 'static' then
         if l_attribute1 in ( 'start', 'delete', 'reset' ) then
            l_prcs_id := l_attribute5;
         else
            --Flow is define by name only
            if l_attribute7 = 'name' then
               l_dgrm_name := l_attribute5;
            --Flow is define by name & version, coma separated
            elsif l_attribute7 = 'name_and_version' then
               l_split_values  := apex_string.split( l_attribute5, ',');
               --Check if item value contains two values otherwise raise error
               if l_split_values.count != 2 then
                  raise e_missing_version;
               end if;
               l_dgrm_name     := l_split_values(1);
               l_dgrm_version  := l_split_values(2);
            -- Flow is define by id
            elsif l_attribute7 = 'id' then
               l_dgrm_id := l_attribute5;
            end if;
         end if;
      elsif l_attribute3 = 'component' then
         if l_attribute1 in ( 'start', 'delete', 'reset' ) then
            l_prcs_id := l_g_attribute1;
         else
            --Flow is define by name only
            if l_attribute7 = 'name' then
               l_dgrm_name := l_g_attribute1;
            --Flow is define by name & version
            elsif l_attribute7 = 'name_and_version' then
               l_split_values  := apex_string.split( l_g_attribute1, ',' );
               --Check if item value contains two values otherwise raise error
               if l_split_values.count != 2 then
                  raise e_missing_version;
               end if;
               l_dgrm_name     := l_split_values(1);
               l_dgrm_version  := l_split_values(2);
            -- Flow is define by id
            elsif l_attribute7 = 'id' then
               l_dgrm_id := l_g_attribute1;
            end if;
         end if;
      end if;
      
      if l_attribute1 = 'delete' then
         -- Call API to delete the instance
         apex_debug.info(
            p_message => '...Delete Flow Instance Id %s'
            , p0        => l_prcs_id
         );
         flow_api_pkg.flow_delete(
            p_process_id  => l_prcs_id
         );
      elsif l_attribute1 = 'start' then
         -- Call API to start the instance
         apex_debug.info(
            p_message => '...Start Flow Instance Id %s'
            , p0        => l_prcs_id
         );
         flow_api_pkg.flow_start(
            p_process_id  => l_prcs_id
         );
      elsif l_attribute1 = 'reset' then
         -- Call API to start the instance
         apex_debug.info(
            p_message => '...Reset Flow Instance Id %s'
            , p0        => l_prcs_id
         );
         flow_api_pkg.flow_reset(
            p_process_id  => l_prcs_id
         );
      elsif l_attribute1 in ( 'create', 'create_and_start' ) then
         apex_debug.info(
            p_message => '...Retrieve FLow Instance Name'
         );
         l_prcs_name := l_attribute2;

         --Create flow instance
         if l_attribute7 in ( 'name', 'name_and_version' ) then
            l_dgrm_name := trim( l_dgrm_name );
            l_dgrm_version := trim( l_dgrm_version );
               
            apex_debug.info(
                 p_message => '...Create Flow instance "%s" with diagram: %s %s'
               , p0        => l_prcs_name
               , p1        => l_dgrm_name
               , p2        => case when l_dgrm_version is not null then apex_string.format( p_message => '(version %s)', p0 => l_dgrm_version) end
            );

            l_prcs_id :=
               flow_api_pkg.flow_create(
                 pi_dgrm_name     => l_dgrm_name
               , pi_dgrm_version  => l_dgrm_version
               , pi_prcs_name     => l_prcs_name
            );
         else
            apex_debug.info(
               p_message => '...Create Flow instance "%s" with diagram id: %s'
               , p0      => l_prcs_name
               , p1      => l_dgrm_id
            );

            l_prcs_id := flow_api_pkg.flow_create(
               pi_dgrm_id    => l_dgrm_id
            , pi_prcs_name  => l_prcs_name
            );
         end if;

         apex_debug.info(
            p_message => ' < Flow instance %s created.'
            , p0      => l_prcs_id
         );
      end if;

      apex_debug.info(
           p_message => ' > Additional actions.'
         , p0        => l_prcs_id
      );

      -- Return instance id in the APEX item provided
      if ( l_attribute9 is not null ) then
         apex_debug.info(
            p_message => '...Return Flow Instance Id into item "%s"'
         , p0        => l_attribute9
         );
         apex_util.set_session_state( l_attribute9, l_prcs_id );
      end if;

      if l_attribute1 in ( 'create', 'create_and_start', 'start' ) then

         --Get JSON for process variables
         if ( l_attribute10 = 'json' ) then
            l_json := l_attribute11;
         elsif ( l_attribute10 = 'sql' ) then
            l_context := apex_exec.open_query_context(
               p_location   => apex_exec.c_location_local_db
            , p_sql_query  => l_attribute12
            );

            while apex_exec.next_row(l_context) loop
               l_json := apex_exec.get_clob(l_context, 1);
            end loop;
            apex_exec.close(l_context);
         end if;

         --Set process variables
         if ( l_attribute10 in (
                  'json', 'sql'
               ) ) then
            apex_debug.info(
               p_message => '...Start setting Flow Instance Variable(s)'
            );
            l_process_variables        := json_array_t(l_json);
            l_process_variables_count  := l_process_variables.get_size();
            for object in 0..l_process_variables_count - 1 loop
               l_process_variable  := json_object_t(l_process_variables.get(object));
               l_var_name          := l_process_variable.get_string('name');
               l_var_type          := l_process_variable.get_string('type');
               case l_var_type
                  when 'varchar2' then
                     apex_debug.info(
                        p_message => '.....Name: %s - Type: %s - Value %s'
                        , p0 => l_var_name
                        , p1 => l_var_type
                        , p2 => l_process_variable.get_string('value')
                     );
                     flow_process_vars.set_var(
                        pi_prcs_id    => l_prcs_id
                     , pi_var_name   => l_var_name
                     , pi_vc2_value  => l_process_variable.get_string('value')
                     );
                  when 'number' then
                     apex_debug.info(
                        p_message => '......Name: %s - Type: %s - Value %s'
                        , p0 => l_var_name
                        , p1 => l_var_type
                        , p2 => l_process_variable.get_number('value')
                     );
                     flow_process_vars.set_var(
                        pi_prcs_id    => l_prcs_id
                     , pi_var_name   => l_var_name
                     , pi_num_value  => l_process_variable.get_number('value')
                     );
                  when 'date' then
                     apex_debug.info(
                        p_message => '......Name: %s - Type: %s - Value %s'
                        , p0 => l_var_name
                        , p1 => l_var_type
                        , p2 => l_process_variable.get_date('value')
                     );
                     flow_process_vars.set_var(
                        pi_prcs_id     => l_prcs_id
                     , pi_var_name    => l_var_name
                     , pi_date_value  => l_process_variable.get_date('value')
                     );
                  when 'clob' then
                     apex_debug.info(
                        p_message => '......Name: %s - Type: %s - Value %s'
                        , p0 => l_var_name
                        , p1 => l_var_type
                        , p2 => l_process_variable.get_clob('value')
                     );
                     flow_process_vars.set_var(
                        pi_prcs_id     => l_prcs_id
                     , pi_var_name    => l_var_name
                     , pi_clob_value  => l_process_variable.get_clob('value')
                     );
                  else
                     raise e_incorrect_variable_type;
               end case;
            end loop;
            apex_debug.info(
               p_message => '...End setting Flow Instance Variable(s)'
            );
         end if;

         if l_attribute1 in ( 'create', 'create_and_start' ) and l_attribute8 is not null then
            apex_debug.info(
               p_message => '...Setting BUSINESS_REF Variable: "%s"'
            , p0        => apex_util.get_session_state(l_attribute8)
            );
            flow_process_vars.set_var(
               pi_prcs_id    => l_prcs_id
            , pi_var_name   => 'BUSINESS_REF'
            , pi_vc2_value  => apex_util.get_session_state(l_attribute8)
            );
         end if;

         --Start flow instance
         if l_attribute1 = 'create_and_start' then
            apex_debug.info(
               p_message => '...Starting Flow Instance %s'
            , p0        => l_prcs_id
            );
            flow_api_pkg.flow_start(p_process_id => l_prcs_id);
         end if;

      end if;

      apex_debug.info(
            p_message => ' < Additional actions.'
            , p0      => l_prcs_id
         );

      return l_result;
   exception 
      when e_missing_version then
         if apex_application.g_debug then
            apex_debug.error(
               p_message => '-- Flows4apex - Plug-in configuration issue, diagram selection is done with name and version but version is not provided.'
            );
         end if;
         apex_error.add_error( 
              p_message => 'Version not defined.'
            , p_display_location => apex_error.c_on_error_page
         );
      when e_incorrect_variable_type then
         if apex_application.g_debug then
            apex_debug.error(
               p_message => '-- Flows4apex - Plug-in configuration issue, process variables JSON contains incorrect variable type.'
            );
         end if;
         apex_error.add_error(
              p_message           => 'Error during parsing process variables.'
            , p_display_location  => apex_error.c_on_error_page
         );
   end execution;
   
end flow_plugin_manage_instance;
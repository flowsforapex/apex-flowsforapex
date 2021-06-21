create or replace package body flow_plugin_create_and_start as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result                   apex_plugin.t_process_exec_result;

      e_missing_version          exception;
      e_incorrect_variable_type  exception;

    --attributes
      l_attribute1               p_process.attribute_01%type := p_process.attribute_01; -- Select Flow (Diagram) using
      l_attribute2               p_process.attribute_02%type := p_process.attribute_02; -- Flow name (items) & Flow version
      l_attribute3               p_process.attribute_03%type := p_process.attribute_03; -- Flow name (query)
      l_attribute4               p_process.attribute_04%type := p_process.attribute_04; -- Flow name (text)
      l_attribute5               p_process.attribute_05%type := p_process.attribute_05; -- Start instance (Y/N)
      l_attribute6               p_process.attribute_06%type := p_process.attribute_06; -- Set pocess variables (list)
      l_attribute7               p_process.attribute_07%type := p_process.attribute_07; -- Flow (Diagram) Selection
      l_attribute8               p_process.attribute_08%type := p_process.attribute_08; -- PV json
      l_attribute9               p_process.attribute_09%type := p_process.attribute_09; -- PV SQL
      l_attribute10              p_process.attribute_10%type := p_process.attribute_10; -- Business Reference
      l_attribute11              p_process.attribute_11%type := p_process.attribute_11; -- Instance Name (item)
      l_attribute12              p_process.attribute_12%type := p_process.attribute_12; -- Return Instance Id
      l_attribute13              p_process.attribute_13%type := p_process.attribute_13; -- Instance Name mode
      l_attribute14              p_process.attribute_14%type := p_process.attribute_14; -- Instance Name (text) 
      l_attribute15              p_process.attribute_15%type := p_process.attribute_15; -- Instance Name (SQL)
      l_g_attribute1             p_plugin.attribute_01%type  := p_plugin.attribute_01;  -- Global attribute
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
      l_sql_parameters           apex_exec.t_parameters;
   begin

    --debug
      if apex_application.g_debug then
         apex_plugin_util.debug_process(
            p_plugin   => p_plugin
          , p_process  => p_process
         );
      end if;

      -- Handle flow name instance
      if ( l_attribute13 = 'item' ) then
         l_prcs_name := apex_util.get_session_state(p_item => l_attribute11);
      elsif ( l_attribute13 = 'sql' ) then
         l_context := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute15
         );
         while apex_exec.next_row(l_context) loop
            l_prcs_name := apex_exec.get_varchar2(l_context, 1);
         end loop;
      elsif ( l_attribute13 = 'static' ) then
         l_prcs_name := l_attribute14;
      end if;

      -- Retrieve flow to be created
      -- Flow is define by item (page or application)
      if ( l_attribute1 = 'item' ) then
         --Flow is define by name only
         if l_attribute7 = 'name' then
            l_dgrm_name := apex_util.get_session_state(p_item => l_attribute2);
         --Flow is define by name and version
         elsif l_attribute7 = 'name_and_version' then
            --Value is coma separated
            l_split_values  := apex_string.split(l_attribute2, ',');
            --Check if item value contains two values otherwise raise error
            if (l_split_values.count != 2) then
               raise e_missing_version;
            end if;
            l_dgrm_name     := apex_util.get_session_state(p_item => l_split_values(1));
            l_dgrm_version  := apex_util.get_session_state(p_item => l_split_values(2));
         -- Flow is define by id
         elsif l_attribute7 = 'id' then
            l_dgrm_id := apex_util.get_session_state(p_item => l_attribute2);
         end if;

      --Flow is define by SQL query
      elsif ( l_attribute1 = 'sql' ) then
         l_context := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute3
         );

         while apex_exec.next_row(l_context) loop
            -- Flow is define by name or name & version, first column contains flow name
            if l_attribute7 in (
                      'name', 'name_and_version'
                   ) then
               l_dgrm_name := apex_exec.get_varchar2(l_context, 1);
            -- Flow is define by name & version, second column contains flow version
            elsif l_attribute7 = 'name_and_version' then
               l_dgrm_version := apex_exec.get_varchar2(l_context, 2);
            -- Flow is define by id, first column contains flow id
            elsif l_attribute7 = 'id' then
               l_dgrm_id := apex_exec.get_number(l_context, 1);
            end if;
         end loop;
         apex_exec.close(l_context);

      -- Flow is define by static text
      elsif ( l_attribute1 = 'static' ) then
         --Flow is define by name only
         if l_attribute7 = 'name' then
            l_dgrm_name := l_attribute4;
         --Flow is define by name & version, coma separated
         elsif l_attribute7 = 'name_and_version' then
            l_split_values  := apex_string.split(l_attribute4, ',');
            --Check if item value contains two values otherwise raise error
            if (l_split_values.count != 2) then
               raise e_missing_version;
            end if;
            l_dgrm_name     := l_split_values(1);
            l_dgrm_version  := l_split_values(2);
         -- Flow is define by id
         elsif l_attribute7 = 'id' then
            l_dgrm_id := l_attribute4;
         end if;
      
      -- Flow is define at component setting level
      elsif ( l_attribute1 = 'component' ) then
         --Flow is define by name only
         if l_attribute7 = 'name' then
            l_dgrm_name := l_g_attribute1;
         --Flow is define by name & version
         elsif l_attribute7 = 'name_and_version' then
            l_split_values  := apex_string.split(l_g_attribute1, ',');
            --Check if item value contains two values otherwise raise error
            if (l_split_values.count != 2) then
               raise e_missing_version;
            end if;
            l_dgrm_name     := l_split_values(1);
            l_dgrm_version  := l_split_values(2);
         -- Flow is define by id
         elsif l_attribute7 = 'id' then
            l_dgrm_id := l_g_attribute1;
         end if;
      end if;

      --Create flow instance
      if l_attribute7 in (
                'name', 'name_and_version'
             ) then
         l_prcs_id :=
            flow_api_pkg.flow_create(
               pi_dgrm_name     => l_dgrm_name
             , pi_dgrm_version  => l_dgrm_version
             , pi_prcs_name     => l_prcs_name
            );
      else
         l_prcs_id := flow_api_pkg.flow_create(
            pi_dgrm_id    => l_dgrm_id
          , pi_prcs_name  => l_prcs_name
         );
      end if;

      -- Return instance id in the APEX item provided
      if ( l_attribute12 is not null ) then
         apex_util.set_session_state(l_attribute12, l_prcs_id);
      end if;

      --Get JSON fro process variables
      if ( l_attribute6 = 'json' ) then
         l_json := l_attribute8;
      elsif ( l_attribute6 = 'sql' ) then
         l_context := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute9
         );

         while apex_exec.next_row(l_context) loop
            l_json := apex_exec.get_clob(l_context, 1);
         end loop;
         apex_exec.close(l_context);
      end if;

      if ( l_attribute6 in (
                'json', 'sql'
             ) ) then
         l_process_variables        := json_array_t(l_json);
         l_process_variables_count  := l_process_variables.get_size();
         for object in 0..l_process_variables_count - 1 loop
            l_process_variable  := json_object_t(l_process_variables.get(object));
            l_var_name          := l_process_variable.get_string('name');
            l_var_type          := l_process_variable.get_string('type');
            case l_var_type
               when 'varchar2' then
                  flow_process_vars.set_var(
                     pi_prcs_id    => l_prcs_id
                   , pi_var_name   => l_var_name
                   , pi_vc2_value  => l_process_variable.get_string('value')
                  );
               when 'number' then
                  flow_process_vars.set_var(
                     pi_prcs_id    => l_prcs_id
                   , pi_var_name   => l_var_name
                   , pi_num_value  => l_process_variable.get_number('value')
                  );
               when 'date' then
                  flow_process_vars.set_var(
                     pi_prcs_id     => l_prcs_id
                   , pi_var_name    => l_var_name
                   , pi_date_value  => l_process_variable.get_date('value')
                  );
               when 'clob' then
                  flow_process_vars.set_var(
                     pi_prcs_id     => l_prcs_id
                   , pi_var_name    => l_var_name
                   , pi_clob_value  => l_process_variable.get_clob('value')
                  );
               else
                  raise e_incorrect_variable_type;
            end case;
         end loop;

      end if;

      flow_process_vars.set_var(
         pi_prcs_id    => l_prcs_id
       , pi_var_name   => 'BUSINESS_REF'
       , pi_vc2_value  => apex_util.get_session_state(l_attribute10)
      );

      if ( l_attribute5 = 'Y' ) then
         flow_api_pkg.flow_start(p_process_id => l_prcs_id);
      end if;

      return l_result;
   exception 
      when e_missing_version then
         apex_error.add_error( 
              p_message => 'Version not defined.'
            , p_display_location => apex_error.c_on_error_page
         );
      when e_incorrect_variable_type then
         apex_error.add_error(
              p_message           => 'Error during parsing process variables.'
            , p_display_location  => apex_error.c_on_error_page
         );

   end execution;

end flow_plugin_create_and_start;
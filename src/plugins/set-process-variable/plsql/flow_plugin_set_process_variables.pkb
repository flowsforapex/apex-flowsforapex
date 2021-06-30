create or replace package body flow_plugin_set_process_variables as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result  apex_plugin.t_process_exec_result;
      l_context apex_exec.t_context;

      --attributes
      l_attribute1 p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2 p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3 p_process.attribute_03%type := p_process.attribute_03; -- SQL query (1 column process id)
      l_attribute4 p_process.attribute_04%type := p_process.attribute_04; -- Set Process Variables using
      l_attribute5 p_process.attribute_05%type := p_process.attribute_05; -- Process Variable(s) Name(s)
      l_attribute6 p_process.attribute_06%type := p_process.attribute_06; -- APEX item(s)
      l_attribute7 p_process.attribute_07%type := p_process.attribute_07; -- JSON
      l_attribute8 p_process.attribute_08%type := p_process.attribute_08; -- SQL query (1 column JSON array)

      --exceptions
      e_var_config              exception;
      e_incorrect_variable_type exception;
      e_types_different         exception;
      e_invalid_number          exception;
      e_invalid_date            exception;

      --types
      type t_prcs_var is table of varchar2(50) index by varchar2(50);
      type t_item     is record (item_type varchar2(50), format_mask varchar(50));
      type t_items    is table of t_item index by varchar2(50);

      --collections
      l_prcs_var t_prcs_var;
      l_items    t_items;

      --json
      l_json              clob;
      l_process_variables json_array_t;
      l_process_variable  json_object_t;
      l_json_element      json_element_t;

      --variables
      l_prcs_id         flow_processes.prcs_id%type;
      l_prcs_var_type   flow_process_variables.prov_var_type%type;
      l_prcs_var_name   flow_process_variables.prov_var_name%type;
      l_split_prcs_var  apex_t_varchar2;
      l_split_items     apex_t_varchar2;
      l_item_name       varchar2(4000);
      l_format_mask     apex_application_page_items.format_mask%type;
      l_types_different number;
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
         l_prcs_id  := apex_util.get_session_state(p_item => l_attribute2);
      elsif ( l_attribute1 = 'sql' ) then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute3
         );

         while apex_exec.next_row(l_context) loop
            l_prcs_id  := apex_exec.get_number(l_context, 1);
         end loop;
         apex_exec.close(l_context);
      end if;

      --Set process variables
      if ( l_attribute4 in (
                'json', 'sql'
             ) ) then
         
         --Get JSON for process variables
         if ( l_attribute4 = 'json' ) then
            l_json := l_attribute7;
         elsif ( l_attribute4 = 'sql' ) then
            l_context := apex_exec.open_query_context(
               p_location   => apex_exec.c_location_local_db
            , p_sql_query  => l_attribute8
            );

            while apex_exec.next_row(l_context) loop
               l_json := apex_exec.get_clob(l_context, 1);
            end loop;
            apex_exec.close(l_context);
         end if;

         --Check variables types
         select count(*)
         into l_types_different
         from
            json_table ( l_json ,
            '$[*]'
               columns (
                  name varchar2 ( 4000 ) path '$.name'
               , type varchar2 ( 4000 ) path '$.type'
               )
            ) set_var
            join flow_process_variables prcs_var 
              on prcs_var.prov_var_name = set_var.name 
             and prcs_var.prov_prcs_id = l_prcs_id
            where prcs_var.prov_var_type != upper( set_var.type );
         
         -- Raise exception if incoherent value found
         if ( l_types_different > 0 ) then
            raise e_types_different;
         end if;

         l_process_variables        := json_array_t(l_json);
         for object in 0..l_process_variables.get_size() - 1 loop
            l_process_variable := json_object_t(l_process_variables.get(object));
            l_prcs_var_name    := l_process_variable.get_string('name');
            l_prcs_var_type    := l_process_variable.get_string('type');
            case l_prcs_var_type
               when 'varchar2' then
                  flow_process_vars.set_var(
                     pi_prcs_id    => l_prcs_id
                   , pi_var_name   => l_prcs_var_name
                   , pi_vc2_value  => l_process_variable.get_string('value')
                  );
               when 'number' then
                  l_json_element := l_process_variable.get('value');
                  if ( l_json_element.is_Number() = false ) then
                     raise e_invalid_number;
                  end if;
                  flow_process_vars.set_var(
                     pi_prcs_id    => l_prcs_id
                   , pi_var_name   => l_prcs_var_name
                   , pi_num_value  => l_process_variable.get_number('value')
                  );
               when 'date' then
                  l_json_element := l_process_variable.get('value');
                  if ( l_json_element.is_Date() = false ) then
                     raise e_invalid_date;
                  end if;
                  flow_process_vars.set_var(
                     pi_prcs_id     => l_prcs_id
                   , pi_var_name    => l_prcs_var_name
                   , pi_date_value  => l_process_variable.get_date('value')
                  );
               when 'clob' then
                  flow_process_vars.set_var(
                     pi_prcs_id     => l_prcs_id
                   , pi_var_name    => l_prcs_var_name
                   , pi_clob_value  => l_process_variable.get_clob('value')
                  );
               else
                  raise e_incorrect_variable_type;
            end case;
         end loop;
      elsif ( l_attribute4 = 'item' ) then
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
         where prov.prov_prcs_id = l_prcs_id
            and prov.prov_var_name in (
               select trim(column_value)
               from apex_string.split(l_attribute5, ',')
            )
         )
         loop
            l_prcs_var(rec.prov_var_name) := rec.prov_var_type;
         end loop;

         -- Get items types
         for rec in (
            select column_value as item_name
               , case
                     when aapi.display_as_code = 'NATIVE_NUMBER_FIELD'    then
                        'NUMBER'
                     when aapi.display_as_code = 'NATIVE_DATE_PICKER'     then
                        'DATE'
                     else
                        'VARCHAR2'
                  end as item_type
               , aapi.format_mask
            from apex_string.split(l_attribute6, ',') items
            left outer join apex_application_page_items aapi
               on aapi.item_name = items.column_value
            left outer join apex_application_items aai
               on aai.item_name = items.column_value
         )
         loop
            l_items(rec.item_name).item_type   := rec.item_type;
            l_items(rec.item_name).format_mask := rec.format_mask;
         end loop;

         -- Loop through variables
         for i in l_split_prcs_var.first..l_split_prcs_var.last
         loop
            -- Get process variable name and item name 
            l_prcs_var_name := trim( l_split_prcs_var( i ) );
            l_item_name     := trim( l_split_items( i ) );

            -- Look for variable type
            begin
               l_prcs_var_type := l_prcs_var( l_prcs_var_name );
            exception 
               -- Look for item type
               when no_data_found then
                  l_prcs_var_type := l_items ( l_item_name ).item_type;
            end;
            
            if ( l_prcs_var_type = 'VARCHAR2' ) then
               flow_process_vars.set_var(
                    pi_prcs_id    => l_prcs_id
                  , pi_var_name   => l_prcs_var_name
                  , pi_vc2_value  => apex_util.get_session_state( p_item => l_item_name )
               );

            elsif ( l_prcs_var_type = 'NUMBER' ) then
               flow_process_vars.set_var(
                    pi_prcs_id    => l_prcs_id
                  , pi_var_name   => l_prcs_var_name
                  , pi_num_value  => to_number( apex_util.get_session_state( p_item => l_item_name ) )
               );
            elsif ( l_prcs_var_type = 'DATE' ) then
               l_format_mask := l_items ( l_item_name ).format_mask;

               -- Use application globalization
               if ( l_format_mask is null ) then
                  l_format_mask := v('APP_DATE_TIME_FORMAT');
               end if;
               --Use fixed format if globalization not set
               if ( l_format_mask is null ) then
                  l_format_mask := 'dd.mm.yyyy hh24:mi:ss';
               end if;

               flow_process_vars.set_var(
                    pi_prcs_id     => l_prcs_id
                  , pi_var_name    => l_prcs_var_name
                  , pi_date_value  => to_date( apex_util.get_session_state( p_item => l_item_name ) , l_format_mask)
               );

            elsif ( l_prcs_var_type = 'CLOB' ) then
               flow_process_vars.set_var(
                    pi_prcs_id     => l_prcs_id
                  , pi_var_name    => l_prcs_var_name
                  , pi_clob_value  => apex_util.get_session_state( p_item => l_item_name )
               );
            end if;
         end loop;
      end if;

      return l_result;
   exception 
      when e_var_config then
         apex_error.add_error( 
              p_message => 'Wrong number of APEX item(s) or process variable(s).'
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
      when e_types_different then
         apex_error.add_error(
              p_message           => 'One or more process variable(s) are a different type than the one defined in the JSON.'
            , p_display_location  => apex_error.c_on_error_page
         );
      when e_invalid_number then
         apex_error.add_error(
              p_message           => apex_string.format( '%s is not a valid number.', l_json_element.stringify() )
            , p_display_location  => apex_error.c_on_error_page
         );
      when e_invalid_date then
         apex_error.add_error(
              p_message           => apex_string.format( '%s is not a valid date.', l_json_element.stringify() )
            , p_display_location  => apex_error.c_on_error_page
         );
   end execution;

end flow_plugin_set_process_variables;
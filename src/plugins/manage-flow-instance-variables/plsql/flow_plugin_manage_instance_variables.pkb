create or replace package body flow_plugin_manage_instance_variables as

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
           p_message => '...Flow Instance define by: %s'
         , p0        => p_process.attribute_01
      );

      if p_process.attribute_01 = 'item' then 
         apex_debug.info(
            p_message => '......Flow Instance Item used: %s - Session state value: %s'
            , p0        => p_process.attribute_02
            , p1        => apex_util.get_session_state(p_item => p_process.attribute_02)
         );
		 
         if p_process.attribute_11 is not null then 
            apex_debug.info(
               p_message => '......Flow Subflow Item used: %s - Session state value: %s'
               , p0        => p_process.attribute_11
               , p1        => apex_util.get_session_state(p_item => p_process.attribute_11)
            );
         else
            apex_debug.info(
               p_message => '......No Subflow Item provided'
            );
         end if;
      elsif p_process.attribute_01 = 'sql'  then
         apex_debug.info(
            p_message => '......Query'
         );
         apex_debug.log_long_message(
              p_message => p_process.attribute_03
            , p_level   => apex_debug.c_log_level_info
         );
      end if;

      apex_debug.info(
           p_message => '...Flow Instance Variables action: %s'
         , p0        => p_process.attribute_04
      );

      apex_debug.info(
           p_message => '...Manage Flow Instance Variables using: %s'
         , p0        => p_process.attribute_05
      );

      if p_process.attribute_05 = 'item' then 
         apex_debug.info(
            p_message => '......Flow Instance Variable(s): %s'
            , p0        => p_process.attribute_06
         );
         apex_debug.info(
            p_message => '......APEX item(s): %s'
            , p0        => p_process.attribute_07
         );
      elsif p_process.attribute_01 = 'sql'  then
         apex_debug.info(
            p_message => '......Query'
         );
         apex_debug.log_long_message(
              p_message => p_process.attribute_08
            , p_level   => apex_debug.c_log_level_info
         );
      elsif p_process.attribute_01 = 'json'  then
         apex_debug.info(
            p_message => '......JSON'
         );
         apex_debug.log_long_message(
              p_message => p_process.attribute_09
            , p_level   => apex_debug.c_log_level_info
         );
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
      l_result  apex_plugin.t_process_exec_result;
      l_context apex_exec.t_context;

      --attributes
      l_attribute1  p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2  p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3  p_process.attribute_03%type := p_process.attribute_03; -- SQL query (1 column process id)
      l_attribute4  p_process.attribute_04%type := p_process.attribute_04; -- Action (get/set)
      l_attribute5  p_process.attribute_05%type := p_process.attribute_05; -- Manage Process Variables using
      l_attribute6  p_process.attribute_06%type := p_process.attribute_06; -- Process Variable(s) Name(s)
      l_attribute7  p_process.attribute_07%type := p_process.attribute_07; -- APEX item(s)
      l_attribute8  p_process.attribute_08%type := p_process.attribute_08; -- JSON
      l_attribute9  p_process.attribute_09%type := p_process.attribute_09; -- SQL query (1 column JSON array)
      
	   l_attribute11 p_process.attribute_11%type := p_process.attribute_11; -- Subflow ID (APEX item)																								

      --exceptions
      e_var_config              exception;
      e_incorrect_variable_type exception;
      e_types_different         exception;
      e_invalid_number          exception;
      e_invalid_date            exception;
      e_invalid_json            exception;

      --types
      type t_prcs_var is table of varchar2(50) index by varchar2(50);
      type t_item     is record (item_type varchar2(50), format_mask varchar(50));
      type t_items    is table of t_item index by varchar2(50);

      --collections
      l_prcs_var   t_prcs_var;
      l_items      t_items;
      l_cur_app_id number;

      --json
      l_json              clob;
      l_process_variables json_array_t;
      l_process_variable  json_object_t;
      l_json_element      json_element_t;
      l_dummy_num         number;

      --variables
      l_prcs_id         flow_processes.prcs_id%type;
      l_sbfl_id         flow_subflows.sbfl_id%type;
      l_prov_var_type   flow_process_variables.prov_var_type%type;
      l_prov_var_name   flow_process_variables.prov_var_name%type;
      l_prov_scope      flow_process_variables.prov_scope%type;
      l_prov_var_vc2    flow_process_variables.prov_var_vc2%type;
      l_prov_var_num    flow_process_variables.prov_var_num%type;
      l_prov_var_date   flow_process_variables.prov_var_date%type;
      l_prov_var_clob    flow_process_variables.prov_var_clob%type;
      l_split_prcs_var  apex_t_varchar2;
      l_split_items     apex_t_varchar2;
      l_item_name       varchar2(4000);
      l_format_mask     apex_application_page_items.format_mask%type;
      l_types_different number;
      l_ts              timestamp;
      l_col_count       pls_integer;
   begin

      --debug
      log_attributes(
         p_plugin   => p_plugin
       , p_process  => p_process
      );


      apex_debug.info(
         p_message => '...Retrieve FLow Instance Id'
      );
      -- Get process Id and subflow Id
      if ( l_attribute1 = 'item' ) then
         l_prcs_id  := apex_util.get_session_state(p_item => l_attribute2);
		 
		   if l_attribute11 is not null then
            l_sbfl_id  := apex_util.get_session_state(p_item => l_attribute11);
         end if;								  
      elsif ( l_attribute1 = 'sql' ) then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute3
         );

		   l_col_count := apex_exec.get_column_count( p_context => l_context );

         while apex_exec.next_row(l_context) loop
            l_prcs_id  := apex_exec.get_number(l_context, 1);
			   if l_col_count = 2 then
               l_sbfl_id := apex_exec.get_number(l_context, 2);
            end if;
         end loop;
         apex_exec.close(l_context);
      end if;

      apex_debug.info(
           p_message => '...Flow Instance Id is %s'
         , p0        => l_prcs_id
      );

	  if l_sbfl_id is not null then
         apex_debug.info(
            p_message => '...Flow Subflow Id is %s'
            , p0        => l_sbfl_id
         );

         -- get the scope and current object for the supplied subflow
         select sbfl.sbfl_scope
         into l_prov_scope
         from flow_subflows sbfl
         where sbfl.sbfl_id = l_sbfl_id
         and sbfl.sbfl_prcs_id = l_prcs_id;

      else
         l_prov_scope := 0;
      end if;
      
      apex_debug.info(
         p_message => '...Scope is %s'
         , p0        => l_prov_scope
      );
      apex_debug.info(
           p_message => '...Start %s Flow Instance Variable(s)'
         , p0        => case l_attribute4
                           when 'set' then 'setting'
                           when 'get' then 'getting'
                        end
      );
      --Set process variables
      if ( l_attribute5 in (
                'json', 'sql'
             ) ) then
         
         --Get JSON for process variables
         if ( l_attribute5 = 'json' ) then
            l_json := l_attribute8;
         elsif ( l_attribute5 = 'sql' ) then
            l_context := apex_exec.open_query_context(
               p_location   => apex_exec.c_location_local_db
            , p_sql_query  => l_attribute9
            );

            while apex_exec.next_row(l_context) loop
               l_json := apex_exec.get_clob(l_context, 1);
            end loop;
            apex_exec.close(l_context);
         end if;

         begin
            l_process_variables := json_array_t(l_json);
         exception when others then
            raise e_invalid_json;
         end;
         
         if ( l_attribute4 = 'set' ) then
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
               where prcs_var.prov_var_type != upper( set_var.type )
			   and prcs_var.prov_scope = l_prov_scope;
            
            -- Raise exception if incoherent value found
            if ( l_types_different > 0 ) then
               raise e_types_different;
            end if;
         end if;

         for object in 0..l_process_variables.get_size() - 1 loop
            l_process_variable := json_object_t(l_process_variables.get(object));
            l_prov_var_name    := l_process_variable.get_string('name');
            l_prov_var_type    := l_process_variable.get_string('type');
            l_item_name        := l_process_variable.get_string('item');
            case l_prov_var_type
               when 'varchar2' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_string('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_vc2(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                           pi_prcs_id   => l_prcs_id
						      , pi_scope      => l_prov_scope   
                        , pi_var_name   => l_prov_var_name
                        , pi_vc2_value  => l_process_variable.get_string('value')
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => flow_process_vars.get_var_vc2(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ) 
                        );
                  end case;
               when 'number' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_number('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_num(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        l_json_element := l_process_variable.get('value');
                        if ( l_json_element.is_String and l_process_variable.get_String('value') is not null 
                           ) then
                           l_process_variable.On_error(3);
                           begin
                              l_dummy_num := l_process_variable.get_Number('value');
                           exception
                              when others then
                                l_process_variable.On_error(0);
                                raise e_invalid_number;
                           end;
                        end if;
                        flow_process_vars.set_var(
                             pi_prcs_id   => l_prcs_id
						         , pi_scope     => l_prov_scope	 
                           , pi_var_name  => l_prov_var_name
                           , pi_num_value => case 
                                                when l_process_variable.get_String('value') is null 
                                                   then 
                                                      null 
                                             else 
                                                l_process_variable.get_number('value') 
                                             end
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => flow_process_vars.get_var_num(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ) 
                        );
                  end case;   
               when 'date' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_date('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_date(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        l_json_element := l_process_variable.get('value');
                        begin
                           if instr( l_process_variable.get_String('value'), 'T' ) > 0 then
                              l_ts := to_timestamp_tz( replace ( l_process_variable.get_String('value'), 'T', ' ' ), 'YYYY-MM-DD HH24:MI:SS TZR' ); 
                           else
                              l_ts := to_timestamp_tz( l_process_variable.get_String('value'), 'YYYY-MM-DD TZR' ); 
                           end if;
                        exception when others then
                           raise e_invalid_date;
                        end;
                        flow_process_vars.set_var(
                          pi_prcs_id    => l_prcs_id
						      , pi_scope      => l_prov_scope									
                        , pi_var_name   => l_prov_var_name
                        , pi_date_value => l_process_variable.get_timestamp('value')
                        );
                     when 'get' then
                        apex_exec.execute_plsql(   'begin
                           :' || l_item_name || ' :=  flow_process_vars.get_var_date(
                                                pi_prcs_id  => '||l_prcs_id||'
											            , pi_scope     => '||l_prov_scope||'										
                                             , pi_var_name => '''||l_prov_var_name||'''
                                          ); 
                           end;');
                  end case;
               when 'timestamp' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_timestamp('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_tstz(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        l_json_element := l_process_variable.get('value');
                        begin
                           if instr( l_process_variable.get_String('value'), 'T' ) > 0 then
                              l_ts := to_timestamp_tz( replace ( l_process_variable.get_String('value'), 'T', ' ' ), 'YYYY-MM-DD HH24:MI:SS TZR' ); 
                           else
                              l_ts := to_timestamp_tz( l_process_variable.get_String('value'), 'YYYY-MM-DD TZR' ); 
                           end if;
                        exception when others then
                           raise e_invalid_date;
                        end;
                        flow_process_vars.set_var(
                          pi_prcs_id    => l_prcs_id
						      , pi_scope      => l_prov_scope									
                        , pi_var_name   => l_prov_var_name
                        , pi_date_value => l_process_variable.get_timestamp('value')
                        );
                     when 'get' then
                        apex_exec.execute_plsql(   'begin
                           :' || l_item_name || ' :=  flow_process_vars.get_var_tstz(
                                                pi_prcs_id  => '||l_prcs_id||'
											            , pi_scope     => '||l_prov_scope||'										
                                             , pi_var_name => '''||l_prov_var_name||'''
                                          ); 
                           end;');
                  end case;
               when 'clob' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_clob('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_clob(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                          pi_prcs_id    => l_prcs_id
						      , pi_scope      => l_prov_scope									
                        , pi_var_name   => l_prov_var_name
                        , pi_clob_value => l_process_variable.get_clob('value')
                        );
                     when 'get' then
                        apex_exec.execute_plsql('begin
                           :' || l_item_name || ' := flow_process_vars.get_var_clob(
                                               pi_prcs_id  => '|| l_prcs_id ||'
											            , pi_scope    => '|| l_prov_scope ||'									   
                                             , pi_var_name => '''|| l_prov_var_name ||'''
                                          );
                           end;'
                        );
                  end case;   
               when 'json' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then l_process_variable.get_clob('value')
                                 when 'get' 
                                    then flow_process_vars.get_var_json(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                          pi_prcs_id    => l_prcs_id
						      , pi_scope      => l_prov_scope									
                        , pi_var_name   => l_prov_var_name
                        , pi_json_value => l_process_variable.get_clob('value')
                        );
                     when 'get' then
                        apex_exec.execute_plsql('begin
                           :' || l_item_name || ' := flow_process_vars.get_var_json(
                                               pi_prcs_id  => '|| l_prcs_id ||'
											            , pi_scope    => '|| l_prov_scope ||'									   
                                             , pi_var_name => '''|| l_prov_var_name ||'''
                                          );
                           end;'
                        );
                  end case;                      
               else
                  raise e_incorrect_variable_type;
            end case;
         end loop;
      elsif ( l_attribute5 = 'item' ) then
         -- Get process variable(s) name(s)
         l_split_prcs_var := apex_string.split(l_attribute6, ',');

         -- Get APEX item(s) name(s)
         l_split_items := apex_string.split(l_attribute7, ',');

         --Raise exception if number of process variables is not the same of APEX items
         if ( l_split_prcs_var.count() != l_split_items.count() ) then
            raise e_var_config;
         end if;

         -- Get process variables types
         for rec in (
            select prov_var_name, prov_var_type
            from flow_process_variables prov
         where prov.prov_prcs_id = l_prcs_id
			and prov.prov_scope = l_prov_scope								 
            and prov.prov_var_name in (
               select trim(column_value)
               from table(l_split_prcs_var)
            )
         )
         loop
            l_prcs_var(rec.prov_var_name) := rec.prov_var_type;
         end loop;

         l_cur_app_id := nv('APP_ID');
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
            from table(apex_string.split(l_attribute7, ',')) items
            left outer join apex_application_page_items aapi
               on aapi.item_name = items.column_value
              and aapi.application_id = l_cur_app_id
            left outer join apex_application_items aai
               on aai.item_name = items.column_value
              and aai.application_id = l_cur_app_id
         )
         loop
            l_items(rec.item_name).item_type   := rec.item_type;
            l_items(rec.item_name).format_mask := case rec.item_type 
                                                     when 'DATE' 
                                                        then coalesce( rec.format_mask, v('APP_NLS_DATE_FORMAT') )
                                                     when 'TIMESTAMP WITH TIME ZONE' 
                                                        then coalesce( rec.format_mask, v('APP_NLS_TIMESTAMP_TZ_FORMAT') ) 
                                                     else
                                                         rec.format_mask
                                                  end;
               
         end loop;

         -- Loop through variables
         for i in l_split_prcs_var.first..l_split_prcs_var.last
         loop
            -- Get process variable name and item name 
            l_prov_var_name := trim( l_split_prcs_var( i ) );
            l_item_name     := trim( l_split_items( i ) );

            -- Look for variable type
            begin
               l_prov_var_type := l_prcs_var( l_prov_var_name );
            exception 
               -- Look for item type
               when no_data_found then
                  l_prov_var_type := l_items ( l_item_name ).item_type;
            end;
            
            case l_prov_var_type 
               when 'VARCHAR2' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then apex_util.get_session_state( p_item => l_item_name )
                                 when 'get' 
                                    then flow_process_vars.get_var_vc2(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope  
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                             pi_prcs_id    => l_prcs_id
						         , pi_scope      => l_prov_scope								  
                           , pi_var_name   => l_prov_var_name
                           , pi_vc2_value  => apex_util.get_session_state( p_item => l_item_name )
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => flow_process_vars.get_var_vc2(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ) 
                        );
                  end case;

               when 'NUMBER' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then 
                                      $if wwv_flow_api.c_current >= 20210415 $then 
                                         to_number( apex_util.get_session_state( p_item => l_item_name ), l_items ( l_item_name ).format_mask )  
                                      $else                                          
                                         to_number( apex_util.get_session_state( p_item => l_item_name ) )
                                      $end
                                 when 'get' 
                                    then flow_process_vars.get_var_num(
                                              pi_prcs_id  => l_prcs_id
											           , pi_scope    => l_prov_scope
                                            , pi_var_name => l_prov_var_name
                                         )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                             pi_prcs_id    => l_prcs_id
						         , pi_scope      => l_prov_scope	 
                           , pi_var_name   => l_prov_var_name
                           , pi_num_value  => $if wwv_flow_api.c_current >= 20210415 $then 
                                                 case when l_items ( l_item_name ).format_mask is not null then
                                                    to_number( apex_util.get_session_state( p_item => l_item_name ), l_items ( l_item_name ).format_mask )
                                                 else
                                                    to_number( apex_util.get_session_state( p_item => l_item_name ) )
                                                 end
                                              $else
                                                 to_number( apex_util.get_session_state( p_item => l_item_name ) )
                                              $end
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => flow_process_vars.get_var_num(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ) 
                        );
                  end case;
               when 'DATE' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then apex_util.get_session_state( p_item => l_item_name )
                                 when 'get' 
                                    then to_char(
                                            flow_process_vars.get_var_date(
                                               pi_prcs_id  => l_prcs_id
											            , pi_scope    => l_prov_scope   
                                             , pi_var_name => l_prov_var_name
                                            ), l_items(l_item_name).format_mask 
                                          )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                             pi_prcs_id    => l_prcs_id
						         , pi_scope      => l_prov_scope
                           , pi_var_name   => l_prov_var_name
                           , pi_date_value => to_date( apex_util.get_session_state( p_item => l_item_name ) , l_items(l_item_name).format_mask )
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => to_char(
                                          flow_process_vars.get_var_date(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ), l_items(l_item_name).format_mask )
                        );
                  end case;
            when 'TIMESTAMP WITH TIME ZONE' then
                  apex_debug.info(
                     p_message => '......Name: %s - Type: %s - Value %s'
                     , p0 => l_prov_var_name
                     , p1 => l_prov_var_type
                     , p2 => case l_attribute4
                                when 'set' 
                                   then apex_util.get_session_state( p_item => l_item_name )
                                 when 'get' 
                                    then to_char(
                                            flow_process_vars.get_var_tstz(
                                               pi_prcs_id  => l_prcs_id
											            , pi_scope    => l_prov_scope   
                                             , pi_var_name => l_prov_var_name
                                            ), l_items(l_item_name).format_mask 
                                          )
                             end 
                  );
                  case l_attribute4
                     when 'set' then
                        flow_process_vars.set_var(
                             pi_prcs_id    => l_prcs_id
						         , pi_scope      => l_prov_scope
                           , pi_var_name   => l_prov_var_name
                           , pi_tstz_value => to_timestamp_tz( apex_util.get_session_state( p_item => l_item_name ) , l_items(l_item_name).format_mask )
                        );
                     when 'get' then
                        apex_util.set_session_state( 
                             p_name  => l_item_name
                           , p_value => to_char(
                                          flow_process_vars.get_var_tstz(
                                             pi_prcs_id  => l_prcs_id
										             , pi_scope    => l_prov_scope	 
                                           , pi_var_name => l_prov_var_name
                                        ), l_items(l_item_name).format_mask )
                        );
                  end case;      
            when 'CLOB' then
               apex_debug.info(
                  p_message => '......Name: %s - Type: %s - Value %s'
                  , p0 => l_prov_var_name
                  , p1 => l_prov_var_type
                  , p2 => case l_attribute4
                             when 'set' 
                                then apex_util.get_session_state( p_item => l_item_name )
                              when 'get' 
                                 then flow_process_vars.get_var_clob(
                                           pi_prcs_id  => l_prcs_id
										           , pi_scope    => l_prov_scope  
                                         , pi_var_name => l_prov_var_name
                                      )
                          end 
               );
               case l_attribute4
                  when 'set' then
                     flow_process_vars.set_var(
                          pi_prcs_id     => l_prcs_id
						      , pi_scope       => l_prov_scope
                        , pi_var_name    => l_prov_var_name
                        , pi_clob_value  => apex_util.get_session_state( p_item => l_item_name )
                     );
                  when 'get' then
                     apex_exec.execute_plsql('begin
                        :' || l_item_name || q'[ := ']' || flow_process_vars.get_var_clob(
                                            pi_prcs_id  => l_prcs_id
										            , pi_scope    => l_prov_scope	 
                                          , pi_var_name => l_prov_var_name
                                       ) || q'[';
                        end;]'
                     );
               end case;
            when 'JSON' then
               apex_debug.info(
                  p_message => '......Name: %s - Type: %s - Value %s'
                  , p0 => l_prov_var_name
                  , p1 => l_prov_var_type
                  , p2 => case l_attribute4
                             when 'set' 
                                then apex_util.get_session_state( p_item => l_item_name )
                              when 'get' 
                                 then flow_process_vars.get_var_json(
                                           pi_prcs_id  => l_prcs_id
										           , pi_scope    => l_prov_scope  
                                         , pi_var_name => l_prov_var_name
                                      )
                          end 
               );
               case l_attribute4
                  when 'set' then
                     flow_process_vars.set_var(
                          pi_prcs_id     => l_prcs_id
						      , pi_scope       => l_prov_scope
                        , pi_var_name    => l_prov_var_name
                        , pi_json_value  => apex_util.get_session_state( p_item => l_item_name )
                     );
                  when 'get' then
                     apex_exec.execute_plsql('begin
                        :' || l_item_name || q'[ := ']' || flow_process_vars.get_var_json(
                                            pi_prcs_id  => l_prcs_id
										            , pi_scope    => l_prov_scope	 
                                          , pi_var_name => l_prov_var_name
                                       ) || q'[';
                        end;]'
                     );
               end case;   
            end case;
         end loop;
      end if;
      apex_debug.info(
           p_message => '...End %s Flow Instance Variable(s)'
         , p0        => case l_attribute4
                           when 'set' then 'setting'
                           when 'get' then 'getting'
                        end 
      );

      return l_result;
   exception 
      when e_var_config then
         apex_error.add_error( 
              p_message => flow_api_pkg.message( p_message_key => 'plugin-wrong-variable-number', p_lang => apex_util.get_session_lang() )
            , p_display_location => apex_error.c_on_error_page
         );
      when e_incorrect_variable_type then
         if apex_application.g_debug then
            apex_debug.error(
               p_message => '-- Flows4apex - Plug-in configuration issue, process variables JSON contains incorrect variable type.'
            );
         end if;
         apex_error.add_error( 
              p_message => flow_api_pkg.message( p_message_key => 'plugin-parsing-json-variables', p_lang => apex_util.get_session_lang() )
            , p_display_location => apex_error.c_on_error_page
         );
      when e_types_different then
         apex_error.add_error( 
              p_message => flow_api_pkg.message( p_message_key => 'plugin-wrong-variable-type', p_lang => apex_util.get_session_lang() )
            , p_display_location => apex_error.c_on_error_page
         );
      when e_invalid_number then
         apex_error.add_error( 
              p_message => flow_api_pkg.message( 
                                p_message_key => 'plugin-variable-not-a-number'
                              , p0            => l_process_variable.get('value').stringify() 
                              , p_lang        => apex_util.get_session_lang() 
                           )
            , p_display_location => apex_error.c_on_error_page
         );
      when e_invalid_date then
         apex_error.add_error( 
              p_message => flow_api_pkg.message( 
                                p_message_key => 'plugin-variable-not-a-date'
                              , p0            =>  l_process_variable.get('value').stringify() 
                              , p_lang        => apex_util.get_session_lang() 
                           )
            , p_display_location => apex_error.c_on_error_page
         );
      when e_invalid_json then
         apex_error.add_error( 
              p_message => flow_api_pkg.message( p_message_key => 'plugin-invalid-json', p_lang => apex_util.get_session_lang() )
            , p_display_location => apex_error.c_on_error_page
         );
   end execution;

end flow_plugin_manage_instance_variables;
/
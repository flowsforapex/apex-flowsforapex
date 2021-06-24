create or replace package body flow_plugin_delete as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result          apex_plugin.t_process_exec_result;

      --attributes
      l_attribute1      p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2      p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3      p_process.attribute_03%type := p_process.attribute_03; -- SQL query (2 columns process id and subflow id)

      l_process_id      flow_processes.prcs_id%type;
      l_context         apex_exec.t_context;

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
      elsif ( l_attribute1 = 'sql' ) then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute3
         );

         while apex_exec.next_row(l_context) loop
            l_process_id  := apex_exec.get_number(l_context, 1);
         end loop;
         apex_exec.close(l_context);
      end if;

      -- Call API to delete the instance
      apex_debug.message(p_message => 'Plug-in: start delete process id '||l_process_id);
      flow_api_pkg.flow_delete(
         p_process_id  => l_process_id
      );

      return l_result;
   end execution;
   
end flow_plugin_delete;
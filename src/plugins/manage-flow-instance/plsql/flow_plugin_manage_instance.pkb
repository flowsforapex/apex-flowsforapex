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
           p_message => '...Flow Instance define by: %s'
         , p0        => p_process.attribute_01
      );

      if p_process.attribute_01 = 'item' then 
         apex_debug.info(
            p_message => '......Item used: %s - Session state value: %s'
            , p0        => p_process.attribute_02
            , p1        => apex_util.get_session_state(p_item => p_process.attribute_02)
         );
      elsif p_process.attribute_01 = 'sql'  then
         apex_debug.info(
            p_message => '......Query'
         );
         apex_debug.log_long_message(
              p_message => p_process.attribute_03
            , p_level   => apex_debug.c_log_level_info
         );
      elsif p_process.attribute_01 = 'static'  then
         apex_debug.info(
              p_message => '......Static value: %s'
            , p0        => p_process.attribute_04
         );
      elsif p_process.attribute_01 = 'component' then
        apex_debug.info(
            p_message => '......Component Setting: %s'
            , p0        => p_plugin.attribute_01
         );
      end if;

      apex_debug.info(
           p_message => '...Flow Instance action: %s'
         , p0        => p_process.attribute_04
      );

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

      --attributes
      l_attribute1      p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2      p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3      p_process.attribute_03%type := p_process.attribute_03; -- SQL query (2 columns process id and subflow id)
      l_attribute4      p_process.attribute_04%type := p_process.attribute_04; -- Action

      l_process_id      flow_processes.prcs_id%type;
      l_context         apex_exec.t_context;

   begin

    --debug
      log_attributes(
           p_plugin   => p_plugin
         , p_process  => p_process
      );

      apex_debug.info(
           p_message => '...Retrieve FLow Instance Id'
      );
      -- Get Flow Instance Id
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

      if ( l_attribute4 = 'delete' ) then
         -- Call API to delete the instance
         apex_debug.info(
              p_message => '...Delete Flow Instance Id %s'
            , p0        => l_process_id
         );
         flow_api_pkg.flow_delete(
            p_process_id  => l_process_id
         );
      elsif ( l_attribute4 = 'start' ) then
         -- Call API to start the instance
         apex_debug.info(
              p_message => '...Start Flow Instance Id %s'
            , p0        => l_process_id
         );
         flow_api_pkg.flow_start(
            p_process_id  => l_process_id
         );
      elsif ( l_attribute4 = 'reset' ) then
         -- Call API to start the instance
         apex_debug.info(
              p_message => '...Reset Flow Instance Id %s'
            , p0        => l_process_id
         );
         flow_api_pkg.flow_reset(
            p_process_id  => l_process_id
         );
      end if;

      return l_result;
   end execution;
   
end flow_plugin_manage_instance;
create or replace package body flow_plugin_manage_instance_step as
   
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
           p_message => '...Flow Instance & Subflow define by: %s'
         , p0        => p_process.attribute_01
      );

      if p_process.attribute_01 = 'item' then 
         apex_debug.info(
            p_message => '......Flow Instance Item used: %s - Session state value: %s'
            , p0        => p_process.attribute_02
            , p1        => apex_util.get_session_state(p_item => p_process.attribute_02)
         );
         apex_debug.info(
            p_message => '......Subflow Item used: %s - Session state value: %s'
            , p0        => p_process.attribute_03
            , p1        => apex_util.get_session_state(p_item => p_process.attribute_03)
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
         , p0        => p_process.attribute_05
      );

      if ( p_process.attribute_05 = 'complete' ) then
         apex_debug.info(
            p_message => '...Set Gateway route?: %s'
            , p0        => p_process.attribute_06
         );

         if ( p_process.attribute_06 = 'Y' ) then
            if ( p_process.attribute_07 is not null ) then
               apex_debug.info(
                  p_message => '......Gateway "%s"'
                  , p0        => p_process.attribute_07
               );
            else
               apex_debug.info(
                  p_message => '......No Gateway define, next gateway will be used.'
               );
            end if;
         end if;
         apex_debug.info(
            p_message => '......Route %s'
            , p0        => p_process.attribute_08
         );

         apex_debug.info(
            p_message => '...Auto branching?: %s'
            , p0        => p_process.attribute_09
         );
      elsif ( p_process.attribute_05 = 'reserve' ) then
         apex_debug.info(
            p_message => '...Reservation define by: %s'
            , p0        => p_process.attribute_10
         );
         if ( p_process.attribute_10 = 'static' ) then
            apex_debug.info(
                 p_message => '......Static value: %s'
               , p0        => p_process.attribute_11
            );
         elsif ( p_process.attribute_10 = 'item' )  then
            apex_debug.info(
               p_message => '......Reservation Item used: %s - Session state value: %s'
               , p0        => p_process.attribute_12
               , p1        => apex_util.get_session_state(p_item => p_process.attribute_12)
            );
         elsif ( p_process.attribute_10 = 'sql' )  then
            apex_debug.info(
               p_message => '......Query'
            );
            apex_debug.log_long_message(
                 p_message => p_process.attribute_13
               , p_level   => apex_debug.c_log_level_info
            );
         end if;
      end if;

      if p_process.attribute_11 is not null then
         apex_debug.info(
            p_message => '...Return Flow Instance ID and Subflow ID into: %s'
            , p0        => p_process.attribute_11
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
      l_result          apex_plugin.t_process_exec_result;

      --exceptions
      e_no_gateway         exception;
      e_gateway_not_exists exception;
      e_no_flow            exception;

      --attributes
      l_attribute1      p_process.attribute_01%type := p_process.attribute_01; -- Flow instance selection (APEX item/SQL)
      l_attribute2      p_process.attribute_02%type := p_process.attribute_02; -- Process ID (APEX item)
      l_attribute3      p_process.attribute_03%type := p_process.attribute_03; -- Subflow ID (APEX item)
      l_attribute4      p_process.attribute_04%type := p_process.attribute_04; -- SQL query (2 columns process id and subflow id)
      l_attribute5      p_process.attribute_05%type := p_process.attribute_05; -- Action (complete/reserve/release)
      l_attribute6      p_process.attribute_06%type := p_process.attribute_06; -- Set Gateway route? (Y/N)
      l_attribute7      p_process.attribute_07%type := p_process.attribute_07; -- Gateway ID
      l_attribute8      p_process.attribute_08%type := p_process.attribute_08; -- Route ID
      l_attribute9      p_process.attribute_09%type := p_process.attribute_09; -- Auto branching (Y/N)
      l_attribute10     p_process.attribute_10%type := p_process.attribute_10; -- Reservation 
      l_attribute11     p_process.attribute_11%type := p_process.attribute_11; -- Return Flow Instance and Subflow ID 

      l_process_id      flow_processes.prcs_id%type;
      l_subflow_id      flow_subflows.sbfl_id%type;
      l_dgrm_id         flow_processes.prcs_dgrm_id%type;
      l_gateway_name    flow_objects.objt_bpmn_id%type;
      l_gateway_exists  number;
      l_context         apex_exec.t_context;
      l_url             varchar2(4000);
      l_split_items     apex_t_varchar2;

       type flow_step_info is record (
           dgrm_id            flow_diagrams.dgrm_id%type
         , source_objt_tag    flow_objects.objt_tag_name%type
         , source_lane_id     flow_objects.objt_objt_lane_id%type
         , target_objt_id     flow_objects.objt_id%type
         , target_objt_ref    flow_objects.objt_bpmn_id%type
         , target_objt_tag    flow_objects.objt_tag_name%type
         , target_objt_subtag flow_objects.objt_sub_tag_name%type
         , target_lane_id     flow_objects.objt_objt_lane_id%type
      );
      l_step_info       flow_step_info;

      l_reservation flow_subflows.sbfl_reservation%type;
   begin

      --debug
      log_attributes(
           p_plugin  => p_plugin
         , p_process => p_process
      );

      apex_debug.info(
         p_message => '...Retrieve FLow Instance Id and Subflow Id'
      );
      -- Get process Id and subflow Id
      if ( l_attribute1 = 'item' ) then
         l_process_id  := apex_util.get_session_state(p_item => l_attribute2);
         l_subflow_id  := apex_util.get_session_state(p_item => l_attribute3);
      elsif ( l_attribute1 = 'sql' ) then
         l_context         := apex_exec.open_query_context(
            p_location   => apex_exec.c_location_local_db
          , p_sql_query  => l_attribute4
         );

         while apex_exec.next_row(l_context) loop
            l_process_id  := apex_exec.get_number(l_context, 1);
            l_subflow_id  := apex_exec.get_number(l_context, 2);
         end loop;
         apex_exec.close(l_context);
      end if;

      --Raise error if unable to find process id or subflow id
      if l_process_id is null or l_subflow_id is null then
         raise e_no_flow;
      end if;

      if ( l_attribute5 = 'complete' ) then
         -- Get step informations
         select prcs.prcs_dgrm_id
            , objt_source.objt_tag_name
            , objt_source.objt_objt_lane_id
            , conn.conn_tgt_objt_id
            , objt_target.objt_bpmn_id
            , objt_target.objt_tag_name
            , objt_target.objt_sub_tag_name
            , objt_target.objt_objt_lane_id
         into l_step_info
         from flow_connections conn
         join flow_objects objt_source
            on conn.conn_src_objt_id = objt_source.objt_id
            and conn.conn_dgrm_id = objt_source.objt_dgrm_id
         join flow_objects objt_target
            on conn.conn_tgt_objt_id = objt_target.objt_id
            and conn.conn_dgrm_id = objt_target.objt_dgrm_id
         join flow_processes prcs
            on prcs.prcs_dgrm_id = conn.conn_dgrm_id
         join flow_subflows sbfl
            on sbfl.sbfl_current = objt_source.objt_bpmn_id
            and sbfl.sbfl_prcs_id = prcs.prcs_id
         where conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
            and prcs.prcs_id = l_process_id
            and sbfl.sbfl_id = l_subflow_id;

         --Set the gateway route
         if ( l_attribute6 = 'Y' ) then
            l_gateway_name := l_attribute7;

            -- If attribute 6 is filled, check if gateway define exists
            if ( l_gateway_name is not null ) then

               select count(*)
               into l_gateway_exists
               from flow_processes prcs
               join flow_objects obj on obj.objt_dgrm_id = prcs.prcs_dgrm_id
               where prcs.prcs_id = l_process_id
               and obj.objt_tag_name in (flow_constants_pkg.gc_bpmn_gateway_exclusive, flow_constants_pkg.gc_bpmn_gateway_inclusive)
               and obj.objt_bpmn_id = l_gateway_name;

               if ( l_gateway_exists = 0) then
                  raise e_gateway_not_exists;
               end if;
            end if;
            
            --Gateway attribute is not filled so we look at the next target object if it's exclusive or inclusive gateway
            if (
               l_attribute7 is null and l_step_info.target_objt_tag in (
                        flow_constants_pkg.gc_bpmn_gateway_exclusive, flow_constants_pkg.gc_bpmn_gateway_inclusive
                     )
            ) then
               l_gateway_name := l_step_info.target_objt_ref;
            end if;

            if ( l_gateway_name is not null ) then

               apex_debug.info(
                  p_message => '...Setting Flow Instance Variable "%s" value "%s"'
                  , p0      => l_gateway_name || ':route'
                  , p1      => l_attribute8
               );

               flow_process_vars.set_var(
                  pi_prcs_id    => l_process_id
               , pi_var_name   => l_gateway_name || ':route'
               , pi_vc2_value  => l_attribute8
               );
            else
               raise e_no_gateway;
            end if;
         end if;

         apex_debug.info(
              p_message => '...Complete Step - Flow Instance Id %s - Subflow Id %s'
            , p0        => l_process_id
            , p1        => l_subflow_id
         );
         -- Call API to complete the step
         flow_api_pkg.flow_complete_step(
            p_process_id  => l_process_id
         , p_subflow_id  => l_subflow_id
         );

         -- Auto-branching
         -- Only if next object is a user task and it's on the same lane than the current step
         if (
            l_attribute9 = 'Y' and l_step_info.target_objt_tag = flow_constants_pkg.gc_bpmn_usertask and ( ( l_step_info.source_lane_id =
            l_step_info.target_lane_id ) or (
               l_step_info.source_lane_id is null and l_step_info.target_lane_id is null
            ) )
         ) then
            -- Get APEX page url
            l_url :=
               flow_usertask_pkg.get_url(
                  pi_prcs_id  => l_process_id
               , pi_sbfl_id  => l_subflow_id
               , pi_objt_id  => l_step_info.target_objt_id
               );
            apex_debug.info(
                 p_message => '...Redirecting to %s'
               , p0        => l_url
            );
            -- Redirect
            apex_util.redirect_url(p_url => l_url);
         end if;

      elsif ( l_attribute5 = 'reserve' ) then
         l_reservation := l_attribute10;

         apex_debug.info(
              p_message => '...Reserve Step - Flow Instance Id %s - Subflow Id %s'
            , p0        => l_process_id
            , p1        => l_subflow_id
         );

         flow_api_pkg.flow_reserve_step(
            p_process_id    => l_process_id
            , p_subflow_id  => l_subflow_id
            , p_reservation => l_reservation
         );

      elsif ( l_attribute5 = 'release' ) then
         apex_debug.info(
              p_message => '...Release Step - Flow Instance Id %s - Subflow Id %s'
            , p0        => l_process_id
            , p1        => l_subflow_id
         );

         flow_api_pkg.flow_release_step(
              p_process_id => l_process_id
            , p_subflow_id => l_subflow_id
         );
      end if;

      -- Return Flow Instance Id and Subflow Id in the APEX items provided
      if ( l_attribute11 is not null ) then
         l_split_items := apex_string.split( l_attribute11, ',' );
         apex_debug.info(
            p_message => '...Return Flow Instance Id into item "%s"'
         , p0        => l_split_items(1)
         );
         apex_util.set_session_state( l_split_items(1), l_process_id );

         if l_split_items.count() = 2 then
            apex_debug.info(
               p_message => '...Return Subflow Id into item "%s"'
            , p0        => l_split_items(2)
            );
            apex_util.set_session_state( l_split_items(2), l_subflow_id );
         end if;
      end if;

      return l_result;
   exception 
      when e_no_gateway then
         apex_error.add_error( 
              p_message => 'Gateway is not define for routing.'
            , p_display_location => apex_error.c_on_error_page
         );
      when e_gateway_not_exists then
         apex_error.add_error( 
              p_message => 'Gateway define does not exists for this flow.'
            , p_display_location => apex_error.c_on_error_page
         );
      when e_no_flow then
         apex_error.add_error( 
              p_message => 'Unable to get Flow Instance Id and or subflow Id to manage the step.'
            , p_display_location => apex_error.c_on_error_page
         );
   end execution;
   
end flow_plugin_manage_instance_step;
/

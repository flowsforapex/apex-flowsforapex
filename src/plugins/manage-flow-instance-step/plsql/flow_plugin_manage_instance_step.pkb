create or replace package body flow_plugin_manage_instance_step as

   function execution (
      p_process  in  apex_plugin.t_process
    , p_plugin   in  apex_plugin.t_plugin
   ) return apex_plugin.t_process_exec_result 
   as
      l_result          apex_plugin.t_process_exec_result;

      --exceptions
      e_no_gateway         exception;
      e_gateway_not_exists exception;

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
      l_attribute10     p_process.attribute_10%type := p_process.attribute_10; -- Reservation mode (static/item/sql)
      l_attribute11     p_process.attribute_11%type := p_process.attribute_11; -- Reservation text
      l_attribute12     p_process.attribute_12%type := p_process.attribute_12; -- Reservation item
      l_attribute13     p_process.attribute_13%type := p_process.attribute_13; -- Reservation sql

      l_process_id      flow_processes.prcs_id%type;
      l_subflow_id      flow_subflows.sbfl_id%type;
      l_dgrm_id         flow_processes.prcs_dgrm_id%type;
      l_gateway_name    flow_objects.objt_bpmn_id%type;
      l_gateway_exists  number;
      l_context         apex_exec.t_context;
      l_url             varchar2(4000);

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

         while apex_exec.next_row(l_context) loop
            l_process_id  := apex_exec.get_number(l_context, 1);
            l_subflow_id  := apex_exec.get_number(l_context, 2);
         end loop;
         apex_exec.close(l_context);
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

               flow_process_vars.set_var(
                  pi_prcs_id    => l_process_id
               , pi_var_name   => l_gateway_name || ':route'
               , pi_vc2_value  => l_attribute8
               );
            else
               raise e_no_gateway;
            end if;
         end if;

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
            -- Redirect
            apex_util.redirect_url(p_url => l_url);
         end if;

      elsif ( l_attribute5 = 'reserve' ) then

         if ( l_attribute10 = 'static' ) then
             l_reservation := l_attribute11;
         elsif ( l_attribute10 = 'item' ) then
            l_reservation := apex_util.get_session_state(l_attribute12);
         elsif ( l_attribute10 = 'sql' ) then
            l_context         := apex_exec.open_query_context(
               p_location   => apex_exec.c_location_local_db
             , p_sql_query  => l_attribute13
            );

            while apex_exec.next_row(l_context) loop
               l_reservation  := apex_exec.get_varchar2(l_context, 1);
            end loop;
            apex_exec.close(l_context);
         end if;

         flow_api_pkg.flow_reserve_step(
            p_process_id    => l_process_id
            , p_subflow_id  => l_subflow_id
            , p_reservation => l_reservation
         );

      elsif ( l_attribute5 = 'release' ) then
         flow_api_pkg.flow_release_step(
              p_process_id => l_process_id
            , p_subflow_id => l_subflow_id
         );
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
   end execution;
   
end flow_plugin_manage_instance_step;
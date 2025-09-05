prompt --application/shared_components/user_interface/lovs/p8_repositionable_steps
begin
--   Manifest
--     P8_REPOSITIONABLE_STEPS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(14375603769799)
,p_lov_name=>'P8_REPOSITIONABLE_STEPS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prev_obj.objt_bpmn_id, prev_obj.objt_tag_name, coalesce( prev_obj.objt_name, prev_obj.objt_bpmn_id) d, level',
'from   flow_objects prev_obj',
'join   flow_connections conn',
'  on   conn.conn_src_objt_id = prev_obj.objt_id',
' and   conn.conn_dgrm_id     = prev_obj.objt_dgrm_id',
'join   flow_objects curr_obj',
'  on   conn.conn_tgt_objt_id = curr_obj.objt_id',
' and   conn.conn_dgrm_id     = curr_obj.objt_dgrm_id',
'where  curr_obj.objt_dgrm_id = ( select  sbfl.sbfl_dgrm_id ',
'                                   from flow_subflows sbfl',
'                                  where sbfl.sbfl_id = :P8_REWIND_SBFL_ID )',
' and   prev_obj.objt_tag_name not in (''bpmn:eventBasedGateway'',''bpmn:inclusiveGateway'',''bpmn:parallelGateway'', ''bpmn:startEvent'', ''bpmn:exclusiveGateway'', ''bpmn:boundaryEvent'')',
'start with curr_obj.objt_bpmn_id = ( select  sbfl.sbfl_current',
'                                       from flow_subflows sbfl',
'                                      where sbfl.sbfl_id = :P8_REWIND_SBFL_ID )',
'connect by curr_obj.objt_tag_name not in (''bpmn:eventBasedGateway'',''bpmn:inclusiveGateway'',''bpmn:parallelGateway'', ''bpmn:startEvent'', ''bpmn:exclusiveGateway'', ''bpmn:boundaryEvent'')',
' and curr_obj.objt_id = prior prev_obj.objt_id'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'OBJT_BPMN_ID'
,p_display_column_name=>'D'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'LEVEL'
,p_default_sort_direction=>'ASC'
,p_version_scn=>1842853054
);
wwv_flow_imp.component_end;
end;
/

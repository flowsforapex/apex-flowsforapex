prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Parsed Diagrams'
,p_alias=>'PARSED-DIAGRAMS'
,p_step_title=>'Parsed Diagrams'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(12495635610083880376)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210103153844'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2404737406481936)
,p_plug_name=>'Diagram'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_DIAGRAMS_VW'
,p_query_where=>'dgrm_id = :p2_dgrm_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.MTAG.APEX.BPMNVIEWER.REGION'
,p_ajax_items_to_submit=>'P2_DGRM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_attribute_10=>'Y'
,p_attribute_11=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2405357256481942)
,p_plug_name=>'Facets'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_api.id(9900826057126998)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_06=>'Y'
,p_attribute_07=>'Y'
,p_attribute_09=>'N'
,p_attribute_12=>'10000'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(9900826057126998)
,p_name=>'Parsed Diagrams'
,p_region_name=>'parsed_drgm'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0002_DIAGRAMS_VW'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_break_cols=>'1:2'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_break_type_flag=>'DEFAULT_BREAK_FORMATTING'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404091459481929)
,p_query_column_id=>1
,p_column_alias=>'DGRM_ID'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404172622481930)
,p_query_column_id=>2
,p_column_alias=>'DGRM_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_default_sort_column_sequence=>2
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404228048481931)
,p_query_column_id=>3
,p_column_alias=>'DGRM_VERSION'
,p_column_display_sequence=>4
,p_column_heading=>'Version'
,p_use_as_row_header=>'N'
,p_default_sort_column_sequence=>3
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404360752481932)
,p_query_column_id=>4
,p_column_alias=>'DGRM_STATUS'
,p_column_display_sequence=>5
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404433838481933)
,p_query_column_id=>5
,p_column_alias=>'DGRM_CATEGORY'
,p_column_display_sequence=>1
,p_column_heading=>'Category'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404590761481934)
,p_query_column_id=>6
,p_column_alias=>'DGRM_LAST_UPDATE'
,p_column_display_sequence=>6
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404680441481935)
,p_query_column_id=>7
,p_column_alias=>'BTN'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2405242659481941)
,p_query_column_id=>8
,p_column_alias=>'LAST_VERSION'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2404877025481937)
,p_name=>'P2_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2404737406481936)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2405400775481943)
,p_name=>'P2_LAST_VERSION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_item_default=>'Y'
,p_prompt=>'Last Version'
,p_source=>'LAST_VERSION'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_item_template_options=>'#DEFAULT#'
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2405545162481944)
,p_name=>'P2_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Search'
,p_source=>'DGRM_CATEGORY,DGRM_NAME,DGRM_STATUS,DGRM_LAST_UPDATE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'ROW'
,p_attribute_02=>'FACET'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2405686302481945)
,p_name=>'P2_DGRM_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Category'
,p_source=>'DGRM_CATEGORY'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_item_template_options=>'#DEFAULT#'
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10426752430468001)
,p_name=>'P2_DGRM_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Status'
,p_source=>'DGRM_STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_item_template_options=>'#DEFAULT#'
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10204710359465896)
,p_name=>'Clickable Action clicked'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.clickable-action '
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10205117311465914)
,p_event_id=>wwv_flow_api.id(10204710359465896)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'var myAction  = myElement.data( "action" );',
'var myDiagram = myElement.data( "dgrm" );',
'',
'console.log(myAction);',
'console.log(myDiagram );',
'',
'if ( myAction === "dgrm_view" ) {',
'  apex.item( "P2_DGRM_ID" ).setValue( myDiagram );',
'} else {',
'     apex.server.process(',
'        "PAGE2_AJAX", ',
'        {',
'            x01: myAction,',
'            x02: myDiagram',
'        }, ',
'        {',
'            success: function( pData )  {',
'                console.log(pData);',
'                if (pData.success === true) {',
'                    if (myAction === "dgrm_edit") { ',
'                        apex.navigation.redirect(pData.data.url); ',
'                    } else {',
'                        apex.region("parsed_drgm").refresh();',
'                        apex.message.showPageSuccess( "Successful action!" );',
'                    }',
'                    ',
'                }',
'            },',
'            error: function( jqXHR, textStatus, errorThrown ) {',
'                alert(jqXHR.responseText);',
'            }',
'        } ',
'    );',
'}',
'',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2404980723481938)
,p_name=>'Refresh diagram'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_DGRM_ID'
,p_condition_element=>'P2_DGRM_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405876514481947)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2404737406481936)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405950709481948)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2404737406481936)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405013624481939)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2404737406481936)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2405147513481940)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PAGE2_AJAX'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_ret varchar2(4000);',
'begin',
'    if (apex_application.g_x01 = ''dgrm_edit'') then',
'        l_ret := apex_page.get_url(',
'            p_page => 4,',
'            p_clear_cache => 4,',
'            p_items => ''P4_DGRM_ID'',',
'            p_values => apex_application.g_x02',
'        );',
'    end if;',
'    ',
'    if (apex_application.g_x01 = ''dgrm_release'') then',
'        update flow_diagrams set dgrm_status = ''released'' where dgrm_id = apex_application.g_x02;',
'        update flow_diagrams set dgrm_status = ''deprecated'' ',
'        where dgrm_id != apex_application.g_x02 ',
'        and dgrm_name = (select dgrm_name from flow_diagrams where dgrm_id = apex_application.g_x02)',
'        and dgrm_status = ''released'' or (dgrm_status = ''draft'' and dgrm_version < (select dgrm_version from flow_diagrams where dgrm_id = apex_application.g_x02));',
'    end if;',
'    ',
'    if (apex_application.g_x01 = ''dgrm_archive'') then',
'        update flow_diagrams set dgrm_status = ''archived'' where dgrm_id = apex_application.g_x02;',
'    end if;',
'    ',
'    if (apex_application.g_x01 = ''dgrm_deprecate'') then',
'        update flow_diagrams set dgrm_status = ''deprecated'' where dgrm_id = apex_application.g_x02;',
'    end if;',
'    ',
'    if (apex_application.g_x01 = ''dgrm_new_version'') then',
'        insert into flow_diagrams (dgrm_name, dgrm_version, dgrm_status, dgrm_category, dgrm_last_update, dgrm_content)',
'        select ',
'            dgrm.dgrm_name, ',
'            (select max(dgrm_version) from flow_diagrams d where d.dgrm_name = dgrm.dgrm_name) + 1,',
'            ''draft'',',
'            dgrm.dgrm_category,',
'            systimestamp,',
'            dgrm.dgrm_content',
'        from flow_diagrams dgrm',
'        where dgrm.dgrm_id = apex_application.g_x02;',
'    end if;',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.open_object(''data'');',
'    if (apex_application.g_x01 = ''dgrm_edit'') then apex_json.write(''url'', l_ret); end if;',
'    apex_json.close_object;',
'    apex_json.close_object;',
'exception',
'    when others then',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', sqlerrm);',
'        apex_json.close_object;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/

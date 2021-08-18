prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Monitor'
,p_alias=>'FLOW-MONITOR'
,p_step_title=>'Flow Monitor - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function redirectToMonitor(prcs_id){',
'    var result = apex.server.process( ',
'            "PROCESS_ACTION", ',
'            {',
'                x01: "VIEW",',
'                x02: prcs_id,',
'                x03: ""',
'            }',
'        );',
'        result.done( function( data ) {',
'            if (!data.success) {',
'                apex.debug.error( "Something went wrong..." );',
'            } else {',
'                apex.navigation.redirect(data.url);',
'            }',
'        }).fail( function( jqXHR, textStatus, errorThrown ) {',
'            apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );',
'        });  ',
'}',
'',
'//Define action for display setting',
'$(function() {',
'    apex.actions.add([',
'        {',
'            /*',
'             * The chooose-size action This sets a class on an element to ',
'             * change the size of the icon.',
'             */',
'            name: "choose-setting", // this matches the A01 Data ID list attribute',
'            get: function() {',
'                return apex.item("P10_DISPLAY_SETTING").getValue();',
'            },',
'            set: function(value) {',
'                apex.item("P10_DISPLAY_SETTING").setValue(value);',
'                //Todo add changing display there',
'                var prcsId = apex.item("P10_PRCS_ID").getValue();',
'',
'                switch(value) {',
'                    case "row" : ',
'                        apex.jQuery("#col1").addClass("col-12").removeClass("col-6");',
'                        apex.jQuery("#col2").addClass("col-12").removeClass("col-6");',
'',
'                        apex.jQuery("#flow-monitor").show();',
'                        apex.region("flow-monitor").refresh();',
'                        break;',
'                    case "column" :',
'                        apex.jQuery("#col1").addClass("col-6").removeClass("col-12");',
'                        apex.jQuery("#col2").addClass("col-6").removeClass("col-12");',
'                        apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());',
'',
'                        apex.jQuery("#flow-monitor").show();',
'                        apex.region("flow-monitor").refresh();',
'                        break;',
'                    case "window" :',
'                        apex.jQuery("#flow-monitor").hide();',
'                        apex.jQuery("#col1").addClass("col-12").removeClass("col-6");',
'                        apex.jQuery("#col2").addClass("col-12").removeClass("col-6");',
'',
'                        if ( prcsId !== "" ) {',
'                            redirectToMonitor(prcsId);',
'                        }',
'                        break;',
'                }',
'',
'            },',
'            // the thing that makes an action a radio group is set and get methods + a choices array',
'            choices: [] // fill this in, in a moment',
'        }',
'    ]);',
'',
'    // When the page first loads',
'    // Use the actions set methods to make sure the UI is in sync with the initial state when the page loads',
'    apex.actions.set("choose-setting", apex.item("P10_DISPLAY_SETTING").getValue());',
'    // Action labels and shortcuts *will be* added to above actions when the menu is initialized (it happens because',
'    // the Menu Popup list template JavaScript code calls apex.actions.addFromMarkup)',
'    // Rather than define message text for each of the size choices and for the',
'    // dynamic antonyms on/off labels, take the choice and on/off labels from the list text.',
'    // Look at the list to see how the text is encoded with | separators.',
'    // Could add the following code to add Execute when Page Loads but we know that menu will be initialized real soon now hence the setTimeout',
'    setTimeout(function() {',
'        var action, label;',
'        // initialize the choices for chooose-size',
'        action = apex.actions.lookup("choose-setting");',
'        action.choices = action.label.split("|").map(function(c, i) { return {label: c, value: ["row", "column", "window"][i]}; } );',
'        delete action.label;',
'        apex.actions.update("choose-setting"); // not needed if only used from menus but good idea to call after making changes.',
'    }, 1);',
'});',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(".a-IRR-headerLabel").each(function() {',
'    var text = $(this).text();',
'    if (text == ''Viewer'') {',
'        $(this).parent().addClass("viewer-heading")',
'    }',
'})',
'',
'/*Disable download image when no instances selected*/',
'$( "#actions_menu" ).on( "menubeforeopen", function( event, ui ) {',
'    var menuItems = ui.menu.items;',
'    menuItems[1].disabled = apex.item("P10_PRCS_ID").getValue() === "" ? true : false;',
'    ui.menu.items = menuItems;',
'} );',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.clickable-action {',
'  cursor: pointer;',
'}',
'',
'.current-process {',
'  background-color: rgba(0,0,0,.05)!important;',
'}',
'',
'.flow-running {',
'  background-color: rgba(0,0,0,.05);',
'}',
'',
'[for^="P10_SELECT_OUTPUT"] {',
'    margin: 5px 0 5px 0!important;',
'}',
'',
'.viewer-heading {',
'    text-align: center !important;',
'}',
'',
'#col2 {',
'    padding-top: 40px;',
'}',
'',
'td[headers*=action]',
'{',
'  display: flex;',
'  justify-content: flex-start;',
'}',
'',
'.a-IRR-header {',
'    vertical-align: inherit;',
'}',
'',
'#settings-header {',
'    font-weight: bold;',
'}',
'',
'.a-Tabs-panel {',
'    display: none;',
'}',
'',
'.prcs_status, .sbfl_status {',
'    font-size: 1.1rem;',
'    line-height: 1.1rem;',
'    padding: 2px 4px;',
'    border-radius: 2px;',
'    min-width: 64px;',
'    text-align: center;',
'    display: inline-block;',
'}',
'',
'.status-created{',
'    background-color: #8c9eb0 !important;',
'    fill: #8c9eb0 !important;',
'    color: #ffffff !important;',
'}',
'.status-running{',
'    background-color: #d9b13b !important;',
'    fill: #d9b13b !important;',
'    color: #ffffff !important;',
'}',
'.status-completed{',
'    background-color: #6aad42 !important;',
'    fill: #6aad42 !important;',
'    color: #f9f9f9 !important; ',
'}',
'.status-terminated{',
'    background-color: #d76a27 !important;',
'    fill: #d76a27 !important;',
'    color: #f9f9f9 !important; ',
'}',
'.status-error{',
'    background-color: #d2423b !important;',
'    fill: #d2423b !important;',
'    color: #ffffff !important;',
'}'))
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210818084523'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2401245095481901)
,p_plug_name=>'Add Gateway Route'
,p_region_name=>'gateway_selector'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7938158412499704)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(7946860874526805)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24415197915878710)
,p_plug_name=>'Tab Holder'
,p_region_name=>'flow-reports'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(12495575615770880223)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24415388012878712)
,p_plug_name=>'Variables'
,p_region_name=>'variables_ig'
,p_parent_plug_id=>wwv_flow_api.id(24415197915878710)
,p_region_css_classes=>'js-react-on-prcs js-hide-no-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_VARIABLES_VW'
,p_query_where=>'prov_prcs_id = :p10_prcs_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Variables'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416312772878722)
,p_name=>'PROV_PRCS_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_PRCS_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_include_in_export=>false
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416444646878723)
,p_name=>'PROV_VAR_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Variable Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>true
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_static_id=>'PROV_VAR_NAME'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416593672878724)
,p_name=>'PROV_VAR_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Variable Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_is_required=>true
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:VARCHAR2;VARCHAR2,NUMBER;NUMBER,DATE;DATE,CLOB;CLOB'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>'- Choose -'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_static_id=>'PROV_VAR_TYPE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416652168878725)
,p_name=>'PROV_VAR_VC2'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_VC2'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Varchar2 Value'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_static_id=>'PROV_VAR_VC2'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416719337878726)
,p_name=>'PROV_VAR_NUM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_NUM'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Number Value'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416845686878727)
,p_name=>'PROV_VAR_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Date Value'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24416900112878728)
,p_name=>'PROV_VAR_CLOB'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROV_VAR_CLOB'
,p_data_type=>'CLOB'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'CLOB Value'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>32767
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24417016443878729)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(24417149723878730)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(24416249103878721)
,p_internal_uid=>24416249103878721
,p_is_editable=>true
,p_edit_operations=>'i:u'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>false
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function (config) {',
'  var $            = apex.jQuery,',
'      toolbarData  = $.apex.interactiveGrid.copyDefaultToolbar(),',
'      toolbarGroup = toolbarData.toolbarFind( "actions3" );',
'',
'  toolbarGroup.controls.push({',
'    type: "BUTTON",',
'    action: "gateway-selector",',
'    iconBeforeLabel: false,',
'    hot: false',
'  });',
'',
'  config.toolbarData = toolbarData;',
'',
'  config.initActions = function (actions) {',
'    actions.add({',
'      name: "gateway-selector",',
'      label: "Add Gateway Route",',
'      action: gatewaySelector',
'    });',
'  }',
'',
'  function gatewaySelector( event, focusElement ) {',
'    apex.item( "P10_GATEWAY" ).setValue( "" );',
'    apex.item( "P10_CONNECTION" ).setValue( "" );',
'    apex.jQuery("#unselect_btn").hide();',
'    apex.jQuery("#select_btn").hide();',
'    apex.message.clearErrors();',
'    apex.theme.openRegion( "gateway_selector" );',
'  }',
'',
'  return config;',
'}'))
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(24459498107723697)
,p_interactive_grid_id=>wwv_flow_api.id(24416249103878721)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(24459589741723698)
,p_report_id=>wwv_flow_api.id(24459498107723697)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24460087892723704)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(24416312772878722)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24460585605723710)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(24416444646878723)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24461051458723712)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(24416593672878724)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24461562561723714)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(24416652168878725)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24462048588723716)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(24416719337878726)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24462535833723718)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(24416845686878727)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24463029288723719)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(24416900112878728)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(24464467079728593)
,p_view_id=>wwv_flow_api.id(24459589741723698)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(24417016443878729)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(160799453422501997)
,p_name=>'Subflows'
,p_region_name=>'subflows'
,p_parent_plug_id=>wwv_flow_api.id(24415197915878710)
,p_template=>wwv_flow_api.id(12495609856182880263)
,p_display_sequence=>30
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--staticRowColors:t-Report--rowHighlightOff'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_SUBFLOWS_VW'
,p_query_where=>'sbfl_prcs_id = :p10_prcs_id'
,p_query_order_by=>'sbfl_id'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No subflows found for selected process.'
,p_query_num_rows_item=>'P10_SUBFLOW_MAX_ROWS'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_LEFT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799330531501996)
,p_query_column_id=>1
,p_column_alias=>'SBFL_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Subflow ID'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798297119501986)
,p_query_column_id=>2
,p_column_alias=>'SBFL_PRCS_ID'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798785838501991)
,p_query_column_id=>3
,p_column_alias=>'SBFL_CURRENT'
,p_column_display_sequence=>2
,p_column_heading=>'Current'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799129243501994)
,p_query_column_id=>4
,p_column_alias=>'SBFL_STARTING_OBJECT'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798717697501990)
,p_query_column_id=>5
,p_column_alias=>'SBFL_LAST_UPDATE'
,p_column_display_sequence=>4
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_column_format=>'&APP_DATE_TIME_FORMAT.'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798666092501989)
,p_query_column_id=>6
,p_column_alias=>'SBFL_STATUS'
,p_column_display_sequence=>5
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="sbfl_status status-#SBFL_STATUS#">#SBFL_STATUS#</span>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(15681258975738603)
,p_query_column_id=>7
,p_column_alias=>'SBFL_CURRENT_LANE'
,p_column_display_sequence=>6
,p_column_heading=>'Lane'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(24415268947878711)
,p_query_column_id=>8
,p_column_alias=>'SBFL_RESERVATION'
,p_column_display_sequence=>7
,p_column_heading=>'Reserved For'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7695911351745146)
,p_query_column_id=>9
,p_column_alias=>'ACTION_HTML'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(24414985338878708)
,p_query_column_id=>10
,p_column_alias=>'RESERVATION_HTML'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(24415012484878709)
,p_query_column_id=>11
,p_column_alias=>'DERIVED$01'
,p_column_display_sequence=>8
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'#ACTION_HTML# #RESERVATION_HTML#'
,p_column_alignment=>'CENTER'
,p_derived_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12493545854579486121)
,p_plug_name=>'Flow Instances'
,p_region_name=>'flow_instances'
,p_parent_plug_id=>wwv_flow_api.id(24415197915878710)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_INSTANCES_VW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Flow Instances'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(26094211779304629)
,p_max_row_count=>'1000000'
,p_max_rows_per_page=>'1000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_LEFT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'FLOWS4APEX'
,p_internal_uid=>26094211779304629
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25020107643509605)
,p_db_column_name=>'VIEW_PROCESS'
,p_display_order=>10
,p_column_identifier=>'K'
,p_column_label=>'Viewer'
,p_column_html_expression=>'<span class="clickable-action id-ref fa fa-eye" data-prcs="#PRCS_ID#" data-action="view" data-name="#PRCS_NAME#" title="View Process Instance"></span>'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'view-process'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094452210304631)
,p_db_column_name=>'PRCS_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Instance'
,p_column_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_PRCS_ID:#PRCS_ID#'
,p_column_linktext=>'#PRCS_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_static_id=>'PRCS_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094567431304632)
,p_db_column_name=>'PRCS_DGRM_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_DGRM_ID:#PRCS_DGRM_ID#'
,p_column_linktext=>'#PRCS_DGRM_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094640100304633)
,p_db_column_name=>'PRCS_DGRM_VERSION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Version'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094739199304634)
,p_db_column_name=>'PRCS_DGRM_STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Flow Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094816603304635)
,p_db_column_name=>'PRCS_DGRM_CATEGORY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Flow Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094928056304636)
,p_db_column_name=>'PRCS_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="prcs_status status-#PRCS_STATUS#">#PRCS_STATUS#</span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095045075304637)
,p_db_column_name=>'PRCS_INIT_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095177493304638)
,p_db_column_name=>'PRCS_LAST_UPDATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095284298304639)
,p_db_column_name=>'BTN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Actions'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_static_id=>'action'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094328735304630)
,p_db_column_name=>'PRCS_ID'
,p_display_order=>110
,p_column_identifier=>'A'
,p_column_label=>'Process ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34631054458575812)
,p_db_column_name=>'PRCS_BUSINESS_REF'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Business Reference'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7938514653499708)
,p_db_column_name=>'PRCS_DGRM_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Prcs Dgrm Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26608389028834346)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'266084'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PRCS_DGRM_CATEGORY:VIEW_PROCESS:PRCS_NAME:PRCS_BUSINESS_REF:PRCS_DGRM_NAME:PRCS_DGRM_VERSION:PRCS_STATUS:PRCS_INIT_DATE:PRCS_LAST_UPDATE:BTN::PRCS_DGRM_ID'
,p_sort_column_1=>'PRCS_DGRM_CATEGORY'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PRCS_NAME'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'PRCS_DGRM_VERSION'
,p_sort_direction_3=>'DESC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'PRCS_DGRM_CATEGORY:0:0:0:0:0'
,p_break_enabled_on=>'PRCS_DGRM_CATEGORY:0:0:0:0:0'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34403200187171418)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6127698437330102702)
,p_plug_name=>'Flow Viewer'
,p_region_name=>'flow-monitor'
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_VW'
,p_query_where=>'prcs_id = :p10_prcs_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_02=>'ALL_CURRENT'
,p_attribute_04=>'ALL_COMPLETED'
,p_attribute_06=>'ALL_ERRORS'
,p_attribute_08=>'N'
,p_attribute_09=>'Y'
,p_attribute_10=>'Y'
,p_attribute_11=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10428749558468021)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(2401245095481901)
,p_button_name=>'UNSELECT'
,p_button_static_id=>'unselect_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Unselect all'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10428265504468016)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(2401245095481901)
,p_button_name=>'SELECT'
,p_button_static_id=>'select_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Select all'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2402252879481911)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(2401245095481901)
,p_button_name=>'ADD'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12491866636991262848)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(34403200187171418)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create new Instance'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RP,11::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7937992279499702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(34403200187171418)
,p_button_name=>'ACTION_MENU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_image_alt=>'Action Menu'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-menuButton'
,p_icon_css_classes=>'fa-bars'
,p_button_cattributes=>'data-menu="actions_menu"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34569800907098125)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP,10,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2401646511481905)
,p_name=>'P10_GATEWAY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2401245095481901)
,p_prompt=>'Gateway'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'P10_INSTANCE_GATEWAYS_LOV'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P10_PRCS_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5522035116864941)
,p_name=>'P10_OBJT_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6127698437330102702)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6600306983290124)
,p_name=>'P10_SBFL_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10426938547468003)
,p_name=>'P10_SELECT_OPTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2401245095481901)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10428066395468014)
,p_name=>'P10_CONNECTION'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(2401245095481901)
,p_prompt=>'Connection'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'P10_INSTANCE_CONNECTIONS_LOV'
,p_lov_cascade_parent_items=>'P10_PRCS_ID,P10_GATEWAY'
,p_ajax_optimize_refresh=>'Y'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34633831971575840)
,p_name=>'P10_SUBFLOW_MAX_ROWS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(160799453422501997)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34634208559575844)
,p_name=>'P10_DISPLAY_SETTING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(34403200187171418)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491864731021262829)
,p_name=>'P10_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797771746501981)
,p_name=>'Create Process Dialog closed - refresh Instances'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12491866636991262848)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737253943406143)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PRCS_ID'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P11_PRCS_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797694678501980)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29602959246125302)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(apex.lang.getMessage("APP_INSTANCE_CREATED"));'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25020236512509606)
,p_name=>'Create Process Dialog (Report) closed - refresh Instances'
,p_event_sequence=>110
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(12493545854579486121)
,p_bind_type=>'live'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737390268406144)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PRCS_ID'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P11_PRCS_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25020304399509607)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737098416406141)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(apex.lang.getMessage("APP_INSTANCE_CREATED"));'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797616307501979)
,p_name=>'Process Instance changed - Refresh Dependant Regions'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_PRCS_ID'
,p_condition_element=>'P10_PRCS_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24418082524878739)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-hide-no-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24417976486878738)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-react-on-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797554131501978)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-react-on-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33736937837406140)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId = apex.item("P10_PRCS_ID").getValue();',
'var selectedView = apex.item("P10_DISPLAY_SETTING").getValue();',
'',
'if ( prcsId !== "" && selectedView === "window") {',
'    redirectToMonitor(prcsId );',
'}'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24417860255878737)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-hide-no-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33736840958406139)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId = apex.item("P10_PRCS_ID").getValue();',
'var selectedView  = apex.item("P10_DISPLAY_SETTING").getValue();',
'',
'if ( prcsId !== "" && selectedView === "window") {',
'    redirectToMonitor(prcsId);',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160796862675501971)
,p_name=>'Clickable Action clicked - Forward to Process or Selection'
,p_event_sequence=>130
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.clickable-action'
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797238690501975)
,p_event_id=>wwv_flow_api.id(160796862675501971)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'var myAction  = myElement.data( "action" );',
'var myProcess = myElement.data( "prcs" );',
'var mySubflow = myElement.data( "sbfl" );',
'var displayOption = apex.item("P10_SELECT_OUTPUT").getValue();',
'',
'if ( myAction !== "view" || ( myAction === "view" && displayOption === "window") ) {',
'  var result = apex.server.process( "PROCESS_ACTION", {',
'    x01: myAction,',
'    x02: myProcess,',
'    x03: mySubflow',
'  });',
'  result.done( function( data ) {',
'    if (!data.success) {',
'      apex.debug.error( "Something went wrong..." );',
'    } else {',
'      if ( myAction === "delete" ) {',
'        apex.item( "P10_PRCS_ID" ).setValue();',
'     }',
'      else if ( myAction === "view" ) {',
'          apex.navigation.redirect(data.url);',
'      } else {',
'        apex.item( "P10_PRCS_ID" ).setValue( myProcess );',
'      }',
'	}',
'  }).fail( function( jqXHR, textStatus, errorThrown ) {',
'    apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );',
'  });  ',
'} else {',
'  apex.item( "P10_PRCS_ID" ).setValue( myProcess );',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7695828836745145)
,p_name=>'Subflows Report refreshed - Mark currently running'
,p_event_sequence=>140
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(160799453422501997)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7695671351745144)
,p_event_id=>wwv_flow_api.id(7695828836745145)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var runningSelector = "button.clickable-action";',
'var processRows = apex.jQuery( "#subflows tr" );',
'',
'processRows.has( runningSelector ).addClass( "flow-running" );'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24414763832878706)
,p_name=>'Instances Report Refreshed'
,p_event_sequence=>150
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(12493545854579486121)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24414806355878707)
,p_event_id=>wwv_flow_api.id(24414763832878706)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6127698437330102702)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var selectedProcess = apex.item( "P10_PRCS_ID" ).getValue();',
'var processRows = apex.jQuery( "#flow_instances td" );',
'processRows.removeClass(''current-process'');',
'                                                                   ',
'if (selectedProcess) {',
'  var currentSelector = "span.id-ref[data-prcs=" + selectedProcess + "]";',
'  var currentRow = processRows.has( currentSelector );',
'  var currentName = apex.jQuery( currentSelector ).data("name");',
'  currentRow.parent().children().addClass( "current-process" );',
'  apex.jQuery( "#" + this.affectedElements[0].id + "_heading" ).text("Flow Viewer (" + currentName +")" );',
'} else {',
'  apex.jQuery( "#" + this.affectedElements[0].id + "_heading" ).text("No process selected" );',
'}',
'',
'$(".a-IRR-headerLabel").each(function() {',
'    var text = $(this).text();',
'    if (text == ''Viewer'') {',
'        $(this).parent().addClass("viewer-heading")',
'    }',
'})'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24417684477878735)
,p_name=>'Refreshed'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33736700260406138)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId = apex.item("P10_PRCS_ID").getValue();',
'var selectedView  = apex.item("P10_SELECT_OUTPUT").getValue();',
'',
'if ( prcsId !== "" && selectedView === "window") {',
'    redirectToMonitor(prcsId);',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2402362161481912)
,p_name=>'Add clicked - add row to variables grid'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(2402252879481911)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2402433976481913)
,p_event_id=>wwv_flow_api.id(2402362161481912)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.clearErrors();',
'var errors = [];',
'',
'if (apex.item("P10_SELECT_OPTION").getValue() === "single" && apex.item("P10_CONNECTION").getValue().length > 1) {',
'    errors = [',
'        {',
'            type:       "error",',
'            location:   [ "inline" ],',
'            pageItem:   "P10_CONNECTION",',
'            message:    "Please select only one connection.",',
'            unsafe:     false',
'        }',
'    ];',
'}',
'if (apex.item("P10_CONNECTION").getValue().length === 0) {',
'    errors = [',
'        {',
'            type:       "error",',
'            location:   [ "inline" ],',
'            pageItem:   "P10_CONNECTION",',
'            message:    "Please select a connection.",',
'            unsafe:     false',
'        }',
'    ];',
'}',
'',
'if (errors.length > 0) {',
'    apex.message.showErrors(errors);',
'} else {',
'    var view = apex.region( "variables_ig" ).widget().interactiveGrid( "getCurrentView" );',
'    var model = view.model;',
'    var newRecordId = model.insertNewRecord();',
'    var $newRecord = model.getRecord( newRecordId );',
'',
'    setTimeout( function(){ ',
'      model.setValue( $newRecord, "PROV_VAR_TYPE", "VARCHAR2" );',
'      model.setValue( $newRecord, "PROV_VAR_NAME", apex.item("P10_GATEWAY").getValue() + ":route" );',
'      model.setValue( $newRecord, "PROV_VAR_VC2",  apex.item("P10_CONNECTION").getValue().join(":"));',
'    }, 5);',
'    apex.theme.closeRegion("gateway_selector");',
'}',
'',
'',
'',
'',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10427083703468004)
,p_name=>'Set Connection Select Option '
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_GATEWAY'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10427118909468005)
,p_event_id=>wwv_flow_api.id(10427083703468004)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_SELECT_OPTION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select select_option',
'from flow_instance_gateways_lov',
'where objt_bpmn_id = :P10_GATEWAY',
'and prcs_id = :P10_PRCS_ID'))
,p_attribute_07=>'P10_GATEWAY,P10_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10428376023468017)
,p_name=>'Select all connection'
,p_event_sequence=>200
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10428265504468016)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10428413100468018)
,p_event_id=>wwv_flow_api.id(10428376023468017)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery("#P10_CONNECTION").find(''input[type="checkbox"]'').toArray().forEach(function(e) {',
'  e.checked = true;',
'});'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10428545869468019)
,p_event_id=>wwv_flow_api.id(10428376023468017)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428265504468016)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10428624364468020)
,p_event_id=>wwv_flow_api.id(10428376023468017)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428749558468021)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10428830923468022)
,p_name=>'Unselect all connection'
,p_event_sequence=>210
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10428749558468021)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10428957553468023)
,p_event_id=>wwv_flow_api.id(10428830923468022)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery("#P10_CONNECTION").find(''input[type="checkbox"]'').toArray().forEach(function(e) {',
'  e.checked = false;',
'});'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10429048123468024)
,p_event_id=>wwv_flow_api.id(10428830923468022)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428749558468021)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10429160835468025)
,p_event_id=>wwv_flow_api.id(10428830923468022)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428265504468016)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10429447518468028)
,p_name=>'Display Button Based on Gateway Type'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SELECT_OPTION'
,p_condition_element=>'P10_SELECT_OPTION'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'multi'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10429500342468029)
,p_event_id=>wwv_flow_api.id(10429447518468028)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428265504468016)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10429676592468030)
,p_event_id=>wwv_flow_api.id(10429447518468028)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(10428265504468016)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33734648059406117)
,p_name=>'Show 1st Diagram in BPMN-Viewer'
,p_event_sequence=>230
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33734760775406118)
,p_event_id=>wwv_flow_api.id(33734648059406117)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ( apex.item("P10_PRCS_ID").isEmpty() ) {',
'    var prcsId = apex.jQuery(apex.jQuery(''[data-action="view"]'')[0]).data("prcs");',
'    if ( prcsId !== undefined ) {',
'        apex.item("P10_PRCS_ID").setValue(prcsId);',
'        apex.region("flow-monitor").refresh();',
'    }',
'}',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(33735458903406125)
,p_name=>'Flow Monitor View Settings'
,p_event_sequence=>250
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SELECT_OUTPUT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33735523526406126)
,p_event_id=>wwv_flow_api.id(33735458903406125)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var selectedView = apex.item("P10_SELECT_OUTPUT").getValue();',
'var prcsId = apex.item("P10_PRCS_ID").getValue();',
'',
'switch(selectedView) {',
'    case "row" : ',
'        apex.jQuery("#col1").addClass("col-12").removeClass("col-6");',
'        apex.jQuery("#col2").addClass("col-12").removeClass("col-6");',
'        ',
'        apex.jQuery("#flow-monitor").show();',
'        apex.region("flow-monitor").refresh();',
'        break;',
'    case "column" :',
'        apex.jQuery("#col1").addClass("col-6").removeClass("col-12");',
'        apex.jQuery("#col2").addClass("col-6").removeClass("col-12");',
'        apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());',
'        ',
'        apex.jQuery("#flow-monitor").show();',
'        apex.region("flow-monitor").refresh();',
'        break;',
'    case "window" :',
'        apex.jQuery("#flow-monitor").hide();',
'        apex.jQuery("#col1").addClass("col-12").removeClass("col-6");',
'        apex.jQuery("#col2").addClass("col-12").removeClass("col-6");',
'        ',
'        if ( prcsId !== "" ) {',
'            redirectToMonitor(prcsId);',
'        }',
'        break;',
'}',
'',
'',
''))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33735607736406127)
,p_event_id=>wwv_flow_api.id(33735458903406125)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Save user preference',
'apex_util.set_preference(''VIEWPORT'',:P10_SELECT_OUTPUT);',
'',
'if (:P10_SELECT_OUTPUT = ''row'') then',
'    :P10_SUBFLOW_MAX_ROWS := 10;',
'else',
'    :P10_SUBFLOW_MAX_ROWS := 50;',
'end if;'))
,p_attribute_02=>'P10_SELECT_OUTPUT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34633996700575841)
,p_event_id=>wwv_flow_api.id(33735458903406125)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(160799453422501997)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4404300076699533)
,p_name=>'Reposition Download Image Button'
,p_event_sequence=>270
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4404452394699534)
,p_event_id=>wwv_flow_api.id(4404300076699533)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$("#download-image").prependTo("#flow-monitor > div.t-Region-header > div.t-Region-headerItems.t-Region-headerItems--buttons").removeClass("u-hidden");'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5522150485864942)
,p_name=>'Element clicked'
,p_event_sequence=>280
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P10_OBJT_LIST'').split('':'').includes(this.data.element.id);'
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522263817864943)
,p_event_id=>wwv_flow_api.id(5522150485864942)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process(',
'    ''PREPARE_URL'',                           ',
'    {',
'        x01: $v(''P10_PRCS_ID''),',
'        x02: this.data.element.id,',
'    }, ',
'    {',
'        success: function (pData)',
'        {           ',
'            apex.navigation.redirect(pData);',
'        },',
'        dataType: "text"                     ',
'    }',
');'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5522454027864945)
,p_name=>'Change cursor'
,p_event_sequence=>290
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522598629864946)
,p_event_id=>wwv_flow_api.id(5522454027864945)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_OBJT_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct listagg(OBJT_BPMN_ID, '':'') within group (order by OBJT_BPMN_ID) "OBJT_ID"',
'from FLOW_OBJECTS',
'where OBJT_DGRM_ID = (select PRCS_DGRM_ID from FLOW_PROCESSES where PRCS_ID = :P10_PRCS_ID)',
'and not OBJT_TAG_NAME = ''bpmn:process'';'))
,p_attribute_07=>'P10_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522653812864947)
,p_event_id=>wwv_flow_api.id(5522454027864945)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var objects = $v(''P10_OBJT_LIST'').split('':'');',
'$.each(objects, function( index, value ) {',
'    $( "[data-element-id=''" + value + "'']").css( "cursor", "pointer" );',
'})'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34634407162575846)
,p_name=>'On Change Display Setting'
,p_event_sequence=>300
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_DISPLAY_SETTING'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34634644617575848)
,p_event_id=>wwv_flow_api.id(34634407162575846)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Save user preference',
'apex_util.set_preference(''VIEWPORT'',:P10_DISPLAY_SETTING);',
'',
'if (:P10_DISPLAY_SETTING = ''row'') then',
'    :P10_SUBFLOW_MAX_ROWS := 10;',
'else',
'    :P10_SUBFLOW_MAX_ROWS := 50;',
'end if;'))
,p_attribute_02=>'P10_DISPLAY_SETTING'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34634703305575849)
,p_event_id=>wwv_flow_api.id(34634407162575846)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(160799453422501997)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(24417245693878731)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(24415388012878712)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Variables - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_p0010_api.process_variables_row',
'(',
'  pi_row_status    => :apex$row_status',
', pi_prov_prcs_id  => :p10_prcs_id',
', pi_prov_var_name => :prov_var_name',
', pi_prov_var_type => :prov_var_type',
', pi_prov_var_vc2  => :prov_var_vc2',
', pi_prov_var_num  => :prov_var_num',
', pi_prov_var_date => to_date( :prov_var_date, v(''APP_DATE_TIME_FORMAT'') )',
', pi_prov_var_clob => :prov_var_clob',
');'))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(33735382808406124)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Viewport for BPMN-Viewer'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Load user preference for the BPMN-Viewer and set it after the page has fully loaded',
'declare',
'    l_script varchar2(4000);',
'begin',
'',
'    -- Set IDs for the the row divs',
'    l_script := q''#apex.jQuery("#flow-reports").parent().attr("id","col1");',
'                   apex.jQuery("#flow-monitor").parent().attr("id","col2");#'';',
'    ',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE (',
'        p_code => l_script,',
'        p_key  => ''init_viewport'');',
'',
'    :P10_DISPLAY_SETTING := nvl(apex_util.get_preference(''VIEWPORT''),''row'');',
'    :P10_SUBFLOW_MAX_ROWS := 10;',
'    ',
'    l_script := null;',
'    -- Set view to side-by-side if preference = ''column''',
'    if :P10_DISPLAY_SETTING = ''column'' then',
'    ',
'        l_script := q''#apex.jQuery("#col1").addClass("col-6").removeClass("col-12");',
'                       apex.jQuery("#col2").addClass("col-6").removeClass("col-12");',
'                       apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());',
'                       apex.jQuery("#flow-monitor").show();',
'                       apex.region( "flow-monitor" ).refresh();#'';',
'        :P10_SUBFLOW_MAX_ROWS := 50;',
'     elsif :P10_DISPLAY_SETTING = ''window'' then',
'        l_script := q''#apex.jQuery("#flow-monitor").hide();',
'                       apex.jQuery("#col1").addClass("col-12").removeClass("col-6");',
'                       apex.jQuery("#col2").addClass("col-12").removeClass("col-6");#'';',
'        :P10_SUBFLOW_MAX_ROWS := 50;',
'    end if;',
'    ',
'    if l_script is not null then',
'        APEX_JAVASCRIPT.ADD_ONLOAD_CODE (',
'            p_code => l_script,',
'            p_key  => ''viewport''',
'        );',
'    end if;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(160796959681501972)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PROCESS_ACTION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_p0010_api.process_action',
'(',
'  pi_action  => apex_application.g_x01',
', pi_prcs_id => apex_application.g_x02',
', pi_sbfl_id => apex_application.g_x03',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5522324613864944)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PREPARE_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_url varchar2(2000);',
'    l_app number := v(''APP_ID'');',
'    l_session number := v(''APP_SESSION'');',
'',
'BEGIN',
'    l_url := APEX_UTIL.PREPARE_URL(',
'        p_url => ''f?p='' || l_app || '':13:'' || l_session ||''::NO::P13_PRCS_ID,P13_OBJT_ID:''|| apex_application.g_x01 || '','' || apex_application.g_x02,',
'        p_checksum_type => ''SESSION'');',
'    htp.p(l_url);',
'END;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/

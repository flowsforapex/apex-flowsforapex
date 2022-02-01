prompt --application/shared_components/user_interface/lovs/p13_object_attributes
begin
--   Manifest
--     P13_OBJECT_ATTRIBUTES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(15330862223656536)
,p_lov_name=>'P13_OBJECT_ATTRIBUTES'
,p_lov_query=>'.'||wwv_flow_api.id(15330862223656536)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331159536656553)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Application'
,p_lov_return_value=>'apex:applicationId'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331535176656556)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Clear Cache'
,p_lov_return_value=>'apex:cache'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15331901949656556)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Item Values'
,p_lov_return_value=>'apex:itemValue'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15332307999656557)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Request'
,p_lov_return_value=>'apex:request'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15332751649656557)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Page Items'
,p_lov_return_value=>'apex:itemName'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333170482656557)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'PL/SQL Code'
,p_lov_return_value=>'apex:plsqlCode'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333581483656557)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'Bind Page Item Values'
,p_lov_return_value=>'apex:autoBinds'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15333933530656557)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Engine'
,p_lov_return_value=>'apex:engine'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15334375925656558)
,p_lov_disp_sequence=>9
,p_lov_disp_value=>'Page'
,p_lov_return_value=>'apex:pageId'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15373450429468526)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Process status after termination'
,p_lov_return_value=>'processStatus'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15373733235468542)
,p_lov_disp_sequence=>11
,p_lov_disp_value=>'Timer Definition Type'
,p_lov_return_value=>'timerType'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15374151920468542)
,p_lov_disp_sequence=>12
,p_lov_disp_value=>'Timer Definition'
,p_lov_return_value=>'timerDefinition'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35700662160505107)
,p_lov_disp_sequence=>13
,p_lov_disp_value=>'Task Type'
,p_lov_return_value=>'taskType'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35700949683505137)
,p_lov_disp_sequence=>14
,p_lov_disp_value=>'From'
,p_lov_return_value=>'apex:emailFrom'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35701367611505137)
,p_lov_disp_sequence=>15
,p_lov_disp_value=>'To'
,p_lov_return_value=>'apex:emailTo'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35701702285505137)
,p_lov_disp_sequence=>16
,p_lov_disp_value=>'CC'
,p_lov_return_value=>'apex:emailCC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35702112103505146)
,p_lov_disp_sequence=>17
,p_lov_disp_value=>'BCC'
,p_lov_return_value=>'apex:emailBCC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35702525554505146)
,p_lov_disp_sequence=>18
,p_lov_disp_value=>'Reply To'
,p_lov_return_value=>'apex:emailReplyTo'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35702928038505146)
,p_lov_disp_sequence=>19
,p_lov_disp_value=>'Use Template'
,p_lov_return_value=>'apex:useTemplate'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35703352692505146)
,p_lov_disp_sequence=>20
,p_lov_disp_value=>'Application ID'
,p_lov_return_value=>'apex:applicationId'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35703713806505147)
,p_lov_disp_sequence=>21
,p_lov_disp_value=>'Template ID'
,p_lov_return_value=>'apex:templateId'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35704108915505147)
,p_lov_disp_sequence=>22
,p_lov_disp_value=>'Placeholder'
,p_lov_return_value=>'apex:placeholder'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35704517220505147)
,p_lov_disp_sequence=>23
,p_lov_disp_value=>'Subject'
,p_lov_return_value=>'apex:subject'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35704978438505147)
,p_lov_disp_sequence=>24
,p_lov_disp_value=>'Body'
,p_lov_return_value=>'apex:bodyText'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35705311456505147)
,p_lov_disp_sequence=>25
,p_lov_disp_value=>'HTML Body'
,p_lov_return_value=>'apex:bodyHTML'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35705730321505148)
,p_lov_disp_sequence=>26
,p_lov_disp_value=>'Attachment'
,p_lov_return_value=>'apex:attachment'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35706161989505149)
,p_lov_disp_sequence=>27
,p_lov_disp_value=>'Send Immediatly'
,p_lov_return_value=>'apex:immediately'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35707717059505149)
,p_lov_disp_sequence=>31
,p_lov_disp_value=>'Date'
,p_lov_return_value=>'apex:date'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35708141249505150)
,p_lov_disp_sequence=>32
,p_lov_disp_value=>'Format Mask'
,p_lov_return_value=>'apex:formatMask'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35708515702505150)
,p_lov_disp_sequence=>33
,p_lov_disp_value=>'Interval Year to Month'
,p_lov_return_value=>'apex:intervalYM'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35708950682505150)
,p_lov_disp_sequence=>34
,p_lov_disp_value=>'Interval Day to Second'
,p_lov_return_value=>'apex:intervalDS'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35709380114505150)
,p_lov_disp_sequence=>35
,p_lov_disp_value=>'Time until the timer fires first'
,p_lov_return_value=>'apex:startIntervalDS'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35709717522505150)
,p_lov_disp_sequence=>36
,p_lov_disp_value=>'Time until the timer fires again'
,p_lov_return_value=>'apex:repeatIntervalDS'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(35710159164505151)
,p_lov_disp_sequence=>37
,p_lov_disp_value=>'Max Runs'
,p_lov_return_value=>'apex:maxRuns'
);
wwv_flow_api.component_end;
end;
/

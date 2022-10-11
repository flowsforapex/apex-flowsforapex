prompt --application/shared_components/globalization/language
begin
--   Manifest
--     LANGUAGE MAP: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_language_map(
 p_id=>wwv_flow_api.id(9033928420999483)
,p_translation_flow_id=>100001
,p_translation_flow_language_cd=>'fr'
,p_direction_right_to_left=>'N'
);
wwv_flow_api.create_language_map(
 p_id=>wwv_flow_api.id(53002706255554766)
,p_translation_flow_id=>100002
,p_translation_flow_language_cd=>'pt-br'
,p_direction_right_to_left=>'N'
);
wwv_flow_api.create_language_map(
 p_id=>wwv_flow_api.id(53002824512556233)
,p_translation_flow_id=>100003
,p_translation_flow_language_cd=>'ja'
,p_direction_right_to_left=>'N'
);
wwv_flow_api.create_language_map(
 p_id=>wwv_flow_api.id(53913409405549240)
,p_translation_flow_id=>100004
,p_translation_flow_language_cd=>'de'
,p_direction_right_to_left=>'N'
);
wwv_flow_api.create_language_map(
 p_id=>wwv_flow_api.id(65314222214861109)
,p_translation_flow_id=>100005
,p_translation_flow_language_cd=>'es'
,p_direction_right_to_left=>'N'
);
wwv_flow_api.component_end;
end;
/

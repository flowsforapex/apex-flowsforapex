prompt --application/shared_components/globalization/messages
begin
--   Manifest
--     MESSAGES: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
null;
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
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717707530572379)
,p_name=>'APP_CHOOSE_BRANCH'
,p_message_text=>'Choose Branch'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909982182815176)
,p_name=>'APP_CHOOSE_BRANCH'
,p_message_language=>'fr'
,p_message_text=>'Choisir une branche'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717207504480868)
,p_name=>'APP_COMPLETE_STEP'
,p_message_text=>'Go to next step'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908538544815176)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Passer \00E0 l''\00E9tape suivante')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8221810702495139)
,p_name=>'APP_COPY_FLOW'
,p_message_text=>'Copy Flow'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714502237388987)
,p_name=>'APP_CREATE_INSTANCE'
,p_message_text=>'Create New Instance'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908171271815176)
,p_name=>'APP_CREATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('Cr\00E9er une nouvelle instance')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34716303518466200)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_text=>'Delete Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909731290815176)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Supprimer une instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34705077390288729)
,p_name=>'APP_DEPRECATE_DIAGRAM'
,p_message_text=>'You are about to mark as deprecated this flow. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908677320815176)
,p_name=>'APP_DEPRECATE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de marquer ce flux comme obsol\00E8te. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34704307318272181)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_text=>'There are %0 process instances associated to this flow.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909438857815176)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe %0 instances associ\00E9e(s) \00E0 ce flux.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714396518387453)
,p_name=>'APP_EDIT'
,p_message_text=>'Edit'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908301413815176)
,p_name=>'APP_EDIT'
,p_message_language=>'fr'
,p_message_text=>unistr('\00C9diter')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8225061315538358)
,p_name=>'APP_FLOW_COPIED'
,p_message_text=>'Flow copied.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(28300791809214356)
,p_name=>'APP_FLOW_IMPORTED'
,p_message_text=>'Flow imported.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909058587815176)
,p_name=>'APP_FLOW_IMPORTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Flux import\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(29609850900170775)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_text=>'Instance created.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909203491815176)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance cr\00E9\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714875794391923)
,p_name=>'APP_NEW_VERSION'
,p_message_text=>'New version'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908222002815176)
,p_name=>'APP_NEW_VERSION'
,p_message_language=>'fr'
,p_message_text=>'Nouvelle version'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34723270983639953)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_text=>'New version added.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34910075530815176)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Nouvelle version ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(28202305228139790)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_text=>'If there are running instances associated to the existing model, then these might cause errors. Are you sure to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909122879815176)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'fr'
,p_message_text=>unistr('S''il existe des instances en cours d''ex\00E9cution associ\00E9es \00E0 ce mod\00E8le, cela risque de provoquer des erreurs. \00CAtes-vous s\00FBr de vouloir continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34706651053300739)
,p_name=>'APP_RELEASE_DIAGRAM'
,p_message_text=>'You are about to release this flow, this will mark as deprecated the current released version. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908478528815176)
,p_name=>'APP_RELEASE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de publier ce flux, ceci va rendre obsol\00E8te la version publi\00E9e courante. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717072336475279)
,p_name=>'APP_RELEASE_STEP'
,p_message_text=>'Release Reservation'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908797363815176)
,p_name=>'APP_RELEASE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Lib\00E9rer la r\00E9servation')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34716833789473548)
,p_name=>'APP_RESERVE_STEP'
,p_message_text=>'Reserve Step'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909887758815176)
,p_name=>'APP_RESERVE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('R\00E9server l''\00E9tape')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715720510433885)
,p_name=>'APP_RESET_INSTANCE'
,p_message_text=>'Reset Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34910171604815176)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('R\00E9initialiser l''instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715595762431684)
,p_name=>'APP_START_INSTANCE'
,p_message_text=>'Start Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909616153815176)
,p_name=>'APP_START_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('D\00E9marrer l''instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715995579436957)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_text=>'Terminate Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909540389815176)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Terminer l''instance de flux'
,p_is_js_message=>true
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
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(26017638645989579)
,p_name=>'DGRM_UK'
,p_message_text=>'A flow already exists with the same name and status.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908898095815176)
,p_name=>'DGRM_UK'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux ayant le m\00EAme nom et statut existe d\00E9j\00E0.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(24219258023169431)
,p_name=>'DGRM_UK2'
,p_message_text=>'A flow with this name and having a status of ''released'' already exists. Change the existing flow status to deprecated or archived and re-import.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34908973711815176)
,p_name=>'DGRM_UK2'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe d\00E9j\00E0 un flux du m\00EAme nom au statut "publi\00E9". Veuillez changer le statut de de flux pour "d\00E9pr\00E9ci\00E9" ou "archiv\00E9" et importer de nouveau.')
,p_is_js_message=>true
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
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(24202863069473923)
,p_name=>'PRCS_DGRM_FK'
,p_message_text=>'Process instances using this flow exist. Use cascade option to remove flow and process instances.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34909398019815176)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe des instances utilisant ce flux. Veuillez utiliser l''option cascade pour supprimer le flux et les instances associ\00E9es.')
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/

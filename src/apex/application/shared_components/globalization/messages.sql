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
 p_id=>wwv_flow_api.id(11208996871917779)
,p_name=>'APP_ARCHIVE_DIAGRAM'
,p_message_text=>'You are about to archive this flow. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11209302202923800)
,p_name=>'APP_ARCHIVE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point d''archiver ce flux. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717707530572379)
,p_name=>'APP_CHOOSE_BRANCH'
,p_message_text=>'Choose Branch'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10002543494408640)
,p_name=>'APP_CHOOSE_BRANCH'
,p_message_language=>'fr'
,p_message_text=>'Choisir une branche'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717207504480868)
,p_name=>'APP_COMPLETE_STEP'
,p_message_text=>'Complete'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10002429235408640)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Compl\00E9ter')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5024381545147791)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_text=>'This will delete the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8808567548754958)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7370414939802683)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_text=>'This will delete the process variable. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8808884945768951)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera la variable de processus. Voulez-vous continuer?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11225313312069738)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_text=>'You are about to release reservation on step(s). Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11225586388072945)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de lib\00E9rer la r\00E9servation du ou des step(s). Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5023975409141065)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_text=>'This will reset the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8809013864775040)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci r\00E9initialisera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7072975164227666)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_text=>'This will restart the subflow. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8809257400778599)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci red\00E9marrera le sous-flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5024181840145883)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_text=>'This will terminate the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8809566017786943)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci terminera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8221810702495139)
,p_name=>'APP_COPY_FLOW'
,p_message_text=>'Copy Flow'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8809746925790732)
,p_name=>'APP_COPY_FLOW'
,p_message_language=>'fr'
,p_message_text=>'Copie du flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714502237388987)
,p_name=>'APP_CREATE_INSTANCE'
,p_message_text=>'Create New Instance'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001689116408622)
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
 p_id=>wwv_flow_api.id(10002101378408629)
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
 p_id=>wwv_flow_api.id(10001381386408584)
,p_name=>'APP_DEPRECATE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de rendre obsol\00E8te ce flux. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34704307318272181)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_text=>'There are %0 process instances associated to this flow.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001288793408582)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe %0 instance(s) de processus associ\00E9e(s) \00E0 ce flux.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714396518387453)
,p_name=>'APP_EDIT'
,p_message_text=>'Edit'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001510439408618)
,p_name=>'APP_EDIT'
,p_message_language=>'fr'
,p_message_text=>'Editer'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385691008882345)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_text=>'Please select a connection'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8809927725796676)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('Veuillez s\00E9lectionner une connexion')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385418133881112)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Please select only one connection',
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8810171360799490)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'fr'
,p_message_text=>unistr('Veuillez s\00E9lectionner une seule connexion')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385297806875971)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_text=>'Value must be a date'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8810395913803578)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre une date')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384469808866136)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_text=>'Variable Name must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8810506910813024)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le nom de la variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385007498873734)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_text=>'Value must be a number'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8810702984816696)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre un nombre')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384642544868247)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_text=>'Variable Type must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8810914092819025)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le type de variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384854796870876)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_text=>'Value must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8811479126833060)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur ne peut \00EAtre vide')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8225061315538358)
,p_name=>'APP_FLOW_COPIED'
,p_message_text=>'Flow copied.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8811630684838006)
,p_name=>'APP_FLOW_COPIED'
,p_message_language=>'fr'
,p_message_text=>unistr('Flux copi\00E9')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(28300791809214356)
,p_name=>'APP_FLOW_IMPORTED'
,p_message_text=>'Flow imported.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001028641408574)
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
 p_id=>wwv_flow_api.id(10001178614408580)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'fr'
,p_message_text=>'Instance created.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005845949232185)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_text=>'Flow instance deleted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7006138066240834)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005460531221619)
,p_name=>'APP_INSTANCE_RESET'
,p_message_text=>'Flow instance reset.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7006743414248765)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux r\00E9initialis\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005265750200100)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_text=>'Flow instance started.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7006585036246542)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux d\00E9marr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005690133229935)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_text=>'Flow instance terminated.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7006368587244427)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux termin\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34714875794391923)
,p_name=>'APP_NEW_VERSION'
,p_message_text=>'New version'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001736548408623)
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
 p_id=>wwv_flow_api.id(10002607696408641)
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
 p_id=>wwv_flow_api.id(10000925518408566)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'fr'
,p_message_text=>unistr('Si des instances en cours d''ex\00E9cution sont associ\00E9es au mod\00E8le existant, ceci peut provoquer des erreurs. Etes-vous s\00FBr de vouloir continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049063211512400)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_text=>'Process variable added.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049247532514652)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7371506201807240)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_text=>'Process variable deleted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8811829469844524)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049459946516827)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_text=>'Process variable saved.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049651493519440)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus enregistr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34706651053300739)
,p_name=>'APP_RELEASE_DIAGRAM'
,p_message_text=>'You are about to release this flow, this will mark as deprecated the current released version. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001431294408617)
,p_name=>'APP_RELEASE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de publier ce flux, ceci rendra obsol\00E8te la version courant publi\00E9e. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717072336475279)
,p_name=>'APP_RELEASE_STEP'
,p_message_text=>'Release Reservation'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10002326444408635)
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
 p_id=>wwv_flow_api.id(10002220773408634)
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
 p_id=>wwv_flow_api.id(10001901039408626)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('R\00E9initialiser l''instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7072717610226144)
,p_name=>'APP_RESTART_STEP'
,p_message_text=>'Re-start'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8812253665854030)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Red\00E9marrer')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715595762431684)
,p_name=>'APP_START_INSTANCE'
,p_message_text=>'Start Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10001809511408626)
,p_name=>'APP_START_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('D\00E9marrer une instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7020498147014290)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_text=>'Subflow restarted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7020695466017798)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Sous-flux red\00E9marr\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715995579436957)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_text=>'Terminate Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10002022150408626)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Terminer l''instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11239873943364108)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_text=>'Flow Viewer'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11240915802390717)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11240035334366277)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_text=>'Flow Viewer (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11241189033393574)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux (%0)'
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
 p_id=>wwv_flow_api.id(10000815536408555)
,p_name=>'DGRM_UK'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux existe d\00E9j\00E0 avec le m\00EAme nom et le m\00EAme statut.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(24219258023169431)
,p_name=>'DGRM_UK2'
,p_message_text=>'A flow with this name and having a status of ''released'' already exists. Change the existing flow status to deprecated or archived and re-import.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(10000733824408555)
,p_name=>'DGRM_UK2'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux portant ce nom et ayant le statut "released" existe d\00E9j\00E0.  Changez le statut du flux existant en deprecated ou archived et r\00E9importez-le.')
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
 p_id=>wwv_flow_api.id(10000673851408553)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'fr'
,p_message_text=>'Des instances de processus utilisant ce flux existent. Utilisez l''option cascade pour supprimer le flux et les instances de processus.'
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/

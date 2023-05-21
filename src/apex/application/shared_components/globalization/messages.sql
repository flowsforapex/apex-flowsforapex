prompt --application/shared_components/globalization/messages
begin
--   Manifest
--     MESSAGES: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
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
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534697581574343)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'de'
,p_message_text=>'APEX Seite'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36508956348127995)
,p_name=>'APEX:APEXPAGE'
,p_message_text=>'APEX Page'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722571659971487)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'es'
,p_message_text=>unistr('P\00E1gina APEX')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516678995573623)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'fr'
,p_message_text=>'Page APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522645019573770)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'ja'
,p_message_text=>unistr('APEX\30DA\30FC\30B8')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528629970574229)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('P\00E1gina APEX')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534761230574343)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'de'
,p_message_text=>unistr('PL/SQL ausf\00FChren')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36509146907128987)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_text=>'Execute PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722633453971487)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'es'
,p_message_text=>'Ejecutar PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516754166573623)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'fr'
,p_message_text=>unistr('Ex\00E9cuter PL/SQL')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522749172573771)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'ja'
,p_message_text=>unistr('PL/SQL\306E\5B9F\884C')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528767040574230)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'pt-br'
,p_message_text=>'Executar PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534812106574343)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'de'
,p_message_text=>'Zyklus (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36509328878129867)
,p_name=>'APEX:ORACLECYCLE'
,p_message_text=>'Cycle (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722770561971487)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'es'
,p_message_text=>'Ciclo (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516831330573623)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'fr'
,p_message_text=>'Cycle (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522801371573771)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30A4\30AF\30EB(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528835150574230)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'pt-br'
,p_message_text=>'Ciclo (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535432282574343)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'de'
,p_message_text=>'Datum (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36510876716170222)
,p_name=>'APEX:ORACLEDATE'
,p_message_text=>'Date (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723347833971507)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'es'
,p_message_text=>'Fecha (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517440198573626)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'fr'
,p_message_text=>'Date (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523451151573771)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E5\4ED8(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529469032574233)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'pt-br'
,p_message_text=>'Data (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535020404574343)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'de'
,p_message_text=>'Dauer (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36509739553137614)
,p_name=>'APEX:ORACLEDURATION'
,p_message_text=>'Duration (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722952271971493)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'es'
,p_message_text=>unistr('Duraci\00F3n (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517041304573624)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'fr'
,p_message_text=>unistr('Dur\00E9e (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523016564573771)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'ja'
,p_message_text=>unistr('\671F\9593(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529016848574232)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Dura\00E7\00E3o (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534915854574343)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'de'
,p_message_text=>'Email senden'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36509583287131032)
,p_name=>'APEX:SENDMAIL'
,p_message_text=>'Send Email'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722870744971493)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'es'
,p_message_text=>unistr('Enviar correo electr\00F3nico')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516978323573624)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'fr'
,p_message_text=>'Envoyer un courriel'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522981384573771)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'ja'
,p_message_text=>unistr('\96FB\5B50\30E1\30FC\30EB\306E\9001\4FE1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528960714574230)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'pt-br'
,p_message_text=>'Enviar e-mail'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(3703354379634692)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'An APEX upgrade have been detected:',
'<ul>',
'<li>running version: %0.%1</li>',
'<li>stored version: %2.%3</li>',
'</ul>',
'You must follow the documentation <a href="#" >here</a> to resolve it.'))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534481144574343)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'de'
,p_message_text=>'Abgeschlossen'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34717207504480868)
,p_name=>'APP_COMPLETE_STEP'
,p_message_text=>'Complete'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722301725971478)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'es'
,p_message_text=>'Completo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516471395573620)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Compl\00E9ter')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522489835573770)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\5B8C\4E86')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528453800574229)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Completo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532115289574341)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'de'
,p_message_text=>unistr('Sie sind dabei dieses Modell zu archivieren. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11208996871917779)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_text=>'You are about to archive this model. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720070976971415)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Va a archivar este modelo. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514129888573604)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point d''archiver ce mod\00E8le. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520177655573769)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\30A2\30FC\30AB\30A4\30D6\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526185259574217)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a arquivar este modelo. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530120133574339)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz wird gel\00F6scht. Bitte f\00FCgen sie einen Kommentar hinzu (optional) und best\00E4tigen sie.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5024381545147791)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_text=>'This will delete the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718098229971367)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n suprimir\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512171666573594)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518155811573732)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\524A\9664\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524122368574206)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto eliminar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531182413574339)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'de'
,p_message_text=>unistr('Prozessvariable wird gel\00F6scht. Bitte f\00FCgen sie einen Kommentar hinzu (optional) und best\00E4tigen sie.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7370414939802683)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_text=>'This will delete the process variable. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719091233971390)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n suprimir\00E1 la variable de proceso. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513179120573599)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera la variable de processus. Voulez-vous continuer?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519158786573768)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\3001\30D7\30ED\30BB\30B9\5909\6570\304C\524A\9664\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525170081574212)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto eliminar\00E1 a vari\00E1vel de processo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533998560574342)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'de'
,p_message_text=>unistr('Sie sind dabei dieses Modell als Veraltet zu markieren. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34705077390288729)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_text=>'You are about to mark as deprecated this model. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721808866971466)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de marcar este modelo como en desuso. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515993070573615)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de rendre obsol\00E8te ce mod\00E8le. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521906044573770)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\975E\63A8\5968\3068\3057\3066\30DE\30FC\30AF\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527937937574226)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a marcar este modelo como descontinuado. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532913280574342)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'de'
,p_message_text=>unistr('Sie sind dabei das Diagramm eines releasten Modells zu \00E4ndern. Dies kann zu Fehlern in der Ausf\00FChrung aktueller Instanzen dieses Modells f\00FChren. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(14021007858509194)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_text=>'Your are about to modify a diagram of a released model. That could possibly breaks running instances of that model. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720886299971435)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'es'
,p_message_text=>unistr('Va a modificar un diagrama de un modelo liberado. Esto podr\00EDa interrumpir las instancias en ejecuci\00F3n de ese modelo. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514968714573608)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de modifier un diagramme d''un mod\00E8le au statut released. Cela pourrait \00E9ventuellement provoquer des erreurs sur les instances en cours d''ex\00E9cution pour ce mod\00E8le. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520988102573769)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'ja'
,p_message_text=>unistr('\30EA\30EA\30FC\30B9\3055\308C\305F\30E2\30C7\30EB\306E\56F3\3092\4FEE\6B63\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\3053\308C\306B\3088\308A\3001\305D\306E\30E2\30C7\30EB\306E\5B9F\884C\4E2D\306E\30A4\30F3\30B9\30BF\30F3\30B9\304C\58CA\308C\308B\53EF\80FD\6027\304C\3042\308A\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526913373574221)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a modificar um diagrama de um modelo lan\00E7ado. Isso poderia possivelmente quebrar inst\00E2ncias de execu\00E7\00E3o desse modelo. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534025374574342)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'de'
,p_message_text=>unistr('Sie sind dabei dieses Model zu releasen. Die aktuelle Release-Version wird als Veraltet markiert. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34706651053300739)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_text=>'You are about to release this model, this will mark as deprecated the current released version. Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721986713971466)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de lanzar este modelo. Esto marcar\00E1 como en desuso la versi\00F3n publicada actual. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516085762573615)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de publier ce mod\00E8le, ceci rendra obsol\00E8te la version courant publi\00E9e. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522066137573770)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\30EA\30EA\30FC\30B9\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\73FE\5728\306E\30EA\30EA\30FC\30B9\6E08\30D0\30FC\30B8\30E7\30F3\304C\975E\63A8\5968\3068\3057\3066\30DE\30FC\30AF\3055\308C\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528022793574227)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a lan\00E7ar este modelo, isto marcar\00E1 a vers\00E3o atual lan\00E7ada como descontinuado. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532293973574341)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'de'
,p_message_text=>unistr('Sie sind dabei die Reservierung f\00FCr Schritte aufzuheben. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11225313312069738)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_text=>'You are about to release reservation on step(s). Do you want to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720119344971415)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de liberar la reserva en los pasos. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514237677573604)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de lib\00E9rer la r\00E9servation de la ou des \00E9tapes(s). Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520278908573769)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B9\30C6\30C3\30D7\3067\4E88\7D04\3092\30EA\30EA\30FC\30B9\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526257110574217)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a liberar a reserva na(s) etapa(s). Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529985258574339)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz wird zur\00FCckgesetzt. Bitte f\00FCgen sie einen Kommentar hinzu (optional) und best\00E4tigen sie.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5023975409141065)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_text=>'This will reset the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68717877430971362)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esto restablecer\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68511997635573582)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci r\00E9initialisera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517929773573732)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\30EA\30BB\30C3\30C8\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523955569574205)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto reiniciar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531008340574339)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'de'
,p_message_text=>unistr('Subflow wird neu gestartet. Bitte f\00FCgen sie einen Kommentar hinzu (optional) und best\00E4tigen sie.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7072975164227666)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_text=>'This will restart the subflow. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718931945971390)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>unistr('Esto reiniciar\00E1 el subflujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513086376573599)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci red\00E9marrera le sous-flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519057119573768)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30B5\30D6\30D5\30ED\30FC\304C\518D\8D77\52D5\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F\FF09\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525085658574212)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto reiniciar\00E1 o subfluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530035859574339)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz wird terminiert. Bitte f\00FCgen sie einen Kommentar hinzu (optional) und best\00E4tigen sie.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(5024181840145883)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_text=>'This will terminate the flow instance. Please add a comment (optional) and click confirm.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68717990692971367)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n terminar\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512068141573594)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci terminera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518012265573732)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\3001\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\7D42\4E86\3057\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524048541574206)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto encerrar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534368570574342)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz l\00F6schen')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34716303518466200)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_text=>'Delete Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722201229971472)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Suprimir instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516348241573620)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Supprimer une instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522339593573770)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\524A\9664')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528311700574228)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Eliminar inst\00E2ncia de fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533878868574342)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'de'
,p_message_text=>unistr('Es existieren %0, diesem Flow, zugeh\00F6rige Prozesse')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34704307318272181)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_text=>'There are %0 process instances associated to this flow.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721705262971466)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'es'
,p_message_text=>'Hay %0 instancias de proceso asociadas a este flujo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515802693573614)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe %0 instance(s) de processus associ\00E9e(s) \00E0 ce flux.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521814217573770)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30D5\30ED\30FC\306B\95A2\9023\4ED8\3051\3089\308C\305F\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C%0\500B\3042\308A\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527887681574225)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'pt-br'
,p_message_text=>unistr('H\00E1 %0 inst\00E2ncias de processo associadas a este fluxo.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531999741574341)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'de'
,p_message_text=>unistr('Bitte Verbindung ausw\00E4hlen')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385691008882345)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_text=>'Please select a connection'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719850318971409)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'es'
,p_message_text=>unistr('Seleccione una conexi\00F3n')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513979050573603)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('Veuillez s\00E9lectionner une connexion')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519978961573768)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\63A5\7D9A\3092\9078\629E\3057\3066\304F\3060\3055\3044')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525990924574216)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Por favor, selecione uma conex\00E3o')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531805925574340)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'de'
,p_message_text=>unistr('Bitte w\00E4hlen sie nur eine Verbindung')
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
 p_id=>wwv_flow_api.id(68719755258971409)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'es'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Seleccione solo una conexi\00F3n'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513861591573603)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'fr'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Veuillez ne s\00E9lectionner qu''une connexion'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519803897573768)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'ja'
,p_message_text=>unistr('\63A5\7D9A\30921\3064\306E\307F\9078\629E\3057\3066\304F\3060\3055\3044')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525837457574216)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Por favor, selecione apenas uma conex\00E3o\005Cn')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533182859574342)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'de'
,p_message_text=>'Modell "%0" Version %1 existiert bereits.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(16953295749988159)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_text=>'Model "%0" Version %1 already exists.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721053674971441)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'es'
,p_message_text=>unistr('El modelo "%0" versi\00F3n %1 ya existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515190207573609)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'fr'
,p_message_text=>unistr('Le mod\00E8le "%0" - Version %1 existe d\00E9j\00E0.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521178624573769)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB"%0"\30D0\30FC\30B8\30E7\30F3%1\306F\65E2\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527129785574222)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Modelo "%0 A vers\00E3o j\00E1 existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533009920574342)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'de'
,p_message_text=>'Version existiert bereits.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(14702944177906412)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_text=>'Version already exists.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720985787971435)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'es'
,p_message_text=>unistr('Esta versi\00F3n ya existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515097059573608)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'fr'
,p_message_text=>unistr('La version existe d\00E9j\00E0')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521007529573769)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D0\30FC\30B8\30E7\30F3\304C\65E2\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527061715574221)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'pt-br'
,p_message_text=>unistr('A vers\00E3o j\00E1 existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535586368574343)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'de'
,p_message_text=>unistr('\00DCberschreiben nur bei Entw\00FCrfen m\00F6glich.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(61364531151233202)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_text=>'Overwrite only possible for draft models.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723439057971513)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'es'
,p_message_text=>'Sobrescribir solo es posible para modelos provisionales.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517529574573627)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'fr'
,p_message_text=>unistr('L''\00E9crasement n''est possible que pour les mod\00E8les au statut draft.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523598869573771)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'ja'
,p_message_text=>unistr('\4E0A\66F8\304D\3067\304D\308B\306E\306F\30C9\30E9\30D5\30C8\30FB\30E2\30C7\30EB\306B\5BFE\3057\3066\306E\307F\3067\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529554737574234)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Substitua somente os modelos preliminares poss\00EDveis.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531736176574340)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'de'
,p_message_text=>'Wert muss ein Datum sein'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385297806875971)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_text=>'Value must be a date'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719606422971403)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'es'
,p_message_text=>'El valor debe ser una fecha'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513716685573603)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre une date')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519790968573768)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306F\65E5\4ED8\3067\3042\308B\5FC5\8981\304C\3042\308A\307E\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525774920574215)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'pt-br'
,p_message_text=>'O valor deve ser uma data'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531360139574339)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'de'
,p_message_text=>'Variablen-Name muss einen Wert haben'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384469808866136)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_text=>'Variable Name must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719299679971397)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El nombre de variable debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513326741573601)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le nom de la variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519353628573768)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\540D\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525386560574214)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O Nome da Vari\00E1vel deve ser informado')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531603518574340)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'de'
,p_message_text=>'Wert muss eine Zahl sein'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7385007498873734)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_text=>'Value must be a number'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719521020971403)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'es'
,p_message_text=>unistr('El valor debe ser un n\00FAmero')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513627164573602)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre un nombre')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519652515573768)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306F\6570\5024\3067\3042\308B\5FC5\8981\304C\3042\308A\307E\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525609375574215)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O valor deve ser um n\00FAmero')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531466314574340)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'de'
,p_message_text=>'Variablen-Typ muss einen Wert haben'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384642544868247)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_text=>'Variable Type must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719300826971397)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El tipo de variable debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513466903573601)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le type de variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519428101573768)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\30BF\30A4\30D7\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525495108574214)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O Tipo de Vari\00E1vel deve ser informado')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531530328574340)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'de'
,p_message_text=>'Wert muss einen Wert haben'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7384854796870876)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_text=>'Value must have a value'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719494139971403)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El valor debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513576716573602)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur ne peut \00EAtre vide')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519501463573768)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525589507574214)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>'O Valor deve ser informado'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533798659574342)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'de'
,p_message_text=>'Instanz erstellt.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(29609850900170775)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_text=>'Instance created.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721667827971460)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'es'
,p_message_text=>'Instancia creada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515775759573613)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance cr\00E9\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521715303573770)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30A4\30F3\30B9\30BF\30F3\30B9\304C\4F5C\6210\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527788654574225)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia criada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530529274574339)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz gel\00F6scht')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005845949232185)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_text=>'Flow instance deleted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718444941971378)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo suprimida.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512562352573594)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518514315573732)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\524A\9664\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524524478574210)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia de fluxo eliminada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530373645574339)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz zur\00FCckgesetzt')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005460531221619)
,p_name=>'APP_INSTANCE_RESET'
,p_message_text=>'Flow instance reset.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718277430971372)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'es'
,p_message_text=>'Restablecimiento de instancia de flujo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512329738573594)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux r\00E9initialis\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518381951573732)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\30EA\30BB\30C3\30C8\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524395485574209)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Reiniciar a inst\00E2ncia do fluxo.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530245983574339)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'de'
,p_message_text=>'Flow-Instanz gestartet'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005265750200100)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_text=>'Flow instance started.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718174514971372)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo iniciada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512219915573594)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux d\00E9marr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518271687573732)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\8D77\52D5\3057\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524216438574207)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'pt-br'
,p_message_text=>'Exemplo de fluxo iniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530434400574339)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'de'
,p_message_text=>'Flow-Instanz terminiert'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7005690133229935)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_text=>'Flow instance terminated.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718305460971372)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo terminada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512414676573594)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux termin\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518401974573732)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\7D42\4E86\3057\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524423253574209)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia de Fluxo encerrada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532068430574341)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'de'
,p_message_text=>'Modell kopiert'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(8225061315538358)
,p_name=>'APP_MODEL_COPIED'
,p_message_text=>'Model copied.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719962447971415)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'es'
,p_message_text=>'Modelo copiado.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514073480573604)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'fr'
,p_message_text=>unistr('Mod\00E8le copi\00E9.')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520022791573769)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB\304C\30B3\30D4\30FC\3055\308C\307E\3057\305F\3002')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526088534574216)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'pt-br'
,p_message_text=>'Modelo copiado.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533619251574342)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'de'
,p_message_text=>'Modell importiert.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(28300791809214356)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_text=>'Model imported.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721513947971459)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'es'
,p_message_text=>'Modelo importado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515632336573613)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Mod\00E8le import\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521646962573770)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB\304C\30A4\30F3\30DD\30FC\30C8\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527691261574225)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'pt-br'
,p_message_text=>'Modelo importado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534529771574343)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'de'
,p_message_text=>unistr('Neue Version hinzugef\00FCgt.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34723270983639953)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_text=>'New version added.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722434773971478)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'es'
,p_message_text=>unistr('Nueva versi\00F3n agregada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516508487573620)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Nouvelle version ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522537609573770)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'ja'
,p_message_text=>unistr('\65B0\3057\3044\30D0\30FC\30B8\30E7\30F3\304C\8FFD\52A0\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528549142574229)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Nova vers\00E3o adicionada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533598363574342)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'de'
,p_message_text=>unistr('Wenn aktuell laufende Instanzen zu diesem Modell existieren k\00F6nnen dadurch Fehler auftreten. M\00F6chten sie fortfahren?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(28202305228139790)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_text=>'If there are running instances associated to the existing model, then these might cause errors. Are you sure to continue?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721427631971453)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'es'
,p_message_text=>unistr('Si hay instancias en ejecuci\00F3n asociadas al modelo existente, pueden provocar errores. \00BFSeguro que desea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515510212573612)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'fr'
,p_message_text=>unistr('Si des instances en cours d''ex\00E9cution sont associ\00E9es au mod\00E8le existant, ceci peut provoquer des erreurs. Etes-vous s\00FBr de vouloir continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521516037573770)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E2\5B58\306E\30E2\30C7\30EB\306B\95A2\9023\4ED8\3051\3089\308C\305F\5B9F\884C\4E2D\306E\30A4\30F3\30B9\30BF\30F3\30B9\304C\3042\308B\5834\5408\3001\30A8\30E9\30FC\304C\767A\751F\3059\308B\53EF\80FD\6027\304C\3042\308A\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527512965574224)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Se houver inst\00E2ncias em execu\00E7\00E3o associadas ao modelo existente, elas poder\00E3o causar erros. Voc\00EA tem certeza que quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530701289574339)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'de'
,p_message_text=>unistr('Prozessvariable hinzugef\00FCgt')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049063211512400)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_text=>'Process variable added.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718623197971384)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso agregada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512756470573596)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518713925573768)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\8FFD\52A0\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524731519574210)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo adicionada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68531263457574339)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'de'
,p_message_text=>unistr('Prozessvariable gel\00F6scht.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7371506201807240)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_text=>'Process variable deleted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68719181200971391)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso suprimida.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68513234334573599)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68519237483573768)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\524A\9664\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68525238243574213)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo exclu\00EDda.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530825932574339)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'de'
,p_message_text=>'Prozessvariable gespeichert'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7049459946516827)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_text=>'Process variable saved.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718757594971384)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso guardada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512801423573596)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus enregistr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518858164573768)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\4FDD\5B58\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524811732574211)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo salva.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535865739574343)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'de'
,p_message_text=>unistr('Neu-ausl\00F6sen')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(73507335747013782)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_text=>'Reschedule'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723710764971516)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'es'
,p_message_text=>'Reprogramar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517853111573628)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'fr'
,p_message_text=>'Reprogrammer'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523840581573771)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'ja'
,p_message_text=>unistr('\518D\30B9\30B1\30B8\30E5\30FC\30EB')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529824051574235)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'pt-br'
,p_message_text=>'Reprogramar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534128496574342)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'de'
,p_message_text=>unistr('Flow-Instanz zur\00FCcksetzen')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715720510433885)
,p_name=>'APP_RESET_INSTANCE'
,p_message_text=>'Reset Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722025513971472)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Restablecer instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516189307573616)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('R\00E9initialiser l''instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522158260573770)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\30EA\30BB\30C3\30C8')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528106176574227)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Reiniciar a Inst\00E2ncia do Fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530924419574339)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'de'
,p_message_text=>'Neustart'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7072717610226144)
,p_name=>'APP_RESTART_STEP'
,p_message_text=>'Re-start'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718836124971384)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>'Reiniciar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512963222573598)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Red\00E9marrer')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518987127573768)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\518D\8D77\52D5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524916386574211)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Reiniciar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68530652341574339)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'de'
,p_message_text=>'Subflow neu gestartet'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7020498147014290)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_text=>'Subflow restarted.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68718531043971378)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'es'
,p_message_text=>'Subflujo reiniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68512681473573595)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Sous-flux red\00E9marr\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68518613860573768)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30D6\30D5\30ED\30FC\304C\518D\8D77\52D5\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68524698284574210)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'pt-br'
,p_message_text=>'Subfluxo reiniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535736394574343)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'de'
,p_message_text=>'In/Out Mapping'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(61820488838157963)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_text=>'In/Out Mapping'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723616551971516)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'es'
,p_message_text=>unistr('Asignaci\00F3n de entrada/salida')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517749454573628)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'fr'
,p_message_text=>unistr('Mappage entr\00E9e/sortie')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523758445573771)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'ja'
,p_message_text=>unistr('\5165\51FA\529B\30DE\30C3\30D4\30F3\30B0')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529765842574235)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Mapeamento de Entrada/Sa\00EDda')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535612109574343)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'de'
,p_message_text=>unistr('Variablenausdr\00FCcke')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(61820286299155230)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_text=>'Variable Expressions'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723538722971516)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'es'
,p_message_text=>'Expresiones de variables'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517627585573628)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'fr'
,p_message_text=>'Expressions de variables'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523620679573771)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\5F0F')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529618313574234)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Express\00F5es de Vari\00E1vel')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68534278995574342)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'de'
,p_message_text=>'Flow-Instanz terminieren'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(34715995579436957)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_text=>'Terminate Flow Instance'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68722132068971472)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Terminar instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68516213813573619)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Terminer l''instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68522242240573770)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\7D42\4E86')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68528224548574228)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Terminar a inst\00E2ncia de fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532750176574341)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'de'
,p_message_text=>'%0 - Version %1'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(14002829627275379)
,p_name=>'APP_TITLE_MODEL'
,p_message_text=>'%0 - Version %1'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720688669971429)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('%0 - Versi\00F3n %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514711690573606)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'fr'
,p_message_text=>'%0 - Version %1'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520780818573769)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('%0 - \30D0\30FC\30B8\30E7\30F3%1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526782373574220)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('%0 - Vers\00E3o %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532673589574341)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'de'
,p_message_text=>'Neues Modell'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(14002221742257151)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_text=>'New Model'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720582879971429)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'es'
,p_message_text=>'Nuevo modelo'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514623807573606)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Nouveau Mod\00E8le')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520644258573769)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\65B0\898F\30E2\30C7\30EB')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526620458574220)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>'Novo modelo'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532843818574342)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'de'
,p_message_text=>'Schritt neustarten'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(14016328404425844)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_text=>'Re-start Step'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720768961971435)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>'Volver a iniciar paso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514877468573608)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Red\00E9marrer l''\00E9tape')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520863696573769)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B9\30C6\30C3\30D7\306E\518D\8D77\52D5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526863828574220)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Reiniciar Etapa'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(3524783067400924)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'We have identified that the application version, data model and code do not match:',
'<ul>',
'<li>application version: %0</li>',
'<li>data model version: %1</li>',
'<li>code version : %2</li>',
'</ul>',
'Please contact your administrator to avoid any problems.'))
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532517789574341)
,p_name=>'APP_VIEW'
,p_message_language=>'de'
,p_message_text=>'Ansicht'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(13203402380103446)
,p_name=>'APP_VIEW'
,p_message_text=>'View'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720455235971429)
,p_name=>'APP_VIEW'
,p_message_language=>'es'
,p_message_text=>'Ver'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514508939573606)
,p_name=>'APP_VIEW'
,p_message_language=>'fr'
,p_message_text=>'Voir'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520567527573769)
,p_name=>'APP_VIEW'
,p_message_language=>'ja'
,p_message_text=>unistr('\8868\793A')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526584070574219)
,p_name=>'APP_VIEW'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532323043574341)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'de'
,p_message_text=>'Flow-Viewer'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11239873943364108)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_text=>'Flow Viewer'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720249806971421)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'es'
,p_message_text=>'Visor de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514394365573605)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520345042573769)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30D3\30E5\30FC\30A2\30FC')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526347696574218)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizador de fluxo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68532421991574341)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'de'
,p_message_text=>'Flow-Viewer (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(11240035334366277)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_text=>'Flow Viewer (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68720344020971422)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'es'
,p_message_text=>'Visor de flujo (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68514473789573605)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68520480126573769)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30D3\30E5\30FC\30A2(%0)')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68526446184574219)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizador de fluxo (%0)'
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535391491574343)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'de'
,p_message_text=>'Zyklus (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36510629773154405)
,p_name=>'BPMN:TIMECYCLE'
,p_message_text=>'Cycle (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723208289971501)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'es'
,p_message_text=>'Ciclo (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517300001573625)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'fr'
,p_message_text=>'Cycle (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523369160573771)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30A4\30AF\30EB(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529331984574233)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'pt-br'
,p_message_text=>'Ciclo (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535132985574343)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'de'
,p_message_text=>'Datum (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36510235534150779)
,p_name=>'BPMN:TIMEDATE'
,p_message_text=>'Date (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723087924971494)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'es'
,p_message_text=>'Fecha (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517162590573625)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'fr'
,p_message_text=>'Date (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523130417573771)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E5\4ED8(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529142401574232)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'pt-br'
,p_message_text=>'Data (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68535210591574343)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'de'
,p_message_text=>'Dauer (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(36510489900152295)
,p_name=>'BPMN:TIMEDURATION'
,p_message_text=>'Duration (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68723139601971501)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'es'
,p_message_text=>unistr('Duraci\00F3n (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68517245602573625)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'fr'
,p_message_text=>unistr('Dur\00E9e (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68523248072573771)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'ja'
,p_message_text=>unistr('\671F\9593(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68529268509574233)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Dura\00E7\00E3o (ISO 8601)')
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533467611574342)
,p_name=>'DGRM_UK'
,p_message_language=>'de'
,p_message_text=>'Ein Flow mit dem selben Namen und Status existiert bereits.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(26017638645989579)
,p_name=>'DGRM_UK'
,p_message_text=>'A flow already exists with the same name and status.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721300435971453)
,p_name=>'DGRM_UK'
,p_message_language=>'es'
,p_message_text=>'Ya existe un flujo con el mismo nombre y estado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515447792573612)
,p_name=>'DGRM_UK'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux existe d\00E9j\00E0 avec le m\00EAme nom et le m\00EAme statut.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521483613573770)
,p_name=>'DGRM_UK'
,p_message_language=>'ja'
,p_message_text=>unistr('\540C\3058\540D\524D\304A\3088\3073\30B9\30C6\30FC\30BF\30B9\306E\30D5\30ED\30FC\304C\3059\3067\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527480725574224)
,p_name=>'DGRM_UK'
,p_message_language=>'pt-br'
,p_message_text=>unistr('J\00E1 existe um fluxo com o mesmo nome e status.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533370449574342)
,p_name=>'DGRM_UK2'
,p_message_language=>'de'
,p_message_text=>unistr('Ein Flow mit diesen Namen und einem Released-Status existiert bereits. \00C4ndern sie den aktuellen Status zu Veraltet oder Archiviert und starten sie den Import erneut.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(24219258023169431)
,p_name=>'DGRM_UK2'
,p_message_text=>'A flow with this name and having a status of ''released'' already exists. Change the existing flow status to deprecated or archived and re-import.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721261920971453)
,p_name=>'DGRM_UK2'
,p_message_language=>'es'
,p_message_text=>'Ya existe un flujo con este nombre y con el estado ''liberado''. Cambie el estado del flujo existente a en desuso o archivado y vuelva a importarlo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515358932573612)
,p_name=>'DGRM_UK2'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux portant ce nom et ayant le statut "released" existe d\00E9j\00E0.  Changez le statut du flux existant en deprecated ou archived et r\00E9importez-le.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521375864573770)
,p_name=>'DGRM_UK2'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\540D\524D\3067\30B9\30C6\30FC\30BF\30B9\304C ''released''\300C\30EA\30EA\30FC\30B9\6E08\300D\306E\30D5\30ED\30FC\306F\3059\3067\306B\5B58\5728\3057\307E\3059\3002\65E2\5B58\306E\30D5\30ED\30FC\30FB\30B9\30C6\30FC\30BF\30B9\3092\975E\63A8\5968\307E\305F\306F\30A2\30FC\30AB\30A4\30D6\6E08\306B\5909\66F4\3057\3001\518D\30A4\30F3\30DD\30FC\30C8\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527336697574223)
,p_name=>'DGRM_UK2'
,p_message_language=>'pt-br'
,p_message_text=>unistr('J\00E1 existe um fluxo com este nome e com um status de ''lan\00E7ado''. Alterar o status do fluxo existente para descontinuado ou arquivado e reimportado.')
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68533219664574342)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'de'
,p_message_text=>unistr('F\00FCr diesen Flow existieren bestehende Prozess-Instanzen. Ben\00FCtzen sie die Kaskadierungs-Option um aktuelle Instanzen to entfernen.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(24202863069473923)
,p_name=>'PRCS_DGRM_FK'
,p_message_text=>'Process instances using this flow exist. Use cascade option to remove flow and process instances.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68721174146971447)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'es'
,p_message_text=>unistr('Existen instancias de proceso que utilizan este flujo. Utilice la opci\00F3n en cascada para eliminar instancias de flujo y proceso.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68515274288573611)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'fr'
,p_message_text=>'Des instances de processus utilisant ce flux existent. Utilisez l''option cascade pour supprimer le flux et les instances de processus.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68521209503573769)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30D5\30ED\30FC\3092\4F7F\7528\3059\308B\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\5B58\5728\3057\307E\3059\3002\30D5\30ED\30FC\304A\3088\3073\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\3092\524A\9664\3059\308B\306B\306F\30AB\30B9\30B1\30FC\30C9\30AA\30D7\30B7\30E7\30F3\3092\4F7F\7528\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(68527270946574223)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Existem inst\00E2ncias de processo que utilizam este fluxo. Use a op\00E7\00E3o em cascata para remover inst\00E2ncias de fluxo e de processo.')
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/

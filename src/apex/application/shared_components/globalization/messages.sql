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
 p_id=>wwv_flow_api.id(7137708452837685)
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
 p_id=>wwv_flow_api.id(7207114497044752)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'es'
,p_message_text=>unistr('P\00E1gina APEX')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188245218043114)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'fr'
,p_message_text=>'Page APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181969886042627)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'it'
,p_message_text=>'Pagina APEX'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175633621042166)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'ja'
,p_message_text=>unistr('APEX\30DA\30FC\30B8')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311947823288843)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'ko'
,p_message_text=>unistr('APEX \D398\C774\C9C0')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213486609045493)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('P\00E1gina APEX')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305408402254996)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('APEX \9875')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194547895043714)
,p_name=>'APEX:APEXPAGE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('APEX \9801\9762')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137896381837685)
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
 p_id=>wwv_flow_api.id(7207270469044752)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'es'
,p_message_text=>'Ejecutar PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188300095043114)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'fr'
,p_message_text=>unistr('Ex\00E9cuter PL/SQL')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182054828042627)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'it'
,p_message_text=>'Esegui PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175709288042166)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'ja'
,p_message_text=>unistr('PL/SQL\306E\5B9F\884C')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312049155288843)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'ko'
,p_message_text=>unistr('PL/SQL \C2E4\D589')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213501646045493)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'pt-br'
,p_message_text=>'Executar PL/SQL'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305545049254996)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6267\884C PL/SQL')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194609108043714)
,p_name=>'APEX:EXECUTEPLSQL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\57F7\884C PL/SQL')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137921240837686)
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
 p_id=>wwv_flow_api.id(7207363120044752)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'es'
,p_message_text=>'Ciclo (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188467912043114)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'fr'
,p_message_text=>'Cycle (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182147912042627)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'it'
,p_message_text=>'Ciclo (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175805851042166)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30A4\30AF\30EB(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312101068288843)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'ko'
,p_message_text=>unistr('\C8FC\AE30(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213689044045493)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'pt-br'
,p_message_text=>'Ciclo (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305601090254996)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5468\671F (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194778776043714)
,p_name=>'APEX:ORACLECYCLE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9031\671F (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138555633837686)
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
 p_id=>wwv_flow_api.id(7207912435044752)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'es'
,p_message_text=>'Fecha (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189017689043114)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'fr'
,p_message_text=>'Date (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182711295042627)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'it'
,p_message_text=>'Data (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176439812042166)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E5\4ED8(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312738748288843)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'ko'
,p_message_text=>unistr('\C77C\C790(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214232767045493)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'pt-br'
,p_message_text=>'Data (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306288954254996)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\65E5\671F (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195363982043715)
,p_name=>'APEX:ORACLEDATE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\65E5\671F (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138175527837686)
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
 p_id=>wwv_flow_api.id(7207575810044752)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'es'
,p_message_text=>unistr('Duraci\00F3n (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188616782043114)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'fr'
,p_message_text=>unistr('Dur\00E9e (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182358910042627)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'it'
,p_message_text=>'Durata (Oracle)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176048579042166)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'ja'
,p_message_text=>unistr('\671F\9593(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312387247288843)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'ko'
,p_message_text=>unistr('\AE30\AC04(Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213842614045493)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Dura\00E7\00E3o (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305860273254996)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6301\7EED\65F6\95F4 (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194928897043714)
,p_name=>'APEX:ORACLEDURATION'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6301\7E8C\6642\9593 (Oracle)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138014156837686)
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
 p_id=>wwv_flow_api.id(7207450434044752)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'es'
,p_message_text=>unistr('Enviar correo electr\00F3nico')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188574465043114)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'fr'
,p_message_text=>'Envoyer un courriel'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182200992042627)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'it'
,p_message_text=>'Invia e-mail'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175938442042166)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'ja'
,p_message_text=>unistr('\96FB\5B50\30E1\30FC\30EB\306E\9001\4FE1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312267700288843)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'ko'
,p_message_text=>unistr('\C804\C790\BA54\C77C \C804\C1A1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213714686045493)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'pt-br'
,p_message_text=>'Enviar e-mail'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305763485254996)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\53D1\9001\7535\5B50\90AE\4EF6')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194891834043714)
,p_name=>'APEX:SENDMAIL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\50B3\9001\96FB\5B50\90F5\4EF6')
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
 p_id=>wwv_flow_api.id(7132868621837678)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'de'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Es wurde ein APEX-Upgrade ermittelt:',
'<ul>',
unistr('<li>ausgef\00FChrte Version: %0.%1</li>'),
'<li>gespeicherte Version: %2.%3</li>',
'</ul>',
unistr('Sie m\00FCssen die Dokumentation <a href="#" >hier</a> befolgen, um dies aufzul\00F6sen.')))
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
 p_id=>wwv_flow_api.id(7202273112044750)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'es'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Se ha detectado una actualizaci\00F3n de APEX:'),
'<ul>',
'<li>running version: %0.%1</li>',
unistr('<li>versi\00F3n almacenada: %2.%3</li>'),
'</ul>',
unistr('Debe seguir la documentaci\00F3n <a href="#" >aqu\00ED</a> para resolverla.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183334828043111)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'fr'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Une mise \00E0 niveau APEX a \00E9t\00E9 d\00E9tect\00E9e :'),
'<ul>',
unistr('<li>ex\00E9cution de la version : %0.%1</li>'),
unistr('<li>version stock\00E9e : %2.%3</li>'),
'</ul>',
unistr('Vous devez suivre la documentation <a href="#" >ici</a> pour la r\00E9soudre.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177019260042625)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'it'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\00C8 stato rilevato un aggiornamento APEX:'),
'<ul>',
'<li>versione di esecuzione: %0.%1</li>',
'<li>versione memorizzata: %2.%3</li>',
'</ul>',
unistr('Per risolvere il problema, \00E8 necessario seguire la documentazione <a href="#" >qui</a>.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7170712270042163)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'ja'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('APEX\30A2\30C3\30D7\30B0\30EC\30FC\30C9\304C\691C\51FA\3055\308C\307E\3057\305F:'),
'<ul>',
unistr('<li>\5B9F\884C\4E2D\30D0\30FC\30B8\30E7\30F3: %0.%1</li>'),
unistr('<li>\683C\7D0D\3055\308C\305F\30D0\30FC\30B8\30E7\30F3: %2.%3</li>'),
'</ul>',
unistr('\89E3\6C7A\3059\308B\306B\306F\3001\30C9\30AD\30E5\30E1\30F3\30C8<a href="#" >\3053\3053</a>\306B\5F93\3046\5FC5\8981\304C\3042\308A\307E\3059\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307019072288841)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'ko'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('APEX \C5C5\ADF8\B808\C774\B4DC\AC00 \AC10\C9C0\B418\C5C8\C2B5\B2C8\B2E4.'),
'<ul>',
unistr('<li>\C2E4\D589 \C911\C778 \BC84\C804: %0.%1</li>'),
unistr('<li>\C800\C7A5\B41C \BC84\C804: %2.%3</li>'),
'</ul>',
unistr('\D574\ACB0\D558\B824\BA74 \C124\BA85\C11C <a href="#" >\C5EC\AE30</a>\B97C \B530\B77C\C57C \D569\B2C8\B2E4.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208599849045490)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'pt-br'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Um upgrade do APEX foi detectado:',
'<ul>',
unistr('<li>vers\00E3o em execu\00E7\00E3o: %0.%1</li>'),
unistr('<li>vers\00E3o armazenada: %2.%3</li>'),
'</ul>',
unistr('\00C9 necess\00E1rio seguir a documenta\00E7\00E3o <a href="#" >aqui</a> para resolv\00EA-la.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300502042254992)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'zh-cn'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\68C0\6D4B\5230 APEX \5347\7EA7\FF1A '),
'<ul>',
unistr(' <li> \8FD0\884C\7248\672C\FF1A%0.%1</li>'),
unistr(' <li> \5B58\50A8\7684\7248\672C\FF1A%2.%3</li>'),
' </ul>',
unistr(' \60A8\5FC5\987B\9075\5FAA\6587\6863 <a href="#" > \6B64\5904 </a> \6765\89E3\51B3\6B64\95EE\9898\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189604631043712)
,p_name=>'APP_APEX_UPGRADE_DETECTED'
,p_message_language=>'zh-tw'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\5075\6E2C\5230 APEX \5347\7D1A\FF1A '),
'<ul>',
unistr(' <li> \57F7\884C\4E2D\7248\672C\FF1A%0.%1</li>'),
unistr(' <li> \5132\5B58\7684\7248\672C\FF1A%2.%3</li>'),
' </ul>',
unistr(' \60A8\5FC5\9808\4F9D\7167 <a href="#" > \6B64\8655 </a> \52A0\4EE5\89E3\6C7A\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137508069837685)
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
 p_id=>wwv_flow_api.id(7206933136044752)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'es'
,p_message_text=>'Completo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188049556043113)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Compl\00E9ter')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181785322042627)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'it'
,p_message_text=>'Completato'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175401299042166)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\5B8C\4E86')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311756524288843)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'ko'
,p_message_text=>unistr('\C644\B8CC')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213227968045492)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Completo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305217458254996)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5B8C\6210')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194389139043714)
,p_name=>'APP_COMPLETE_STEP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5B8C\6210')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135286686837683)
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
 p_id=>wwv_flow_api.id(7204673685044751)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Va a archivar este modelo. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185761642043112)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point d''archiver ce mod\00E8le. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179415551042626)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'it'
,p_message_text=>'Si sta per archiviare questo modello. Continuare?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173163107042164)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\30A2\30FC\30AB\30A4\30D6\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309495788288842)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \BAA8\B378\C744 \C544\CE74\C774\BE0C\D558\B824\ACE0 \D569\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210959548045492)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a arquivar este modelo. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302931261254994)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\60A8\5373\5C06\5B58\6863\6B64\6A21\578B\3002\662F\5426\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192008454043713)
,p_name=>'APP_CONFIRM_ARCHIVE_MODEL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\60A8\5373\5C07\5C01\5B58\6B64\6A21\578B\3002\60A8\662F\5426\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133268390837679)
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
 p_id=>wwv_flow_api.id(7202622706044750)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n suprimir\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183725185043112)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177418937042625)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'it'
,p_message_text=>unistr('Questa operazione eliminer\00E0 l''istanza del flusso. Aggiungere un commento (facoltativo) e fare clic su Conferma.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171121339042163)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\524A\9664\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307423274288841)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C0AD\C81C\B429\B2C8\B2E4. \C124\BA85\C744 \CD94\AC00\D558\ACE0(\C120\D0DD\C0AC\D56D) \D655\C778\C744 \B204\B974\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208941045045491)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto eliminar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300975772254993)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FD9\5C06\5220\9664\6D41\7A0B\5B9E\4F8B\3002\8BF7\6DFB\52A0\5907\6CE8\FF08\53EF\9009\FF09\FF0C\7136\540E\5355\51FB\201C\786E\8BA4\201D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190088338043712)
,p_name=>'APP_CONFIRM_DELETE_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9019\6703\522A\9664\6D41\7A0B\5BE6\4F8B\3002\8ACB\65B0\589E\8A3B\89E3 (\9078\64C7\6027)\FF0C\7136\5F8C\6309\4E00\4E0B\78BA\8A8D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134255773837681)
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
 p_id=>wwv_flow_api.id(7203634023044750)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n suprimir\00E1 la variable de proceso. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184739684043112)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'fr'
,p_message_text=>'Ceci supprimera la variable de processus. Voulez-vous continuer?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178494186042625)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'it'
,p_message_text=>unistr('La variabile di processo verr\00E0 eliminata. Aggiungere un commento (facoltativo) e fare clic su Conferma.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172147137042164)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\3001\30D7\30ED\30BB\30B9\5909\6570\304C\524A\9664\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308400474288841)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D504\B85C\C138\C2A4 \BCC0\C218\AC00 \C0AD\C81C\B429\B2C8\B2E4. \C124\BA85\C744 \CD94\AC00\D558\ACE0(\C120\D0DD\C0AC\D56D) \D655\C778\C744 \B204\B974\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209923859045491)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto eliminar\00E1 a vari\00E1vel de processo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301943226254994)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FD9\5C06\5220\9664\8FDB\7A0B\53D8\91CF\3002\8BF7\6DFB\52A0\5907\6CE8\FF08\53EF\9009\FF09\FF0C\7136\540E\5355\51FB\201C\786E\8BA4\201D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191003596043713)
,p_name=>'APP_CONFIRM_DELETE_PROCESS_VARIABLE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9019\6703\522A\9664\8655\7406\8B8A\6578\3002\8ACB\65B0\589E\8A3B\89E3 (\9078\64C7\6027)\FF0C\7136\5F8C\6309\4E00\4E0B\78BA\8A8D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137022989837685)
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
 p_id=>wwv_flow_api.id(7206498733044751)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de marcar este modelo como en desuso. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187522440043113)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de rendre obsol\00E8te ce mod\00E8le. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181217328042627)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'it'
,p_message_text=>unistr('Si sta per contrassegnare come non pi\00F9 valido questo modello. Continuare?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174974750042166)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\975E\63A8\5968\3068\3057\3066\30DE\30FC\30AF\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311274847288843)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \BAA8\B378\C744 \B354 \C774\C0C1 \C0AC\C6A9\B418\C9C0 \C54A\B294 \AC83\C73C\B85C \D45C\C2DC\D558\B824\ACE0 \D569\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212776063045492)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a marcar este modelo como descontinuado. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304779820254995)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\60A8\5373\5C06\6807\8BB0\4E3A\5DF2\5F03\7528\6B64\6A21\578B\3002\662F\5426\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193873122043714)
,p_name=>'APP_CONFIRM_DEPRECATE_MODEL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\60A8\5373\5C07\5C07\6B64\6A21\578B\6A19\793A\70BA\5DF2\4E0D\518D\4F7F\7528\3002\60A8\662F\5426\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136094262837684)
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
 p_id=>wwv_flow_api.id(7205450429044751)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'es'
,p_message_text=>unistr('Va a modificar un diagrama de un modelo liberado. Esto podr\00EDa interrumpir las instancias en ejecuci\00F3n de ese modelo. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186582700043113)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de modifier un diagramme d''un mod\00E8le au statut released. Cela pourrait \00E9ventuellement provoquer des erreurs sur les instances en cours d''ex\00E9cution pour ce mod\00E8le. Voulez-vous continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180284133042626)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'it'
,p_message_text=>unistr('Si sta per modificare un diagramma di un modello rilasciato. Ci\00F2 potrebbe interrompere l''esecuzione di istanze di quel modello. Continuare?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173935700042165)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'ja'
,p_message_text=>unistr('\30EA\30EA\30FC\30B9\3055\308C\305F\30E2\30C7\30EB\306E\56F3\3092\4FEE\6B63\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\3053\308C\306B\3088\308A\3001\305D\306E\30E2\30C7\30EB\306E\5B9F\884C\4E2D\306E\30A4\30F3\30B9\30BF\30F3\30B9\304C\58CA\308C\308B\53EF\80FD\6027\304C\3042\308A\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310262046288842)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'ko'
,p_message_text=>unistr('\B9B4\B9AC\C988\B41C \BAA8\B378\C758 \B2E4\C774\C5B4\ADF8\B7A8\C744 \C218\C815\D558\B824\ACE0 \D569\B2C8\B2E4. \C774 \ACBD\C6B0 \D574\B2F9 \BAA8\B378\C758 \C2E4\D589 \C911\C778 \C778\C2A4\D134\C2A4\AC00 \C190\C0C1\B420 \C218 \C788\C2B5\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211736511045492)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a modificar um diagrama de um modelo lan\00E7ado. Isso poderia possivelmente quebrar inst\00E2ncias de execu\00E7\00E3o desse modelo. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303790919254995)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\60A8\5C06\8981\4FEE\6539\5DF2\53D1\5E03\6A21\578B\7684\56FE\8868\3002\8FD9\53EF\80FD\4F1A\7834\574F\8BE5\6A21\578B\7684\8FD0\884C\5B9E\4F8B\3002\662F\5426\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192852526043714)
,p_name=>'APP_CONFIRM_EDIT_RELEASE_DIAGRAM'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\60A8\5373\5C07\4FEE\6539\5DF2\6838\767C\6A21\578B\7684\5716\8868\3002\9019\53EF\80FD\6703\7834\58DE\8A72\6A21\578B\7684\57F7\884C\5BE6\4F8B\3002\60A8\662F\5426\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137112591837685)
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
 p_id=>wwv_flow_api.id(7206594680044751)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de lanzar este modelo. Esto marcar\00E1 como en desuso la versi\00F3n publicada actual. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187652121043113)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de publier ce mod\00E8le, ceci rendra obsol\00E8te la version courant publi\00E9e. Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181372937042627)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'it'
,p_message_text=>unistr('Si sta per rilasciare questo modello. Verr\00E0 contrassegnata come non pi\00F9 valida la versione rilasciata corrente. Continuare?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175092250042166)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30E2\30C7\30EB\3092\30EA\30EA\30FC\30B9\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\73FE\5728\306E\30EA\30EA\30FC\30B9\6E08\30D0\30FC\30B8\30E7\30F3\304C\975E\63A8\5968\3068\3057\3066\30DE\30FC\30AF\3055\308C\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311339586288843)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \BAA8\B378\C744 \B9B4\B9AC\C2A4\D558\B824\ACE0 \D569\B2C8\B2E4. \ADF8\B7EC\BA74 \D604\C7AC \B9B4\B9AC\C2A4\B41C \BC84\C804\C774 \B354 \C774\C0C1 \C0AC\C6A9\B418\C9C0 \C54A\B294 \AC83\C73C\B85C \D45C\C2DC\B429\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212878299045492)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a lan\00E7ar este modelo, isto marcar\00E1 a vers\00E3o atual lan\00E7ada como descontinuado. Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304834798254995)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\60A8\5373\5C06\53D1\5E03\6B64\6A21\578B\FF0C\8FD9\4F1A\5C06\5F53\524D\53D1\5E03\7684\7248\672C\6807\8BB0\4E3A\5DF2\8FC7\65F6\3002\662F\5426\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193957602043714)
,p_name=>'APP_CONFIRM_RELEASE_MODEL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\60A8\5373\5C07\767C\884C\6B64\6A21\578B\FF0C\9019\5C07\6703\6A19\793A\70BA\5DF2\68C4\7528\76EE\524D\7684\767C\884C\7248\672C\3002\60A8\662F\5426\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135358544837683)
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
 p_id=>wwv_flow_api.id(7204738796044751)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'es'
,p_message_text=>unistr('Est\00E1 a punto de liberar la reserva en los pasos. \00BFDesea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185880647043113)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Vous \00EAtes sur le point de lib\00E9rer la r\00E9servation de la ou des \00E9tapes(s). Voulez-vous continuer?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179566432042626)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'it'
,p_message_text=>'Si sta per rilasciare la prenotazione per i passi. Continuare?'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173260269042164)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B9\30C6\30C3\30D7\3067\4E88\7D04\3092\30EA\30EA\30FC\30B9\3057\3088\3046\3068\3057\3066\3044\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309524808288842)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'ko'
,p_message_text=>unistr('\B2E8\ACC4\C5D0\C11C \C608\C57D\C744 \B9B4\B9AC\C2A4\D558\B824\ACE0 \D569\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211048763045492)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Voc\00EA est\00E1 prestes a liberar a reserva na(s) etapa(s). Voc\00EA quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303050809254994)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\60A8\5C06\5728\6B65\9AA4\4E2D\91CA\653E\4FDD\7559\3002\662F\5426\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192142419043713)
,p_name=>'APP_CONFIRM_RELEASE_STEP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\60A8\5373\5C07\6838\767C\6B65\9A5F\7684\9810\7559\3002\60A8\662F\5426\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133057773837679)
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
 p_id=>wwv_flow_api.id(7202477406044750)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esto restablecer\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183541163043111)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci r\00E9initialisera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177214668042625)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'it'
,p_message_text=>unistr('Questa operazione reimposter\00E0 l''istanza del flusso. Aggiungere un commento (facoltativo) e fare clic su Conferma.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7170901966042163)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\30EA\30BB\30C3\30C8\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307287004288841)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\ADF8\B7EC\BA74 \D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C7AC\C124\C815\B429\B2C8\B2E4. \C124\BA85\C744 \CD94\AC00\D558\ACE0(\C120\D0DD\C0AC\D56D) \D655\C778\C744 \B204\B974\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208779934045491)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto reiniciar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300789027254993)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FD9\5C06\91CD\7F6E\6D41\7A0B\5B9E\4F8B\3002\8BF7\6DFB\52A0\5907\6CE8\FF08\53EF\9009\FF09\FF0C\7136\540E\5355\51FB\201C\786E\8BA4\201D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189828670043712)
,p_name=>'APP_CONFIRM_RESET_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9019\6703\91CD\8A2D\6D41\7A0B\5BE6\4F8B\3002\8ACB\65B0\589E\8A3B\89E3 (\9078\64C7\6027)\FF0C\7136\5F8C\6309\4E00\4E0B\78BA\8A8D\3002')
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
 p_id=>wwv_flow_api.id(7134126038837681)
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
 p_id=>wwv_flow_api.id(7203562339044750)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>unistr('Esto reiniciar\00E1 el subflujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184613893043112)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Ceci red\00E9marrera le sous-flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178345488042625)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'it'
,p_message_text=>unistr('Il flusso secondario verr\00E0 riavviato. Aggiungere un commento (facoltativo) e fare clic su Conferma.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172026580042164)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\30B5\30D6\30D5\30ED\30FC\304C\518D\8D77\52D5\3055\308C\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F\FF09\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308364085288841)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774\B807\AC8C \D558\BA74 \D558\C704 \D50C\B85C\C6B0\AC00 \B2E4\C2DC \C2DC\C791\B429\B2C8\B2E4. \C124\BA85\C744 \CD94\AC00\D558\ACE0(\C120\D0DD\C0AC\D56D) \D655\C778\C744 \B204\B974\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209814931045491)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto reiniciar\00E1 o subfluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301876838254994)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FD9\5C06\91CD\65B0\542F\52A8\5B50\6D41\7A0B\3002\8BF7\6DFB\52A0\5907\6CE8\FF08\53EF\9009\FF09\FF0C\7136\540E\5355\51FB\201C\786E\8BA4\201D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190924062043713)
,p_name=>'APP_CONFIRM_RESTART_STEP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9019\6703\91CD\65B0\555F\52D5\5B50\6D41\7A0B\3002\8ACB\65B0\589E\8A3B\89E3 (\9078\64C7\6027)\FF0C\7136\5F8C\6309\4E00\4E0B\78BA\8A8D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133108591837679)
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
 p_id=>wwv_flow_api.id(7202555887044750)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>unistr('Esta acci\00F3n terminar\00E1 la instancia de flujo. Agregue un comentario (opcional) y haga clic en Confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183636417043112)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Ceci terminera l''instance de flux. Veuillez ajouter un commentaire (facultatif) et cliquer sur confirmer.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177328516042625)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'it'
,p_message_text=>unistr('Questa operazione interromper\00E0 l''istanza del flusso. Aggiungere un commento (facoltativo) e fare clic su Conferma.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171050397042163)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\308C\306B\3088\308A\3001\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\7D42\4E86\3057\307E\3059\3002\30B3\30E1\30F3\30C8(\4EFB\610F)\3092\8FFD\52A0\3057\3001\300C\78BA\8A8D\300D\3092\30AF\30EA\30C3\30AF\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307361617288841)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C885\B8CC\B429\B2C8\B2E4. \C124\BA85\C744 \CD94\AC00\D558\ACE0(\C120\D0DD\C0AC\D56D) \D655\C778\C744 \B204\B974\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208860155045491)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Isto encerrar\00E1 a inst\00E2ncia de fluxo. Favor adicionar um coment\00E1rio (opcional) e clicar em confirmar.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300804262254993)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FD9\5C06\7EC8\6B62\6D41\7A0B\5B9E\4F8B\3002\8BF7\6DFB\52A0\5907\6CE8\FF08\53EF\9009\FF09\FF0C\7136\540E\5355\51FB\201C\786E\8BA4\201D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189984647043712)
,p_name=>'APP_CONFIRM_TERMINATE_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9019\6703\7D42\6B62\6D41\7A0B\5BE6\4F8B\3002\8ACB\65B0\589E\8A3B\89E3 (\9078\64C7\6027)\FF0C\7136\5F8C\6309\4E00\4E0B\78BA\8A8D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137442416837685)
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
 p_id=>wwv_flow_api.id(7206864842044752)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Suprimir instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187911529043113)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Supprimer une instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181617600042627)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'it'
,p_message_text=>'Elimina istanza flusso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175337253042166)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\524A\9664')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311625732288843)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4 \C0AD\C81C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213162657045492)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Eliminar inst\00E2ncia de fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305152279254996)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5220\9664\6D41\7A0B\5B9E\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194240045043714)
,p_name=>'APP_DELETE_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\522A\9664\6D41\7A0B\5BE6\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136902738837685)
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
 p_id=>wwv_flow_api.id(7206328431044751)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'es'
,p_message_text=>'Hay %0 instancias de proceso asociadas a este flujo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187416253043113)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'fr'
,p_message_text=>unistr('Il existe %0 instance(s) de processus associ\00E9e(s) \00E0 ce flux.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181151013042627)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'it'
,p_message_text=>'A questo flusso sono associate %0 istanze di processo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174817836042166)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30D5\30ED\30FC\306B\95A2\9023\4ED8\3051\3089\308C\305F\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C%0\500B\3042\308A\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311176516288843)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \D50C\B85C\C6B0\C640 \C5F0\AD00\B41C %0\AC1C\C758 \D504\B85C\C138\C2A4 \C778\C2A4\D134\C2A4\AC00 \C788\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212689475045492)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'pt-br'
,p_message_text=>unistr('H\00E1 %0 inst\00E2ncias de processo associadas a este fluxo.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304673016254995)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6709 %0 \4E2A\8FDB\7A0B\5B9E\4F8B\4E0E\6B64\6D41\7A0B\5173\8054\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193728070043714)
,p_name=>'APP_DIAGRAM_INSTANCES_NB'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6709 %0 \500B\8655\7406\57F7\884C\8655\7406\8207\6B64\6D41\7A0B\95DC\806F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135080238837682)
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
 p_id=>wwv_flow_api.id(7204403867044751)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'es'
,p_message_text=>unistr('Seleccione una conexi\00F3n')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185598092043112)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('Veuillez s\00E9lectionner une connexion')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179287136042626)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'it'
,p_message_text=>'Selezionare una connessione'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172915219042164)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\63A5\7D9A\3092\9078\629E\3057\3066\304F\3060\3055\3044')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309287591288842)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'ko'
,p_message_text=>unistr('\C811\C18D\C744 \C120\D0DD\D558\C2ED\C2DC\C624.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210717510045491)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Por favor, selecione uma conex\00E3o')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302776913254994)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8BF7\9009\62E9\8FDE\63A5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191833768043713)
,p_name=>'APP_ERR_GATEWAY_CONNECTION_EMPTY'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\8ACB\9078\53D6\9023\7DDA')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134908357837682)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'de'
,p_message_text=>unistr('Bitte w\00E4hlen Sie nur eine Verbindung aus')
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
 p_id=>wwv_flow_api.id(7204343668044750)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'es'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Seleccione solo una conexi\00F3n'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185403240043112)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'fr'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Veuillez ne s\00E9lectionner qu''une connexion'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179161346042626)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'it'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Selezionare una sola connessione',
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172815658042164)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'ja'
,p_message_text=>unistr('\63A5\7D9A\30921\3064\306E\307F\9078\629E\3057\3066\304F\3060\3055\3044')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309177009288842)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'ko'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\C5F0\ACB0\C744 \D558\B098\B9CC \C120\D0DD\D558\C2ED\C2DC\C624.'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210660474045491)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Por favor, selecione apenas uma conex\00E3o\005Cn')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302699342254994)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'zh-cn'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\8BF7\4EC5\9009\62E9\4E00\4E2A\8FDE\63A5'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191763558043713)
,p_name=>'APP_ERR_GATEWAY_ONLY_ONE_CONNECTION'
,p_message_language=>'zh-tw'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\8ACB\53EA\9078\53D6\4E00\500B\9023\7DDA'),
''))
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136230699837684)
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
 p_id=>wwv_flow_api.id(7205628107044751)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'es'
,p_message_text=>unistr('El modelo "%0" versi\00F3n %1 ya existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186718069043113)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'fr'
,p_message_text=>unistr('Le mod\00E8le "%0" - Version %1 existe d\00E9j\00E0.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180499099042626)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'it'
,p_message_text=>unistr('Il modello "%0" versione %1 esiste gi\00E0.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174151531042165)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB"%0"\30D0\30FC\30B8\30E7\30F3%1\306F\65E2\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310450415288842)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'ko'
,p_message_text=>unistr('\BAA8\B378 "%0" \BC84\C804 %1\C774(\AC00) \C774\BBF8 \C788\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211912970045492)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Modelo "%0 A vers\00E3o j\00E1 existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303990071254995)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6A21\578B "%0" \7248\672C %1 \5DF2\5B58\5728\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193097577043714)
,p_name=>'APP_ERR_MODEL_EXIST'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6A21\578B "%0" \7248\672C %1 \5DF2\7D93\5B58\5728\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136147124837684)
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
 p_id=>wwv_flow_api.id(7205597489044751)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'es'
,p_message_text=>unistr('Esta versi\00F3n ya existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186696015043113)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'fr'
,p_message_text=>unistr('La version existe d\00E9j\00E0')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180304183042626)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'it'
,p_message_text=>unistr('Questa versione esiste gi\00E0.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174091438042165)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D0\30FC\30B8\30E7\30F3\304C\65E2\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310320080288842)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'ko'
,p_message_text=>unistr('\BC84\C804\C774 \C774\BBF8 \C874\C7AC\D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211803064045492)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'pt-br'
,p_message_text=>unistr('A vers\00E3o j\00E1 existe.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303823223254995)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\7248\672C\5DF2\5B58\5728\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192964047043714)
,p_name=>'APP_ERR_MODEL_VERSION_EXIST'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\7248\672C\5DF2\5B58\5728\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138600852837686)
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
 p_id=>wwv_flow_api.id(7208015514044752)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'es'
,p_message_text=>'Sobrescribir solo es posible para modelos provisionales.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189121568043114)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'fr'
,p_message_text=>unistr('L''\00E9crasement n''est possible que pour les mod\00E8les au statut draft.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182841441042627)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'it'
,p_message_text=>'Sovrascrivi possibile solo per i modelli bozza.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176568374042166)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'ja'
,p_message_text=>unistr('\4E0A\66F8\304D\3067\304D\308B\306E\306F\30C9\30E9\30D5\30C8\30FB\30E2\30C7\30EB\306B\5BFE\3057\3066\306E\307F\3067\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312876325288843)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'ko'
,p_message_text=>unistr('\CD08\C548 \BAA8\B378\C5D0 \B300\D574\C11C\B9CC \ACB9\CCD0\C501\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214332355045493)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Substitua somente os modelos preliminares poss\00EDveis.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306325092254996)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\53EA\80FD\8986\76D6\8349\7A3F\6A21\578B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195454088043715)
,p_name=>'APP_ERR_ONLY_DRAFT'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\53EA\80FD\8986\5BEB\8349\7A3F\6A21\578B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134840248837682)
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
 p_id=>wwv_flow_api.id(7204282472044750)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'es'
,p_message_text=>'El valor debe ser una fecha'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185361585043112)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre une date')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179078467042626)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'it'
,p_message_text=>'Il valore deve essere una data'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172721382042164)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306F\65E5\4ED8\3067\3042\308B\5FC5\8981\304C\3042\308A\307E\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309098893288842)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'ko'
,p_message_text=>unistr('\AC12\C740 \C77C\C790\C5EC\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210534079045491)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'pt-br'
,p_message_text=>'O valor deve ser uma data'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302584186254994)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\503C\5FC5\987B\4E3A\65E5\671F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191610858043713)
,p_name=>'APP_ERR_PROV_VAR_DATE_NOT_DATE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\503C\5FC5\9808\662F\65E5\671F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134466481837681)
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
 p_id=>wwv_flow_api.id(7203885358044750)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El nombre de variable debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184973401043112)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le nom de la variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178632823042625)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'it'
,p_message_text=>'Il nome della variabile deve avere un valore'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172374449042164)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\540D\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308605087288842)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'ko'
,p_message_text=>unistr('\BCC0\C218 \C774\B984\C5D0\B294 \AC12\C774 \C788\C5B4\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210167039045491)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O Nome da Vari\00E1vel deve ser informado')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302120157254994)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\53D8\91CF\540D\79F0\5FC5\987B\5177\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191213962043713)
,p_name=>'APP_ERR_PROV_VAR_NAME_EMPTY'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\8B8A\6578\540D\7A31\5FC5\9808\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134719685837682)
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
 p_id=>wwv_flow_api.id(7204103430044750)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'es'
,p_message_text=>unistr('El valor debe ser un n\00FAmero')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185279791043112)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre un nombre')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178922408042626)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'it'
,p_message_text=>'Il valore deve essere un numero'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172639644042164)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306F\6570\5024\3067\3042\308B\5FC5\8981\304C\3042\308A\307E\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308972679288842)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'ko'
,p_message_text=>unistr('\AC12\C740 \C22B\C790\C5EC\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210482169045491)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O valor deve ser um n\00FAmero')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302479884254994)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\503C\5FC5\987B\4E3A\6570\5B57')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191519287043713)
,p_name=>'APP_ERR_PROV_VAR_NUM_NOT_NUMBER'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\503C\5FC5\9808\662F\6578\5B57')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7132901605837679)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'de'
,p_message_text=>'Wert muss ein Zeitstempel sein'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(4774216918721288)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_text=>'Value must be a timestamp'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7202343167044750)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'es'
,p_message_text=>'El valor debe ser un registro de hora'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183415034043111)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur doit \00EAtre un horodatage')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177163393042625)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'it'
,p_message_text=>'Il valore deve essere un indicatore orario'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7170889205042163)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306F\30BF\30A4\30E0\30B9\30BF\30F3\30D7\3067\3042\308B\5FC5\8981\304C\3042\308A\307E\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307117414288841)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'ko'
,p_message_text=>unistr('\AC12\C740 \C2DC\AC04\AE30\B85D\C774\C5B4\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208627234045491)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'pt-br'
,p_message_text=>'O valor deve ser um timestamp'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300697441254993)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\503C\5FC5\987B\4E3A\65F6\95F4\6233')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189787284043712)
,p_name=>'APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\503C\5FC5\9808\662F\6642\6233')
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
 p_id=>wwv_flow_api.id(7134563224837681)
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
 p_id=>wwv_flow_api.id(7203911094044750)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El tipo de variable debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185068474043112)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>'Le type de variable doit avoir une valeur'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178723598042625)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'it'
,p_message_text=>'Il tipo di variabile deve avere un valore'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172486192042164)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\30BF\30A4\30D7\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308729558288842)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'ko'
,p_message_text=>unistr('\BCC0\C218 \C720\D615\C5D0\B294 \AC12\C774 \C788\C5B4\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210219549045491)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>unistr('O Tipo de Vari\00E1vel deve ser informado')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302268098254994)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\53D8\91CF\7C7B\578B\5FC5\987B\5177\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191394111043713)
,p_name=>'APP_ERR_PROV_VAR_TYPE_EMPTY'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\8B8A\6578\985E\578B\5FC5\9808\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134662185837681)
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
 p_id=>wwv_flow_api.id(7204058403044750)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'es'
,p_message_text=>'El valor debe tener un valor'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185161332043112)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'fr'
,p_message_text=>unistr('La valeur ne peut \00EAtre vide')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178859321042626)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'it'
,p_message_text=>'Il valore deve avere un valore'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172530442042164)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'ja'
,p_message_text=>unistr('\5024\306B\306F\5024\304C\5FC5\8981\3067\3059')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308880595288842)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'ko'
,p_message_text=>unistr('\AC12\C5D0\B294 \AC12\C774 \C788\C5B4\C57C \D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210303893045491)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'pt-br'
,p_message_text=>'O Valor deve ser informado'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302372394254994)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\503C\5FC5\987B\5177\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191445417043713)
,p_name=>'APP_ERR_PROV_VAR_VALUE_EMPTY'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\503C\5FC5\9808\6709\503C')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136861993837685)
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
 p_id=>wwv_flow_api.id(7206280520044751)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'es'
,p_message_text=>'Instancia creada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187373305043113)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance cr\00E9\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181041971042627)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'it'
,p_message_text=>'Istanza creata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174736401042166)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30A4\30F3\30B9\30BF\30F3\30B9\304C\4F5C\6210\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311038504288843)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'ko'
,p_message_text=>unistr('\C778\C2A4\D134\C2A4\AC00 \C0DD\C131\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212514892045492)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia criada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304584951254995)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\521B\5EFA\5B9E\4F8B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193674338043714)
,p_name=>'APP_INSTANCE_CREATED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\5EFA\7ACB\57F7\884C\8655\7406\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133629085837680)
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
 p_id=>wwv_flow_api.id(7203066927044750)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo suprimida.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184182543043112)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177874361042625)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'it'
,p_message_text=>'Istanza flusso eliminata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171500697042163)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\524A\9664\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307855068288841)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C0AD\C81C\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209347264045491)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia de fluxo eliminada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301386833254993)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\5220\9664\6D41\7A0B\5B9E\4F8B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190406731043713)
,p_name=>'APP_INSTANCE_DELETED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\522A\9664\6D41\7A0B\57F7\884C\8655\7406\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133414648837680)
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
 p_id=>wwv_flow_api.id(7202860573044750)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'es'
,p_message_text=>'Restablecimiento de instancia de flujo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183978543043112)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux r\00E9initialis\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177675768042625)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'it'
,p_message_text=>'Reimpostazione istanza flusso.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171339080042163)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\30EA\30BB\30C3\30C8\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307661135288841)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C7AC\C124\C815\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209145460045491)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Reiniciar a inst\00E2ncia do fluxo.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301167029254993)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\5B9E\4F8B\91CD\7F6E\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190202657043713)
,p_name=>'APP_INSTANCE_RESET'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6D41\7A0B\57F7\884C\8655\7406\5DF2\91CD\8A2D\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133375116837679)
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
 p_id=>wwv_flow_api.id(7202774420044750)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo iniciada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183814702043112)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux d\00E9marr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177535128042625)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'it'
,p_message_text=>'Istanza flusso avviata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171255860042163)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\8D77\52D5\3057\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307538316288841)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C2DC\C791\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209097402045491)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'pt-br'
,p_message_text=>'Exemplo de fluxo iniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301065698254993)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\5B9E\4F8B\5DF2\542F\52A8\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190123630043713)
,p_name=>'APP_INSTANCE_STARTED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6D41\7A0B\5BE6\4F8B\5DF2\555F\52D5\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133571448837680)
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
 p_id=>wwv_flow_api.id(7202915416044750)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'es'
,p_message_text=>'Instancia de flujo terminada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184005764043112)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'fr'
,p_message_text=>unistr('Instance de flux termin\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177774139042625)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'it'
,p_message_text=>'Istanza flusso terminata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171496225042163)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\7D42\4E86\3057\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307724182288841)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4\AC00 \C885\B8CC\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209220207045491)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Inst\00E2ncia de Fluxo encerrada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301208003254993)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\5B9E\4F8B\5DF2\7EC8\6B62\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190328751043713)
,p_name=>'APP_INSTANCE_TERMINATED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6D41\7A0B\57F7\884C\8655\7406\5DF2\7D42\6B62\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135114298837683)
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
 p_id=>wwv_flow_api.id(7204544084044751)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'es'
,p_message_text=>'Modelo copiado.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185626545043112)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'fr'
,p_message_text=>unistr('Mod\00E8le copi\00E9.')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179369942042626)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'it'
,p_message_text=>'Modello copiato.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173058243042164)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB\304C\30B3\30D4\30FC\3055\308C\307E\3057\305F\3002')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309330865288842)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'ko'
,p_message_text=>unistr('\BAA8\B378\C774 \BCF5\C0AC\B418\C5C8\C2B5\B2C8\B2E4.')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210814111045491)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'pt-br'
,p_message_text=>'Modelo copiado.'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302861908254994)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\590D\5236\6A21\578B\3002')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191976453043713)
,p_name=>'APP_MODEL_COPIED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\8907\88FD\6A21\578B\3002')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136776164837685)
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
 p_id=>wwv_flow_api.id(7206190224044751)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'es'
,p_message_text=>'Modelo importado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187284833043113)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Mod\00E8le import\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180902183042627)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'it'
,p_message_text=>'Modello importato.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174640806042166)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30E2\30C7\30EB\304C\30A4\30F3\30DD\30FC\30C8\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310930144288843)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'ko'
,p_message_text=>unistr('\BAA8\B378\C744 \C784\D3EC\D2B8\D588\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212491256045492)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'pt-br'
,p_message_text=>'Modelo importado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304429272254995)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\5BFC\5165\6A21\578B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193539097043714)
,p_name=>'APP_MODEL_IMPORTED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\532F\5165\6A21\578B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137696496837685)
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
 p_id=>wwv_flow_api.id(7207088646044752)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'es'
,p_message_text=>unistr('Nueva versi\00F3n agregada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188144635043113)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Nouvelle version ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181868641042627)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'it'
,p_message_text=>'Nuova versione aggiunta.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175564269042166)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'ja'
,p_message_text=>unistr('\65B0\3057\3044\30D0\30FC\30B8\30E7\30F3\304C\8FFD\52A0\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311826367288843)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'ko'
,p_message_text=>unistr('\C0C8 \BC84\C804\C774 \CD94\AC00\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213379291045492)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Nova vers\00E3o adicionada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305337063254996)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\6DFB\52A0\65B0\7248\672C\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194408054043714)
,p_name=>'APP_NEW_VERSION_ADDED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\65B0\589E\65B0\7248\672C\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136665065837685)
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
 p_id=>wwv_flow_api.id(7206066594044751)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'es'
,p_message_text=>unistr('Si hay instancias en ejecuci\00F3n asociadas al modelo existente, pueden provocar errores. \00BFSeguro que desea continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187151411043113)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'fr'
,p_message_text=>unistr('Si des instances en cours d''ex\00E9cution sont associ\00E9es au mod\00E8le existant, ceci peut provoquer des erreurs. Etes-vous s\00FBr de vouloir continuer ?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180875181042626)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'it'
,p_message_text=>unistr('Se esistono istanze in esecuzione associate al modello esistente, potrebbero verificarsi errori. Si \00E8 certi di voler continuare?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174563924042166)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E2\5B58\306E\30E2\30C7\30EB\306B\95A2\9023\4ED8\3051\3089\308C\305F\5B9F\884C\4E2D\306E\30A4\30F3\30B9\30BF\30F3\30B9\304C\3042\308B\5834\5408\3001\30A8\30E9\30FC\304C\767A\751F\3059\308B\53EF\80FD\6027\304C\3042\308A\307E\3059\3002\7D9A\884C\3057\307E\3059\304B?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310807689288843)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'ko'
,p_message_text=>unistr('\AE30\C874 \BAA8\B378\C5D0 \C5F0\AD00\B41C \C2E4\D589 \C911\C778 \C778\C2A4\D134\C2A4\AC00 \C788\C744 \ACBD\C6B0 \C774\B85C \C778\D574 \C624\B958\AC00 \BC1C\C0DD\D560 \C218 \C788\C2B5\B2C8\B2E4. \ACC4\C18D\D558\C2DC\ACA0\C2B5\B2C8\AE4C?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212357199045492)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Se houver inst\00E2ncias em execu\00E7\00E3o associadas ao modelo existente, elas poder\00E3o causar erros. Voc\00EA tem certeza que quer continuar?')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304365653254995)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5982\679C\5B58\5728\4E0E\73B0\6709\6A21\578B\5173\8054\7684\6B63\5728\8FD0\884C\7684\5B9E\4F8B\FF0C\5219\8FD9\4E9B\5B9E\4F8B\53EF\80FD\4F1A\5BFC\81F4\9519\8BEF\3002\662F\5426\786E\5B9A\8981\7EE7\7EED\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193476398043714)
,p_name=>'APP_OVERWRITE_WARN'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5982\679C\6709\8207\73FE\6709\6A21\578B\76F8\95DC\806F\7684\57F7\884C\4E2D\4F8B\9805\FF0C\5247\9019\4E9B\4F8B\9805\53EF\80FD\6703\5C0E\81F4\932F\8AA4\3002\60A8\662F\5426\78BA\5B9A\8981\7E7C\7E8C\FF1F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133845183837680)
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
 p_id=>wwv_flow_api.id(7203291347044750)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso agregada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184368011043112)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus ajout\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178061979042625)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'it'
,p_message_text=>'Variabile processo aggiunta.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171701365042163)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\8FFD\52A0\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308048354288841)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D504\B85C\C138\C2A4 \BCC0\C218\AC00 \CD94\AC00\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209561691045491)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo adicionada.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301590568254994)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\6DFB\52A0\8FDB\7A0B\53D8\91CF\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190622432043713)
,p_name=>'APP_PROCESS_VARIABLE_ADDED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\65B0\589E\8655\7406\8B8A\6578\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134388318837681)
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
 p_id=>wwv_flow_api.id(7203714362044750)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso suprimida.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184862574043112)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus supprim\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178532733042625)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'it'
,p_message_text=>'Variabile processo eliminata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7172282041042164)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\524A\9664\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308584013288841)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D504\B85C\C138\C2A4 \BCC0\C218\AC00 \C0AD\C81C\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7210055728045491)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo exclu\00EDda.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7302060366254994)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\53D8\91CF\5DF2\5220\9664\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7191184831043713)
,p_name=>'APP_PROCESS_VARIABLE_DELETED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\522A\9664\8655\7406\8B8A\6578\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133915308837680)
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
 p_id=>wwv_flow_api.id(7203316402044750)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'es'
,p_message_text=>'Variable de proceso guardada.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184404598043112)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'fr'
,p_message_text=>unistr('Variable de processus enregistr\00E9e.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178188108042625)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'it'
,p_message_text=>'Variabile processo salvata.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171856326042164)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D7\30ED\30BB\30B9\5909\6570\304C\4FDD\5B58\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308153593288841)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D504\B85C\C138\C2A4 \BCC0\C218\AC00 \C800\C7A5\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209639200045491)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Vari\00E1vel de processo salva.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301615306254994)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\8FDB\7A0B\53D8\91CF\5DF2\4FDD\5B58\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190725752043713)
,p_name=>'APP_PROCESS_VARIABLE_SAVED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\5132\5B58\8655\7406\8B8A\6578\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138946205837687)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'de'
,p_message_text=>unistr('Neu-ausl\00F6sen')
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
 p_id=>wwv_flow_api.id(73507335747013782)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_text=>'Reschedule'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208350466044752)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'es'
,p_message_text=>'Reprogramar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189481787043114)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'fr'
,p_message_text=>'Reprogrammer'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183177689042628)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'it'
,p_message_text=>'Rischedula'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176860660042167)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'ja'
,p_message_text=>unistr('\518D\30B9\30B1\30B8\30E5\30FC\30EB')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7313192369288844)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'ko'
,p_message_text=>unistr('\C2A4\CF00\C904 \C870\C815')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214613120045493)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'pt-br'
,p_message_text=>'Reprogramar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306644535254996)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\91CD\65B0\8BA1\5212')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195776858043715)
,p_name=>'APP_RESCHEDULE_TIMER'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\91CD\65B0\6392\5B9A')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137215638837685)
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
 p_id=>wwv_flow_api.id(7206635859044751)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Restablecer instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187787479043113)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>unistr('R\00E9initialiser l''instance de flux')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181463041042627)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'it'
,p_message_text=>'Reimposta istanza flusso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175197211042166)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\30EA\30BB\30C3\30C8')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311442149288843)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4 \C7AC\C124\C815')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212910296045492)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Reiniciar a Inst\00E2ncia do Fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304953975254995)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\91CD\7F6E\6D41\7A0B\5B9E\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194029903043714)
,p_name=>'APP_RESET_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\91CD\8A2D\6D41\7A0B\5BE6\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7134079744837680)
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
 p_id=>wwv_flow_api.id(7203425597044750)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>'Reiniciar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184581558043112)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Red\00E9marrer')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7178279953042625)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'it'
,p_message_text=>'Riavvia'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171977317042164)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\518D\8D77\52D5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7308210418288841)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'ko'
,p_message_text=>unistr('\C7AC\C2DC\C791')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209794943045491)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Reiniciar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301719511254994)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\91CD\65B0\542F\52A8')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190887198043713)
,p_name=>'APP_RESTART_STEP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\91CD\65B0\555F\52D5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7133785259837680)
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
 p_id=>wwv_flow_api.id(7203169253044750)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'es'
,p_message_text=>'Subflujo reiniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7184265032043112)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'fr'
,p_message_text=>unistr('Sous-flux red\00E9marr\00E9.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7177998998042625)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'it'
,p_message_text=>'Flusso secondario riavviato.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7171672539042163)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30D6\30D5\30ED\30FC\304C\518D\8D77\52D5\3055\308C\307E\3057\305F\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7307902084288841)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D558\C704 \D50C\B85C\C6B0\AC00 \C7AC\C2DC\C791\B418\C5C8\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7209430148045491)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'pt-br'
,p_message_text=>'Subfluxo reiniciado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7301465463254993)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5B50\6D41\7A0B\5DF2\91CD\65B0\542F\52A8\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7190504307043713)
,p_name=>'APP_SUBLFOW_RESTARTED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5B50\6D41\7A0B\5DF2\91CD\65B0\555F\52D5\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138805995837687)
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
 p_id=>wwv_flow_api.id(7208273289044752)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'es'
,p_message_text=>unistr('Asignaci\00F3n de entrada/salida')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189343572043114)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'fr'
,p_message_text=>unistr('Mappage entr\00E9e/sortie')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183023715042627)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'it'
,p_message_text=>'Mapping in entrata/in uscita'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176781029042167)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'ja'
,p_message_text=>unistr('\5165\51FA\529B\30DE\30C3\30D4\30F3\30B0')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7313000683288844)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'ko'
,p_message_text=>unistr('\C785\B825/\CD9C\B825 \B9E4\D551')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214570976045493)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Mapeamento de Entrada/Sa\00EDda')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306563759254996)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\4F20\5165/\8F93\51FA\6620\5C04')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195626173043715)
,p_name=>'APP_TAB_IN_OUT_MAPPING'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\8F38\5165 / \8F38\51FA\5C0D\61C9')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138774590837687)
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
 p_id=>wwv_flow_api.id(7208109479044752)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'es'
,p_message_text=>'Expresiones de variables'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189231037043114)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'fr'
,p_message_text=>'Expressions de variables'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182912961042627)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'it'
,p_message_text=>'Variabile Espressioni'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176625108042167)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'ja'
,p_message_text=>unistr('\5909\6570\5F0F')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312969146288844)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'ko'
,p_message_text=>unistr('\BCC0\C218 \D45C\D604\C2DD')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214420027045493)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Express\00F5es de Vari\00E1vel')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306451002254996)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\53D8\91CF\8868\8FBE\5F0F')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195549885043715)
,p_name=>'APP_TAB_VAR_EXP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\8B8A\6578\8868\793A\5F0F')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7137325689837685)
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
 p_id=>wwv_flow_api.id(7206763624044751)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'es'
,p_message_text=>'Terminar instancia de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187817482043113)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'fr'
,p_message_text=>'Terminer l''instance de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7181568718042627)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'it'
,p_message_text=>'Arresta istanza flusso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7175257316042166)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30A4\30F3\30B9\30BF\30F3\30B9\306E\7D42\4E86')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7311528705288843)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \C778\C2A4\D134\C2A4 \C885\B8CC')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213090531045492)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Terminar a inst\00E2ncia de fluxo')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305038641254996)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\7EC8\6B62\6D41\7A0B\5B9E\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7194193108043714)
,p_name=>'APP_TERMINATE_INSTANCE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\7D42\6B62\6D41\7A0B\5BE6\4F8B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135834198837684)
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
 p_id=>wwv_flow_api.id(7205217486044751)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'es'
,p_message_text=>unistr('%0 - Versi\00F3n %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186324039043113)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'fr'
,p_message_text=>'%0 - Version %1'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180000477042626)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'it'
,p_message_text=>'%0 - Versione %1'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173743118042165)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('%0 - \30D0\30FC\30B8\30E7\30F3%1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310011607288842)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'ko'
,p_message_text=>unistr('%0 - \BC84\C804 %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211549081045492)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>unistr('%0 - Vers\00E3o %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303500019254995)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('%0 - \7248\672C %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192688305043714)
,p_name=>'APP_TITLE_MODEL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('%0 - \7248\672C %1')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135794125837683)
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
 p_id=>wwv_flow_api.id(7205135013044751)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'es'
,p_message_text=>'Nuevo modelo'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186278818043113)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'fr'
,p_message_text=>unistr('Nouveau Mod\00E8le')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179948950042626)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'it'
,p_message_text=>'Nuovo modello'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173600984042165)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'ja'
,p_message_text=>unistr('\65B0\898F\30E2\30C7\30EB')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309965979288842)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'ko'
,p_message_text=>unistr('\C0C8 \BAA8\B378')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211497943045492)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'pt-br'
,p_message_text=>'Novo modelo'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303432433254995)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\65B0\5EFA\6A21\578B')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192546044043714)
,p_name=>'APP_TITLE_NEW_MODEL'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\65B0\5EFA\6A21\578B')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135985933837684)
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
 p_id=>wwv_flow_api.id(7205348143044751)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'es'
,p_message_text=>'Volver a iniciar paso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186444711043113)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'fr'
,p_message_text=>unistr('Red\00E9marrer l''\00E9tape')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180153317042626)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'it'
,p_message_text=>'Riavvia passo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173835410042165)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B9\30C6\30C3\30D7\306E\518D\8D77\52D5')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310123949288842)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'ko'
,p_message_text=>unistr('\B2E8\ACC4 \C7AC\C2DC\C791')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211685182045492)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'pt-br'
,p_message_text=>'Reiniciar Etapa'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303650167254995)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\91CD\65B0\542F\52A8\6B65\9AA4')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192712904043714)
,p_name=>'APP_TITLE_RESTART_STEP'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\91CD\65B0\555F\52D5\6B65\9A5F')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7132715698837678)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'de'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Die Anwendungsversion, das Datenmodell und der Code stimmen nicht \00FCberein:'),
'<ul>',
'<li>Anwendungsversion: %0</li>',
'<li>Datenmodellversion: %1</li>',
'<li>Codeversion: %2</li>',
'</ul>',
'Wenden Sie sich an Ihren Administrator, um Probleme zu vermeiden.'))
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
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7202159453044750)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'es'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hemos identificado que la versi\00F3n de la aplicaci\00F3n, el modelo de datos y el c\00F3digo no coinciden:'),
'<ul>',
unistr('<li>versi\00F3n de la aplicaci\00F3n: %0</li>'),
unistr('<li>versi\00F3n de modelo de datos: %1</li>'),
unistr('<li>versi\00F3n de c\00F3digo: %2</li>'),
'</ul>',
unistr('P\00F3ngase en contacto con el administrador para evitar problemas.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7183237506043111)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'fr'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Nous avons identifi\00E9 que la version de l''application, le mod\00E8le de donn\00E9es et le code ne correspondent pas :'),
'<ul>',
'<li>version de l''application : %0</li>',
unistr('<li>version du mod\00E8le de donn\00E9es : %1</li>'),
'<li>version du code : %2</li>',
'</ul>',
unistr('Contactez votre administrateur pour \00E9viter tout probl\00E8me.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176959863042625)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'it'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\00C8 stato rilevato che la versione dell''applicazione, il modello dati e il codice non corrispondono:'),
'<ul>',
'<li>versione dell''applicazione: %0</li>',
'<li>versione modello dati: %1</li>',
'<li>versione codice: %2</li>',
'</ul>',
'Contattare l''amministratore per evitare problemi.'))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7170658084042163)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'ja'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\30A2\30D7\30EA\30B1\30FC\30B7\30E7\30F3\306E\30D0\30FC\30B8\30E7\30F3\3001\30C7\30FC\30BF\30FB\30E2\30C7\30EB\304A\3088\3073\30B3\30FC\30C9\304C\4E00\81F4\3057\306A\3044\3053\3068\304C\78BA\8A8D\3055\308C\307E\3057\305F\3002'),
'<ul>',
unistr('<li>\30A2\30D7\30EA\30B1\30FC\30B7\30E7\30F3\30FB\30D0\30FC\30B8\30E7\30F3: %0</li>'),
unistr('<li>\30C7\30FC\30BF\30FB\30E2\30C7\30EB\30FB\30D0\30FC\30B8\30E7\30F3: %1</li>'),
unistr('<li>\30B3\30FC\30C9\30FB\30D0\30FC\30B8\30E7\30F3: %2</li>'),
'</ul>',
unistr('\554F\984C\3092\56DE\907F\3059\308B\306B\306F\3001\7BA1\7406\8005\306B\9023\7D61\3057\3066\304F\3060\3055\3044\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306991424288841)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'ko'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\C560\D50C\B9AC\CF00\C774\C158 \BC84\C804, \B370\C774\D130 \BAA8\B378 \BC0F \CF54\B4DC\AC00 \C77C\CE58\D558\C9C0 \C54A\B294 \AC83\C73C\B85C \D655\C778\B418\C5C8\C2B5\B2C8\B2E4.'),
'<ul>',
unistr('<li>\C560\D50C\B9AC\CF00\C774\C158 \BC84\C804: %0</li>'),
unistr('<li>\B370\C774\D130 \BAA8\B378 \BC84\C804: %1</li>'),
unistr('<li>\CF54\B4DC \BC84\C804: %2</li>'),
'</ul>',
unistr('\BB38\C81C\B97C \BC29\C9C0\D558\B824\BA74 \AD00\B9AC\C790\C5D0\AC8C \BB38\C758\D558\C2ED\C2DC\C624.')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7208434790045490)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'pt-br'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Identificamos que a vers\00E3o, o modelo e o c\00F3digo do aplicativo n\00E3o correspondem:'),
'<ul>',
unistr('<li>vers\00E3o do aplicativo: %0</li>'),
unistr('<li>vers\00E3o do modelo de dados: %1</li>'),
unistr('<li>vers\00E3o do c\00F3digo: %2</li>'),
'</ul>',
'Entre em contato com o administrador para evitar problemas.'))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7300481436254992)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'zh-cn'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\6211\4EEC\5DF2\786E\5B9A\5E94\7528\7A0B\5E8F\7248\672C\3001\6570\636E\6A21\578B\548C\4EE3\7801\4E0D\5339\914D\FF1A '),
'<ul>',
unistr(' <li> \5E94\7528\7A0B\5E8F\7248\672C\FF1A%0</li>'),
unistr(' <li> \6570\636E\6A21\578B\7248\672C\FF1A%1</li>'),
unistr(' <li> \4EE3\7801\7248\672C\FF1A%2</li>'),
' </ul>',
unistr(' \8BF7\4E0E\7BA1\7406\5458\8054\7CFB\4EE5\907F\514D\51FA\73B0\4EFB\4F55\95EE\9898\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7189539439043712)
,p_name=>'APP_VERSION_MISMATCH'
,p_message_language=>'zh-tw'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\6211\5011\767C\73FE\61C9\7528\7A0B\5F0F\7248\672C\3001\8CC7\6599\6A21\578B\4EE5\53CA\7A0B\5F0F\78BC\4E0D\7B26\FF1A '),
'<ul>',
unistr(' <li> \61C9\7528\7A0B\5F0F\7248\672C\FF1A%0</li>'),
unistr(' <li> \8CC7\6599\6A21\578B\7248\672C\FF1A%1</li>'),
unistr(' <li> \7A0B\5F0F\78BC\7248\672C\FF1A%2</li>'),
' </ul>',
unistr(' \8ACB\806F\7D61\7BA1\7406\54E1\4EE5\907F\514D\4EFB\4F55\554F\984C\3002')))
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135620640837683)
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
 p_id=>wwv_flow_api.id(7205018026044751)
,p_name=>'APP_VIEW'
,p_message_language=>'es'
,p_message_text=>'Ver'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186152012043113)
,p_name=>'APP_VIEW'
,p_message_language=>'fr'
,p_message_text=>'Voir'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179885632042626)
,p_name=>'APP_VIEW'
,p_message_language=>'it'
,p_message_text=>'Visualizza'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173560005042165)
,p_name=>'APP_VIEW'
,p_message_language=>'ja'
,p_message_text=>unistr('\8868\793A')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309831622288842)
,p_name=>'APP_VIEW'
,p_message_language=>'ko'
,p_message_text=>unistr('\BCF4\AE30')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211390438045492)
,p_name=>'APP_VIEW'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizar'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303381110254995)
,p_name=>'APP_VIEW'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\67E5\770B')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192403366043713)
,p_name=>'APP_VIEW'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6AA2\8996')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135400899837683)
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
 p_id=>wwv_flow_api.id(7204851498044751)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'es'
,p_message_text=>'Visor de flujo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7185969868043113)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179607084042626)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'it'
,p_message_text=>'Visualizzatore flusso'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173336400042165)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30FB\30D3\30E5\30FC\30A2\30FC')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309612553288842)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \BDF0\C5B4')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211178474045492)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizador de fluxo'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303175338254994)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\67E5\770B\5668')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192282218043713)
,p_name=>'APP_VIEWER_TITLE_NO_PROCESS'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6D41\7A0B\6AA2\8996\5668')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7135526352837683)
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
 p_id=>wwv_flow_api.id(7204972225044751)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'es'
,p_message_text=>'Visor de flujo (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186011136043113)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'fr'
,p_message_text=>'Visionneuse de flux (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7179708830042626)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'it'
,p_message_text=>'Visualizzatore flusso (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7173467293042165)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'ja'
,p_message_text=>unistr('\30D5\30ED\30FC\30D3\30E5\30FC\30A2(%0)')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7309717285288842)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'ko'
,p_message_text=>unistr('\D50C\B85C\C6B0 \BDF0\C5B4(%0)')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7211288196045492)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'pt-br'
,p_message_text=>'Visualizador de fluxo (%0)'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7303215994254994)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6D41\7A0B\67E5\770B\5668 (%0)')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7192302646043713)
,p_name=>'APP_VIEWER_TITLE_PROCESS_SELECTED'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6D41\7A0B\6AA2\8996\5668 (%0)')
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
 p_id=>wwv_flow_api.id(7138484237837686)
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
 p_id=>wwv_flow_api.id(7207829712044752)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'es'
,p_message_text=>'Ciclo (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188942450043114)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'fr'
,p_message_text=>'Cycle (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182658218042627)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'it'
,p_message_text=>'Ciclo (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176346444042166)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'ja'
,p_message_text=>unistr('\30B5\30A4\30AF\30EB(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312634227288843)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'ko'
,p_message_text=>unistr('\C8FC\AE30(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214120287045493)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'pt-br'
,p_message_text=>'Ciclo (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306155133254996)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5468\671F (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195246751043715)
,p_name=>'BPMN:TIMECYCLE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\9031\671F (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138289730837686)
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
 p_id=>wwv_flow_api.id(7207668171044752)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'es'
,p_message_text=>'Fecha (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188749140043114)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'fr'
,p_message_text=>'Date (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182456539042627)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'it'
,p_message_text=>'Data (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176133195042166)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'ja'
,p_message_text=>unistr('\65E5\4ED8(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312488661288843)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'ko'
,p_message_text=>unistr('\C77C\C790(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7213986717045493)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'pt-br'
,p_message_text=>'Data (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7305956522254996)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\65E5\671F (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195052945043715)
,p_name=>'BPMN:TIMEDATE'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\65E5\671F (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7138361266837686)
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
 p_id=>wwv_flow_api.id(7207705355044752)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'es'
,p_message_text=>unistr('Duraci\00F3n (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7188819937043114)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'fr'
,p_message_text=>unistr('Dur\00E9e (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7182581351042627)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'it'
,p_message_text=>'Durata (ISO 8601)'
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7176284680042166)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'ja'
,p_message_text=>unistr('\671F\9593(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7312562726288843)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'ko'
,p_message_text=>unistr('\AE30\AC04(ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7214037089045493)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Dura\00E7\00E3o (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7306078669254996)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\6301\7EED\65F6\95F4 (ISO 8601)')
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7195197811043715)
,p_name=>'BPMN:TIMEDURATION'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6301\7E8C\6642\9593 (ISO 8601)')
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
 p_id=>wwv_flow_api.id(7136532798837685)
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
 p_id=>wwv_flow_api.id(7205930987044751)
,p_name=>'DGRM_UK'
,p_message_language=>'es'
,p_message_text=>'Ya existe un flujo con el mismo nombre y estado.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7187031242043113)
,p_name=>'DGRM_UK'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux existe d\00E9j\00E0 avec le m\00EAme nom et le m\00EAme statut.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180762831042626)
,p_name=>'DGRM_UK'
,p_message_language=>'it'
,p_message_text=>unistr('Esiste gi\00E0 un flusso con lo stesso nome e lo stesso stato.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174428624042166)
,p_name=>'DGRM_UK'
,p_message_language=>'ja'
,p_message_text=>unistr('\540C\3058\540D\524D\304A\3088\3073\30B9\30C6\30FC\30BF\30B9\306E\30D5\30ED\30FC\304C\3059\3067\306B\5B58\5728\3057\307E\3059\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310707461288843)
,p_name=>'DGRM_UK'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774\B984 \BC0F \C0C1\D0DC\AC00 \B3D9\C77C\D55C \D50C\B85C\C6B0\AC00 \C774\BBF8 \C788\C2B5\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212222529045492)
,p_name=>'DGRM_UK'
,p_message_language=>'pt-br'
,p_message_text=>unistr('J\00E1 existe um fluxo com o mesmo nome e status.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304217366254995)
,p_name=>'DGRM_UK'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5DF2\5B58\5728\5177\6709\76F8\540C\540D\79F0\548C\72B6\6001\7684\6D41\7A0B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193370495043714)
,p_name=>'DGRM_UK'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\5DF2\6709\76F8\540C\540D\7A31\8207\72C0\614B\7684\6D41\7A0B\5B58\5728\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7136427077837684)
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
 p_id=>wwv_flow_api.id(7205810907044751)
,p_name=>'DGRM_UK2'
,p_message_language=>'es'
,p_message_text=>'Ya existe un flujo con este nombre y con el estado ''liberado''. Cambie el estado del flujo existente a en desuso o archivado y vuelva a importarlo.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186960750043113)
,p_name=>'DGRM_UK2'
,p_message_language=>'fr'
,p_message_text=>unistr('Un flux portant ce nom et ayant le statut "released" existe d\00E9j\00E0.  Changez le statut du flux existant en deprecated ou archived et r\00E9importez-le.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180625534042626)
,p_name=>'DGRM_UK2'
,p_message_language=>'it'
,p_message_text=>unistr('Esiste gi\00E0 un flusso con questo nome e con stato ''rilasciato''. Modificare lo stato del flusso esistente in Non pi\00F9 valido o Archiviato e reimportare.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174329471042165)
,p_name=>'DGRM_UK2'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\540D\524D\3067\30B9\30C6\30FC\30BF\30B9\304C ''released''\300C\30EA\30EA\30FC\30B9\6E08\300D\306E\30D5\30ED\30FC\306F\3059\3067\306B\5B58\5728\3057\307E\3059\3002\65E2\5B58\306E\30D5\30ED\30FC\30FB\30B9\30C6\30FC\30BF\30B9\3092\975E\63A8\5968\307E\305F\306F\30A2\30FC\30AB\30A4\30D6\6E08\306B\5909\66F4\3057\3001\518D\30A4\30F3\30DD\30FC\30C8\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310669434288842)
,p_name=>'DGRM_UK2'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \C774\B984\C774 \C788\ACE0 \C0C1\D0DC\AC00 ''\B9B4\B9AC\C988\B428''\C778 \D50C\B85C\C6B0\AC00 \C774\BBF8 \C788\C2B5\B2C8\B2E4. \AE30\C874 \D50C\B85C\C6B0 \C0C1\D0DC\B97C \B354 \C774\C0C1 \C0AC\C6A9\B418\C9C0 \C54A\AC70\B098 \C544\CE74\C774\BE0C\B41C \D6C4 \B2E4\C2DC \C784\D3EC\D2B8\B85C \BCC0\ACBD\D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212115848045492)
,p_name=>'DGRM_UK2'
,p_message_language=>'pt-br'
,p_message_text=>unistr('J\00E1 existe um fluxo com este nome e com um status de ''lan\00E7ado''. Alterar o status do fluxo existente para descontinuado ou arquivado e reimportado.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304119211254995)
,p_name=>'DGRM_UK2'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5177\6709\6B64\540D\79F0\4E14\72B6\6001\4E3A\201C\5DF2\53D1\653E\201D\7684\6D41\7A0B\5DF2\5B58\5728\3002\5C06\73B0\6709\6D41\7A0B\72B6\6001\66F4\6539\4E3A\5DF2\5F03\7528\6216\5DF2\5B58\6863\5E76\91CD\65B0\5BFC\5165\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193223100043714)
,p_name=>'DGRM_UK2'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\6B64\540D\7A31\4E14\72C0\614B\70BA\300C\5DF2\6838\767C\300D\7684\6D41\7A0B\5DF2\5B58\5728\3002\5C07\73FE\6709\6D41\7A0B\72C0\614B\8B8A\66F4\70BA\5DF2\68C4\7528\6216\5DF2\5C01\5B58\4E26\91CD\65B0\532F\5165\3002')
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
 p_id=>wwv_flow_api.id(7136390712837684)
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
 p_id=>wwv_flow_api.id(7205780342044751)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'es'
,p_message_text=>unistr('Existen instancias de proceso que utilizan este flujo. Utilice la opci\00F3n en cascada para eliminar instancias de flujo y proceso.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7186873035043113)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'fr'
,p_message_text=>'Des instances de processus utilisant ce flux existent. Utilisez l''option cascade pour supprimer le flux et les instances de processus.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7180501065042626)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'it'
,p_message_text=>'Esistono istanze di processo che utilizzano questo flusso. Utilizzare l''opzione a cascata per rimuovere le istanze di flusso ed elaborazione.'
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7174272689042165)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'ja'
,p_message_text=>unistr('\3053\306E\30D5\30ED\30FC\3092\4F7F\7528\3059\308B\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\304C\5B58\5728\3057\307E\3059\3002\30D5\30ED\30FC\304A\3088\3073\30D7\30ED\30BB\30B9\30FB\30A4\30F3\30B9\30BF\30F3\30B9\3092\524A\9664\3059\308B\306B\306F\30AB\30B9\30B1\30FC\30C9\30AA\30D7\30B7\30E7\30F3\3092\4F7F\7528\3057\3066\304F\3060\3055\3044\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7310575164288842)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'ko'
,p_message_text=>unistr('\C774 \D50C\B85C\C6B0\B97C \C0AC\C6A9\D558\B294 \D504\B85C\C138\C2A4 \C778\C2A4\D134\C2A4\AC00 \C874\C7AC\D569\B2C8\B2E4. \ACC4\B2E8\C2DD \C635\C158\C744 \C0AC\C6A9\D558\C5EC \D50C\B85C\C6B0 \BC0F \D504\B85C\C138\C2A4 \C778\C2A4\D134\C2A4\B97C \C81C\AC70\D569\B2C8\B2E4.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7212017232045492)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'pt-br'
,p_message_text=>unistr('Existem inst\00E2ncias de processo que utilizam este fluxo. Use a op\00E7\00E3o em cascata para remover inst\00E2ncias de fluxo e de processo.')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7304098201254995)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'zh-cn'
,p_message_text=>unistr('\5B58\5728\4F7F\7528\6B64\6D41\7684\6D41\7A0B\5B9E\4F8B\3002\4F7F\7528\7EA7\8054\9009\9879\5220\9664\6D41\548C\6D41\7A0B\5B9E\4F8B\3002')
,p_is_js_message=>true
);
wwv_flow_api.create_message(
 p_id=>wwv_flow_api.id(7193113179043714)
,p_name=>'PRCS_DGRM_FK'
,p_message_language=>'zh-tw'
,p_message_text=>unistr('\4F7F\7528\6B64\6D41\7A0B\7684\8655\7406\5BE6\4F8B\5DF2\5B58\5728\3002\4F7F\7528\91CD\758A\986F\793A\9078\9805\4F86\79FB\9664\6D41\7A0B\8207\8655\7406\5BE6\4F8B\3002')
,p_is_js_message=>true
);
wwv_flow_api.component_end;
end;
/

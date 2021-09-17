insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'eng_handle_event_int',
'fr',
'Erreur interne du moteur de flux: Processus %0 Sous-flux %1 Module %2 Courant %4 Balise courante %3'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'more_than_1_forward_path',
'fr',
'Plus d''un chemin d''accès trouvé alors qu''un seul est autorisé.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'no_next_step_found',
'fr',
'Aucune étape suivante trouvée pour le sous-flux %0. Vérifiez votre diagramme de processus.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_failed',
'fr',
'Processus %0 : Tâche de script %1 a échoué en raison d''une erreur PL/SQL - voir le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_requested_stop',
'fr',
'Processus %0: Tâche de script %1 arrêt du traitement demandé - voir le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timeout_locking_subflow',
'fr',
'Impossible de verrouiller le sous-flux : %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer_broken',
'fr',
'Minuteur %0 en erreur dans le processus %1 , sous-flux : %2.  Voir error_info.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_plsql_error',
'fr',
'Sous-flux : %0 Erreur dans l''expression %2 de la variable : %1'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_no_data',
'fr',
'Ereur lors de la mise à jour de la variable %1 avec la valeur %2 dans le processus %0 - Aucune donnée trouvée dans la requête.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_other',
'fr',
'Ereur lors de la mise à jour de la variable %1 avec la valeur %2 dans le processus %0.  Erreur SQL indiquée dans le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_too_many_rows',
'fr',
'Ereur lors de la mise à jour de la variable %1 avec la valeur %2 dans le processus %0.  La requête renvoie plusieurs lignes.'
);


/* Plug-ins */
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-model-no-version',
'fr',
'La version n''est pas définie.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-parsing-json-variables',
'fr',
'Erreur lors de l''analyse des variables du processus.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-route-not-define',
'fr',
'La passerelle n''est pas définie pour le routage.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-gateway-not-exist',
'fr',
'La définition de la passerelle n''existe pas pour ce flux.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-no-instance-subflow-id',
'fr',
'Impossible d''obtenir l''Id de l''Instance de flux et ou l''Id du sous-flux pour gérer l''étape.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-wrong-variable-number',
'fr',
'Mauvais nombre d''élément(s) APEX ou de variable(s) de processus.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-wrong-variable-type',
'fr',
'Une ou plusieurs variables de processus sont d''un type différent de celui défini dans le JSON.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-variable-not-a-number',
'fr',
'%0 n''est pas un nombre valide.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-variable-not-a-date',
'fr',
'%0 n''est pas une date valide.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-modeler-id-not-found',
'fr',
'Aucune donnée trouvée. Vérifiez si le Diagramme avec l''ID fourni existe.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-unexpected-error',
'fr',
'Erreur inattendue, veuillez contacter votre administrateur.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-not-parsable',
'fr',
'Le diagramme n''a pas pu être analysé.<br />Veuillez examiner votre diagramme pour vous assurer qu''il est pris en charge.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-saved',
'fr',
'Changements enregistrés !'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-has-changed',
'fr',
'Le modlèle a changé, annuler les changements?'
);

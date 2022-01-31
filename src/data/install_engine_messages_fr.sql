PROMPT >> Delete existing messages
delete from flow_messages where fmsg_lang = 'fr';

PROMPT >> Loading Exported Messages
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'ITE-unsupported-type',
'fr',
'Type d''événement de lancer intermédiaire actuellement non pris en charge rencontré à %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'boundary-event-child-lock-to',
'fr',
'Sous-flux enfant ou minuteur de %0 sont actuellement verrouillés par un autre utilisateur. . Réessayez votre transaction plus tard.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'boundary-event-no-catch-found',
'fr',
'Aucun événement de frontière de type %0 trouvé pour capturer l''événement.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'boundary-event-too-many',
'fr',
'Plus d''un événement de frontière %0 trouvé sur le sous-processus.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'eng_handle_event_int',
'fr',
'Erreur interne du moteur de flux: Processus %0 Sous-flux %1 Module %2 Courant %4 Balise courante %3'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'engine-unsupported-object',
'fr',
'Erreur de modèle : L''étape suivante du modèle de processus BPMN utilise un objet non supporté %0'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'engine-util-prcs-not-found',
'fr',
'Erreur applicative : L''ID du processus %0 n''a pas été trouvé.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'engine-util-sbfl-not-in-prcs',
'fr',
'Erreur applicative: L''ID du sous-flux fourni ( %0 ) existe mais n''est pas un enfant de l''ID de processus fourni ( %1 ).'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'engine-util-sbfl-not-found',
'fr',
'L''ID du sous-flux fourni ( %0 ) est introuvable. Vérifiez les événements du processus qui ont modifié le flux du processus (délais, erreurs, escalades).'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'gateway-invalid-route',
'fr',
'Erreur au niveau de la passerelle %0. La variable fournie %1 contient une route invalide : %2'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'gateway-merge-error',
'fr',
'Erreur interne de traitement lors de la fusion au nivau de la passerelle sur le sous-flux %0'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'gateway-no-route',
'fr',
'Aucune instruction de routage de passerelle n''est fournie dans la variable %0 et le modèle ne contient pas de route par défaut.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'gateway-too-many-defaults',
'fr',
'Plus d''une route par défaut spécifiée dans le modèle pour la passerelle %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'link-no-catch',
'fr',
'Impossible de trouver le lien correspondant à l''événement %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'link-too-many-catches',
'fr',
'Plus d''un lien correspond à l''événement %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'logging-instance-event',
'fr',
'Flows - Erreur interne lors de l''enregistrement d''un évènement d''instance'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'logging-step-event',
'fr',
'Flows - Erreur interne lors de l''enregistrement d''un évènement d''étape'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'logging-variable-event',
'fr',
'Flows - Erreur interne lors de l''enregistrement d''un évènement de variable'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'process-lock-timeout',
'fr',
'Les objets de traitement pour %0 sont actuellement verrouillés par un autre utilisateur. Réessayez plus tard.'
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
'Processus %0 : la tâche %1 a échoué en raison d''une erreur PL/SQL - voir le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_requested_stop',
'fr',
'Processus %0: Tâche %1 arrêt du traitement demandé - voir le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timeout_locking_subflow',
'fr',
'Impossible de verrouiller le sous-flux %0, celui-ci est actuellement verrouillé par un autre utilisateur. Veuillez réessayer ultérieurement.'
);
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-already-placed',
'fr',
'Réservation déjà effectuée sur la prochaine tâche pour vous.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-by-other_user',
'fr',
'La réservation pour %0 est impossible. L''étape est déjà réservée par un autre utilisateur (%1).'
); 
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-failed-not-found',
'fr',
'La réservation pour %0 est impossible. Sous-flux %0 dans le processus %1 non trouvé.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-incorrect-step-key',
'fr',
'La tâche n''est plus en cours, elle est probablement déjà terminée.  Veuillez rafraîchir votre liste de tâches.'
); 
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-lock-timeout',
'fr',
'Sous-flux actuellement verrouillé (non reservé) par un autre utilisteur. Veuillez réessayez ultérieurement.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'reservation-release-not-found',
'fr',
'La libération de la réservation est impossible. Sous-flux %0 dans le processus %1 non trouvé.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'restart-no-error',
'fr',
'Aucune erreur courante trouvée. Vérifiez votre diagramme de processus.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-already-running',
'fr',
'Vous avez essayé de démarrer un processus (id %0) qui est déjà en cours d''exécution.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-multiple-already-running',
'fr',
'Vous avez essayé de démarrer un processus (id %0) dont plusieurs copies sont déjà en cours d''exécution.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-multiple-start-events',
'fr',
'Vous avez défini plusieurs événements de début. Assurez-vous que votre diagramme n''a qu''un seul événement de début.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-no-start-event',
'fr',
'Aucun événement de début n''est défini dans le diagramme de flux.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-not-created',
'fr',
'Vous avez essayé de démarrer un processus (id %0) qui n''existe pas.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'start-type-unsupported',
'fr',
'Type d''événement de début non pris en charge (%0). Seuls les événements de début standard et de type minuteur sont actuellement pris en charge.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'startwork-sbfl-not-found',
'fr',
'Début de l''enregistrement des temps de travail non réussi. Le sous-flux %0 du processus %1 est introuvable.'
);
  
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'step-key-incorrect',
'fr',
'Cette étape de processus a déjà été réalisée.  (Clé d''étape fournie incorrecte %0, clé d''étape attendue %1).'
); 

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'subProcess-no-start',
'fr',
'Impossible de trouver l''événement de début de sous-processus.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'subProcess-too-many-starts',
'fr',
'Plus d''un événement de sous-processus trouvé.'
);
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer-broken',
'fr',
'Minuteur %0 cycle %4 en erreur dans le processus %1 , sous-flux : %2.  Voir error_info.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer-cycle-unsupported',
'fr',
'Minuteur de type cycle défini pour l''objet %0 n''est pas pris en charge actuellement.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer-incomplete-definition',
'fr',
'Définition incomplète du minuteur de l''objet %0. Type: %1; Valeur1: %2 Valeur2: %3 Valeur3: %4'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer-lock-timeout',
'fr',
'La minuteur du sous-flux %0 est verrouillé par un autre utilisateur. Veuillez réessayer ultérieurement.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer-object-not-found',
'fr',
'Objet avec minuteur non trouvé dans get_timer_definition. Sous-flux %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timers-lock-timeout',
'fr',
'Les minuteurs pour le processus %0 sont verrouillés par un autre utilisateur. Veuillez réessayer ultérieurement.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var-set-error',
'fr',
'Erreur de création de la variable de processus %0 pour l''ID de processus %1.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var-get-error',
'fr',
'Erreur de récupération de la variable de processus %0 pour l''ID de processus %1.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var-update-error',
'fr',
'Erreur de mise à jour de la variable de processus %0 pour l''ID de processus %1.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var-delete-error',
'fr',
'Erreur de suppression de la variable de processus %0 pour l''ID de processus %1.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var-lock-error',
'fr',
'Erreur de verrouillage de la variable de processus %0 pour l''ID de processus %1.'
); 

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_datatype',
'fr',
'Erreur de définition de la variable de processus. Type de données incorrect pour la variable %0. Erreur SQL affichée dans le débogage.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_date_format',
'fr',
'Erreur de définition de la variable de processus %1 : format de date incorrect (Sous-flux : %0, Valeur : %3.)'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_object_not_found',
'fr',
'Erreur interne dans la recherche de l''objet %0 dans process_expressions. Erreur SQL affichée dans le débogage'
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
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_static_general',
'fr',
'Erreur de définition de la variable de processus %2 %1 dans le processus id %0. Voir l''erreur dans le journal des événements.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'version-no-rel-or-draft-v0',
'fr',
'Impossible de trouver le diagramme publié ou la version 0 du diagramme - veuillez spécifier une version ou un numéro de diagramme.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
 'timer_definition_error',
 'fr',
 'Erreur lors de l''analyse de la définition du minuteur dans le processus %0, sous-flux %1. Type de minuteur : %2, Définition: %3'
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
'Le modèle a changé, annuler les changements?'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'wrong-default-workspace',
'fr',
'Processus %0 : la tâche de service %1 a échoué : l''espace de travail par défaut défini dans le paramètre de configuration n''est pas valide.'
 );

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'workspace-not-found',
'fr',
'Processus %0 : la tâche de service %1 a échoué : impossible de trouver l''espace de travail associé à l''aplication définie dans le diagramme. Veuillez vérifier le modèle.'
 );
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-no-from',
'fr',
'Processus %0 : la tâche de service %1 a échoué : attribut De non défini. Veuillez vérifier le modèle.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-no-to',
'fr',
'Processus %0 : la tâche de service %1 a échoué : attribut To non défini. Veuillez vérifier le modèle.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-no-template',
'fr',
'Processus %0 : la tâche de service %1 a échoué : attribut Template non défini. Veuillez vérifier le modèle.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-no-body',
'fr',
'Processus %0 : la tâche de service %1 a échoué : attribut Corps non défini. Veuillez vérifier le modèle.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-failed',
'fr',
'Processus %0 : la tâche de service %1 a échoué : voir le journal pour plus de détail et vérifier le modèle.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'email-placeholder-json-invalid',
'fr',
'Processus %0: la tâche de service %1 a échoué : l''objet JSON des espaces réservés est invalide. Veuillez vérifier le modèle.'
);

/*
-- Flows for APEX - engine_messages_es.sql
--
-- Engine Messages for language code "es"
--
-- Generated by language-load-generator
-- Generated on Wed, 09 Oct 2024 11:34:25 GMT
*/

set define '^'
whenever sqlerror exit rollback;

PROMPT >> Loading Engine Messages for Language "es"
declare
  c_load_lang constant varchar2(10) := 'es';
begin
  delete
    from flow_messages
   where fmsg_lang = c_load_lang;

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-business-ref-null', c_load_lang, q'[Error al crear la tarea de aprobación - La referencia de negocio o la clave primaria del sistema de registro no deben ser nulas.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'due-on-interval-error', c_load_lang, q'[Error al evaluar el vencimiento. La expresión de intervalo no es válida. Intervalo: %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'due-on-error', c_load_lang, q'[Error al evaluar el vencimiento.  La expresión de vencimiento no es válida.  Expresión de intervalo: %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'settings-priority-error', c_load_lang, q'[Error al evaluar la prioridad. La expresión de prioridad no es válida. Expresión: %0. En su lugar, se utiliza la prioridad 3.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-bad-scope', c_load_lang, q'[Se ha proporcionado un ámbito no válido (%0) para la variable de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'scheduler-repeat-shared-env', c_load_lang, q'[Intervalo de repetición de temporizador demasiado frecuente para el host (%0) Intervalo solicitado %1. Debe ser mayor que 1 minuto.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'archive-destination-bad-json', c_load_lang, q'[Error en el parámetro de configuración de destino de archivo. Parámetro: %0]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'msgflow-not-correlated', c_load_lang, q'[El mensaje recibido no coincide con un mensaje esperado.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'msgflow-no-longer-current-step', c_load_lang, q'[Ya se ha producido un mensaje de recepción de paso de proceso (se ha proporcionado una clave de paso incorrecta).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'feature-requires-ee', c_load_lang, q'[El procesamiento de esta función requiere la licencia Flows for APEX Enterprise Edition.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'iter_close_error', c_load_lang, q'[Error interno al procesar cierre de iteración en subflujo %0]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_sql_too_many_values', c_load_lang, q'[Error al establecer la variable de proceso %1 en el ID de proceso %0 (juego %2).  La consulta devuelve más de un valor.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_json_format', c_load_lang, q'[Error al definir la variable de proceso %1: formato JSON incorrecto (subflujo: %0, juego: %3).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'iter_lock_error', c_load_lang, q'[Error al bloquear el detalle de iteración (bucle de iteración %0 %2) para el ID de proceso %1.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'subProcess-no-start', c_load_lang, q'[No se ha encontrado el evento de inicio de subproceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'subProcess-too-many-starts', c_load_lang, q'[Se ha encontrado más de un inicio de subproceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer-broken', c_load_lang, q'[Temporizador %0 Ejecución %4 interrumpido en proceso %1 , subflujo : %2. Consulte error_info.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer-cycle-unsupported', c_load_lang, q'[El temporizador de ciclo definido para el objeto %0 no está soportado actualmente.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer-incomplete-definition', c_load_lang, q'[Definiciones de temporizador incompletas para el objeto %0. Tipo: %1; Value1: %2 Value2: %3  Value3: %4]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer-lock-timeout', c_load_lang, q'[El temporizador para el subflujo %0 está bloqueado actualmente por otro usuario. Vuelva a intentarlo más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer-object-not-found', c_load_lang, q'[No se ha encontrado el objeto con temporizador en get_timer_definition. Subflujo %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timers-lock-timeout', c_load_lang, q'[Los temporizadores del proceso %0 están bloqueados actualmente por otro usuario. Vuelva a intentarlo más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-set-error', c_load_lang, q'[Error al crear la variable de proceso %0 para el ID de proceso %1 en el ámbito %2.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-get-error', c_load_lang, q'[Error al obtener la variable de proceso %0 para el ID de proceso %1 en el ámbito %2.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-update-error', c_load_lang, q'[Error al actualizar la variable de proceso %0 para el ID de proceso %1 en el ámbito %2.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-delete-error', c_load_lang, q'[Error al suprimir la variable de proceso %0 para el ID de proceso %1 en el ámbito %2.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var-lock-error', c_load_lang, q'[Error al bloquear la variable de proceso %0 para el ID de proceso %1 en el ámbito %2.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_datatype', c_load_lang, q'[Error al definir la variable de proceso. Tipo de dato incorrecto para la variable %0. Error SQL mostrado en la salida de depuración.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_date_format', c_load_lang, q'[Error al definir la variable de proceso %1: Formato de fecha incorrecto (subflujo: %0, juego: %3).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_object_not_found', c_load_lang, q'[Error interno al buscar el objeto %0 en process_expressions. Error SQL mostrado en la salida de depuración.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_plsql_error', c_load_lang, q'[Subflujo: %0 Error en expresión %2 para variable: %1]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_sql_no_data', c_load_lang, q'[Error al establecer la variable de proceso %1 en el ID de proceso %0 (juego %2). No se han encontrado datos en la consulta.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_sql_other', c_load_lang, q'[Error al establecer la variable de proceso %1 en el ID de proceso %0 (juego %2). Error SQL mostrado en el log de eventos.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_sql_too_many_rows', c_load_lang, q'[Error al establecer la variable de proceso %1 en el ID de proceso %0 (juego %2). La consulta devuelve varias filas.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'var_exp_static_general', c_load_lang, q'[Error al establecer la variable de proceso %1 en el ID de proceso %0 (juego %2). Consulte el error en el log de eventos.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'version-no-rel-or-draft-v0', c_load_lang, q'[No se ha encontrado el diagrama publicado o la versión de borrador 0 del diagrama; especifique una versión o diagram_id]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'version-not-found', c_load_lang, q'[No se ha encontrado la versión de diagrama especificada. Compruebe la especificación de versión.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timer_definition_error', c_load_lang, q'[Error al analizar la definición de temporizador en el proceso %0, subflujo %1. Tipo de temporizador: %2, Definición: %3]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-model-no-version', c_load_lang, q'[Versión no definida.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-parsing-json-variables', c_load_lang, q'[Error durante el análisis de variables de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-route-not-define', c_load_lang, q'[Gateway no está definido para direccionamiento.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-gateway-not-exist', c_load_lang, q'[La definición de gateway no existe para este flujo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-no-instance-subflow-id', c_load_lang, q'[No se ha podido obtener el ID de instancia de flujo ni el ID de subflujo para gestionar el paso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-wrong-variable-number', c_load_lang, q'[Número incorrecto de elementos APEX o variables de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-wrong-variable-type', c_load_lang, q'[Una o más variables de proceso son de un tipo diferente al definido en JSON.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-variable-not-a-number', c_load_lang, q'[%0 no es un número válido.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-variable-not-a-date', c_load_lang, q'[%0 no es una fecha válida.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-invalid-json', c_load_lang, q'[El JSON proporcionado no es válido.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-modeler-id-not-found', c_load_lang, q'[No se encontraron datos. Compruebe si existe un diagrama con el ID proporcionado.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-unexpected-error', c_load_lang, q'[Error inesperado. Póngase en contacto con el administrador.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-diagram-not-parsable', c_load_lang, q'[No se ha podido analizar el diagrama.<br />Revise el diagrama para asegurarse de que está soportado.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-diagram-saved', c_load_lang, q'[¡Cambios guardados!]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-diagram-has-changed', c_load_lang, q'[El modelo ha cambiado. ¿Descartar los cambios?]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'wrong-default-workspace', c_load_lang, q'[Proceso %0: fallo de ServiceTask %1: el espacio de trabajo por defecto definido en el parámetro de configuración no es válido.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'workspace-not-found', c_load_lang, q'[Proceso %0: ServiceTask %1 ha fallado: no se ha encontrado el espacio de trabajo asociado al ID de aplicación definido en el diagrama. Compruebe el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-no-from', c_load_lang, q'[Proceso %0: ServiceTask %1 ha fallado: el atributo "De" y el remitente de correo electrónico por defecto no están definidos. Compruebe el modelo o el parámetro de configuración.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-no-to', c_load_lang, q'[Proceso %0: fallo de ServiceTask %1: atributo "A" no definido. Compruebe el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-no-template', c_load_lang, q'[Proceso %0: fallo de ServiceTask %1: atributo "Plantilla" no definido. Compruebe el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-no-body', c_load_lang, q'[Proceso %0: fallo de ServiceTask %1: atributo "Cuerpo" no definido. Compruebe el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-failed', c_load_lang, q'[Proceso %0: ServiceTask %1 no ha podido ver el log de errores y comprobar el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'email-placeholder-json-invalid', c_load_lang, q'[Proceso %0: ServiceTask %1 marcador de posición JSON es invalid.Please comprobar el modelo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plugin-multiple-rows', c_load_lang, q'[Se han encontrado varias filas. Active el valor 'Activar actividades de llamada' en los atributos del plugin del visor.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-cancelation-error', c_load_lang, q'[Error al intentar cancelar la tarea de flujo de trabajo de APEX (task_id: %1 ) para el paso de proceso: %0.)]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-not-supported', c_load_lang, q'[El uso de la función Flujo de trabajo de APEX necesita Oracle APEX v%0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-not-found', c_load_lang, q'[No se ha encontrado la tarea de flujo de trabajo de APEX %0 en flujos para el proceso APEX]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-on-multiple-steps', c_load_lang, q'[La tarea de flujo de trabajo de APEX %0 se ha encontrado asociada a más de un flujo para el paso de proceso de APEX.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-not-current-step', c_load_lang, q'[La tarea de flujo de trabajo de APEX %0 no es el paso actual del proceso. El paso puede haber finalizado todo listo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-invalid-result-var', c_load_lang, q'[La variable de proceso de resultado de tarea de flujo de trabajo de APEX no está definida o no es válida.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-creation-error', c_load_lang, q'[Error al crear la tarea de flujo de trabajo de APEX %0 en la aplicación %1. Consulte la depuración para obtener más información.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-priority-error', c_load_lang, q'[Error al evaluar la prioridad. La prioridad debe estar entre 1 y 5. Prioridad: %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-task-multiple-processes', c_load_lang, q'[Error al crear la sesión de APEX. El diagrama BPMN contiene varios objetos de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'call-diagram-not-callable', c_load_lang, q'[Ha intentado llamar a un diagrama %0 marcado como no llamable.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'ITE-unsupported-type', c_load_lang, q'[Se ha encontrado un tipo de evento de devolución intermedio no soportado actualmente en %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'apex-session-params-not-set', c_load_lang, q'[Los detalles de conexión asíncrona para el objeto %0 se deben definir en variables de proceso, detalles de conexión asíncrona de diagrama o detalles de configuración del sistema.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'async-invalid_params', c_load_lang, q'[No se puede crear una conexión asíncrona para el objeto %0. Nombre de usuario no válido en la aplicación especificada]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'async-no-username', c_load_lang, q'[No se puede crear una conexión asíncrona para el objeto %0. Se debe especificar el nombre de usuario en la variable de proceso, el diagrama de proceso o la configuración del sistema.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'async-no-appid', c_load_lang, q'[No se puede crear una conexión asíncrona para el objeto %0. El ID de aplicación se debe especificar en la variable de proceso, el diagrama de proceso o la configuración del sistema.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'async-no-pageid', c_load_lang, q'[No se puede crear una conexión asíncrona para el objeto %0. El ID de página se debe especificar en la variable de proceso, el diagrama de proceso o la configuración del sistema.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'boundary-event-child-lock-to', c_load_lang, q'[Subflujos o temporizadores de límite secundario de %0 bloqueados actualmente por otro usuario. Vuelva a intentar la transacción más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'boundary-event-no-catch-found', c_load_lang, q'[No se ha encontrado ningún boundaryEvent de tipo %0 para capturar el evento.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'boundary-event-too-many', c_load_lang, q'[Se ha encontrado más de un %0 boundaryEvent en el subproceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'eng_handle_event_int', c_load_lang, q'[Error interno del motor de flujo: Proceso %0 Subflujo %1 Módulo %2 Actual %4 Etiqueta actual %3]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'engine-unsupported-object', c_load_lang, q'[Error de modelo: el siguiente paso del modelo BPMN del proceso utiliza un objeto %0 no soportado]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'engine-util-prcs-not-found', c_load_lang, q'[Error de aplicación: No se ha encontrado el ID de proceso %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'engine-util-sbfl-not-in-prcs', c_load_lang, q'[Error de aplicación: el ID de subflujo proporcionado ( %0 ) existe pero no es secundario del ID de proceso proporcionado ( %1 ).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'engine-util-sbfl-not-found', c_load_lang, q'[No se ha encontrado el ID de subflujo proporcionado (%0). Compruebe los eventos de proceso que han cambiado el flujo de proceso (tiempos de espera, errores, escaladas).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'gateway-invalid-route', c_load_lang, q'[Error en gateway %0. La variable proporcionada %1 contiene una ruta no válida: %2]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'gateway-merge-error', c_load_lang, q'[Error interno al procesar el gateway de fusión en el subflujo %0]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'gateway-no-route', c_load_lang, q'[No se ha proporcionado ninguna instrucción de direccionamiento de gateway en la variable %0 y el modelo no contiene ninguna ruta por defecto.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'gateway-bad-expression', c_load_lang, q'[Expresión de enrutamiento de gateway incorrecta. Esto puede ocurrir si intenta enlazar una variable con dos puntos incrustados (:).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'gateway-too-many-defaults', c_load_lang, q'[Se ha especificado más de una ruta por defecto en el modelo para el gateway %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'link-no-catch', c_load_lang, q'[No se ha encontrado el evento de captura de enlace coincidente denominado %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'link-too-many-catches', c_load_lang, q'[Hay más de un evento de captura de enlace coincidente denominado %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'logging-instance-event', c_load_lang, q'[Flujos: error interno al registrar un evento de instancia]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'logging-step-event', c_load_lang, q'[Flujos - Error interno al registrar un evento de paso]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'logging-variable-event', c_load_lang, q'[Flujos: error interno al registrar un evento variable]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'process-lock-timeout', c_load_lang, q'[Objetos de proceso para %0 bloqueados actualmente por otro usuario. Vuelva a intentarlo más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'more_than_1_forward_path', c_load_lang, q'[Se encontraron más de 1 ruta hacia adelante cuando solo se permiten 1.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'no_next_step_found', c_load_lang, q'[No se ha encontrado ningún paso siguiente en el subflujo %0. Compruebe el diagrama de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plsql_script_failed', c_load_lang, q'[Proceso %0: la tarea %1 ha fallado debido a un error de PL/SQL. Consulte el log de eventos.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'plsql_script_requested_stop', c_load_lang, q'[Proceso %0: la tarea %1 ha solicitado la detención del procesamiento. Consulte el log de eventos.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'timeout_locking_subflow', c_load_lang, q'[No se puede bloquear el subflujo %0 porque está bloqueado actualmente por otro usuario. Vuelva a intentarlo más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-already-placed', c_load_lang, q'[Ya ha realizado la reserva en la siguiente tarea.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-by-other_user', c_load_lang, q'[Reserva incorrecta para %0. El paso ya está reservado por otro usuario (%1).]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-failed-not-found', c_load_lang, q'[Reserva para %2 incorrecta. No se ha encontrado el subflujo %0 en el proceso %1.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-incorrect-step-key', c_load_lang, q'[La tarea ya no está actualizada, probablemente ya se haya completado. Refresque la bandeja de entrada.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-lock-timeout', c_load_lang, q'[Subflujo bloqueado actualmente (no reservado) por otro usuario. Intente realizar su reserva de nuevo más tarde.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'reservation-release-not-found', c_load_lang, q'[Liberación de reserva incorrecta. No se ha encontrado el subflujo %0 en el proceso %1.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'restart-no-error', c_load_lang, q'[No se ha encontrado ningún error actual. Compruebe el diagrama de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-already-running', c_load_lang, q'[Ha intentado iniciar un proceso (ID %0) que ya se está ejecutando.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-diagram-calls-itself', c_load_lang, q'[Ha intentado iniciar un proceso con un diagrama %0 que incluye una llamada callActivity.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-multiple-already-running', c_load_lang, q'[Intentó iniciar un proceso (ID %0) con varias copias ya en ejecución.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-multiple-start-events', c_load_lang, q'[Tiene varios eventos iniciales definidos. Asegúrese de que el diagrama solo tiene un evento de inicio.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-no-start-event', c_load_lang, q'[No se ha definido ningún evento inicial en el diagrama de flujo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-not-created', c_load_lang, q'[Ha intentado iniciar un proceso (ID %0) que no existe.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'start-type-unsupported', c_load_lang, q'[Tipo de evento de inicio no admitido (%0). Actualmente solo se admite Ninguno (estándar), Mensaje y Evento de inicio de temporizador.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'settings-procvar-no-prcs', c_load_lang, q'[La configuración no puede especificar una variable de proceso sin un ID de proceso.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'diagram-archive-has-instances', c_load_lang, q'[Ha intentado archivar un diagrama que tiene instancias en ejecución.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'logging-diagram-event', c_load_lang, q'[Flujos: error interno al registrar un evento de diagrama.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'log-archive-error', c_load_lang, q'[Error al archivar el resumen de instancias para la instancia de proceso %0]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'msgflow-lock-timeout-subflow', c_load_lang, q'[El receptor de mensajes no puede bloquear el subflujo. Vuelva a intentarlo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'settings-error', c_load_lang, q'[Error al evaluar la configuración. La expresión no es válida. Expresión: %0.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'msgflow-endpoint-not-supported', c_load_lang, q'[MessageFlow El punto final especificado ( %0 ) no está soportado.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'msgflow-lock-timeout-msub', c_load_lang, q'[Suscripción de mensaje bloqueada por otro usuario. Vuelva a intentarlo.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'startwork-sbfl-not-found', c_load_lang, q'[Registro de hora de inicio de trabajo incorrecto. No se ha encontrado el subflujo %0 en el proceso %1.]' );
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values ( 'step-key-incorrect', c_load_lang, q'[Ya se ha producido este paso de proceso. (Se ha proporcionado una clave de paso incorrecta %0 mientras se esperaba la clave de paso %1).]' );
  
  commit;
end;
/

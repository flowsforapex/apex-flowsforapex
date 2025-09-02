function initApp() {
  apex.jQuery( window ).on( "theme42ready", function () {
    apex.theme42.util.configAPEXMsgs( {
      autoDismiss: true,
      duration: 5000,
    } );
  } );
}

function addClassesToParents(pSelector, pParentSelector, pClasses) {
  apex
    .jQuery( pSelector )
    .parents( pParentSelector )
    .addClass( pClasses );
}

function childrenAttributeToArray(container, children, attribute){
  return apex
           .jQuery(container)
           .find(children)
           .map( function ( item ) {
             return apex.jQuery( this ).attr( attribute );
           })
           .toArray();
}

function getflowInstanceData(action, element){
  let el = element;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(element).closest("button");
  }
  return {
    "x01": action,
    "x02": apex.jQuery( el ).attr("data-prcs")
  };
}

function getBulkFlowInstanceData(action){
  return {
    "x01": action,
    "f01": childrenAttributeToArray( "#flow-instances .a-IRR-tableContainer", 'input[name="f01"]:checked', "data-prcs" )
  };
}

function getMessageData(action, element){
  let el = element;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(element).closest("button");
  }
  return {
    "x01": action,
    "x02": apex.jQuery( el ).attr("data-message"),
    "x03": apex.jQuery( el ).attr("data-key"),
    "x04": apex.jQuery( el ).attr("data-value")
  };
}

function getRepositionSubflowData(action, element){
  let el = element;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(element).closest("button");
  }
  return {
    "x01": action,
    "x02": apex.jQuery( el ).attr("data-prcs"),
    "x03": apex.jQuery( el ).attr("data-sbfl"),
    "x04": apex.jQuery( el ).attr("data-new-task"),
    "x05": apex.jQuery( el ).attr("data-comment")
  };
}


function getSubflowData(action, element){
  let el = element;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(element).closest("button");
  }
  return {
    "x01": action,
    "x02": apex.jQuery( el ).attr("data-prcs"),
    "x03": apex.jQuery( el ).attr("data-sbfl"),
    "x04": apex.jQuery( el ).attr("data-key")
  };
}

function getBulkSubflowData(action){
  return {
    "x01": action,
    "f01": childrenAttributeToArray( "#subflows .a-IRR-tableContainer", 'input[name="f02"]:checked', "data-prcs" ),
    "f02": childrenAttributeToArray( "#subflows .a-IRR-tableContainer", 'input[name="f02"]:checked', "value" ),
    "f03": childrenAttributeToArray( "#subflows .a-IRR-tableContainer", 'input[name="f02"]:checked', "data-key" )
  };
}

function openModalConfirmWithComment( action, element, confirmMessageKey, titleKey ){
  let el = element;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(element).closest("button");
  }
  var pageId = apex.item("pFlowStepId").getValue();
  apex.item( "P" + pageId + "_COMMENT" ).setValue( "" );
  apex.item( "P" + pageId + "_CONFIRM_TEXT" ).setValue( apex.lang.getMessage( confirmMessageKey ) );
  apex.jQuery( "#confirm-btn" ).attr( "data-action", action );
  apex
    .jQuery( "#confirm-btn" )
    .attr( "data-prcs", apex.jQuery( el ).attr( "data-prcs" ) );
  apex
    .jQuery( "#confirm-btn" )
    .attr( "data-sbfl", apex.jQuery( el ).attr( "data-sbfl" ) );
  apex
    .jQuery( "#confirm-btn" )
    .attr( "data-key", apex.jQuery( el ).attr( "data-key" ) );
  apex
    .jQuery( "#confirm-btn" )
    .attr( "data-name", apex.jQuery( el ).attr( "data-name" ) );
  apex.theme.openRegion( "instance_action_dialog" );
  apex.util.getTopApex().jQuery(".f4a-dynamic-title").closest(".ui-dialog-content").dialog('option', 'title', apex.lang.getMessage( titleKey ));
}

function getConfirmComment(){
  var pageId = apex.item("pFlowStepId").getValue();
  return apex.item( "P" + pageId + "_COMMENT" ).getValue();
}

function sendToServer(dataToSend, options = {}){
  var result = apex.server.process( "AJAX_HANDLER", dataToSend);
  result
    .done( function ( data ) {
      if ( !data.success ) {
        if (data.message !== undefined && data.message !== null) {
          apex.message.clearErrors();

          apex.message.showErrors([
              {
                  type:       "error",
                  location:   "page",
                  message:    data.message,
                  unsafe:     false
              }
          ]);
        } else {
          apex.debug.error( "Something went wrong..." );
        }
      } else {
        if ( options.messageKey !== undefined ){
          apex.message.showPageSuccess( apex.lang.getMessage( options.messageKey ) );
        }
        if (options.ItemsToSet !== undefined && apex.jQuery.isEmptyObject(options.ItemsToSet) === false ){
          Object.keys(options.ItemsToSet).forEach(function(itemName) {
            apex.item(itemName).setValue(options.ItemsToSet[itemName]);
          });
        }
        if ( options.refreshRegion !== undefined && options.refreshRegion.length > 0 ) {
          options.refreshRegion.forEach(function(name) {
            if (apex.region(name).type === "InteractiveReport") {
              var currentRowsPerPage = apex.jQuery("#" + name + "_ir").data().apexInteractiveReport.options.currentRowsPerPage;
              var currentPage = apex.jQuery("#" + name +" .a-IRR-pagination-label").text().split('-')[0].trim();
              apex.jQuery("#" + name + "_ir").data().apexInteractiveReport._paginate("pgR_min_row=" + currentPage + "max_rows=" + currentRowsPerPage + "rows_fetched=" + currentRowsPerPage );
            } else {
              apex.region(name).refresh();
            }
          })
        }
        if ( data.url !== undefined && options.redirect !== false ){
          apex.navigation.redirect( data.url );
        }
        if ( ( options.reloadPage !== undefined && options.reloadPage ) || ( data.reloadPage !== undefined && data.reloadPage ) ) {
          window.location.reload();
        }
      }
    })
    .fail( function ( jqXHR, textStatus, errorThrown ) {
        console.log('error');
      apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );
    } ); 
}

function downloadAsSVG(){
    apex
    .region( "flow-monitor" )
    .downloadAsSVG();
}

function startFlowInstance( action, element ) {
  var data = getflowInstanceData(action, element);
  var options = {};
  options.messageKey = "APP_INSTANCE_STARTED";
  options.reloadPage = apex.item("pFlowStepId").getValue() === "8" ? true : false;
  options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
  options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": data.x02, "P10_PRCS_NAME": apex.jQuery( element ).attr("data-name") };
  sendToServer(data, options);
}

function bulkStartFlowInstance( action ) {
  var data = getBulkFlowInstanceData(action);
  var options = {};
  options.messageKey = "APP_INSTANCE_STARTED";
  options.refreshRegion = ["flow-instances", "flow-monitor"];
  sendToServer(data, options);
}

function resetFlowInstance(action, element){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getflowInstanceData(action, element);
    data.x03 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_RESET";
    options.reloadPage = apex.item("pFlowStepId").getValue() === "8" ? true : false;
    options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
    options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": data.x02, "P10_PRCS_NAME": apex.jQuery( element ).attr("data-name") };
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RESET_INSTANCE", "APP_RESET_INSTANCE" );
  }
}

function bulkResetFlowInstance(action, element){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getBulkFlowInstanceData(action);
    data.x02 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_RESET";
    options.refreshRegion = ["flow-instances", "flow-monitor"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RESET_INSTANCE", "APP_RESET_INSTANCE" );
  }
}

function terminateFlowInstance(action, element) {
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getflowInstanceData(action, element);
    data.x03 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_TERMINATED";
    options.reloadPage = apex.item("pFlowStepId").getValue() === "8" ? true : false;
    options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
    options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": data.x02, "P10_PRCS_NAME": apex.jQuery( element ).attr("data-name") };
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_TERMINATE_INSTANCE", "APP_TERMINATE_INSTANCE" );
  }
}

function bulkTerminateFlowInstance(action, element) {
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getBulkFlowInstanceData(action);
    data.x02 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_TERMINATED";
    options.refreshRegion = ["flow-instances", "flow-monitor"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_TERMINATE_INSTANCE", "APP_TERMINATE_INSTANCE" );
  } 
}

function suspendFlowInstance(action, element) {
  if (apex.items.P0_LICENSE_EDITION.value === "enterprise") {
    if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
        apex.theme.closeRegion( "instance_action_dialog" );
        var data = getflowInstanceData(action, element);
        data.x03 = getConfirmComment();

        var options = {};
        options.messageKey = "APP_INSTANCE_SUSPENDED";
        options.reloadPage = apex.item("pFlowStepId").getValue() === "8" ? true : false;
        options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
        options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": data.x02, "P10_PRCS_NAME": apex.jQuery( element ).attr("data-name") };
        sendToServer(data, options);
    } else {
        openModalConfirmWithComment( action, element, "APP_CONFIRM_SUSPEND_INSTANCE", "APP_SUSPEND_INSTANCE" );
    }
  } else {
    apex.theme.openRegion("enterprise-edition-dg");
  }
  
}

function resumeFlowInstance(action, element) {
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getflowInstanceData(action, element);
    data.x03 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_RESUMED";
    options.reloadPage = apex.item("pFlowStepId").getValue() === "8" ? true : false;
    options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
    options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": data.x02, "P10_PRCS_NAME": apex.jQuery( element ).attr("data-name") };
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RESUME_INSTANCE", "APP_RESUME_INSTANCE" );
  }
}

function deleteFlowInstance( action, element ){ 
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getflowInstanceData(action, element);
    data.x03 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_DELETED";
    options.refreshRegion = apex.item("pFlowStepId").getValue() === "10" ? ["flow-instances", "flow-monitor"] : [];
    options.ItemsToSet = apex.item("pFlowStepId").getValue() === "8" ? {} : {"P10_PRCS_ID": "", "P10_PRCS_NAME": ""};
    options.redirect = apex.item("pFlowStepId").getValue() === "10" ? false : true;
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_DELETE_INSTANCE", "APP_DELETE_INSTANCE" );
  }
}

function bulkDeleteFlowInstance( action, element ){ 
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getBulkFlowInstanceData(action);
    data.x02 = getConfirmComment();

    var options = {};
    options.messageKey = "APP_INSTANCE_DELETED";
    options.refreshRegion = ["flow-instances", "flow-monitor"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_DELETE_INSTANCE", "APP_DELETE_INSTANCE" );
  }
}

function redirectToFlowInstanceAudit( action, element ){
  var data = getflowInstanceData(action, element);
  data.x03 = apex.jQuery( element ).attr("data-name");
  if ( apex.item("pFlowStepId").getValue() === "10" ) {
    apex.item("P10_PRCS_ID").setValue(data.x02);
    apex.item("P10_PRCS_NAME").setValue( data.x03 );
    data.pageItems = ["P10_PRCS_ID", "P10_PRCS_NAME"];
  }
  var options = {};
  options.refreshRegion = apex.item("pFlowStepId").getValue() === "8" ? [] : ["flow-instances", "flow-monitor"];
  sendToServer(data, options);
}

function redirectToFlowInstanceDetail( action, element ){
  var data = getflowInstanceData(action, element);
  apex.item("P10_PRCS_ID").setValue(data.x02);
  apex.item("P10_PRCS_NAME").setValue( apex.jQuery( element ).attr("data-name") );
  data.pageItems = ["P10_PRCS_ID", "P10_PRCS_NAME"];
  sendToServer(data);
}

function redirectToFlowDiagram( action, element ){
  var data = getflowInstanceData(action, element);
  data.x02 = apex.jQuery( element ).attr("data-dgrm");
  sendToServer(data);
}

function redirectToFlowDiagramTaskStatus(action, element){
  var data = getflowInstanceData(action, element);
  data.x02 = apex.jQuery( element ).attr("data-dgrm");
  sendToServer(data);
}

function initViewer( prcsId, prcsName, displaySetting ) {
  if (prcsName !== "")
      apex.jQuery( "#flow-monitor_heading" ).text( apex.lang.formatMessage("APP_VIEWER_TITLE_PROCESS_SELECTED", prcsName) );
    else
       apex.jQuery( "#flow-monitor_heading" ).text( apex.lang.getMessage("APP_VIEWER_TITLE_NO_PROCESS") );

  if ( prcsId !== "" && displaySetting === "window") {
    redirectToMonitor(prcsId);
  }
}

function redirectToMonitor(prcsId) {
  var data = {};
  data.x01 = "view-flow-instance";
  data.x02 = prcsId;
  sendToServer(data);
}

function getVariableErrors(){
  var errors = [];

  if ( apex.item("P8_PROV_VAR_NAME").isEmpty() ) {
    errors.push(
      {
        type:       "error",
        location:   [ "inline" ],
        pageItem:   "P8_PROV_VAR_NAME",
        message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_NAME_EMPTY" ),
        unsafe:     false
      }
    );
  }

  if ( apex.item("P8_PROV_VAR_TYPE").isEmpty() ) {
    errors.push(
      {
        type:       "error",
        location:   [ "inline" ],
        pageItem:   "P8_PROV_VAR_TYPE",
        message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_TYPE_EMPTY" ),
        unsafe:     false
      }
    );
  } else {
    var varType = apex.item("P8_PROV_VAR_TYPE").getValue();
    if ( varType === "VARCHAR2" ) {
      if ( apex.item("P8_PROV_VAR_VC2").isEmpty() ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_VC2",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_VALUE_EMPTY" ),
            unsafe:     false
          }
        );
      } 
    } else if ( varType === "NUMBER" ) {
      if ( apex.item("P8_PROV_VAR_NUM").isEmpty() ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_NUM",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_VALUE_EMPTY" ),
            unsafe:     false
          }
        );
      } else {
        if ( apex.item("P8_PROV_VAR_NUM_VALID").getValue() === "N" ) {
          errors.push(
            {
              type:       "error",
              location:   [ "inline" ],
              pageItem:   "P8_PROV_VAR_NUM",
              message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_NUM_NOT_NUMBER" ),
              unsafe:     false
            }
          );
        }
      }
    } else if ( varType === "DATE" ) {
      if ( apex.item("P8_PROV_VAR_DATE").isEmpty() ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_DATE",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_VALUE_EMPTY" ),
            unsafe:     false
          }
        );
      } else if ( apex.item("P8_PROV_VAR_DATE_VALID").getValue() === "N" ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_DATE",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_DATE_NOT_DATE" ),
            unsafe:     false
          }
        );
      } 
    } else if ( varType === "TIMESTAMP WITH TIME ZONE" ) {
      if ( apex.item("P8_PROV_VAR_TSTZ").isEmpty() ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_TSTZ",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_VALUE_EMPTY" ),
            unsafe:     false
          }
        );
      } else if ( apex.item("P8_PROV_VAR_TSTZ_VALID").getValue() === "N" ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_TSTZ",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_TSTZ_NOT_TSTZ" ),
            unsafe:     false
          }
        );
      } 
    } else if ( varType === "CLOB" || varType === "JSON" ) {
      if ( apex.item("P8_PROV_VAR_CLOB").isEmpty() ) {
        errors.push(
          {
            type:       "error",
            location:   [ "inline" ],
            pageItem:   "P8_PROV_VAR_CLOB",
            message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_VALUE_EMPTY" ),
            unsafe:     false
          }
        );
      } 
      if (varType === "JSON") {
        try {
          JSON.parse(apex.item("P8_PROV_VAR_CLOB").getValue());
        } catch (e) {
          errors.push(
            {
              type:       "error",
              location:   [ "inline" ],
              pageItem:   "P8_PROV_VAR_CLOB",
              message:    apex.lang.getMessage( "APP_ERR_PROV_VAR_INVALID_JSON" ),
              unsafe:     false
            }
          );
        }
      }
    } 
  }
  return errors;
}

function getGatewayErrors(){
  var errors = [];

  if (apex.item("P8_SELECT_OPTION").getValue() === "single" && apex.item("P8_CONNECTION").getValue().length > 1) {
      errors = [
          {
              type:       "error",
              location:   [ "inline" ],
              pageItem:   "P8_CONNECTION",
              message:    apex.lang.getMessage( "APP_ERR_GATEWAY_ONLY_ONE_CONNECTION" ),
              unsafe:     false
          }
      ];
  }
  if (apex.item("P8_CONNECTION").getValue().length === 0) {
      errors = [
          {
              type:       "error",
              location:   [ "inline" ],
              pageItem:   "P8_CONNECTION",
              message:    apex.lang.getMessage( "APP_ERR_GATEWAY_CONNECTION_EMPTY" ),
              unsafe:     false
          }
      ];
  }
  return errors;
}

function addProcessVariable(action, focusElement){ 
  var el = focusElement;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(focusElement).closest("button");
  }
  var gatewayRoute = apex.jQuery(el).attr("data-gateway-route") === "true" ? true : false;
  var dialogId = gatewayRoute ? "gateway_selector" : "variable_dialog" ;

  if ( apex.jQuery( "#" + dialogId ).dialog( "isOpen" ) ) {
    var errors = gatewayRoute ? getGatewayErrors() : getVariableErrors();
    if ( errors.length === 0 ) {
      apex.theme.closeRegion( dialogId );

      var data = {}, options = {};
      data.x01 = action;
      data.x02 = apex.item("P8_PRCS_ID").getValue();
      data.x06 = apex.item("P8_PROV_SCOPE").getValue();
      if ( gatewayRoute ) {
        data.x03 = apex.item("P8_GATEWAY").getValue() + ":route";
        data.x04 = 'VARCHAR2';
        var selectOption = apex.item("P8_SELECT_OPTION").getValue();
        var route = selectOption === "single" ? apex.item("P8_CONNECTION").getValue() : apex.item("P8_CONNECTION").getValue().join(":");
        data.x05 = selectOption = route;
      } else {
        data.x03 = apex.item("P8_PROV_VAR_NAME").getValue();
        data.x04 = apex.item("P8_PROV_VAR_TYPE").getValue();
        if ( data.x04 === "VARCHAR2" ) {
          data.x05 = apex.item("P8_PROV_VAR_VC2").getValue();
        } else if ( data.x04 === "NUMBER" ) {
          data.x05 = apex.item("P8_PROV_VAR_NUM").getValue();
        } else if ( data.x04 === "DATE" ) {
          data.x05 = apex.item("P8_PROV_VAR_DATE").getValue();
        } else if ( data.x04 === "TIMESTAMP WITH TIME ZONE" ) {
          data.x05 = apex.item("P8_PROV_VAR_TSTZ").getValue();
        } else if ( data.x04 === "CLOB" || data.x04 === "JSON") {
          var chunkedClob = apex.server.chunk(apex.item("P8_PROV_VAR_CLOB").getValue());
          if ( !Array.isArray( chunkedClob ) ) {
            chunkedClob = [chunkedClob];
          }
          data.f01 = chunkedClob;
        } 

      }
      
      options.messageKey = "APP_PROCESS_VARIABLE_ADDED";
      options.refreshRegion = ["process-variables"];

      sendToServer(data, options);
    } else {
      apex.message.clearErrors();
      apex.message.showErrors( errors );
    }
  } else {
    if (gatewayRoute) {
      apex.item( "P8_GATEWAY" ).setValue( "" );
      apex.item("P8_GATEWAY").enable();
      apex.item( "P8_CONNECTION" ).setValue( "" );
      apex.jQuery( "#unselect_btn" ).hide();
      apex.jQuery( "#select_btn" ).hide();
      apex.jQuery( "#add-prov-var-route-btn" ).show();
      apex.jQuery( "#save-prov-var-route-btn" ).hide();
    } else {
      apex.item( "P8_PROV_VAR_VC2"  ).setValue();
      apex.item( "P8_PROV_VAR_NUM"  ).setValue();
      apex.item( "P8_PROV_VAR_DATE" ).setValue();
      apex.item( "P8_PROV_VAR_CLOB" ).setValue();
      apex.item( "P8_PROV_VAR_NAME" ).setValue();
      apex.item( "P8_PROV_VAR_NAME" ).enable();
      apex.item( "P8_PROV_VAR_TYPE" ).setValue("VARCHAR2");
      apex.item( "P8_PROV_VAR_TYPE" ).enable();
      apex.item( "P8_PROV_SCOPE"    ).setValue(apex.items.P8_DIAGRAM_LEVEL.isEmpty() ? "0" : apex.items.P8_DIAGRAM_LEVEL.value );
      apex.item( "P8_PROV_SCOPE"    ).enable();
      apex.jQuery( "#add-prov-var-btn" ).show();
      apex.jQuery( "#save-prov-var-btn" ).hide();
    }
    apex.message.clearErrors();
    apex.theme.openRegion( dialogId );
  }
}

function updateProcessVariable(action, focusElement){
  var el = focusElement;
  if ( el.type === undefined || el.type !== "button") {
    el = apex.jQuery(focusElement).closest("button");
  }
  var gatewayRoute = apex.jQuery(el).attr("data-gateway-route") === "true" ? true : false;
  var dialogId = gatewayRoute ? "gateway_selector" : "variable_dialog" ;

  if ( apex.jQuery( "#" + dialogId ).dialog( "isOpen" ) ) {
    var errors = gatewayRoute ? getGatewayErrors() : getVariableErrors();
    if ( errors.length === 0 ) {
      apex.theme.closeRegion( dialogId );

      var data = {}, options = {};
      data.x01 = action;
      data.x02 = apex.item("P8_PRCS_ID").getValue();
      data.x06 = apex.item("P8_PROV_SCOPE").getValue();
      if ( gatewayRoute ) {
        data.x03 = apex.item("P8_GATEWAY").getValue() + ":route";
        data.x04 = 'VARCHAR2';
        var selectOption = apex.item("P8_SELECT_OPTION").getValue();
        var route = selectOption === "single" ? apex.item("P8_CONNECTION").getValue() : apex.item("P8_CONNECTION").getValue().join(":");
        data.x05 = selectOption = route;
      } else {
        data.x03 = apex.item("P8_PROV_VAR_NAME").getValue();
        data.x04 = apex.item("P8_PROV_VAR_TYPE").getValue();
        if ( data.x04 === "VARCHAR2" ) {
          data.x05 = apex.item("P8_PROV_VAR_VC2").getValue();
        } else if ( data.x04 === "NUMBER" ) {
          data.x05 = apex.item("P8_PROV_VAR_NUM").getValue();
        } else if ( data.x04 === "DATE" ) {
          data.x05 = apex.item("P8_PROV_VAR_DATE").getValue();
        } else if ( data.x04 === "TIMESTAMP WITH TIME ZONE" ) {
          data.x05 = apex.item("P8_PROV_VAR_TSTZ").getValue();
        } else if ( data.x04 === "CLOB" || data.x04 === "JSON") {
          var chunkedClob = apex.server.chunk(apex.item("P8_PROV_VAR_CLOB").getValue());
          if ( !Array.isArray( chunkedClob ) ) {
            chunkedClob = [chunkedClob];
          }
          data.f01 = chunkedClob;
        } 
      }
      
      options.messageKey = "APP_PROCESS_VARIABLE_SAVED";
      options.refreshRegion = ["process-variables"];

      sendToServer(data, options);
    } else {
      apex.message.showErrors( errors );
    }
  } else {
    var varName = apex.jQuery(focusElement).attr("data-name");
    var varType = apex.jQuery(focusElement).attr("data-type");
    var varScope = apex.jQuery(focusElement).attr("data-scope");
    apex.server.process( 
      "GET_VARIABLE", 
      {
        x01: apex.item("P8_PRCS_ID").getValue(),
        x02: varName,
        x03: varType,
        x04: varScope
      }, 
      {
        success: function( data )  {
          if (data.success){
            if (gatewayRoute) {
              apex.message.clearErrors();
              apex.theme.openRegion("gateway_selector");
              apex.jQuery("#unselect_btn").hide();
              apex.jQuery("#select_btn").hide();
              apex.jQuery("#add-prov-var-route-btn").hide();
              apex.jQuery("#save-prov-var-route-btn").show();
              apex.item("P8_GATEWAY").setValue(varName.split(":")[0]);
              setTimeout(function(){ 
                apex.item("P8_CONNECTION").setValue(data.vc2_value); 
                apex.item("P8_GATEWAY").disable();
              }, 300);
            } else {
              apex.item("P8_PROV_VAR_NAME").setValue(varName);
              apex.item("P8_PROV_VAR_NAME").disable();
              apex.item("P8_PROV_VAR_TYPE").setValue(varType);
              apex.item("P8_PROV_VAR_TYPE").disable();
              apex.item("P8_PROV_SCOPE").setValue(varScope);
              apex.item("P8_PROV_SCOPE").disable();
              apex.theme.openRegion("variable_dialog");
              if ( varType === "VARCHAR2") {
                apex.item("P8_PROV_VAR_VC2").setValue(data.vc2_value);
                apex.item("P8_PROV_VAR_NUM").setValue("");
                apex.item("P8_PROV_VAR_DATE").setValue("");
                apex.item("P8_PROV_VAR_TSTZ").setValue("");
                apex.item("P8_PROV_VAR_CLOB").setValue("");
                apex.item("P8_PROV_VAR_VC2").setFocus();
              } else if ( varType === "NUMBER") {
                apex.item("P8_PROV_VAR_NUM").setValue(data.num_value);
                apex.item("P8_PROV_VAR_VC2").setValue("");
                apex.item("P8_PROV_VAR_DATE").setValue("");
                apex.item("P8_PROV_VAR_TSTZ").setValue("");
                apex.item("P8_PROV_VAR_CLOB").setValue("");
                apex.item("P8_PROV_VAR_NUM").setFocus();
              } else if ( varType === "DATE") {
                apex.item("P8_PROV_VAR_DATE").setValue(data.date_value);
                apex.item("P8_PROV_VAR_TSTZ").setValue("");
                apex.item("P8_PROV_VAR_VC2").setValue("");
                apex.item("P8_PROV_VAR_NUM").setValue("");
                apex.item("P8_PROV_VAR_CLOB").setValue("");
                apex.item("P8_PROV_VAR_DATE").setFocus();
              } else if ( varType === "TIMESTAMP WITH TIME ZONE") {
                apex.item("P8_PROV_VAR_TSTZ").setValue(data.tstz_value);
                apex.item("P8_PROV_VAR_VC2").setValue("");
                apex.item("P8_PROV_VAR_NUM").setValue("");
                apex.item("P8_PROV_VAR_DATE").setValue("");
                apex.item("P8_PROV_VAR_CLOB").setValue("");
                apex.item("P8_PROV_VAR_TSTZ").setFocus();
              } else if ( varType === "CLOB" || varType === "JSON") {
                apex.item("P8_PROV_VAR_CLOB").setValue(varType === "CLOB" ? data.clob_value : data.json_value);
                apex.item("P8_PROV_VAR_VC2").setValue("");
                apex.item("P8_PROV_VAR_NUM").setValue("");
                apex.item("P8_PROV_VAR_DATE").setValue("");
                apex.item("P8_PROV_VAR_TSTZ").setValue("");
                apex.item("P8_PROV_VAR_CLOB").setFocus();
              } 
              apex.jQuery("#add-prov-var-btn").hide();
              apex.jQuery("#save-prov-var-btn").show(); 
            }
            apex.theme.openRegion( dialogId );
          }
        },
        error: function( jqXHR, textStatus, errorThrown ) {
          console.log(jqXHR);
        }
      } 
    );
  }
}

function deleteProcessVariable(action, focusElement){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_DELETE_PROCESS_VARIABLE"), function( okPressed ) {
    if( okPressed ) {
      var data = {}, options = {};
      data.x01 = action;
      data.x02 = apex.jQuery(focusElement).attr("data-prcs");
      data.x03 = apex.jQuery(focusElement).attr("data-name");
      data.x04 = apex.jQuery(focusElement).attr("data-scope");
      
      options.messageKey = "APP_PROCESS_VARIABLE_DELETED";
      options.refreshRegion = ["process-variables"];
      sendToServer(data, options);
    }
  });
}

function openProcessVariableHistory( action, element ){
  var prcsId = apex.jQuery(element).attr("data-prcs");
  var varName = apex.jQuery(element).attr("data-name");
  var varNameUC = apex.jQuery(element).attr("data-name-uc");
  var varScope = apex.jQuery(element).attr("data-scope");
  var data = {};
  data.x01 = action;
  data.x02 = prcsId;
  data.x03 = varName;
  data.x04 = varNameUC;
  data.x04 = varScope;
  sendToServer(data);
}

function bulkDeleteProcessVariable(action){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_DELETE_PROCESS_VARIABLE"), function( okPressed ) {
    if( okPressed ) {
      var data = {}, options = {};
      data.x01 = action;
      data.f01 = childrenAttributeToArray("#process-variables .a-IRR-tableContainer", 'input[name="f03"]:checked', "data-prcs");
      data.f02 = childrenAttributeToArray("#process-variables .a-IRR-tableContainer", 'input[name="f03"]:checked', "value");
      data.f03 = childrenAttributeToArray("#process-variables .a-IRR-tableContainer", 'input[name="f03"]:checked', "data-scope");
      
      options.messageKey = "APP_PROCESS_VARIABLE_DELETED";
      options.refreshRegion = ["process-variables"];
      sendToServer(data, options);
    }
  });
}

function completeStep( action, element ){
  var data = getSubflowData(action, element);
  var options = {};
  options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
  sendToServer(data, options);
}

function bulkCompleteStep( action ){
  var data = getBulkSubflowData( action );
  var options = {};
  options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
  sendToServer(data, options);
}

function restartStep( action, element){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getSubflowData(action, element);
    data.x05 = getConfirmComment();
    var options = {};
    options.messageKey = "APP_SUBLFOW_RESTARTED";
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "task-list"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RESTART_STEP", "APP_TITLE_RESTART_STEP" );
  }
}

function forceNextStep( action, element){
  if (apex.items.P0_LICENSE_EDITION.value === "enterprise"){
    if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
        apex.theme.closeRegion( "instance_action_dialog" );
        var data = getSubflowData(action, element);
        data.x05 = getConfirmComment();
        var options = {};
        options.messageKey = "APP_FORCE_NEXT_STEP";
        options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
        sendToServer(data, options);
    } else {
        openModalConfirmWithComment( action, element, "APP_CONFIRM_FORCE_NEXT_STEP", "APP_TITLE_FORCE_NEXT_STEP" );
    }
  } else {
    apex.theme.openRegion("enterprise-edition-dg");
  }
  
}

function bulkRestartStep( action, element ){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getBulkSubflowData( action );
    data.x02 = getConfirmComment();
    
    var options = {};
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "task-list"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RESTART_STEP", "APP_TITLE_RESTART_STEP" );
  }
}

function openReservationDialog(action, element){
  apex.item( "P8_RESERVATION" ).setValue( "" );
  apex.jQuery( "#reserve-step-btn" ).attr( "data-action", action );
  apex
    .jQuery( "#reserve-step-btn" )
    .attr( "data-prcs", apex.jQuery( element ).attr( "data-prcs" ) );
  apex
    .jQuery( "#reserve-step-btn" )
    .attr( "data-sbfl", apex.jQuery( element ).attr( "data-sbfl" ) );
  apex
    .jQuery( "#reserve-step-btn" )
    .attr( "data-key", apex.jQuery( element ).attr( "data-key" ) );
  apex.theme.openRegion( "reservation_dialog" );
}

function reserveStep( action, element ){
  if ( apex.jQuery( "#reservation_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "reservation_dialog" );
    var data = getSubflowData(action, element);
    data.x05 = apex.item("P8_RESERVATION").getValue();

    var options = {};
    options.refreshRegion = ["subflows", "task-list"];
    sendToServer(data, options);
  } else {
    openReservationDialog( action, element );
  }
}

function bulkReserveStep( action ){
  if ( apex.jQuery( "#reservation_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "reservation_dialog" );
    var data = getBulkSubflowData( action );
    data.x02 = apex.item("P8_RESERVATION").getValue();
    
    var options = {};
    options.refreshRegion = ["subflows", "task-list"];
    sendToServer(data, options);
  } else {
    openReservationDialog( action, null );
  }
}

function releaseStep( action, element ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_RELEASE_STEP"), function( okPressed ) {
    if( okPressed ) {
      var data = getSubflowData(action, element);
      
      var options = {};
      options.refreshRegion = ["subflows", "task-list"];
      sendToServer(data, options);
    }
  });
}

function bulkReleaseStep( action ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_RELEASE_STEP"), function( okPressed ) {
    if( okPressed ) {
      var data = getBulkSubflowData(action);
      
      var options = {};
      options.refreshRegion = ["subflows", "task-list"];
      sendToServer(data, options);
    }
  });
}

function rescheduleTimer ( action, element ){
  if ( apex.jQuery( "#reschedule_timer_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "reschedule_timer_dialog" );
    var data = getSubflowData(action, element);
    data.x05 = apex.item("P8_RESCHEDULE_TIMER_NOW").getValue();
    data.x06 = apex.item( "P8_RESCHEDULE_TIMER_AT" ).getValue();
    data.x07 = apex.item("P8_RESCHEDULE_TIMER_COMMENT").getValue();
       
    var options = {};
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
    sendToServer(data, options);
  } else {
    openRescheduleTimerDialog( action, element );
  }
}

function bulkRescheduleTimer ( action ){
  if ( apex.jQuery( "#reschedule_timer_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "reschedule_timer_dialog" );
    var data = getBulkSubflowData(action);
    data.x02 = apex.item("P8_RESCHEDULE_TIMER_NOW").getValue();
    data.x03 = apex.item( "P8_RESCHEDULE_TIMER_AT" ).getValue();
    data.x04 = apex.item("P8_RESCHEDULE_TIMER_COMMENT").getValue();
       
    var options = {};
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
    sendToServer(data, options);
  } else {
    openRescheduleTimerDialog( action, null );
  }
}

function deleteOnResume( action, element ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_DELETE_ON_RESUME"), function( okPressed ) {
    if( okPressed ) {
      var data = getSubflowData(action, element);
      
      var options = {};
      options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events"];
      sendToServer(data, options);
    }
  });
}


function returnToPriorGateway( action, element ){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getSubflowData(action, element);
    data.x05 = getConfirmComment();
    var options = {};
    options.messageKey = "APP_RETURN_PRIOR_GATEWAY";
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "task-list"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_RETURN_PRIOR_GATEWAY", "APP_TITLE_RETURN_PRIOR_GATEWAY" );
  }
}

function repositionSubflow( action, element ) {
  if ( apex.jQuery( "#reposition_subflow_dialog" ).dialog( "isOpen" ) ) {
    var data = getRepositionSubflowData( action, element );
    data.x04 = apex.item("P8_REPOSITION_NEW_TASK").getValue();
    data.x05 = apex.item( "P8_REPOSITION_COMMENT" ).getValue();

    apex.theme.closeRegion( "reposition_subflow_dialog" );
    var options = {};
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
    sendToServer(data, options);
  } 
  else {
    openRepositionSubflowDialog( action, element );
  }
  
};

function openRepositionSubflowDialog(action, element){
  apex
    .jQuery( "#reposition-subflow-btn" )
    .attr( "data-prcs", apex.jQuery( element ).attr( "data-prcs" ) );
  apex
    .jQuery( "#reposition-subflow-btn" )
    .attr( "data-sbfl", apex.jQuery( element ).attr( "data-sbfl" ) );
  apex
    .jQuery( "#reposition-subflow-btn" )
    .attr( "data-new-step", apex.jQuery( element ).attr( "data-new-step" ) );
  apex
    .jQuery( "#reposition-subflow-btn" )
    .attr( "data-comment", apex.jQuery( element ).attr( "data-comment" ) );
  apex.item("P8_REWIND_SBFL_ID").setValue( apex.jQuery( element ).attr("data-sbfl") );
  apex.item("P8_REPOSITION_TEXT").setValue( apex.lang.getMessage( "APP_CONFIRM_REPOSITION_SUBFLOW" ) );
  apex.theme.openRegion( "reposition_subflow_dialog" );
}

function rewindLastStep( action, element ){
  if ( apex.jQuery( "#instance_action_dialog" ).dialog( "isOpen" ) ) {
    apex.theme.closeRegion( "instance_action_dialog" );
    var data = getSubflowData(action, element);
    data.x05 = getConfirmComment();
    var options = {};
    options.messageKey = "APP_REWIND_LAST_STEP";
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "task-list"];
    sendToServer(data, options);
  } else {
    openModalConfirmWithComment( action, element, "APP_CONFIRM_REWIND_LAST_STEP", "APP_TITLE_REWIND_LAST_STEP" );
  }
}

function rewindSubProcess( action, element ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_REWIND_SUBPROCESS"), function( okPressed ) {
    if( okPressed ) {
      var data = getSubflowData(action, element);
      
      var options = {};
      options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events"];
      sendToServer(data, options);
    }
  });
}

function rewindCallActivity( action, element ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_REWIND_CALL_ACTIVITY"), function( okPressed ) {
    if( okPressed ) {
      var data = getSubflowData(action, element);
      
      var options = {};
      options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events"];
      sendToServer(data, options);
    }
  });
}

function rewindLinkEvent( action, element ){
  apex.message.confirm( apex.lang.getMessage("APP_CONFIRM_REWIND_LINK_EVENT"), function( okPressed ) {
    if( okPressed ) {
      var data = getSubflowData(action, element);
      
      var options = {};
      options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events"];
      sendToServer(data, options);
    }
  });
}

function receiveMessage( action, element ) {
  if ( apex.jQuery( "#receive_message_dialog" ).dialog( "isOpen" ) ) {
    var data = getMessageData( action, element );
    var chunkedClob = apex.server.chunk(apex.item("P8_PAYLOAD").getValue());
    if ( !Array.isArray( chunkedClob ) ) {
      chunkedClob = [chunkedClob];
    }
    data.f01 = chunkedClob;
    apex.theme.closeRegion( "receive_message_dialog" );
    var options = {};
    options.refreshRegion = ["subflows", "flow-monitor", "process-variables", "flow-instance-events", "message-subscriptions", "task-list"];
    sendToServer(data, options);
  } 
  else {
    openReceiveMessageDialog( action, element );
  }
  
};

function openReceiveMessageDialog(action, element){
  apex
    .jQuery( "#receive-message-btn" )
    .attr( "data-message", apex.jQuery( element ).attr( "data-message" ) );
  apex
    .jQuery( "#receive-message-btn" )
    .attr( "data-key", apex.jQuery( element ).attr( "data-key" ) );
  apex
    .jQuery( "#receive-message-btn" )
    .attr( "data-value", apex.jQuery( element ).attr( "data-value" ) );
  apex.theme.openRegion( "receive_message_dialog" );
}

function openRescheduleTimerDialog(action, element){
  apex.item( "P8_RESCHEDULE_TIMER_NOW" ).setValue( "Y" );
  apex.item( "P8_RESCHEDULE_TIMER_AT" ).setValue( "" );
  apex.item("P8_RESCHEDULE_TIMER_COMMENT").setValue("");
  apex.jQuery( "#reschedule-timer-btn" ).attr( "data-action", action );
  apex
    .jQuery( "#reschedule-timer-btn" )
    .attr( "data-prcs", apex.jQuery( element ).attr( "data-prcs" ) );
  apex
    .jQuery( "#reschedule-timer-btn" )
    .attr( "data-sbfl", apex.jQuery( element ).attr( "data-sbfl" ) );
  apex
    .jQuery( "#reschedule-timer-btn" )
    .attr( "data-key", apex.jQuery( element ).attr( "data-key" ) );
  apex.theme.openRegion( "reschedule_timer_dialog" );
}

function markAsCurrent(prcsId){
  var processRows = apex.jQuery( "#flow-instances td" );
  var selectedProcess = prcsId;
  var currentSelector =
    "button.flow-instance-actions-btn[data-prcs=" +
    selectedProcess +
    "]";
  var currentRow = processRows.has( currentSelector );
  processRows.removeClass( "current-process" );
  currentRow.parent().children().addClass( "current-process" );
}

function refreshViewer(prcsId){
  if ( apex.item("P10_DISPLAY_SETTING").getValue() === "window" ) {
    redirectToMonitor(prcsId);
  } else {
    apex.region("flow-monitor").refresh();
  }
}

function viewFlowInstance( action, element ){
  var selectedProcess = apex.jQuery( element ).attr( "data-prcs" );
  var currentName = apex.jQuery( element ).attr( "data-name" );
  apex.item("P10_PRCS_ID").setValue(selectedProcess);
  apex.item("P10_PRCS_NAME").setValue(currentName);
  markAsCurrent(selectedProcess);
  refreshViewer(selectedProcess);
}

function initActions(){
  //Define actions
  $( function () {
    var pageId = apex.item("pFlowStepId").getValue();
    if (pageId === "2") {
      apex.actions.add( [
        {
          name: "new-flow-version",
          action: function ( event, focusElement ) {
            var dgrmId = apex.jQuery( focusElement ).attr( "data-dgrm" );
            apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
            apex.item( "P2_BULK_ACTION" ).setValue( "N" );
            apex.theme.openRegion( "new_version_reg" );
          },
        },
        {
          name: "bulk-new-flow-version",
          action: function ( event, focusElement ) {
            var dgrmId = apex
              .jQuery( "input[name=f01]:checked" )
              .map( function () {
                return apex.jQuery( this ).attr( "value" );
              } )
              .get()
              .join( ":" );
            apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
            apex.item( "P2_BULK_ACTION" ).setValue( "Y" );
            apex.theme.openRegion( "new_version_reg" );
          },
        },
        {
          name: "bulk-copy-flow",
          action: function ( event, focusElement ) {
            var dgrmId = apex
              .jQuery( "input[name=f01]:checked" )
              .map( function () {
                return apex.jQuery( this ).attr( "value" );
              } )
              .get()
              .join( ":" );
            apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
            apex.item( "P2_BULK_ACTION" ).setValue( "Y" );
            apex.theme.openRegion( "copy_flow_reg" );
          },
        },
        {
          name: "copy-flow",
          action: function ( event, focusElement ) {
            var dgrmId = apex.jQuery( focusElement ).attr( "data-dgrm" );
            apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
            apex.item( "P2_BULK_ACTION" ).setValue( "N" );
            apex.theme.openRegion( "copy_flow_reg" );
          },
        },
        {
          name: "instances-per-step",
          action: function ( event, focusElement ) {
            redirectToFlowDiagramTaskStatus(this.name, focusElement);
          },
        }
      ] );
    }

    if ( pageId === "7") {
      apex.actions.add( [
        {
          name: "delete-flow-diagram",
          action: function ( event, focusElement ) {
            apex.theme.openRegion("delete_reg");
          },
        }
      ] );
    }

    if ( pageId === "8") {
      apex.actions.add( [
        {
          name: "complete-step",
          action: function ( event, focusElement ) {
            completeStep( this.name, focusElement );
          },
        },
        {
          name: "bulk-complete-step",
          action: function ( event, focusElement ) {
            bulkCompleteStep( this.name );
          }
        },
        {
          name: "restart-step",
          action: function ( event, focusElement ) {
            restartStep( this.name, focusElement);
          }
        },
        {
          name: "force-next-step",
          action: function ( event, focusElement ) {
            forceNextStep( this.name, focusElement);
          }
        },
        {
          name: "bulk-restart-step",
          action: function ( event, focusElement ) {
            bulkRestartStep( this.name, focusElement );
          }
        },
        {
          name: "reserve-step",
          action: function ( event, focusElement ) {
            reserveStep( this.name, focusElement );
          }
        },
        {
          name: "bulk-reserve-step",
          action: function ( event, focusElement ) {
            bulkReserveStep( this.name );
          }
        },
        {
          name: "release-step",
          action: function ( event, focusElement ) {
            releaseStep( this.name, focusElement );
          }
        },
        {
          name: "bulk-release-step",
          action: function ( event, focusElement ) {
            bulkReleaseStep( this.name );
          }
        },
        {
          name: "add-process-variable",
          action: function ( event, focusElement ) {
            addProcessVariable( 'process-variable', focusElement );
          }
        },
        {
          name: "update-process-variable",
          action: function ( event, focusElement ) {
            updateProcessVariable( 'process-variable', focusElement );
          }
        },
        {
          name: "delete-process-variable",
          action: function ( event, focusElement ) {
            deleteProcessVariable( this.name, focusElement );
          }
        },
        {
          name: "process-variable-history",
          action: function ( event, focusElement ) {
            openProcessVariableHistory( this.name, focusElement );
          }
        },
        {
          name: "bulk-delete-process-variable",
          action: function ( event, focusElement ) {
            bulkDeleteProcessVariable( this.name );
          }
        },
        {
          name: "reschedule-timer",
          action: function( event, focusElement ) {
            rescheduleTimer( this.name, focusElement );
          }
        },
        {
          name: "bulk-reschedule-timer",
          action: function( event, focusElement ) {
            bulkRescheduleTimer( this.name);
          }
        },
        {
          name: "receive-message",
          action: function ( event, focusElement ) {
            receiveMessage( this.name, focusElement );
          }
        },
        {
          name: "delete-on-resume",
          action: function( event, focusElement ) {
            deleteOnResume( this.name, focusElement );
          }
        },
        {
          name: "return-prev-gw-resume",
          action: function( event, focusElement ) {
            returnToPriorGateway( this.name, focusElement );
          }
        },
        {
          name: "reposition-subflow",
          action: function( event, focusElement ) {
            repositionSubflow( this.name, focusElement );
          }
        },
        {
          name: "rewind-last-step",
          action: function( event, focusElement ) {
            rewindLastStep( this.name, focusElement );
          }
        },
        {
          name: "rewind-subprocess-on-resume",
          action: function( event, focusElement ) {
            rewindSubProcess( this.name, focusElement );
          }
        },
        {
          name: "rewind-call-activity-on-resume",
          action: function( event, focusElement ) {
            rewindCallActivity( this.name, focusElement );
          }
        },
        {
          name: "rewind-link-event-on-resume",
          action: function( event, focusElement ) {
            rewindLinkEvent( this.name, focusElement );
          }
        }
      ] );
    }

    if (pageId === "10") {
      apex.actions.add( 
        [ 
          {
            name: "view-flow-instance",
            action: function ( event, focusElement ) {
              viewFlowInstance( this.name, focusElement);
            },
          },
          {
            name: "bulk-start-flow-instance",
            action: function ( event, focusElement ) {
              bulkStartFlowInstance( this.name );
            },
          },
          {
            name: "bulk-reset-flow-instance",
            action: function ( event, focusElement ) {
              bulkResetFlowInstance( this.name, focusElement );
            },
          },
          {
            name: "bulk-terminate-flow-instance",
            action: function ( event, focusElement ) {
              bulkTerminateFlowInstance( this.name, focusElement );
            },
          },
          {
            name: "bulk-delete-flow-instance",
            action: function ( event, focusElement ) {
              bulkDeleteFlowInstance( this.name, focusElement);
            },
          },
          {
            name: "open-flow-instance-details",
            action: function ( event, focusElement ) {
              redirectToFlowInstanceDetail( this.name, focusElement );
            }
          }
        ]
      );
    }

    if (pageId === "8" || pageId === "10") {
      apex.actions.add([
        {
          name: "choose-setting",
          get: function () {
            return apex.item( "P" + pageId + "_DISPLAY_SETTING" ).getValue();
          },
          set: function ( value ) {
            apex.item( "P" + pageId + "_DISPLAY_SETTING" ).setValue( value );
            var prcsId = apex.item( "P" + pageId + "_PRCS_ID" ).getValue();
  
            switch ( value ) {
              case "row":
                apex.jQuery( "#col1" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );
                apex.jQuery( "#col2" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );
  
                apex.jQuery( "#flow-monitor" ).show();
                apex.region( "flow-monitor" ).refresh();
               
                break;
              case "column":
                apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( [ "col-12", "col-end" ] );
                apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( [ "col-12", "col-start" ] );
                apex.jQuery( "#col2" ).appendTo( apex.jQuery( "#col1" ).parent() );
  
                apex.jQuery( "#flow-monitor" ).show();
                apex.region( "flow-monitor" ).refresh();
                
                break;
              case "window":
                apex.jQuery( "#flow-monitor" ).hide();
                apex.jQuery( "#col1" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );
                apex.jQuery( "#col2" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );

                if ( prcsId !== "" ) {
                  redirectToMonitor( prcsId );
                }
                break;
            }
          },
          choices: [],
        },
        {
          name: "start-flow-instance",
          action: function ( event, focusElement ) {
            startFlowInstance( this.name, focusElement);
          }
        },
        {
          name: "reset-flow-instance",
          action: function ( event, focusElement ) {
            resetFlowInstance( this.name, focusElement );
          }
        },
        {
          name: "terminate-flow-instance",
          action: function ( event, focusElement ) {
            terminateFlowInstance( this.name, focusElement );
          }
        },
        {
          name: "delete-flow-instance",
          action: function ( event, focusElement ) {
            deleteFlowInstance( this.name, focusElement );
          }
        },
        {
          name: "suspend-flow-instance",
          action: function ( event, focusElement ) {
            suspendFlowInstance( this.name, focusElement );
          }
        },
        {
          name: "resume-flow-instance",
          action: function ( event, focusElement ) {
            resumeFlowInstance( this.name, focusElement );
          }
        },
        {
          name: "download-as-svg",
          action: function ( event, focusElement ) {
            downloadAsSVG();
          }
        },
        {
          name: "flow-instance-audit",
          action: function ( event, focusElement ) {
            redirectToFlowInstanceAudit( this.name, focusElement );
          }
        }
      ]);

      apex.actions.set(
        "choose-setting",
        apex.item( "P" + pageId + "_DISPLAY_SETTING" ).getValue()
      );
  
      setTimeout( function () {
        var action, label;
        action = apex.actions.lookup( "choose-setting" );
        action.choices = action.label.split( "|" ).map( function ( c, i ) {
          return { label: c, value: ["row", "column", "window"][i] };
        } );
        delete action.label;
        apex.actions.update( "choose-setting" );
      }, 1 );
    }

    apex.actions.add( [
      {
        name: "edit-flow-diagram",
        action: function ( event, focusElement ) {
          redirectToFlowDiagram( this.name, focusElement);
        }
      }
    ] 
    );
  } );
}

function initPage2() {
  initApp();
  initActions();

  apex.jQuery( window ).on( "theme42ready", function () {
    $( "#parsed_drgm table th.a-IRR-header--group" )
      .attr( "colspan", "6" )
      .after(
        '<th colspan="6" class="a-IRR-header a-IRR-header--group" id="instances_column_group_heading" style="text-align: center;">Instances</th>'
      );

    $( ".a-IRR-headerLabel, .a-IRR-headerLink" ).each( function () {
      var status = $( this ).children("i").data("status");
      if ( status == "created" ) {
        $( this ).parent().addClass( "ffa-color--created" );
      } else if ( status == "completed" ) {
        $( this ).parent().addClass( "ffa-color--completed" );
      } else if ( status == "suspended" ) {
        $( this ).parent().addClass( "ffa-color--suspended" );
      } else if ( status == "running" ) {
        $( this ).parent().addClass( "ffa-color--running" );
      } else if ( status == "terminated" ) {
        $( this ).parent().addClass( "ffa-color--terminated" );
      } else if ( status == "error" ) {
        $( this ).parent().addClass( "ffa-color--error" );
      }
    } );

    if ($("th.a-IRR-header--group").length > 0) {
      $("th").each(function(i){
          if ( apex.jQuery(this).attr("id") === undefined) {
              apex.jQuery(this).find('input[type="checkbox"]').hide();
              apex.jQuery(this).find('button#header-action').hide();
          } else {
              apex.jQuery(this).addClass("u-alignMiddle");
          }
      });
    }

    $( "#header_actions_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      if (
        apex
          .jQuery( "#parsed_drgm_ir .a-IRR-tableContainer" )
          .find( 'input[type="checkbox"]:checked' ).length === 0
      ) {
        menuItems = menuItems.map( function ( item ) {
          if ( item.action !== "refresh" ) {
            item.disabled = true;
          }
          return item;
        } );
      } else {
        menuItems = menuItems.map( function ( item ) {
          if ( item.action !== "refresh" ) {
            item.disabled = false;
          }
          return item;
        } );

        apex
          .jQuery( "#parsed_drgm_ir .a-IRR-tableContainer" )
          .find( 'input[type="checkbox"]:checked' )
          .each( function () {
            var name = $( this ).data( "name" );

            if (
              apex
                .jQuery( "#parsed_drgm_ir .a-IRR-tableContainer" )
                .find(
                  'input[type="checkbox"][data-name="' + name + '"]:checked'
                ).length > 1
            ) {
              menuItems = menuItems.map( function ( item ) {
                if (
                  item.action === "bulk-new-flow-version" ||
                  item.action === "bulk-copy-flow"
                ) {
                  item.disabled = true;
                }
                return item;
              } );
              return false;
            }
          } );
      }
      ui.menu.items = menuItems;
    } );
  } );
}

function initPage3() {
  initApp();
  apex.jQuery( window ).on( "theme42ready", function () {
    addClassesToParents('span[data-status="created"]'   , "span.t-BadgeList-wrap", "ffa-color--created");
    addClassesToParents('span[data-status="running"]'   , "span.t-BadgeList-wrap", "ffa-color--running");
    addClassesToParents('span[data-status="suspended"]' , "span.t-BadgeList-wrap", "ffa-color--suspended");
    addClassesToParents('span[data-status="completed"]' , "span.t-BadgeList-wrap", "ffa-color--completed");
    addClassesToParents('span[data-status="terminated"]', "span.t-BadgeList-wrap", "ffa-color--terminated");
    addClassesToParents('span[data-status="error"]'     , "span.t-BadgeList-wrap", "ffa-color--error");
  } );
}

function initPage4() {
  initApp();
  $(window).bind('keydown', function(event) {
    if (event.ctrlKey || event.metaKey) {
        if (String.fromCharCode(event.which).toLowerCase() === 's') {
            event.preventDefault();
            apex.region('modeler').save();
        }
    }
  });
}

function initPage7() {
  initActions();
  apex.jQuery( window ).on( "theme42ready", function () {
    addClassesToParents('span[data-status="created"]'   , "span.t-BadgeList-value", ["ffa-color--created", "instance-counter-link"]);
    addClassesToParents('span[data-status="running"]'   , "span.t-BadgeList-value", ["ffa-color--running", "instance-counter-link"]);
    addClassesToParents('span[data-status="suspended"]' , "span.t-BadgeList-value", ["ffa-color--suspended", "instance-counter-link"]);
    addClassesToParents('span[data-status="completed"]' , "span.t-BadgeList-value", ["ffa-color--completed", "instance-counter-link"]);
    addClassesToParents('span[data-status="terminated"]', "span.t-BadgeList-value", ["ffa-color--terminated", "instance-counter-link"]);
    addClassesToParents('span[data-status="error"]'     , "span.t-BadgeList-value", ["ffa-color--error", "instance-counter-link"]);

    $( "#actions_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      var dgrmStatus = apex.item("P7_DGRM_STATUS").getValue();
      var engineAppMode = apex.item("P7_ENGINE_APP_MODE").getValue();
      menuItems = menuItems.map( function ( item ) {
        if ( item.action === "delete-flow-diagram" ) {
          item.disabled = dgrmStatus === "draft" || dgrmStatus === "archived" || engineAppMode === "development" ? false : true;
        }
        return item;
      } );
      ui.menu.items = menuItems;
    } );
  } );
}

function initPage8() {
  initApp();
  initActions();

  apex.jQuery( window ).on( "theme42ready", function () {
    $( "th.a-IRR-header" ).each( function ( i ) {
      if ( apex.jQuery( this ).attr( "id" ) === undefined ) {
        apex.jQuery( this ).find( 'input[type="checkbox"]' ).hide();
        apex.jQuery( this ).find( "button#subflow-header-action" ).hide();
      } else {
        apex.jQuery( this ).addClass( "u-alignMiddle" );
      }
    } );
    
    var prcsStatus = apex.item("P8_PRCS_STATUS").getValue();
      
    if ( prcsStatus === "created" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-37-alert-text", "fa", "fa-plus-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-37-alert-bg");
    } else if ( prcsStatus === "running" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-35-alert-text", "fa", "fa-play-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-35-alert-bg");
    } else if ( prcsStatus === "suspended" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-31-alert-text", "fa", "fa-pause-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-31-alert-bg");
    } else if ( prcsStatus === "completed" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-44-alert-text", "fa", "fa-check-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-44-alert-bg");
    } else if ( prcsStatus === "terminated" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-38-alert-text", "fa", "fa-stop-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-38-alert-bg");
    } else if ( prcsStatus === "error" ) {
        apex.jQuery("#flow-instance-detail").find("span.t-Icon").addClass(["u-color-39-alert-text", "fa", "fa-exclamation-circle-o"]);
        apex.jQuery("#flow-instance-detail").find("div.t-Alert-icon").addClass("u-color-39-alert-bg");
    } 


    $( "#actions_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      var prcsStatus = apex.item("P8_PRCS_STATUS").getValue();
      menuItems = menuItems.map( function ( item ) {
        if ( item.action === "start-flow-instance" ) {
          item.disabled = prcsStatus !== "created" ? true : false;
        }
        if ( item.action === "reset-flow-instance" ) {
          item.disabled = prcsStatus !== "created" ? false : true;
        }
        if ( item.action === "terminate-flow-instance" ) {
          item.disabled =
            prcsStatus === "running" || prcsStatus === "error" ? false : true;
        }
        if ( item.action === "suspend-flow-instance" ) {
          item.disabled =
            prcsStatus === "running" || prcsStatus === "error" ? false : true;
        }  
        if ( item.action === "resume-flow-instance" ) {
          item.disabled = prcsStatus !== "suspended" ? true : false;
        }              
        return item;
      } );

      ui.menu.items = menuItems;
    } );

    $( "#subflow_header_action_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      menuItems = menuItems.map( function ( item ) {
        if ( apex.jQuery( 'input[name="f02"]:checked' ).length === 0 ) {
          item.disabled = true;
        } else {
          item.disabled = false;
          if ( item.action === "bulk-complete-step" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-status!="running"]:checked' )
                .length > 0
            ) {
              item.disabled = true;
            }
          }
          if ( item.action === "bulk-restart-step" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-status!="error"]:checked' )
                .length > 0
            ) {
              item.disabled = true;
            }
          }
          if ( item.action === "bulk-reserve-step" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-reservation!=""]:checked' )
                .length > 0
              || apex
              .jQuery( "#subflows .a-IRR-tableContainer" )
              .find( 'input[name="f02"][data-status!="running"]:checked' )
              .length > 0
            ) {
              item.disabled = true;
            }
          }
          if ( item.action === "bulk-release-step" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-reservation=""]:checked' )
                .length > 0
            ) {
              item.disabled = true;
            }
          }
          if ( item.action === "bulk-reschedule-timer" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-status!="waiting for timer"]:checked' )
                .length > 0
            ) {
              item.disabled = true;
            }
          }
        }
        return item;
      } );
      ui.menu.items = menuItems;
    } );

        apex
        .jQuery( "#subflow_row_action_menu" )
      .on( "menubeforeopen", function ( event, ui ) {
        var rowBtn = apex.jQuery( ".subflow-actions-btn.is-active" );
        var menuItems = ui.menu.items;
        var sbflStatus = rowBtn.data( "status" );
        var prcsStatus = apex.item("P8_PRCS_STATUS").getValue();
        var subflReservation = rowBtn.data( "reservation" );
        menuItems = menuItems.map( function ( item ) {
          if ( item.action === "complete-step" ) {
            item.disabled = sbflStatus === "running" ? false : true;
          }
          if ( item.action === "restart-step" ) {
            item.disabled = sbflStatus === "error" ? false : true;
          }
          if ( item.action === "force-next-step" ) {
            item.disabled = sbflStatus === "error" ? false : true;
          }
          if ( item.action === "reserve-step" ) {
            item.disabled =
              subflReservation === "" && sbflStatus === "running"
                ? false
                : true;
          }
          if ( item.action === "release-step" ) {
            item.disabled =
              subflReservation !== "" && sbflStatus === "running"
                ? false
                : true;
          }
          if ( item.action === "reschedule-timer" ) {
            item.disabled = sbflStatus === "waiting for timer" ? false : true;
          }
          if ( item.id === "rewind-sub-menu" ) {
            item.disabled = prcsStatus !== "suspended" ? true : false;
            /*It is a submenu*/
            let subMenuItems = item.menu.items;
            subMenuItems = subMenuItems.map(function(subItem){
 
                if (subItem.id === "rewind-last-step") {
                    console.log(prcsStatus);
                    console.log(sbflStatus);
                    console.log(canRewind);
                    var canRewind = prcsStatus === "suspended" && sbflStatus === "waiting at gateway";
                    subItem.disabled = !canRewind;
                }
                if ( ["delete-on-resume", "return-prev-gw-resume", "reposition-subflow", "rewind-subprocess-on-resume", "rewind-call-activity-on-resume", "rewind-link-event-on-resume"].includes(subItem.id)) {
                    subItem.disabled = prcsStatus !== "suspended" ? true : false;
                }
                return subItem;
            });
            item.menu.items = subMenuItems;   
          }
          return item;
        } );
        ui.menu.items = menuItems;
      } );

    apex
      .jQuery( "#variable_header_action_menu" )
      .on( "menubeforeopen", function ( event, ui ) {
        var menuItems = ui.menu.items;
        menuItems = menuItems.map( function ( item ) {
          if ( apex.jQuery( 'input[name="f03"]:checked' ).length === 0 ) {
            item.disabled = true;
          } else {
            item.disabled = false;
          }
          return item;
        } );
        ui.menu.items = menuItems;
      } );

  } );
}

function initPage10() {
  initApp();
  initActions();

  apex.jQuery( window ).on( "theme42ready", function () {
    if ($("th.a-IRR-header--group").length > 0) {
      $( "th.a-IRR-header" ).each( function ( i ) {
        if ( apex.jQuery( this ).attr( "id" ) === undefined ) {
          apex.jQuery( this ).find( 'input[type="checkbox"]' ).hide();
          apex.jQuery( this ).find( "button#instance-header-action" ).hide();
        } else {
          apex.jQuery( this ).addClass( "u-alignMiddle" );
        }
      } );
    }

    /*Disable download image when no instances selected*/
    $( "#actions_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      menuItems[1].disabled =
        apex.item( "P10_PRCS_ID" ).getValue() === "" ? true : false;
      ui.menu.items = menuItems;
    } );

    $( "#instance_header_action_menu" ).on(
      "menubeforeopen",
      function ( event, ui ) {
        var menuItems = ui.menu.items;
        menuItems = menuItems.map( function ( item ) {
          if ( apex.jQuery( 'input[name="f01"]:checked' ).length === 0 ) {
            item.disabled = true;
          } else {
            item.disabled = false;
            if ( item.action === "bulk-start-flow-instance" ) {
              if (
                apex
                  .jQuery( "#flow-instances .a-IRR-tableContainer" )
                  .find( 'input[name="f01"][data-status!="created"]:checked' )
                  .length > 0
              ) {
                item.disabled = true;
              }
            }
            if ( item.action === "bulk-reset-flow-instance" ) {
              if (
                apex
                  .jQuery( "#flow-instances .a-IRR-tableContainer" )
                  .find( 'input[name="f01"][data-status="created"]:checked' )
                  .length > 0
              ) {
                item.disabled = true;
              }
            }
            if ( item.action === "bulk-terminate-flow-instance" ) {
              if (
                apex
                  .jQuery( "#flow-instances .a-IRR-tableContainer" )
                  .find(
                    'input[name="f01"][data-status!="running"]:checked',
                    'input[name="f01"][data-status!="error"]:checked'
                  ).length > 0
              ) {
                item.disabled = true;
              }
            }
          }
          return item;
        } );
        ui.menu.items = menuItems;
      }
    );

    $( "#instance_row_action_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var rowBtn = apex.jQuery( ".flow-instance-actions-btn.is-active" );
      var menuItems = ui.menu.items;
      var prcsStatus = rowBtn.data( "status" );
      var prcsId = rowBtn.attr( "data-prcs" );
      menuItems = menuItems.map( function ( item ) {
        if ( item.action === "start-flow-instance" ) {
          item.disabled = prcsStatus !== "created" ? true : false;
        }
        if ( item.action === "reset-flow-instance" ) {
          item.disabled = prcsStatus !== "created" ? false : true;
        }
        if ( item.action === "terminate-flow-instance" ) {
          item.disabled =
            prcsStatus === "running" || prcsStatus === "error" ? false : true;
        }
        if ( item.action === "download-as-svg" ) {
          item.disabled = 
          prcsId !== apex.item("P10_PRCS_ID").getValue() ? true : false;
        }
        return item;
      } );

      ui.menu.items = menuItems;
    } );

  } );
}

/* Utility functions for viewer plugin dynamic (click) actions */

function changeCursor(objectListItem) {
  // get object ids from page item
  var objects = objectListItem.split(':');
  // change cursor to pointer
  $.each(objects, function( index, value ) {
    $( "[data-element-id='" + value + "']").css( "cursor", "pointer" );
  });
}

function clickCondition(objectListItem, eventData) {
  // if object exists in list
  if (objectListItem.split(':').includes(eventData.element.id) &&
      // filter out call activity drilldown
      (eventData.element.type != 'bpmn:CallActivity' ||
        (eventData.originalEvent.target.tagName != 'path' && !eventData.originalEvent.target.getAttribute('transform'))
      )
    ) return true;
  return false;
}

function openObjectDialog(objectBpmnId, objectName, currentPage) {
  // set title
  var title = objectBpmnId + (objectName.length > 0 ? ' - ' + objectName : '');
  // open page
  apex.server.process(
      'GET_URL',                           
      {
          x01: objectBpmnId,
          x02: title,
          pageItems: [`P${currentPage}_LOADED_DIAGRAM`]
      }, 
      {
          success: function (pData)
          {           
              apex.navigation.redirect(pData);
          },
          dataType: "text"                     
      }
  );
}

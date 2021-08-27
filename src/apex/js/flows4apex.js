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

function initPage2() {
  initApp();
  $( function () {
    apex.actions.add( [
      {
        name: "edit-flow",
        action: function ( event, focusElement ) {
          var dgrmId = apex.jQuery( focusElement ).attr( "data-dgrm" );
          apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
          apex.page.submit( "EDIT_FLOW" );
        },
      },
      {
        name: "new-flow-version",
        action: function ( event, focusElement ) {
          var dgrmId = apex.jQuery( focusElement ).attr( "data-dgrm" );
          apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
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
          apex.theme.openRegion( "copy_flow_reg" );
        },
      },
      {
        name: "copy-flow",
        action: function ( event, focusElement ) {
          var dgrmId = apex.jQuery( focusElement ).attr( "data-dgrm" );
          apex.item( "P2_DGRM_ID" ).setValue( dgrmId );
          apex.theme.openRegion( "copy_flow_reg" );
        },
      },
    ] );
  } );

  apex.jQuery( window ).on( "theme42ready", function () {
    $( "#parsed_drgm table th.a-IRR-header--group" )
      .attr( "colspan", "6" )
      .after(
        '<th colspan="5" class="a-IRR-header a-IRR-header--group" id="instances_column_group_heading" style="text-align: center;">Instances</th>'
      );

    $( ".a-IRR-headerLabel, .a-IRR-headerLink" ).each( function () {
      var text = $( this ).text();
      if ( text == "Created" ) {
        $( this ).prepend('<i class="status_icon fa fa-plus"></i>');  
        $( this ).parent().addClass( "u-color-44" );
      } else if ( text == "Completed" ) {
        $( this ).prepend('<i class="status_icon fa fa-play"></i>');  
        $( this ).parent().addClass( "u-color-35" );
      } else if ( text == "Running" ) {
        $( this ).prepend('<i class="status_icon fa fa-check"></i>');  
        $( this ).parent().addClass( "u-color-37" );
      } else if ( text == "Terminated" ) {
        $( this ).prepend('<i class="status_icon fa fa-stop-circle-o"></i>');  
        $( this ).parent().addClass( "u-color-38" );
      } else if ( text == "Error" ) {
        $( this ).prepend('<i class="status_icon fa fa-warning"></i>');  
        $( this ).parent().addClass( "u-color-39" );
      }
    } );

    $( "th.a-IRR-header" ).each( function ( i ) {
      if ( apex.jQuery( this ).attr( "id" ) === undefined ) {
        apex.jQuery( this ).find( 'input[type="checkbox"]' ).hide();
        apex.jQuery( this ).find( "button#header-action" ).hide();
      } else {
        apex.jQuery( this ).addClass( "u-alignMiddle" );
      }
    } );

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
    addClassesToParents('span[data-status="created"]'  , "span.t-BadgeList-wrap", "u-color-44");
    addClassesToParents('span[data-status="running"]'  , "span.t-BadgeList-wrap", "u-color-37");
    addClassesToParents('span[data-status="completed"]', "span.t-BadgeList-wrap", "u-color-35");
    addClassesToParents('span[data-status="terminated"]', "span.t-BadgeList-wrap", "u-color-38");
    addClassesToParents('span[data-status="error"]'     , "span.t-BadgeList-wrap", "u-color-39");
  } );
}

function initPage7() {
  apex.jQuery( window ).on( "theme42ready", function () {
    addClassesToParents('span[data-status="created"]'   , "span.t-BadgeList-value", ["u-color-44", "instance-counter-link"]);
    addClassesToParents('span[data-status="running"]'   , "span.t-BadgeList-value", ["u-color-37", "instance-counter-link"]);
    addClassesToParents('span[data-status="completed"]' , "span.t-BadgeList-value", ["u-color-35", "instance-counter-link"]);
    addClassesToParents('span[data-status="terminated"]', "span.t-BadgeList-value", ["u-color-38", "instance-counter-link"]);
    addClassesToParents('span[data-status="error"]'     , "span.t-BadgeList-value", ["u-color-39", "instance-counter-link"]);
  } );
}

function redirectToMonitor( prcs_id ) {
  var processes = [];
  processes.push( prcs_id );
  var result = apex.server.process( "PROCESS_ACTION", {
    x01: "view-flow-instance",
    f01: processes,
    f02: [null],
    f03: [null],
    f04: [null],
  } );
  result
    .done( function ( data ) {
      if ( !data.success ) {
        apex.debug.error( "Something went wrong..." );
      } else {
        apex.navigation.redirect( data.url );
      }
    } )
    .fail( function ( jqXHR, textStatus, errorThrown ) {
      apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );
    } );
}

function initPage8() {
  initApp();

  function processAction( action, element ) {
    var processes = [];
    var subflows = [];
    var diagrams = [];
    var processesNames = [];

    if ( action.includes( "bulk-" ) ) {
      if ( action.includes( "-flow-instance" ) ) {
        processes = apex
          .jQuery( "#flow-instances .a-IRR-tableContainer" )
          .find( 'input[name="f01"]:checked' )
          .map( function ( item ) {
            return apex.jQuery( this ).attr( "data-prcs" );
          } )
          .toArray();
        subflows = processes.map( function ( i ) {
          return null;
        } );
      } else {
        processes = apex
          .jQuery( "#subflows .a-IRR-tableContainer" )
          .find( 'input[name="f02"]:checked' )
          .map( function ( item ) {
            return apex.jQuery( this ).attr( "data-prcs" );
          } )
          .toArray();
        subflows = apex
          .jQuery( "#subflows .a-IRR-tableContainer" )
          .find( 'input[name="f02"]:checked' )
          .map( function ( item ) {
            return this.value;
          } )
          .toArray();
      }
    } else {
      var myElement = apex.jQuery( element );
      var myProcess = myElement.attr( "data-prcs" );
      var mySubflow = myElement.attr( "data-sbfl" );
      var myDiagram = myElement.attr( "data-dgrm" );
      var myProcessName = myElement.attr( "data-name" );
      processes.push( myProcess );
      subflows.push( mySubflow === undefined ? null : mySubflow );
      diagrams.push( myDiagram === undefined ? null : myDiagram );
      processesNames.push( myProcessName === undefined ? null : myProcessName );
    }

    var displaySetting = apex.item( "P10_DISPLAY_SETTING" ).getValue();

    if (
      action !== "view-flow-instance" ||
      ( action === "view-flow-instance" && displaySetting === "window" )
    ) {
      var result = apex.server.process( "PROCESS_ACTION", {
        x01: action,
        x02: apex.item( "P10_RESERVATION" ).getValue(),
        f01: processes,
        f02: subflows,
        f03: diagrams,
        f04: processesNames,
      } );
      result
        .done( function ( data ) {
          if ( !data.success ) {
            apex.debug.error( "Something went wrong..." );
          } else {
            if ( action === "delete-flow-instance" ) {
              apex.item( "P10_PRCS_ID" ).setValue();
            } else if (
              action === "view-flow-instance" ||
              action === "flow-instance-audit" ||
              action === "edit-flow-diagram"
            ) {
              apex.navigation.redirect( data.url );
            } else {
              apex.region( "flow-instances" ).refresh();
              apex.region( "subflows" ).refresh();
              apex.region( "flow-monitor" ).refresh();
            }
          }
        } )
        .fail( function ( jqXHR, textStatus, errorThrown ) {
          apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );
        } );
    } else {
      apex.item( "P10_PRCS_ID" ).setValue( myProcess );
    }
  }

  //Define actions
  $( function () {
    apex.actions.add( [
      {
        name: "choose-setting",
        get: function () {
          return apex.item( "P8_DISPLAY_SETTING" ).getValue();
        },
        set: function ( value ) {
          apex.item( "P8_DISPLAY_SETTING" ).setValue( value );
          var prcsId = apex.item( "P8_PRCS_ID" ).getValue();

          switch ( value ) {
            case "row":
              apex.jQuery( "#col1" ).addClass( "col-12" ).removeClass( "col-6" );
              apex.jQuery( "#col2" ).addClass( "col-12" ).removeClass( "col-6" );

              apex.jQuery( "#flow-monitor" ).show();
              apex.region( "flow-monitor" ).refresh();
              break;
            case "column":
              apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( "col-12" );
              apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( "col-12" );
              apex.jQuery( "#col2" ).appendTo( apex.jQuery( "#col1" ).parent() );

              apex.jQuery( "#flow-monitor" ).show();
              apex.region( "flow-monitor" ).refresh();
              break;
            case "window":
              apex.jQuery( "#flow-monitor" ).hide();
              apex.jQuery( "#col1" ).addClass( "col-12" ).removeClass( "col-6" );
              apex.jQuery( "#col2" ).addClass( "col-12" ).removeClass( "col-6" );

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
          processAction( this.name, focusElement );
        },
      },
      {
        name: "reset-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_RESET_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "terminate-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_TERMINATE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "delete-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_DELETE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "download-as-svg",
        action: function ( event, focusElement ) {
          apex
            .region( "flow-monitor" )
            .getSVG()
            .then( ( svg ) => {
              var svgBlob = new Blob( [svg], {
                type: "image/svg+xml",
              } );
              var fileName = Date.now();

              var downloadLink = document.createElement( "a" );
              downloadLink.download = fileName;
              downloadLink.href = window.URL.createObjectURL( svgBlob );
              downloadLink.click();
            } );
        },
      },
      {
        name: "flow-instance-audit",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "edit-flow-diagram",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "complete-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "bulk-complete-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "restart-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "bulk-restart-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "reserve-step",
        action: function ( event, focusElement ) {
          if ( apex.jQuery( "#reservation_dialog" ).dialog( "isOpen" ) ) {
            apex.theme.closeRegion( "reservation_dialog" );
            processAction( this.name, focusElement );
          } else {
            apex.item( "P10_RESERVATION" ).setValue( "" );
            apex.jQuery( "#reserve-step-btn" ).attr( "data-action", this.name );
            apex
              .jQuery( "#reserve-step-btn" )
              .attr( "data-prcs", apex.jQuery( focusElement ).attr( "data-prcs" ) );
            apex
              .jQuery( "#reserve-step-btn" )
              .attr( "data-sbfl", apex.jQuery( focusElement ).attr( "data-sbfl" ) );
            apex.theme.openRegion( "reservation_dialog" );
          }
        },
      },
      {
        name: "bulk-reserve-step",
        action: function ( event, focusElement ) {
          if ( apex.jQuery( "#reservation_dialog" ).dialog( "isOpen" ) ) {
            apex.theme.closeRegion( "reservation_dialog" );
            processAction( this.name, focusElement );
          } else {
            apex.item( "P10_RESERVATION" ).setValue( "" );
            apex.jQuery( "#reserve-step-btn" ).attr( "data-action", this.name );
            apex.jQuery( "#reserve-step-btn" ).attr( "data-prcs", "" );
            apex.jQuery( "#reserve-step-btn" ).attr( "data-sbfl", "" );
            apex.theme.openRegion( "reservation_dialog" );
          }
        },
      },
      {
        name: "release-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "bulk-release-step",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
    ] );

    apex.actions.set(
      "choose-setting",
      apex.item( "P8_DISPLAY_SETTING" ).getValue()
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
  } );

  apex.jQuery( window ).on( "theme42ready", function () {
    $( "th.a-IRR-header" ).each( function ( i ) {
      if ( apex.jQuery( this ).attr( "id" ) === undefined ) {
        apex.jQuery( this ).find( 'input[type="checkbox"]' ).hide();
        apex.jQuery( this ).find( "button#subflow-header-action" ).hide();
      } else {
        apex.jQuery( this ).addClass( "u-alignMiddle" );
      }
    } );

    /*Disable download image when no instances selected*/
    $( "#actions_menu" ).on( "menubeforeopen", function ( event, ui ) {
      var menuItems = ui.menu.items;
      menuItems[1].disabled =
        apex.item( "P8_PRCS_ID" ).getValue() === "" ? true : false;
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
            ) {
              item.disabled = true;
            }
          }
          if ( item.action === "bulk-release-step" ) {
            if (
              apex
                .jQuery( "#subflows .a-IRR-tableContainer" )
                .find( 'input[name="f02"][data-reservation=""]:checked' ).length >
              0
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
        var subflReservation = rowBtn.data( "reservation" );
        menuItems = menuItems.map( function ( item ) {
          if ( item.action === "complete-step" ) {
            item.disabled = sbflStatus === "running" ? false : true;
          }
          if ( item.action === "restart-step" ) {
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
          return item;
        } );
        ui.menu.items = menuItems;
      } );
  } );
}

function initPage10() {
  initApp();

  function processAction( action, element ) {
    var processes = [];
    var subflows = [];
    var diagrams = [];
    var processesNames = [];

    if ( action.includes( "bulk-" ) ) {
      if ( action.includes( "-flow-instance" ) ) {
        processes = apex
          .jQuery( "#flow-instances .a-IRR-tableContainer" )
          .find( 'input[name="f01"]:checked' )
          .map( function ( item ) {
            return apex.jQuery( this ).attr( "data-prcs" );
          } )
          .toArray();
        subflows = processes.map( function ( i ) {
          return null;
        } );
      } else {
        processes = apex
          .jQuery( "#subflows .a-IRR-tableContainer" )
          .find( 'input[name="f02"]:checked' )
          .map( function ( item ) {
            return apex.jQuery( this ).attr( "data-prcs" );
          } )
          .toArray();
        subflows = apex
          .jQuery( "#subflows .a-IRR-tableContainer" )
          .find( 'input[name="f02"]:checked' )
          .map( function ( item ) {
            return this.value;
          } )
          .toArray();
      }
    } else {
      var myElement = apex.jQuery( element );
      var myProcess = myElement.attr( "data-prcs" );
      var mySubflow = myElement.attr( "data-sbfl" );
      var myDiagram = myElement.attr( "data-dgrm" );
      var myProcessName = myElement.attr( "data-name" );
      processes.push( myProcess );
      subflows.push( mySubflow === undefined ? null : mySubflow );
      diagrams.push( myDiagram === undefined ? null : myDiagram );
      processesNames.push( myProcessName === undefined ? null : myProcessName );
    }

    var displaySetting = apex.item( "P10_DISPLAY_SETTING" ).getValue();

    if (
      action !== "view-flow-instance" ||
      ( action === "view-flow-instance" && displaySetting === "window" )
    ) {
      var result = apex.server.process( "PROCESS_ACTION", {
        x01: action,
        x02: apex.item( "P10_RESERVATION" ).getValue(),
        f01: processes,
        f02: subflows,
        f03: diagrams,
        f04: processesNames,
      } );
      result
        .done( function ( data ) {
          if ( !data.success ) {
            apex.debug.error( "Something went wrong..." );
          } else {
            if ( action === "delete-flow-instance" ) {
              apex.item( "P10_PRCS_ID" ).setValue();
            } else if (
              action === "view-flow-instance"  ||
              action === "flow-instance-audit" ||
              action === "edit-flow-diagram"   ||
              action === "open-flow-instance-details"
            ) {
              apex.navigation.redirect( data.url );
            } else {
              apex.region( "flow-instances" ).refresh();
              apex.region( "flow-monitor" ).refresh();
            }
          }
        } )
        .fail( function ( jqXHR, textStatus, errorThrown ) {
          apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );
        } );
    } else {
      apex.item( "P10_PRCS_ID" ).setValue( myProcess );
    }
  }

  //Define actions
  $( function () {
    apex.actions.add( [
      {
        name: "choose-setting",
        get: function () {
          return apex.item( "P10_DISPLAY_SETTING" ).getValue();
        },
        set: function ( value ) {
          apex.item( "P10_DISPLAY_SETTING" ).setValue( value );
          var prcsId = apex.item( "P10_PRCS_ID" ).getValue();

          switch ( value ) {
            case "row":
              apex.jQuery( "#col1" ).addClass( "col-12" ).removeClass( "col-6" );
              apex.jQuery( "#col2" ).addClass( "col-12" ).removeClass( "col-6" );

              apex.jQuery( "#flow-monitor" ).show();
              apex.region( "flow-monitor" ).refresh();
              break;
            case "column":
              apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( "col-12" );
              apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( "col-12" );
              apex.jQuery( "#col2" ).appendTo( apex.jQuery( "#col1" ).parent() );

              apex.jQuery( "#flow-monitor" ).show();
              apex.region( "flow-monitor" ).refresh();
              break;
            case "window":
              apex.jQuery( "#flow-monitor" ).hide();
              apex.jQuery( "#col1" ).addClass( "col-12" ).removeClass( "col-6" );
              apex.jQuery( "#col2" ).addClass( "col-12" ).removeClass( "col-6" );

              if ( prcsId !== "" ) {
                redirectToMonitor( prcsId );
              }
              break;
          }
        },
        choices: [],
      },
      {
        name: "view-flow-instance",
        action: function ( event, focusElement ) {
          var processRows = apex.jQuery( "#flow-instances td" );
          var selectedProcess = apex.jQuery( focusElement ).attr( "data-prcs" );
          var currentName = apex.jQuery( focusElement ).attr( "data-name" );
          var currentSelector =
            "button.flow-instance-actions-btn[data-prcs=" +
            selectedProcess +
            "]";
          var currentRow = processRows.has( currentSelector );
          processRows.removeClass( "current-process" );
          currentRow.parent().children().addClass( "current-process" );
          apex
            .jQuery( "#flow-monitor_heading" )
            .text( "Flow Viewer (" + currentName + ")" );
          processAction( this.name, focusElement );
        },
      },
      {
        name: "start-flow-instance",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "bulk-start-flow-instance",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "reset-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_RESET_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "bulk-reset-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_RESET_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "terminate-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_TERMINATE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "bulk-terminate-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_TERMINATE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "delete-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_DELETE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "bulk-delete-flow-instance",
        action: function ( event, focusElement ) {
          var action = this.name;
          apex.message.confirm(
            apex.lang.getMessage( "APP_CONFIRM_DELETE_INSTANCE" ),
            function ( okPressed ) {
              if ( okPressed ) {
                processAction( action, focusElement );
              }
            }
          );
        },
      },
      {
        name: "download-as-svg",
        action: function ( event, focusElement ) {
          apex
            .region( "flow-monitor" )
            .getSVG()
            .then( ( svg ) => {
              var svgBlob = new Blob( [svg], {
                type: "image/svg+xml",
              } );
              var fileName = Date.now();

              var downloadLink = document.createElement( "a" );
              downloadLink.download = fileName;
              downloadLink.href = window.URL.createObjectURL( svgBlob );
              downloadLink.click();
            } );
        },
      },
      {
        name: "flow-instance-audit",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "edit-flow-diagram",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        },
      },
      {
        name: "open-flow-instance-details",
        action: function ( event, focusElement ) {
          processAction( this.name, focusElement );
        }
      }
    ] );

    apex.actions.set(
      "choose-setting",
      apex.item( "P10_DISPLAY_SETTING" ).getValue()
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
  } );

  apex.jQuery( window ).on( "theme42ready", function () {
    $( "th.a-IRR-header" ).each( function ( i ) {
      if ( apex.jQuery( this ).attr( "id" ) === undefined ) {
        apex.jQuery( this ).find( 'input[type="checkbox"]' ).hide();
        apex.jQuery( this ).find( "button#instance-header-action" ).hide();
      } else {
        apex.jQuery( this ).addClass( "u-alignMiddle" );
      }
    } );

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
        return item;
      } );

      ui.menu.items = menuItems;
    } );

  } );
}

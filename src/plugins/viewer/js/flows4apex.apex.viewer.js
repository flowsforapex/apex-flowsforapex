/* global apex, BpmnJS */

(function( $, region, event ){

  $.widget( "flows4apex.viewer", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
      noDataFoundMessage: "Could not load Diagram",
      refreshOnLoad: false,
      useNavigatedViewer: false,
      addHighlighting: false,
      enableCallActivities: false,
      config: {
        currentStyle: {
          "fill": "#6aad42",
          "border": "black",
          "label": "black"
        },
        completedStyle: {
          "fill": "#8c9eb0",
          "border": "black",
          "label": "black"
        },
        errorStyle: {
          "fill": "#d2423b",
          "border": "black",
          "label": "white"
        }
      }
    },
    _create: function() {
      this._defaultXml =
        "<?xml version='1.0' encoding='UTF-8'?>" +
        "<bpmn:definitions xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:bpmn='http://www.omg.org/spec/BPMN/20100524/MODEL' xmlns:bpmndi='http://www.omg.org/spec/BPMN/20100524/DI' id='Definitions_1wzb475' targetNamespace='http://bpmn.io/schema/bpmn' exporter='bpmn-js (https://demo.bpmn.io)' exporterVersion='7.2.0'>" +
        "<bpmn:process id='Process_0rxermh' isExecutable='false' />" +
        "<bpmndi:BPMNDiagram id='BPMNDiagram_1'>" +
        "<bpmndi:BPMNPlane id='BPMNPlane_1' bpmnElement='Process_0rxermh' />" +
        "</bpmndi:BPMNDiagram>" +
        "</bpmn:definitions>";
      this.regionId    = this.element[0].id;
      this.canvasId    = this.regionId + "_canvas";
      this.enabledModules = [];
      if ( this.options.addHighlighting ) {
        this.enabledModules.push(bpmnViewer.customModules.styleModule);
      }
      if ( this.options.enableCallActivities ) {
        this.enabledModules.push(bpmnViewer.customModules.subProcessModule);
      }
      this.bpmnRenderer = {
        defaultFillColor: "var(--default-fill-color)",
        defaultStrokeColor: "var(--default-stroke-color)",
        defaultLabelColor: "var(--default-stroke-color)",
      }
      if ( this.options.useNavigatedViewer ) {
        this.bpmnViewer$ = new bpmnViewer.NavigatedViewer({ container: "#" + this.canvasId, additionalModules: this.enabledModules, bpmnRenderer: this.bpmnRenderer });
      } else {
        this.bpmnViewer$ = new bpmnViewer.Viewer({ container: "#" + this.canvasId, additionalModules: this.enabledModules, bpmnRenderer: this.bpmnRenderer });
      }
      if ( this.options.refreshOnLoad ) {
        this.refresh();
      }
      this._registerEvents();
      region.create( this.regionId, {
        widget: () => { return this.element; },
        refresh: () => { this.refresh(); },
        reset: () => { this.reset(); },
        loadDiagram: () => { this.loadDiagram(); },
        getSVG: () => this.getSVG(),
        getViewerInstance: () => { return this.bpmnViewer$; },
        getEventBus: () => { return this.bpmnViewer$.get( "eventBus" ); },
        widgetName: "bpmnviewer",
        type: "flows4apex.viewer"
      });
    },
    loadDiagram: async function() {
      $( "#" + this.canvasId ).show();
      $( "#" + this.regionId + " span.nodatafound" ).hide();
      const bpmnViewer$ = this.bpmnViewer$;
      try {
        const result = await bpmnViewer$.importXML( this.diagram || this._defaultXml );
        const { warnings } = result;
        if ( warnings.length > 0 ) {
          apex.debug.warn( "Warnings during XML Import", warnings );
        }
        this.zoom( "fit-viewport" );
        if ( this.options.addHighlighting ) {
          bpmnViewer$.get('styleModule').addStylesToElements(this.current, this.options.config.currentStyle);
          bpmnViewer$.get('styleModule').addStylesToElements(this.completed, this.options.config.completedStyle);
          bpmnViewer$.get('styleModule').addStylesToElements(this.error, this.options.config.errorStyle);
        }
        // trigger load event
        event.trigger( "#" + this.regionId, "mtbv_diagram_loaded", { diagramId: this.diagramId } );
      } catch (err) {
        apex.debug.error( "Loading Diagram failed.", err, this.diagram );
      }
    },
    zoom: function( zoomOption ) {
      this.bpmnViewer$.get( "canvas" ).zoom( zoomOption );
    },
    getSVG: async function() {
      const bpmnViewer$ = this.bpmnViewer$;
      try {
        const result = await bpmnViewer$.saveSVG({ format: true });
        const { svg } = result;
        if ( this.options.addHighlighting ) {
          return bpmnViewer$.get('styleModule').addToSVGStyle(svg,'.djs-group { --default-fill-color: white; --default-stroke-color: black; }');
        }
        return svg;
      } catch (err) {
        apex.debug.error( "Get SVG failed.", err );
        throw err;
      }
    },
    refresh: function() {
      apex.debug.info( "Enter Refresh", this.options );
      apex.server.plugin( this.options.ajaxIdentifier, {
        pageItems: $( this.options.itemsToSubmit, apex.gPageContext$ )
      }, {
        refreshObject: "#" + this.canvasId,
        loadingIndicator: "#" + this.canvasId
      }).then( pData => {
        if ( pData.found ) {
          var diagram;
          // use call activities
          if ( this.options.enableCallActivities ) {
            // get hierarchy
            this.data = pData.data;
            // get root entry
            diagram = pData.data.find(d => typeof(d.callingDiagramId) === 'undefined');
            // set reference to current diagram
            this.index = pData.data.indexOf(diagram);
            // 
            this.diagramId = diagram.diagramId;
            // set widget reference to viewer module
            this.bpmnViewer$.get('subProcessModule').setWidget(this);
          }
          else {
            // get first (only) entry
            diagram = pData.data[0];
          }     
          // add highlighting
          if ( this.options.addHighlighting ) {
            this.current   = diagram.current;
            this.completed = diagram.completed;
            this.error     = diagram.error;
          }
          // set diagram content
          this.diagram = diagram.diagram;
          // load diagram
          this.loadDiagram();
        } else {
          $( "#" + this.canvasId ).hide();
          $( "#" + this.regionId + " span.nodatafound" ).show();
        }
      });
    },
    _registerEvents: function() {
      const capturedEvents = [
        "element.hover",
        "element.out",
        "element.click",
        "element.dblclick",
        "element.mousedown",
        "element.mouseup"
      ];

      let eventBus = this.bpmnViewer$.get( "eventBus" );
      capturedEvents.forEach( currentEvent => {
        eventBus.on( currentEvent, eventData => {
          event.trigger( "#" + this.regionId, "mtbv_" + currentEvent.replace(".", "_"), eventData );
        });
      });
    }
  })

})( apex.jQuery, apex.region, apex.event );

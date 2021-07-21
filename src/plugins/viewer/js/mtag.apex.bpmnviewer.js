/* global apex, BpmnJS */

(function( $, region, event ){

  $.widget( "mtag.bpmnviewer", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
      noDataFoundMessage: "Could not load Diagram",
      refreshOnLoad: false,
      useNavigatedViewer: false,
      enableExpandModule: true,
      config: {
        currentStyle: {
          fill: "green",
          stroke: "black"
        },
        completedStyle: {
          fill: "grey",
          stroke: "black"
        },
        lastCompletedStyle: {
          fill: "grey",
          stroke: "black"
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
      this.enabledModules.push(bpmnViewer.customModules.styleModule);
      if ( this.options.enableExpandModule ) {
        this.enabledModules.push( bpmnViewer.customModules.spViewModule );
      }
      if ( this.options.useNavigatedViewer ) {
        this.bpmnViewer$ = new bpmnViewer.NavigatedViewer({ container: "#" + this.canvasId, additionalModules: this.enabledModules });
      } else {
        this.bpmnViewer$ = new bpmnViewer.Viewer({ container: "#" + this.canvasId, additionalModules: this.enabledModules });
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
        type: "mtag.bpmnviewer"
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
        bpmnViewer$.get('styleModule').addStylesToElements(this.current, this.options.config.currentStyle);
        bpmnViewer$.get('styleModule').addStylesToElements(this.completed, this.options.config.completedStyle);
        bpmnViewer$.get('styleModule').addStylesToElements(this.lastCompleted, this.options.config.lastCompletedStyle);
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
          this.diagram       = pData.data.diagram;
          this.current       = pData.data.current;
          this.completed     = pData.data.completed;
          this.lastCompleted = pData.data.lastCompleted;
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

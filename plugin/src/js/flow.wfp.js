/* global apex, BpmnJS */

(function( $, region ){

  $.widget( "flow.wfp", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
      
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
      this.canvasId    = this.regionId + '_canvas';
      this.bpmnViewer$ = new BpmnJS({ container: '#' + this.canvasId });
      //this.refresh();
      //this.diagram     = this._defaultXML;
      region.create( this.regionId, {
        widget: () => { return this.element; },
        refresh: () => { this.refresh(); },
        reset: () => { this.reset(); },
        loadDiagram: () => { this.loadDiagram(); },
        addMarker: () => { this.addMArker(); },
        widgetName: "wfp",
        type: "flow.wfp"
      });
    },
    loadDiagram: async function() {
//      var me = this;
      const bpmnViewer$ = this.bpmnViewer$;
      try {
        const result = await bpmnViewer$.importXML( this.diagram || this._defaultXml );
        const { warnings } = result;
        apex.debug.warn( "Warnings during XML Import", warnings );

        this.zoom( "fit-viewport" );
        this.addMarkers( this.current, "highlight" );
      } catch (err) {
        apex.debug.error( "Loading Diagram failed.", err, this.diagram );
      }
    },
    addMarkers: function( markers, markerClass ) {
      let canvas = this.bpmnViewer$.get( "canvas" );
      if ( Array.isArray( markers ) ) {
        markers.forEach( currentMarker => {
          canvas.addMarker( currentMarker, markerClass );
        });
      } else {
        canvas.addMarker( markers, markerClass );
      }
    },
    zoom: function( zoomOption ) {
      this.bpmnViewer$.get( "canvas" ).zoom( zoomOption );
    },
    refresh: function() {
      apex.debug.info( "Enter Refresh", this.options );
      apex.debug.info( "Test Selector...", $( this.options.itemsToSubmit, apex.gPageContext$ ) );
      apex.server.plugin( this.options.ajaxIdentifier, {
        pageItems: $( this.options.itemsToSubmit, apex.gPageContext$ )
      }, {
        refreshObject: "#" + this.canvasId,
        loadingIndicator: "#" + this.canvasId
      }).then( pData => {
        this.diagram = pData.data.diagram;
        this.current = pData.data.current;
        this.loadDiagram();
      });
    },
    reset: function() {

    }
  })

})( apex.jQuery, apex.region );

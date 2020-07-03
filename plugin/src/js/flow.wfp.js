/* global apex, BpmnJS */

(function( $, region ){

  $.widget( "flow.wfp", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
      noDataFoundMessage: "Could not load Diagram",
      refreshOnLoad: false,
      currentClass: "wfp-current",
      completedClass: "wfp-completed",
      lastCompletedClass: "wfp-last-completed"
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
      if ( this.options.refreshOnLoad ) {
        this.refresh();
      }
//      this.eventBus$   = this.bpmnViewer$.get('eventBus');
//      this.eventBus$.on( 'element.click', (e) => { alert( "Clicked on " + e.element.id ); } );
      region.create( this.regionId, {
        widget: () => { return this.element; },
        refresh: () => { this.refresh(); },
        reset: () => { this.reset(); },
        loadDiagram: () => { this.loadDiagram(); },
        addMarkers: () => { this.addMarkers(); },
        getViewerInstance: () => { return this.bpmnViewer$; },
        widgetName: "wfp",
        type: "flow.wfp"
      });
    },
    loadDiagram: async function() {
      $( "#" + this.canvasId ).show();
      $( "#" + this.regionId + " span.nodatafound" ).hide();
      const bpmnViewer$ = this.bpmnViewer$;
      try {
        const result = await bpmnViewer$.importXML( this.diagram || this._defaultXml );
        const { warnings } = result;
        apex.debug.warn( "Warnings during XML Import", warnings );

        this.zoom( "fit-viewport" );
        this.addMarkers( this.current, this.options.currentClass );
        this.addMarkers( this.completed, this.options.completedClass );
        this.addMarkers( this.lastCompleted, this.options.lastCompletedClass );
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
      } else if ( markers ) {
        canvas.addMarker( markers, markerClass );
      } else {
        apex.debug.warn( "No markers received?", markers );
      }
    },
    zoom: function( zoomOption ) {
      this.bpmnViewer$.get( "canvas" ).zoom( zoomOption );
    },
    expandElement: function( element ) {
      // TODO: implement
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
    reset: function() {

    }
  })

})( apex.jQuery, apex.region );

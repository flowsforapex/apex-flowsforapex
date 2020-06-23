/* global apex, BpmnJS */

(function( $, region ){

  $.widget( "flow.wfp", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null
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
        widgetName: "wfp",
        type: "flow.wfp"
      });
    },
    loadDiagram: function() {
      var me = this;
      var bpmnViewer$ = me.bpmnViewer$;
      bpmnViewer$.importXML( this.diagram || this._defaultXml, function( err ) {
        if ( !err ) {
          apex.debug.trace( "XML imported." );
          var canvas = bpmnViewer$.get( "canvas" );
          canvas.zoom( "fit-viewport" );
          try {
            canvas.addMarker( me.current, "highlight" );
          } catch (e) {
            apex.debug.warn( "Adding Marker failed.", e );
          }
        } else {
          apex.debug.error( "Loading Diagram failed.", err, this.diagram );
        }
      });
    },
    refresh: function() {
      apex.debug.info( "Enter Refresh", this.options );
      apex.debug.info( "Test Selector...", $( this.options.itemsToSubmit, apex.gPageContext$ ) );
      apex.server.plugin( this.options.ajaxIdentifier, {
        pageItems: '#' + this.options.itemsToSubmit
      }, {
        refreshObject: "#" + this.canvasId,
        loadingIndicator: "#" + this.canvasId
      }).then( pData => {
        this.diagram = pData.diagram;
        this.current = pData.current;
        this.loadDiagram();
      });
    },
    reset: function() {

    }
  })

})( apex.jQuery, apex.region );

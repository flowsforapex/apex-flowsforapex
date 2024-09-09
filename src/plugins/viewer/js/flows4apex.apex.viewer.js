/* global apex, BpmnJS */

(function( $, region, event, message ){

  $.widget( "flows4apex.viewer", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null,
      noDataFoundMessage: "Could not load Diagram",
      refreshOnLoad: false,
      showToolbar: false,
      enableMousewheelZoom: false,
      addHighlighting: false,
      useBPMNcolors: false,
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
        },
        allowDownload: true,
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
      this.viewerWrap  = this.regionId + "_viewer";
      this.canvasId    = this.regionId + "_canvas";
      this.enabledModules = [
        bpmnViewer.customModules.drilldownCentering,
        bpmnViewer.customModules.multiInstanceModule,
        bpmnViewer.customModules.userTaskModule
      ];

      // add style module if addHighlighting or bpmnColors options is enabled
      if ( this.options.addHighlighting || this.options.useBPMNcolors ) {
        this.enabledModules.push(bpmnViewer.customModules.styleModule);
      }

      // add callActivityModule if call activities option is enabled
      if ( this.options.enableCallActivities ) {
        this.enabledModules.push(bpmnViewer.customModules.callActivityModule);
      }

      // set default colors
      this.bpmnRenderer = {
        defaultFillColor: "var(--default-fill-color)",
        defaultStrokeColor: "var(--default-stroke-color)",
        defaultLabelColor: "var(--default-stroke-color)",
      }

      // add custom palette if showToolbar option is enabled
      if ( this.options.showToolbar ) {
        this.enabledModules.push(bpmnViewer.customModules.customPaletteProviderModule);
      }
      // add zoomScroll module if mouse wheel zoom option is enabled
      if ( this.options.enableMousewheelZoom ) {
        this.enabledModules.push(bpmnViewer.customModules.ZoomScrollModule);
      }
      // add move canvas module if showToolbar option or mouse wheel zoom option is enabled
      if ( this.options.showToolbar || this.options.enableMousewheelZoom) {
        this.enabledModules.push(bpmnViewer.customModules.MoveCanvasModule);
      }

      this.bpmnViewer$ = new bpmnViewer.Viewer({
          container: "#" + this.canvasId,
          additionalModules: this.enabledModules,
          bpmnRenderer: this.bpmnRenderer,
          config: this.options.config
      });

      // prevent page submit + reload after button click
      $( document ).on( "apexbeforepagesubmit", ( _, request ) => {
        if (!request) apex.event.gCancelFlag = true;
      } );

      if ( this.options.refreshOnLoad ) {
        this.refresh();
      }

      this._registerEvents();
      
      region.create(this.regionId, {
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
        
        
        // get viewer modules
        const eventBus = bpmnViewer$.get('eventBus');
        const multiInstanceModule = bpmnViewer$.get('multiInstanceModule');

        // update colors with the current highlighting info
        this.updateColors(this.current, this.completed, this.error);
          
        // root.set -> drilled down into or moved out from sub process
        eventBus.on('root.set', (event) => {
          const {element} = event;
          // if current element is not iterating -> iterating elements are handled inside module
          if (!multiInstanceModule.isMultiInstanceSubProcess(element)) {
            // update colors
            this.updateColors(this.current, this.completed, this.error);
          }
        });

        // add overlays if iterationData is existing
        if (this.iterationData) {
          this.bpmnViewer$.get('multiInstanceModule').addOverlays();
        }

        // add overlays if userTaskData is existing
        if (this.userTaskData) {
          this.bpmnViewer$.get('userTaskModule').addOverlays();
        }

        // trigger load event
        event.trigger( "#" + this.regionId, "mtbv_diagram_loaded", 
          { 
            diagramIdentifier: this.diagramIdentifier, 
            callingDiagramIdentifier: this.callingDiagramIdentifier, 
            callingObjectId: this.callingObjectId
          } 
        );

      } catch (err) {
        apex.debug.error( "Loading Diagram failed.", err, this.diagram );
      }
    },

    updateColors: function(current, completed, error) {
      // if any color option is enabled
      if ( this.options.addHighlighting || this.options.useBPMNcolors ) {
        // get viewer module
        const styleModule = this.bpmnViewer$.get('styleModule');
        // reset current colors
        this.resetColors();
        // add highlighting if option is enabled
        if ( this.options.addHighlighting ) {
          styleModule.highlightElements(current, completed, error);
        }
      }
    },

    resetColors: function() {
      // if any color option is enabled
      if ( this.options.addHighlighting || this.options.useBPMNcolors ) {
        // get viewer module
        const styleModule = this.bpmnViewer$.get('styleModule');
        // reset bpmn colors if option is not enabled
        if ( !this.options.useBPMNcolors ) {
          styleModule.resetBPMNcolors();
        }
        // reset highlighting
        styleModule.resetHighlighting();
      }
    },

    zoom: function( zoomOption ) {
      this.bpmnViewer$.get( "canvas" ).zoom( zoomOption, 'auto' );
    },

    getSVG: async function() {

      try {
        const result = await this.bpmnViewer$.saveSVG({ format: true });
        const { svg } = result;
        
        // add highlighting colors to image if option is enabled
        if ( this.options.addHighlighting ) {
          return this.bpmnViewer$.get('styleModule').addStyleToSVG(svg);
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
      })
      .then( pData => {
        if ( pData.found ) {

          var diagram;
          var oldLoaded = true;

          // set widget reference
          this.bpmnViewer$.get('multiInstanceModule').setWidget(this);
          this.bpmnViewer$.get('userTaskModule').setWidget(this);
          
          // if call activities option enabled
          if (this.options.enableCallActivities) {
            // set widget reference
            this.bpmnViewer$.get('callActivityModule').setWidget(this);
            // load old diagram (if possible)
            diagram = pData.data.find(d => d.diagramIdentifier === this.diagramIdentifier);
            // otherwise: get root entry
            if (!diagram) {
              oldLoaded = false;
              diagram = pData.data.find(d => typeof(d.callingDiagramIdentifier) === 'undefined');
            } 
            // set references to hierarchy + current diagram
            this.data = pData.data;
            this.diagramIdentifier = diagram.diagramIdentifier;
            this.callingDiagramIdentifier = diagram.callingDiagramIdentifier;
            this.callingObjectId = diagram.callingObjectId;

            // reset & update breadcrumb
            if (!oldLoaded) {
                this.bpmnViewer$.get('callActivityModule').resetBreadcrumb();
                this.bpmnViewer$.get('callActivityModule').updateBreadcrumb();
            }
          }
          // call activities not activated
          else {
            // get first (only) entry
            diagram = pData.data[0];
            this.diagramIdentifier = diagram.diagramIdentifier;
          }

          // add highlighting if option is enabled
          if (this.options.addHighlighting) {
            this.current   = diagram.current;
            this.completed = diagram.completed;
            this.error     = diagram.error;
          }

          // set diagram content
          this.diagram = diagram.diagram;

          // parse iterationData and attach to instance
          try {
            this.iterationData = JSON.parse(diagram.iterationData);
          }
          catch(e) {
            this.iterationData = null;
          }
          
          // parse userTaskData and attach to instance
          try {
            this.userTaskData = JSON.parse(diagram.userTaskData);
          }
          catch(e) {
            this.userTaskData = null;
          }

          // load diagram
          this.loadDiagram();
        } else {

          $( "#" + this.canvasId ).hide();
          
          if (pData.message) {
            apex.message.clearErrors();
            message.showErrors( [
              {
                type: "error",
                location: ["page"],
                message: pData.message,
                unsafe: false,
              },
            ] );
          }
          else {
            $( "#" + this.regionId + " span.nodatafound" ).show();
          }
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

})( apex.jQuery, apex.region, apex.event, apex.message );

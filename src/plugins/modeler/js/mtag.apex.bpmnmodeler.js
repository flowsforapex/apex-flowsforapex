/* global apex, bpmnModeler */

(function( $, region, debug, server, message ){

  $.widget( "mtag.bpmnmodeler", {
    options: {
      ajaxIdentifier: null,
      itemsToSubmit: null
    },
    _create: function() {
      this.changed     = false;
      this.regionId    = this.element[0].id;
      this.modelerWrap = this.regionId + "_modeler";
      this.canvasId    = this.regionId + "_canvas";
      this.propertiesPanelParent = this.regionId + "_properties";

      this.enabledModules = [ 
        bpmnModeler.customModules.propertiesPanelModule,
        bpmnModeler.customModules.propertiesProviderModule,
        bpmnModeler.customModules.lintModule
      ];

      this.moddleExtensions = {
        apex: bpmnModeler.moddleExtensions.apexModdleDescriptor
      };

      this.linting = {
        bpmnlint: bpmnModeler.linting.apexLinting
      };

      this.bpmnModeler$ = new bpmnModeler.Modeler({
        container: "#" + this.canvasId,
        propertiesPanel: { parent: "#" + this.propertiesPanelParent },
        additionalModules: this.enabledModules,
        moddleExtensions: this.moddleExtensions,
        linting: this.linting
      });

      // prevent click events from bubbling up the dom
      $( "#" + this.modelerWrap ).on( "click", ( event ) => {
        event.stopPropagation();
        return false;
      });

      region.create( this.regionId, {
        widget: () => { return this.element; },
        refresh: () => { this.refresh(); },
        loadDiagram: () => { this.loadDiagram(); },
        getModelerInstance: () => { return this.bpmnModeler$; },
        getEventBus: () => { return this.bpmnModeler$.get( "eventBus" ); },
        save: () => { this.save(); },
        getDiagram: () => this.getDiagram(),
        widgetName: "bpmnmodeler",
        type: "mtag.bpmnmodeler"
      });

      this.refresh();
    },
    loadDiagram: async function() {
      var that = this;
      const bpmnModeler$ = this.bpmnModeler$;
      try {
        const result = await bpmnModeler$.importXML( this.diagramContent );
        const { warnings } = result;
        
        if ( warnings.length > 0 ) {
          debug.warn( "Warnings during XML Import", warnings );
        }

        this.zoom( "fit-viewport" );
        that.changed = false;
        bpmnModeler$.get( "eventBus" ).on( "commandStack.changed", function() {
          that.changed = true;
        });
      } catch (err) {
        debug.error( "Loading Diagram failed.", err, this.diagram );
      }
    },
    zoom: function( zoomOption ) {
      this.bpmnModeler$.get( "canvas" ).zoom( zoomOption );
    },
    refresh: function() {
      var that = this;
      debug.info( "Enter Refresh", this.options );
      if (this.changed) {
        message.confirm( "Model has changed. Discard changes?", function( okPressed ){
          if ( okPressed ) {
            that._refreshCall();
          }
        });
      } else {
        that._refreshCall();
      }
    },
    getDiagram: async function() {
      var that = this;
      const bpmnModeler$ = that.bpmnModeler$;
      try {
        const result = await bpmnModeler$.saveXML( { format: true } );
        const { xml } = result;
        return xml;
      } catch (err) {
        debug.error( "Get Diagram failed.", err );
        throw err;
      }
    },
    save: async function() {
      this._saveCall( await this.getDiagram() );
    },
    _refreshCall: function() {
      server.plugin( this.options.ajaxIdentifier, {
        pageItems: $( this.options.itemsToSubmit, apex.gPageContext$ ),
        x01: 'LOAD'
      }, {
        refreshObject: "#" + this.canvasId,
        loadingIndicator: "#" + this.canvasId
      }).then( pData => {
        this.diagramContent = pData.data.content;
        this.diagramId      = pData.data.id;
        this.loadDiagram();
      });
    },
    _saveCall: function( xml ) {
      server.plugin( this.options.ajaxIdentifier, {
        regions: [
          {
            "id": this.regionId,
            "data": {
              "id"       : this.diagramId,
              "content"  : xml.replaceAll( '"', "'" )
            }
          }
        ],
        x01: 'SAVE'
      }).then( pData => {
        apex.message.clearErrors();
        if ( pData.success ) {
          this.changed = false;
          message.showPageSuccess( "Changes saved!" );
        } else {
          message.showErrors([
            {
              type:       "error",
              location:   [ "page" ],
              message:    pData.message,
              unsafe:     false
            }
          ]);
        }
      });
    }
  });
})( apex.jQuery, apex.region, apex.debug, apex.server, apex.message );

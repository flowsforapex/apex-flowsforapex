var f4a = f4a || {};
f4a.plugins = f4a.plugins || {};
f4a.plugins.viewer = f4a.plugins.viewer || {
    
    render: function(options) {

        const {
            regionId,
            ajaxIdentifier,
            itemsToSubmit,
            noDataFoundMessage,
            refreshOnLoad,
            showToolbar,
            addHighlighting,
            enableCallActivities,
            enableMousewheelZoom,
            useBPMNcolors,
            themePluginClass,
            config
        } = options;

        // store apex-related input
        this.regionId = regionId;
        this.ajaxIdentifier = ajaxIdentifier;
        this.itemsToSubmit = itemsToSubmit;
        this.noDataFoundMessage = noDataFoundMessage;

        // create custom element        
        this.viewerElement = document.createElement('f4a-viewer');

        // set component properties
        this.viewerElement.regionId = regionId;
        
        this.viewerElement.showToolbar = showToolbar;
        this.viewerElement.addHighlighting = addHighlighting;
        this.viewerElement.enableCallActivities = enableCallActivities;
        this.viewerElement.enableMousewheelZoom = enableMousewheelZoom;
        this.viewerElement.useBPMNcolors = useBPMNcolors;
        this.viewerElement.themePluginClass = themePluginClass;
        // pass config from js initialization function
        this.viewerElement.config = config;

        // attach custom element to DOM
        document.querySelector(`#${regionId} .t-Region-body`).appendChild(this.viewerElement);

        // define region functions
        apex.region.create( regionId, {
            refresh: () => this.refresh(),
            loadDiagram: () => this.loadDiagram(),
            getDiagram: () => this.getDiagram(),
            getSVG: () => this.getSVG(),
        } );

        if (refreshOnLoad) this.refresh();

        this.registerEvents();
    },

    refresh: function() {
        // only invoke load procedure here
        this.loadDiagram();
    },

    loadDiagram: function() {
        apex.server.plugin(
            this.ajaxIdentifier,
            {
                pageItems: $( this.itemsToSubmit, apex.gPageContext$ )
            },
            {
                refreshObject: "#" + this.viewerElement.canvas.id,
                loadingIndicator: "#" + this.viewerElement.canvas.id,
            }
        )
        .then( async pData => {
            if ( pData.found ) {
                $( "#" + this.viewerElement.canvas.id ).show();
                $( "#" + this.regionId + " span.nodatafound" ).hide();
                
                const diagram = this.viewerElement.loadData(pData.data);
                
                try {
                    await this.viewerElement.loadDiagram(diagram);

                    // trigger load event
                    apex.event.trigger( "#" + this.regionId, "mtbv_diagram_loaded",
                        { 
                            diagramIdentifier: this.viewerElement.diagramIdentifier, 
                            callingDiagramIdentifier: this.viewerElement.callingDiagramIdentifier, 
                            callingObjectId: this.viewerElement.callingObjectId
                        } 
                    );
                }
                catch(err) {
                    apex.debug.error('Loading Diagram failed.', err, diagram);
                }
            
            } else {
                $( "#" + this.viewerElement.canvas.id ).hide();          
                
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

    getDiagram: async function() {
        try {
            return await this.viewerElement.getDiagram();
        } catch (err) {
            apex.debug.error( "Get Diagram failed.", err );
        }
    },

    getSVG: async function() {
        try {
            return await this.viewerElement.getSVG();
        } catch (err) {
            apex.debug.error( "Get SVG failed.", err );
        }
    },

    registerEvents: function() {

        const capturedEvents = [
            "element.hover",
            "element.out",
            "element.click",
            "element.dblclick",
            "element.mousedown",
            "element.mouseup"
        ];

        const eventBus = this.viewerElement.getEventBus();
        
        capturedEvents.forEach( currentEvent => {
            eventBus.on( currentEvent, eventData => {
                apex.event.trigger( "#" + this.regionId, "mtbv_" + currentEvent.replace(".", "_"), eventData );
            });
        });
    }
}

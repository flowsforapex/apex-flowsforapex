var f4a = f4a || {};
f4a.plugins = f4a.plugins || {};
f4a.plugins.modeler = f4a.plugins.modeler || {
    
    render: async function(options) {

        const {
            regionId,
            ajaxIdentifier,
            itemsToSubmit,
            showCustomExtensions,
            themePluginClass,
            monacoEditorVersion,
        } = options;

        const monacoPath = `${apex_img_dir}libraries/monaco-editor/${monacoEditorVersion}`;

        // init monaco editor (will be used inside bundled code)
        window._monacoReady = new Promise(async (resolve, reject) => {

            // already existing
            if (window.monaco) {
                apex.debug.info("Monaco Editor already loaded.");
                
                resolve(window.monaco);
                return;
            }

            // try ESM version first (APEX 26.1+)
            try {
                const module = await import(`${monacoPath}/monaco-editor.min.js`);
                apex.debug.info("ESM version of Monaco Editor loaded.");

                const monaco = module.monaco;
                window.monaco = monaco;

                resolve(monaco);
                return;
            }
            catch(esmError) {
                apex.debug.warn("Loading ESM version of Monaco Editor failed. Trying AMD version now.")
            }

            // try AMD version else (APEX < 26.1)
            const amdPath = `${monacoPath}/min/vs`;

            // init monaco worker environment
            window.MonacoEnvironment = {
                getWorkerUrl: function (_moduleId, _label) {
                    return `${amdPath}/base/worker/workerMain.js`;
                }
            };

            require.config({ paths: { vs: amdPath } });

            require(
                ['vs/editor/editor.main']
                , (_module) => { 
                    apex.debug.info("AMD version of Monaco Editor loaded.");
                    resolve(window.monaco);
                }
                , (_error) => { 
                    apex.debug.warn("Loading AMD version of Monaco Editor failed.");

                    apex.message.showErrors( [
                        {
                            type: "error",
                            location: ["page"],
                            message: "Couldn't find Monaco Editor. <br/> Please check the provided version in the Component Settings.",
                            unsafe: false,
                        },
                    ] );
                }
            );
        });

        // store apex-related input
        this.regionId = regionId;
        this.ajaxIdentifier = ajaxIdentifier;
        this.itemsToSubmit = itemsToSubmit;

        // create custom element        
        this.modelerElement = document.createElement('f4a-modeler');

        // set component properties
        this.modelerElement.regionId = regionId;
        this.modelerElement.ajaxIdentifier = ajaxIdentifier;
        this.modelerElement.showCustomExtensions = showCustomExtensions;
        this.modelerElement.themePluginClass = themePluginClass;
        
        // attach custom element to DOM
        document.querySelector(`#${regionId} .t-Region-body`).appendChild(this.modelerElement);

        // define region functions
        apex.region.create( regionId, {
            refresh: () => this.refresh(),
            loadDiagram: () => this.loadDiagram(),
            save: () => this.save(),
            getDiagram: () => this.getDiagram(),
            getSVG: () => this.getSVG(),
        } );

        // register custom changed handler with APEX
        apex.page.warnOnUnsavedChanges( null, () => {
            return this.modelerElement.isChanged();
        } );

        // initially load diagram
        this.loadDiagram()
    },

    refresh: function() {
        if ( this.modelerElement.isChanged() ) {
            apex.message.confirm("Model has changed. Discard changes?",
                ( okPressed ) => {
                    if ( okPressed ) {
                        this.loadDiagram();
                    }
                }
            );
        } else {
            this.loadDiagram();
        }
    },

    loadDiagram: function() {
        apex.server.plugin(
            this.ajaxIdentifier,
            {
                pageItems: $( this.itemsToSubmit, apex.gPageContext$ ),
                x01: "LOAD",
            },
            {
                refreshObject: "#" + this.modelerElement.canvas.id,
                loadingIndicator: "#" + this.modelerElement.canvas.id,
            }
        )
        .then( async pData => {
            
            const diagram = pData.data.content;
            this.diagramId = pData.data.id;
            
            try {
                await this.modelerElement.loadDiagram(diagram);
            }
            catch(err) {
                apex.debug.error('Loading Diagram failed.', err, diagram);
            }
        } );
    },

    save: async function() {
        const xml = await this.modelerElement.getDiagram();
        
        apex.server.plugin(this.ajaxIdentifier, {
            regions: [
                {
                    id: this.regionId,
                    data: {
                        id: this.diagramId,
                        content: xml,
                    },
                },
            ],
            x01: "SAVE",
        })
        .then( ( pData ) => {
            apex.message.clearErrors();
            if ( pData.success ) {
                this.modelerElement.changed = false;
                apex.message.showPageSuccess( pData.message );
            } else {
                apex.message.showErrors( [
                    {
                        type: "error",
                        location: ["page"],
                        message: pData.message,
                        unsafe: false,
                    },
                ] );
            }
        });
    },

    getDiagram: async function () {
        try {
            return await this.modelerElement.getDiagram();
        } catch (err) {
            apex.debug.error( "Get Diagram failed.", err );
        }
    },

    getSVG: async function () {
        try {
            return await this.modelerElement.getSVG();
        } catch (err) {
            apex.debug.error( "Get SVG failed.", err );
        }
    },
}

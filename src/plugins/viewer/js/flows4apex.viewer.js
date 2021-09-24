var bpmnViewer =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ({

/***/ "./index.js":
/*!******************!*\
  !*** ./index.js ***!
  \******************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var bpmn_js_lib_NavigatedViewer__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! bpmn-js/lib/NavigatedViewer */ "./node_modules/bpmn-js/lib/NavigatedViewer.js");
/* harmony import */ var bpmn_js_lib_Viewer__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! bpmn-js/lib/Viewer */ "./node_modules/bpmn-js/lib/Viewer.js");
/* harmony import */ var _lib_spViewModule__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./lib/spViewModule */ "./lib/spViewModule/index.js");
/* harmony import */ var _lib_styleModule__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./lib/styleModule */ "./lib/styleModule/index.js");





var bpmnViewer = {
  Viewer: bpmn_js_lib_Viewer__WEBPACK_IMPORTED_MODULE_1__["default"],
  NavigatedViewer: bpmn_js_lib_NavigatedViewer__WEBPACK_IMPORTED_MODULE_0__["default"],
  customModules: {
    spViewModule: _lib_spViewModule__WEBPACK_IMPORTED_MODULE_2__["default"],
    styleModule: _lib_styleModule__WEBPACK_IMPORTED_MODULE_3__["default"],
  },
};

/* harmony default export */ __webpack_exports__["default"] = (bpmnViewer);


/***/ }),

/***/ "./lib/spViewModule/index.js":
/*!***********************************!*\
  !*** ./lib/spViewModule/index.js ***!
  \***********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* Module for zooming into a Subprocess*/
// import CoreModule from './bpmn-viewer.js';

var spViewModule = {
  __depends__: [],
  __init__: ['sPViewModule'],
  sPViewModule: ['type', SPViewModule],
};

SPViewModule.$inject = ['eventBus'];

function SPViewModule(eventBus) {
  var currentExpandedProcess;
  var previousTextStyle;
  var previousIconStyle;
  var previousRectStyle;

  var isExpanded;
  var originalWidth;
  var originalHeight;
  var originalX = 0;
  var originalY = 0;

  var hiddenElements;

  function setProcessTextStyle(parentProcess, textStyle) {
    var previousStyle;
    var visualElements = parentProcess.getElementsByClassName('djs-visual');
    if (visualElements.length != 0) {
      var textElements = visualElements[0].getElementsByTagName('text');
      if (textElements.length != 0) {
        previousStyle = textElements[0].getAttribute('style');
        textElements[0].setAttribute('style', textStyle);
      }
    }
    return previousStyle;
  }

  function setProcessIconStyle(parentProcess, textStyle) {
    var previousStyle;
    var visualElements = parentProcess.getElementsByClassName('djs-visual');
    if (visualElements.length != 0) {
      var rectElements = visualElements[0].getElementsByTagName('rect');
      if (rectElements.length != 0) {
        previousStyle = rectElements[1].getAttribute('style');
        rectElements[1].setAttribute('style', textStyle);
      }
    }
    return previousStyle;
  }

  function setProcessIconRect(parentProcess, textStyle) {
    var previousStyle;
    var visualElements = parentProcess.getElementsByClassName('djs-visual');
    if (visualElements.length != 0) {
      var pathElements = visualElements[0].getElementsByTagName('path');
      if (pathElements.length != 0) {
        previousStyle = pathElements[0].getAttribute('style');
        pathElements[0].setAttribute('style', textStyle);
      }
    }
    return previousStyle;
  }

  function parseMatrix(matrix) {
    matrix = matrix.replace('matrix(', '');
    matrix = matrix.replace(')', '');
    return matrix.split(' ');
  }

  function difference(a, b) {
    return Math.abs(a - b);
  }

  function calculateCorrectBounds(subElements) {
    var bounds = { width: 0, height: 0, x: 0, y: 0 };
    var parentBounds = { width: 0, height: 0, x: 0, y: 0 };
    var shapeElement = subElements.parentElement ? subElements.parentElement.children[0] : null;

    // getting parent x, y with and height for later calculations
    if (shapeElement) {
      var rectElement = shapeElement.getElementsByTagName('rect');
      parentBounds.x = rectElement[0].getAttribute('x');
      parentBounds.y = rectElement[0].getAttribute('y');
      parentBounds.width = rectElement[0].getAttribute('width');
      parentBounds.height = rectElement[0].getAttribute('height');
    }

    var minX = 100000;
    var maxX = 0;
    var minY = 100000;
    var maxY = 0;

    subElements.subProcs.forEach((subElement) => {
      // looping Event type Elements that have a matrix that has to be parsed to extract coordinates
      Array.from(subElement.children).forEach((childElement) => {
        if (childElement.hasAttributes('transform')) {
          var transform = childElement.getAttribute('transform');
          if (transform != null) {
            var result = parseMatrix(transform);
            var rectElements = childElement.getElementsByTagName('rect');

            if (result.length >= 6) {
              if (rectElements.length != 0) {
                Array.from(rectElements).forEach((rectElement) => {
                  // we are applying those multipliers here so the items are not directly at the edge of the parent
                  var width =
                    parseInt(rectElement.getAttribute('width'), 10) * 2;
                  var height =
                    parseInt(rectElement.getAttribute('height'), 10) * 2;

                  if (parseInt(result[4], 10) < minX) {
                    minX = parseInt(result[4], 10);
                  }
                  if (parseInt(result[5], 10) < minY) {
                    minY = parseInt(result[5], 10);
                  }
                  if (parseInt(result[4], 10) + width > maxX) {
                    maxX = parseInt(result[4], 10) + width;
                  }
                  if (parseInt(result[5], 10) + height > maxY) {
                    maxY = parseInt(result[5], 10) + height;
                  }
                });
              }
            }
          }
        }
      });

      // looping through all the normal rects that dont have a matrix
      var tagElements = subElement.getElementsByTagName('rect');
      if (tagElements.length != 0) {
        var x = Number(tagElements[0].getAttribute('x'));
        var y = Number(tagElements[0].getAttribute('y'));

        // We are applying those multipliers here so the items are not directly at the edge of the parent
        var width = Number(tagElements[0].getAttribute('width')) * 2;
        var height = Number(tagElements[0].getAttribute('height')) * 2;

        // skip "faulty" elements that have 0, 0 as coordinates
        if (x > 0 && y > 0) {
          if (x < minX) {
            minX = x;
          }
          if (x + width > maxX) {
            maxX = x + width;
          }
          if (y < minY) {
            minY = y;
          }
          if (y + height > maxY) {
            maxY = y + height;
          }
        }
      }
    });

    // calculating width and height
    bounds.width = maxX - minX;
    bounds.height = maxY - minY;

    // parsing parentPos
    var transform = subElements.parentElement ? subElements.parentElement.children[0].getAttribute('transform') : null;
    if (transform) {
      var matrix = parseMatrix(transform);
      if (matrix.length >= 6) {
        parentBounds.x = parseInt(matrix[4], 10);
        parentBounds.y = parseInt(matrix[5], 10);
      }
    }

    var centerPointParentX = Math.abs(parentBounds.x - parentBounds.width / 2);
    var centerPointParentY = Math.abs(parentBounds.y - parentBounds.height / 2);

    var centerExtremeX = Math.abs(maxX - (maxX - minX) / 2);
    var centerExtremeY = Math.abs(maxY - (maxY - minY) / 2);

    // with this code we are checking wether the subElements are centered in the mainProc
    if (centerExtremeX != centerPointParentX) {
      // apply offset X (the offset we have to apply so the elements are centered on the X axis)
      var offsetX = difference(centerExtremeX, centerPointParentX);
      if (centerPointParentX < centerExtremeX) {
        offsetX = -offsetX;
      }
    }

    if (centerExtremeY != centerPointParentY) {
      // apply offset Y (the offset we have to apply so the elements are centered on the Y axis)
      var offsetY = difference(centerExtremeY, centerPointParentY);
      if (centerPointParentY < centerExtremeY) {
        offsetY = -offsetY;
      }
    }

    // calculating new process position (the offsets could be added here instead of moving all the subElements we would only move the parentProc)
    bounds.x = -(bounds.width / 2 - parentBounds.width / 2);
    bounds.y = -(bounds.height / 2 - parentBounds.height / 2);
    return bounds;
  }

  function setBoxBounds(subElements, originalBounds) {
    var shapeElement = subElements.parentElement ? subElements.parentElement.children[0] : null;
    if (shapeElement) {
      var rectElement = shapeElement.getElementsByTagName('rect');
      rectElement[0].setAttribute('width', originalBounds.width);
      rectElement[0].setAttribute('height', originalBounds.height);
      rectElement[0].setAttribute('x', originalBounds.x);
      rectElement[0].setAttribute('y', originalBounds.y);
    }
  }

  function getOriginalBounds(subElements) {
    var shapeElement = subElements.parentElement.getElementsByClassName(
      'djs-element djs-shape selected'
    );
    if (shapeElement.length != 0) {
      var rectElement = shapeElement[0].getElementsByTagName('rect');
      originalWidth = rectElement[0].getAttribute('width');
      originalHeight = rectElement[0].getAttribute('height');
    }
  }

  function getSubProcessElements(elementID) {
    var subElementWithParent = { subProcs: new Array(), parentElement: null };
    var djsGroupElements = document.getElementsByClassName('djs-group');
    Array.from(djsGroupElements).forEach((djsGroupElement) => {
      if (djsGroupElement.children != 0) {
        if (
          djsGroupElement.children[0].getAttribute('data-element-id') ==
          elementID
        ) {
          var tagElements = djsGroupElement.getElementsByTagName('path');
          if (tagElements.length != 0) {
            if (tagElements[0].getAttribute('data-marker') == 'sub-process') {
              subElementWithParent.parentElement = djsGroupElement;
              var djsChildrenElements =
                djsGroupElement.getElementsByClassName('djs-children');
              Array.from(djsChildrenElements).forEach((djsChildrenElement) => {
                var djsChildrenGroupElements =
                  djsChildrenElement.getElementsByClassName('djs-group');
                Array.from(djsChildrenGroupElements).forEach(
                  (djsChildrenGroupElement) => {
                    subElementWithParent.subProcs.push(djsChildrenGroupElement);
                  }
                );
              });
            }
          }
        }
      }
    });
    return subElementWithParent;
  }

  function getAllElementsInRect(left, right, top, bottom) {
    var elementsInRect = new Array();
    var layerElements = document.getElementsByClassName('layer-base');
    Array.from(layerElements[0].children).forEach((layerElement) => {
      if (layerElement.children.length != 0) {
        var transform = layerElement.children[0].getAttribute('transform');
        if (transform) {
          var matrix = parseMatrix(transform);
          if (matrix.length >= 6) {
            var x = parseInt(matrix[4], 10);
            var y = parseInt(matrix[5], 10);
            if ((x >= left && x <= right) || (y >= top && y <= bottom)) {
              var elementID =
                layerElement.children[0].getAttribute('data-element-id');
              if (
                elementID.includes('TextAnnotation') ||
                elementID.includes('Association') ||
                elementID.includes('label')
              ) {
                elementsInRect.push(layerElement.children[0]);
              }
            }
          }
        } else if (layerElement.children[0].length != 0) {
          var rectElement =
            layerElement.children[0].getElementsByTagName('rect');
          if (rectElement.length != 0) {
            var x = parseInt(rectElement[0].getAttribute('x'), 10);
            var y = parseInt(rectElement[0].getAttribute('y'), 10);
            if ((x >= left && x <= right) || (y >= top && y <= bottom)) {
              var elementID =
                layerElement.children[0].getAttribute('data-element-id');
              if (elementID.includes('Association')) {
                elementsInRect.push(layerElement.children[0]);
              }
            }
          }
        }
      }
    });
    return elementsInRect;
  }

  eventBus.on('element.click', function (event) {
    if (event.element.type == 'bpmn:SubProcess') {
      var subElements = getSubProcessElements(event.element.id);
      var testBounds = calculateCorrectBounds(subElements);

      var transform = subElements.parentElement ? subElements.parentElement.children[0].getAttribute('transform') : null;
      if (transform) {
        var matrix = parseMatrix(transform);
        if (matrix.length >= 6) {
          var x = parseInt(matrix[4], 10) + testBounds.x;
          var y = parseInt(matrix[5], 10) + testBounds.y;
          hiddenElements = getAllElementsInRect(
            x,
            x + testBounds.width,
            y,
            y + testBounds.height
          );
        }
      }

      if (subElements.subProcs != 0) {
        if (!isExpanded) {
          getOriginalBounds(subElements);
          currentExpandedProcess = subElements.parentElement;
          isExpanded = true;
          setBoxBounds(subElements, testBounds);
          previousTextStyle = setProcessTextStyle(
            subElements.parentElement,
            'fill: none;'
          );
          previousIconStyle = setProcessIconStyle(
            subElements.parentElement,
            'fill: none; stroke: none;'
          );
          previousRectStyle = setProcessIconRect(
            subElements.parentElement,
            'stroke: none;'
          );
          subElements.subProcs.forEach((subElement) => {
            subElement.lastElementChild.setAttribute(
              'style',
              'display: block;'
            );
          });

          if (hiddenElements != 0) {
            hiddenElements.forEach((hiddenElement) => {
              hiddenElement.setAttribute('style', 'display: none;');
            });
          }
        } else if (currentExpandedProcess == subElements.parentElement) {
          subElements.subProcs.forEach((subElement) => {
            subElement.lastElementChild.setAttribute('style', 'display: none;');
          });
          isExpanded = false;
          setBoxBounds(subElements, {
            width: originalWidth,
            height: originalHeight,
            x: originalX,
            y: originalY,
          });
          setProcessTextStyle(subElements.parentElement, previousTextStyle);
          setProcessIconStyle(subElements.parentElement, previousIconStyle);
          setProcessIconRect(subElements.parentElement, previousRectStyle);

          if (hiddenElements != 0) {
            hiddenElements.forEach((hiddenElement) => {
              hiddenElement.setAttribute('style', 'display: block;');
            });
          }
        }
      }
    }
  });
}

/* harmony default export */ __webpack_exports__["default"] = (spViewModule);


/***/ }),

/***/ "./lib/styleModule/StyleModule.js":
/*!****************************************!*\
  !*** ./lib/styleModule/StyleModule.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return StyleModule; });
function StyleModule() {}

StyleModule.prototype.addStylesToElements = function (elements, css) {
  for (const e of elements) {
    var rect = document.querySelector(
      `g[data-element-id="${e}"]:not(.djs-connection) .djs-visual > rect`
    );
    var circles = document.querySelectorAll(
      `g[data-element-id="${e}"]:not(.djs-connection) .djs-visual > circle`
    );
    var polygons = document.querySelectorAll(
      `g[data-element-id="${e}"]:not(.djs-connection) .djs-visual > polygon`
    );
    var text = document.querySelector(
      `g[data-element-id="${e}"]:not(.djs-connection) .djs-visual > text`
    );
    var paths = document.querySelectorAll(
      `g[data-element-id="${e}"]:not(.djs-connection) .djs-visual > path`
    );

    if (css.fill !== undefined) {
      if (rect) rect.style.fill = css.fill;
      if (circles.length > 0) circles.forEach(c => (c.style.fill = css.fill));
      if (polygons.length > 0) { polygons.forEach(p => (p.style.fill = css.fill)); }
      if (rect && paths.length > 0) { paths.forEach(p => (p.style.fill = css.fill)); }
    }

    if (css.border !== undefined) {
      if (rect) rect.style.stroke = css.border;
      if (circles.length > 0) { circles.forEach(c => (c.style.stroke = css.border)); }
      if (polygons.length > 0) { polygons.forEach(p => (p.style.stroke = css.border)); }
    }

    if (css.label !== undefined) {
      if (text) text.style.fill = css.label;
      if (paths.length > 0) paths.forEach(p => (p.style.stroke = css.label));
      if (polygons.length > 0 && paths.length > 0) { paths.forEach(p => (p.style.fill = css.label)); }
    }
  }
};

StyleModule.prototype.addToSVGStyle = function (svg, style) {
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(svg, 'text/xml');

  var defs = xmlDoc.getElementsByTagName('defs')[0];

  var styleNode = document.createElement('style');
  styleNode.setAttribute('type', 'text/css');
  var content = document.createTextNode(style);
  styleNode.appendChild(content);
  defs.appendChild(styleNode);

  var xmlText = new XMLSerializer().serializeToString(xmlDoc);

  return xmlText;
};


/***/ }),

/***/ "./lib/styleModule/index.js":
/*!**********************************!*\
  !*** ./lib/styleModule/index.js ***!
  \**********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _StyleModule_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./StyleModule.js */ "./lib/styleModule/StyleModule.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: ['styleModule'],
  styleModule: ['type', _StyleModule_js__WEBPACK_IMPORTED_MODULE_0__["default"]]
});


/***/ }),

/***/ "./node_modules/bpmn-js/lib/BaseViewer.js":
/*!************************************************!*\
  !*** ./node_modules/bpmn-js/lib/BaseViewer.js ***!
  \************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return BaseViewer; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var diagram_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! diagram-js */ "./node_modules/diagram-js/index.js");
/* harmony import */ var bpmn_moddle__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! bpmn-moddle */ "./node_modules/bpmn-moddle/dist/index.esm.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_5___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_5__);
/* harmony import */ var _import_Importer__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./import/Importer */ "./node_modules/bpmn-js/lib/import/Importer.js");
/* harmony import */ var _util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./util/CompatibilityUtil */ "./node_modules/bpmn-js/lib/util/CompatibilityUtil.js");
/* harmony import */ var _util_PoweredByUtil__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./util/PoweredByUtil */ "./node_modules/bpmn-js/lib/util/PoweredByUtil.js");
/**
 * The code in the <project-logo></project-logo> area
 * must not be changed.
 *
 * @see http://bpmn.io/license for more information.
 */















/**
 * A base viewer for BPMN 2.0 diagrams.
 *
 * Have a look at {@link Viewer}, {@link NavigatedViewer} or {@link Modeler} for
 * bundles that include actual features.
 *
 * @param {Object} [options] configuration options to pass to the viewer
 * @param {DOMElement} [options.container] the container to render the viewer in, defaults to body.
 * @param {string|number} [options.width] the width of the viewer
 * @param {string|number} [options.height] the height of the viewer
 * @param {Object} [options.moddleExtensions] extension packages to provide
 * @param {Array<didi.Module>} [options.modules] a list of modules to override the default modules
 * @param {Array<didi.Module>} [options.additionalModules] a list of modules to use with the default modules
 */
function BaseViewer(options) {

  options = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, DEFAULT_OPTIONS, options);

  this._moddle = this._createModdle(options);

  this._container = this._createContainer(options);

  /* <project-logo> */

  addProjectLogo(this._container);

  /* </project-logo> */

  this._init(this._container, this._moddle, options);
}

inherits__WEBPACK_IMPORTED_MODULE_5___default()(BaseViewer, diagram_js__WEBPACK_IMPORTED_MODULE_3__["default"]);

/**
* The importXML result.
*
* @typedef {Object} ImportXMLResult
*
* @property {Array<string>} warnings
*/

/**
* The importXML error.
*
* @typedef {Error} ImportXMLError
*
* @property {Array<string>} warnings
*/

/**
 * Parse and render a BPMN 2.0 diagram.
 *
 * Once finished the viewer reports back the result to the
 * provided callback function with (err, warnings).
 *
 * ## Life-Cycle Events
 *
 * During import the viewer will fire life-cycle events:
 *
 *   * import.parse.start (about to read model from xml)
 *   * import.parse.complete (model read; may have worked or not)
 *   * import.render.start (graphical import start)
 *   * import.render.complete (graphical import finished)
 *   * import.done (everything done)
 *
 * You can use these events to hook into the life-cycle.
 *
 * @param {string} xml the BPMN 2.0 xml
 * @param {ModdleElement<BPMNDiagram>|string} [bpmnDiagram] BPMN diagram or id of diagram to render (if not provided, the first one will be rendered)
 *
 * Returns {Promise<ImportXMLResult, ImportXMLError>}
 */
BaseViewer.prototype.importXML = Object(_util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__["wrapForCompatibility"])(function importXML(xml, bpmnDiagram) {

  var self = this;

  function ParseCompleteEvent(data) {

    var event = self.get('eventBus').createEvent(data);

    // TODO(nikku): remove with future bpmn-js version
    Object.defineProperty(event, 'context', {
      enumerable: true,
      get: function() {

        console.warn(new Error(
          'import.parse.complete <context> is deprecated ' +
          'and will be removed in future library versions'
        ));

        return {
          warnings: data.warnings,
          references: data.references,
          elementsById: data.elementsById
        };
      }
    });

    return event;
  }

  return new Promise(function(resolve, reject) {

    // hook in pre-parse listeners +
    // allow xml manipulation
    xml = self._emit('import.parse.start', { xml: xml }) || xml;

    self._moddle.fromXML(xml, 'bpmn:Definitions').then(function(result) {
      var definitions = result.rootElement;
      var references = result.references;
      var parseWarnings = result.warnings;
      var elementsById = result.elementsById;

      // hook in post parse listeners +
      // allow definitions manipulation
      definitions = self._emit('import.parse.complete', ParseCompleteEvent({
        error: null,
        definitions: definitions,
        elementsById: elementsById,
        references: references,
        warnings: parseWarnings
      })) || definitions;

      self.importDefinitions(definitions, bpmnDiagram).then(function(result) {
        var allWarnings = [].concat(parseWarnings, result.warnings || []);

        self._emit('import.done', { error: null, warnings: allWarnings });

        return resolve({ warnings: allWarnings });
      }).catch(function(err) {
        var allWarnings = [].concat(parseWarnings, err.warnings || []);

        self._emit('import.done', { error: err, warnings: allWarnings });

        return reject(addWarningsToError(err, allWarnings));
      });
    }).catch(function(err) {

      self._emit('import.parse.complete', {
        error: err
      });

      err = checkValidationError(err);

      self._emit('import.done', { error: err, warnings: err.warnings });

      return reject(err);
    });
  });
});

/**
* The importDefinitions result.
*
* @typedef {Object} ImportDefinitionsResult
*
* @property {Array<string>} warnings
*/

/**
* The importDefinitions error.
*
* @typedef {Error} ImportDefinitionsError
*
* @property {Array<string>} warnings
*/

/**
 * Import parsed definitions and render a BPMN 2.0 diagram.
 *
 * Once finished the viewer reports back the result to the
 * provided callback function with (err, warnings).
 *
 * ## Life-Cycle Events
 *
 * During import the viewer will fire life-cycle events:
 *
 *   * import.render.start (graphical import start)
 *   * import.render.complete (graphical import finished)
 *
 * You can use these events to hook into the life-cycle.
 *
 * @param {ModdleElement<Definitions>} definitions parsed BPMN 2.0 definitions
 * @param {ModdleElement<BPMNDiagram>|string} [bpmnDiagram] BPMN diagram or id of diagram to render (if not provided, the first one will be rendered)
 *
 * Returns {Promise<ImportDefinitionsResult, ImportDefinitionsError>}
 */
BaseViewer.prototype.importDefinitions = Object(_util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__["wrapForCompatibility"])(function importDefinitions(definitions, bpmnDiagram) {

  var self = this;

  return new Promise(function(resolve, reject) {

    self._setDefinitions(definitions);

    self.open(bpmnDiagram).then(function(result) {

      var warnings = result.warnings;

      return resolve({ warnings: warnings });
    }).catch(function(err) {

      return reject(err);
    });
  });
});

/**
 * The open result.
 *
 * @typedef {Object} OpenResult
 *
 * @property {Array<string>} warnings
 */

/**
* The open error.
*
* @typedef {Error} OpenError
*
* @property {Array<string>} warnings
*/

/**
 * Open diagram of previously imported XML.
 *
 * Once finished the viewer reports back the result to the
 * provided callback function with (err, warnings).
 *
 * ## Life-Cycle Events
 *
 * During switch the viewer will fire life-cycle events:
 *
 *   * import.render.start (graphical import start)
 *   * import.render.complete (graphical import finished)
 *
 * You can use these events to hook into the life-cycle.
 *
 * @param {string|ModdleElement<BPMNDiagram>} [bpmnDiagramOrId] id or the diagram to open
 *
 * Returns {Promise<OpenResult, OpenError>}
 */
BaseViewer.prototype.open = Object(_util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__["wrapForCompatibility"])(function open(bpmnDiagramOrId) {

  var definitions = this._definitions;
  var bpmnDiagram = bpmnDiagramOrId;

  var self = this;

  return new Promise(function(resolve, reject) {
    if (!definitions) {
      var err1 = new Error('no XML imported');

      return reject(addWarningsToError(err1, []));
    }

    if (typeof bpmnDiagramOrId === 'string') {
      bpmnDiagram = findBPMNDiagram(definitions, bpmnDiagramOrId);

      if (!bpmnDiagram) {
        var err2 = new Error('BPMNDiagram <' + bpmnDiagramOrId + '> not found');

        return reject(addWarningsToError(err2, []));
      }
    }

    // clear existing rendered diagram
    // catch synchronous exceptions during #clear()
    try {
      self.clear();
    } catch (error) {

      return reject(addWarningsToError(error, []));
    }

    // perform graphical import
    Object(_import_Importer__WEBPACK_IMPORTED_MODULE_6__["importBpmnDiagram"])(self, definitions, bpmnDiagram).then(function(result) {

      var warnings = result.warnings;

      return resolve({ warnings: warnings });
    }).catch(function(err) {

      return reject(err);
    });
  });
});

/**
 * The saveXML result.
 *
 * @typedef {Object} SaveXMLResult
 *
 * @property {string} xml
 */

/**
 * Export the currently displayed BPMN 2.0 diagram as
 * a BPMN 2.0 XML document.
 *
 * ## Life-Cycle Events
 *
 * During XML saving the viewer will fire life-cycle events:
 *
 *   * saveXML.start (before serialization)
 *   * saveXML.serialized (after xml generation)
 *   * saveXML.done (everything done)
 *
 * You can use these events to hook into the life-cycle.
 *
 * @param {Object} [options] export options
 * @param {boolean} [options.format=false] output formatted XML
 * @param {boolean} [options.preamble=true] output preamble
 *
 * Returns {Promise<SaveXMLResult, Error>}
 */
BaseViewer.prototype.saveXML = Object(_util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__["wrapForCompatibility"])(function saveXML(options) {

  options = options || {};

  var self = this;

  var definitions = this._definitions;

  return new Promise(function(resolve) {

    if (!definitions) {
      return resolve({
        error: new Error('no definitions loaded')
      });
    }

    // allow to fiddle around with definitions
    definitions = self._emit('saveXML.start', {
      definitions: definitions
    }) || definitions;

    self._moddle.toXML(definitions, options).then(function(result) {

      var xml = result.xml;

      xml = self._emit('saveXML.serialized', {
        xml: xml
      }) || xml;

      return resolve({
        xml: xml
      });
    });
  }).catch(function(error) {
    return { error: error };
  }).then(function(result) {

    self._emit('saveXML.done', result);

    var error = result.error;

    if (error) {
      return Promise.reject(error);
    }

    return result;
  });
});

/**
 * The saveSVG result.
 *
 * @typedef {Object} SaveSVGResult
 *
 * @property {string} svg
 */

/**
 * Export the currently displayed BPMN 2.0 diagram as
 * an SVG image.
 *
 * ## Life-Cycle Events
 *
 * During SVG saving the viewer will fire life-cycle events:
 *
 *   * saveSVG.start (before serialization)
 *   * saveSVG.done (everything done)
 *
 * You can use these events to hook into the life-cycle.
 *
 * @param {Object} [options]
 *
 * Returns {Promise<SaveSVGResult, Error>}
 */
BaseViewer.prototype.saveSVG = Object(_util_CompatibilityUtil__WEBPACK_IMPORTED_MODULE_7__["wrapForCompatibility"])(function saveSVG(options) {

  options = options || {};

  var self = this;

  return new Promise(function(resolve, reject) {

    self._emit('saveSVG.start');

    var svg, err;

    try {
      var canvas = self.get('canvas');

      var contentNode = canvas.getDefaultLayer(),
          defsNode = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["query"])('defs', canvas._svg);

      var contents = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_2__["innerSVG"])(contentNode),
          defs = defsNode ? '<defs>' + Object(tiny_svg__WEBPACK_IMPORTED_MODULE_2__["innerSVG"])(defsNode) + '</defs>' : '';

      var bbox = contentNode.getBBox();

      svg =
        '<?xml version="1.0" encoding="utf-8"?>\n' +
        '<!-- created with bpmn-js / http://bpmn.io -->\n' +
        '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n' +
        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ' +
             'width="' + bbox.width + '" height="' + bbox.height + '" ' +
             'viewBox="' + bbox.x + ' ' + bbox.y + ' ' + bbox.width + ' ' + bbox.height + '" version="1.1">' +
          defs + contents +
        '</svg>';
    } catch (e) {
      err = e;
    }

    self._emit('saveSVG.done', {
      error: err,
      svg: svg
    });

    if (!err) {
      return resolve({ svg: svg });
    }

    return reject(err);
  });
});

/**
 * Get a named diagram service.
 *
 * @example
 *
 * var elementRegistry = viewer.get('elementRegistry');
 * var startEventShape = elementRegistry.get('StartEvent_1');
 *
 * @param {string} name
 *
 * @return {Object} diagram service instance
 *
 * @method BaseViewer#get
 */

/**
 * Invoke a function in the context of this viewer.
 *
 * @example
 *
 * viewer.invoke(function(elementRegistry) {
 *   var startEventShape = elementRegistry.get('StartEvent_1');
 * });
 *
 * @param {Function} fn to be invoked
 *
 * @return {Object} the functions return value
 *
 * @method BaseViewer#invoke
 */


BaseViewer.prototype._setDefinitions = function(definitions) {
  this._definitions = definitions;
};

BaseViewer.prototype.getModules = function() {
  return this._modules;
};

/**
 * Remove all drawn elements from the viewer.
 *
 * After calling this method the viewer can still
 * be reused for opening another diagram.
 *
 * @method BaseViewer#clear
 */
BaseViewer.prototype.clear = function() {
  if (!this.getDefinitions()) {

    // no diagram to clear
    return;
  }

  // remove businessObject#di binding
  //
  // this is necessary, as we establish the bindings
  // in the BpmnTreeWalker (and assume none are given
  // on reimport)
  this.get('elementRegistry').forEach(function(element) {
    var bo = element.businessObject;

    if (bo && bo.di) {
      delete bo.di;
    }
  });

  // remove drawn elements
  diagram_js__WEBPACK_IMPORTED_MODULE_3__["default"].prototype.clear.call(this);
};

/**
 * Destroy the viewer instance and remove all its
 * remainders from the document tree.
 */
BaseViewer.prototype.destroy = function() {

  // diagram destroy
  diagram_js__WEBPACK_IMPORTED_MODULE_3__["default"].prototype.destroy.call(this);

  // dom detach
  Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["remove"])(this._container);
};

/**
 * Register an event listener
 *
 * Remove a previously added listener via {@link #off(event, callback)}.
 *
 * @param {string} event
 * @param {number} [priority]
 * @param {Function} callback
 * @param {Object} [that]
 */
BaseViewer.prototype.on = function(event, priority, callback, target) {
  return this.get('eventBus').on(event, priority, callback, target);
};

/**
 * De-register an event listener
 *
 * @param {string} event
 * @param {Function} callback
 */
BaseViewer.prototype.off = function(event, callback) {
  this.get('eventBus').off(event, callback);
};

BaseViewer.prototype.attachTo = function(parentNode) {

  if (!parentNode) {
    throw new Error('parentNode required');
  }

  // ensure we detach from the
  // previous, old parent
  this.detach();

  // unwrap jQuery if provided
  if (parentNode.get && parentNode.constructor.prototype.jquery) {
    parentNode = parentNode.get(0);
  }

  if (typeof parentNode === 'string') {
    parentNode = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["query"])(parentNode);
  }

  parentNode.appendChild(this._container);

  this._emit('attach', {});

  this.get('canvas').resized();
};

BaseViewer.prototype.getDefinitions = function() {
  return this._definitions;
};

BaseViewer.prototype.detach = function() {

  var container = this._container,
      parentNode = container.parentNode;

  if (!parentNode) {
    return;
  }

  this._emit('detach', {});

  parentNode.removeChild(container);
};

BaseViewer.prototype._init = function(container, moddle, options) {

  var baseModules = options.modules || this.getModules(),
      additionalModules = options.additionalModules || [],
      staticModules = [
        {
          bpmnjs: [ 'value', this ],
          moddle: [ 'value', moddle ]
        }
      ];

  var diagramModules = [].concat(staticModules, baseModules, additionalModules);

  var diagramOptions = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["omit"])(options, [ 'additionalModules' ]), {
    canvas: Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, options.canvas, { container: container }),
    modules: diagramModules
  });

  // invoke diagram constructor
  diagram_js__WEBPACK_IMPORTED_MODULE_3__["default"].call(this, diagramOptions);

  if (options && options.container) {
    this.attachTo(options.container);
  }
};

/**
 * Emit an event on the underlying {@link EventBus}
 *
 * @param  {string} type
 * @param  {Object} event
 *
 * @return {Object} event processing result (if any)
 */
BaseViewer.prototype._emit = function(type, event) {
  return this.get('eventBus').fire(type, event);
};

BaseViewer.prototype._createContainer = function(options) {

  var container = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])('<div class="bjs-container"></div>');

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(container.style, {
    width: ensureUnit(options.width),
    height: ensureUnit(options.height),
    position: options.position
  });

  return container;
};

BaseViewer.prototype._createModdle = function(options) {
  var moddleOptions = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, this._moddleExtensions, options.moddleExtensions);

  return new bpmn_moddle__WEBPACK_IMPORTED_MODULE_4__["default"](moddleOptions);
};

BaseViewer.prototype._modules = [];

// helpers ///////////////

function addWarningsToError(err, warningsAry) {
  err.warnings = warningsAry;
  return err;
}

function checkValidationError(err) {

  // check if we can help the user by indicating wrong BPMN 2.0 xml
  // (in case he or the exporting tool did not get that right)

  var pattern = /unparsable content <([^>]+)> detected([\s\S]*)$/;
  var match = pattern.exec(err.message);

  if (match) {
    err.message =
      'unparsable content <' + match[1] + '> detected; ' +
      'this may indicate an invalid BPMN 2.0 diagram file' + match[2];
  }

  return err;
}

var DEFAULT_OPTIONS = {
  width: '100%',
  height: '100%',
  position: 'relative'
};


/**
 * Ensure the passed argument is a proper unit (defaulting to px)
 */
function ensureUnit(val) {
  return val + (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(val) ? 'px' : '');
}


/**
 * Find BPMNDiagram in definitions by ID
 *
 * @param {ModdleElement<Definitions>} definitions
 * @param {string} diagramId
 *
 * @return {ModdleElement<BPMNDiagram>|null}
 */
function findBPMNDiagram(definitions, diagramId) {
  if (!diagramId) {
    return null;
  }

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(definitions.diagrams, function(element) {
    return element.id === diagramId;
  }) || null;
}


/* <project-logo> */





/**
 * Adds the project logo to the diagram container as
 * required by the bpmn.io license.
 *
 * @see http://bpmn.io/license
 *
 * @param {Element} container
 */
function addProjectLogo(container) {
  var img = _util_PoweredByUtil__WEBPACK_IMPORTED_MODULE_8__["BPMNIO_IMG"];

  var linkMarkup =
    '<a href="http://bpmn.io" ' +
       'target="_blank" ' +
       'class="bjs-powered-by" ' +
       'title="Powered by bpmn.io" ' +
       'style="position: absolute; bottom: 15px; right: 15px; z-index: 100; ' + _util_PoweredByUtil__WEBPACK_IMPORTED_MODULE_8__["LINK_STYLES"] + '">' +
      img +
    '</a>';

  var linkElement = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])(linkMarkup);

  container.appendChild(linkElement);

  min_dom__WEBPACK_IMPORTED_MODULE_1__["event"].bind(linkElement, 'click', function(event) {
    Object(_util_PoweredByUtil__WEBPACK_IMPORTED_MODULE_8__["open"])();

    event.preventDefault();
  });
}

/* </project-logo> */


/***/ }),

/***/ "./node_modules/bpmn-js/lib/NavigatedViewer.js":
/*!*****************************************************!*\
  !*** ./node_modules/bpmn-js/lib/NavigatedViewer.js ***!
  \*****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return NavigatedViewer; });
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _Viewer__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Viewer */ "./node_modules/bpmn-js/lib/Viewer.js");
/* harmony import */ var diagram_js_lib_navigation_keyboard_move__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! diagram-js/lib/navigation/keyboard-move */ "./node_modules/diagram-js/lib/navigation/keyboard-move/index.js");
/* harmony import */ var diagram_js_lib_navigation_movecanvas__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! diagram-js/lib/navigation/movecanvas */ "./node_modules/diagram-js/lib/navigation/movecanvas/index.js");
/* harmony import */ var diagram_js_lib_navigation_zoomscroll__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! diagram-js/lib/navigation/zoomscroll */ "./node_modules/diagram-js/lib/navigation/zoomscroll/index.js");









/**
 * A viewer that includes mouse navigation facilities
 *
 * @param {Object} options
 */
function NavigatedViewer(options) {
  _Viewer__WEBPACK_IMPORTED_MODULE_1__["default"].call(this, options);
}

inherits__WEBPACK_IMPORTED_MODULE_0___default()(NavigatedViewer, _Viewer__WEBPACK_IMPORTED_MODULE_1__["default"]);


NavigatedViewer.prototype._navigationModules = [
  diagram_js_lib_navigation_keyboard_move__WEBPACK_IMPORTED_MODULE_2__["default"],
  diagram_js_lib_navigation_movecanvas__WEBPACK_IMPORTED_MODULE_3__["default"],
  diagram_js_lib_navigation_zoomscroll__WEBPACK_IMPORTED_MODULE_4__["default"]
];

NavigatedViewer.prototype._modules = [].concat(
  _Viewer__WEBPACK_IMPORTED_MODULE_1__["default"].prototype._modules,
  NavigatedViewer.prototype._navigationModules
);

/***/ }),

/***/ "./node_modules/bpmn-js/lib/Viewer.js":
/*!********************************************!*\
  !*** ./node_modules/bpmn-js/lib/Viewer.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Viewer; });
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./core */ "./node_modules/bpmn-js/lib/core/index.js");
/* harmony import */ var diagram_js_lib_i18n_translate__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! diagram-js/lib/i18n/translate */ "./node_modules/diagram-js/lib/i18n/translate/index.js");
/* harmony import */ var diagram_js_lib_features_selection__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! diagram-js/lib/features/selection */ "./node_modules/diagram-js/lib/features/selection/index.js");
/* harmony import */ var diagram_js_lib_features_overlays__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! diagram-js/lib/features/overlays */ "./node_modules/diagram-js/lib/features/overlays/index.js");
/* harmony import */ var _BaseViewer__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./BaseViewer */ "./node_modules/bpmn-js/lib/BaseViewer.js");










/**
 * A viewer for BPMN 2.0 diagrams.
 *
 * Have a look at {@link NavigatedViewer} or {@link Modeler} for bundles that include
 * additional features.
 *
 *
 * ## Extending the Viewer
 *
 * In order to extend the viewer pass extension modules to bootstrap via the
 * `additionalModules` option. An extension module is an object that exposes
 * named services.
 *
 * The following example depicts the integration of a simple
 * logging component that integrates with interaction events:
 *
 *
 * ```javascript
 *
 * // logging component
 * function InteractionLogger(eventBus) {
 *   eventBus.on('element.hover', function(event) {
 *     console.log()
 *   })
 * }
 *
 * InteractionLogger.$inject = [ 'eventBus' ]; // minification save
 *
 * // extension module
 * var extensionModule = {
 *   __init__: [ 'interactionLogger' ],
 *   interactionLogger: [ 'type', InteractionLogger ]
 * };
 *
 * // extend the viewer
 * var bpmnViewer = new Viewer({ additionalModules: [ extensionModule ] });
 * bpmnViewer.importXML(...);
 * ```
 *
 * @param {Object} [options] configuration options to pass to the viewer
 * @param {DOMElement} [options.container] the container to render the viewer in, defaults to body.
 * @param {string|number} [options.width] the width of the viewer
 * @param {string|number} [options.height] the height of the viewer
 * @param {Object} [options.moddleExtensions] extension packages to provide
 * @param {Array<didi.Module>} [options.modules] a list of modules to override the default modules
 * @param {Array<didi.Module>} [options.additionalModules] a list of modules to use with the default modules
 */
function Viewer(options) {
  _BaseViewer__WEBPACK_IMPORTED_MODULE_5__["default"].call(this, options);
}

inherits__WEBPACK_IMPORTED_MODULE_0___default()(Viewer, _BaseViewer__WEBPACK_IMPORTED_MODULE_5__["default"]);

// modules the viewer is composed of
Viewer.prototype._modules = [
  _core__WEBPACK_IMPORTED_MODULE_1__["default"],
  diagram_js_lib_i18n_translate__WEBPACK_IMPORTED_MODULE_2__["default"],
  diagram_js_lib_features_selection__WEBPACK_IMPORTED_MODULE_3__["default"],
  diagram_js_lib_features_overlays__WEBPACK_IMPORTED_MODULE_4__["default"]
];

// default moddle extensions the viewer is composed of
Viewer.prototype._moddleExtensions = {};

/***/ }),

/***/ "./node_modules/bpmn-js/lib/core/index.js":
/*!************************************************!*\
  !*** ./node_modules/bpmn-js/lib/core/index.js ***!
  \************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _draw__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../draw */ "./node_modules/bpmn-js/lib/draw/index.js");
/* harmony import */ var _import__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../import */ "./node_modules/bpmn-js/lib/import/index.js");



/* harmony default export */ __webpack_exports__["default"] = ({
  __depends__: [
    _draw__WEBPACK_IMPORTED_MODULE_0__["default"],
    _import__WEBPACK_IMPORTED_MODULE_1__["default"]
  ]
});

/***/ }),

/***/ "./node_modules/bpmn-js/lib/draw/BpmnRenderUtil.js":
/*!*********************************************************!*\
  !*** ./node_modules/bpmn-js/lib/draw/BpmnRenderUtil.js ***!
  \*********************************************************/
/*! exports provided: isTypedEvent, isThrowEvent, isCollection, getDi, getSemantic, getFillColor, getStrokeColor, getLabelColor, getCirclePath, getRoundRectPath, getDiamondPath, getRectPath */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isTypedEvent", function() { return isTypedEvent; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isThrowEvent", function() { return isThrowEvent; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isCollection", function() { return isCollection; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getDi", function() { return getDi; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getSemantic", function() { return getSemantic; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getFillColor", function() { return getFillColor; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getStrokeColor", function() { return getStrokeColor; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getLabelColor", function() { return getLabelColor; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getCirclePath", function() { return getCirclePath; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getRoundRectPath", function() { return getRoundRectPath; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getDiamondPath", function() { return getDiamondPath; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getRectPath", function() { return getRectPath; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! diagram-js/lib/util/RenderUtil */ "./node_modules/diagram-js/lib/util/RenderUtil.js");





// element utils //////////////////////

/**
 * Checks if eventDefinition of the given element matches with semantic type.
 *
 * @return {boolean} true if element is of the given semantic type
 */
function isTypedEvent(event, eventDefinitionType, filter) {

  function matches(definition, filter) {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["every"])(filter, function(val, key) {

      // we want a == conversion here, to be able to catch
      // undefined == false and friends
      /* jshint -W116 */
      return definition[key] == val;
    });
  }

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["some"])(event.eventDefinitions, function(definition) {
    return definition.$type === eventDefinitionType && matches(event, filter);
  });
}

function isThrowEvent(event) {
  return (event.$type === 'bpmn:IntermediateThrowEvent') || (event.$type === 'bpmn:EndEvent');
}

function isCollection(element) {
  var dataObject = element.dataObjectRef;

  return element.isCollection || (dataObject && dataObject.isCollection);
}

function getDi(element) {
  return element.businessObject.di;
}

function getSemantic(element) {
  return element.businessObject;
}


// color access //////////////////////

function getFillColor(element, defaultColor) {
  var di = getDi(element);

  return di.get('color:background-color') || di.get('bioc:fill') || defaultColor || 'white';
}

function getStrokeColor(element, defaultColor) {
  var di = getDi(element);

  return di.get('color:border-color') || di.get('bioc:stroke') || defaultColor || 'black';
}

function getLabelColor(element, defaultColor, defaultStrokeColor) {
  var di = getDi(element),
      label = di.get('label');

  return label && label.get('color:color') || defaultColor ||
    getStrokeColor(element, defaultStrokeColor);
}

// cropping path customizations //////////////////////

function getCirclePath(shape) {

  var cx = shape.x + shape.width / 2,
      cy = shape.y + shape.height / 2,
      radius = shape.width / 2;

  var circlePath = [
    ['M', cx, cy],
    ['m', 0, -radius],
    ['a', radius, radius, 0, 1, 1, 0, 2 * radius],
    ['a', radius, radius, 0, 1, 1, 0, -2 * radius],
    ['z']
  ];

  return Object(diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_1__["componentsToPath"])(circlePath);
}

function getRoundRectPath(shape, borderRadius) {

  var x = shape.x,
      y = shape.y,
      width = shape.width,
      height = shape.height;

  var roundRectPath = [
    ['M', x + borderRadius, y],
    ['l', width - borderRadius * 2, 0],
    ['a', borderRadius, borderRadius, 0, 0, 1, borderRadius, borderRadius],
    ['l', 0, height - borderRadius * 2],
    ['a', borderRadius, borderRadius, 0, 0, 1, -borderRadius, borderRadius],
    ['l', borderRadius * 2 - width, 0],
    ['a', borderRadius, borderRadius, 0, 0, 1, -borderRadius, -borderRadius],
    ['l', 0, borderRadius * 2 - height],
    ['a', borderRadius, borderRadius, 0, 0, 1, borderRadius, -borderRadius],
    ['z']
  ];

  return Object(diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_1__["componentsToPath"])(roundRectPath);
}

function getDiamondPath(shape) {

  var width = shape.width,
      height = shape.height,
      x = shape.x,
      y = shape.y,
      halfWidth = width / 2,
      halfHeight = height / 2;

  var diamondPath = [
    ['M', x + halfWidth, y],
    ['l', halfWidth, halfHeight],
    ['l', -halfWidth, halfHeight],
    ['l', -halfWidth, -halfHeight],
    ['z']
  ];

  return Object(diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_1__["componentsToPath"])(diamondPath);
}

function getRectPath(shape) {
  var x = shape.x,
      y = shape.y,
      width = shape.width,
      height = shape.height;

  var rectPath = [
    ['M', x, y],
    ['l', width, 0],
    ['l', 0, height],
    ['l', -width, 0],
    ['z']
  ];

  return Object(diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_1__["componentsToPath"])(rectPath);
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/draw/BpmnRenderer.js":
/*!*******************************************************!*\
  !*** ./node_modules/bpmn-js/lib/draw/BpmnRenderer.js ***!
  \*******************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return BpmnRenderer; });
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var diagram_js_lib_draw_BaseRenderer__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! diagram-js/lib/draw/BaseRenderer */ "./node_modules/diagram-js/lib/draw/BaseRenderer.js");
/* harmony import */ var _util_DiUtil__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../util/DiUtil */ "./node_modules/bpmn-js/lib/util/DiUtil.js");
/* harmony import */ var _features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../features/label-editing/LabelUtil */ "./node_modules/bpmn-js/lib/features/label-editing/LabelUtil.js");
/* harmony import */ var _util_ModelUtil__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../util/ModelUtil */ "./node_modules/bpmn-js/lib/util/ModelUtil.js");
/* harmony import */ var diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! diagram-js/lib/util/RenderUtil */ "./node_modules/diagram-js/lib/util/RenderUtil.js");
/* harmony import */ var _BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./BpmnRenderUtil */ "./node_modules/bpmn-js/lib/draw/BpmnRenderUtil.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var diagram_js_lib_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! diagram-js/lib/util/SvgTransformUtil */ "./node_modules/diagram-js/lib/util/SvgTransformUtil.js");
/* harmony import */ var ids__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ids */ "./node_modules/ids/dist/index.esm.js");
























var RENDERER_IDS = new ids__WEBPACK_IMPORTED_MODULE_11__["default"]();

var TASK_BORDER_RADIUS = 10;
var INNER_OUTER_DIST = 3;

var DEFAULT_FILL_OPACITY = .95,
    HIGH_FILL_OPACITY = .35;

var ELEMENT_LABEL_DISTANCE = 10;

function BpmnRenderer(
    config, eventBus, styles, pathMap,
    canvas, textRenderer, priority) {

  diagram_js_lib_draw_BaseRenderer__WEBPACK_IMPORTED_MODULE_2__["default"].call(this, eventBus, priority);

  var defaultFillColor = config && config.defaultFillColor,
      defaultStrokeColor = config && config.defaultStrokeColor,
      defaultLabelColor = config && config.defaultLabelColor;

  var rendererId = RENDERER_IDS.next();

  var markers = {};

  var computeStyle = styles.computeStyle;

  function addMarker(id, options) {
    var attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({
      fill: 'black',
      strokeWidth: 1,
      strokeLinecap: 'round',
      strokeDasharray: 'none'
    }, options.attrs);

    var ref = options.ref || { x: 0, y: 0 };

    var scale = options.scale || 1;

    // fix for safari / chrome / firefox bug not correctly
    // resetting stroke dash array
    if (attrs.strokeDasharray === 'none') {
      attrs.strokeDasharray = [10000, 1];
    }

    var marker = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('marker');

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(options.element, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(marker, options.element);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(marker, {
      id: id,
      viewBox: '0 0 20 20',
      refX: ref.x,
      refY: ref.y,
      markerWidth: 20 * scale,
      markerHeight: 20 * scale,
      orient: 'auto'
    });

    var defs = Object(min_dom__WEBPACK_IMPORTED_MODULE_8__["query"])('defs', canvas._svg);

    if (!defs) {
      defs = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('defs');

      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(canvas._svg, defs);
    }

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(defs, marker);

    markers[id] = marker;
  }

  function colorEscape(str) {

    // only allow characters and numbers
    return str.replace(/[^0-9a-zA-z]+/g, '_');
  }

  function marker(type, fill, stroke) {
    var id = type + '-' + colorEscape(fill) + '-' + colorEscape(stroke) + '-' + rendererId;

    if (!markers[id]) {
      createMarker(id, type, fill, stroke);
    }

    return 'url(#' + id + ')';
  }

  function createMarker(id, type, fill, stroke) {

    if (type === 'sequenceflow-end') {
      var sequenceflowEnd = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(sequenceflowEnd, { d: 'M 1 5 L 11 10 L 1 15 Z' });

      addMarker(id, {
        element: sequenceflowEnd,
        ref: { x: 11, y: 10 },
        scale: 0.5,
        attrs: {
          fill: stroke,
          stroke: stroke
        }
      });
    }

    if (type === 'messageflow-start') {
      var messageflowStart = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('circle');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(messageflowStart, { cx: 6, cy: 6, r: 3.5 });

      addMarker(id, {
        element: messageflowStart,
        attrs: {
          fill: fill,
          stroke: stroke
        },
        ref: { x: 6, y: 6 }
      });
    }

    if (type === 'messageflow-end') {
      var messageflowEnd = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(messageflowEnd, { d: 'm 1 5 l 0 -3 l 7 3 l -7 3 z' });

      addMarker(id, {
        element: messageflowEnd,
        attrs: {
          fill: fill,
          stroke: stroke,
          strokeLinecap: 'butt'
        },
        ref: { x: 8.5, y: 5 }
      });
    }

    if (type === 'association-start') {
      var associationStart = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(associationStart, { d: 'M 11 5 L 1 10 L 11 15' });

      addMarker(id, {
        element: associationStart,
        attrs: {
          fill: 'none',
          stroke: stroke,
          strokeWidth: 1.5
        },
        ref: { x: 1, y: 10 },
        scale: 0.5
      });
    }

    if (type === 'association-end') {
      var associationEnd = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(associationEnd, { d: 'M 1 5 L 11 10 L 1 15' });

      addMarker(id, {
        element: associationEnd,
        attrs: {
          fill: 'none',
          stroke: stroke,
          strokeWidth: 1.5
        },
        ref: { x: 12, y: 10 },
        scale: 0.5
      });
    }

    if (type === 'conditional-flow-marker') {
      var conditionalflowMarker = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(conditionalflowMarker, { d: 'M 0 10 L 8 6 L 16 10 L 8 14 Z' });

      addMarker(id, {
        element: conditionalflowMarker,
        attrs: {
          fill: fill,
          stroke: stroke
        },
        ref: { x: -1, y: 10 },
        scale: 0.5
      });
    }

    if (type === 'conditional-default-flow-marker') {
      var conditionaldefaultflowMarker = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(conditionaldefaultflowMarker, { d: 'M 6 4 L 10 16' });

      addMarker(id, {
        element: conditionaldefaultflowMarker,
        attrs: {
          stroke: stroke
        },
        ref: { x: 0, y: 10 },
        scale: 0.5
      });
    }
  }

  function drawCircle(parentGfx, width, height, offset, attrs) {

    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["isObject"])(offset)) {
      attrs = offset;
      offset = 0;
    }

    offset = offset || 0;

    attrs = computeStyle(attrs, {
      stroke: 'black',
      strokeWidth: 2,
      fill: 'white'
    });

    if (attrs.fill === 'none') {
      delete attrs.fillOpacity;
    }

    var cx = width / 2,
        cy = height / 2;

    var circle = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('circle');
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(circle, {
      cx: cx,
      cy: cy,
      r: Math.round((width + height) / 4 - offset)
    });
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(circle, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, circle);

    return circle;
  }

  function drawRect(parentGfx, width, height, r, offset, attrs) {

    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["isObject"])(offset)) {
      attrs = offset;
      offset = 0;
    }

    offset = offset || 0;

    attrs = computeStyle(attrs, {
      stroke: 'black',
      strokeWidth: 2,
      fill: 'white'
    });

    var rect = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('rect');
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(rect, {
      x: offset,
      y: offset,
      width: width - offset * 2,
      height: height - offset * 2,
      rx: r,
      ry: r
    });
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(rect, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, rect);

    return rect;
  }

  function drawDiamond(parentGfx, width, height, attrs) {

    var x_2 = width / 2;
    var y_2 = height / 2;

    var points = [{ x: x_2, y: 0 }, { x: width, y: y_2 }, { x: x_2, y: height }, { x: 0, y: y_2 }];

    var pointsString = points.map(function(point) {
      return point.x + ',' + point.y;
    }).join(' ');

    attrs = computeStyle(attrs, {
      stroke: 'black',
      strokeWidth: 2,
      fill: 'white'
    });

    var polygon = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('polygon');
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(polygon, {
      points: pointsString
    });
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(polygon, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, polygon);

    return polygon;
  }

  function drawLine(parentGfx, waypoints, attrs) {
    attrs = computeStyle(attrs, [ 'no-fill' ], {
      stroke: 'black',
      strokeWidth: 2,
      fill: 'none'
    });

    var line = Object(diagram_js_lib_util_RenderUtil__WEBPACK_IMPORTED_MODULE_6__["createLine"])(waypoints, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, line);

    return line;
  }

  function drawPath(parentGfx, d, attrs) {

    attrs = computeStyle(attrs, [ 'no-fill' ], {
      strokeWidth: 2,
      stroke: 'black'
    });

    var path = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["create"])('path');
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(path, { d: d });
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(path, attrs);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, path);

    return path;
  }

  function drawMarker(type, parentGfx, path, attrs) {
    return drawPath(parentGfx, path, Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({ 'data-marker': type }, attrs));
  }

  function as(type) {
    return function(parentGfx, element) {
      return handlers[type](parentGfx, element);
    };
  }

  function renderer(type) {
    return handlers[type];
  }

  function renderEventContent(element, parentGfx) {

    var event = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);
    var isThrowing = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isThrowEvent"])(event);

    if (event.eventDefinitions && event.eventDefinitions.length>1) {
      if (event.parallelMultiple) {
        return renderer('bpmn:ParallelMultipleEventDefinition')(parentGfx, element, isThrowing);
      }
      else {
        return renderer('bpmn:MultipleEventDefinition')(parentGfx, element, isThrowing);
      }
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:MessageEventDefinition')) {
      return renderer('bpmn:MessageEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:TimerEventDefinition')) {
      return renderer('bpmn:TimerEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:ConditionalEventDefinition')) {
      return renderer('bpmn:ConditionalEventDefinition')(parentGfx, element);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:SignalEventDefinition')) {
      return renderer('bpmn:SignalEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:EscalationEventDefinition')) {
      return renderer('bpmn:EscalationEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:LinkEventDefinition')) {
      return renderer('bpmn:LinkEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:ErrorEventDefinition')) {
      return renderer('bpmn:ErrorEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:CancelEventDefinition')) {
      return renderer('bpmn:CancelEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:CompensateEventDefinition')) {
      return renderer('bpmn:CompensateEventDefinition')(parentGfx, element, isThrowing);
    }

    if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isTypedEvent"])(event, 'bpmn:TerminateEventDefinition')) {
      return renderer('bpmn:TerminateEventDefinition')(parentGfx, element, isThrowing);
    }

    return null;
  }

  function renderLabel(parentGfx, label, options) {

    options = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({
      size: {
        width: 100
      }
    }, options);

    var text = textRenderer.createText(label || '', options);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["classes"])(text).add('djs-label');

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["append"])(parentGfx, text);

    return text;
  }

  function renderEmbeddedLabel(parentGfx, element, align) {
    var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

    return renderLabel(parentGfx, semantic.name, {
      box: element,
      align: align,
      padding: 5,
      style: {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getLabelColor"])(element, defaultLabelColor, defaultStrokeColor)
      }
    });
  }

  function renderExternalLabel(parentGfx, element) {

    var box = {
      width: 90,
      height: 30,
      x: element.width / 2 + element.x,
      y: element.height / 2 + element.y
    };

    return renderLabel(parentGfx, Object(_features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_4__["getLabel"])(element), {
      box: box,
      fitBox: true,
      style: Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])(
        {},
        textRenderer.getExternalStyle(),
        {
          fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getLabelColor"])(element, defaultLabelColor, defaultStrokeColor)
        }
      )
    });
  }

  function renderLaneLabel(parentGfx, text, element) {
    var textBox = renderLabel(parentGfx, text, {
      box: {
        height: 30,
        width: element.height
      },
      align: 'center-middle',
      style: {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getLabelColor"])(element, defaultLabelColor, defaultStrokeColor)
      }
    });

    var top = -1 * element.height;

    Object(diagram_js_lib_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_10__["transform"])(textBox, 0, -top, 270);
  }

  function createPathFromConnection(connection) {
    var waypoints = connection.waypoints;

    var pathData = 'm  ' + waypoints[0].x + ',' + waypoints[0].y;
    for (var i = 1; i < waypoints.length; i++) {
      pathData += 'L' + waypoints[i].x + ',' + waypoints[i].y + ' ';
    }
    return pathData;
  }

  var handlers = this.handlers = {
    'bpmn:Event': function(parentGfx, element, attrs) {

      if (!('fillOpacity' in attrs)) {
        attrs.fillOpacity = DEFAULT_FILL_OPACITY;
      }

      return drawCircle(parentGfx, element.width, element.height, attrs);
    },
    'bpmn:StartEvent': function(parentGfx, element) {
      var attrs = {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      if (!semantic.isInterrupting) {
        attrs = {
          strokeDasharray: '6',
          strokeLinecap: 'round',
          fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
        };
      }

      var circle = renderer('bpmn:Event')(parentGfx, element, attrs);

      renderEventContent(element, parentGfx);

      return circle;
    },
    'bpmn:MessageEventDefinition': function(parentGfx, element, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_MESSAGE', {
        xScaleFactor: 0.9,
        yScaleFactor: 0.9,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.235,
          my: 0.315
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor) : Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor);
      var stroke = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor) : Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      var messagePath = drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: stroke
      });

      return messagePath;
    },
    'bpmn:TimerEventDefinition': function(parentGfx, element) {
      var circle = drawCircle(parentGfx, element.width, element.height, 0.2 * element.height, {
        strokeWidth: 2,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var pathData = pathMap.getScaledPath('EVENT_TIMER_WH', {
        xScaleFactor: 0.75,
        yScaleFactor: 0.75,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.5,
          my: 0.5
        }
      });

      drawPath(parentGfx, pathData, {
        strokeWidth: 2,
        strokeLinecap: 'square',
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      for (var i = 0;i < 12; i++) {

        var linePathData = pathMap.getScaledPath('EVENT_TIMER_LINE', {
          xScaleFactor: 0.75,
          yScaleFactor: 0.75,
          containerWidth: element.width,
          containerHeight: element.height,
          position: {
            mx: 0.5,
            my: 0.5
          }
        });

        var width = element.width / 2;
        var height = element.height / 2;

        drawPath(parentGfx, linePathData, {
          strokeWidth: 1,
          strokeLinecap: 'square',
          transform: 'rotate(' + (i * 30) + ',' + height + ',' + width + ')',
          stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
        });
      }

      return circle;
    },
    'bpmn:EscalationEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_ESCALATION', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.5,
          my: 0.2
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:ConditionalEventDefinition': function(parentGfx, event) {
      var pathData = pathMap.getScaledPath('EVENT_CONDITIONAL', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.5,
          my: 0.222
        }
      });

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:LinkEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_LINK', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.57,
          my: 0.263
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:ErrorEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_ERROR', {
        xScaleFactor: 1.1,
        yScaleFactor: 1.1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.2,
          my: 0.722
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:CancelEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_CANCEL_45', {
        xScaleFactor: 1.0,
        yScaleFactor: 1.0,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.638,
          my: -0.055
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      var path = drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });

      Object(diagram_js_lib_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_10__["rotate"])(path, 45);

      return path;
    },
    'bpmn:CompensateEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_COMPENSATION', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.22,
          my: 0.5
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:SignalEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_SIGNAL', {
        xScaleFactor: 0.9,
        yScaleFactor: 0.9,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.5,
          my: 0.2
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:MultipleEventDefinition': function(parentGfx, event, isThrowing) {
      var pathData = pathMap.getScaledPath('EVENT_MULTIPLE', {
        xScaleFactor: 1.1,
        yScaleFactor: 1.1,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.222,
          my: 0.36
        }
      });

      var fill = isThrowing ? Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor) : 'none';

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: fill
      });
    },
    'bpmn:ParallelMultipleEventDefinition': function(parentGfx, event) {
      var pathData = pathMap.getScaledPath('EVENT_PARALLEL_MULTIPLE', {
        xScaleFactor: 1.2,
        yScaleFactor: 1.2,
        containerWidth: event.width,
        containerHeight: event.height,
        position: {
          mx: 0.458,
          my: 0.194
        }
      });

      return drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(event, defaultStrokeColor)
      });
    },
    'bpmn:EndEvent': function(parentGfx, element) {
      var circle = renderer('bpmn:Event')(parentGfx, element, {
        strokeWidth: 4,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      renderEventContent(element, parentGfx, true);

      return circle;
    },
    'bpmn:TerminateEventDefinition': function(parentGfx, element) {
      var circle = drawCircle(parentGfx, element.width, element.height, 8, {
        strokeWidth: 4,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return circle;
    },
    'bpmn:IntermediateEvent': function(parentGfx, element) {
      var outer = renderer('bpmn:Event')(parentGfx, element, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      /* inner */
      drawCircle(parentGfx, element.width, element.height, INNER_OUTER_DIST, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, 'none'),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      renderEventContent(element, parentGfx);

      return outer;
    },
    'bpmn:IntermediateCatchEvent': as('bpmn:IntermediateEvent'),
    'bpmn:IntermediateThrowEvent': as('bpmn:IntermediateEvent'),

    'bpmn:Activity': function(parentGfx, element, attrs) {

      attrs = attrs || {};

      if (!('fillOpacity' in attrs)) {
        attrs.fillOpacity = DEFAULT_FILL_OPACITY;
      }

      return drawRect(parentGfx, element.width, element.height, TASK_BORDER_RADIUS, attrs);
    },

    'bpmn:Task': function(parentGfx, element) {
      var attrs = {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      var rect = renderer('bpmn:Activity')(parentGfx, element, attrs);

      renderEmbeddedLabel(parentGfx, element, 'center-middle');
      attachTaskMarkers(parentGfx, element);

      return rect;
    },
    'bpmn:ServiceTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var pathDataBG = pathMap.getScaledPath('TASK_TYPE_SERVICE', {
        abspos: {
          x: 12,
          y: 18
        }
      });

      /* service bg */ drawPath(parentGfx, pathDataBG, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var fillPathData = pathMap.getScaledPath('TASK_TYPE_SERVICE_FILL', {
        abspos: {
          x: 17.2,
          y: 18
        }
      });

      /* service fill */ drawPath(parentGfx, fillPathData, {
        strokeWidth: 0,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor)
      });

      var pathData = pathMap.getScaledPath('TASK_TYPE_SERVICE', {
        abspos: {
          x: 17,
          y: 22
        }
      });

      /* service */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:UserTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var x = 15;
      var y = 12;

      var pathData = pathMap.getScaledPath('TASK_TYPE_USER_1', {
        abspos: {
          x: x,
          y: y
        }
      });

      /* user path */ drawPath(parentGfx, pathData, {
        strokeWidth: 0.5,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var pathData2 = pathMap.getScaledPath('TASK_TYPE_USER_2', {
        abspos: {
          x: x,
          y: y
        }
      });

      /* user2 path */ drawPath(parentGfx, pathData2, {
        strokeWidth: 0.5,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var pathData3 = pathMap.getScaledPath('TASK_TYPE_USER_3', {
        abspos: {
          x: x,
          y: y
        }
      });

      /* user3 path */ drawPath(parentGfx, pathData3, {
        strokeWidth: 0.5,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:ManualTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var pathData = pathMap.getScaledPath('TASK_TYPE_MANUAL', {
        abspos: {
          x: 17,
          y: 15
        }
      });

      /* manual path */ drawPath(parentGfx, pathData, {
        strokeWidth: 0.5, // 0.25,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:SendTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var pathData = pathMap.getScaledPath('TASK_TYPE_SEND', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: 21,
        containerHeight: 14,
        position: {
          mx: 0.285,
          my: 0.357
        }
      });

      /* send path */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor)
      });

      return task;
    },
    'bpmn:ReceiveTask' : function(parentGfx, element) {
      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      var task = renderer('bpmn:Task')(parentGfx, element);
      var pathData;

      if (semantic.instantiate) {
        drawCircle(parentGfx, 28, 28, 20 * 0.22, { strokeWidth: 1 });

        pathData = pathMap.getScaledPath('TASK_TYPE_INSTANTIATING_SEND', {
          abspos: {
            x: 7.77,
            y: 9.52
          }
        });
      } else {

        pathData = pathMap.getScaledPath('TASK_TYPE_SEND', {
          xScaleFactor: 0.9,
          yScaleFactor: 0.9,
          containerWidth: 21,
          containerHeight: 14,
          position: {
            mx: 0.3,
            my: 0.4
          }
        });
      }

      /* receive path */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:ScriptTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var pathData = pathMap.getScaledPath('TASK_TYPE_SCRIPT', {
        abspos: {
          x: 15,
          y: 20
        }
      });

      /* script path */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:BusinessRuleTask': function(parentGfx, element) {
      var task = renderer('bpmn:Task')(parentGfx, element);

      var headerPathData = pathMap.getScaledPath('TASK_TYPE_BUSINESS_RULE_HEADER', {
        abspos: {
          x: 8,
          y: 8
        }
      });

      var businessHeaderPath = drawPath(parentGfx, headerPathData);
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(businessHeaderPath, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, '#aaaaaa'),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var headerData = pathMap.getScaledPath('TASK_TYPE_BUSINESS_RULE_MAIN', {
        abspos: {
          x: 8,
          y: 8
        }
      });

      var businessPath = drawPath(parentGfx, headerData);
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(businessPath, {
        strokeWidth: 1,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return task;
    },
    'bpmn:SubProcess': function(parentGfx, element, attrs) {
      attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      }, attrs);

      var rect = renderer('bpmn:Activity')(parentGfx, element, attrs);

      var expanded = Object(_util_DiUtil__WEBPACK_IMPORTED_MODULE_3__["isExpanded"])(element);

      if (Object(_util_DiUtil__WEBPACK_IMPORTED_MODULE_3__["isEventSubProcess"])(element)) {
        Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(rect, {
          strokeDasharray: '1,2'
        });
      }

      renderEmbeddedLabel(parentGfx, element, expanded ? 'center-top' : 'center-middle');

      if (expanded) {
        attachTaskMarkers(parentGfx, element);
      } else {
        attachTaskMarkers(parentGfx, element, ['SubProcessMarker']);
      }

      return rect;
    },
    'bpmn:AdHocSubProcess': function(parentGfx, element) {
      return renderer('bpmn:SubProcess')(parentGfx, element);
    },
    'bpmn:Transaction': function(parentGfx, element) {
      var outer = renderer('bpmn:SubProcess')(parentGfx, element);

      var innerAttrs = styles.style([ 'no-fill', 'no-events' ], {
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      /* inner path */ drawRect(parentGfx, element.width, element.height, TASK_BORDER_RADIUS - 2, INNER_OUTER_DIST, innerAttrs);

      return outer;
    },
    'bpmn:CallActivity': function(parentGfx, element) {
      return renderer('bpmn:SubProcess')(parentGfx, element, {
        strokeWidth: 5
      });
    },
    'bpmn:Participant': function(parentGfx, element) {

      var attrs = {
        fillOpacity: DEFAULT_FILL_OPACITY,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      var lane = renderer('bpmn:Lane')(parentGfx, element, attrs);

      var expandedPool = Object(_util_DiUtil__WEBPACK_IMPORTED_MODULE_3__["isExpanded"])(element);

      if (expandedPool) {
        drawLine(parentGfx, [
          { x: 30, y: 0 },
          { x: 30, y: element.height }
        ], {
          stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
        });
        var text = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element).name;
        renderLaneLabel(parentGfx, text, element);
      } else {

        // Collapsed pool draw text inline
        var text2 = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element).name;
        renderLabel(parentGfx, text2, {
          box: element, align: 'center-middle',
          style: {
            fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getLabelColor"])(element, defaultLabelColor, defaultStrokeColor)
          }
        });
      }

      var participantMultiplicity = !!(Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element).participantMultiplicity);

      if (participantMultiplicity) {
        renderer('ParticipantMultiplicityMarker')(parentGfx, element);
      }

      return lane;
    },
    'bpmn:Lane': function(parentGfx, element, attrs) {
      var rect = drawRect(parentGfx, element.width, element.height, 0, Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        fillOpacity: HIGH_FILL_OPACITY,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      }, attrs));

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      if (semantic.$type === 'bpmn:Lane') {
        var text = semantic.name;
        renderLaneLabel(parentGfx, text, element);
      }

      return rect;
    },
    'bpmn:InclusiveGateway': function(parentGfx, element) {
      var diamond = renderer('bpmn:Gateway')(parentGfx, element);

      /* circle path */
      drawCircle(parentGfx, element.width, element.height, element.height * 0.24, {
        strokeWidth: 2.5,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return diamond;
    },
    'bpmn:ExclusiveGateway': function(parentGfx, element) {
      var diamond = renderer('bpmn:Gateway')(parentGfx, element);

      var pathData = pathMap.getScaledPath('GATEWAY_EXCLUSIVE', {
        xScaleFactor: 0.4,
        yScaleFactor: 0.4,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.32,
          my: 0.3
        }
      });

      if ((Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getDi"])(element).isMarkerVisible)) {
        drawPath(parentGfx, pathData, {
          strokeWidth: 1,
          fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
          stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
        });
      }

      return diamond;
    },
    'bpmn:ComplexGateway': function(parentGfx, element) {
      var diamond = renderer('bpmn:Gateway')(parentGfx, element);

      var pathData = pathMap.getScaledPath('GATEWAY_COMPLEX', {
        xScaleFactor: 0.5,
        yScaleFactor:0.5,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.46,
          my: 0.26
        }
      });

      /* complex path */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return diamond;
    },
    'bpmn:ParallelGateway': function(parentGfx, element) {
      var diamond = renderer('bpmn:Gateway')(parentGfx, element);

      var pathData = pathMap.getScaledPath('GATEWAY_PARALLEL', {
        xScaleFactor: 0.6,
        yScaleFactor:0.6,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.46,
          my: 0.2
        }
      });

      /* parallel path */ drawPath(parentGfx, pathData, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return diamond;
    },
    'bpmn:EventBasedGateway': function(parentGfx, element) {

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      var diamond = renderer('bpmn:Gateway')(parentGfx, element);

      /* outer circle path */ drawCircle(parentGfx, element.width, element.height, element.height * 0.20, {
        strokeWidth: 1,
        fill: 'none',
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var type = semantic.eventGatewayType;
      var instantiate = !!semantic.instantiate;

      function drawEvent() {

        var pathData = pathMap.getScaledPath('GATEWAY_EVENT_BASED', {
          xScaleFactor: 0.18,
          yScaleFactor: 0.18,
          containerWidth: element.width,
          containerHeight: element.height,
          position: {
            mx: 0.36,
            my: 0.44
          }
        });

        var attrs = {
          strokeWidth: 2,
          fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, 'none'),
          stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
        };

        /* event path */ drawPath(parentGfx, pathData, attrs);
      }

      if (type === 'Parallel') {

        var pathData = pathMap.getScaledPath('GATEWAY_PARALLEL', {
          xScaleFactor: 0.4,
          yScaleFactor:0.4,
          containerWidth: element.width,
          containerHeight: element.height,
          position: {
            mx: 0.474,
            my: 0.296
          }
        });

        var parallelPath = drawPath(parentGfx, pathData);
        Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(parallelPath, {
          strokeWidth: 1,
          fill: 'none'
        });
      } else if (type === 'Exclusive') {

        if (!instantiate) {
          var innerCircle = drawCircle(parentGfx, element.width, element.height, element.height * 0.26);
          Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(innerCircle, {
            strokeWidth: 1,
            fill: 'none',
            stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
          });
        }

        drawEvent();
      }


      return diamond;
    },
    'bpmn:Gateway': function(parentGfx, element) {
      var attrs = {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        fillOpacity: DEFAULT_FILL_OPACITY,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      return drawDiamond(parentGfx, element.width, element.height, attrs);
    },
    'bpmn:SequenceFlow': function(parentGfx, element) {
      var pathData = createPathFromConnection(element);

      var fill = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      var attrs = {
        strokeLinejoin: 'round',
        markerEnd: marker('sequenceflow-end', fill, stroke),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      var path = drawPath(parentGfx, pathData, attrs);

      var sequenceFlow = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      var source;

      if (element.source) {
        source = element.source.businessObject;

        // conditional flow marker
        if (sequenceFlow.conditionExpression && source.$instanceOf('bpmn:Activity')) {
          Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(path, {
            markerStart: marker('conditional-flow-marker', fill, stroke)
          });
        }

        // default marker
        if (source.default && (source.$instanceOf('bpmn:Gateway') || source.$instanceOf('bpmn:Activity')) &&
            source.default === sequenceFlow) {
          Object(tiny_svg__WEBPACK_IMPORTED_MODULE_9__["attr"])(path, {
            markerStart: marker('conditional-default-flow-marker', fill, stroke)
          });
        }
      }

      return path;
    },
    'bpmn:Association': function(parentGfx, element, attrs) {

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      var fill = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({
        strokeDasharray: '0.5, 5',
        strokeLinecap: 'round',
        strokeLinejoin: 'round',
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      }, attrs || {});

      if (semantic.associationDirection === 'One' ||
          semantic.associationDirection === 'Both') {
        attrs.markerEnd = marker('association-end', fill, stroke);
      }

      if (semantic.associationDirection === 'Both') {
        attrs.markerStart = marker('association-start', fill, stroke);
      }

      return drawLine(parentGfx, element.waypoints, attrs);
    },
    'bpmn:DataInputAssociation': function(parentGfx, element) {
      var fill = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      return renderer('bpmn:Association')(parentGfx, element, {
        markerEnd: marker('association-end', fill, stroke)
      });
    },
    'bpmn:DataOutputAssociation': function(parentGfx, element) {
      var fill = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      return renderer('bpmn:Association')(parentGfx, element, {
        markerEnd: marker('association-end', fill, stroke)
      });
    },
    'bpmn:MessageFlow': function(parentGfx, element) {

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element),
          di = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getDi"])(element);

      var fill = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
          stroke = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor);

      var pathData = createPathFromConnection(element);

      var attrs = {
        markerEnd: marker('messageflow-end', fill, stroke),
        markerStart: marker('messageflow-start', fill, stroke),
        strokeDasharray: '10, 12',
        strokeLinecap: 'round',
        strokeLinejoin: 'round',
        strokeWidth: '1.5px',
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      var path = drawPath(parentGfx, pathData, attrs);

      if (semantic.messageRef) {
        var midPoint = path.getPointAtLength(path.getTotalLength() / 2);

        var markerPathData = pathMap.getScaledPath('MESSAGE_FLOW_MARKER', {
          abspos: {
            x: midPoint.x,
            y: midPoint.y
          }
        });

        var messageAttrs = { strokeWidth: 1 };

        if (di.messageVisibleKind === 'initiating') {
          messageAttrs.fill = 'white';
          messageAttrs.stroke = 'black';
        } else {
          messageAttrs.fill = '#888';
          messageAttrs.stroke = 'white';
        }

        var message = drawPath(parentGfx, markerPathData, messageAttrs);

        var labelText = semantic.messageRef.name;
        var label = renderLabel(parentGfx, labelText, {
          align: 'center-top',
          fitBox: true,
          style: {
            fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultLabelColor, defaultStrokeColor)
          }
        });

        var messageBounds = message.getBBox(),
            labelBounds = label.getBBox();

        var translateX = midPoint.x - labelBounds.width / 2,
            translateY = midPoint.y + messageBounds.height / 2 + ELEMENT_LABEL_DISTANCE;

        Object(diagram_js_lib_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_10__["transform"])(label, translateX, translateY, 0);

      }

      return path;
    },
    'bpmn:DataObject': function(parentGfx, element) {
      var pathData = pathMap.getScaledPath('DATA_OBJECT_PATH', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.474,
          my: 0.296
        }
      });

      var elementObject = drawPath(parentGfx, pathData, {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        fillOpacity: DEFAULT_FILL_OPACITY,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

      if (Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["isCollection"])(semantic)) {
        renderDataItemCollection(parentGfx, element);
      }

      return elementObject;
    },
    'bpmn:DataObjectReference': as('bpmn:DataObject'),
    'bpmn:DataInput': function(parentGfx, element) {

      var arrowPathData = pathMap.getRawPath('DATA_ARROW');

      // page
      var elementObject = renderer('bpmn:DataObject')(parentGfx, element);

      /* input arrow path */ drawPath(parentGfx, arrowPathData, { strokeWidth: 1 });

      return elementObject;
    },
    'bpmn:DataOutput': function(parentGfx, element) {
      var arrowPathData = pathMap.getRawPath('DATA_ARROW');

      // page
      var elementObject = renderer('bpmn:DataObject')(parentGfx, element);

      /* output arrow path */ drawPath(parentGfx, arrowPathData, {
        strokeWidth: 1,
        fill: 'black'
      });

      return elementObject;
    },
    'bpmn:DataStoreReference': function(parentGfx, element) {
      var DATA_STORE_PATH = pathMap.getScaledPath('DATA_STORE', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0,
          my: 0.133
        }
      });

      var elementStore = drawPath(parentGfx, DATA_STORE_PATH, {
        strokeWidth: 2,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        fillOpacity: DEFAULT_FILL_OPACITY,
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      return elementStore;
    },
    'bpmn:BoundaryEvent': function(parentGfx, element) {

      var semantic = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element),
          cancel = semantic.cancelActivity;

      var attrs = {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      };

      if (!cancel) {
        attrs.strokeDasharray = '6';
        attrs.strokeLinecap = 'round';
      }

      // apply fillOpacity
      var outerAttrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({}, attrs, {
        fillOpacity: 1
      });

      // apply no-fill
      var innerAttrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({}, attrs, {
        fill: 'none'
      });

      var outer = renderer('bpmn:Event')(parentGfx, element, outerAttrs);

      /* inner path */ drawCircle(parentGfx, element.width, element.height, INNER_OUTER_DIST, innerAttrs);

      renderEventContent(element, parentGfx);

      return outer;
    },
    'bpmn:Group': function(parentGfx, element) {

      var group = drawRect(parentGfx, element.width, element.height, TASK_BORDER_RADIUS, {
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        strokeWidth: 1,
        strokeDasharray: '8,3,1,3',
        fill: 'none',
        pointerEvents: 'none'
      });

      return group;
    },
    'label': function(parentGfx, element) {
      return renderExternalLabel(parentGfx, element);
    },
    'bpmn:TextAnnotation': function(parentGfx, element) {
      var style = {
        'fill': 'none',
        'stroke': 'none'
      };

      var textElement = drawRect(parentGfx, element.width, element.height, 0, 0, style);

      var textPathData = pathMap.getScaledPath('TEXT_ANNOTATION', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: 0.0,
          my: 0.0
        }
      });

      drawPath(parentGfx, textPathData, {
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      var text = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element).text || '';
      renderLabel(parentGfx, text, {
        box: element,
        align: 'left-top',
        padding: 5,
        style: {
          fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getLabelColor"])(element, defaultLabelColor, defaultStrokeColor)
        }
      });

      return textElement;
    },
    'ParticipantMultiplicityMarker': function(parentGfx, element) {
      var markerPath = pathMap.getScaledPath('MARKER_PARALLEL', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2) / element.width),
          my: (element.height - 15) / element.height
        }
      });

      drawMarker('participant-multiplicity', parentGfx, markerPath, {
        strokeWidth: 2,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    },
    'SubProcessMarker': function(parentGfx, element) {
      var markerRect = drawRect(parentGfx, 14, 14, 0, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });

      // Process marker is placed in the middle of the box
      // therefore fixed values can be used here
      Object(diagram_js_lib_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_10__["translate"])(markerRect, element.width / 2 - 7.5, element.height - 20);

      var markerPath = pathMap.getScaledPath('MARKER_SUB_PROCESS', {
        xScaleFactor: 1.5,
        yScaleFactor: 1.5,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: (element.width / 2 - 7.5) / element.width,
          my: (element.height - 20) / element.height
        }
      });

      drawMarker('sub-process', parentGfx, markerPath, {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    },
    'ParallelMarker': function(parentGfx, element, position) {
      var markerPath = pathMap.getScaledPath('MARKER_PARALLEL', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2 + position.parallel) / element.width),
          my: (element.height - 20) / element.height
        }
      });

      drawMarker('parallel', parentGfx, markerPath, {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    },
    'SequentialMarker': function(parentGfx, element, position) {
      var markerPath = pathMap.getScaledPath('MARKER_SEQUENTIAL', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2 + position.seq) / element.width),
          my: (element.height - 19) / element.height
        }
      });

      drawMarker('sequential', parentGfx, markerPath, {
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    },
    'CompensationMarker': function(parentGfx, element, position) {
      var markerMath = pathMap.getScaledPath('MARKER_COMPENSATION', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2 + position.compensation) / element.width),
          my: (element.height - 13) / element.height
        }
      });

      drawMarker('compensation', parentGfx, markerMath, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    },
    'LoopMarker': function(parentGfx, element, position) {
      var markerPath = pathMap.getScaledPath('MARKER_LOOP', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2 + position.loop) / element.width),
          my: (element.height - 7) / element.height
        }
      });

      drawMarker('loop', parentGfx, markerPath, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getFillColor"])(element, defaultFillColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        strokeLinecap: 'round',
        strokeMiterlimit: 0.5
      });
    },
    'AdhocMarker': function(parentGfx, element, position) {
      var markerPath = pathMap.getScaledPath('MARKER_ADHOC', {
        xScaleFactor: 1,
        yScaleFactor: 1,
        containerWidth: element.width,
        containerHeight: element.height,
        position: {
          mx: ((element.width / 2 + position.adhoc) / element.width),
          my: (element.height - 15) / element.height
        }
      });

      drawMarker('adhoc', parentGfx, markerPath, {
        strokeWidth: 1,
        fill: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor),
        stroke: Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getStrokeColor"])(element, defaultStrokeColor)
      });
    }
  };

  function attachTaskMarkers(parentGfx, element, taskMarkers) {
    var obj = Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getSemantic"])(element);

    var subprocess = taskMarkers && taskMarkers.indexOf('SubProcessMarker') !== -1;
    var position;

    if (subprocess) {
      position = {
        seq: -21,
        parallel: -22,
        compensation: -42,
        loop: -18,
        adhoc: 10
      };
    } else {
      position = {
        seq: -3,
        parallel: -6,
        compensation: -27,
        loop: 0,
        adhoc: 10
      };
    }

    Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["forEach"])(taskMarkers, function(marker) {
      renderer(marker)(parentGfx, element, position);
    });

    if (obj.isForCompensation) {
      renderer('CompensationMarker')(parentGfx, element, position);
    }

    if (obj.$type === 'bpmn:AdHocSubProcess') {
      renderer('AdhocMarker')(parentGfx, element, position);
    }

    var loopCharacteristics = obj.loopCharacteristics,
        isSequential = loopCharacteristics && loopCharacteristics.isSequential;

    if (loopCharacteristics) {

      if (isSequential === undefined) {
        renderer('LoopMarker')(parentGfx, element, position);
      }

      if (isSequential === false) {
        renderer('ParallelMarker')(parentGfx, element, position);
      }

      if (isSequential === true) {
        renderer('SequentialMarker')(parentGfx, element, position);
      }
    }
  }

  function renderDataItemCollection(parentGfx, element) {

    var yPosition = (element.height - 18) / element.height;

    var pathData = pathMap.getScaledPath('DATA_OBJECT_COLLECTION_PATH', {
      xScaleFactor: 1,
      yScaleFactor: 1,
      containerWidth: element.width,
      containerHeight: element.height,
      position: {
        mx: 0.33,
        my: yPosition
      }
    });

    /* collection path */ drawPath(parentGfx, pathData, {
      strokeWidth: 2
    });
  }


  // extension API, use at your own risk
  this._drawPath = drawPath;

}


inherits__WEBPACK_IMPORTED_MODULE_0___default()(BpmnRenderer, diagram_js_lib_draw_BaseRenderer__WEBPACK_IMPORTED_MODULE_2__["default"]);

BpmnRenderer.$inject = [
  'config.bpmnRenderer',
  'eventBus',
  'styles',
  'pathMap',
  'canvas',
  'textRenderer'
];


BpmnRenderer.prototype.canRender = function(element) {
  return Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_5__["is"])(element, 'bpmn:BaseElement');
};

BpmnRenderer.prototype.drawShape = function(parentGfx, element) {
  var type = element.type;
  var h = this.handlers[type];

  /* jshint -W040 */
  return h(parentGfx, element);
};

BpmnRenderer.prototype.drawConnection = function(parentGfx, element) {
  var type = element.type;
  var h = this.handlers[type];

  /* jshint -W040 */
  return h(parentGfx, element);
};

BpmnRenderer.prototype.getShapePath = function(element) {

  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_5__["is"])(element, 'bpmn:Event')) {
    return Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getCirclePath"])(element);
  }

  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_5__["is"])(element, 'bpmn:Activity')) {
    return Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getRoundRectPath"])(element, TASK_BORDER_RADIUS);
  }

  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_5__["is"])(element, 'bpmn:Gateway')) {
    return Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getDiamondPath"])(element);
  }

  return Object(_BpmnRenderUtil__WEBPACK_IMPORTED_MODULE_7__["getRectPath"])(element);
};


/***/ }),

/***/ "./node_modules/bpmn-js/lib/draw/PathMap.js":
/*!**************************************************!*\
  !*** ./node_modules/bpmn-js/lib/draw/PathMap.js ***!
  \**************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return PathMap; });
/**
 * Map containing SVG paths needed by BpmnRenderer.
 */

function PathMap() {

  /**
   * Contains a map of path elements
   *
   * <h1>Path definition</h1>
   * A parameterized path is defined like this:
   * <pre>
   * 'GATEWAY_PARALLEL': {
   *   d: 'm {mx},{my} {e.x0},0 0,{e.x1} {e.x1},0 0,{e.y0} -{e.x1},0 0,{e.y1} ' +
          '-{e.x0},0 0,-{e.y1} -{e.x1},0 0,-{e.y0} {e.x1},0 z',
   *   height: 17.5,
   *   width:  17.5,
   *   heightElements: [2.5, 7.5],
   *   widthElements: [2.5, 7.5]
   * }
   * </pre>
   * <p>It's important to specify a correct <b>height and width</b> for the path as the scaling
   * is based on the ratio between the specified height and width in this object and the
   * height and width that is set as scale target (Note x,y coordinates will be scaled with
   * individual ratios).</p>
   * <p>The '<b>heightElements</b>' and '<b>widthElements</b>' array must contain the values that will be scaled.
   * The scaling is based on the computed ratios.
   * Coordinates on the y axis should be in the <b>heightElement</b>'s array, they will be scaled using
   * the computed ratio coefficient.
   * In the parameterized path the scaled values can be accessed through the 'e' object in {} brackets.
   *   <ul>
   *    <li>The values for the y axis can be accessed in the path string using {e.y0}, {e.y1}, ....</li>
   *    <li>The values for the x axis can be accessed in the path string using {e.x0}, {e.x1}, ....</li>
   *   </ul>
   *   The numbers x0, x1 respectively y0, y1, ... map to the corresponding array index.
   * </p>
   */
  this.pathMap = {
    'EVENT_MESSAGE': {
      d: 'm {mx},{my} l 0,{e.y1} l {e.x1},0 l 0,-{e.y1} z l {e.x0},{e.y0} l {e.x0},-{e.y0}',
      height: 36,
      width:  36,
      heightElements: [6, 14],
      widthElements: [10.5, 21]
    },
    'EVENT_SIGNAL': {
      d: 'M {mx},{my} l {e.x0},{e.y0} l -{e.x1},0 Z',
      height: 36,
      width: 36,
      heightElements: [18],
      widthElements: [10, 20]
    },
    'EVENT_ESCALATION': {
      d: 'M {mx},{my} l {e.x0},{e.y0} l -{e.x0},-{e.y1} l -{e.x0},{e.y1} Z',
      height: 36,
      width: 36,
      heightElements: [20, 7],
      widthElements: [8]
    },
    'EVENT_CONDITIONAL': {
      d: 'M {e.x0},{e.y0} l {e.x1},0 l 0,{e.y2} l -{e.x1},0 Z ' +
         'M {e.x2},{e.y3} l {e.x0},0 ' +
         'M {e.x2},{e.y4} l {e.x0},0 ' +
         'M {e.x2},{e.y5} l {e.x0},0 ' +
         'M {e.x2},{e.y6} l {e.x0},0 ' +
         'M {e.x2},{e.y7} l {e.x0},0 ' +
         'M {e.x2},{e.y8} l {e.x0},0 ',
      height: 36,
      width:  36,
      heightElements: [8.5, 14.5, 18, 11.5, 14.5, 17.5, 20.5, 23.5, 26.5],
      widthElements:  [10.5, 14.5, 12.5]
    },
    'EVENT_LINK': {
      d: 'm {mx},{my} 0,{e.y0} -{e.x1},0 0,{e.y1} {e.x1},0 0,{e.y0} {e.x0},-{e.y2} -{e.x0},-{e.y2} z',
      height: 36,
      width: 36,
      heightElements: [4.4375, 6.75, 7.8125],
      widthElements: [9.84375, 13.5]
    },
    'EVENT_ERROR': {
      d: 'm {mx},{my} {e.x0},-{e.y0} {e.x1},-{e.y1} {e.x2},{e.y2} {e.x3},-{e.y3} -{e.x4},{e.y4} -{e.x5},-{e.y5} z',
      height: 36,
      width: 36,
      heightElements: [0.023, 8.737, 8.151, 16.564, 10.591, 8.714],
      widthElements: [0.085, 6.672, 6.97, 4.273, 5.337, 6.636]
    },
    'EVENT_CANCEL_45': {
      d: 'm {mx},{my} -{e.x1},0 0,{e.x0} {e.x1},0 0,{e.y1} {e.x0},0 ' +
        '0,-{e.y1} {e.x1},0 0,-{e.y0} -{e.x1},0 0,-{e.y1} -{e.x0},0 z',
      height: 36,
      width: 36,
      heightElements: [4.75, 8.5],
      widthElements: [4.75, 8.5]
    },
    'EVENT_COMPENSATION': {
      d: 'm {mx},{my} {e.x0},-{e.y0} 0,{e.y1} z m {e.x1},-{e.y2} {e.x2},-{e.y3} 0,{e.y1} -{e.x2},-{e.y3} z',
      height: 36,
      width: 36,
      heightElements: [6.5, 13, 0.4, 6.1],
      widthElements: [9, 9.3, 8.7]
    },
    'EVENT_TIMER_WH': {
      d: 'M {mx},{my} l {e.x0},-{e.y0} m -{e.x0},{e.y0} l {e.x1},{e.y1} ',
      height: 36,
      width:  36,
      heightElements: [10, 2],
      widthElements: [3, 7]
    },
    'EVENT_TIMER_LINE': {
      d:  'M {mx},{my} ' +
          'm {e.x0},{e.y0} l -{e.x1},{e.y1} ',
      height: 36,
      width:  36,
      heightElements: [10, 3],
      widthElements: [0, 0]
    },
    'EVENT_MULTIPLE': {
      d:'m {mx},{my} {e.x1},-{e.y0} {e.x1},{e.y0} -{e.x0},{e.y1} -{e.x2},0 z',
      height: 36,
      width:  36,
      heightElements: [6.28099, 12.56199],
      widthElements: [3.1405, 9.42149, 12.56198]
    },
    'EVENT_PARALLEL_MULTIPLE': {
      d:'m {mx},{my} {e.x0},0 0,{e.y1} {e.x1},0 0,{e.y0} -{e.x1},0 0,{e.y1} ' +
        '-{e.x0},0 0,-{e.y1} -{e.x1},0 0,-{e.y0} {e.x1},0 z',
      height: 36,
      width:  36,
      heightElements: [2.56228, 7.68683],
      widthElements: [2.56228, 7.68683]
    },
    'GATEWAY_EXCLUSIVE': {
      d:'m {mx},{my} {e.x0},{e.y0} {e.x1},{e.y0} {e.x2},0 {e.x4},{e.y2} ' +
                    '{e.x4},{e.y1} {e.x2},0 {e.x1},{e.y3} {e.x0},{e.y3} ' +
                    '{e.x3},0 {e.x5},{e.y1} {e.x5},{e.y2} {e.x3},0 z',
      height: 17.5,
      width:  17.5,
      heightElements: [8.5, 6.5312, -6.5312, -8.5],
      widthElements:  [6.5, -6.5, 3, -3, 5, -5]
    },
    'GATEWAY_PARALLEL': {
      d:'m {mx},{my} 0,{e.y1} -{e.x1},0 0,{e.y0} {e.x1},0 0,{e.y1} {e.x0},0 ' +
        '0,-{e.y1} {e.x1},0 0,-{e.y0} -{e.x1},0 0,-{e.y1} -{e.x0},0 z',
      height: 30,
      width:  30,
      heightElements: [5, 12.5],
      widthElements: [5, 12.5]
    },
    'GATEWAY_EVENT_BASED': {
      d:'m {mx},{my} {e.x0},{e.y0} {e.x0},{e.y1} {e.x1},{e.y2} {e.x2},0 z',
      height: 11,
      width:  11,
      heightElements: [-6, 6, 12, -12],
      widthElements: [9, -3, -12]
    },
    'GATEWAY_COMPLEX': {
      d:'m {mx},{my} 0,{e.y0} -{e.x0},-{e.y1} -{e.x1},{e.y2} {e.x0},{e.y1} -{e.x2},0 0,{e.y3} ' +
        '{e.x2},0  -{e.x0},{e.y1} l {e.x1},{e.y2} {e.x0},-{e.y1} 0,{e.y0} {e.x3},0 0,-{e.y0} {e.x0},{e.y1} ' +
        '{e.x1},-{e.y2} -{e.x0},-{e.y1} {e.x2},0 0,-{e.y3} -{e.x2},0 {e.x0},-{e.y1} -{e.x1},-{e.y2} ' +
        '-{e.x0},{e.y1} 0,-{e.y0} -{e.x3},0 z',
      height: 17.125,
      width:  17.125,
      heightElements: [4.875, 3.4375, 2.125, 3],
      widthElements: [3.4375, 2.125, 4.875, 3]
    },
    'DATA_OBJECT_PATH': {
      d:'m 0,0 {e.x1},0 {e.x0},{e.y0} 0,{e.y1} -{e.x2},0 0,-{e.y2} {e.x1},0 0,{e.y0} {e.x0},0',
      height: 61,
      width:  51,
      heightElements: [10, 50, 60],
      widthElements: [10, 40, 50, 60]
    },
    'DATA_OBJECT_COLLECTION_PATH': {
      d: 'm{mx},{my} m 3,2 l 0,10 m 3,-10 l 0,10 m 3,-10 l 0,10',
      height: 10,
      width: 10,
      heightElements: [],
      widthElements: []
    },
    'DATA_ARROW': {
      d:'m 5,9 9,0 0,-3 5,5 -5,5 0,-3 -9,0 z',
      height: 61,
      width:  51,
      heightElements: [],
      widthElements: []
    },
    'DATA_STORE': {
      d:'m  {mx},{my} ' +
        'l  0,{e.y2} ' +
        'c  {e.x0},{e.y1} {e.x1},{e.y1}  {e.x2},0 ' +
        'l  0,-{e.y2} ' +
        'c -{e.x0},-{e.y1} -{e.x1},-{e.y1} -{e.x2},0' +
        'c  {e.x0},{e.y1} {e.x1},{e.y1}  {e.x2},0 ' +
        'm  -{e.x2},{e.y0}' +
        'c  {e.x0},{e.y1} {e.x1},{e.y1} {e.x2},0' +
        'm  -{e.x2},{e.y0}' +
        'c  {e.x0},{e.y1} {e.x1},{e.y1}  {e.x2},0',
      height: 61,
      width:  61,
      heightElements: [7, 10, 45],
      widthElements:  [2, 58, 60]
    },
    'TEXT_ANNOTATION': {
      d: 'm {mx}, {my} m 10,0 l -10,0 l 0,{e.y0} l 10,0',
      height: 30,
      width: 10,
      heightElements: [30],
      widthElements: [10]
    },
    'MARKER_SUB_PROCESS': {
      d: 'm{mx},{my} m 7,2 l 0,10 m -5,-5 l 10,0',
      height: 10,
      width: 10,
      heightElements: [],
      widthElements: []
    },
    'MARKER_PARALLEL': {
      d: 'm{mx},{my} m 3,2 l 0,10 m 3,-10 l 0,10 m 3,-10 l 0,10',
      height: 10,
      width: 10,
      heightElements: [],
      widthElements: []
    },
    'MARKER_SEQUENTIAL': {
      d: 'm{mx},{my} m 0,3 l 10,0 m -10,3 l 10,0 m -10,3 l 10,0',
      height: 10,
      width: 10,
      heightElements: [],
      widthElements: []
    },
    'MARKER_COMPENSATION': {
      d: 'm {mx},{my} 7,-5 0,10 z m 7.1,-0.3 6.9,-4.7 0,10 -6.9,-4.7 z',
      height: 10,
      width: 21,
      heightElements: [],
      widthElements: []
    },
    'MARKER_LOOP': {
      d: 'm {mx},{my} c 3.526979,0 6.386161,-2.829858 6.386161,-6.320661 0,-3.490806 -2.859182,-6.320661 ' +
        '-6.386161,-6.320661 -3.526978,0 -6.38616,2.829855 -6.38616,6.320661 0,1.745402 ' +
        '0.714797,3.325567 1.870463,4.469381 0.577834,0.571908 1.265885,1.034728 2.029916,1.35457 ' +
        'l -0.718163,-3.909793 m 0.718163,3.909793 -3.885211,0.802902',
      height: 13.9,
      width: 13.7,
      heightElements: [],
      widthElements: []
    },
    'MARKER_ADHOC': {
      d: 'm {mx},{my} m 0.84461,2.64411 c 1.05533,-1.23780996 2.64337,-2.07882 4.29653,-1.97997996 2.05163,0.0805 ' +
        '3.85579,1.15803 5.76082,1.79107 1.06385,0.34139996 2.24454,0.1438 3.18759,-0.43767 0.61743,-0.33642 ' +
        '1.2775,-0.64078 1.7542,-1.17511 0,0.56023 0,1.12046 0,1.6807 -0.98706,0.96237996 -2.29792,1.62393996 ' +
        '-3.6918,1.66181996 -1.24459,0.0927 -2.46671,-0.2491 -3.59505,-0.74812 -1.35789,-0.55965 ' +
        '-2.75133,-1.33436996 -4.27027,-1.18121996 -1.37741,0.14601 -2.41842,1.13685996 -3.44288,1.96782996 z',
      height: 4,
      width: 15,
      heightElements: [],
      widthElements: []
    },
    'TASK_TYPE_SEND': {
      d: 'm {mx},{my} l 0,{e.y1} l {e.x1},0 l 0,-{e.y1} z l {e.x0},{e.y0} l {e.x0},-{e.y0}',
      height: 14,
      width:  21,
      heightElements: [6, 14],
      widthElements: [10.5, 21]
    },
    'TASK_TYPE_SCRIPT': {
      d: 'm {mx},{my} c 9.966553,-6.27276 -8.000926,-7.91932 2.968968,-14.938 l -8.802728,0 ' +
        'c -10.969894,7.01868 6.997585,8.66524 -2.968967,14.938 z ' +
        'm -7,-12 l 5,0 ' +
        'm -4.5,3 l 4.5,0 ' +
        'm -3,3 l 5,0' +
        'm -4,3 l 5,0',
      height: 15,
      width:  12.6,
      heightElements: [6, 14],
      widthElements: [10.5, 21]
    },
    'TASK_TYPE_USER_1': {
      d: 'm {mx},{my} c 0.909,-0.845 1.594,-2.049 1.594,-3.385 0,-2.554 -1.805,-4.62199999 ' +
        '-4.357,-4.62199999 -2.55199998,0 -4.28799998,2.06799999 -4.28799998,4.62199999 0,1.348 ' +
        '0.974,2.562 1.89599998,3.405 -0.52899998,0.187 -5.669,2.097 -5.794,4.7560005 v 6.718 ' +
        'h 17 v -6.718 c 0,-2.2980005 -5.5279996,-4.5950005 -6.0509996,-4.7760005 z' +
        'm -8,6 l 0,5.5 m 11,0 l 0,-5'
    },
    'TASK_TYPE_USER_2': {
      d: 'm {mx},{my} m 2.162,1.009 c 0,2.4470005 -2.158,4.4310005 -4.821,4.4310005 ' +
        '-2.66499998,0 -4.822,-1.981 -4.822,-4.4310005 '
    },
    'TASK_TYPE_USER_3': {
      d: 'm {mx},{my} m -6.9,-3.80 c 0,0 2.25099998,-2.358 4.27399998,-1.177 2.024,1.181 4.221,1.537 ' +
        '4.124,0.965 -0.098,-0.57 -0.117,-3.79099999 -4.191,-4.13599999 -3.57499998,0.001 ' +
        '-4.20799998,3.36699999 -4.20699998,4.34799999 z'
    },
    'TASK_TYPE_MANUAL': {
      d: 'm {mx},{my} c 0.234,-0.01 5.604,0.008 8.029,0.004 0.808,0 1.271,-0.172 1.417,-0.752 0.227,-0.898 ' +
        '-0.334,-1.314 -1.338,-1.316 -2.467,-0.01 -7.886,-0.004 -8.108,-0.004 -0.014,-0.079 0.016,-0.533 0,-0.61 ' +
        '0.195,-0.042 8.507,0.006 9.616,0.002 0.877,-0.007 1.35,-0.438 1.353,-1.208 0.003,-0.768 -0.479,-1.09 ' +
        '-1.35,-1.091 -2.968,-0.002 -9.619,-0.013 -9.619,-0.013 v -0.591 c 0,0 5.052,-0.016 7.225,-0.016 ' +
        '0.888,-0.002 1.354,-0.416 1.351,-1.193 -0.006,-0.761 -0.492,-1.196 -1.361,-1.196 -3.473,-0.005 ' +
        '-10.86,-0.003 -11.0829995,-0.003 -0.022,-0.047 -0.045,-0.094 -0.069,-0.139 0.3939995,-0.319 ' +
        '2.0409995,-1.626 2.4149995,-2.017 0.469,-0.4870005 0.519,-1.1650005 0.162,-1.6040005 -0.414,-0.511 ' +
        '-0.973,-0.5 -1.48,-0.236 -1.4609995,0.764 -6.5999995,3.6430005 -7.7329995,4.2710005 -0.9,0.499 ' +
        '-1.516,1.253 -1.882,2.19 -0.37000002,0.95 -0.17,2.01 -0.166,2.979 0.004,0.718 -0.27300002,1.345 ' +
        '-0.055,2.063 0.629,2.087 2.425,3.312 4.859,3.318 4.6179995,0.014 9.2379995,-0.139 13.8569995,-0.158 ' +
        '0.755,-0.004 1.171,-0.301 1.182,-1.033 0.012,-0.754 -0.423,-0.969 -1.183,-0.973 -1.778,-0.01 ' +
        '-5.824,-0.004 -6.04,-0.004 10e-4,-0.084 0.003,-0.586 10e-4,-0.67 z'
    },
    'TASK_TYPE_INSTANTIATING_SEND': {
      d: 'm {mx},{my} l 0,8.4 l 12.6,0 l 0,-8.4 z l 6.3,3.6 l 6.3,-3.6'
    },
    'TASK_TYPE_SERVICE': {
      d: 'm {mx},{my} v -1.71335 c 0.352326,-0.0705 0.703932,-0.17838 1.047628,-0.32133 ' +
        '0.344416,-0.14465 0.665822,-0.32133 0.966377,-0.52145 l 1.19431,1.18005 1.567487,-1.57688 ' +
        '-1.195028,-1.18014 c 0.403376,-0.61394 0.683079,-1.29908 0.825447,-2.01824 l 1.622133,-0.01 ' +
        'v -2.2196 l -1.636514,0.01 c -0.07333,-0.35153 -0.178319,-0.70024 -0.323564,-1.04372 ' +
        '-0.145244,-0.34406 -0.321407,-0.6644 -0.522735,-0.96217 l 1.131035,-1.13631 -1.583305,-1.56293 ' +
        '-1.129598,1.13589 c -0.614052,-0.40108 -1.302883,-0.68093 -2.022633,-0.82247 l 0.0093,-1.61852 ' +
        'h -2.241173 l 0.0042,1.63124 c -0.353763,0.0736 -0.705369,0.17977 -1.049785,0.32371 -0.344415,0.14437 ' +
        '-0.665102,0.32092 -0.9635006,0.52046 l -1.1698628,-1.15823 -1.5667691,1.5792 1.1684265,1.15669 ' +
        'c -0.4026573,0.61283 -0.68308,1.29797 -0.8247287,2.01713 l -1.6588041,0.003 v 2.22174 ' +
        'l 1.6724648,-0.006 c 0.073327,0.35077 0.1797598,0.70243 0.3242851,1.04472 0.1452428,0.34448 ' +
        '0.3214064,0.6644 0.5227339,0.96066 l -1.1993431,1.19723 1.5840256,1.56011 1.1964668,-1.19348 ' +
        'c 0.6140517,0.40346 1.3028827,0.68232 2.0233517,0.82331 l 7.19e-4,1.69892 h 2.226848 z ' +
        'm 0.221462,-3.9957 c -1.788948,0.7502 -3.8576,-0.0928 -4.6097055,-1.87438 -0.7521065,-1.78321 ' +
        '0.090598,-3.84627 1.8802645,-4.59604 1.78823,-0.74936 3.856881,0.0929 4.608987,1.87437 ' +
        '0.752106,1.78165 -0.0906,3.84612 -1.879546,4.59605 z'
    },
    'TASK_TYPE_SERVICE_FILL': {
      d: 'm {mx},{my} c -1.788948,0.7502 -3.8576,-0.0928 -4.6097055,-1.87438 -0.7521065,-1.78321 ' +
        '0.090598,-3.84627 1.8802645,-4.59604 1.78823,-0.74936 3.856881,0.0929 4.608987,1.87437 ' +
        '0.752106,1.78165 -0.0906,3.84612 -1.879546,4.59605 z'
    },
    'TASK_TYPE_BUSINESS_RULE_HEADER': {
      d: 'm {mx},{my} 0,4 20,0 0,-4 z'
    },
    'TASK_TYPE_BUSINESS_RULE_MAIN': {
      d: 'm {mx},{my} 0,12 20,0 0,-12 z' +
        'm 0,8 l 20,0 ' +
        'm -13,-4 l 0,8'
    },
    'MESSAGE_FLOW_MARKER': {
      d: 'm {mx},{my} m -10.5 ,-7 l 0,14 l 21,0 l 0,-14 z l 10.5,6 l 10.5,-6'
    }
  };

  this.getRawPath = function getRawPath(pathId) {
    return this.pathMap[pathId].d;
  };

  /**
   * Scales the path to the given height and width.
   * <h1>Use case</h1>
   * <p>Use case is to scale the content of elements (event, gateways) based
   * on the element bounding box's size.
   * </p>
   * <h1>Why not transform</h1>
   * <p>Scaling a path with transform() will also scale the stroke and IE does not support
   * the option 'non-scaling-stroke' to prevent this.
   * Also there are use cases where only some parts of a path should be
   * scaled.</p>
   *
   * @param {string} pathId The ID of the path.
   * @param {Object} param <p>
   *   Example param object scales the path to 60% size of the container (data.width, data.height).
   *   <pre>
   *   {
   *     xScaleFactor: 0.6,
   *     yScaleFactor:0.6,
   *     containerWidth: data.width,
   *     containerHeight: data.height,
   *     position: {
   *       mx: 0.46,
   *       my: 0.2,
   *     }
   *   }
   *   </pre>
   *   <ul>
   *    <li>targetpathwidth = xScaleFactor * containerWidth</li>
   *    <li>targetpathheight = yScaleFactor * containerHeight</li>
   *    <li>Position is used to set the starting coordinate of the path. M is computed:
    *    <ul>
    *      <li>position.x * containerWidth</li>
    *      <li>position.y * containerHeight</li>
    *    </ul>
    *    Center of the container <pre> position: {
   *       mx: 0.5,
   *       my: 0.5,
   *     }</pre>
   *     Upper left corner of the container
   *     <pre> position: {
   *       mx: 0.0,
   *       my: 0.0,
   *     }</pre>
   *    </li>
   *   </ul>
   * </p>
   *
   */
  this.getScaledPath = function getScaledPath(pathId, param) {
    var rawPath = this.pathMap[pathId];

    // positioning
    // compute the start point of the path
    var mx, my;

    if (param.abspos) {
      mx = param.abspos.x;
      my = param.abspos.y;
    } else {
      mx = param.containerWidth * param.position.mx;
      my = param.containerHeight * param.position.my;
    }

    var coordinates = {}; // map for the scaled coordinates
    if (param.position) {

      // path
      var heightRatio = (param.containerHeight / rawPath.height) * param.yScaleFactor;
      var widthRatio = (param.containerWidth / rawPath.width) * param.xScaleFactor;


      // Apply height ratio
      for (var heightIndex = 0; heightIndex < rawPath.heightElements.length; heightIndex++) {
        coordinates['y' + heightIndex] = rawPath.heightElements[heightIndex] * heightRatio;
      }

      // Apply width ratio
      for (var widthIndex = 0; widthIndex < rawPath.widthElements.length; widthIndex++) {
        coordinates['x' + widthIndex] = rawPath.widthElements[widthIndex] * widthRatio;
      }
    }

    // Apply value to raw path
    var path = format(
      rawPath.d, {
        mx: mx,
        my: my,
        e: coordinates
      }
    );
    return path;
  };
}

// helpers //////////////////////

// copied from https://github.com/adobe-webplatform/Snap.svg/blob/master/src/svg.js
var tokenRegex = /\{([^}]+)\}/g,
    objNotationRegex = /(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g; // matches .xxxxx or ["xxxxx"] to run over object properties

function replacer(all, key, obj) {
  var res = obj;
  key.replace(objNotationRegex, function(all, name, quote, quotedName, isFunc) {
    name = name || quotedName;
    if (res) {
      if (name in res) {
        res = res[name];
      }
      typeof res == 'function' && isFunc && (res = res());
    }
  });
  res = (res == null || res == obj ? all : res) + '';

  return res;
}

function format(str, obj) {
  return String(str).replace(tokenRegex, function(all, key) {
    return replacer(all, key, obj);
  });
}


/***/ }),

/***/ "./node_modules/bpmn-js/lib/draw/TextRenderer.js":
/*!*******************************************************!*\
  !*** ./node_modules/bpmn-js/lib/draw/TextRenderer.js ***!
  \*******************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return TextRenderer; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var diagram_js_lib_util_Text__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! diagram-js/lib/util/Text */ "./node_modules/diagram-js/lib/util/Text.js");




var DEFAULT_FONT_SIZE = 12;
var LINE_HEIGHT_RATIO = 1.2;

var MIN_TEXT_ANNOTATION_HEIGHT = 30;


function TextRenderer(config) {

  var defaultStyle = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({
    fontFamily: 'Arial, sans-serif',
    fontSize: DEFAULT_FONT_SIZE,
    fontWeight: 'normal',
    lineHeight: LINE_HEIGHT_RATIO
  }, config && config.defaultStyle || {});

  var fontSize = parseInt(defaultStyle.fontSize, 10) - 1;

  var externalStyle = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, defaultStyle, {
    fontSize: fontSize
  }, config && config.externalStyle || {});

  var textUtil = new diagram_js_lib_util_Text__WEBPACK_IMPORTED_MODULE_1__["default"]({
    style: defaultStyle
  });

  /**
   * Get the new bounds of an externally rendered,
   * layouted label.
   *
   * @param  {Bounds} bounds
   * @param  {string} text
   *
   * @return {Bounds}
   */
  this.getExternalLabelBounds = function(bounds, text) {

    var layoutedDimensions = textUtil.getDimensions(text, {
      box: {
        width: 90,
        height: 30,
        x: bounds.width / 2 + bounds.x,
        y: bounds.height / 2 + bounds.y
      },
      style: externalStyle
    });

    // resize label shape to fit label text
    return {
      x: Math.round(bounds.x + bounds.width / 2 - layoutedDimensions.width / 2),
      y: Math.round(bounds.y),
      width: Math.ceil(layoutedDimensions.width),
      height: Math.ceil(layoutedDimensions.height)
    };

  };

  /**
   * Get the new bounds of text annotation.
   *
   * @param  {Bounds} bounds
   * @param  {string} text
   *
   * @return {Bounds}
   */
  this.getTextAnnotationBounds = function(bounds, text) {

    var layoutedDimensions = textUtil.getDimensions(text, {
      box: bounds,
      style: defaultStyle,
      align: 'left-top',
      padding: 5
    });

    return {
      x: bounds.x,
      y: bounds.y,
      width: bounds.width,
      height: Math.max(MIN_TEXT_ANNOTATION_HEIGHT, Math.round(layoutedDimensions.height))
    };
  };

  /**
   * Create a layouted text element.
   *
   * @param {string} text
   * @param {Object} [options]
   *
   * @return {SVGElement} rendered text
   */
  this.createText = function(text, options) {
    return textUtil.createText(text, options || {});
  };

  /**
   * Get default text style.
   */
  this.getDefaultStyle = function() {
    return defaultStyle;
  };

  /**
   * Get the external text style.
   */
  this.getExternalStyle = function() {
    return externalStyle;
  };

}

TextRenderer.$inject = [
  'config.textRenderer'
];

/***/ }),

/***/ "./node_modules/bpmn-js/lib/draw/index.js":
/*!************************************************!*\
  !*** ./node_modules/bpmn-js/lib/draw/index.js ***!
  \************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _BpmnRenderer__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./BpmnRenderer */ "./node_modules/bpmn-js/lib/draw/BpmnRenderer.js");
/* harmony import */ var _TextRenderer__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./TextRenderer */ "./node_modules/bpmn-js/lib/draw/TextRenderer.js");
/* harmony import */ var _PathMap__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./PathMap */ "./node_modules/bpmn-js/lib/draw/PathMap.js");





/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'bpmnRenderer' ],
  bpmnRenderer: [ 'type', _BpmnRenderer__WEBPACK_IMPORTED_MODULE_0__["default"] ],
  textRenderer: [ 'type', _TextRenderer__WEBPACK_IMPORTED_MODULE_1__["default"] ],
  pathMap: [ 'type', _PathMap__WEBPACK_IMPORTED_MODULE_2__["default"] ]
});


/***/ }),

/***/ "./node_modules/bpmn-js/lib/features/label-editing/LabelUtil.js":
/*!**********************************************************************!*\
  !*** ./node_modules/bpmn-js/lib/features/label-editing/LabelUtil.js ***!
  \**********************************************************************/
/*! exports provided: getLabel, setLabel */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getLabel", function() { return getLabel; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "setLabel", function() { return setLabel; });
/* harmony import */ var _util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../util/ModelUtil */ "./node_modules/bpmn-js/lib/util/ModelUtil.js");


function getLabelAttr(semantic) {
  if (
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:FlowElement') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:Participant') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:Lane') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:SequenceFlow') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:MessageFlow') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:DataInput') ||
    Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:DataOutput')
  ) {
    return 'name';
  }

  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:TextAnnotation')) {
    return 'text';
  }

  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(semantic, 'bpmn:Group')) {
    return 'categoryValueRef';
  }
}

function getCategoryValue(semantic) {
  var categoryValueRef = semantic['categoryValueRef'];

  if (!categoryValueRef) {
    return '';
  }


  return categoryValueRef.value || '';
}

function getLabel(element) {
  var semantic = element.businessObject,
      attr = getLabelAttr(semantic);

  if (attr) {

    if (attr === 'categoryValueRef') {

      return getCategoryValue(semantic);
    }

    return semantic[attr] || '';
  }
}


function setLabel(element, text, isExternal) {
  var semantic = element.businessObject,
      attr = getLabelAttr(semantic);

  if (attr) {

    if (attr === 'categoryValueRef') {
      semantic['categoryValueRef'].value = text;
    } else {
      semantic[attr] = text;
    }

  }

  return element;
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/import/BpmnImporter.js":
/*!*********************************************************!*\
  !*** ./node_modules/bpmn-js/lib/import/BpmnImporter.js ***!
  \*********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return BpmnImporter; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var _util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../util/ModelUtil */ "./node_modules/bpmn-js/lib/util/ModelUtil.js");
/* harmony import */ var _util_LabelUtil__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../util/LabelUtil */ "./node_modules/bpmn-js/lib/util/LabelUtil.js");
/* harmony import */ var diagram_js_lib_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! diagram-js/lib/layout/LayoutUtil */ "./node_modules/diagram-js/lib/layout/LayoutUtil.js");
/* harmony import */ var _util_DiUtil__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../util/DiUtil */ "./node_modules/bpmn-js/lib/util/DiUtil.js");
/* harmony import */ var _features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../features/label-editing/LabelUtil */ "./node_modules/bpmn-js/lib/features/label-editing/LabelUtil.js");
/* harmony import */ var _Util__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./Util */ "./node_modules/bpmn-js/lib/import/Util.js");















function elementData(semantic, attrs) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({
    id: semantic.id,
    type: semantic.$type,
    businessObject: semantic
  }, attrs);
}

function getWaypoints(bo, source, target) {

  var waypoints = bo.di.waypoint;

  if (!waypoints || waypoints.length < 2) {
    return [ Object(diagram_js_lib_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__["getMid"])(source), Object(diagram_js_lib_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__["getMid"])(target) ];
  }

  return waypoints.map(function(p) {
    return { x: p.x, y: p.y };
  });
}

function notYetDrawn(translate, semantic, refSemantic, property) {
  return new Error(translate('element {element} referenced by {referenced}#{property} not yet drawn', {
    element: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(refSemantic),
    referenced: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(semantic),
    property: property
  }));
}


/**
 * An importer that adds bpmn elements to the canvas
 *
 * @param {EventBus} eventBus
 * @param {Canvas} canvas
 * @param {ElementFactory} elementFactory
 * @param {ElementRegistry} elementRegistry
 * @param {Function} translate
 * @param {TextRenderer} textRenderer
 */
function BpmnImporter(
    eventBus, canvas, elementFactory,
    elementRegistry, translate, textRenderer) {

  this._eventBus = eventBus;
  this._canvas = canvas;
  this._elementFactory = elementFactory;
  this._elementRegistry = elementRegistry;
  this._translate = translate;
  this._textRenderer = textRenderer;
}

BpmnImporter.$inject = [
  'eventBus',
  'canvas',
  'elementFactory',
  'elementRegistry',
  'translate',
  'textRenderer'
];


/**
 * Add bpmn element (semantic) to the canvas onto the
 * specified parent shape.
 */
BpmnImporter.prototype.add = function(semantic, parentElement) {

  var di = semantic.di,
      element,
      translate = this._translate,
      hidden;

  var parentIndex;

  // ROOT ELEMENT
  // handle the special case that we deal with a
  // invisible root element (process or collaboration)
  if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(di, 'bpmndi:BPMNPlane')) {

    // add a virtual element (not being drawn)
    element = this._elementFactory.createRoot(elementData(semantic));

    this._canvas.setRootElement(element);
  }

  // SHAPE
  else if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(di, 'bpmndi:BPMNShape')) {

    var collapsed = !Object(_util_DiUtil__WEBPACK_IMPORTED_MODULE_4__["isExpanded"])(semantic),
        isFrame = isFrameElement(semantic);
    hidden = parentElement && (parentElement.hidden || parentElement.collapsed);

    var bounds = semantic.di.bounds;

    element = this._elementFactory.createShape(elementData(semantic, {
      collapsed: collapsed,
      hidden: hidden,
      x: Math.round(bounds.x),
      y: Math.round(bounds.y),
      width: Math.round(bounds.width),
      height: Math.round(bounds.height),
      isFrame: isFrame
    }));

    if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:BoundaryEvent')) {
      this._attachBoundary(semantic, element);
    }

    // insert lanes behind other flow nodes (cf. #727)
    if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:Lane')) {
      parentIndex = 0;
    }

    if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataStoreReference')) {

      // check whether data store is inside our outside of its semantic parent
      if (!isPointInsideBBox(parentElement, Object(diagram_js_lib_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__["getMid"])(bounds))) {
        parentElement = this._canvas.getRootElement();
      }
    }

    this._canvas.addShape(element, parentElement, parentIndex);
  }

  // CONNECTION
  else if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(di, 'bpmndi:BPMNEdge')) {

    var source = this._getSource(semantic),
        target = this._getTarget(semantic);

    hidden = parentElement && (parentElement.hidden || parentElement.collapsed);

    element = this._elementFactory.createConnection(elementData(semantic, {
      hidden: hidden,
      source: source,
      target: target,
      waypoints: getWaypoints(semantic, source, target)
    }));

    if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataAssociation')) {

      // render always on top; this ensures DataAssociations
      // are rendered correctly across different "hacks" people
      // love to model such as cross participant / sub process
      // associations
      parentElement = null;
    }

    // insert sequence flows behind other flow nodes (cf. #727)
    if (Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:SequenceFlow')) {
      parentIndex = 0;
    }

    this._canvas.addConnection(element, parentElement, parentIndex);
  } else {
    throw new Error(translate('unknown di {di} for element {semantic}', {
      di: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(di),
      semantic: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(semantic)
    }));
  }

  // (optional) LABEL
  if (Object(_util_LabelUtil__WEBPACK_IMPORTED_MODULE_2__["isLabelExternal"])(semantic) && Object(_features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_5__["getLabel"])(element)) {
    this.addLabel(semantic, element);
  }


  this._eventBus.fire('bpmnElement.added', { element: element });

  return element;
};


/**
 * Attach the boundary element to the given host
 *
 * @param {ModdleElement} boundarySemantic
 * @param {djs.model.Base} boundaryElement
 */
BpmnImporter.prototype._attachBoundary = function(boundarySemantic, boundaryElement) {
  var translate = this._translate;
  var hostSemantic = boundarySemantic.attachedToRef;

  if (!hostSemantic) {
    throw new Error(translate('missing {semantic}#attachedToRef', {
      semantic: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(boundarySemantic)
    }));
  }

  var host = this._elementRegistry.get(hostSemantic.id),
      attachers = host && host.attachers;

  if (!host) {
    throw notYetDrawn(translate, boundarySemantic, hostSemantic, 'attachedToRef');
  }

  // wire element.host <> host.attachers
  boundaryElement.host = host;

  if (!attachers) {
    host.attachers = attachers = [];
  }

  if (attachers.indexOf(boundaryElement) === -1) {
    attachers.push(boundaryElement);
  }
};


/**
 * add label for an element
 */
BpmnImporter.prototype.addLabel = function(semantic, element) {
  var bounds,
      text,
      label;

  bounds = Object(_util_LabelUtil__WEBPACK_IMPORTED_MODULE_2__["getExternalLabelBounds"])(semantic, element);

  text = Object(_features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_5__["getLabel"])(element);

  if (text) {

    // get corrected bounds from actual layouted text
    bounds = this._textRenderer.getExternalLabelBounds(bounds, text);
  }

  label = this._elementFactory.createLabel(elementData(semantic, {
    id: semantic.id + '_label',
    labelTarget: element,
    type: 'label',
    hidden: element.hidden || !Object(_features_label_editing_LabelUtil__WEBPACK_IMPORTED_MODULE_5__["getLabel"])(element),
    x: Math.round(bounds.x),
    y: Math.round(bounds.y),
    width: Math.round(bounds.width),
    height: Math.round(bounds.height)
  }));

  return this._canvas.addShape(label, element.parent);
};

/**
 * Return the drawn connection end based on the given side.
 *
 * @throws {Error} if the end is not yet drawn
 */
BpmnImporter.prototype._getEnd = function(semantic, side) {

  var element,
      refSemantic,
      type = semantic.$type,
      translate = this._translate;

  refSemantic = semantic[side + 'Ref'];

  // handle mysterious isMany DataAssociation#sourceRef
  if (side === 'source' && type === 'bpmn:DataInputAssociation') {
    refSemantic = refSemantic && refSemantic[0];
  }

  // fix source / target for DataInputAssociation / DataOutputAssociation
  if (side === 'source' && type === 'bpmn:DataOutputAssociation' ||
      side === 'target' && type === 'bpmn:DataInputAssociation') {

    refSemantic = semantic.$parent;
  }

  element = refSemantic && this._getElement(refSemantic);

  if (element) {
    return element;
  }

  if (refSemantic) {
    throw notYetDrawn(translate, semantic, refSemantic, side + 'Ref');
  } else {
    throw new Error(translate('{semantic}#{side} Ref not specified', {
      semantic: Object(_Util__WEBPACK_IMPORTED_MODULE_6__["elementToString"])(semantic),
      side: side
    }));
  }
};

BpmnImporter.prototype._getSource = function(semantic) {
  return this._getEnd(semantic, 'source');
};

BpmnImporter.prototype._getTarget = function(semantic) {
  return this._getEnd(semantic, 'target');
};


BpmnImporter.prototype._getElement = function(semantic) {
  return this._elementRegistry.get(semantic.id);
};


// helpers ////////////////////

function isPointInsideBBox(bbox, point) {
  var x = point.x,
      y = point.y;

  return x >= bbox.x &&
    x <= bbox.x + bbox.width &&
    y >= bbox.y &&
    y <= bbox.y + bbox.height;
}

function isFrameElement(semantic) {
  return Object(_util_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:Group');
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/import/BpmnTreeWalker.js":
/*!***********************************************************!*\
  !*** ./node_modules/bpmn-js/lib/import/BpmnTreeWalker.js ***!
  \***********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return BpmnTreeWalker; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var object_refs__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! object-refs */ "./node_modules/object-refs/index.js");
/* harmony import */ var object_refs__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(object_refs__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var _Util__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./Util */ "./node_modules/bpmn-js/lib/import/Util.js");






var diRefs = new object_refs__WEBPACK_IMPORTED_MODULE_1___default.a(
  { name: 'bpmnElement', enumerable: true },
  { name: 'di', configurable: true }
);

/**
 * Returns true if an element has the given meta-model type
 *
 * @param  {ModdleElement}  element
 * @param  {string}         type
 *
 * @return {boolean}
 */
function is(element, type) {
  return element.$instanceOf(type);
}


/**
 * Find a suitable display candidate for definitions where the DI does not
 * correctly specify one.
 */
function findDisplayCandidate(definitions) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(definitions.rootElements, function(e) {
    return is(e, 'bpmn:Process') || is(e, 'bpmn:Collaboration');
  });
}


function BpmnTreeWalker(handler, translate) {

  // list of containers already walked
  var handledElements = {};

  // list of elements to handle deferred to ensure
  // prerequisites are drawn
  var deferred = [];

  // Helpers //////////////////////

  function contextual(fn, ctx) {
    return function(e) {
      fn(e, ctx);
    };
  }

  function handled(element) {
    handledElements[element.id] = element;
  }

  function isHandled(element) {
    return handledElements[element.id];
  }

  function visit(element, ctx) {

    var gfx = element.gfx;

    // avoid multiple rendering of elements
    if (gfx) {
      throw new Error(
        translate('already rendered {element}', { element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(element) })
      );
    }

    // call handler
    return handler.element(element, ctx);
  }

  function visitRoot(element, diagram) {
    return handler.root(element, diagram);
  }

  function visitIfDi(element, ctx) {

    try {
      var gfx = element.di && visit(element, ctx);

      handled(element);

      return gfx;
    } catch (e) {
      logError(e.message, { element: element, error: e });

      console.error(translate('failed to import {element}', { element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(element) }));
      console.error(e);
    }
  }

  function logError(message, context) {
    handler.error(message, context);
  }

  // DI handling //////////////////////

  function registerDi(di) {
    var bpmnElement = di.bpmnElement;

    if (bpmnElement) {
      if (bpmnElement.di) {
        logError(
          translate('multiple DI elements defined for {element}', {
            element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(bpmnElement)
          }),
          { element: bpmnElement }
        );
      } else {
        diRefs.bind(bpmnElement, 'di');
        bpmnElement.di = di;
      }
    } else {
      logError(
        translate('no bpmnElement referenced in {element}', {
          element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(di)
        }),
        { element: di }
      );
    }
  }

  function handleDiagram(diagram) {
    handlePlane(diagram.plane);
  }

  function handlePlane(plane) {
    registerDi(plane);

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(plane.planeElement, handlePlaneElement);
  }

  function handlePlaneElement(planeElement) {
    registerDi(planeElement);
  }


  // Semantic handling //////////////////////

  /**
   * Handle definitions and return the rendered diagram (if any)
   *
   * @param {ModdleElement} definitions to walk and import
   * @param {ModdleElement} [diagram] specific diagram to import and display
   *
   * @throws {Error} if no diagram to display could be found
   */
  function handleDefinitions(definitions, diagram) {

    // make sure we walk the correct bpmnElement

    var diagrams = definitions.diagrams;

    if (diagram && diagrams.indexOf(diagram) === -1) {
      throw new Error(translate('diagram not part of bpmn:Definitions'));
    }

    if (!diagram && diagrams && diagrams.length) {
      diagram = diagrams[0];
    }

    // no diagram -> nothing to import
    if (!diagram) {
      throw new Error(translate('no diagram to display'));
    }

    // load DI from selected diagram only
    handleDiagram(diagram);


    var plane = diagram.plane;

    if (!plane) {
      throw new Error(translate(
        'no plane for {element}',
        { element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(diagram) }
      ));
    }

    var rootElement = plane.bpmnElement;

    // ensure we default to a suitable display candidate (process or collaboration),
    // even if non is specified in DI
    if (!rootElement) {
      rootElement = findDisplayCandidate(definitions);

      if (!rootElement) {
        throw new Error(translate('no process or collaboration to display'));
      } else {

        logError(
          translate('correcting missing bpmnElement on {plane} to {rootElement}', {
            plane: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(plane),
            rootElement: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(rootElement)
          })
        );

        // correct DI on the fly
        plane.bpmnElement = rootElement;
        registerDi(plane);
      }
    }


    var ctx = visitRoot(rootElement, plane);

    if (is(rootElement, 'bpmn:Process')) {
      handleProcess(rootElement, ctx);
    } else if (is(rootElement, 'bpmn:Collaboration')) {
      handleCollaboration(rootElement, ctx);

      // force drawing of everything not yet drawn that is part of the target DI
      handleUnhandledProcesses(definitions.rootElements, ctx);
    } else {
      throw new Error(
        translate('unsupported bpmnElement for {plane}: {rootElement}', {
          plane: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(plane),
          rootElement: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(rootElement)
        })
      );
    }

    // handle all deferred elements
    handleDeferred(deferred);
  }

  function handleDeferred() {

    var fn;

    // drain deferred until empty
    while (deferred.length) {
      fn = deferred.shift();

      fn();
    }
  }

  function handleProcess(process, context) {
    handleFlowElementsContainer(process, context);
    handleIoSpecification(process.ioSpecification, context);

    handleArtifacts(process.artifacts, context);

    // log process handled
    handled(process);
  }

  function handleUnhandledProcesses(rootElements, ctx) {

    // walk through all processes that have not yet been drawn and draw them
    // if they contain lanes with DI information.
    // we do this to pass the free-floating lane test cases in the MIWG test suite
    var processes = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(rootElements, function(e) {
      return !isHandled(e) && is(e, 'bpmn:Process') && e.laneSets;
    });

    processes.forEach(contextual(handleProcess, ctx));
  }

  function handleMessageFlow(messageFlow, context) {
    visitIfDi(messageFlow, context);
  }

  function handleMessageFlows(messageFlows, context) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(messageFlows, contextual(handleMessageFlow, context));
  }

  function handleDataAssociation(association, context) {
    visitIfDi(association, context);
  }

  function handleDataInput(dataInput, context) {
    visitIfDi(dataInput, context);
  }

  function handleDataOutput(dataOutput, context) {
    visitIfDi(dataOutput, context);
  }

  function handleArtifact(artifact, context) {

    // bpmn:TextAnnotation
    // bpmn:Group
    // bpmn:Association

    visitIfDi(artifact, context);
  }

  function handleArtifacts(artifacts, context) {

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(artifacts, function(e) {
      if (is(e, 'bpmn:Association')) {
        deferred.push(function() {
          handleArtifact(e, context);
        });
      } else {
        handleArtifact(e, context);
      }
    });
  }

  function handleIoSpecification(ioSpecification, context) {

    if (!ioSpecification) {
      return;
    }

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(ioSpecification.dataInputs, contextual(handleDataInput, context));
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(ioSpecification.dataOutputs, contextual(handleDataOutput, context));
  }

  function handleSubProcess(subProcess, context) {
    handleFlowElementsContainer(subProcess, context);
    handleArtifacts(subProcess.artifacts, context);
  }

  function handleFlowNode(flowNode, context) {
    var childCtx = visitIfDi(flowNode, context);

    if (is(flowNode, 'bpmn:SubProcess')) {
      handleSubProcess(flowNode, childCtx || context);
    }

    if (is(flowNode, 'bpmn:Activity')) {
      handleIoSpecification(flowNode.ioSpecification, context);
    }

    // defer handling of associations
    // affected types:
    //
    //   * bpmn:Activity
    //   * bpmn:ThrowEvent
    //   * bpmn:CatchEvent
    //
    deferred.push(function() {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(flowNode.dataInputAssociations, contextual(handleDataAssociation, context));
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(flowNode.dataOutputAssociations, contextual(handleDataAssociation, context));
    });
  }

  function handleSequenceFlow(sequenceFlow, context) {
    visitIfDi(sequenceFlow, context);
  }

  function handleDataElement(dataObject, context) {
    visitIfDi(dataObject, context);
  }

  function handleLane(lane, context) {

    deferred.push(function() {

      var newContext = visitIfDi(lane, context);

      if (lane.childLaneSet) {
        handleLaneSet(lane.childLaneSet, newContext || context);
      }

      wireFlowNodeRefs(lane);
    });
  }

  function handleLaneSet(laneSet, context) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(laneSet.lanes, contextual(handleLane, context));
  }

  function handleLaneSets(laneSets, context) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(laneSets, contextual(handleLaneSet, context));
  }

  function handleFlowElementsContainer(container, context) {
    handleFlowElements(container.flowElements, context);

    if (container.laneSets) {
      handleLaneSets(container.laneSets, context);
    }
  }

  function handleFlowElements(flowElements, context) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(flowElements, function(e) {
      if (is(e, 'bpmn:SequenceFlow')) {
        deferred.push(function() {
          handleSequenceFlow(e, context);
        });
      } else if (is(e, 'bpmn:BoundaryEvent')) {
        deferred.unshift(function() {
          handleFlowNode(e, context);
        });
      } else if (is(e, 'bpmn:FlowNode')) {
        handleFlowNode(e, context);
      } else if (is(e, 'bpmn:DataObject')) {

        // SKIP (assume correct referencing via DataObjectReference)
      } else if (is(e, 'bpmn:DataStoreReference')) {
        handleDataElement(e, context);
      } else if (is(e, 'bpmn:DataObjectReference')) {
        handleDataElement(e, context);
      } else {
        logError(
          translate('unrecognized flowElement {element} in context {context}', {
            element: Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(e),
            context: (context ? Object(_Util__WEBPACK_IMPORTED_MODULE_2__["elementToString"])(context.businessObject) : 'null')
          }),
          { element: e, context: context }
        );
      }
    });
  }

  function handleParticipant(participant, context) {
    var newCtx = visitIfDi(participant, context);

    var process = participant.processRef;
    if (process) {
      handleProcess(process, newCtx || context);
    }
  }

  function handleCollaboration(collaboration) {

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(collaboration.participants, contextual(handleParticipant));

    handleArtifacts(collaboration.artifacts);

    // handle message flows latest in the process
    deferred.push(function() {
      handleMessageFlows(collaboration.messageFlows);
    });
  }


  function wireFlowNodeRefs(lane) {

    // wire the virtual flowNodeRefs <-> relationship
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(lane.flowNodeRef, function(flowNode) {
      var lanes = flowNode.get('lanes');

      if (lanes) {
        lanes.push(lane);
      }
    });
  }

  // API //////////////////////

  return {
    handleDeferred: handleDeferred,
    handleDefinitions: handleDefinitions,
    handleSubProcess: handleSubProcess,
    registerDi: registerDi
  };
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/import/Importer.js":
/*!*****************************************************!*\
  !*** ./node_modules/bpmn-js/lib/import/Importer.js ***!
  \*****************************************************/
/*! exports provided: importBpmnDiagram */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "importBpmnDiagram", function() { return importBpmnDiagram; });
/* harmony import */ var _BpmnTreeWalker__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./BpmnTreeWalker */ "./node_modules/bpmn-js/lib/import/BpmnTreeWalker.js");



/**
 * The importBpmnDiagram result.
 *
 * @typedef {Object} ImportBPMNDiagramResult
 *
 * @property {Array<string>} warnings
 */

/**
* The importBpmnDiagram error.
*
* @typedef {Error} ImportBPMNDiagramError
*
* @property {Array<string>} warnings
*/

/**
 * Import the definitions into a diagram.
 *
 * Errors and warnings are reported through the specified callback.
 *
 * @param  {djs.Diagram} diagram
 * @param  {ModdleElement<Definitions>} definitions
 * @param  {ModdleElement<BPMNDiagram>} [bpmnDiagram] the diagram to be rendered
 * (if not provided, the first one will be rendered)
 *
 * Returns {Promise<ImportBPMNDiagramResult, ImportBPMNDiagramError>}
 */
function importBpmnDiagram(diagram, definitions, bpmnDiagram) {

  var importer,
      eventBus,
      translate;

  var error,
      warnings = [];

  /**
   * Walk the diagram semantically, importing (=drawing)
   * all elements you encounter.
   *
   * @param {ModdleElement<Definitions>} definitions
   * @param {ModdleElement<BPMNDiagram>} bpmnDiagram
   */
  function render(definitions, bpmnDiagram) {

    var visitor = {

      root: function(element) {
        return importer.add(element);
      },

      element: function(element, parentShape) {
        return importer.add(element, parentShape);
      },

      error: function(message, context) {
        warnings.push({ message: message, context: context });
      }
    };

    var walker = new _BpmnTreeWalker__WEBPACK_IMPORTED_MODULE_0__["default"](visitor, translate);

    // traverse BPMN 2.0 document model,
    // starting at definitions
    walker.handleDefinitions(definitions, bpmnDiagram);
  }

  return new Promise(function(resolve, reject) {
    try {
      importer = diagram.get('bpmnImporter');
      eventBus = diagram.get('eventBus');
      translate = diagram.get('translate');

      eventBus.fire('import.render.start', { definitions: definitions });

      render(definitions, bpmnDiagram);

      eventBus.fire('import.render.complete', {
        error: error,
        warnings: warnings
      });

      return resolve({ warnings: warnings });
    } catch (e) {

      e.warnings = warnings;
      return reject(e);
    }
  });
}


/***/ }),

/***/ "./node_modules/bpmn-js/lib/import/Util.js":
/*!*************************************************!*\
  !*** ./node_modules/bpmn-js/lib/import/Util.js ***!
  \*************************************************/
/*! exports provided: elementToString */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "elementToString", function() { return elementToString; });
function elementToString(e) {
  if (!e) {
    return '<null>';
  }

  return '<' + e.$type + (e.id ? ' id="' + e.id : '') + '" />';
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/import/index.js":
/*!**************************************************!*\
  !*** ./node_modules/bpmn-js/lib/import/index.js ***!
  \**************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var diagram_js_lib_i18n_translate__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! diagram-js/lib/i18n/translate */ "./node_modules/diagram-js/lib/i18n/translate/index.js");
/* harmony import */ var _BpmnImporter__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./BpmnImporter */ "./node_modules/bpmn-js/lib/import/BpmnImporter.js");




/* harmony default export */ __webpack_exports__["default"] = ({
  __depends__: [
    diagram_js_lib_i18n_translate__WEBPACK_IMPORTED_MODULE_0__["default"]
  ],
  bpmnImporter: [ 'type', _BpmnImporter__WEBPACK_IMPORTED_MODULE_1__["default"] ]
});

/***/ }),

/***/ "./node_modules/bpmn-js/lib/util/CompatibilityUtil.js":
/*!************************************************************!*\
  !*** ./node_modules/bpmn-js/lib/util/CompatibilityUtil.js ***!
  \************************************************************/
/*! exports provided: wrapForCompatibility */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "wrapForCompatibility", function() { return wrapForCompatibility; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


// TODO(nikku): remove with future bpmn-js version

/**
 * Wraps APIs to check:
 *
 * 1) If a callback is passed -> Warn users about callback deprecation.
 * 2) If Promise class is implemented in current environment.
 *
 * @private
 */
function wrapForCompatibility(api) {

  return function() {

    if (!window.Promise) {
      throw new Error('Promises is not supported in this environment. Please polyfill Promise.');
    }

    var argLen = arguments.length;
    if (argLen >= 1 && Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isFunction"])(arguments[argLen - 1])) {

      var callback = arguments[argLen - 1];

      console.warn(new Error(
        'Passing callbacks to ' + api.name + ' is deprecated and will be removed in a future major release. ' +
        'Please switch to promises: https://bpmn.io/l/moving-to-promises.html'
      ));

      var argsWithoutCallback = Array.prototype.slice.call(arguments, 0, -1);

      api.apply(this, argsWithoutCallback).then(function(result) {

        var firstKey = Object.keys(result)[0];

        // The APIs we are wrapping all resolve a single item depending on the API.
        // For instance, importXML resolves { warnings } and saveXML returns { xml }.
        // That's why we can call the callback with the first item of result.
        return callback(null, result[firstKey]);

        // Passing a second paramter instead of catch because we don't want to
        // catch errors thrown by callback().
      }, function(err) {

        return callback(err, err.warnings);
      });
    } else {

      return api.apply(this, arguments);
    }
  };
}


/***/ }),

/***/ "./node_modules/bpmn-js/lib/util/DiUtil.js":
/*!*************************************************!*\
  !*** ./node_modules/bpmn-js/lib/util/DiUtil.js ***!
  \*************************************************/
/*! exports provided: isExpanded, isInterrupting, isEventSubProcess, hasEventDefinition, hasErrorEventDefinition, hasEscalationEventDefinition, hasCompensateEventDefinition */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isExpanded", function() { return isExpanded; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isInterrupting", function() { return isInterrupting; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isEventSubProcess", function() { return isEventSubProcess; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasEventDefinition", function() { return hasEventDefinition; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasErrorEventDefinition", function() { return hasErrorEventDefinition; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasEscalationEventDefinition", function() { return hasEscalationEventDefinition; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasCompensateEventDefinition", function() { return hasCompensateEventDefinition; });
/* harmony import */ var _ModelUtil__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./ModelUtil */ "./node_modules/bpmn-js/lib/util/ModelUtil.js");
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");





function isExpanded(element) {

  if (Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(element, 'bpmn:CallActivity')) {
    return false;
  }

  if (Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(element, 'bpmn:SubProcess')) {
    return Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element).di && !!Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element).di.isExpanded;
  }

  if (Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(element, 'bpmn:Participant')) {
    return !!Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element).processRef;
  }

  return true;
}

function isInterrupting(element) {
  return element && Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element).isInterrupting !== false;
}

function isEventSubProcess(element) {
  return element && !!Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element).triggeredByEvent;
}

function hasEventDefinition(element, eventType) {
  var bo = Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["getBusinessObject"])(element),
      hasEventDefinition = false;

  if (bo.eventDefinitions) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["forEach"])(bo.eventDefinitions, function(event) {
      if (Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_0__["is"])(event, eventType)) {
        hasEventDefinition = true;
      }
    });
  }

  return hasEventDefinition;
}

function hasErrorEventDefinition(element) {
  return hasEventDefinition(element, 'bpmn:ErrorEventDefinition');
}

function hasEscalationEventDefinition(element) {
  return hasEventDefinition(element, 'bpmn:EscalationEventDefinition');
}

function hasCompensateEventDefinition(element) {
  return hasEventDefinition(element, 'bpmn:CompensateEventDefinition');
}


/***/ }),

/***/ "./node_modules/bpmn-js/lib/util/LabelUtil.js":
/*!****************************************************!*\
  !*** ./node_modules/bpmn-js/lib/util/LabelUtil.js ***!
  \****************************************************/
/*! exports provided: DEFAULT_LABEL_SIZE, FLOW_LABEL_INDENT, isLabelExternal, hasExternalLabel, getFlowLabelPosition, getWaypointsMid, getExternalLabelMid, getExternalLabelBounds, isLabel */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "DEFAULT_LABEL_SIZE", function() { return DEFAULT_LABEL_SIZE; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "FLOW_LABEL_INDENT", function() { return FLOW_LABEL_INDENT; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isLabelExternal", function() { return isLabelExternal; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasExternalLabel", function() { return hasExternalLabel; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getFlowLabelPosition", function() { return getFlowLabelPosition; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getWaypointsMid", function() { return getWaypointsMid; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getExternalLabelMid", function() { return getExternalLabelMid; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getExternalLabelBounds", function() { return getExternalLabelBounds; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isLabel", function() { return isLabel; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var _ModelUtil__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./ModelUtil */ "./node_modules/bpmn-js/lib/util/ModelUtil.js");





var DEFAULT_LABEL_SIZE = {
  width: 90,
  height: 20
};

var FLOW_LABEL_INDENT = 15;


/**
 * Returns true if the given semantic has an external label
 *
 * @param {BpmnElement} semantic
 * @return {boolean} true if has label
 */
function isLabelExternal(semantic) {
  return Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:Event') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:Gateway') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataStoreReference') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataObjectReference') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataInput') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:DataOutput') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:SequenceFlow') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:MessageFlow') ||
         Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(semantic, 'bpmn:Group');
}

/**
 * Returns true if the given element has an external label
 *
 * @param {djs.model.shape} element
 * @return {boolean} true if has label
 */
function hasExternalLabel(element) {
  return isLabel(element.label);
}

/**
 * Get the position for sequence flow labels
 *
 * @param  {Array<Point>} waypoints
 * @return {Point} the label position
 */
function getFlowLabelPosition(waypoints) {

  // get the waypoints mid
  var mid = waypoints.length / 2 - 1;

  var first = waypoints[Math.floor(mid)];
  var second = waypoints[Math.ceil(mid + 0.01)];

  // get position
  var position = getWaypointsMid(waypoints);

  // calculate angle
  var angle = Math.atan((second.y - first.y) / (second.x - first.x));

  var x = position.x,
      y = position.y;

  if (Math.abs(angle) < Math.PI / 2) {
    y -= FLOW_LABEL_INDENT;
  } else {
    x += FLOW_LABEL_INDENT;
  }

  return { x: x, y: y };
}


/**
 * Get the middle of a number of waypoints
 *
 * @param  {Array<Point>} waypoints
 * @return {Point} the mid point
 */
function getWaypointsMid(waypoints) {

  var mid = waypoints.length / 2 - 1;

  var first = waypoints[Math.floor(mid)];
  var second = waypoints[Math.ceil(mid + 0.01)];

  return {
    x: first.x + (second.x - first.x) / 2,
    y: first.y + (second.y - first.y) / 2
  };
}


function getExternalLabelMid(element) {

  if (element.waypoints) {
    return getFlowLabelPosition(element.waypoints);
  } else if (Object(_ModelUtil__WEBPACK_IMPORTED_MODULE_1__["is"])(element, 'bpmn:Group')) {
    return {
      x: element.x + element.width / 2,
      y: element.y + DEFAULT_LABEL_SIZE.height / 2
    };
  } else {
    return {
      x: element.x + element.width / 2,
      y: element.y + element.height + DEFAULT_LABEL_SIZE.height / 2
    };
  }
}


/**
 * Returns the bounds of an elements label, parsed from the elements DI or
 * generated from its bounds.
 *
 * @param {BpmnElement} semantic
 * @param {djs.model.Base} element
 */
function getExternalLabelBounds(semantic, element) {

  var mid,
      size,
      bounds,
      di = semantic.di,
      label = di.label;

  if (label && label.bounds) {
    bounds = label.bounds;

    size = {
      width: Math.max(DEFAULT_LABEL_SIZE.width, bounds.width),
      height: bounds.height
    };

    mid = {
      x: bounds.x + bounds.width / 2,
      y: bounds.y + bounds.height / 2
    };
  } else {

    mid = getExternalLabelMid(element);

    size = DEFAULT_LABEL_SIZE;
  }

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({
    x: mid.x - size.width / 2,
    y: mid.y - size.height / 2
  }, size);
}

function isLabel(element) {
  return element && !!element.labelTarget;
}


/***/ }),

/***/ "./node_modules/bpmn-js/lib/util/ModelUtil.js":
/*!****************************************************!*\
  !*** ./node_modules/bpmn-js/lib/util/ModelUtil.js ***!
  \****************************************************/
/*! exports provided: is, getBusinessObject */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "is", function() { return is; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getBusinessObject", function() { return getBusinessObject; });
/**
 * Is an element of the given BPMN type?
 *
 * @param  {djs.model.Base|ModdleElement} element
 * @param  {string} type
 *
 * @return {boolean}
 */
function is(element, type) {
  var bo = getBusinessObject(element);

  return bo && (typeof bo.$instanceOf === 'function') && bo.$instanceOf(type);
}


/**
 * Return the business object for a given element.
 *
 * @param  {djs.model.Base|ModdleElement} element
 *
 * @return {ModdleElement}
 */
function getBusinessObject(element) {
  return (element && element.businessObject) || element;
}

/***/ }),

/***/ "./node_modules/bpmn-js/lib/util/PoweredByUtil.js":
/*!********************************************************!*\
  !*** ./node_modules/bpmn-js/lib/util/PoweredByUtil.js ***!
  \********************************************************/
/*! exports provided: BPMNIO_IMG, LINK_STYLES, open */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "BPMNIO_IMG", function() { return BPMNIO_IMG; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "LINK_STYLES", function() { return LINK_STYLES; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "open", function() { return open; });
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/**
 * This file must not be changed or exchanged.
 *
 * @see http://bpmn.io/license for more information.
 */




// inlined ../../resources/logo.svg
var BPMNIO_LOGO_SVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14.02 5.57" width="53" height="21" style="vertical-align:middle"><path fill="currentColor" d="M1.88.92v.14c0 .41-.13.68-.4.8.33.14.46.44.46.86v.33c0 .61-.33.95-.95.95H0V0h.95c.65 0 .93.3.93.92zM.63.57v1.06h.24c.24 0 .38-.1.38-.43V.98c0-.28-.1-.4-.32-.4zm0 1.63v1.22h.36c.2 0 .32-.1.32-.39v-.35c0-.37-.12-.48-.4-.48H.63zM4.18.99v.52c0 .64-.31.98-.94.98h-.3V4h-.62V0h.92c.63 0 .94.35.94.99zM2.94.57v1.35h.3c.2 0 .3-.09.3-.37v-.6c0-.29-.1-.38-.3-.38h-.3zm2.89 2.27L6.25 0h.88v4h-.6V1.12L6.1 3.99h-.6l-.46-2.82v2.82h-.55V0h.87zM8.14 1.1V4h-.56V0h.79L9 2.4V0h.56v4h-.64zm2.49 2.29v.6h-.6v-.6zM12.12 1c0-.63.33-1 .95-1 .61 0 .95.37.95 1v2.04c0 .64-.34 1-.95 1-.62 0-.95-.37-.95-1zm.62 2.08c0 .28.13.39.33.39s.32-.1.32-.4V.98c0-.29-.12-.4-.32-.4s-.33.11-.33.4z"/><path fill="currentColor" d="M0 4.53h14.02v1.04H0zM11.08 0h.63v.62h-.63zm.63 4V1h-.63v2.98z"/></svg>';

var BPMNIO_IMG = BPMNIO_LOGO_SVG;

function css(attrs) {
  return attrs.join(';');
}

var LINK_STYLES = css([
  'color: #404040'
]);

var LIGHTBOX_STYLES = css([
  'z-index: 1001',
  'position: fixed',
  'top: 0',
  'left: 0',
  'right: 0',
  'bottom: 0'
]);

var BACKDROP_STYLES = css([
  'width: 100%',
  'height: 100%',
  'background: rgba(40,40,40,0.2)'
]);

var NOTICE_STYLES = css([
  'position: absolute',
  'left: 50%',
  'top: 40%',
  'transform: translate(-50%)',
  'width: 260px',
  'padding: 10px',
  'background: white',
  'box-shadow: 0 1px 4px rgba(0,0,0,0.3)',
  'font-family: Helvetica, Arial, sans-serif',
  'font-size: 14px',
  'display: flex',
  'line-height: 1.3'
]);

var LIGHTBOX_MARKUP =
  '<div class="bjs-powered-by-lightbox" style="' + LIGHTBOX_STYLES + '">' +
    '<div class="backdrop" style="' + BACKDROP_STYLES + '"></div>' +
    '<div class="notice" style="' + NOTICE_STYLES + '">' +
      '<a href="https://bpmn.io" target="_blank" rel="noopener" style="margin: 15px 20px 15px 10px; align-self: center;' + LINK_STYLES + '">' +
        BPMNIO_IMG +
      '</a>' +
      '<span>' +
        'Web-based tooling for BPMN, DMN and CMMN diagrams ' +
        'powered by <a href="https://bpmn.io" target="_blank" rel="noopener">bpmn.io</a>.' +
      '</span>' +
    '</div>' +
  '</div>';


var lightbox;

function open() {

  if (!lightbox) {
    lightbox = Object(min_dom__WEBPACK_IMPORTED_MODULE_0__["domify"])(LIGHTBOX_MARKUP);

    min_dom__WEBPACK_IMPORTED_MODULE_0__["delegate"].bind(lightbox, '.backdrop', 'click', function(event) {
      document.body.removeChild(lightbox);
    });
  }

  document.body.appendChild(lightbox);
}


/***/ }),

/***/ "./node_modules/bpmn-moddle/dist/index.esm.js":
/*!****************************************************!*\
  !*** ./node_modules/bpmn-moddle/dist/index.esm.js ***!
  \****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var moddle__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! moddle */ "./node_modules/moddle/dist/index.esm.js");
/* harmony import */ var moddle_xml__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! moddle-xml */ "./node_modules/moddle-xml/dist/index.esm.js");




/**
 * A sub class of {@link Moddle} with support for import and export of BPMN 2.0 xml files.
 *
 * @class BpmnModdle
 * @extends Moddle
 *
 * @param {Object|Array} packages to use for instantiating the model
 * @param {Object} [options] additional options to pass over
 */
function BpmnModdle(packages, options) {
  moddle__WEBPACK_IMPORTED_MODULE_1__["Moddle"].call(this, packages, options);
}

BpmnModdle.prototype = Object.create(moddle__WEBPACK_IMPORTED_MODULE_1__["Moddle"].prototype);

/**
 * The fromXML result.
 *
 * @typedef {Object} ParseResult
 *
 * @property {ModdleElement} rootElement
 * @property {Array<Object>} references
 * @property {Array<Error>} warnings
 * @property {Object} elementsById - a mapping containing each ID -> ModdleElement
 */

/**
 * The fromXML error.
 *
 * @typedef {Error} ParseError
 *
 * @property {Array<Error>} warnings
 */

/**
 * Instantiates a BPMN model tree from a given xml string.
 *
 * @param {String}   xmlStr
 * @param {String}   [typeName='bpmn:Definitions'] name of the root element
 * @param {Object}   [options]  options to pass to the underlying reader
 *
 * @returns {Promise<ParseResult, ParseError>}
 */
BpmnModdle.prototype.fromXML = function(xmlStr, typeName, options) {

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(typeName)) {
    options = typeName;
    typeName = 'bpmn:Definitions';
  }

  var reader = new moddle_xml__WEBPACK_IMPORTED_MODULE_2__["Reader"](Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ model: this, lax: true }, options));
  var rootHandler = reader.handler(typeName);

  return reader.fromXML(xmlStr, rootHandler);
};


/**
 * The toXML result.
 *
 * @typedef {Object} SerializationResult
 *
 * @property {String} xml
 */

/**
 * Serializes a BPMN 2.0 object tree to XML.
 *
 * @param {String}   element    the root element, typically an instance of `bpmn:Definitions`
 * @param {Object}   [options]  to pass to the underlying writer
 *
 * @returns {Promise<SerializationResult, Error>}
 */
BpmnModdle.prototype.toXML = function(element, options) {

  var writer = new moddle_xml__WEBPACK_IMPORTED_MODULE_2__["Writer"](options);

  return new Promise(function(resolve, reject) {
    try {
      var result = writer.toXML(element);

      return resolve({
        xml: result
      });
    } catch (err) {
      return reject(err);
    }
  });
};

var name = "BPMN20";
var uri = "http://www.omg.org/spec/BPMN/20100524/MODEL";
var prefix = "bpmn";
var associations = [
];
var types = [
	{
		name: "Interface",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "operations",
				type: "Operation",
				isMany: true
			},
			{
				name: "implementationRef",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Operation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "inMessageRef",
				type: "Message",
				isReference: true
			},
			{
				name: "outMessageRef",
				type: "Message",
				isReference: true
			},
			{
				name: "errorRef",
				type: "Error",
				isMany: true,
				isReference: true
			},
			{
				name: "implementationRef",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "EndPoint",
		superClass: [
			"RootElement"
		]
	},
	{
		name: "Auditing",
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "GlobalTask",
		superClass: [
			"CallableElement"
		],
		properties: [
			{
				name: "resources",
				type: "ResourceRole",
				isMany: true
			}
		]
	},
	{
		name: "Monitoring",
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "Performer",
		superClass: [
			"ResourceRole"
		]
	},
	{
		name: "Process",
		superClass: [
			"FlowElementsContainer",
			"CallableElement"
		],
		properties: [
			{
				name: "processType",
				type: "ProcessType",
				isAttr: true
			},
			{
				name: "isClosed",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "auditing",
				type: "Auditing"
			},
			{
				name: "monitoring",
				type: "Monitoring"
			},
			{
				name: "properties",
				type: "Property",
				isMany: true
			},
			{
				name: "laneSets",
				isMany: true,
				replaces: "FlowElementsContainer#laneSets",
				type: "LaneSet"
			},
			{
				name: "flowElements",
				isMany: true,
				replaces: "FlowElementsContainer#flowElements",
				type: "FlowElement"
			},
			{
				name: "artifacts",
				type: "Artifact",
				isMany: true
			},
			{
				name: "resources",
				type: "ResourceRole",
				isMany: true
			},
			{
				name: "correlationSubscriptions",
				type: "CorrelationSubscription",
				isMany: true
			},
			{
				name: "supports",
				type: "Process",
				isMany: true,
				isReference: true
			},
			{
				name: "definitionalCollaborationRef",
				type: "Collaboration",
				isAttr: true,
				isReference: true
			},
			{
				name: "isExecutable",
				isAttr: true,
				type: "Boolean"
			}
		]
	},
	{
		name: "LaneSet",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "lanes",
				type: "Lane",
				isMany: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Lane",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "partitionElementRef",
				type: "BaseElement",
				isAttr: true,
				isReference: true
			},
			{
				name: "partitionElement",
				type: "BaseElement"
			},
			{
				name: "flowNodeRef",
				type: "FlowNode",
				isMany: true,
				isReference: true
			},
			{
				name: "childLaneSet",
				type: "LaneSet",
				xml: {
					serialize: "xsi:type"
				}
			}
		]
	},
	{
		name: "GlobalManualTask",
		superClass: [
			"GlobalTask"
		]
	},
	{
		name: "ManualTask",
		superClass: [
			"Task"
		]
	},
	{
		name: "UserTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "renderings",
				type: "Rendering",
				isMany: true
			},
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Rendering",
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "HumanPerformer",
		superClass: [
			"Performer"
		]
	},
	{
		name: "PotentialOwner",
		superClass: [
			"HumanPerformer"
		]
	},
	{
		name: "GlobalUserTask",
		superClass: [
			"GlobalTask"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			},
			{
				name: "renderings",
				type: "Rendering",
				isMany: true
			}
		]
	},
	{
		name: "Gateway",
		isAbstract: true,
		superClass: [
			"FlowNode"
		],
		properties: [
			{
				name: "gatewayDirection",
				type: "GatewayDirection",
				"default": "Unspecified",
				isAttr: true
			}
		]
	},
	{
		name: "EventBasedGateway",
		superClass: [
			"Gateway"
		],
		properties: [
			{
				name: "instantiate",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "eventGatewayType",
				type: "EventBasedGatewayType",
				isAttr: true,
				"default": "Exclusive"
			}
		]
	},
	{
		name: "ComplexGateway",
		superClass: [
			"Gateway"
		],
		properties: [
			{
				name: "activationCondition",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "default",
				type: "SequenceFlow",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ExclusiveGateway",
		superClass: [
			"Gateway"
		],
		properties: [
			{
				name: "default",
				type: "SequenceFlow",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "InclusiveGateway",
		superClass: [
			"Gateway"
		],
		properties: [
			{
				name: "default",
				type: "SequenceFlow",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ParallelGateway",
		superClass: [
			"Gateway"
		]
	},
	{
		name: "RootElement",
		isAbstract: true,
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "Relationship",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "type",
				isAttr: true,
				type: "String"
			},
			{
				name: "direction",
				type: "RelationshipDirection",
				isAttr: true
			},
			{
				name: "source",
				isMany: true,
				isReference: true,
				type: "Element"
			},
			{
				name: "target",
				isMany: true,
				isReference: true,
				type: "Element"
			}
		]
	},
	{
		name: "BaseElement",
		isAbstract: true,
		properties: [
			{
				name: "id",
				isAttr: true,
				type: "String",
				isId: true
			},
			{
				name: "documentation",
				type: "Documentation",
				isMany: true
			},
			{
				name: "extensionDefinitions",
				type: "ExtensionDefinition",
				isMany: true,
				isReference: true
			},
			{
				name: "extensionElements",
				type: "ExtensionElements"
			}
		]
	},
	{
		name: "Extension",
		properties: [
			{
				name: "mustUnderstand",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "definition",
				type: "ExtensionDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ExtensionDefinition",
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "extensionAttributeDefinitions",
				type: "ExtensionAttributeDefinition",
				isMany: true
			}
		]
	},
	{
		name: "ExtensionAttributeDefinition",
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "type",
				isAttr: true,
				type: "String"
			},
			{
				name: "isReference",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "extensionDefinition",
				type: "ExtensionDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ExtensionElements",
		properties: [
			{
				name: "valueRef",
				isAttr: true,
				isReference: true,
				type: "Element"
			},
			{
				name: "values",
				type: "Element",
				isMany: true
			},
			{
				name: "extensionAttributeDefinition",
				type: "ExtensionAttributeDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Documentation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "text",
				type: "String",
				isBody: true
			},
			{
				name: "textFormat",
				"default": "text/plain",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Event",
		isAbstract: true,
		superClass: [
			"FlowNode",
			"InteractionNode"
		],
		properties: [
			{
				name: "properties",
				type: "Property",
				isMany: true
			}
		]
	},
	{
		name: "IntermediateCatchEvent",
		superClass: [
			"CatchEvent"
		]
	},
	{
		name: "IntermediateThrowEvent",
		superClass: [
			"ThrowEvent"
		]
	},
	{
		name: "EndEvent",
		superClass: [
			"ThrowEvent"
		]
	},
	{
		name: "StartEvent",
		superClass: [
			"CatchEvent"
		],
		properties: [
			{
				name: "isInterrupting",
				"default": true,
				isAttr: true,
				type: "Boolean"
			}
		]
	},
	{
		name: "ThrowEvent",
		isAbstract: true,
		superClass: [
			"Event"
		],
		properties: [
			{
				name: "dataInputs",
				type: "DataInput",
				isMany: true
			},
			{
				name: "dataInputAssociations",
				type: "DataInputAssociation",
				isMany: true
			},
			{
				name: "inputSet",
				type: "InputSet"
			},
			{
				name: "eventDefinitions",
				type: "EventDefinition",
				isMany: true
			},
			{
				name: "eventDefinitionRef",
				type: "EventDefinition",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "CatchEvent",
		isAbstract: true,
		superClass: [
			"Event"
		],
		properties: [
			{
				name: "parallelMultiple",
				isAttr: true,
				type: "Boolean",
				"default": false
			},
			{
				name: "dataOutputs",
				type: "DataOutput",
				isMany: true
			},
			{
				name: "dataOutputAssociations",
				type: "DataOutputAssociation",
				isMany: true
			},
			{
				name: "outputSet",
				type: "OutputSet"
			},
			{
				name: "eventDefinitions",
				type: "EventDefinition",
				isMany: true
			},
			{
				name: "eventDefinitionRef",
				type: "EventDefinition",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "BoundaryEvent",
		superClass: [
			"CatchEvent"
		],
		properties: [
			{
				name: "cancelActivity",
				"default": true,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "attachedToRef",
				type: "Activity",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "EventDefinition",
		isAbstract: true,
		superClass: [
			"RootElement"
		]
	},
	{
		name: "CancelEventDefinition",
		superClass: [
			"EventDefinition"
		]
	},
	{
		name: "ErrorEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "errorRef",
				type: "Error",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "TerminateEventDefinition",
		superClass: [
			"EventDefinition"
		]
	},
	{
		name: "EscalationEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "escalationRef",
				type: "Escalation",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Escalation",
		properties: [
			{
				name: "structureRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "escalationCode",
				isAttr: true,
				type: "String"
			}
		],
		superClass: [
			"RootElement"
		]
	},
	{
		name: "CompensateEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "waitForCompletion",
				isAttr: true,
				type: "Boolean",
				"default": true
			},
			{
				name: "activityRef",
				type: "Activity",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "TimerEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "timeDate",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "timeCycle",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "timeDuration",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			}
		]
	},
	{
		name: "LinkEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "target",
				type: "LinkEventDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "source",
				type: "LinkEventDefinition",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "MessageEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "messageRef",
				type: "Message",
				isAttr: true,
				isReference: true
			},
			{
				name: "operationRef",
				type: "Operation",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ConditionalEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "condition",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			}
		]
	},
	{
		name: "SignalEventDefinition",
		superClass: [
			"EventDefinition"
		],
		properties: [
			{
				name: "signalRef",
				type: "Signal",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Signal",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "structureRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ImplicitThrowEvent",
		superClass: [
			"ThrowEvent"
		]
	},
	{
		name: "DataState",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ItemAwareElement",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "itemSubjectRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "dataState",
				type: "DataState"
			}
		]
	},
	{
		name: "DataAssociation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "sourceRef",
				type: "ItemAwareElement",
				isMany: true,
				isReference: true
			},
			{
				name: "targetRef",
				type: "ItemAwareElement",
				isReference: true
			},
			{
				name: "transformation",
				type: "FormalExpression",
				xml: {
					serialize: "property"
				}
			},
			{
				name: "assignment",
				type: "Assignment",
				isMany: true
			}
		]
	},
	{
		name: "DataInput",
		superClass: [
			"ItemAwareElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "isCollection",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "inputSetRef",
				type: "InputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "inputSetWithOptional",
				type: "InputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "inputSetWithWhileExecuting",
				type: "InputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			}
		]
	},
	{
		name: "DataOutput",
		superClass: [
			"ItemAwareElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "isCollection",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "outputSetRef",
				type: "OutputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "outputSetWithOptional",
				type: "OutputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "outputSetWithWhileExecuting",
				type: "OutputSet",
				isMany: true,
				isVirtual: true,
				isReference: true
			}
		]
	},
	{
		name: "InputSet",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "dataInputRefs",
				type: "DataInput",
				isMany: true,
				isReference: true
			},
			{
				name: "optionalInputRefs",
				type: "DataInput",
				isMany: true,
				isReference: true
			},
			{
				name: "whileExecutingInputRefs",
				type: "DataInput",
				isMany: true,
				isReference: true
			},
			{
				name: "outputSetRefs",
				type: "OutputSet",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "OutputSet",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "dataOutputRefs",
				type: "DataOutput",
				isMany: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "inputSetRefs",
				type: "InputSet",
				isMany: true,
				isReference: true
			},
			{
				name: "optionalOutputRefs",
				type: "DataOutput",
				isMany: true,
				isReference: true
			},
			{
				name: "whileExecutingOutputRefs",
				type: "DataOutput",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "Property",
		superClass: [
			"ItemAwareElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "DataInputAssociation",
		superClass: [
			"DataAssociation"
		]
	},
	{
		name: "DataOutputAssociation",
		superClass: [
			"DataAssociation"
		]
	},
	{
		name: "InputOutputSpecification",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "dataInputs",
				type: "DataInput",
				isMany: true
			},
			{
				name: "dataOutputs",
				type: "DataOutput",
				isMany: true
			},
			{
				name: "inputSets",
				type: "InputSet",
				isMany: true
			},
			{
				name: "outputSets",
				type: "OutputSet",
				isMany: true
			}
		]
	},
	{
		name: "DataObject",
		superClass: [
			"FlowElement",
			"ItemAwareElement"
		],
		properties: [
			{
				name: "isCollection",
				"default": false,
				isAttr: true,
				type: "Boolean"
			}
		]
	},
	{
		name: "InputOutputBinding",
		properties: [
			{
				name: "inputDataRef",
				type: "InputSet",
				isAttr: true,
				isReference: true
			},
			{
				name: "outputDataRef",
				type: "OutputSet",
				isAttr: true,
				isReference: true
			},
			{
				name: "operationRef",
				type: "Operation",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Assignment",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "from",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "to",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			}
		]
	},
	{
		name: "DataStore",
		superClass: [
			"RootElement",
			"ItemAwareElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "capacity",
				isAttr: true,
				type: "Integer"
			},
			{
				name: "isUnlimited",
				"default": true,
				isAttr: true,
				type: "Boolean"
			}
		]
	},
	{
		name: "DataStoreReference",
		superClass: [
			"ItemAwareElement",
			"FlowElement"
		],
		properties: [
			{
				name: "dataStoreRef",
				type: "DataStore",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "DataObjectReference",
		superClass: [
			"ItemAwareElement",
			"FlowElement"
		],
		properties: [
			{
				name: "dataObjectRef",
				type: "DataObject",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ConversationLink",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "sourceRef",
				type: "InteractionNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "targetRef",
				type: "InteractionNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ConversationAssociation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "innerConversationNodeRef",
				type: "ConversationNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "outerConversationNodeRef",
				type: "ConversationNode",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "CallConversation",
		superClass: [
			"ConversationNode"
		],
		properties: [
			{
				name: "calledCollaborationRef",
				type: "Collaboration",
				isAttr: true,
				isReference: true
			},
			{
				name: "participantAssociations",
				type: "ParticipantAssociation",
				isMany: true
			}
		]
	},
	{
		name: "Conversation",
		superClass: [
			"ConversationNode"
		]
	},
	{
		name: "SubConversation",
		superClass: [
			"ConversationNode"
		],
		properties: [
			{
				name: "conversationNodes",
				type: "ConversationNode",
				isMany: true
			}
		]
	},
	{
		name: "ConversationNode",
		isAbstract: true,
		superClass: [
			"InteractionNode",
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "participantRef",
				type: "Participant",
				isMany: true,
				isReference: true
			},
			{
				name: "messageFlowRefs",
				type: "MessageFlow",
				isMany: true,
				isReference: true
			},
			{
				name: "correlationKeys",
				type: "CorrelationKey",
				isMany: true
			}
		]
	},
	{
		name: "GlobalConversation",
		superClass: [
			"Collaboration"
		]
	},
	{
		name: "PartnerEntity",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "participantRef",
				type: "Participant",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "PartnerRole",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "participantRef",
				type: "Participant",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "CorrelationProperty",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "correlationPropertyRetrievalExpression",
				type: "CorrelationPropertyRetrievalExpression",
				isMany: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "type",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Error",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "structureRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "errorCode",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "CorrelationKey",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "correlationPropertyRef",
				type: "CorrelationProperty",
				isMany: true,
				isReference: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Expression",
		superClass: [
			"BaseElement"
		],
		isAbstract: false,
		properties: [
			{
				name: "body",
				isBody: true,
				type: "String"
			}
		]
	},
	{
		name: "FormalExpression",
		superClass: [
			"Expression"
		],
		properties: [
			{
				name: "language",
				isAttr: true,
				type: "String"
			},
			{
				name: "evaluatesToTypeRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Message",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "itemRef",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ItemDefinition",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "itemKind",
				type: "ItemKind",
				isAttr: true
			},
			{
				name: "structureRef",
				isAttr: true,
				type: "String"
			},
			{
				name: "isCollection",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "import",
				type: "Import",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "FlowElement",
		isAbstract: true,
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "auditing",
				type: "Auditing"
			},
			{
				name: "monitoring",
				type: "Monitoring"
			},
			{
				name: "categoryValueRef",
				type: "CategoryValue",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "SequenceFlow",
		superClass: [
			"FlowElement"
		],
		properties: [
			{
				name: "isImmediate",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "conditionExpression",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "sourceRef",
				type: "FlowNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "targetRef",
				type: "FlowNode",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "FlowElementsContainer",
		isAbstract: true,
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "laneSets",
				type: "LaneSet",
				isMany: true
			},
			{
				name: "flowElements",
				type: "FlowElement",
				isMany: true
			}
		]
	},
	{
		name: "CallableElement",
		isAbstract: true,
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "ioSpecification",
				type: "InputOutputSpecification",
				xml: {
					serialize: "property"
				}
			},
			{
				name: "supportedInterfaceRef",
				type: "Interface",
				isMany: true,
				isReference: true
			},
			{
				name: "ioBinding",
				type: "InputOutputBinding",
				isMany: true,
				xml: {
					serialize: "property"
				}
			}
		]
	},
	{
		name: "FlowNode",
		isAbstract: true,
		superClass: [
			"FlowElement"
		],
		properties: [
			{
				name: "incoming",
				type: "SequenceFlow",
				isMany: true,
				isReference: true
			},
			{
				name: "outgoing",
				type: "SequenceFlow",
				isMany: true,
				isReference: true
			},
			{
				name: "lanes",
				type: "Lane",
				isMany: true,
				isVirtual: true,
				isReference: true
			}
		]
	},
	{
		name: "CorrelationPropertyRetrievalExpression",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "messagePath",
				type: "FormalExpression"
			},
			{
				name: "messageRef",
				type: "Message",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "CorrelationPropertyBinding",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "dataPath",
				type: "FormalExpression"
			},
			{
				name: "correlationPropertyRef",
				type: "CorrelationProperty",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Resource",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "resourceParameters",
				type: "ResourceParameter",
				isMany: true
			}
		]
	},
	{
		name: "ResourceParameter",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "isRequired",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "type",
				type: "ItemDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "CorrelationSubscription",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "correlationKeyRef",
				type: "CorrelationKey",
				isAttr: true,
				isReference: true
			},
			{
				name: "correlationPropertyBinding",
				type: "CorrelationPropertyBinding",
				isMany: true
			}
		]
	},
	{
		name: "MessageFlow",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "sourceRef",
				type: "InteractionNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "targetRef",
				type: "InteractionNode",
				isAttr: true,
				isReference: true
			},
			{
				name: "messageRef",
				type: "Message",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "MessageFlowAssociation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "innerMessageFlowRef",
				type: "MessageFlow",
				isAttr: true,
				isReference: true
			},
			{
				name: "outerMessageFlowRef",
				type: "MessageFlow",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "InteractionNode",
		isAbstract: true,
		properties: [
			{
				name: "incomingConversationLinks",
				type: "ConversationLink",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "outgoingConversationLinks",
				type: "ConversationLink",
				isMany: true,
				isVirtual: true,
				isReference: true
			}
		]
	},
	{
		name: "Participant",
		superClass: [
			"InteractionNode",
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "interfaceRef",
				type: "Interface",
				isMany: true,
				isReference: true
			},
			{
				name: "participantMultiplicity",
				type: "ParticipantMultiplicity"
			},
			{
				name: "endPointRefs",
				type: "EndPoint",
				isMany: true,
				isReference: true
			},
			{
				name: "processRef",
				type: "Process",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ParticipantAssociation",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "innerParticipantRef",
				type: "Participant",
				isAttr: true,
				isReference: true
			},
			{
				name: "outerParticipantRef",
				type: "Participant",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ParticipantMultiplicity",
		properties: [
			{
				name: "minimum",
				"default": 0,
				isAttr: true,
				type: "Integer"
			},
			{
				name: "maximum",
				"default": 1,
				isAttr: true,
				type: "Integer"
			}
		],
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "Collaboration",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "isClosed",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "participants",
				type: "Participant",
				isMany: true
			},
			{
				name: "messageFlows",
				type: "MessageFlow",
				isMany: true
			},
			{
				name: "artifacts",
				type: "Artifact",
				isMany: true
			},
			{
				name: "conversations",
				type: "ConversationNode",
				isMany: true
			},
			{
				name: "conversationAssociations",
				type: "ConversationAssociation"
			},
			{
				name: "participantAssociations",
				type: "ParticipantAssociation",
				isMany: true
			},
			{
				name: "messageFlowAssociations",
				type: "MessageFlowAssociation",
				isMany: true
			},
			{
				name: "correlationKeys",
				type: "CorrelationKey",
				isMany: true
			},
			{
				name: "choreographyRef",
				type: "Choreography",
				isMany: true,
				isReference: true
			},
			{
				name: "conversationLinks",
				type: "ConversationLink",
				isMany: true
			}
		]
	},
	{
		name: "ChoreographyActivity",
		isAbstract: true,
		superClass: [
			"FlowNode"
		],
		properties: [
			{
				name: "participantRef",
				type: "Participant",
				isMany: true,
				isReference: true
			},
			{
				name: "initiatingParticipantRef",
				type: "Participant",
				isAttr: true,
				isReference: true
			},
			{
				name: "correlationKeys",
				type: "CorrelationKey",
				isMany: true
			},
			{
				name: "loopType",
				type: "ChoreographyLoopType",
				"default": "None",
				isAttr: true
			}
		]
	},
	{
		name: "CallChoreography",
		superClass: [
			"ChoreographyActivity"
		],
		properties: [
			{
				name: "calledChoreographyRef",
				type: "Choreography",
				isAttr: true,
				isReference: true
			},
			{
				name: "participantAssociations",
				type: "ParticipantAssociation",
				isMany: true
			}
		]
	},
	{
		name: "SubChoreography",
		superClass: [
			"ChoreographyActivity",
			"FlowElementsContainer"
		],
		properties: [
			{
				name: "artifacts",
				type: "Artifact",
				isMany: true
			}
		]
	},
	{
		name: "ChoreographyTask",
		superClass: [
			"ChoreographyActivity"
		],
		properties: [
			{
				name: "messageFlowRef",
				type: "MessageFlow",
				isMany: true,
				isReference: true
			}
		]
	},
	{
		name: "Choreography",
		superClass: [
			"Collaboration",
			"FlowElementsContainer"
		]
	},
	{
		name: "GlobalChoreographyTask",
		superClass: [
			"Choreography"
		],
		properties: [
			{
				name: "initiatingParticipantRef",
				type: "Participant",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "TextAnnotation",
		superClass: [
			"Artifact"
		],
		properties: [
			{
				name: "text",
				type: "String"
			},
			{
				name: "textFormat",
				"default": "text/plain",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Group",
		superClass: [
			"Artifact"
		],
		properties: [
			{
				name: "categoryValueRef",
				type: "CategoryValue",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Association",
		superClass: [
			"Artifact"
		],
		properties: [
			{
				name: "associationDirection",
				type: "AssociationDirection",
				isAttr: true
			},
			{
				name: "sourceRef",
				type: "BaseElement",
				isAttr: true,
				isReference: true
			},
			{
				name: "targetRef",
				type: "BaseElement",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "Category",
		superClass: [
			"RootElement"
		],
		properties: [
			{
				name: "categoryValue",
				type: "CategoryValue",
				isMany: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Artifact",
		isAbstract: true,
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "CategoryValue",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "categorizedFlowElements",
				type: "FlowElement",
				isMany: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "value",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Activity",
		isAbstract: true,
		superClass: [
			"FlowNode"
		],
		properties: [
			{
				name: "isForCompensation",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "default",
				type: "SequenceFlow",
				isAttr: true,
				isReference: true
			},
			{
				name: "ioSpecification",
				type: "InputOutputSpecification",
				xml: {
					serialize: "property"
				}
			},
			{
				name: "boundaryEventRefs",
				type: "BoundaryEvent",
				isMany: true,
				isReference: true
			},
			{
				name: "properties",
				type: "Property",
				isMany: true
			},
			{
				name: "dataInputAssociations",
				type: "DataInputAssociation",
				isMany: true
			},
			{
				name: "dataOutputAssociations",
				type: "DataOutputAssociation",
				isMany: true
			},
			{
				name: "startQuantity",
				"default": 1,
				isAttr: true,
				type: "Integer"
			},
			{
				name: "resources",
				type: "ResourceRole",
				isMany: true
			},
			{
				name: "completionQuantity",
				"default": 1,
				isAttr: true,
				type: "Integer"
			},
			{
				name: "loopCharacteristics",
				type: "LoopCharacteristics"
			}
		]
	},
	{
		name: "ServiceTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			},
			{
				name: "operationRef",
				type: "Operation",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "SubProcess",
		superClass: [
			"Activity",
			"FlowElementsContainer",
			"InteractionNode"
		],
		properties: [
			{
				name: "triggeredByEvent",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "artifacts",
				type: "Artifact",
				isMany: true
			}
		]
	},
	{
		name: "LoopCharacteristics",
		isAbstract: true,
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "MultiInstanceLoopCharacteristics",
		superClass: [
			"LoopCharacteristics"
		],
		properties: [
			{
				name: "isSequential",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "behavior",
				type: "MultiInstanceBehavior",
				"default": "All",
				isAttr: true
			},
			{
				name: "loopCardinality",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "loopDataInputRef",
				type: "ItemAwareElement",
				isReference: true
			},
			{
				name: "loopDataOutputRef",
				type: "ItemAwareElement",
				isReference: true
			},
			{
				name: "inputDataItem",
				type: "DataInput",
				xml: {
					serialize: "property"
				}
			},
			{
				name: "outputDataItem",
				type: "DataOutput",
				xml: {
					serialize: "property"
				}
			},
			{
				name: "complexBehaviorDefinition",
				type: "ComplexBehaviorDefinition",
				isMany: true
			},
			{
				name: "completionCondition",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "oneBehaviorEventRef",
				type: "EventDefinition",
				isAttr: true,
				isReference: true
			},
			{
				name: "noneBehaviorEventRef",
				type: "EventDefinition",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "StandardLoopCharacteristics",
		superClass: [
			"LoopCharacteristics"
		],
		properties: [
			{
				name: "testBefore",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "loopCondition",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "loopMaximum",
				type: "Integer",
				isAttr: true
			}
		]
	},
	{
		name: "CallActivity",
		superClass: [
			"Activity",
			"InteractionNode"
		],
		properties: [
			{
				name: "calledElement",
				type: "String",
				isAttr: true
			}
		]
	},
	{
		name: "Task",
		superClass: [
			"Activity",
			"InteractionNode"
		]
	},
	{
		name: "SendTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			},
			{
				name: "operationRef",
				type: "Operation",
				isAttr: true,
				isReference: true
			},
			{
				name: "messageRef",
				type: "Message",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ReceiveTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			},
			{
				name: "instantiate",
				"default": false,
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "operationRef",
				type: "Operation",
				isAttr: true,
				isReference: true
			},
			{
				name: "messageRef",
				type: "Message",
				isAttr: true,
				isReference: true
			}
		]
	},
	{
		name: "ScriptTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "scriptFormat",
				isAttr: true,
				type: "String"
			},
			{
				name: "script",
				type: "String"
			}
		]
	},
	{
		name: "BusinessRuleTask",
		superClass: [
			"Task"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "AdHocSubProcess",
		superClass: [
			"SubProcess"
		],
		properties: [
			{
				name: "completionCondition",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "ordering",
				type: "AdHocOrdering",
				isAttr: true
			},
			{
				name: "cancelRemainingInstances",
				"default": true,
				isAttr: true,
				type: "Boolean"
			}
		]
	},
	{
		name: "Transaction",
		superClass: [
			"SubProcess"
		],
		properties: [
			{
				name: "protocol",
				isAttr: true,
				type: "String"
			},
			{
				name: "method",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "GlobalScriptTask",
		superClass: [
			"GlobalTask"
		],
		properties: [
			{
				name: "scriptLanguage",
				isAttr: true,
				type: "String"
			},
			{
				name: "script",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "GlobalBusinessRuleTask",
		superClass: [
			"GlobalTask"
		],
		properties: [
			{
				name: "implementation",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ComplexBehaviorDefinition",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "condition",
				type: "FormalExpression"
			},
			{
				name: "event",
				type: "ImplicitThrowEvent"
			}
		]
	},
	{
		name: "ResourceRole",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "resourceRef",
				type: "Resource",
				isReference: true
			},
			{
				name: "resourceParameterBindings",
				type: "ResourceParameterBinding",
				isMany: true
			},
			{
				name: "resourceAssignmentExpression",
				type: "ResourceAssignmentExpression"
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ResourceParameterBinding",
		properties: [
			{
				name: "expression",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			},
			{
				name: "parameterRef",
				type: "ResourceParameter",
				isAttr: true,
				isReference: true
			}
		],
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "ResourceAssignmentExpression",
		properties: [
			{
				name: "expression",
				type: "Expression",
				xml: {
					serialize: "xsi:type"
				}
			}
		],
		superClass: [
			"BaseElement"
		]
	},
	{
		name: "Import",
		properties: [
			{
				name: "importType",
				isAttr: true,
				type: "String"
			},
			{
				name: "location",
				isAttr: true,
				type: "String"
			},
			{
				name: "namespace",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "Definitions",
		superClass: [
			"BaseElement"
		],
		properties: [
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "targetNamespace",
				isAttr: true,
				type: "String"
			},
			{
				name: "expressionLanguage",
				"default": "http://www.w3.org/1999/XPath",
				isAttr: true,
				type: "String"
			},
			{
				name: "typeLanguage",
				"default": "http://www.w3.org/2001/XMLSchema",
				isAttr: true,
				type: "String"
			},
			{
				name: "imports",
				type: "Import",
				isMany: true
			},
			{
				name: "extensions",
				type: "Extension",
				isMany: true
			},
			{
				name: "rootElements",
				type: "RootElement",
				isMany: true
			},
			{
				name: "diagrams",
				isMany: true,
				type: "bpmndi:BPMNDiagram"
			},
			{
				name: "exporter",
				isAttr: true,
				type: "String"
			},
			{
				name: "relationships",
				type: "Relationship",
				isMany: true
			},
			{
				name: "exporterVersion",
				isAttr: true,
				type: "String"
			}
		]
	}
];
var enumerations = [
	{
		name: "ProcessType",
		literalValues: [
			{
				name: "None"
			},
			{
				name: "Public"
			},
			{
				name: "Private"
			}
		]
	},
	{
		name: "GatewayDirection",
		literalValues: [
			{
				name: "Unspecified"
			},
			{
				name: "Converging"
			},
			{
				name: "Diverging"
			},
			{
				name: "Mixed"
			}
		]
	},
	{
		name: "EventBasedGatewayType",
		literalValues: [
			{
				name: "Parallel"
			},
			{
				name: "Exclusive"
			}
		]
	},
	{
		name: "RelationshipDirection",
		literalValues: [
			{
				name: "None"
			},
			{
				name: "Forward"
			},
			{
				name: "Backward"
			},
			{
				name: "Both"
			}
		]
	},
	{
		name: "ItemKind",
		literalValues: [
			{
				name: "Physical"
			},
			{
				name: "Information"
			}
		]
	},
	{
		name: "ChoreographyLoopType",
		literalValues: [
			{
				name: "None"
			},
			{
				name: "Standard"
			},
			{
				name: "MultiInstanceSequential"
			},
			{
				name: "MultiInstanceParallel"
			}
		]
	},
	{
		name: "AssociationDirection",
		literalValues: [
			{
				name: "None"
			},
			{
				name: "One"
			},
			{
				name: "Both"
			}
		]
	},
	{
		name: "MultiInstanceBehavior",
		literalValues: [
			{
				name: "None"
			},
			{
				name: "One"
			},
			{
				name: "All"
			},
			{
				name: "Complex"
			}
		]
	},
	{
		name: "AdHocOrdering",
		literalValues: [
			{
				name: "Parallel"
			},
			{
				name: "Sequential"
			}
		]
	}
];
var xml = {
	tagAlias: "lowerCase",
	typePrefix: "t"
};
var BpmnPackage = {
	name: name,
	uri: uri,
	prefix: prefix,
	associations: associations,
	types: types,
	enumerations: enumerations,
	xml: xml
};

var name$1 = "BPMNDI";
var uri$1 = "http://www.omg.org/spec/BPMN/20100524/DI";
var prefix$1 = "bpmndi";
var types$1 = [
	{
		name: "BPMNDiagram",
		properties: [
			{
				name: "plane",
				type: "BPMNPlane",
				redefines: "di:Diagram#rootElement"
			},
			{
				name: "labelStyle",
				type: "BPMNLabelStyle",
				isMany: true
			}
		],
		superClass: [
			"di:Diagram"
		]
	},
	{
		name: "BPMNPlane",
		properties: [
			{
				name: "bpmnElement",
				isAttr: true,
				isReference: true,
				type: "bpmn:BaseElement",
				redefines: "di:DiagramElement#modelElement"
			}
		],
		superClass: [
			"di:Plane"
		]
	},
	{
		name: "BPMNShape",
		properties: [
			{
				name: "bpmnElement",
				isAttr: true,
				isReference: true,
				type: "bpmn:BaseElement",
				redefines: "di:DiagramElement#modelElement"
			},
			{
				name: "isHorizontal",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "isExpanded",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "isMarkerVisible",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "label",
				type: "BPMNLabel"
			},
			{
				name: "isMessageVisible",
				isAttr: true,
				type: "Boolean"
			},
			{
				name: "participantBandKind",
				type: "ParticipantBandKind",
				isAttr: true
			},
			{
				name: "choreographyActivityShape",
				type: "BPMNShape",
				isAttr: true,
				isReference: true
			}
		],
		superClass: [
			"di:LabeledShape"
		]
	},
	{
		name: "BPMNEdge",
		properties: [
			{
				name: "label",
				type: "BPMNLabel"
			},
			{
				name: "bpmnElement",
				isAttr: true,
				isReference: true,
				type: "bpmn:BaseElement",
				redefines: "di:DiagramElement#modelElement"
			},
			{
				name: "sourceElement",
				isAttr: true,
				isReference: true,
				type: "di:DiagramElement",
				redefines: "di:Edge#source"
			},
			{
				name: "targetElement",
				isAttr: true,
				isReference: true,
				type: "di:DiagramElement",
				redefines: "di:Edge#target"
			},
			{
				name: "messageVisibleKind",
				type: "MessageVisibleKind",
				isAttr: true,
				"default": "initiating"
			}
		],
		superClass: [
			"di:LabeledEdge"
		]
	},
	{
		name: "BPMNLabel",
		properties: [
			{
				name: "labelStyle",
				type: "BPMNLabelStyle",
				isAttr: true,
				isReference: true,
				redefines: "di:DiagramElement#style"
			}
		],
		superClass: [
			"di:Label"
		]
	},
	{
		name: "BPMNLabelStyle",
		properties: [
			{
				name: "font",
				type: "dc:Font"
			}
		],
		superClass: [
			"di:Style"
		]
	}
];
var enumerations$1 = [
	{
		name: "ParticipantBandKind",
		literalValues: [
			{
				name: "top_initiating"
			},
			{
				name: "middle_initiating"
			},
			{
				name: "bottom_initiating"
			},
			{
				name: "top_non_initiating"
			},
			{
				name: "middle_non_initiating"
			},
			{
				name: "bottom_non_initiating"
			}
		]
	},
	{
		name: "MessageVisibleKind",
		literalValues: [
			{
				name: "initiating"
			},
			{
				name: "non_initiating"
			}
		]
	}
];
var associations$1 = [
];
var BpmnDiPackage = {
	name: name$1,
	uri: uri$1,
	prefix: prefix$1,
	types: types$1,
	enumerations: enumerations$1,
	associations: associations$1
};

var name$2 = "DC";
var uri$2 = "http://www.omg.org/spec/DD/20100524/DC";
var prefix$2 = "dc";
var types$2 = [
	{
		name: "Boolean"
	},
	{
		name: "Integer"
	},
	{
		name: "Real"
	},
	{
		name: "String"
	},
	{
		name: "Font",
		properties: [
			{
				name: "name",
				type: "String",
				isAttr: true
			},
			{
				name: "size",
				type: "Real",
				isAttr: true
			},
			{
				name: "isBold",
				type: "Boolean",
				isAttr: true
			},
			{
				name: "isItalic",
				type: "Boolean",
				isAttr: true
			},
			{
				name: "isUnderline",
				type: "Boolean",
				isAttr: true
			},
			{
				name: "isStrikeThrough",
				type: "Boolean",
				isAttr: true
			}
		]
	},
	{
		name: "Point",
		properties: [
			{
				name: "x",
				type: "Real",
				"default": "0",
				isAttr: true
			},
			{
				name: "y",
				type: "Real",
				"default": "0",
				isAttr: true
			}
		]
	},
	{
		name: "Bounds",
		properties: [
			{
				name: "x",
				type: "Real",
				"default": "0",
				isAttr: true
			},
			{
				name: "y",
				type: "Real",
				"default": "0",
				isAttr: true
			},
			{
				name: "width",
				type: "Real",
				isAttr: true
			},
			{
				name: "height",
				type: "Real",
				isAttr: true
			}
		]
	}
];
var associations$2 = [
];
var DcPackage = {
	name: name$2,
	uri: uri$2,
	prefix: prefix$2,
	types: types$2,
	associations: associations$2
};

var name$3 = "DI";
var uri$3 = "http://www.omg.org/spec/DD/20100524/DI";
var prefix$3 = "di";
var types$3 = [
	{
		name: "DiagramElement",
		isAbstract: true,
		properties: [
			{
				name: "id",
				isAttr: true,
				isId: true,
				type: "String"
			},
			{
				name: "extension",
				type: "Extension"
			},
			{
				name: "owningDiagram",
				type: "Diagram",
				isReadOnly: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "owningElement",
				type: "DiagramElement",
				isReadOnly: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "modelElement",
				isReadOnly: true,
				isVirtual: true,
				isReference: true,
				type: "Element"
			},
			{
				name: "style",
				type: "Style",
				isReadOnly: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "ownedElement",
				type: "DiagramElement",
				isReadOnly: true,
				isMany: true,
				isVirtual: true
			}
		]
	},
	{
		name: "Node",
		isAbstract: true,
		superClass: [
			"DiagramElement"
		]
	},
	{
		name: "Edge",
		isAbstract: true,
		superClass: [
			"DiagramElement"
		],
		properties: [
			{
				name: "source",
				type: "DiagramElement",
				isReadOnly: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "target",
				type: "DiagramElement",
				isReadOnly: true,
				isVirtual: true,
				isReference: true
			},
			{
				name: "waypoint",
				isUnique: false,
				isMany: true,
				type: "dc:Point",
				xml: {
					serialize: "xsi:type"
				}
			}
		]
	},
	{
		name: "Diagram",
		isAbstract: true,
		properties: [
			{
				name: "id",
				isAttr: true,
				isId: true,
				type: "String"
			},
			{
				name: "rootElement",
				type: "DiagramElement",
				isReadOnly: true,
				isVirtual: true
			},
			{
				name: "name",
				isAttr: true,
				type: "String"
			},
			{
				name: "documentation",
				isAttr: true,
				type: "String"
			},
			{
				name: "resolution",
				isAttr: true,
				type: "Real"
			},
			{
				name: "ownedStyle",
				type: "Style",
				isReadOnly: true,
				isMany: true,
				isVirtual: true
			}
		]
	},
	{
		name: "Shape",
		isAbstract: true,
		superClass: [
			"Node"
		],
		properties: [
			{
				name: "bounds",
				type: "dc:Bounds"
			}
		]
	},
	{
		name: "Plane",
		isAbstract: true,
		superClass: [
			"Node"
		],
		properties: [
			{
				name: "planeElement",
				type: "DiagramElement",
				subsettedProperty: "DiagramElement-ownedElement",
				isMany: true
			}
		]
	},
	{
		name: "LabeledEdge",
		isAbstract: true,
		superClass: [
			"Edge"
		],
		properties: [
			{
				name: "ownedLabel",
				type: "Label",
				isReadOnly: true,
				subsettedProperty: "DiagramElement-ownedElement",
				isMany: true,
				isVirtual: true
			}
		]
	},
	{
		name: "LabeledShape",
		isAbstract: true,
		superClass: [
			"Shape"
		],
		properties: [
			{
				name: "ownedLabel",
				type: "Label",
				isReadOnly: true,
				subsettedProperty: "DiagramElement-ownedElement",
				isMany: true,
				isVirtual: true
			}
		]
	},
	{
		name: "Label",
		isAbstract: true,
		superClass: [
			"Node"
		],
		properties: [
			{
				name: "bounds",
				type: "dc:Bounds"
			}
		]
	},
	{
		name: "Style",
		isAbstract: true,
		properties: [
			{
				name: "id",
				isAttr: true,
				isId: true,
				type: "String"
			}
		]
	},
	{
		name: "Extension",
		properties: [
			{
				name: "values",
				isMany: true,
				type: "Element"
			}
		]
	}
];
var associations$3 = [
];
var xml$1 = {
	tagAlias: "lowerCase"
};
var DiPackage = {
	name: name$3,
	uri: uri$3,
	prefix: prefix$3,
	types: types$3,
	associations: associations$3,
	xml: xml$1
};

var name$4 = "bpmn.io colors for BPMN";
var uri$4 = "http://bpmn.io/schema/bpmn/biocolor/1.0";
var prefix$4 = "bioc";
var types$4 = [
	{
		name: "ColoredShape",
		"extends": [
			"bpmndi:BPMNShape"
		],
		properties: [
			{
				name: "stroke",
				isAttr: true,
				type: "String"
			},
			{
				name: "fill",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ColoredEdge",
		"extends": [
			"bpmndi:BPMNEdge"
		],
		properties: [
			{
				name: "stroke",
				isAttr: true,
				type: "String"
			},
			{
				name: "fill",
				isAttr: true,
				type: "String"
			}
		]
	}
];
var enumerations$2 = [
];
var associations$4 = [
];
var BiocPackage = {
	name: name$4,
	uri: uri$4,
	prefix: prefix$4,
	types: types$4,
	enumerations: enumerations$2,
	associations: associations$4
};

var name$5 = "BPMN in Color";
var uri$5 = "http://www.omg.org/spec/BPMN/non-normative/color/1.0";
var prefix$5 = "color";
var types$5 = [
	{
		name: "ColoredLabel",
		"extends": [
			"bpmndi:BPMNLabel"
		],
		properties: [
			{
				name: "color",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ColoredShape",
		"extends": [
			"bpmndi:BPMNShape"
		],
		properties: [
			{
				name: "background-color",
				isAttr: true,
				type: "String"
			},
			{
				name: "border-color",
				isAttr: true,
				type: "String"
			}
		]
	},
	{
		name: "ColoredEdge",
		"extends": [
			"bpmndi:BPMNEdge"
		],
		properties: [
			{
				name: "border-color",
				isAttr: true,
				type: "String"
			}
		]
	}
];
var enumerations$3 = [
];
var associations$5 = [
];
var BpmnInColorPackage = {
	name: name$5,
	uri: uri$5,
	prefix: prefix$5,
	types: types$5,
	enumerations: enumerations$3,
	associations: associations$5
};

var packages = {
  bpmn: BpmnPackage,
  bpmndi: BpmnDiPackage,
  dc: DcPackage,
  di: DiPackage,
  bioc: BiocPackage,
  color: BpmnInColorPackage
};

function simple(additionalPackages, options) {
  var pks = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, packages, additionalPackages);

  return new BpmnModdle(pks, options);
}

/* harmony default export */ __webpack_exports__["default"] = (simple);


/***/ }),

/***/ "./node_modules/diagram-js/index.js":
/*!******************************************!*\
  !*** ./node_modules/diagram-js/index.js ***!
  \******************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _lib_Diagram__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./lib/Diagram */ "./node_modules/diagram-js/lib/Diagram.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "default", function() { return _lib_Diagram__WEBPACK_IMPORTED_MODULE_0__["default"]; });



/***/ }),

/***/ "./node_modules/diagram-js/lib/Diagram.js":
/*!************************************************!*\
  !*** ./node_modules/diagram-js/lib/Diagram.js ***!
  \************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Diagram; });
/* harmony import */ var didi__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! didi */ "./node_modules/didi/dist/index.esm.js");
/* harmony import */ var _core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./core */ "./node_modules/diagram-js/lib/core/index.js");





/**
 * Bootstrap an injector from a list of modules, instantiating a number of default components
 *
 * @ignore
 * @param {Array<didi.Module>} bootstrapModules
 *
 * @return {didi.Injector} a injector to use to access the components
 */
function bootstrap(bootstrapModules) {

  var modules = [],
      components = [];

  function hasModule(m) {
    return modules.indexOf(m) >= 0;
  }

  function addModule(m) {
    modules.push(m);
  }

  function visit(m) {
    if (hasModule(m)) {
      return;
    }

    (m.__depends__ || []).forEach(visit);

    if (hasModule(m)) {
      return;
    }

    addModule(m);

    (m.__init__ || []).forEach(function(c) {
      components.push(c);
    });
  }

  bootstrapModules.forEach(visit);

  var injector = new didi__WEBPACK_IMPORTED_MODULE_0__["Injector"](modules);

  components.forEach(function(c) {

    try {

      // eagerly resolve component (fn or string)
      injector[typeof c === 'string' ? 'get' : 'invoke'](c);
    } catch (e) {
      console.error('Failed to instantiate component');
      console.error(e.stack);

      throw e;
    }
  });

  return injector;
}

/**
 * Creates an injector from passed options.
 *
 * @ignore
 * @param  {Object} options
 * @return {didi.Injector}
 */
function createInjector(options) {

  options = options || {};

  var configModule = {
    'config': ['value', options]
  };

  var modules = [ configModule, _core__WEBPACK_IMPORTED_MODULE_1__["default"] ].concat(options.modules || []);

  return bootstrap(modules);
}


/**
 * The main diagram-js entry point that bootstraps the diagram with the given
 * configuration.
 *
 * To register extensions with the diagram, pass them as Array<didi.Module> to the constructor.
 *
 * @class djs.Diagram
 * @memberOf djs
 * @constructor
 *
 * @example
 *
 * <caption>Creating a plug-in that logs whenever a shape is added to the canvas.</caption>
 *
 * // plug-in implemenentation
 * function MyLoggingPlugin(eventBus) {
 *   eventBus.on('shape.added', function(event) {
 *     console.log('shape ', event.shape, ' was added to the diagram');
 *   });
 * }
 *
 * // export as module
 * export default {
 *   __init__: [ 'myLoggingPlugin' ],
 *     myLoggingPlugin: [ 'type', MyLoggingPlugin ]
 * };
 *
 *
 * // instantiate the diagram with the new plug-in
 *
 * import MyLoggingModule from 'path-to-my-logging-plugin';
 *
 * var diagram = new Diagram({
 *   modules: [
 *     MyLoggingModule
 *   ]
 * });
 *
 * diagram.invoke([ 'canvas', function(canvas) {
 *   // add shape to drawing canvas
 *   canvas.addShape({ x: 10, y: 10 });
 * });
 *
 * // 'shape ... was added to the diagram' logged to console
 *
 * @param {Object} options
 * @param {Array<didi.Module>} [options.modules] external modules to instantiate with the diagram
 * @param {didi.Injector} [injector] an (optional) injector to bootstrap the diagram with
 */
function Diagram(options, injector) {

  // create injector unless explicitly specified
  this.injector = injector = injector || createInjector(options);

  // API

  /**
   * Resolves a diagram service
   *
   * @method Diagram#get
   *
   * @param {string} name the name of the diagram service to be retrieved
   * @param {boolean} [strict=true] if false, resolve missing services to null
   */
  this.get = injector.get;

  /**
   * Executes a function into which diagram services are injected
   *
   * @method Diagram#invoke
   *
   * @param {Function|Object[]} fn the function to resolve
   * @param {Object} locals a number of locals to use to resolve certain dependencies
   */
  this.invoke = injector.invoke;

  // init

  // indicate via event


  /**
   * An event indicating that all plug-ins are loaded.
   *
   * Use this event to fire other events to interested plug-ins
   *
   * @memberOf Diagram
   *
   * @event diagram.init
   *
   * @example
   *
   * eventBus.on('diagram.init', function() {
   *   eventBus.fire('my-custom-event', { foo: 'BAR' });
   * });
   *
   * @type {Object}
   */
  this.get('eventBus').fire('diagram.init');
}


/**
 * Destroys the diagram
 *
 * @method  Diagram#destroy
 */
Diagram.prototype.destroy = function() {
  this.get('eventBus').fire('diagram.destroy');
};

/**
 * Clear the diagram, removing all contents.
 */
Diagram.prototype.clear = function() {
  this.get('eventBus').fire('diagram.clear');
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/core/Canvas.js":
/*!****************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/Canvas.js ***!
  \****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Canvas; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var _util_Collections__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../util/Collections */ "./node_modules/diagram-js/lib/util/Collections.js");
/* harmony import */ var _util_Elements__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../util/Elements */ "./node_modules/diagram-js/lib/util/Elements.js");
/* harmony import */ var _layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../layout/LayoutUtil */ "./node_modules/diagram-js/lib/layout/LayoutUtil.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");













function round(number, resolution) {
  return Math.round(number * resolution) / resolution;
}

function ensurePx(number) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(number) ? number + 'px' : number;
}

/**
 * Creates a HTML container element for a SVG element with
 * the given configuration
 *
 * @param  {Object} options
 * @return {HTMLElement} the container element
 */
function createContainer(options) {

  options = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, { width: '100%', height: '100%' }, options);

  var container = options.container || document.body;

  // create a <div> around the svg element with the respective size
  // this way we can always get the correct container size
  // (this is impossible for <svg> elements at the moment)
  var parent = document.createElement('div');
  parent.setAttribute('class', 'djs-container');

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(parent.style, {
    position: 'relative',
    overflow: 'hidden',
    width: ensurePx(options.width),
    height: ensurePx(options.height)
  });

  container.appendChild(parent);

  return parent;
}

function createGroup(parent, cls, childIndex) {
  var group = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('g');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(group).add(cls);

  var index = childIndex !== undefined ? childIndex : parent.childNodes.length - 1;

  // must ensure second argument is node or _null_
  // cf. https://developer.mozilla.org/en-US/docs/Web/API/Node/insertBefore
  parent.insertBefore(group, parent.childNodes[index] || null);

  return group;
}

var BASE_LAYER = 'base';


var REQUIRED_MODEL_ATTRS = {
  shape: [ 'x', 'y', 'width', 'height' ],
  connection: [ 'waypoints' ]
};

/**
 * The main drawing canvas.
 *
 * @class
 * @constructor
 *
 * @emits Canvas#canvas.init
 *
 * @param {Object} config
 * @param {EventBus} eventBus
 * @param {GraphicsFactory} graphicsFactory
 * @param {ElementRegistry} elementRegistry
 */
function Canvas(config, eventBus, graphicsFactory, elementRegistry) {

  this._eventBus = eventBus;
  this._elementRegistry = elementRegistry;
  this._graphicsFactory = graphicsFactory;

  this._init(config || {});
}

Canvas.$inject = [
  'config.canvas',
  'eventBus',
  'graphicsFactory',
  'elementRegistry'
];


Canvas.prototype._init = function(config) {

  var eventBus = this._eventBus;

  // Creates a <svg> element that is wrapped into a <div>.
  // This way we are always able to correctly figure out the size of the svg element
  // by querying the parent node.
  //
  // (It is not possible to get the size of a svg element cross browser @ 2014-04-01)
  //
  // <div class="djs-container" style="width: {desired-width}, height: {desired-height}">
  //   <svg width="100%" height="100%">
  //    ...
  //   </svg>
  // </div>

  // html container
  var container = this._container = createContainer(config);

  var svg = this._svg = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('svg');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["attr"])(svg, { width: '100%', height: '100%' });

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["append"])(container, svg);

  var viewport = this._viewport = createGroup(svg, 'viewport');

  this._layers = {};

  // debounce canvas.viewbox.changed events
  // for smoother diagram interaction
  if (config.deferUpdate !== false) {
    this._viewboxChanged = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["debounce"])(Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(this._viewboxChanged, this), 300);
  }

  eventBus.on('diagram.init', function() {

    /**
     * An event indicating that the canvas is ready to be drawn on.
     *
     * @memberOf Canvas
     *
     * @event canvas.init
     *
     * @type {Object}
     * @property {SVGElement} svg the created svg element
     * @property {SVGElement} viewport the direct parent of diagram elements and shapes
     */
    eventBus.fire('canvas.init', {
      svg: svg,
      viewport: viewport
    });

  }, this);

  // reset viewbox on shape changes to
  // recompute the viewbox
  eventBus.on([
    'shape.added',
    'connection.added',
    'shape.removed',
    'connection.removed',
    'elements.changed'
  ], function() {
    delete this._cachedViewbox;
  }, this);

  eventBus.on('diagram.destroy', 500, this._destroy, this);
  eventBus.on('diagram.clear', 500, this._clear, this);
};

Canvas.prototype._destroy = function(emit) {
  this._eventBus.fire('canvas.destroy', {
    svg: this._svg,
    viewport: this._viewport
  });

  var parent = this._container.parentNode;

  if (parent) {
    parent.removeChild(this._container);
  }

  delete this._svg;
  delete this._container;
  delete this._layers;
  delete this._rootElement;
  delete this._viewport;
};

Canvas.prototype._clear = function() {

  var self = this;

  var allElements = this._elementRegistry.getAll();

  // remove all elements
  allElements.forEach(function(element) {
    var type = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_2__["getType"])(element);

    if (type === 'root') {
      self.setRootElement(null, true);
    } else {
      self._removeElement(element, type);
    }
  });

  // force recomputation of view box
  delete this._cachedViewbox;
};

/**
 * Returns the default layer on which
 * all elements are drawn.
 *
 * @returns {SVGElement}
 */
Canvas.prototype.getDefaultLayer = function() {
  return this.getLayer(BASE_LAYER, 0);
};

/**
 * Returns a layer that is used to draw elements
 * or annotations on it.
 *
 * Non-existing layers retrieved through this method
 * will be created. During creation, the optional index
 * may be used to create layers below or above existing layers.
 * A layer with a certain index is always created above all
 * existing layers with the same index.
 *
 * @param {string} name
 * @param {number} index
 *
 * @returns {SVGElement}
 */
Canvas.prototype.getLayer = function(name, index) {

  if (!name) {
    throw new Error('must specify a name');
  }

  var layer = this._layers[name];

  if (!layer) {
    layer = this._layers[name] = this._createLayer(name, index);
  }

  // throw an error if layer creation / retrival is
  // requested on different index
  if (typeof index !== 'undefined' && layer.index !== index) {
    throw new Error('layer <' + name + '> already created at index <' + index + '>');
  }

  return layer.group;
};

/**
 * Creates a given layer and returns it.
 *
 * @param {string} name
 * @param {number} [index=0]
 *
 * @return {Object} layer descriptor with { index, group: SVGGroup }
 */
Canvas.prototype._createLayer = function(name, index) {

  if (!index) {
    index = 0;
  }

  var childIndex = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["reduce"])(this._layers, function(childIndex, layer) {
    if (index >= layer.index) {
      childIndex++;
    }

    return childIndex;
  }, 0);

  return {
    group: createGroup(this._viewport, 'layer-' + name, childIndex),
    index: index
  };

};

/**
 * Returns the html element that encloses the
 * drawing canvas.
 *
 * @return {DOMNode}
 */
Canvas.prototype.getContainer = function() {
  return this._container;
};


// markers //////////////////////

Canvas.prototype._updateMarker = function(element, marker, add) {
  var container;

  if (!element.id) {
    element = this._elementRegistry.get(element);
  }

  // we need to access all
  container = this._elementRegistry._elements[element.id];

  if (!container) {
    return;
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])([ container.gfx, container.secondaryGfx ], function(gfx) {
    if (gfx) {

      // invoke either addClass or removeClass based on mode
      if (add) {
        Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).add(marker);
      } else {
        Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).remove(marker);
      }
    }
  });

  /**
   * An event indicating that a marker has been updated for an element
   *
   * @event element.marker.update
   * @type {Object}
   * @property {djs.model.Element} element the shape
   * @property {Object} gfx the graphical representation of the shape
   * @property {string} marker
   * @property {boolean} add true if the marker was added, false if it got removed
   */
  this._eventBus.fire('element.marker.update', { element: element, gfx: container.gfx, marker: marker, add: !!add });
};


/**
 * Adds a marker to an element (basically a css class).
 *
 * Fires the element.marker.update event, making it possible to
 * integrate extension into the marker life-cycle, too.
 *
 * @example
 * canvas.addMarker('foo', 'some-marker');
 *
 * var fooGfx = canvas.getGraphics('foo');
 *
 * fooGfx; // <g class="... some-marker"> ... </g>
 *
 * @param {string|djs.model.Base} element
 * @param {string} marker
 */
Canvas.prototype.addMarker = function(element, marker) {
  this._updateMarker(element, marker, true);
};


/**
 * Remove a marker from an element.
 *
 * Fires the element.marker.update event, making it possible to
 * integrate extension into the marker life-cycle, too.
 *
 * @param  {string|djs.model.Base} element
 * @param  {string} marker
 */
Canvas.prototype.removeMarker = function(element, marker) {
  this._updateMarker(element, marker, false);
};

/**
 * Check the existence of a marker on element.
 *
 * @param  {string|djs.model.Base} element
 * @param  {string} marker
 */
Canvas.prototype.hasMarker = function(element, marker) {
  if (!element.id) {
    element = this._elementRegistry.get(element);
  }

  var gfx = this.getGraphics(element);

  return Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).has(marker);
};

/**
 * Toggles a marker on an element.
 *
 * Fires the element.marker.update event, making it possible to
 * integrate extension into the marker life-cycle, too.
 *
 * @param  {string|djs.model.Base} element
 * @param  {string} marker
 */
Canvas.prototype.toggleMarker = function(element, marker) {
  if (this.hasMarker(element, marker)) {
    this.removeMarker(element, marker);
  } else {
    this.addMarker(element, marker);
  }
};

Canvas.prototype.getRootElement = function() {
  if (!this._rootElement) {
    this.setRootElement({ id: '__implicitroot', children: [] });
  }

  return this._rootElement;
};



// root element handling //////////////////////

/**
 * Sets a given element as the new root element for the canvas
 * and returns the new root element.
 *
 * @param {Object|djs.model.Root} element
 * @param {boolean} [override] whether to override the current root element, if any
 *
 * @return {Object|djs.model.Root} new root element
 */
Canvas.prototype.setRootElement = function(element, override) {

  if (element) {
    this._ensureValid('root', element);
  }

  var currentRoot = this._rootElement,
      elementRegistry = this._elementRegistry,
      eventBus = this._eventBus;

  if (currentRoot) {
    if (!override) {
      throw new Error('rootElement already set, need to specify override');
    }

    // simulate element remove event sequence
    eventBus.fire('root.remove', { element: currentRoot });
    eventBus.fire('root.removed', { element: currentRoot });

    elementRegistry.remove(currentRoot);
  }

  if (element) {
    var gfx = this.getDefaultLayer();

    // resemble element add event sequence
    eventBus.fire('root.add', { element: element });

    elementRegistry.add(element, gfx, this._svg);

    eventBus.fire('root.added', { element: element, gfx: gfx });
  }

  this._rootElement = element;

  return element;
};



// add functionality //////////////////////

Canvas.prototype._ensureValid = function(type, element) {
  if (!element.id) {
    throw new Error('element must have an id');
  }

  if (this._elementRegistry.get(element.id)) {
    throw new Error('element with id ' + element.id + ' already exists');
  }

  var requiredAttrs = REQUIRED_MODEL_ATTRS[type];

  var valid = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["every"])(requiredAttrs, function(attr) {
    return typeof element[attr] !== 'undefined';
  });

  if (!valid) {
    throw new Error(
      'must supply { ' + requiredAttrs.join(', ') + ' } with ' + type);
  }
};

Canvas.prototype._setParent = function(element, parent, parentIndex) {
  Object(_util_Collections__WEBPACK_IMPORTED_MODULE_1__["add"])(parent.children, element, parentIndex);
  element.parent = parent;
};

/**
 * Adds an element to the canvas.
 *
 * This wires the parent <-> child relationship between the element and
 * a explicitly specified parent or an implicit root element.
 *
 * During add it emits the events
 *
 *  * <{type}.add> (element, parent)
 *  * <{type}.added> (element, gfx)
 *
 * Extensions may hook into these events to perform their magic.
 *
 * @param {string} type
 * @param {Object|djs.model.Base} element
 * @param {Object|djs.model.Base} [parent]
 * @param {number} [parentIndex]
 *
 * @return {Object|djs.model.Base} the added element
 */
Canvas.prototype._addElement = function(type, element, parent, parentIndex) {

  parent = parent || this.getRootElement();

  var eventBus = this._eventBus,
      graphicsFactory = this._graphicsFactory;

  this._ensureValid(type, element);

  eventBus.fire(type + '.add', { element: element, parent: parent });

  this._setParent(element, parent, parentIndex);

  // create graphics
  var gfx = graphicsFactory.create(type, element, parentIndex);

  this._elementRegistry.add(element, gfx);

  // update its visual
  graphicsFactory.update(type, element, gfx);

  eventBus.fire(type + '.added', { element: element, gfx: gfx });

  return element;
};

/**
 * Adds a shape to the canvas
 *
 * @param {Object|djs.model.Shape} shape to add to the diagram
 * @param {djs.model.Base} [parent]
 * @param {number} [parentIndex]
 *
 * @return {djs.model.Shape} the added shape
 */
Canvas.prototype.addShape = function(shape, parent, parentIndex) {
  return this._addElement('shape', shape, parent, parentIndex);
};

/**
 * Adds a connection to the canvas
 *
 * @param {Object|djs.model.Connection} connection to add to the diagram
 * @param {djs.model.Base} [parent]
 * @param {number} [parentIndex]
 *
 * @return {djs.model.Connection} the added connection
 */
Canvas.prototype.addConnection = function(connection, parent, parentIndex) {
  return this._addElement('connection', connection, parent, parentIndex);
};


/**
 * Internal remove element
 */
Canvas.prototype._removeElement = function(element, type) {

  var elementRegistry = this._elementRegistry,
      graphicsFactory = this._graphicsFactory,
      eventBus = this._eventBus;

  element = elementRegistry.get(element.id || element);

  if (!element) {

    // element was removed already
    return;
  }

  eventBus.fire(type + '.remove', { element: element });

  graphicsFactory.remove(element);

  // unset parent <-> child relationship
  Object(_util_Collections__WEBPACK_IMPORTED_MODULE_1__["remove"])(element.parent && element.parent.children, element);
  element.parent = null;

  eventBus.fire(type + '.removed', { element: element });

  elementRegistry.remove(element);

  return element;
};


/**
 * Removes a shape from the canvas
 *
 * @param {string|djs.model.Shape} shape or shape id to be removed
 *
 * @return {djs.model.Shape} the removed shape
 */
Canvas.prototype.removeShape = function(shape) {

  /**
   * An event indicating that a shape is about to be removed from the canvas.
   *
   * @memberOf Canvas
   *
   * @event shape.remove
   * @type {Object}
   * @property {djs.model.Shape} element the shape descriptor
   * @property {Object} gfx the graphical representation of the shape
   */

  /**
   * An event indicating that a shape has been removed from the canvas.
   *
   * @memberOf Canvas
   *
   * @event shape.removed
   * @type {Object}
   * @property {djs.model.Shape} element the shape descriptor
   * @property {Object} gfx the graphical representation of the shape
   */
  return this._removeElement(shape, 'shape');
};


/**
 * Removes a connection from the canvas
 *
 * @param {string|djs.model.Connection} connection or connection id to be removed
 *
 * @return {djs.model.Connection} the removed connection
 */
Canvas.prototype.removeConnection = function(connection) {

  /**
   * An event indicating that a connection is about to be removed from the canvas.
   *
   * @memberOf Canvas
   *
   * @event connection.remove
   * @type {Object}
   * @property {djs.model.Connection} element the connection descriptor
   * @property {Object} gfx the graphical representation of the connection
   */

  /**
   * An event indicating that a connection has been removed from the canvas.
   *
   * @memberOf Canvas
   *
   * @event connection.removed
   * @type {Object}
   * @property {djs.model.Connection} element the connection descriptor
   * @property {Object} gfx the graphical representation of the connection
   */
  return this._removeElement(connection, 'connection');
};


/**
 * Return the graphical object underlaying a certain diagram element
 *
 * @param {string|djs.model.Base} element descriptor of the element
 * @param {boolean} [secondary=false] whether to return the secondary connected element
 *
 * @return {SVGElement}
 */
Canvas.prototype.getGraphics = function(element, secondary) {
  return this._elementRegistry.getGraphics(element, secondary);
};


/**
 * Perform a viewbox update via a given change function.
 *
 * @param {Function} changeFn
 */
Canvas.prototype._changeViewbox = function(changeFn) {

  // notify others of the upcoming viewbox change
  this._eventBus.fire('canvas.viewbox.changing');

  // perform actual change
  changeFn.apply(this);

  // reset the cached viewbox so that
  // a new get operation on viewbox or zoom
  // triggers a viewbox re-computation
  this._cachedViewbox = null;

  // notify others of the change; this step
  // may or may not be debounced
  this._viewboxChanged();
};

Canvas.prototype._viewboxChanged = function() {
  this._eventBus.fire('canvas.viewbox.changed', { viewbox: this.viewbox() });
};


/**
 * Gets or sets the view box of the canvas, i.e. the
 * area that is currently displayed.
 *
 * The getter may return a cached viewbox (if it is currently
 * changing). To force a recomputation, pass `false` as the first argument.
 *
 * @example
 *
 * canvas.viewbox({ x: 100, y: 100, width: 500, height: 500 })
 *
 * // sets the visible area of the diagram to (100|100) -> (600|100)
 * // and and scales it according to the diagram width
 *
 * var viewbox = canvas.viewbox(); // pass `false` to force recomputing the box.
 *
 * console.log(viewbox);
 * // {
 * //   inner: Dimensions,
 * //   outer: Dimensions,
 * //   scale,
 * //   x, y,
 * //   width, height
 * // }
 *
 * // if the current diagram is zoomed and scrolled, you may reset it to the
 * // default zoom via this method, too:
 *
 * var zoomedAndScrolledViewbox = canvas.viewbox();
 *
 * canvas.viewbox({
 *   x: 0,
 *   y: 0,
 *   width: zoomedAndScrolledViewbox.outer.width,
 *   height: zoomedAndScrolledViewbox.outer.height
 * });
 *
 * @param  {Object} [box] the new view box to set
 * @param  {number} box.x the top left X coordinate of the canvas visible in view box
 * @param  {number} box.y the top left Y coordinate of the canvas visible in view box
 * @param  {number} box.width the visible width
 * @param  {number} box.height
 *
 * @return {Object} the current view box
 */
Canvas.prototype.viewbox = function(box) {

  if (box === undefined && this._cachedViewbox) {
    return this._cachedViewbox;
  }

  var viewport = this._viewport,
      innerBox,
      outerBox = this.getSize(),
      matrix,
      transform,
      scale,
      x, y;

  if (!box) {

    // compute the inner box based on the
    // diagrams default layer. This allows us to exclude
    // external components, such as overlays
    innerBox = this.getDefaultLayer().getBBox();

    transform = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["transform"])(viewport);
    matrix = transform ? transform.matrix : Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["createMatrix"])();
    scale = round(matrix.a, 1000);

    x = round(-matrix.e || 0, 1000);
    y = round(-matrix.f || 0, 1000);

    box = this._cachedViewbox = {
      x: x ? x / scale : 0,
      y: y ? y / scale : 0,
      width: outerBox.width / scale,
      height: outerBox.height / scale,
      scale: scale,
      inner: {
        width: innerBox.width,
        height: innerBox.height,
        x: innerBox.x,
        y: innerBox.y
      },
      outer: outerBox
    };

    return box;
  } else {

    this._changeViewbox(function() {
      scale = Math.min(outerBox.width / box.width, outerBox.height / box.height);

      var matrix = this._svg.createSVGMatrix()
        .scale(scale)
        .translate(-box.x, -box.y);

      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["transform"])(viewport, matrix);
    });
  }

  return box;
};


/**
 * Gets or sets the scroll of the canvas.
 *
 * @param {Object} [delta] the new scroll to apply.
 *
 * @param {number} [delta.dx]
 * @param {number} [delta.dy]
 */
Canvas.prototype.scroll = function(delta) {

  var node = this._viewport;
  var matrix = node.getCTM();

  if (delta) {
    this._changeViewbox(function() {
      delta = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ dx: 0, dy: 0 }, delta || {});

      matrix = this._svg.createSVGMatrix().translate(delta.dx, delta.dy).multiply(matrix);

      setCTM(node, matrix);
    });
  }

  return { x: matrix.e, y: matrix.f };
};

/**
 * Scrolls the viewbox to contain the given element.
 * Optionally specify a padding to be applied to the edges.
 *
 * @param {Object} [element] the element to scroll to.
 * @param {Object|Number} [padding=100] the padding to be applied. Can also specify top, bottom, left and right.
 *
 */
Canvas.prototype.scrollToElement = function(element, padding) {
  var defaultPadding = 100;
  if (!padding) {
    padding = {};
  }
  if (typeof padding === 'number') {
    defaultPadding = padding;
  }

  padding = {
    top: padding.top || defaultPadding,
    right: padding.right || defaultPadding,
    bottom: padding.bottom || defaultPadding,
    left: padding.left || defaultPadding
  };

  var elementBounds = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_2__["getBBox"])(element),
      elementTrbl = Object(_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__["asTRBL"])(elementBounds),
      viewboxBounds = this.viewbox(),
      zoom = this.zoom(),
      dx, dy;

  // Shrink viewboxBounds with padding
  viewboxBounds.y += padding.top / zoom;
  viewboxBounds.x += padding.left / zoom;
  viewboxBounds.width -= (padding.right + padding.left) / zoom;
  viewboxBounds.height -= (padding.bottom + padding.top) / zoom;

  var viewboxTrbl = Object(_layout_LayoutUtil__WEBPACK_IMPORTED_MODULE_3__["asTRBL"])(viewboxBounds);

  var canFit = elementBounds.width < viewboxBounds.width && elementBounds.height < viewboxBounds.height;

  if (!canFit) {

    // top-left when element can't fit
    dx = elementBounds.x - viewboxBounds.x;
    dy = elementBounds.y - viewboxBounds.y;

  } else {

    var dRight = Math.max(0, elementTrbl.right - viewboxTrbl.right),
        dLeft = Math.min(0, elementTrbl.left - viewboxTrbl.left),
        dBottom = Math.max(0, elementTrbl.bottom - viewboxTrbl.bottom),
        dTop = Math.min(0, elementTrbl.top - viewboxTrbl.top);

    dx = dRight || dLeft;
    dy = dBottom || dTop;

  }

  this.scroll({ dx: -dx * zoom, dy: -dy * zoom });
};

/**
 * Gets or sets the current zoom of the canvas, optionally zooming
 * to the specified position.
 *
 * The getter may return a cached zoom level. Call it with `false` as
 * the first argument to force recomputation of the current level.
 *
 * @param {string|number} [newScale] the new zoom level, either a number, i.e. 0.9,
 *                                   or `fit-viewport` to adjust the size to fit the current viewport
 * @param {string|Point} [center] the reference point { x: .., y: ..} to zoom to, 'auto' to zoom into mid or null
 *
 * @return {number} the current scale
 */
Canvas.prototype.zoom = function(newScale, center) {

  if (!newScale) {
    return this.viewbox(newScale).scale;
  }

  if (newScale === 'fit-viewport') {
    return this._fitViewport(center);
  }

  var outer,
      matrix;

  this._changeViewbox(function() {

    if (typeof center !== 'object') {
      outer = this.viewbox().outer;

      center = {
        x: outer.width / 2,
        y: outer.height / 2
      };
    }

    matrix = this._setZoom(newScale, center);
  });

  return round(matrix.a, 1000);
};

function setCTM(node, m) {
  var mstr = 'matrix(' + m.a + ',' + m.b + ',' + m.c + ',' + m.d + ',' + m.e + ',' + m.f + ')';
  node.setAttribute('transform', mstr);
}

Canvas.prototype._fitViewport = function(center) {

  var vbox = this.viewbox(),
      outer = vbox.outer,
      inner = vbox.inner,
      newScale,
      newViewbox;

  // display the complete diagram without zooming in.
  // instead of relying on internal zoom, we perform a
  // hard reset on the canvas viewbox to realize this
  //
  // if diagram does not need to be zoomed in, we focus it around
  // the diagram origin instead

  if (inner.x >= 0 &&
      inner.y >= 0 &&
      inner.x + inner.width <= outer.width &&
      inner.y + inner.height <= outer.height &&
      !center) {

    newViewbox = {
      x: 0,
      y: 0,
      width: Math.max(inner.width + inner.x, outer.width),
      height: Math.max(inner.height + inner.y, outer.height)
    };
  } else {

    newScale = Math.min(1, outer.width / inner.width, outer.height / inner.height);
    newViewbox = {
      x: inner.x + (center ? inner.width / 2 - outer.width / newScale / 2 : 0),
      y: inner.y + (center ? inner.height / 2 - outer.height / newScale / 2 : 0),
      width: outer.width / newScale,
      height: outer.height / newScale
    };
  }

  this.viewbox(newViewbox);

  return this.viewbox(false).scale;
};


Canvas.prototype._setZoom = function(scale, center) {

  var svg = this._svg,
      viewport = this._viewport;

  var matrix = svg.createSVGMatrix();
  var point = svg.createSVGPoint();

  var centerPoint,
      originalPoint,
      currentMatrix,
      scaleMatrix,
      newMatrix;

  currentMatrix = viewport.getCTM();

  var currentScale = currentMatrix.a;

  if (center) {
    centerPoint = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(point, center);

    // revert applied viewport transformations
    originalPoint = centerPoint.matrixTransform(currentMatrix.inverse());

    // create scale matrix
    scaleMatrix = matrix
      .translate(originalPoint.x, originalPoint.y)
      .scale(1 / currentScale * scale)
      .translate(-originalPoint.x, -originalPoint.y);

    newMatrix = currentMatrix.multiply(scaleMatrix);
  } else {
    newMatrix = matrix.scale(scale);
  }

  setCTM(this._viewport, newMatrix);

  return newMatrix;
};


/**
 * Returns the size of the canvas
 *
 * @return {Dimensions}
 */
Canvas.prototype.getSize = function() {
  return {
    width: this._container.clientWidth,
    height: this._container.clientHeight
  };
};


/**
 * Return the absolute bounding box for the given element
 *
 * The absolute bounding box may be used to display overlays in the
 * callers (browser) coordinate system rather than the zoomed in/out
 * canvas coordinates.
 *
 * @param  {ElementDescriptor} element
 * @return {Bounds} the absolute bounding box
 */
Canvas.prototype.getAbsoluteBBox = function(element) {
  var vbox = this.viewbox();
  var bbox;

  // connection
  // use svg bbox
  if (element.waypoints) {
    var gfx = this.getGraphics(element);

    bbox = gfx.getBBox();
  }

  // shapes
  // use data
  else {
    bbox = element;
  }

  var x = bbox.x * vbox.scale - vbox.x * vbox.scale;
  var y = bbox.y * vbox.scale - vbox.y * vbox.scale;

  var width = bbox.width * vbox.scale;
  var height = bbox.height * vbox.scale;

  return {
    x: x,
    y: y,
    width: width,
    height: height
  };
};

/**
 * Fires an event in order other modules can react to the
 * canvas resizing
 */
Canvas.prototype.resized = function() {

  // force recomputation of view box
  delete this._cachedViewbox;

  this._eventBus.fire('canvas.resized');
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/core/ElementFactory.js":
/*!************************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/ElementFactory.js ***!
  \************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return ElementFactory; });
/* harmony import */ var _model__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../model */ "./node_modules/diagram-js/lib/model/index.js");
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");




/**
 * A factory for diagram-js shapes
 */
function ElementFactory() {
  this._uid = 12;
}


ElementFactory.prototype.createRoot = function(attrs) {
  return this.create('root', attrs);
};

ElementFactory.prototype.createLabel = function(attrs) {
  return this.create('label', attrs);
};

ElementFactory.prototype.createShape = function(attrs) {
  return this.create('shape', attrs);
};

ElementFactory.prototype.createConnection = function(attrs) {
  return this.create('connection', attrs);
};

/**
 * Create a model element with the given type and
 * a number of pre-set attributes.
 *
 * @param  {string} type
 * @param  {Object} attrs
 * @return {djs.model.Base} the newly created model instance
 */
ElementFactory.prototype.create = function(type, attrs) {

  attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["assign"])({}, attrs || {});

  if (!attrs.id) {
    attrs.id = type + '_' + (this._uid++);
  }

  return Object(_model__WEBPACK_IMPORTED_MODULE_0__["create"])(type, attrs);
};

/***/ }),

/***/ "./node_modules/diagram-js/lib/core/ElementRegistry.js":
/*!*************************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/ElementRegistry.js ***!
  \*************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return ElementRegistry; });
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
var ELEMENT_ID = 'data-element-id';




/**
 * @class
 *
 * A registry that keeps track of all shapes in the diagram.
 */
function ElementRegistry(eventBus) {
  this._elements = {};

  this._eventBus = eventBus;
}

ElementRegistry.$inject = [ 'eventBus' ];

/**
 * Register a pair of (element, gfx, (secondaryGfx)).
 *
 * @param {djs.model.Base} element
 * @param {SVGElement} gfx
 * @param {SVGElement} [secondaryGfx] optional other element to register, too
 */
ElementRegistry.prototype.add = function(element, gfx, secondaryGfx) {

  var id = element.id;

  this._validateId(id);

  // associate dom node with element
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(gfx, ELEMENT_ID, id);

  if (secondaryGfx) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(secondaryGfx, ELEMENT_ID, id);
  }

  this._elements[id] = { element: element, gfx: gfx, secondaryGfx: secondaryGfx };
};

/**
 * Removes an element from the registry.
 *
 * @param {djs.model.Base} element
 */
ElementRegistry.prototype.remove = function(element) {
  var elements = this._elements,
      id = element.id || element,
      container = id && elements[id];

  if (container) {

    // unset element id on gfx
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(container.gfx, ELEMENT_ID, '');

    if (container.secondaryGfx) {
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(container.secondaryGfx, ELEMENT_ID, '');
    }

    delete elements[id];
  }
};

/**
 * Update the id of an element
 *
 * @param {djs.model.Base} element
 * @param {string} newId
 */
ElementRegistry.prototype.updateId = function(element, newId) {

  this._validateId(newId);

  if (typeof element === 'string') {
    element = this.get(element);
  }

  this._eventBus.fire('element.updateId', {
    element: element,
    newId: newId
  });

  var gfx = this.getGraphics(element),
      secondaryGfx = this.getGraphics(element, true);

  this.remove(element);

  element.id = newId;

  this.add(element, gfx, secondaryGfx);
};

/**
 * Return the model element for a given id or graphics.
 *
 * @example
 *
 * elementRegistry.get('SomeElementId_1');
 * elementRegistry.get(gfx);
 *
 *
 * @param {string|SVGElement} filter for selecting the element
 *
 * @return {djs.model.Base}
 */
ElementRegistry.prototype.get = function(filter) {
  var id;

  if (typeof filter === 'string') {
    id = filter;
  } else {
    id = filter && Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(filter, ELEMENT_ID);
  }

  var container = this._elements[id];
  return container && container.element;
};

/**
 * Return all elements that match a given filter function.
 *
 * @param {Function} fn
 *
 * @return {Array<djs.model.Base>}
 */
ElementRegistry.prototype.filter = function(fn) {

  var filtered = [];

  this.forEach(function(element, gfx) {
    if (fn(element, gfx)) {
      filtered.push(element);
    }
  });

  return filtered;
};

/**
 * Return the first element that satisfies the provided testing function.
 *
 * @param {Function} fn
 *
 * @return {djs.model.Base}
 */
ElementRegistry.prototype.find = function(fn) {
  var map = this._elements,
      keys = Object.keys(map);

  for (var i = 0; i < keys.length; i++) {
    var id = keys[i],
        container = map[id],
        element = container.element,
        gfx = container.gfx;

    if (fn(element, gfx)) {
      return element;
    }
  }
};

/**
 * Return all rendered model elements.
 *
 * @return {Array<djs.model.Base>}
 */
ElementRegistry.prototype.getAll = function() {
  return this.filter(function(e) { return e; });
};

/**
 * Iterate over all diagram elements.
 *
 * @param {Function} fn
 */
ElementRegistry.prototype.forEach = function(fn) {

  var map = this._elements;

  Object.keys(map).forEach(function(id) {
    var container = map[id],
        element = container.element,
        gfx = container.gfx;

    return fn(element, gfx);
  });
};

/**
 * Return the graphical representation of an element or its id.
 *
 * @example
 * elementRegistry.getGraphics('SomeElementId_1');
 * elementRegistry.getGraphics(rootElement); // <g ...>
 *
 * elementRegistry.getGraphics(rootElement, true); // <svg ...>
 *
 *
 * @param {string|djs.model.Base} filter
 * @param {boolean} [secondary=false] whether to return the secondary connected element
 *
 * @return {SVGElement}
 */
ElementRegistry.prototype.getGraphics = function(filter, secondary) {
  var id = filter.id || filter;

  var container = this._elements[id];
  return container && (secondary ? container.secondaryGfx : container.gfx);
};

/**
 * Validate the suitability of the given id and signals a problem
 * with an exception.
 *
 * @param {string} id
 *
 * @throws {Error} if id is empty or already assigned
 */
ElementRegistry.prototype._validateId = function(id) {
  if (!id) {
    throw new Error('element must have an id');
  }

  if (this._elements[id]) {
    throw new Error('element with id ' + id + ' already added');
  }
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/core/EventBus.js":
/*!******************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/EventBus.js ***!
  \******************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return EventBus; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


var FN_REF = '__fn';

var DEFAULT_PRIORITY = 1000;

var slice = Array.prototype.slice;

/**
 * A general purpose event bus.
 *
 * This component is used to communicate across a diagram instance.
 * Other parts of a diagram can use it to listen to and broadcast events.
 *
 *
 * ## Registering for Events
 *
 * The event bus provides the {@link EventBus#on} and {@link EventBus#once}
 * methods to register for events. {@link EventBus#off} can be used to
 * remove event registrations. Listeners receive an instance of {@link Event}
 * as the first argument. It allows them to hook into the event execution.
 *
 * ```javascript
 *
 * // listen for event
 * eventBus.on('foo', function(event) {
 *
 *   // access event type
 *   event.type; // 'foo'
 *
 *   // stop propagation to other listeners
 *   event.stopPropagation();
 *
 *   // prevent event default
 *   event.preventDefault();
 * });
 *
 * // listen for event with custom payload
 * eventBus.on('bar', function(event, payload) {
 *   console.log(payload);
 * });
 *
 * // listen for event returning value
 * eventBus.on('foobar', function(event) {
 *
 *   // stop event propagation + prevent default
 *   return false;
 *
 *   // stop event propagation + return custom result
 *   return {
 *     complex: 'listening result'
 *   };
 * });
 *
 *
 * // listen with custom priority (default=1000, higher is better)
 * eventBus.on('priorityfoo', 1500, function(event) {
 *   console.log('invoked first!');
 * });
 *
 *
 * // listen for event and pass the context (`this`)
 * eventBus.on('foobar', function(event) {
 *   this.foo();
 * }, this);
 * ```
 *
 *
 * ## Emitting Events
 *
 * Events can be emitted via the event bus using {@link EventBus#fire}.
 *
 * ```javascript
 *
 * // false indicates that the default action
 * // was prevented by listeners
 * if (eventBus.fire('foo') === false) {
 *   console.log('default has been prevented!');
 * };
 *
 *
 * // custom args + return value listener
 * eventBus.on('sum', function(event, a, b) {
 *   return a + b;
 * });
 *
 * // you can pass custom arguments + retrieve result values.
 * var sum = eventBus.fire('sum', 1, 2);
 * console.log(sum); // 3
 * ```
 */
function EventBus() {
  this._listeners = {};

  // cleanup on destroy on lowest priority to allow
  // message passing until the bitter end
  this.on('diagram.destroy', 1, this._destroy, this);
}


/**
 * Register an event listener for events with the given name.
 *
 * The callback will be invoked with `event, ...additionalArguments`
 * that have been passed to {@link EventBus#fire}.
 *
 * Returning false from a listener will prevent the events default action
 * (if any is specified). To stop an event from being processed further in
 * other listeners execute {@link Event#stopPropagation}.
 *
 * Returning anything but `undefined` from a listener will stop the listener propagation.
 *
 * @param {string|Array<string>} events
 * @param {number} [priority=1000] the priority in which this listener is called, larger is higher
 * @param {Function} callback
 * @param {Object} [that] Pass context (`this`) to the callback
 */
EventBus.prototype.on = function(events, priority, callback, that) {

  events = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(events) ? events : [ events ];

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isFunction"])(priority)) {
    that = callback;
    callback = priority;
    priority = DEFAULT_PRIORITY;
  }

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(priority)) {
    throw new Error('priority must be a number');
  }

  var actualCallback = callback;

  if (that) {
    actualCallback = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(callback, that);

    // make sure we remember and are able to remove
    // bound callbacks via {@link #off} using the original
    // callback
    actualCallback[FN_REF] = callback[FN_REF] || callback;
  }

  var self = this;

  events.forEach(function(e) {
    self._addListener(e, {
      priority: priority,
      callback: actualCallback,
      next: null
    });
  });
};


/**
 * Register an event listener that is executed only once.
 *
 * @param {string} event the event name to register for
 * @param {number} [priority=1000] the priority in which this listener is called, larger is higher
 * @param {Function} callback the callback to execute
 * @param {Object} [that] Pass context (`this`) to the callback
 */
EventBus.prototype.once = function(event, priority, callback, that) {
  var self = this;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isFunction"])(priority)) {
    that = callback;
    callback = priority;
    priority = DEFAULT_PRIORITY;
  }

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(priority)) {
    throw new Error('priority must be a number');
  }

  function wrappedCallback() {
    wrappedCallback.__isTomb = true;

    var result = callback.apply(that, arguments);

    self.off(event, wrappedCallback);

    return result;
  }

  // make sure we remember and are able to remove
  // bound callbacks via {@link #off} using the original
  // callback
  wrappedCallback[FN_REF] = callback;

  this.on(event, priority, wrappedCallback);
};


/**
 * Removes event listeners by event and callback.
 *
 * If no callback is given, all listeners for a given event name are being removed.
 *
 * @param {string|Array<string>} events
 * @param {Function} [callback]
 */
EventBus.prototype.off = function(events, callback) {

  events = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(events) ? events : [ events ];

  var self = this;

  events.forEach(function(event) {
    self._removeListener(event, callback);
  });

};


/**
 * Create an EventBus event.
 *
 * @param {Object} data
 *
 * @return {Object} event, recognized by the eventBus
 */
EventBus.prototype.createEvent = function(data) {
  var event = new InternalEvent();

  event.init(data);

  return event;
};


/**
 * Fires a named event.
 *
 * @example
 *
 * // fire event by name
 * events.fire('foo');
 *
 * // fire event object with nested type
 * var event = { type: 'foo' };
 * events.fire(event);
 *
 * // fire event with explicit type
 * var event = { x: 10, y: 20 };
 * events.fire('element.moved', event);
 *
 * // pass additional arguments to the event
 * events.on('foo', function(event, bar) {
 *   alert(bar);
 * });
 *
 * events.fire({ type: 'foo' }, 'I am bar!');
 *
 * @param {string} [name] the optional event name
 * @param {Object} [event] the event object
 * @param {...Object} additional arguments to be passed to the callback functions
 *
 * @return {boolean} the events return value, if specified or false if the
 *                   default action was prevented by listeners
 */
EventBus.prototype.fire = function(type, data) {
  var event,
      firstListener,
      returnValue,
      args;

  args = slice.call(arguments);

  if (typeof type === 'object') {
    data = type;
    type = data.type;
  }

  if (!type) {
    throw new Error('no event type specified');
  }

  firstListener = this._listeners[type];

  if (!firstListener) {
    return;
  }

  // we make sure we fire instances of our home made
  // events here. We wrap them only once, though
  if (data instanceof InternalEvent) {

    // we are fine, we alread have an event
    event = data;
  } else {
    event = this.createEvent(data);
  }

  // ensure we pass the event as the first parameter
  args[0] = event;

  // original event type (in case we delegate)
  var originalType = event.type;

  // update event type before delegation
  if (type !== originalType) {
    event.type = type;
  }

  try {
    returnValue = this._invokeListeners(event, args, firstListener);
  } finally {

    // reset event type after delegation
    if (type !== originalType) {
      event.type = originalType;
    }
  }

  // set the return value to false if the event default
  // got prevented and no other return value exists
  if (returnValue === undefined && event.defaultPrevented) {
    returnValue = false;
  }

  return returnValue;
};


EventBus.prototype.handleError = function(error) {
  return this.fire('error', { error: error }) === false;
};


EventBus.prototype._destroy = function() {
  this._listeners = {};
};

EventBus.prototype._invokeListeners = function(event, args, listener) {

  var returnValue;

  while (listener) {

    // handle stopped propagation
    if (event.cancelBubble) {
      break;
    }

    returnValue = this._invokeListener(event, args, listener);

    listener = listener.next;
  }

  return returnValue;
};

EventBus.prototype._invokeListener = function(event, args, listener) {

  var returnValue;

  if (listener.callback.__isTomb) {
    return returnValue;
  }

  try {

    // returning false prevents the default action
    returnValue = invokeFunction(listener.callback, args);

    // stop propagation on return value
    if (returnValue !== undefined) {
      event.returnValue = returnValue;
      event.stopPropagation();
    }

    // prevent default on return false
    if (returnValue === false) {
      event.preventDefault();
    }
  } catch (e) {
    if (!this.handleError(e)) {
      console.error('unhandled error in event listener');
      console.error(e.stack);

      throw e;
    }
  }

  return returnValue;
};

/*
 * Add new listener with a certain priority to the list
 * of listeners (for the given event).
 *
 * The semantics of listener registration / listener execution are
 * first register, first serve: New listeners will always be inserted
 * after existing listeners with the same priority.
 *
 * Example: Inserting two listeners with priority 1000 and 1300
 *
 *    * before: [ 1500, 1500, 1000, 1000 ]
 *    * after: [ 1500, 1500, (new=1300), 1000, 1000, (new=1000) ]
 *
 * @param {string} event
 * @param {Object} listener { priority, callback }
 */
EventBus.prototype._addListener = function(event, newListener) {

  var listener = this._getListeners(event),
      previousListener;

  // no prior listeners
  if (!listener) {
    this._setListeners(event, newListener);

    return;
  }

  // ensure we order listeners by priority from
  // 0 (high) to n > 0 (low)
  while (listener) {

    if (listener.priority < newListener.priority) {

      newListener.next = listener;

      if (previousListener) {
        previousListener.next = newListener;
      } else {
        this._setListeners(event, newListener);
      }

      return;
    }

    previousListener = listener;
    listener = listener.next;
  }

  // add new listener to back
  previousListener.next = newListener;
};


EventBus.prototype._getListeners = function(name) {
  return this._listeners[name];
};

EventBus.prototype._setListeners = function(name, listener) {
  this._listeners[name] = listener;
};

EventBus.prototype._removeListener = function(event, callback) {

  var listener = this._getListeners(event),
      nextListener,
      previousListener,
      listenerCallback;

  if (!callback) {

    // clear listeners
    this._setListeners(event, null);

    return;
  }

  while (listener) {

    nextListener = listener.next;

    listenerCallback = listener.callback;

    if (listenerCallback === callback || listenerCallback[FN_REF] === callback) {
      if (previousListener) {
        previousListener.next = nextListener;
      } else {

        // new first listener
        this._setListeners(event, nextListener);
      }
    }

    previousListener = listener;
    listener = nextListener;
  }
};

/**
 * A event that is emitted via the event bus.
 */
function InternalEvent() { }

InternalEvent.prototype.stopPropagation = function() {
  this.cancelBubble = true;
};

InternalEvent.prototype.preventDefault = function() {
  this.defaultPrevented = true;
};

InternalEvent.prototype.init = function(data) {
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(this, data || {});
};


/**
 * Invoke function. Be fast...
 *
 * @param {Function} fn
 * @param {Array<Object>} args
 *
 * @return {Any}
 */
function invokeFunction(fn, args) {
  return fn.apply(null, args);
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/core/GraphicsFactory.js":
/*!*************************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/GraphicsFactory.js ***!
  \*************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return GraphicsFactory; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var _util_GraphicsUtil__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../util/GraphicsUtil */ "./node_modules/diagram-js/lib/util/GraphicsUtil.js");
/* harmony import */ var _util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../util/SvgTransformUtil */ "./node_modules/diagram-js/lib/util/SvgTransformUtil.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var _util_Elements__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../util/Elements */ "./node_modules/diagram-js/lib/util/Elements.js");












/**
 * A factory that creates graphical elements
 *
 * @param {EventBus} eventBus
 * @param {ElementRegistry} elementRegistry
 */
function GraphicsFactory(eventBus, elementRegistry) {
  this._eventBus = eventBus;
  this._elementRegistry = elementRegistry;
}

GraphicsFactory.$inject = [ 'eventBus' , 'elementRegistry' ];


GraphicsFactory.prototype._getChildrenContainer = function(element) {

  var gfx = this._elementRegistry.getGraphics(element);

  var childrenGfx;

  // root element
  if (!element.parent) {
    childrenGfx = gfx;
  } else {
    childrenGfx = Object(_util_GraphicsUtil__WEBPACK_IMPORTED_MODULE_1__["getChildren"])(gfx);
    if (!childrenGfx) {
      childrenGfx = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('g');
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(childrenGfx).add('djs-children');

      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["append"])(gfx.parentNode, childrenGfx);
    }
  }

  return childrenGfx;
};

/**
 * Clears the graphical representation of the element and returns the
 * cleared visual (the <g class="djs-visual" /> element).
 */
GraphicsFactory.prototype._clear = function(gfx) {
  var visual = Object(_util_GraphicsUtil__WEBPACK_IMPORTED_MODULE_1__["getVisual"])(gfx);

  Object(min_dom__WEBPACK_IMPORTED_MODULE_3__["clear"])(visual);

  return visual;
};

/**
 * Creates a gfx container for shapes and connections
 *
 * The layout is as follows:
 *
 * <g class="djs-group">
 *
 *   <!-- the gfx -->
 *   <g class="djs-element djs-(shape|connection|frame)">
 *     <g class="djs-visual">
 *       <!-- the renderer draws in here -->
 *     </g>
 *
 *     <!-- extensions (overlays, click box, ...) goes here
 *   </g>
 *
 *   <!-- the gfx child nodes -->
 *   <g class="djs-children"></g>
 * </g>
 *
 * @param {string} type the type of the element, i.e. shape | connection
 * @param {SVGElement} [childrenGfx]
 * @param {number} [parentIndex] position to create container in parent
 * @param {boolean} [isFrame] is frame element
 *
 * @return {SVGElement}
 */
GraphicsFactory.prototype._createContainer = function(
    type, childrenGfx, parentIndex, isFrame
) {
  var outerGfx = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('g');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(outerGfx).add('djs-group');

  // insert node at position
  if (typeof parentIndex !== 'undefined') {
    prependTo(outerGfx, childrenGfx, childrenGfx.childNodes[parentIndex]);
  } else {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["append"])(childrenGfx, outerGfx);
  }

  var gfx = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('g');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).add('djs-element');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).add('djs-' + type);

  if (isFrame) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(gfx).add('djs-frame');
  }

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["append"])(outerGfx, gfx);

  // create visual
  var visual = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["create"])('g');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["classes"])(visual).add('djs-visual');

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["append"])(gfx, visual);

  return gfx;
};

GraphicsFactory.prototype.create = function(type, element, parentIndex) {
  var childrenGfx = this._getChildrenContainer(element.parent);
  return this._createContainer(type, childrenGfx, parentIndex, Object(_util_Elements__WEBPACK_IMPORTED_MODULE_5__["isFrameElement"])(element));
};

GraphicsFactory.prototype.updateContainments = function(elements) {

  var self = this,
      elementRegistry = this._elementRegistry,
      parents;

  parents = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["reduce"])(elements, function(map, e) {

    if (e.parent) {
      map[e.parent.id] = e.parent;
    }

    return map;
  }, {});

  // update all parents of changed and reorganized their children
  // in the correct order (as indicated in our model)
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(parents, function(parent) {

    var children = parent.children;

    if (!children) {
      return;
    }

    var childrenGfx = self._getChildrenContainer(parent);

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(children.slice().reverse(), function(child) {
      var childGfx = elementRegistry.getGraphics(child);

      prependTo(childGfx.parentNode, childrenGfx);
    });
  });
};

GraphicsFactory.prototype.drawShape = function(visual, element) {
  var eventBus = this._eventBus;

  return eventBus.fire('render.shape', { gfx: visual, element: element });
};

GraphicsFactory.prototype.getShapePath = function(element) {
  var eventBus = this._eventBus;

  return eventBus.fire('render.getShapePath', element);
};

GraphicsFactory.prototype.drawConnection = function(visual, element) {
  var eventBus = this._eventBus;

  return eventBus.fire('render.connection', { gfx: visual, element: element });
};

GraphicsFactory.prototype.getConnectionPath = function(waypoints) {
  var eventBus = this._eventBus;

  return eventBus.fire('render.getConnectionPath', waypoints);
};

GraphicsFactory.prototype.update = function(type, element, gfx) {

  // do NOT update root element
  if (!element.parent) {
    return;
  }

  var visual = this._clear(gfx);

  // redraw
  if (type === 'shape') {
    this.drawShape(visual, element);

    // update positioning
    Object(_util_SvgTransformUtil__WEBPACK_IMPORTED_MODULE_2__["translate"])(gfx, element.x, element.y);
  } else
  if (type === 'connection') {
    this.drawConnection(visual, element);
  } else {
    throw new Error('unknown type: ' + type);
  }

  if (element.hidden) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["attr"])(gfx, 'display', 'none');
  } else {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["attr"])(gfx, 'display', 'block');
  }
};

GraphicsFactory.prototype.remove = function(element) {
  var gfx = this._elementRegistry.getGraphics(element);

  // remove
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_4__["remove"])(gfx.parentNode);
};


// helpers //////////

function prependTo(newNode, parentNode, siblingNode) {
  var node = siblingNode || parentNode.firstChild;

  // do not prepend node to itself to prevent IE from crashing
  // https://github.com/bpmn-io/bpmn-js/issues/746
  if (newNode === node) {
    return;
  }

  parentNode.insertBefore(newNode, node);
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/core/index.js":
/*!***************************************************!*\
  !*** ./node_modules/diagram-js/lib/core/index.js ***!
  \***************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _draw__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../draw */ "./node_modules/diagram-js/lib/draw/index.js");
/* harmony import */ var _Canvas__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Canvas */ "./node_modules/diagram-js/lib/core/Canvas.js");
/* harmony import */ var _ElementRegistry__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./ElementRegistry */ "./node_modules/diagram-js/lib/core/ElementRegistry.js");
/* harmony import */ var _ElementFactory__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./ElementFactory */ "./node_modules/diagram-js/lib/core/ElementFactory.js");
/* harmony import */ var _EventBus__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./EventBus */ "./node_modules/diagram-js/lib/core/EventBus.js");
/* harmony import */ var _GraphicsFactory__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./GraphicsFactory */ "./node_modules/diagram-js/lib/core/GraphicsFactory.js");








/* harmony default export */ __webpack_exports__["default"] = ({
  __depends__: [ _draw__WEBPACK_IMPORTED_MODULE_0__["default"] ],
  __init__: [ 'canvas' ],
  canvas: [ 'type', _Canvas__WEBPACK_IMPORTED_MODULE_1__["default"] ],
  elementRegistry: [ 'type', _ElementRegistry__WEBPACK_IMPORTED_MODULE_2__["default"] ],
  elementFactory: [ 'type', _ElementFactory__WEBPACK_IMPORTED_MODULE_3__["default"] ],
  eventBus: [ 'type', _EventBus__WEBPACK_IMPORTED_MODULE_4__["default"] ],
  graphicsFactory: [ 'type', _GraphicsFactory__WEBPACK_IMPORTED_MODULE_5__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/draw/BaseRenderer.js":
/*!**********************************************************!*\
  !*** ./node_modules/diagram-js/lib/draw/BaseRenderer.js ***!
  \**********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return BaseRenderer; });
var DEFAULT_RENDER_PRIORITY = 1000;

/**
 * The base implementation of shape and connection renderers.
 *
 * @param {EventBus} eventBus
 * @param {number} [renderPriority=1000]
 */
function BaseRenderer(eventBus, renderPriority) {
  var self = this;

  renderPriority = renderPriority || DEFAULT_RENDER_PRIORITY;

  eventBus.on([ 'render.shape', 'render.connection' ], renderPriority, function(evt, context) {
    var type = evt.type,
        element = context.element,
        visuals = context.gfx;

    if (self.canRender(element)) {
      if (type === 'render.shape') {
        return self.drawShape(visuals, element);
      } else {
        return self.drawConnection(visuals, element);
      }
    }
  });

  eventBus.on([ 'render.getShapePath', 'render.getConnectionPath'], renderPriority, function(evt, element) {
    if (self.canRender(element)) {
      if (evt.type === 'render.getShapePath') {
        return self.getShapePath(element);
      } else {
        return self.getConnectionPath(element);
      }
    }
  });
}

/**
 * Should check whether *this* renderer can render
 * the element/connection.
 *
 * @param {element} element
 *
 * @returns {boolean}
 */
BaseRenderer.prototype.canRender = function() {};

/**
 * Provides the shape's snap svg element to be drawn on the `canvas`.
 *
 * @param {djs.Graphics} visuals
 * @param {Shape} shape
 *
 * @returns {Snap.svg} [returns a Snap.svg paper element ]
 */
BaseRenderer.prototype.drawShape = function() {};

/**
 * Provides the shape's snap svg element to be drawn on the `canvas`.
 *
 * @param {djs.Graphics} visuals
 * @param {Connection} connection
 *
 * @returns {Snap.svg} [returns a Snap.svg paper element ]
 */
BaseRenderer.prototype.drawConnection = function() {};

/**
 * Gets the SVG path of a shape that represents it's visual bounds.
 *
 * @param {Shape} shape
 *
 * @return {string} svg path
 */
BaseRenderer.prototype.getShapePath = function() {};

/**
 * Gets the SVG path of a connection that represents it's visual bounds.
 *
 * @param {Connection} connection
 *
 * @return {string} svg path
 */
BaseRenderer.prototype.getConnectionPath = function() {};


/***/ }),

/***/ "./node_modules/diagram-js/lib/draw/DefaultRenderer.js":
/*!*************************************************************!*\
  !*** ./node_modules/diagram-js/lib/draw/DefaultRenderer.js ***!
  \*************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return DefaultRenderer; });
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var _BaseRenderer__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./BaseRenderer */ "./node_modules/diagram-js/lib/draw/BaseRenderer.js");
/* harmony import */ var _util_RenderUtil__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../util/RenderUtil */ "./node_modules/diagram-js/lib/util/RenderUtil.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var _util_Elements__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../util/Elements */ "./node_modules/diagram-js/lib/util/Elements.js");










// apply default renderer with lowest possible priority
// so that it only kicks in if noone else could render
var DEFAULT_RENDER_PRIORITY = 1;

/**
 * The default renderer used for shapes and connections.
 *
 * @param {EventBus} eventBus
 * @param {Styles} styles
 */
function DefaultRenderer(eventBus, styles) {

  //
  _BaseRenderer__WEBPACK_IMPORTED_MODULE_1__["default"].call(this, eventBus, DEFAULT_RENDER_PRIORITY);

  this.CONNECTION_STYLE = styles.style([ 'no-fill' ], { strokeWidth: 5, stroke: 'fuchsia' });
  this.SHAPE_STYLE = styles.style({ fill: 'white', stroke: 'fuchsia', strokeWidth: 2 });
  this.FRAME_STYLE = styles.style([ 'no-fill' ], { stroke: 'fuchsia', strokeDasharray: 4, strokeWidth: 2 });
}

inherits__WEBPACK_IMPORTED_MODULE_0___default()(DefaultRenderer, _BaseRenderer__WEBPACK_IMPORTED_MODULE_1__["default"]);


DefaultRenderer.prototype.canRender = function() {
  return true;
};

DefaultRenderer.prototype.drawShape = function drawShape(visuals, element) {
  var rect = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["create"])('rect');

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(rect, {
    x: 0,
    y: 0,
    width: element.width || 0,
    height: element.height || 0
  });

  if (Object(_util_Elements__WEBPACK_IMPORTED_MODULE_4__["isFrameElement"])(element)) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(rect, this.FRAME_STYLE);
  } else {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(rect, this.SHAPE_STYLE);
  }

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["append"])(visuals, rect);

  return rect;
};

DefaultRenderer.prototype.drawConnection = function drawConnection(visuals, connection) {

  var line = Object(_util_RenderUtil__WEBPACK_IMPORTED_MODULE_2__["createLine"])(connection.waypoints, this.CONNECTION_STYLE);
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["append"])(visuals, line);

  return line;
};

DefaultRenderer.prototype.getShapePath = function getShapePath(shape) {

  var x = shape.x,
      y = shape.y,
      width = shape.width,
      height = shape.height;

  var shapePath = [
    ['M', x, y],
    ['l', width, 0],
    ['l', 0, height],
    ['l', -width, 0],
    ['z']
  ];

  return Object(_util_RenderUtil__WEBPACK_IMPORTED_MODULE_2__["componentsToPath"])(shapePath);
};

DefaultRenderer.prototype.getConnectionPath = function getConnectionPath(connection) {
  var waypoints = connection.waypoints;

  var idx, point, connectionPath = [];

  for (idx = 0; (point = waypoints[idx]); idx++) {

    // take invisible docking into account
    // when creating the path
    point = point.original || point;

    connectionPath.push([ idx === 0 ? 'M' : 'L', point.x, point.y ]);
  }

  return Object(_util_RenderUtil__WEBPACK_IMPORTED_MODULE_2__["componentsToPath"])(connectionPath);
};


DefaultRenderer.$inject = [ 'eventBus', 'styles' ];


/***/ }),

/***/ "./node_modules/diagram-js/lib/draw/Styles.js":
/*!****************************************************!*\
  !*** ./node_modules/diagram-js/lib/draw/Styles.js ***!
  \****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Styles; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");



/**
 * A component that manages shape styles
 */
function Styles() {

  var defaultTraits = {

    'no-fill': {
      fill: 'none'
    },
    'no-border': {
      strokeOpacity: 0.0
    },
    'no-events': {
      pointerEvents: 'none'
    }
  };

  var self = this;

  /**
   * Builds a style definition from a className, a list of traits and an object of additional attributes.
   *
   * @param  {string} className
   * @param  {Array<string>} traits
   * @param  {Object} additionalAttrs
   *
   * @return {Object} the style defintion
   */
  this.cls = function(className, traits, additionalAttrs) {
    var attrs = this.style(traits, additionalAttrs);

    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(attrs, { 'class': className });
  };

  /**
   * Builds a style definition from a list of traits and an object of additional attributes.
   *
   * @param  {Array<string>} traits
   * @param  {Object} additionalAttrs
   *
   * @return {Object} the style defintion
   */
  this.style = function(traits, additionalAttrs) {

    if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(traits) && !additionalAttrs) {
      additionalAttrs = traits;
      traits = [];
    }

    var attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["reduce"])(traits, function(attrs, t) {
      return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(attrs, defaultTraits[t] || {});
    }, {});

    return additionalAttrs ? Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(attrs, additionalAttrs) : attrs;
  };

  this.computeStyle = function(custom, traits, defaultStyles) {
    if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(traits)) {
      defaultStyles = traits;
      traits = [];
    }

    return self.style(traits || [], Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, defaultStyles, custom || {}));
  };
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/draw/index.js":
/*!***************************************************!*\
  !*** ./node_modules/diagram-js/lib/draw/index.js ***!
  \***************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _DefaultRenderer__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./DefaultRenderer */ "./node_modules/diagram-js/lib/draw/DefaultRenderer.js");
/* harmony import */ var _Styles__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Styles */ "./node_modules/diagram-js/lib/draw/Styles.js");



/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'defaultRenderer' ],
  defaultRenderer: [ 'type', _DefaultRenderer__WEBPACK_IMPORTED_MODULE_0__["default"] ],
  styles: [ 'type', _Styles__WEBPACK_IMPORTED_MODULE_1__["default"] ]
});


/***/ }),

/***/ "./node_modules/diagram-js/lib/features/interaction-events/InteractionEvents.js":
/*!**************************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/interaction-events/InteractionEvents.js ***!
  \**************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return InteractionEvents; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var _util_Mouse__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../util/Mouse */ "./node_modules/diagram-js/lib/util/Mouse.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var _util_RenderUtil__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../../util/RenderUtil */ "./node_modules/diagram-js/lib/util/RenderUtil.js");










function allowAll(event) { return true; }

function allowPrimaryAndAuxiliary(event) {
  return Object(_util_Mouse__WEBPACK_IMPORTED_MODULE_2__["isPrimaryButton"])(event) || Object(_util_Mouse__WEBPACK_IMPORTED_MODULE_2__["isAuxiliaryButton"])(event);
}

var LOW_PRIORITY = 500;


/**
 * A plugin that provides interaction events for diagram elements.
 *
 * It emits the following events:
 *
 *   * element.click
 *   * element.contextmenu
 *   * element.dblclick
 *   * element.hover
 *   * element.mousedown
 *   * element.mousemove
 *   * element.mouseup
 *   * element.out
 *
 * Each event is a tuple { element, gfx, originalEvent }.
 *
 * Canceling the event via Event#preventDefault()
 * prevents the original DOM operation.
 *
 * @param {EventBus} eventBus
 */
function InteractionEvents(eventBus, elementRegistry, styles) {

  var self = this;

  /**
   * Fire an interaction event.
   *
   * @param {string} type local event name, e.g. element.click.
   * @param {DOMEvent} event native event
   * @param {djs.model.Base} [element] the diagram element to emit the event on;
   *                                   defaults to the event target
   */
  function fire(type, event, element) {

    if (isIgnored(type, event)) {
      return;
    }

    var target, gfx, returnValue;

    if (!element) {
      target = event.delegateTarget || event.target;

      if (target) {
        gfx = target;
        element = elementRegistry.get(gfx);
      }
    } else {
      gfx = elementRegistry.getGraphics(element);
    }

    if (!gfx || !element) {
      return;
    }

    returnValue = eventBus.fire(type, {
      element: element,
      gfx: gfx,
      originalEvent: event
    });

    if (returnValue === false) {
      event.stopPropagation();
      event.preventDefault();
    }
  }

  // TODO(nikku): document this
  var handlers = {};

  function mouseHandler(localEventName) {
    return handlers[localEventName];
  }

  function isIgnored(localEventName, event) {

    var filter = ignoredFilters[localEventName] || _util_Mouse__WEBPACK_IMPORTED_MODULE_2__["isPrimaryButton"];

    // only react on left mouse button interactions
    // except for interaction events that are enabled
    // for secundary mouse button
    return !filter(event);
  }

  var bindings = {
    click: 'element.click',
    contextmenu: 'element.contextmenu',
    dblclick: 'element.dblclick',
    mousedown: 'element.mousedown',
    mousemove: 'element.mousemove',
    mouseover: 'element.hover',
    mouseout: 'element.out',
    mouseup: 'element.mouseup',
  };

  var ignoredFilters = {
    'element.contextmenu': allowAll,
    'element.mousedown': allowPrimaryAndAuxiliary,
    'element.mouseup': allowPrimaryAndAuxiliary,
    'element.click': allowPrimaryAndAuxiliary,
    'element.dblclick': allowPrimaryAndAuxiliary
  };


  // manual event trigger //////////

  /**
   * Trigger an interaction event (based on a native dom event)
   * on the target shape or connection.
   *
   * @param {string} eventName the name of the triggered DOM event
   * @param {MouseEvent} event
   * @param {djs.model.Base} targetElement
   */
  function triggerMouseEvent(eventName, event, targetElement) {

    // i.e. element.mousedown...
    var localEventName = bindings[eventName];

    if (!localEventName) {
      throw new Error('unmapped DOM event name <' + eventName + '>');
    }

    return fire(localEventName, event, targetElement);
  }


  var ELEMENT_SELECTOR = 'svg, .djs-element';

  // event handling ///////

  function registerEvent(node, event, localEvent, ignoredFilter) {

    var handler = handlers[localEvent] = function(event) {
      fire(localEvent, event);
    };

    if (ignoredFilter) {
      ignoredFilters[localEvent] = ignoredFilter;
    }

    handler.$delegate = min_dom__WEBPACK_IMPORTED_MODULE_1__["delegate"].bind(node, ELEMENT_SELECTOR, event, handler);
  }

  function unregisterEvent(node, event, localEvent) {

    var handler = mouseHandler(localEvent);

    if (!handler) {
      return;
    }

    min_dom__WEBPACK_IMPORTED_MODULE_1__["delegate"].unbind(node, event, handler.$delegate);
  }

  function registerEvents(svg) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(bindings, function(val, key) {
      registerEvent(svg, key, val);
    });
  }

  function unregisterEvents(svg) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(bindings, function(val, key) {
      unregisterEvent(svg, key, val);
    });
  }

  eventBus.on('canvas.destroy', function(event) {
    unregisterEvents(event.svg);
  });

  eventBus.on('canvas.init', function(event) {
    registerEvents(event.svg);
  });


  // hit box updating ////////////////

  eventBus.on([ 'shape.added', 'connection.added' ], function(event) {
    var element = event.element,
        gfx = event.gfx;

    eventBus.fire('interactionEvents.createHit', { element: element, gfx: gfx });
  });

  // Update djs-hit on change.
  // A low priortity is necessary, because djs-hit of labels has to be updated
  // after the label bounds have been updated in the renderer.
  eventBus.on([
    'shape.changed',
    'connection.changed'
  ], LOW_PRIORITY, function(event) {

    var element = event.element,
        gfx = event.gfx;

    eventBus.fire('interactionEvents.updateHit', { element: element, gfx: gfx });
  });

  eventBus.on('interactionEvents.createHit', LOW_PRIORITY, function(event) {
    var element = event.element,
        gfx = event.gfx;

    self.createDefaultHit(element, gfx);
  });

  eventBus.on('interactionEvents.updateHit', function(event) {
    var element = event.element,
        gfx = event.gfx;

    self.updateDefaultHit(element, gfx);
  });


  // hit styles ////////////

  var STROKE_HIT_STYLE = createHitStyle('djs-hit djs-hit-stroke');

  var CLICK_STROKE_HIT_STYLE = createHitStyle('djs-hit djs-hit-click-stroke');

  var ALL_HIT_STYLE = createHitStyle('djs-hit djs-hit-all');

  var HIT_TYPES = {
    'all': ALL_HIT_STYLE,
    'click-stroke': CLICK_STROKE_HIT_STYLE,
    'stroke': STROKE_HIT_STYLE
  };

  function createHitStyle(classNames, attrs) {

    attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({
      stroke: 'white',
      strokeWidth: 15
    }, attrs || {});

    return styles.cls(classNames, [ 'no-fill', 'no-border' ], attrs);
  }


  // style helpers ///////////////

  function applyStyle(hit, type) {

    var attrs = HIT_TYPES[type];

    if (!attrs) {
      throw new Error('invalid hit type <' + type + '>');
    }

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(hit, attrs);

    return hit;
  }

  function appendHit(gfx, hit) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["append"])(gfx, hit);
  }


  // API

  /**
   * Remove hints on the given graphics.
   *
   * @param {SVGElement} gfx
   */
  this.removeHits = function(gfx) {
    var hits = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["queryAll"])('.djs-hit', gfx);

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(hits, tiny_svg__WEBPACK_IMPORTED_MODULE_3__["remove"]);
  };

  /**
   * Create default hit for the given element.
   *
   * @param {djs.model.Base} element
   * @param {SVGElement} gfx
   *
   * @return {SVGElement} created hit
   */
  this.createDefaultHit = function(element, gfx) {
    var waypoints = element.waypoints,
        isFrame = element.isFrame,
        boxType;

    if (waypoints) {
      return this.createWaypointsHit(gfx, waypoints);
    } else {

      boxType = isFrame ? 'stroke' : 'all';

      return this.createBoxHit(gfx, boxType, {
        width: element.width,
        height: element.height
      });
    }
  };

  /**
   * Create hits for the given waypoints.
   *
   * @param {SVGElement} gfx
   * @param {Array<Point>} waypoints
   *
   * @return {SVGElement}
   */
  this.createWaypointsHit = function(gfx, waypoints) {

    var hit = Object(_util_RenderUtil__WEBPACK_IMPORTED_MODULE_4__["createLine"])(waypoints);

    applyStyle(hit, 'stroke');

    appendHit(gfx, hit);

    return hit;
  };

  /**
   * Create hits for a box.
   *
   * @param {SVGElement} gfx
   * @param {string} hitType
   * @param {Object} attrs
   *
   * @return {SVGElement}
   */
  this.createBoxHit = function(gfx, type, attrs) {

    attrs = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({
      x: 0,
      y: 0
    }, attrs);

    var hit = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["create"])('rect');

    applyStyle(hit, type);

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(hit, attrs);

    appendHit(gfx, hit);

    return hit;
  };

  /**
   * Update default hit of the element.
   *
   * @param  {djs.model.Base} element
   * @param  {SVGElement} gfx
   *
   * @return {SVGElement} updated hit
   */
  this.updateDefaultHit = function(element, gfx) {

    var hit = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["query"])('.djs-hit', gfx);

    if (!hit) {
      return;
    }

    if (element.waypoints) {
      Object(_util_RenderUtil__WEBPACK_IMPORTED_MODULE_4__["updateLine"])(hit, element.waypoints);
    } else {
      Object(tiny_svg__WEBPACK_IMPORTED_MODULE_3__["attr"])(hit, {
        width: element.width,
        height: element.height
      });
    }

    return hit;
  };

  this.fire = fire;

  this.triggerMouseEvent = triggerMouseEvent;

  this.mouseHandler = mouseHandler;

  this.registerEvent = registerEvent;
  this.unregisterEvent = unregisterEvent;
}


InteractionEvents.$inject = [
  'eventBus',
  'elementRegistry',
  'styles'
];


/**
 * An event indicating that the mouse hovered over an element
 *
 * @event element.hover
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the mouse has left an element
 *
 * @event element.out
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the mouse has clicked an element
 *
 * @event element.click
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the mouse has double clicked an element
 *
 * @event element.dblclick
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the mouse has gone down on an element.
 *
 * @event element.mousedown
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the mouse has gone up on an element.
 *
 * @event element.mouseup
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/**
 * An event indicating that the context menu action is triggered
 * via mouse or touch controls.
 *
 * @event element.contextmenu
 *
 * @type {Object}
 * @property {djs.model.Base} element
 * @property {SVGElement} gfx
 * @property {Event} originalEvent
 */

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/interaction-events/index.js":
/*!**************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/interaction-events/index.js ***!
  \**************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _InteractionEvents__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./InteractionEvents */ "./node_modules/diagram-js/lib/features/interaction-events/InteractionEvents.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'interactionEvents' ],
  interactionEvents: [ 'type', _InteractionEvents__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/keyboard/Keyboard.js":
/*!*******************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/keyboard/Keyboard.js ***!
  \*******************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Keyboard; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var _KeyboardUtil__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./KeyboardUtil */ "./node_modules/diagram-js/lib/features/keyboard/KeyboardUtil.js");






var KEYDOWN_EVENT = 'keyboard.keydown',
    KEYUP_EVENT = 'keyboard.keyup';

var DEFAULT_PRIORITY = 1000;


/**
 * A keyboard abstraction that may be activated and
 * deactivated by users at will, consuming key events
 * and triggering diagram actions.
 *
 * For keys pressed down, keyboard fires `keyboard.keydown` event.
 * The event context contains one field which is `KeyboardEvent` event.
 *
 * The implementation fires the following key events that allow
 * other components to hook into key handling:
 *
 *  - keyboard.bind
 *  - keyboard.unbind
 *  - keyboard.init
 *  - keyboard.destroy
 *
 * All events contain one field which is node.
 *
 * A default binding for the keyboard may be specified via the
 * `keyboard.bindTo` configuration option.
 *
 * @param {Config} config
 * @param {EventBus} eventBus
 */
function Keyboard(config, eventBus) {
  var self = this;

  this._config = config || {};
  this._eventBus = eventBus;

  this._keydownHandler = this._keydownHandler.bind(this);
  this._keyupHandler = this._keyupHandler.bind(this);

  // properly clean dom registrations
  eventBus.on('diagram.destroy', function() {
    self._fire('destroy');

    self.unbind();
  });

  eventBus.on('diagram.init', function() {
    self._fire('init');
  });

  eventBus.on('attach', function() {
    if (config && config.bindTo) {
      self.bind(config.bindTo);
    }
  });

  eventBus.on('detach', function() {
    self.unbind();
  });
}

Keyboard.$inject = [
  'config.keyboard',
  'eventBus'
];

Keyboard.prototype._keydownHandler = function(event) {
  this._keyHandler(event, KEYDOWN_EVENT);
};

Keyboard.prototype._keyupHandler = function(event) {
  this._keyHandler(event, KEYUP_EVENT);
};

Keyboard.prototype._keyHandler = function(event, type) {
  var target = event.target,
      eventBusResult;

  if (isInput(target)) {
    return;
  }

  var context = {
    keyEvent: event
  };

  eventBusResult = this._eventBus.fire(type || KEYDOWN_EVENT, context);

  if (eventBusResult) {
    event.preventDefault();
  }
};

Keyboard.prototype.bind = function(node) {

  // make sure that the keyboard is only bound once to the DOM
  this.unbind();

  this._node = node;

  // bind key events
  min_dom__WEBPACK_IMPORTED_MODULE_1__["event"].bind(node, 'keydown', this._keydownHandler, true);
  min_dom__WEBPACK_IMPORTED_MODULE_1__["event"].bind(node, 'keyup', this._keyupHandler, true);

  this._fire('bind');
};

Keyboard.prototype.getBinding = function() {
  return this._node;
};

Keyboard.prototype.unbind = function() {
  var node = this._node;

  if (node) {
    this._fire('unbind');

    // unbind key events
    min_dom__WEBPACK_IMPORTED_MODULE_1__["event"].unbind(node, 'keydown', this._keydownHandler, true);
    min_dom__WEBPACK_IMPORTED_MODULE_1__["event"].unbind(node, 'keyup', this._keyupHandler, true);
  }

  this._node = null;
};

Keyboard.prototype._fire = function(event) {
  this._eventBus.fire('keyboard.' + event, { node: this._node });
};

/**
 * Add a listener function that is notified with `KeyboardEvent` whenever
 * the keyboard is bound and the user presses a key. If no priority is
 * provided, the default value of 1000 is used.
 *
 * @param {number} [priority]
 * @param {Function} listener
 * @param {string} type
 */
Keyboard.prototype.addListener = function(priority, listener, type) {
  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isFunction"])(priority)) {
    type = listener;
    listener = priority;
    priority = DEFAULT_PRIORITY;
  }

  this._eventBus.on(type || KEYDOWN_EVENT, priority, listener);
};

Keyboard.prototype.removeListener = function(listener, type) {
  this._eventBus.off(type || KEYDOWN_EVENT, listener);
};

Keyboard.prototype.hasModifier = _KeyboardUtil__WEBPACK_IMPORTED_MODULE_2__["hasModifier"];
Keyboard.prototype.isCmd = _KeyboardUtil__WEBPACK_IMPORTED_MODULE_2__["isCmd"];
Keyboard.prototype.isShift = _KeyboardUtil__WEBPACK_IMPORTED_MODULE_2__["isShift"];
Keyboard.prototype.isKey = _KeyboardUtil__WEBPACK_IMPORTED_MODULE_2__["isKey"];



// helpers ///////

function isInput(target) {
  return target && (Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["matches"])(target, 'input, textarea') || target.contentEditable === 'true');
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/features/keyboard/KeyboardBindings.js":
/*!***************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/keyboard/KeyboardBindings.js ***!
  \***************************************************************************/
/*! exports provided: KEYCODE_C, KEYCODE_V, KEYCODE_Y, KEYCODE_Z, KEYS_COPY, KEYS_PASTE, KEYS_REDO, KEYS_UNDO, default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYCODE_C", function() { return KEYCODE_C; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYCODE_V", function() { return KEYCODE_V; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYCODE_Y", function() { return KEYCODE_Y; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYCODE_Z", function() { return KEYCODE_Z; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYS_COPY", function() { return KEYS_COPY; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYS_PASTE", function() { return KEYS_PASTE; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYS_REDO", function() { return KEYS_REDO; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "KEYS_UNDO", function() { return KEYS_UNDO; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return KeyboardBindings; });
/* harmony import */ var _KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./KeyboardUtil */ "./node_modules/diagram-js/lib/features/keyboard/KeyboardUtil.js");


var LOW_PRIORITY = 500;

var KEYCODE_C = 67;
var KEYCODE_V = 86;
var KEYCODE_Y = 89;
var KEYCODE_Z = 90;

var KEYS_COPY = ['c', 'C', KEYCODE_C ];
var KEYS_PASTE = [ 'v', 'V', KEYCODE_V ];
var KEYS_REDO = [ 'y', 'Y', KEYCODE_Y ];
var KEYS_UNDO = [ 'z', 'Z', KEYCODE_Z ];


/**
 * Adds default keyboard bindings.
 *
 * This does not pull in any features will bind only actions that
 * have previously been registered against the editorActions component.
 *
 * @param {EventBus} eventBus
 * @param {Keyboard} keyboard
 */
function KeyboardBindings(eventBus, keyboard) {

  var self = this;

  eventBus.on('editorActions.init', LOW_PRIORITY, function(event) {

    var editorActions = event.editorActions;

    self.registerBindings(keyboard, editorActions);
  });
}

KeyboardBindings.$inject = [
  'eventBus',
  'keyboard'
];


/**
 * Register available keyboard bindings.
 *
 * @param {Keyboard} keyboard
 * @param {EditorActions} editorActions
 */
KeyboardBindings.prototype.registerBindings = function(keyboard, editorActions) {

  /**
   * Add keyboard binding if respective editor action
   * is registered.
   *
   * @param {string} action name
   * @param {Function} fn that implements the key binding
   */
  function addListener(action, fn) {

    if (editorActions.isRegistered(action)) {
      keyboard.addListener(fn);
    }
  }


  // undo
  // (CTRL|CMD) + Z
  addListener('undo', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event) && !Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isShift"])(event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(KEYS_UNDO, event)) {
      editorActions.trigger('undo');

      return true;
    }
  });

  // redo
  // CTRL + Y
  // CMD + SHIFT + Z
  addListener('redo', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event) && (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(KEYS_REDO, event) || (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(KEYS_UNDO, event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isShift"])(event)))) {
      editorActions.trigger('redo');

      return true;
    }
  });

  // copy
  // CTRL/CMD + C
  addListener('copy', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(KEYS_COPY, event)) {
      editorActions.trigger('copy');

      return true;
    }
  });

  // paste
  // CTRL/CMD + V
  addListener('paste', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(KEYS_PASTE, event)) {
      editorActions.trigger('paste');

      return true;
    }
  });

  // zoom in one step
  // CTRL/CMD + +
  addListener('stepZoom', function(context) {

    var event = context.keyEvent;

    // quirk: it has to be triggered by `=` as well to work on international keyboard layout
    // cf: https://github.com/bpmn-io/bpmn-js/issues/1362#issuecomment-722989754
    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])([ '+', 'Add', '=' ], event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event)) {
      editorActions.trigger('stepZoom', { value: 1 });

      return true;
    }
  });

  // zoom out one step
  // CTRL + -
  addListener('stepZoom', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])([ '-', 'Subtract' ], event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event)) {
      editorActions.trigger('stepZoom', { value: -1 });

      return true;
    }
  });

  // zoom to the default level
  // CTRL + 0
  addListener('zoom', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])('0', event) && Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isCmd"])(event)) {
      editorActions.trigger('zoom', { value: 1 });

      return true;
    }
  });

  // delete selected element
  // DEL
  addListener('removeSelection', function(context) {

    var event = context.keyEvent;

    if (Object(_KeyboardUtil__WEBPACK_IMPORTED_MODULE_0__["isKey"])(['Backspace', 'Delete', 'Del' ], event)) {
      editorActions.trigger('removeSelection');

      return true;
    }
  });
};

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/keyboard/KeyboardUtil.js":
/*!***********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/keyboard/KeyboardUtil.js ***!
  \***********************************************************************/
/*! exports provided: hasModifier, isCmd, isKey, isShift */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasModifier", function() { return hasModifier; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isCmd", function() { return isCmd; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isKey", function() { return isKey; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isShift", function() { return isShift; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


/**
 * Returns true if event was triggered with any modifier
 * @param {KeyboardEvent} event
 */
function hasModifier(event) {
  return (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey);
}

/**
 * @param {KeyboardEvent} event
 */
function isCmd(event) {

  // ensure we don't react to AltGr
  // (mapped to CTRL + ALT)
  if (event.altKey) {
    return false;
  }

  return event.ctrlKey || event.metaKey;
}

/**
 * Checks if key pressed is one of provided keys.
 *
 * @param {string|Array<string>} keys
 * @param {KeyboardEvent} event
 */
function isKey(keys, event) {
  keys = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(keys) ? keys : [ keys ];

  return keys.indexOf(event.key) !== -1 || keys.indexOf(event.keyCode) !== -1;
}

/**
 * @param {KeyboardEvent} event
 */
function isShift(event) {
  return event.shiftKey;
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/keyboard/index.js":
/*!****************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/keyboard/index.js ***!
  \****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Keyboard__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Keyboard */ "./node_modules/diagram-js/lib/features/keyboard/Keyboard.js");
/* harmony import */ var _KeyboardBindings__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./KeyboardBindings */ "./node_modules/diagram-js/lib/features/keyboard/KeyboardBindings.js");



/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'keyboard', 'keyboardBindings' ],
  keyboard: [ 'type', _Keyboard__WEBPACK_IMPORTED_MODULE_0__["default"] ],
  keyboardBindings: [ 'type', _KeyboardBindings__WEBPACK_IMPORTED_MODULE_1__["default"] ]
});


/***/ }),

/***/ "./node_modules/diagram-js/lib/features/outline/Outline.js":
/*!*****************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/outline/Outline.js ***!
  \*****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Outline; });
/* harmony import */ var _util_Elements__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../util/Elements */ "./node_modules/diagram-js/lib/util/Elements.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


var LOW_PRIORITY = 500;








/**
 * @class
 *
 * A plugin that adds an outline to shapes and connections that may be activated and styled
 * via CSS classes.
 *
 * @param {EventBus} eventBus
 * @param {Styles} styles
 * @param {ElementRegistry} elementRegistry
 */
function Outline(eventBus, styles, elementRegistry) {

  this.offset = 6;

  var OUTLINE_STYLE = styles.cls('djs-outline', [ 'no-fill' ]);

  var self = this;

  function createOutline(gfx, bounds) {
    var outline = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["create"])('rect');

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(outline, Object(min_dash__WEBPACK_IMPORTED_MODULE_3__["assign"])({
      x: 10,
      y: 10,
      width: 100,
      height: 100
    }, OUTLINE_STYLE));

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["append"])(gfx, outline);

    return outline;
  }

  // A low priortity is necessary, because outlines of labels have to be updated
  // after the label bounds have been updated in the renderer.
  eventBus.on([ 'shape.added', 'shape.changed' ], LOW_PRIORITY, function(event) {
    var element = event.element,
        gfx = event.gfx;

    var outline = Object(min_dom__WEBPACK_IMPORTED_MODULE_2__["query"])('.djs-outline', gfx);

    if (!outline) {
      outline = createOutline(gfx, element);
    }

    self.updateShapeOutline(outline, element);
  });

  eventBus.on([ 'connection.added', 'connection.changed' ], function(event) {
    var element = event.element,
        gfx = event.gfx;

    var outline = Object(min_dom__WEBPACK_IMPORTED_MODULE_2__["query"])('.djs-outline', gfx);

    if (!outline) {
      outline = createOutline(gfx, element);
    }

    self.updateConnectionOutline(outline, element);
  });
}


/**
 * Updates the outline of a shape respecting the dimension of the
 * element and an outline offset.
 *
 * @param  {SVGElement} outline
 * @param  {djs.model.Base} element
 */
Outline.prototype.updateShapeOutline = function(outline, element) {

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(outline, {
    x: -this.offset,
    y: -this.offset,
    width: element.width + this.offset * 2,
    height: element.height + this.offset * 2
  });

};


/**
 * Updates the outline of a connection respecting the bounding box of
 * the connection and an outline offset.
 *
 * @param  {SVGElement} outline
 * @param  {djs.model.Base} element
 */
Outline.prototype.updateConnectionOutline = function(outline, connection) {

  var bbox = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_0__["getBBox"])(connection);

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(outline, {
    x: bbox.x - this.offset,
    y: bbox.y - this.offset,
    width: bbox.width + this.offset * 2,
    height: bbox.height + this.offset * 2
  });

};


Outline.$inject = ['eventBus', 'styles', 'elementRegistry'];

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/outline/index.js":
/*!***************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/outline/index.js ***!
  \***************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Outline__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Outline */ "./node_modules/diagram-js/lib/features/outline/Outline.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'outline' ],
  outline: [ 'type', _Outline__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/overlays/Overlays.js":
/*!*******************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/overlays/Overlays.js ***!
  \*******************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Overlays; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var _util_Elements__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../util/Elements */ "./node_modules/diagram-js/lib/util/Elements.js");
/* harmony import */ var _util_IdGenerator__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../../util/IdGenerator */ "./node_modules/diagram-js/lib/util/IdGenerator.js");








// document wide unique overlay ids
var ids = new _util_IdGenerator__WEBPACK_IMPORTED_MODULE_3__["default"]('ov');

var LOW_PRIORITY = 500;


/**
 * A service that allows users to attach overlays to diagram elements.
 *
 * The overlay service will take care of overlay positioning during updates.
 *
 * @example
 *
 * // add a pink badge on the top left of the shape
 * overlays.add(someShape, {
 *   position: {
 *     top: -5,
 *     left: -5
 *   },
 *   html: '<div style="width: 10px; background: fuchsia; color: white;">0</div>'
 * });
 *
 * // or add via shape id
 *
 * overlays.add('some-element-id', {
 *   position: {
 *     top: -5,
 *     left: -5
 *   }
 *   html: '<div style="width: 10px; background: fuchsia; color: white;">0</div>'
 * });
 *
 * // or add with optional type
 *
 * overlays.add(someShape, 'badge', {
 *   position: {
 *     top: -5,
 *     left: -5
 *   }
 *   html: '<div style="width: 10px; background: fuchsia; color: white;">0</div>'
 * });
 *
 *
 * // remove an overlay
 *
 * var id = overlays.add(...);
 * overlays.remove(id);
 *
 *
 * You may configure overlay defaults during tool by providing a `config` module
 * with `overlays.defaults` as an entry:
 *
 * {
 *   overlays: {
 *     defaults: {
 *       show: {
 *         minZoom: 0.7,
 *         maxZoom: 5.0
 *       },
 *       scale: {
 *         min: 1
 *       }
 *     }
 * }
 *
 * @param {Object} config
 * @param {EventBus} eventBus
 * @param {Canvas} canvas
 * @param {ElementRegistry} elementRegistry
 */
function Overlays(config, eventBus, canvas, elementRegistry) {

  this._eventBus = eventBus;
  this._canvas = canvas;
  this._elementRegistry = elementRegistry;

  this._ids = ids;

  this._overlayDefaults = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({

    // no show constraints
    show: null,

    // always scale
    scale: true
  }, config && config.defaults);

  /**
   * Mapping overlayId -> overlay
   */
  this._overlays = {};

  /**
   * Mapping elementId -> overlay container
   */
  this._overlayContainers = [];

  // root html element for all overlays
  this._overlayRoot = createRoot(canvas.getContainer());

  this._init();
}


Overlays.$inject = [
  'config.overlays',
  'eventBus',
  'canvas',
  'elementRegistry'
];


/**
 * Returns the overlay with the specified id or a list of overlays
 * for an element with a given type.
 *
 * @example
 *
 * // return the single overlay with the given id
 * overlays.get('some-id');
 *
 * // return all overlays for the shape
 * overlays.get({ element: someShape });
 *
 * // return all overlays on shape with type 'badge'
 * overlays.get({ element: someShape, type: 'badge' });
 *
 * // shape can also be specified as id
 * overlays.get({ element: 'element-id', type: 'badge' });
 *
 *
 * @param {Object} search
 * @param {string} [search.id]
 * @param {string|djs.model.Base} [search.element]
 * @param {string} [search.type]
 *
 * @return {Object|Array<Object>} the overlay(s)
 */
Overlays.prototype.get = function(search) {

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(search)) {
    search = { id: search };
  }

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(search.element)) {
    search.element = this._elementRegistry.get(search.element);
  }

  if (search.element) {
    var container = this._getOverlayContainer(search.element, true);

    // return a list of overlays when searching by element (+type)
    if (container) {
      return search.type ? Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(container.overlays, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["matchPattern"])({ type: search.type })) : container.overlays.slice();
    } else {
      return [];
    }
  } else
  if (search.type) {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(this._overlays, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["matchPattern"])({ type: search.type }));
  } else {

    // return single element when searching by id
    return search.id ? this._overlays[search.id] : null;
  }
};

/**
 * Adds a HTML overlay to an element.
 *
 * @param {string|djs.model.Base}   element   attach overlay to this shape
 * @param {string}                  [type]    optional type to assign to the overlay
 * @param {Object}                  overlay   the overlay configuration
 *
 * @param {string|DOMElement}       overlay.html                 html element to use as an overlay
 * @param {Object}                  [overlay.show]               show configuration
 * @param {number}                  [overlay.show.minZoom]       minimal zoom level to show the overlay
 * @param {number}                  [overlay.show.maxZoom]       maximum zoom level to show the overlay
 * @param {Object}                  overlay.position             where to attach the overlay
 * @param {number}                  [overlay.position.left]      relative to element bbox left attachment
 * @param {number}                  [overlay.position.top]       relative to element bbox top attachment
 * @param {number}                  [overlay.position.bottom]    relative to element bbox bottom attachment
 * @param {number}                  [overlay.position.right]     relative to element bbox right attachment
 * @param {boolean|Object}          [overlay.scale=true]         false to preserve the same size regardless of
 *                                                               diagram zoom
 * @param {number}                  [overlay.scale.min]
 * @param {number}                  [overlay.scale.max]
 *
 * @return {string}                 id that may be used to reference the overlay for update or removal
 */
Overlays.prototype.add = function(element, type, overlay) {

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isObject"])(type)) {
    overlay = type;
    type = null;
  }

  if (!element.id) {
    element = this._elementRegistry.get(element);
  }

  if (!overlay.position) {
    throw new Error('must specifiy overlay position');
  }

  if (!overlay.html) {
    throw new Error('must specifiy overlay html');
  }

  if (!element) {
    throw new Error('invalid element specified');
  }

  var id = this._ids.next();

  overlay = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, this._overlayDefaults, overlay, {
    id: id,
    type: type,
    element: element,
    html: overlay.html
  });

  this._addOverlay(overlay);

  return id;
};


/**
 * Remove an overlay with the given id or all overlays matching the given filter.
 *
 * @see Overlays#get for filter options.
 *
 * @param {string} [id]
 * @param {Object} [filter]
 */
Overlays.prototype.remove = function(filter) {

  var overlays = this.get(filter) || [];

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(overlays)) {
    overlays = [ overlays ];
  }

  var self = this;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(overlays, function(overlay) {

    var container = self._getOverlayContainer(overlay.element, true);

    if (overlay) {
      Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["remove"])(overlay.html);
      Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["remove"])(overlay.htmlContainer);

      delete overlay.htmlContainer;
      delete overlay.element;

      delete self._overlays[overlay.id];
    }

    if (container) {
      var idx = container.overlays.indexOf(overlay);
      if (idx !== -1) {
        container.overlays.splice(idx, 1);
      }
    }
  });

};


Overlays.prototype.show = function() {
  setVisible(this._overlayRoot);
};


Overlays.prototype.hide = function() {
  setVisible(this._overlayRoot, false);
};

Overlays.prototype.clear = function() {
  this._overlays = {};

  this._overlayContainers = [];

  Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["clear"])(this._overlayRoot);
};

Overlays.prototype._updateOverlayContainer = function(container) {
  var element = container.element,
      html = container.html;

  // update container left,top according to the elements x,y coordinates
  // this ensures we can attach child elements relative to this container

  var x = element.x,
      y = element.y;

  if (element.waypoints) {
    var bbox = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_2__["getBBox"])(element);
    x = bbox.x;
    y = bbox.y;
  }

  setPosition(html, x, y);

  Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["attr"])(container.html, 'data-container-id', element.id);
};


Overlays.prototype._updateOverlay = function(overlay) {

  var position = overlay.position,
      htmlContainer = overlay.htmlContainer,
      element = overlay.element;

  // update overlay html relative to shape because
  // it is already positioned on the element

  // update relative
  var left = position.left,
      top = position.top;

  if (position.right !== undefined) {

    var width;

    if (element.waypoints) {
      width = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_2__["getBBox"])(element).width;
    } else {
      width = element.width;
    }

    left = position.right * -1 + width;
  }

  if (position.bottom !== undefined) {

    var height;

    if (element.waypoints) {
      height = Object(_util_Elements__WEBPACK_IMPORTED_MODULE_2__["getBBox"])(element).height;
    } else {
      height = element.height;
    }

    top = position.bottom * -1 + height;
  }

  setPosition(htmlContainer, left || 0, top || 0);
};


Overlays.prototype._createOverlayContainer = function(element) {
  var html = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])('<div class="djs-overlays" style="position: absolute" />');

  this._overlayRoot.appendChild(html);

  var container = {
    html: html,
    element: element,
    overlays: []
  };

  this._updateOverlayContainer(container);

  this._overlayContainers.push(container);

  return container;
};


Overlays.prototype._updateRoot = function(viewbox) {
  var scale = viewbox.scale || 1;

  var matrix = 'matrix(' +
  [
    scale,
    0,
    0,
    scale,
    -1 * viewbox.x * scale,
    -1 * viewbox.y * scale
  ].join(',') +
  ')';

  setTransform(this._overlayRoot, matrix);
};


Overlays.prototype._getOverlayContainer = function(element, raw) {
  var container = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(this._overlayContainers, function(c) {
    return c.element === element;
  });


  if (!container && !raw) {
    return this._createOverlayContainer(element);
  }

  return container;
};


Overlays.prototype._addOverlay = function(overlay) {

  var id = overlay.id,
      element = overlay.element,
      html = overlay.html,
      htmlContainer,
      overlayContainer;

  // unwrap jquery (for those who need it)
  if (html.get && html.constructor.prototype.jquery) {
    html = html.get(0);
  }

  // create proper html elements from
  // overlay HTML strings
  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(html)) {
    html = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])(html);
  }

  overlayContainer = this._getOverlayContainer(element);

  htmlContainer = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])('<div class="djs-overlay" data-overlay-id="' + id + '" style="position: absolute">');

  htmlContainer.appendChild(html);

  if (overlay.type) {
    Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["classes"])(htmlContainer).add('djs-overlay-' + overlay.type);
  }

  overlay.htmlContainer = htmlContainer;

  overlayContainer.overlays.push(overlay);
  overlayContainer.html.appendChild(htmlContainer);

  this._overlays[id] = overlay;

  this._updateOverlay(overlay);
  this._updateOverlayVisibilty(overlay, this._canvas.viewbox());
};


Overlays.prototype._updateOverlayVisibilty = function(overlay, viewbox) {
  var show = overlay.show,
      minZoom = show && show.minZoom,
      maxZoom = show && show.maxZoom,
      htmlContainer = overlay.htmlContainer,
      visible = true;

  if (show) {
    if (
      (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isDefined"])(minZoom) && minZoom > viewbox.scale) ||
      (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isDefined"])(maxZoom) && maxZoom < viewbox.scale)
    ) {
      visible = false;
    }

    setVisible(htmlContainer, visible);
  }

  this._updateOverlayScale(overlay, viewbox);
};


Overlays.prototype._updateOverlayScale = function(overlay, viewbox) {
  var shouldScale = overlay.scale,
      minScale,
      maxScale,
      htmlContainer = overlay.htmlContainer;

  var scale, transform = '';

  if (shouldScale !== true) {

    if (shouldScale === false) {
      minScale = 1;
      maxScale = 1;
    } else {
      minScale = shouldScale.min;
      maxScale = shouldScale.max;
    }

    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isDefined"])(minScale) && viewbox.scale < minScale) {
      scale = (1 / viewbox.scale || 1) * minScale;
    }

    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isDefined"])(maxScale) && viewbox.scale > maxScale) {
      scale = (1 / viewbox.scale || 1) * maxScale;
    }
  }

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isDefined"])(scale)) {
    transform = 'scale(' + scale + ',' + scale + ')';
  }

  setTransform(htmlContainer, transform);
};


Overlays.prototype._updateOverlaysVisibilty = function(viewbox) {

  var self = this;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(this._overlays, function(overlay) {
    self._updateOverlayVisibilty(overlay, viewbox);
  });
};


Overlays.prototype._init = function() {

  var eventBus = this._eventBus;

  var self = this;


  // scroll/zoom integration

  function updateViewbox(viewbox) {
    self._updateRoot(viewbox);
    self._updateOverlaysVisibilty(viewbox);

    self.show();
  }

  eventBus.on('canvas.viewbox.changing', function(event) {
    self.hide();
  });

  eventBus.on('canvas.viewbox.changed', function(event) {
    updateViewbox(event.viewbox);
  });


  // remove integration

  eventBus.on([ 'shape.remove', 'connection.remove' ], function(e) {
    var element = e.element;
    var overlays = self.get({ element: element });

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(overlays, function(o) {
      self.remove(o.id);
    });

    var container = self._getOverlayContainer(element);

    if (container) {
      Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["remove"])(container.html);
      var i = self._overlayContainers.indexOf(container);
      if (i !== -1) {
        self._overlayContainers.splice(i, 1);
      }
    }
  });


  // move integration

  eventBus.on('element.changed', LOW_PRIORITY, function(e) {
    var element = e.element;

    var container = self._getOverlayContainer(element, true);

    if (container) {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(container.overlays, function(overlay) {
        self._updateOverlay(overlay);
      });

      self._updateOverlayContainer(container);
    }
  });


  // marker integration, simply add them on the overlays as classes, too.

  eventBus.on('element.marker.update', function(e) {
    var container = self._getOverlayContainer(e.element, true);
    if (container) {
      Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["classes"])(container.html)[e.add ? 'add' : 'remove'](e.marker);
    }
  });


  // clear overlays with diagram

  eventBus.on('diagram.clear', this.clear, this);
};



// helpers /////////////////////////////

function createRoot(parentNode) {
  var root = Object(min_dom__WEBPACK_IMPORTED_MODULE_1__["domify"])(
    '<div class="djs-overlay-container" style="position: absolute; width: 0; height: 0;" />'
  );

  parentNode.insertBefore(root, parentNode.firstChild);

  return root;
}

function setPosition(el, x, y) {
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(el.style, { left: x + 'px', top: y + 'px' });
}

function setVisible(el, visible) {
  el.style.display = visible === false ? 'none' : '';
}

function setTransform(el, transform) {

  el.style['transform-origin'] = 'top left';

  [ '', '-ms-', '-webkit-' ].forEach(function(prefix) {
    el.style[prefix + 'transform'] = transform;
  });
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/overlays/index.js":
/*!****************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/overlays/index.js ***!
  \****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Overlays__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Overlays */ "./node_modules/diagram-js/lib/features/overlays/Overlays.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'overlays' ],
  overlays: [ 'type', _Overlays__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/selection/Selection.js":
/*!*********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/selection/Selection.js ***!
  \*********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Selection; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");



/**
 * A service that offers the current selection in a diagram.
 * Offers the api to control the selection, too.
 *
 * @class
 *
 * @param {EventBus} eventBus the event bus
 */
function Selection(eventBus) {

  this._eventBus = eventBus;

  this._selectedElements = [];

  var self = this;

  eventBus.on([ 'shape.remove', 'connection.remove' ], function(e) {
    var element = e.element;
    self.deselect(element);
  });

  eventBus.on([ 'diagram.clear' ], function(e) {
    self.select(null);
  });
}

Selection.$inject = [ 'eventBus' ];


Selection.prototype.deselect = function(element) {
  var selectedElements = this._selectedElements;

  var idx = selectedElements.indexOf(element);

  if (idx !== -1) {
    var oldSelection = selectedElements.slice();

    selectedElements.splice(idx, 1);

    this._eventBus.fire('selection.changed', { oldSelection: oldSelection, newSelection: selectedElements });
  }
};


Selection.prototype.get = function() {
  return this._selectedElements;
};

Selection.prototype.isSelected = function(element) {
  return this._selectedElements.indexOf(element) !== -1;
};


/**
 * This method selects one or more elements on the diagram.
 *
 * By passing an additional add parameter you can decide whether or not the element(s)
 * should be added to the already existing selection or not.
 *
 * @method Selection#select
 *
 * @param  {Object|Object[]} elements element or array of elements to be selected
 * @param  {boolean} [add] whether the element(s) should be appended to the current selection, defaults to false
 */
Selection.prototype.select = function(elements, add) {
  var selectedElements = this._selectedElements,
      oldSelection = selectedElements.slice();

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(elements)) {
    elements = elements ? [ elements ] : [];
  }

  // selection may be cleared by passing an empty array or null
  // to the method
  if (add) {
    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(elements, function(element) {
      if (selectedElements.indexOf(element) !== -1) {

        // already selected
        return;
      } else {
        selectedElements.push(element);
      }
    });
  } else {
    this._selectedElements = selectedElements = elements.slice();
  }

  this._eventBus.fire('selection.changed', { oldSelection: oldSelection, newSelection: selectedElements });
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/features/selection/SelectionBehavior.js":
/*!*****************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/selection/SelectionBehavior.js ***!
  \*****************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return SelectionBehavior; });
/* harmony import */ var _util_Mouse__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../util/Mouse */ "./node_modules/diagram-js/lib/util/Mouse.js");
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");





function SelectionBehavior(eventBus, selection, canvas, elementRegistry) {

  // Select elements on create
  eventBus.on('create.end', 500, function(event) {
    var context = event.context,
        canExecute = context.canExecute,
        elements = context.elements,
        hints = context.hints || {},
        autoSelect = hints.autoSelect;

    if (canExecute) {
      if (autoSelect === false) {

        // Select no elements
        return;
      }

      if (Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["isArray"])(autoSelect)) {
        selection.select(autoSelect);
      } else {

        // Select all elements by default
        selection.select(elements.filter(isShown));
      }
    }
  });

  // Select connection targets on connect
  eventBus.on('connect.end', 500, function(event) {
    var context = event.context,
        canExecute = context.canExecute,
        hover = context.hover;

    if (canExecute && hover) {
      selection.select(hover);
    }
  });

  // Select shapes on move
  eventBus.on('shape.move.end', 500, function(event) {
    var previousSelection = event.previousSelection || [];

    var shape = elementRegistry.get(event.context.shape.id);

    // Always select main shape on move
    var isSelected = Object(min_dash__WEBPACK_IMPORTED_MODULE_1__["find"])(previousSelection, function(selectedShape) {
      return shape.id === selectedShape.id;
    });

    if (!isSelected) {
      selection.select(shape);
    }
  });

  // Select elements on click
  eventBus.on('element.click', function(event) {

    if (!Object(_util_Mouse__WEBPACK_IMPORTED_MODULE_0__["isPrimaryButton"])(event)) {
      return;
    }

    var element = event.element;

    if (element === canvas.getRootElement()) {
      element = null;
    }

    var isSelected = selection.isSelected(element),
        isMultiSelect = selection.get().length > 1;

    // Add to selection if CTRL or SHIFT pressed
    var add = Object(_util_Mouse__WEBPACK_IMPORTED_MODULE_0__["hasPrimaryModifier"])(event) || Object(_util_Mouse__WEBPACK_IMPORTED_MODULE_0__["hasSecondaryModifier"])(event);

    if (isSelected && isMultiSelect) {
      if (add) {

        // Deselect element
        return selection.deselect(element);
      } else {

        // Select element only
        return selection.select(element);
      }
    } else if (!isSelected) {

      // Select element
      selection.select(element, add);
    } else {

      // Deselect element
      selection.deselect(element);
    }
  });
}

SelectionBehavior.$inject = [
  'eventBus',
  'selection',
  'canvas',
  'elementRegistry'
];


function isShown(element) {
  return !element.hidden;
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/features/selection/SelectionVisuals.js":
/*!****************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/selection/SelectionVisuals.js ***!
  \****************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return SelectionVisuals; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


var MARKER_HOVER = 'hover',
    MARKER_SELECTED = 'selected';


/**
 * A plugin that adds a visible selection UI to shapes and connections
 * by appending the <code>hover</code> and <code>selected</code> classes to them.
 *
 * @class
 *
 * Makes elements selectable, too.
 *
 * @param {EventBus} events
 * @param {SelectionService} selection
 * @param {Canvas} canvas
 */
function SelectionVisuals(events, canvas, selection, styles) {

  this._multiSelectionBox = null;

  function addMarker(e, cls) {
    canvas.addMarker(e, cls);
  }

  function removeMarker(e, cls) {
    canvas.removeMarker(e, cls);
  }

  events.on('element.hover', function(event) {
    addMarker(event.element, MARKER_HOVER);
  });

  events.on('element.out', function(event) {
    removeMarker(event.element, MARKER_HOVER);
  });

  events.on('selection.changed', function(event) {

    function deselect(s) {
      removeMarker(s, MARKER_SELECTED);
    }

    function select(s) {
      addMarker(s, MARKER_SELECTED);
    }

    var oldSelection = event.oldSelection,
        newSelection = event.newSelection;

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(oldSelection, function(e) {
      if (newSelection.indexOf(e) === -1) {
        deselect(e);
      }
    });

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(newSelection, function(e) {
      if (oldSelection.indexOf(e) === -1) {
        select(e);
      }
    });
  });
}

SelectionVisuals.$inject = [
  'eventBus',
  'canvas',
  'selection',
  'styles'
];

/***/ }),

/***/ "./node_modules/diagram-js/lib/features/selection/index.js":
/*!*****************************************************************!*\
  !*** ./node_modules/diagram-js/lib/features/selection/index.js ***!
  \*****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _interaction_events__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../interaction-events */ "./node_modules/diagram-js/lib/features/interaction-events/index.js");
/* harmony import */ var _outline__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../outline */ "./node_modules/diagram-js/lib/features/outline/index.js");
/* harmony import */ var _Selection__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./Selection */ "./node_modules/diagram-js/lib/features/selection/Selection.js");
/* harmony import */ var _SelectionVisuals__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./SelectionVisuals */ "./node_modules/diagram-js/lib/features/selection/SelectionVisuals.js");
/* harmony import */ var _SelectionBehavior__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./SelectionBehavior */ "./node_modules/diagram-js/lib/features/selection/SelectionBehavior.js");








/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'selectionVisuals', 'selectionBehavior' ],
  __depends__: [
    _interaction_events__WEBPACK_IMPORTED_MODULE_0__["default"],
    _outline__WEBPACK_IMPORTED_MODULE_1__["default"]
  ],
  selection: [ 'type', _Selection__WEBPACK_IMPORTED_MODULE_2__["default"] ],
  selectionVisuals: [ 'type', _SelectionVisuals__WEBPACK_IMPORTED_MODULE_3__["default"] ],
  selectionBehavior: [ 'type', _SelectionBehavior__WEBPACK_IMPORTED_MODULE_4__["default"] ]
});


/***/ }),

/***/ "./node_modules/diagram-js/lib/i18n/translate/index.js":
/*!*************************************************************!*\
  !*** ./node_modules/diagram-js/lib/i18n/translate/index.js ***!
  \*************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _translate__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./translate */ "./node_modules/diagram-js/lib/i18n/translate/translate.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  translate: [ 'value', _translate__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/i18n/translate/translate.js":
/*!*****************************************************************!*\
  !*** ./node_modules/diagram-js/lib/i18n/translate/translate.js ***!
  \*****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return translate; });
/**
 * A simple translation stub to be used for multi-language support
 * in diagrams. Can be easily replaced with a more sophisticated
 * solution.
 *
 * @example
 *
 * // use it inside any diagram component by injecting `translate`.
 *
 * function MyService(translate) {
 *   alert(translate('HELLO {you}', { you: 'You!' }));
 * }
 *
 * @param {string} template to interpolate
 * @param {Object} [replacements] a map with substitutes
 *
 * @return {string} the translated string
 */
function translate(template, replacements) {

  replacements = replacements || {};

  return template.replace(/{([^}]+)}/g, function(_, key) {
    return replacements[key] || '{' + key + '}';
  });
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/layout/LayoutUtil.js":
/*!**********************************************************!*\
  !*** ./node_modules/diagram-js/lib/layout/LayoutUtil.js ***!
  \**********************************************************/
/*! exports provided: roundBounds, roundPoint, asTRBL, asBounds, getMid, getOrientation, getElementLineIntersection, getIntersections, filterRedundantWaypoints */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "roundBounds", function() { return roundBounds; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "roundPoint", function() { return roundPoint; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "asTRBL", function() { return asTRBL; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "asBounds", function() { return asBounds; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getMid", function() { return getMid; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getOrientation", function() { return getOrientation; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getElementLineIntersection", function() { return getElementLineIntersection; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getIntersections", function() { return getIntersections; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "filterRedundantWaypoints", function() { return filterRedundantWaypoints; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var _util_Geometry__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../util/Geometry */ "./node_modules/diagram-js/lib/util/Geometry.js");
/* harmony import */ var path_intersection__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! path-intersection */ "./node_modules/path-intersection/intersect.js");
/* harmony import */ var path_intersection__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(path_intersection__WEBPACK_IMPORTED_MODULE_2__);







function roundBounds(bounds) {
  return {
    x: Math.round(bounds.x),
    y: Math.round(bounds.y),
    width: Math.round(bounds.width),
    height: Math.round(bounds.height)
  };
}


function roundPoint(point) {

  return {
    x: Math.round(point.x),
    y: Math.round(point.y)
  };
}


/**
 * Convert the given bounds to a { top, left, bottom, right } descriptor.
 *
 * @param {Bounds|Point} bounds
 *
 * @return {Object}
 */
function asTRBL(bounds) {
  return {
    top: bounds.y,
    right: bounds.x + (bounds.width || 0),
    bottom: bounds.y + (bounds.height || 0),
    left: bounds.x
  };
}


/**
 * Convert a { top, left, bottom, right } to an objects bounds.
 *
 * @param {Object} trbl
 *
 * @return {Bounds}
 */
function asBounds(trbl) {
  return {
    x: trbl.left,
    y: trbl.top,
    width: trbl.right - trbl.left,
    height: trbl.bottom - trbl.top
  };
}


/**
 * Get the mid of the given bounds or point.
 *
 * @param {Bounds|Point} bounds
 *
 * @return {Point}
 */
function getMid(bounds) {
  return roundPoint({
    x: bounds.x + (bounds.width || 0) / 2,
    y: bounds.y + (bounds.height || 0) / 2
  });
}


// orientation utils //////////////////////

/**
 * Get orientation of the given rectangle with respect to
 * the reference rectangle.
 *
 * A padding (positive or negative) may be passed to influence
 * horizontal / vertical orientation and intersection.
 *
 * @param {Bounds} rect
 * @param {Bounds} reference
 * @param {Point|number} padding
 *
 * @return {string} the orientation; one of top, top-left, left, ..., bottom, right or intersect.
 */
function getOrientation(rect, reference, padding) {

  padding = padding || 0;

  // make sure we can use an object, too
  // for individual { x, y } padding
  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isObject"])(padding)) {
    padding = { x: padding, y: padding };
  }


  var rectOrientation = asTRBL(rect),
      referenceOrientation = asTRBL(reference);

  var top = rectOrientation.bottom + padding.y <= referenceOrientation.top,
      right = rectOrientation.left - padding.x >= referenceOrientation.right,
      bottom = rectOrientation.top - padding.y >= referenceOrientation.bottom,
      left = rectOrientation.right + padding.x <= referenceOrientation.left;

  var vertical = top ? 'top' : (bottom ? 'bottom' : null),
      horizontal = left ? 'left' : (right ? 'right' : null);

  if (horizontal && vertical) {
    return vertical + '-' + horizontal;
  } else {
    return horizontal || vertical || 'intersect';
  }
}


// intersection utils //////////////////////

/**
 * Get intersection between an element and a line path.
 *
 * @param {PathDef} elementPath
 * @param {PathDef} linePath
 * @param {boolean} cropStart crop from start or end
 *
 * @return {Point}
 */
function getElementLineIntersection(elementPath, linePath, cropStart) {

  var intersections = getIntersections(elementPath, linePath);

  // recognize intersections
  // only one -> choose
  // two close together -> choose first
  // two or more distinct -> pull out appropriate one
  // none -> ok (fallback to point itself)
  if (intersections.length === 1) {
    return roundPoint(intersections[0]);
  } else if (intersections.length === 2 && Object(_util_Geometry__WEBPACK_IMPORTED_MODULE_1__["pointDistance"])(intersections[0], intersections[1]) < 1) {
    return roundPoint(intersections[0]);
  } else if (intersections.length > 1) {

    // sort by intersections based on connection segment +
    // distance from start
    intersections = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["sortBy"])(intersections, function(i) {
      var distance = Math.floor(i.t2 * 100) || 1;

      distance = 100 - distance;

      distance = (distance < 10 ? '0' : '') + distance;

      // create a sort string that makes sure we sort
      // line segment ASC + line segment position DESC (for cropStart)
      // line segment ASC + line segment position ASC (for cropEnd)
      return i.segment2 + '#' + distance;
    });

    return roundPoint(intersections[cropStart ? 0 : intersections.length - 1]);
  }

  return null;
}


function getIntersections(a, b) {
  return path_intersection__WEBPACK_IMPORTED_MODULE_2___default()(a, b);
}


function filterRedundantWaypoints(waypoints) {

  // alter copy of waypoints, not original
  waypoints = waypoints.slice();

  var idx = 0,
      point,
      previousPoint,
      nextPoint;

  while (waypoints[idx]) {
    point = waypoints[idx];
    previousPoint = waypoints[idx - 1];
    nextPoint = waypoints[idx + 1];

    if (Object(_util_Geometry__WEBPACK_IMPORTED_MODULE_1__["pointDistance"])(point, nextPoint) === 0 ||
        Object(_util_Geometry__WEBPACK_IMPORTED_MODULE_1__["pointsOnLine"])(previousPoint, nextPoint, point)) {

      // remove point, if overlapping with {nextPoint}
      // or on line with {previousPoint} -> {point} -> {nextPoint}
      waypoints.splice(idx, 1);
    } else {
      idx++;
    }
  }

  return waypoints;
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/model/index.js":
/*!****************************************************!*\
  !*** ./node_modules/diagram-js/lib/model/index.js ***!
  \****************************************************/
/*! exports provided: Base, Shape, Root, Label, Connection, create */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Base", function() { return Base; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Shape", function() { return Shape; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Root", function() { return Root; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Label", function() { return Label; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Connection", function() { return Connection; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "create", function() { return create; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! inherits */ "./node_modules/inherits/inherits_browser.js");
/* harmony import */ var inherits__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(inherits__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var object_refs__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! object-refs */ "./node_modules/object-refs/index.js");
/* harmony import */ var object_refs__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(object_refs__WEBPACK_IMPORTED_MODULE_2__);





var parentRefs = new object_refs__WEBPACK_IMPORTED_MODULE_2___default.a({ name: 'children', enumerable: true, collection: true }, { name: 'parent' }),
    labelRefs = new object_refs__WEBPACK_IMPORTED_MODULE_2___default.a({ name: 'labels', enumerable: true, collection: true }, { name: 'labelTarget' }),
    attacherRefs = new object_refs__WEBPACK_IMPORTED_MODULE_2___default.a({ name: 'attachers', collection: true }, { name: 'host' }),
    outgoingRefs = new object_refs__WEBPACK_IMPORTED_MODULE_2___default.a({ name: 'outgoing', collection: true }, { name: 'source' }),
    incomingRefs = new object_refs__WEBPACK_IMPORTED_MODULE_2___default.a({ name: 'incoming', collection: true }, { name: 'target' });

/**
 * @namespace djs.model
 */

/**
 * @memberOf djs.model
 */

/**
 * The basic graphical representation
 *
 * @class
 *
 * @abstract
 */
function Base() {

  /**
   * The object that backs up the shape
   *
   * @name Base#businessObject
   * @type Object
   */
  Object.defineProperty(this, 'businessObject', {
    writable: true
  });


  /**
   * Single label support, will mapped to multi label array
   *
   * @name Base#label
   * @type Object
   */
  Object.defineProperty(this, 'label', {
    get: function() {
      return this.labels[0];
    },
    set: function(newLabel) {

      var label = this.label,
          labels = this.labels;

      if (!newLabel && label) {
        labels.remove(label);
      } else {
        labels.add(newLabel, 0);
      }
    }
  });

  /**
   * The parent shape
   *
   * @name Base#parent
   * @type Shape
   */
  parentRefs.bind(this, 'parent');

  /**
   * The list of labels
   *
   * @name Base#labels
   * @type Label
   */
  labelRefs.bind(this, 'labels');

  /**
   * The list of outgoing connections
   *
   * @name Base#outgoing
   * @type Array<Connection>
   */
  outgoingRefs.bind(this, 'outgoing');

  /**
   * The list of incoming connections
   *
   * @name Base#incoming
   * @type Array<Connection>
   */
  incomingRefs.bind(this, 'incoming');
}


/**
 * A graphical object
 *
 * @class
 * @constructor
 *
 * @extends Base
 */
function Shape() {
  Base.call(this);

  /**
   * Indicates frame shapes
   *
   * @name Shape#isFrame
   * @type boolean
   */

  /**
   * The list of children
   *
   * @name Shape#children
   * @type Array<Base>
   */
  parentRefs.bind(this, 'children');

  /**
   * @name Shape#host
   * @type Shape
   */
  attacherRefs.bind(this, 'host');

  /**
   * @name Shape#attachers
   * @type Shape
   */
  attacherRefs.bind(this, 'attachers');
}

inherits__WEBPACK_IMPORTED_MODULE_1___default()(Shape, Base);


/**
 * A root graphical object
 *
 * @class
 * @constructor
 *
 * @extends Shape
 */
function Root() {
  Shape.call(this);
}

inherits__WEBPACK_IMPORTED_MODULE_1___default()(Root, Shape);


/**
 * A label for an element
 *
 * @class
 * @constructor
 *
 * @extends Shape
 */
function Label() {
  Shape.call(this);

  /**
   * The labeled element
   *
   * @name Label#labelTarget
   * @type Base
   */
  labelRefs.bind(this, 'labelTarget');
}

inherits__WEBPACK_IMPORTED_MODULE_1___default()(Label, Shape);


/**
 * A connection between two elements
 *
 * @class
 * @constructor
 *
 * @extends Base
 */
function Connection() {
  Base.call(this);

  /**
   * The element this connection originates from
   *
   * @name Connection#source
   * @type Base
   */
  outgoingRefs.bind(this, 'source');

  /**
   * The element this connection points to
   *
   * @name Connection#target
   * @type Base
   */
  incomingRefs.bind(this, 'target');
}

inherits__WEBPACK_IMPORTED_MODULE_1___default()(Connection, Base);


var types = {
  connection: Connection,
  shape: Shape,
  label: Label,
  root: Root
};

/**
 * Creates a new model element of the specified type
 *
 * @method create
 *
 * @example
 *
 * var shape1 = Model.create('shape', { x: 10, y: 10, width: 100, height: 100 });
 * var shape2 = Model.create('shape', { x: 210, y: 210, width: 100, height: 100 });
 *
 * var connection = Model.create('connection', { waypoints: [ { x: 110, y: 55 }, {x: 210, y: 55 } ] });
 *
 * @param  {string} type lower-cased model name
 * @param  {Object} attrs attributes to initialize the new model instance with
 *
 * @return {Base} the new model instance
 */
function create(type, attrs) {
  var Type = types[type];
  if (!Type) {
    throw new Error('unknown type: <' + type + '>');
  }
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(new Type(), attrs);
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/keyboard-move/KeyboardMove.js":
/*!******************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/keyboard-move/KeyboardMove.js ***!
  \******************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return KeyboardMove; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");



var DEFAULT_CONFIG = {
  moveSpeed: 50,
  moveSpeedAccelerated: 200
};


/**
 * A feature that allows users to move the canvas using the keyboard.
 *
 * @param {Object} config
 * @param {number} [config.moveSpeed=50]
 * @param {number} [config.moveSpeedAccelerated=200]
 * @param {Keyboard} keyboard
 * @param {Canvas} canvas
 */
function KeyboardMove(
    config,
    keyboard,
    canvas
) {

  var self = this;

  this._config = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, DEFAULT_CONFIG, config || {});

  keyboard.addListener(arrowsListener);


  function arrowsListener(context) {

    var event = context.keyEvent,
        config = self._config;

    if (!keyboard.isCmd(event)) {
      return;
    }

    if (keyboard.isKey([
      'ArrowLeft', 'Left',
      'ArrowUp', 'Up',
      'ArrowDown', 'Down',
      'ArrowRight', 'Right'
    ], event)) {

      var speed = (
        keyboard.isShift(event) ?
          config.moveSpeedAccelerated :
          config.moveSpeed
      );

      var direction;

      switch (event.key) {
      case 'ArrowLeft':
      case 'Left':
        direction = 'left';
        break;
      case 'ArrowUp':
      case 'Up':
        direction = 'up';
        break;
      case 'ArrowRight':
      case 'Right':
        direction = 'right';
        break;
      case 'ArrowDown':
      case 'Down':
        direction = 'down';
        break;
      }

      self.moveCanvas({
        speed: speed,
        direction: direction
      });

      return true;
    }
  }

  this.moveCanvas = function(opts) {

    var dx = 0,
        dy = 0,
        speed = opts.speed;

    var actualSpeed = speed / Math.min(Math.sqrt(canvas.viewbox().scale), 1);

    switch (opts.direction) {
    case 'left': // Left
      dx = actualSpeed;
      break;
    case 'up': // Up
      dy = actualSpeed;
      break;
    case 'right': // Right
      dx = -actualSpeed;
      break;
    case 'down': // Down
      dy = -actualSpeed;
      break;
    }

    canvas.scroll({
      dx: dx,
      dy: dy
    });
  };

}


KeyboardMove.$inject = [
  'config.keyboardMove',
  'keyboard',
  'canvas'
];


/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/keyboard-move/index.js":
/*!***********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/keyboard-move/index.js ***!
  \***********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _features_keyboard__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../features/keyboard */ "./node_modules/diagram-js/lib/features/keyboard/index.js");
/* harmony import */ var _KeyboardMove__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./KeyboardMove */ "./node_modules/diagram-js/lib/navigation/keyboard-move/KeyboardMove.js");





/* harmony default export */ __webpack_exports__["default"] = ({
  __depends__: [
    _features_keyboard__WEBPACK_IMPORTED_MODULE_0__["default"]
  ],
  __init__: [ 'keyboardMove' ],
  keyboardMove: [ 'type', _KeyboardMove__WEBPACK_IMPORTED_MODULE_1__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/movecanvas/MoveCanvas.js":
/*!*************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/movecanvas/MoveCanvas.js ***!
  \*************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return MoveCanvas; });
/* harmony import */ var _util_Cursor__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../util/Cursor */ "./node_modules/diagram-js/lib/util/Cursor.js");
/* harmony import */ var _util_ClickTrap__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../util/ClickTrap */ "./node_modules/diagram-js/lib/util/ClickTrap.js");
/* harmony import */ var _util_PositionUtil__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../util/PositionUtil */ "./node_modules/diagram-js/lib/util/PositionUtil.js");
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var _util_Event__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../../util/Event */ "./node_modules/diagram-js/lib/util/Event.js");











var THRESHOLD = 15;


/**
 * Move the canvas via mouse.
 *
 * @param {EventBus} eventBus
 * @param {Canvas} canvas
 */
function MoveCanvas(eventBus, canvas) {

  var context;


  // listen for move on element mouse down;
  // allow others to hook into the event before us though
  // (dragging / element moving will do this)
  eventBus.on('element.mousedown', 500, function(e) {
    return handleStart(e.originalEvent);
  });


  function handleMove(event) {

    var start = context.start,
        button = context.button,
        position = Object(_util_Event__WEBPACK_IMPORTED_MODULE_4__["toPoint"])(event),
        delta = Object(_util_PositionUtil__WEBPACK_IMPORTED_MODULE_2__["delta"])(position, start);

    if (!context.dragging && length(delta) > THRESHOLD) {
      context.dragging = true;

      if (button === 0) {
        Object(_util_ClickTrap__WEBPACK_IMPORTED_MODULE_1__["install"])(eventBus);
      }

      Object(_util_Cursor__WEBPACK_IMPORTED_MODULE_0__["set"])('grab');
    }

    if (context.dragging) {

      var lastPosition = context.last || context.start;

      delta = Object(_util_PositionUtil__WEBPACK_IMPORTED_MODULE_2__["delta"])(position, lastPosition);

      canvas.scroll({
        dx: delta.x,
        dy: delta.y
      });

      context.last = position;
    }

    // prevent select
    event.preventDefault();
  }


  function handleEnd(event) {
    min_dom__WEBPACK_IMPORTED_MODULE_3__["event"].unbind(document, 'mousemove', handleMove);
    min_dom__WEBPACK_IMPORTED_MODULE_3__["event"].unbind(document, 'mouseup', handleEnd);

    context = null;

    Object(_util_Cursor__WEBPACK_IMPORTED_MODULE_0__["unset"])();
  }

  function handleStart(event) {

    // event is already handled by '.djs-draggable'
    if (Object(min_dom__WEBPACK_IMPORTED_MODULE_3__["closest"])(event.target, '.djs-draggable')) {
      return;
    }

    var button = event.button;

    // reject right mouse button or modifier key
    if (button >= 2 || event.ctrlKey || event.shiftKey || event.altKey) {
      return;
    }

    context = {
      button: button,
      start: Object(_util_Event__WEBPACK_IMPORTED_MODULE_4__["toPoint"])(event)
    };

    min_dom__WEBPACK_IMPORTED_MODULE_3__["event"].bind(document, 'mousemove', handleMove);
    min_dom__WEBPACK_IMPORTED_MODULE_3__["event"].bind(document, 'mouseup', handleEnd);

    // we've handled the event
    return true;
  }

  this.isActive = function() {
    return !!context;
  };

}


MoveCanvas.$inject = [
  'eventBus',
  'canvas'
];



// helpers ///////

function length(point) {
  return Math.sqrt(Math.pow(point.x, 2) + Math.pow(point.y, 2));
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/movecanvas/index.js":
/*!********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/movecanvas/index.js ***!
  \********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _MoveCanvas__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./MoveCanvas */ "./node_modules/diagram-js/lib/navigation/movecanvas/MoveCanvas.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'moveCanvas' ],
  moveCanvas: [ 'type', _MoveCanvas__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomScroll.js":
/*!*************************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomScroll.js ***!
  \*************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return ZoomScroll; });
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");
/* harmony import */ var _ZoomUtil__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./ZoomUtil */ "./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomUtil.js");
/* harmony import */ var _util_Math__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../util/Math */ "./node_modules/diagram-js/lib/util/Math.js");
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");








var sign = Math.sign || function(n) {
  return n >= 0 ? 1 : -1;
};

var RANGE = { min: 0.2, max: 4 },
    NUM_STEPS = 10;

var DELTA_THRESHOLD = 0.1;

var DEFAULT_SCALE = 0.75;

/**
 * An implementation of zooming and scrolling within the
 * {@link Canvas} via the mouse wheel.
 *
 * Mouse wheel zooming / scrolling may be disabled using
 * the {@link toggle(enabled)} method.
 *
 * @param {Object} [config]
 * @param {boolean} [config.enabled=true] default enabled state
 * @param {number} [config.scale=.75] scroll sensivity
 * @param {EventBus} eventBus
 * @param {Canvas} canvas
 */
function ZoomScroll(config, eventBus, canvas) {

  config = config || {};

  this._enabled = false;

  this._canvas = canvas;
  this._container = canvas._container;

  this._handleWheel = Object(min_dash__WEBPACK_IMPORTED_MODULE_3__["bind"])(this._handleWheel, this);

  this._totalDelta = 0;
  this._scale = config.scale || DEFAULT_SCALE;

  var self = this;

  eventBus.on('canvas.init', function(e) {
    self._init(config.enabled !== false);
  });
}

ZoomScroll.$inject = [
  'config.zoomScroll',
  'eventBus',
  'canvas'
];

ZoomScroll.prototype.scroll = function scroll(delta) {
  this._canvas.scroll(delta);
};


ZoomScroll.prototype.reset = function reset() {
  this._canvas.zoom('fit-viewport');
};

/**
 * Zoom depending on delta.
 *
 * @param {number} delta
 * @param {Object} position
 */
ZoomScroll.prototype.zoom = function zoom(delta, position) {

  // zoom with half the step size of stepZoom
  var stepSize = Object(_ZoomUtil__WEBPACK_IMPORTED_MODULE_1__["getStepSize"])(RANGE, NUM_STEPS * 2);

  // add until threshold reached
  this._totalDelta += delta;

  if (Math.abs(this._totalDelta) > DELTA_THRESHOLD) {
    this._zoom(delta, position, stepSize);

    // reset
    this._totalDelta = 0;
  }
};


ZoomScroll.prototype._handleWheel = function handleWheel(event) {

  // event is already handled by '.djs-scrollable'
  if (Object(min_dom__WEBPACK_IMPORTED_MODULE_0__["closest"])(event.target, '.djs-scrollable', true)) {
    return;
  }

  var element = this._container;

  event.preventDefault();

  // pinch to zoom is mapped to wheel + ctrlKey = true
  // in modern browsers (!)

  var isZoom = event.ctrlKey;

  var isHorizontalScroll = event.shiftKey;

  var factor = -1 * this._scale,
      delta;

  if (isZoom) {
    factor *= event.deltaMode === 0 ? 0.020 : 0.32;
  } else {
    factor *= event.deltaMode === 0 ? 1.0 : 16.0;
  }

  if (isZoom) {
    var elementRect = element.getBoundingClientRect();

    var offset = {
      x: event.clientX - elementRect.left,
      y: event.clientY - elementRect.top
    };

    delta = (
      Math.sqrt(
        Math.pow(event.deltaY, 2) +
        Math.pow(event.deltaX, 2)
      ) * sign(event.deltaY) * factor
    );

    // zoom in relative to diagram {x,y} coordinates
    this.zoom(delta, offset);
  } else {

    if (isHorizontalScroll) {
      delta = {
        dx: factor * event.deltaY,
        dy: 0
      };
    } else {
      delta = {
        dx: factor * event.deltaX,
        dy: factor * event.deltaY
      };
    }

    this.scroll(delta);
  }
};

/**
 * Zoom with fixed step size.
 *
 * @param {number} delta - Zoom delta (1 for zooming in, -1 for out).
 * @param {Object} position
 */
ZoomScroll.prototype.stepZoom = function stepZoom(delta, position) {

  var stepSize = Object(_ZoomUtil__WEBPACK_IMPORTED_MODULE_1__["getStepSize"])(RANGE, NUM_STEPS);

  this._zoom(delta, position, stepSize);
};


/**
 * Zoom in/out given a step size.
 *
 * @param {number} delta
 * @param {Object} position
 * @param {number} stepSize
 */
ZoomScroll.prototype._zoom = function(delta, position, stepSize) {
  var canvas = this._canvas;

  var direction = delta > 0 ? 1 : -1;

  var currentLinearZoomLevel = Object(_util_Math__WEBPACK_IMPORTED_MODULE_2__["log10"])(canvas.zoom());

  // snap to a proximate zoom step
  var newLinearZoomLevel = Math.round(currentLinearZoomLevel / stepSize) * stepSize;

  // increase or decrease one zoom step in the given direction
  newLinearZoomLevel += stepSize * direction;

  // calculate the absolute logarithmic zoom level based on the linear zoom level
  // (e.g. 2 for an absolute x2 zoom)
  var newLogZoomLevel = Math.pow(10, newLinearZoomLevel);

  canvas.zoom(Object(_ZoomUtil__WEBPACK_IMPORTED_MODULE_1__["cap"])(RANGE, newLogZoomLevel), position);
};


/**
 * Toggle the zoom scroll ability via mouse wheel.
 *
 * @param  {boolean} [newEnabled] new enabled state
 */
ZoomScroll.prototype.toggle = function toggle(newEnabled) {

  var element = this._container;
  var handleWheel = this._handleWheel;

  var oldEnabled = this._enabled;

  if (typeof newEnabled === 'undefined') {
    newEnabled = !oldEnabled;
  }

  // only react on actual changes
  if (oldEnabled !== newEnabled) {

    // add or remove wheel listener based on
    // changed enabled state
    min_dom__WEBPACK_IMPORTED_MODULE_0__["event"][newEnabled ? 'bind' : 'unbind'](element, 'wheel', handleWheel, false);
  }

  this._enabled = newEnabled;

  return newEnabled;
};


ZoomScroll.prototype._init = function(newEnabled) {
  this.toggle(newEnabled);
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomUtil.js":
/*!***********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomUtil.js ***!
  \***********************************************************************/
/*! exports provided: getStepSize, cap */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getStepSize", function() { return getStepSize; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "cap", function() { return cap; });
/* harmony import */ var _util_Math__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../util/Math */ "./node_modules/diagram-js/lib/util/Math.js");


/**
 * Get step size for given range and number of steps.
 *
 * @param {Object} range
 * @param {number} range.min
 * @param {number} range.max
 */
function getStepSize(range, steps) {

  var minLinearRange = Object(_util_Math__WEBPACK_IMPORTED_MODULE_0__["log10"])(range.min),
      maxLinearRange = Object(_util_Math__WEBPACK_IMPORTED_MODULE_0__["log10"])(range.max);

  var absoluteLinearRange = Math.abs(minLinearRange) + Math.abs(maxLinearRange);

  return absoluteLinearRange / steps;
}

function cap(range, scale) {
  return Math.max(range.min, Math.min(range.max, scale));
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/navigation/zoomscroll/index.js":
/*!********************************************************************!*\
  !*** ./node_modules/diagram-js/lib/navigation/zoomscroll/index.js ***!
  \********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _ZoomScroll__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./ZoomScroll */ "./node_modules/diagram-js/lib/navigation/zoomscroll/ZoomScroll.js");


/* harmony default export */ __webpack_exports__["default"] = ({
  __init__: [ 'zoomScroll' ],
  zoomScroll: [ 'type', _ZoomScroll__WEBPACK_IMPORTED_MODULE_0__["default"] ]
});

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/ClickTrap.js":
/*!*******************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/ClickTrap.js ***!
  \*******************************************************/
/*! exports provided: install */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "install", function() { return install; });
var TRAP_PRIORITY = 5000;

/**
 * Installs a click trap that prevents a ghost click following a dragging operation.
 *
 * @return {Function} a function to immediately remove the installed trap.
 */
function install(eventBus, eventName) {

  eventName = eventName || 'element.click';

  function trap() {
    return false;
  }

  eventBus.once(eventName, TRAP_PRIORITY, trap);

  return function() {
    eventBus.off(eventName, trap);
  };
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Collections.js":
/*!*********************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Collections.js ***!
  \*********************************************************/
/*! exports provided: remove, add, indexOf */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "remove", function() { return remove; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "add", function() { return add; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "indexOf", function() { return indexOf; });
/**
 * Failsafe remove an element from a collection
 *
 * @param  {Array<Object>} [collection]
 * @param  {Object} [element]
 *
 * @return {number} the previous index of the element
 */
function remove(collection, element) {

  if (!collection || !element) {
    return -1;
  }

  var idx = collection.indexOf(element);

  if (idx !== -1) {
    collection.splice(idx, 1);
  }

  return idx;
}

/**
 * Fail save add an element to the given connection, ensuring
 * it does not yet exist.
 *
 * @param {Array<Object>} collection
 * @param {Object} element
 * @param {number} idx
 */
function add(collection, element, idx) {

  if (!collection || !element) {
    return;
  }

  if (typeof idx !== 'number') {
    idx = -1;
  }

  var currentIdx = collection.indexOf(element);

  if (currentIdx !== -1) {

    if (currentIdx === idx) {

      // nothing to do, position has not changed
      return;
    } else {

      if (idx !== -1) {

        // remove from current position
        collection.splice(currentIdx, 1);
      } else {

        // already exists in collection
        return;
      }
    }
  }

  if (idx !== -1) {

    // insert at specified position
    collection.splice(idx, 0, element);
  } else {

    // push to end
    collection.push(element);
  }
}


/**
 * Fail save get the index of an element in a collection.
 *
 * @param {Array<Object>} collection
 * @param {Object} element
 *
 * @return {number} the index or -1 if collection or element do
 *                  not exist or the element is not contained.
 */
function indexOf(collection, element) {

  if (!collection || !element) {
    return -1;
  }

  return collection.indexOf(element);
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Cursor.js":
/*!****************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Cursor.js ***!
  \****************************************************/
/*! exports provided: set, unset, has */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "set", function() { return set; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "unset", function() { return unset; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "has", function() { return has; });
/* harmony import */ var min_dom__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dom */ "./node_modules/min-dom/dist/index.esm.js");


var CURSOR_CLS_PATTERN = /^djs-cursor-.*$/;


function set(mode) {
  var classes = Object(min_dom__WEBPACK_IMPORTED_MODULE_0__["classes"])(document.body);

  classes.removeMatching(CURSOR_CLS_PATTERN);

  if (mode) {
    classes.add('djs-cursor-' + mode);
  }
}

function unset() {
  set(null);
}

function has(mode) {
  var classes = Object(min_dom__WEBPACK_IMPORTED_MODULE_0__["classes"])(document.body);

  return classes.has('djs-cursor-' + mode);
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Elements.js":
/*!******************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Elements.js ***!
  \******************************************************/
/*! exports provided: getParents, add, eachElement, selfAndChildren, selfAndDirectChildren, selfAndAllChildren, getClosure, getBBox, getEnclosedElements, getType, isFrameElement */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getParents", function() { return getParents; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "add", function() { return add; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "eachElement", function() { return eachElement; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "selfAndChildren", function() { return selfAndChildren; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "selfAndDirectChildren", function() { return selfAndDirectChildren; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "selfAndAllChildren", function() { return selfAndAllChildren; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getClosure", function() { return getClosure; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getBBox", function() { return getBBox; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getEnclosedElements", function() { return getEnclosedElements; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getType", function() { return getType; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isFrameElement", function() { return isFrameElement; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");



/**
 * Get parent elements.
 *
 * @param {Array<djs.model.base>} elements
 *
 * @returns {Array<djs.model.Base>}
 */
function getParents(elements) {

  // find elements that are not children of any other elements
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(elements, function(element) {
    return !Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(elements, function(e) {
      return e !== element && getParent(element, e);
    });
  });
}


function getParent(element, parent) {
  if (!parent) {
    return;
  }

  if (element === parent) {
    return parent;
  }

  if (!element.parent) {
    return;
  }

  return getParent(element.parent, parent);
}


/**
 * Adds an element to a collection and returns true if the
 * element was added.
 *
 * @param {Array<Object>} elements
 * @param {Object} e
 * @param {boolean} unique
 */
function add(elements, e, unique) {
  var canAdd = !unique || elements.indexOf(e) === -1;

  if (canAdd) {
    elements.push(e);
  }

  return canAdd;
}


/**
 * Iterate over each element in a collection, calling the iterator function `fn`
 * with (element, index, recursionDepth).
 *
 * Recurse into all elements that are returned by `fn`.
 *
 * @param  {Object|Array<Object>} elements
 * @param  {Function} fn iterator function called with (element, index, recursionDepth)
 * @param  {number} [depth] maximum recursion depth
 */
function eachElement(elements, fn, depth) {

  depth = depth || 0;

  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(elements)) {
    elements = [ elements ];
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(elements, function(s, i) {
    var filter = fn(s, i, depth);

    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(filter) && filter.length) {
      eachElement(filter, fn, depth + 1);
    }
  });
}


/**
 * Collects self + child elements up to a given depth from a list of elements.
 *
 * @param  {djs.model.Base|Array<djs.model.Base>} elements the elements to select the children from
 * @param  {boolean} unique whether to return a unique result set (no duplicates)
 * @param  {number} maxDepth the depth to search through or -1 for infinite
 *
 * @return {Array<djs.model.Base>} found elements
 */
function selfAndChildren(elements, unique, maxDepth) {
  var result = [],
      processedChildren = [];

  eachElement(elements, function(element, i, depth) {
    add(result, element, unique);

    var children = element.children;

    // max traversal depth not reached yet
    if (maxDepth === -1 || depth < maxDepth) {

      // children exist && children not yet processed
      if (children && add(processedChildren, children, unique)) {
        return children;
      }
    }
  });

  return result;
}

/**
 * Return self + direct children for a number of elements
 *
 * @param  {Array<djs.model.Base>} elements to query
 * @param  {boolean} allowDuplicates to allow duplicates in the result set
 *
 * @return {Array<djs.model.Base>} the collected elements
 */
function selfAndDirectChildren(elements, allowDuplicates) {
  return selfAndChildren(elements, !allowDuplicates, 1);
}


/**
 * Return self + ALL children for a number of elements
 *
 * @param  {Array<djs.model.Base>} elements to query
 * @param  {boolean} allowDuplicates to allow duplicates in the result set
 *
 * @return {Array<djs.model.Base>} the collected elements
 */
function selfAndAllChildren(elements, allowDuplicates) {
  return selfAndChildren(elements, !allowDuplicates, -1);
}


/**
 * Gets the the closure for all selected elements,
 * their enclosed children and connections.
 *
 * @param {Array<djs.model.Base>} elements
 * @param {boolean} [isTopLevel=true]
 * @param {Object} [existingClosure]
 *
 * @return {Object} newClosure
 */
function getClosure(elements, isTopLevel, closure) {

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isUndefined"])(isTopLevel)) {
    isTopLevel = true;
  }

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isObject"])(isTopLevel)) {
    closure = isTopLevel;
    isTopLevel = true;
  }


  closure = closure || {};

  var allShapes = copyObject(closure.allShapes),
      allConnections = copyObject(closure.allConnections),
      enclosedElements = copyObject(closure.enclosedElements),
      enclosedConnections = copyObject(closure.enclosedConnections);

  var topLevel = copyObject(
    closure.topLevel,
    isTopLevel && Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["groupBy"])(elements, function(e) { return e.id; })
  );


  function handleConnection(c) {
    if (topLevel[c.source.id] && topLevel[c.target.id]) {
      topLevel[c.id] = [ c ];
    }

    // not enclosed as a child, but maybe logically
    // (connecting two moved elements?)
    if (allShapes[c.source.id] && allShapes[c.target.id]) {
      enclosedConnections[c.id] = enclosedElements[c.id] = c;
    }

    allConnections[c.id] = c;
  }

  function handleElement(element) {

    enclosedElements[element.id] = element;

    if (element.waypoints) {

      // remember connection
      enclosedConnections[element.id] = allConnections[element.id] = element;
    } else {

      // remember shape
      allShapes[element.id] = element;

      // remember all connections
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(element.incoming, handleConnection);

      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(element.outgoing, handleConnection);

      // recurse into children
      return element.children;
    }
  }

  eachElement(elements, handleElement);

  return {
    allShapes: allShapes,
    allConnections: allConnections,
    topLevel: topLevel,
    enclosedConnections: enclosedConnections,
    enclosedElements: enclosedElements
  };
}

/**
 * Returns the surrounding bbox for all elements in
 * the array or the element primitive.
 *
 * @param {Array<djs.model.Shape>|djs.model.Shape} elements
 * @param {boolean} stopRecursion
 */
function getBBox(elements, stopRecursion) {

  stopRecursion = !!stopRecursion;
  if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(elements)) {
    elements = [elements];
  }

  var minX,
      minY,
      maxX,
      maxY;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(elements, function(element) {

    // If element is a connection the bbox must be computed first
    var bbox = element;
    if (element.waypoints && !stopRecursion) {
      bbox = getBBox(element.waypoints, true);
    }

    var x = bbox.x,
        y = bbox.y,
        height = bbox.height || 0,
        width = bbox.width || 0;

    if (x < minX || minX === undefined) {
      minX = x;
    }
    if (y < minY || minY === undefined) {
      minY = y;
    }

    if ((x + width) > maxX || maxX === undefined) {
      maxX = x + width;
    }
    if ((y + height) > maxY || maxY === undefined) {
      maxY = y + height;
    }
  });

  return {
    x: minX,
    y: minY,
    height: maxY - minY,
    width: maxX - minX
  };
}


/**
 * Returns all elements that are enclosed from the bounding box.
 *
 *   * If bbox.(width|height) is not specified the method returns
 *     all elements with element.x/y > bbox.x/y
 *   * If only bbox.x or bbox.y is specified, method return all elements with
 *     e.x > bbox.x or e.y > bbox.y
 *
 * @param {Array<djs.model.Shape>} elements List of Elements to search through
 * @param {djs.model.Shape} bbox the enclosing bbox.
 *
 * @return {Array<djs.model.Shape>} enclosed elements
 */
function getEnclosedElements(elements, bbox) {

  var filteredElements = {};

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(elements, function(element) {

    var e = element;

    if (e.waypoints) {
      e = getBBox(e);
    }

    if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.y) && (e.x > bbox.x)) {
      filteredElements[element.id] = element;
    }
    if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.x) && (e.y > bbox.y)) {
      filteredElements[element.id] = element;
    }
    if (e.x > bbox.x && e.y > bbox.y) {
      if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.width) && Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.height) &&
          e.width + e.x < bbox.width + bbox.x &&
          e.height + e.y < bbox.height + bbox.y) {

        filteredElements[element.id] = element;
      } else if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.width) || !Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isNumber"])(bbox.height)) {
        filteredElements[element.id] = element;
      }
    }
  });

  return filteredElements;
}


function getType(element) {

  if ('waypoints' in element) {
    return 'connection';
  }

  if ('x' in element) {
    return 'shape';
  }

  return 'root';
}

function isFrameElement(element) {

  return !!(element && element.isFrame);
}

// helpers ///////////////////////////////

function copyObject(src1, src2) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, src1 || {}, src2 || {});
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Event.js":
/*!***************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Event.js ***!
  \***************************************************/
/*! exports provided: getOriginal, stopPropagation, toPoint */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getOriginal", function() { return getOriginal; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "stopPropagation", function() { return stopPropagation; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "toPoint", function() { return toPoint; });
function __stopPropagation(event) {
  if (!event || typeof event.stopPropagation !== 'function') {
    return;
  }

  event.stopPropagation();
}


function getOriginal(event) {
  return event.originalEvent || event.srcEvent;
}


function stopPropagation(event, immediate) {
  __stopPropagation(event, immediate);
  __stopPropagation(getOriginal(event), immediate);
}


function toPoint(event) {

  if (event.pointers && event.pointers.length) {
    event = event.pointers[0];
  }

  if (event.touches && event.touches.length) {
    event = event.touches[0];
  }

  return event ? {
    x: event.clientX,
    y: event.clientY
  } : null;
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Geometry.js":
/*!******************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Geometry.js ***!
  \******************************************************/
/*! exports provided: pointDistance, pointsOnLine, pointsAligned, pointsAlignedHorizontally, pointsAlignedVertically, pointInRect, getMidPoint */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointDistance", function() { return pointDistance; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointsOnLine", function() { return pointsOnLine; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointsAligned", function() { return pointsAligned; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointsAlignedHorizontally", function() { return pointsAlignedHorizontally; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointsAlignedVertically", function() { return pointsAlignedVertically; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pointInRect", function() { return pointInRect; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getMidPoint", function() { return getMidPoint; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


/**
 * Computes the distance between two points
 *
 * @param  {Point}  p
 * @param  {Point}  q
 *
 * @return {number}  distance
 */
function pointDistance(a, b) {
  if (!a || !b) {
    return -1;
  }

  return Math.sqrt(
    Math.pow(a.x - b.x, 2) +
    Math.pow(a.y - b.y, 2)
  );
}


/**
 * Returns true if the point r is on the line between p and q
 *
 * @param  {Point}  p
 * @param  {Point}  q
 * @param  {Point}  r
 * @param  {number} [accuracy=5] accuracy for points on line check (lower is better)
 *
 * @return {boolean}
 */
function pointsOnLine(p, q, r, accuracy) {

  if (typeof accuracy === 'undefined') {
    accuracy = 5;
  }

  if (!p || !q || !r) {
    return false;
  }

  var val = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x),
      dist = pointDistance(p, q);

  // @see http://stackoverflow.com/a/907491/412190
  return Math.abs(val / dist) <= accuracy;
}


var ALIGNED_THRESHOLD = 2;

/**
 * Check whether two points are horizontally or vertically aligned.
 *
 * @param {Array<Point>|Point}
 * @param {Point}
 *
 * @return {string|boolean}
 */
function pointsAligned(a, b) {
  var points;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(a)) {
    points = a;
  } else {
    points = [ a, b ];
  }

  if (pointsAlignedHorizontally(points)) {
    return 'h';
  }

  if (pointsAlignedVertically(points)) {
    return 'v';
  }

  return false;
}

function pointsAlignedHorizontally(a, b) {
  var points;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(a)) {
    points = a;
  } else {
    points = [ a, b ];
  }

  var firstPoint = points.slice().shift();

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["every"])(points, function(point) {
    return Math.abs(firstPoint.y - point.y) <= ALIGNED_THRESHOLD;
  });
}

function pointsAlignedVertically(a, b) {
  var points;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isArray"])(a)) {
    points = a;
  } else {
    points = [ a, b ];
  }

  var firstPoint = points.slice().shift();

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["every"])(points, function(point) {
    return Math.abs(firstPoint.x - point.x) <= ALIGNED_THRESHOLD;
  });
}



/**
 * Returns true if the point p is inside the rectangle rect
 *
 * @param  {Point}  p
 * @param  {Rect} rect
 * @param  {number} tolerance
 *
 * @return {boolean}
 */
function pointInRect(p, rect, tolerance) {
  tolerance = tolerance || 0;

  return p.x > rect.x - tolerance &&
         p.y > rect.y - tolerance &&
         p.x < rect.x + rect.width + tolerance &&
         p.y < rect.y + rect.height + tolerance;
}

/**
 * Returns a point in the middle of points p and q
 *
 * @param  {Point}  p
 * @param  {Point}  q
 *
 * @return {Point} middle point
 */
function getMidPoint(p, q) {
  return {
    x: Math.round(p.x + ((q.x - p.x) / 2.0)),
    y: Math.round(p.y + ((q.y - p.y) / 2.0))
  };
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/GraphicsUtil.js":
/*!**********************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/GraphicsUtil.js ***!
  \**********************************************************/
/*! exports provided: getVisual, getChildren */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getVisual", function() { return getVisual; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "getChildren", function() { return getChildren; });
/**
 * SVGs for elements are generated by the {@link GraphicsFactory}.
 *
 * This utility gives quick access to the important semantic
 * parts of an element.
 */

/**
 * Returns the visual part of a diagram element
 *
 * @param {Snap<SVGElement>} gfx
 *
 * @return {Snap<SVGElement>}
 */
function getVisual(gfx) {
  return gfx.childNodes[0];
}

/**
 * Returns the children for a given diagram element.
 *
 * @param {Snap<SVGElement>} gfx
 * @return {Snap<SVGElement>}
 */
function getChildren(gfx) {
  return gfx.parentNode.childNodes[1];
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/IdGenerator.js":
/*!*********************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/IdGenerator.js ***!
  \*********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return IdGenerator; });
/**
 * Util that provides unique IDs.
 *
 * @class djs.util.IdGenerator
 * @constructor
 * @memberOf djs.util
 *
 * The ids can be customized via a given prefix and contain a random value to avoid collisions.
 *
 * @param {string} prefix a prefix to prepend to generated ids (for better readability)
 */
function IdGenerator(prefix) {

  this._counter = 0;
  this._prefix = (prefix ? prefix + '-' : '') + Math.floor(Math.random() * 1000000000) + '-';
}

/**
 * Returns a next unique ID.
 *
 * @method djs.util.IdGenerator#next
 *
 * @returns {string} the id
 */
IdGenerator.prototype.next = function() {
  return this._prefix + (++this._counter);
};


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Math.js":
/*!**************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Math.js ***!
  \**************************************************/
/*! exports provided: log10, substract */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "log10", function() { return log10; });
/* harmony import */ var _PositionUtil__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./PositionUtil */ "./node_modules/diagram-js/lib/util/PositionUtil.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "substract", function() { return _PositionUtil__WEBPACK_IMPORTED_MODULE_0__["delta"]; });

/**
 * Get the logarithm of x with base 10
 * @param  {Integer} value
 */
function log10(x) {
  return Math.log(x) / Math.log(10);
}




/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Mouse.js":
/*!***************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Mouse.js ***!
  \***************************************************/
/*! exports provided: isMac, isButton, isPrimaryButton, isAuxiliaryButton, isSecondaryButton, hasPrimaryModifier, hasSecondaryModifier */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isButton", function() { return isButton; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isPrimaryButton", function() { return isPrimaryButton; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isAuxiliaryButton", function() { return isAuxiliaryButton; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isSecondaryButton", function() { return isSecondaryButton; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasPrimaryModifier", function() { return hasPrimaryModifier; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hasSecondaryModifier", function() { return hasSecondaryModifier; });
/* harmony import */ var _Event__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Event */ "./node_modules/diagram-js/lib/util/Event.js");
/* harmony import */ var _Platform__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Platform */ "./node_modules/diagram-js/lib/util/Platform.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "isMac", function() { return _Platform__WEBPACK_IMPORTED_MODULE_1__["isMac"]; });







function isButton(event, button) {
  return (Object(_Event__WEBPACK_IMPORTED_MODULE_0__["getOriginal"])(event) || event).button === button;
}

function isPrimaryButton(event) {

  // button === 0 -> left áka primary mouse button
  return isButton(event, 0);
}

function isAuxiliaryButton(event) {

  // button === 1 -> auxiliary áka wheel button
  return isButton(event, 1);
}

function isSecondaryButton(event) {

  // button === 2 -> right áka secondary button
  return isButton(event, 2);
}

function hasPrimaryModifier(event) {
  var originalEvent = Object(_Event__WEBPACK_IMPORTED_MODULE_0__["getOriginal"])(event) || event;

  if (!isPrimaryButton(event)) {
    return false;
  }

  // Use cmd as primary modifier key for mac OS
  if (Object(_Platform__WEBPACK_IMPORTED_MODULE_1__["isMac"])()) {
    return originalEvent.metaKey;
  } else {
    return originalEvent.ctrlKey;
  }
}


function hasSecondaryModifier(event) {
  var originalEvent = Object(_Event__WEBPACK_IMPORTED_MODULE_0__["getOriginal"])(event) || event;

  return isPrimaryButton(event) && originalEvent.shiftKey;
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Platform.js":
/*!******************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Platform.js ***!
  \******************************************************/
/*! exports provided: isMac */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isMac", function() { return isMac; });
function isMac() {
  return (/mac/i).test(navigator.platform);
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/PositionUtil.js":
/*!**********************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/PositionUtil.js ***!
  \**********************************************************/
/*! exports provided: center, delta */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "center", function() { return center; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "delta", function() { return delta; });
function center(bounds) {
  return {
    x: bounds.x + (bounds.width / 2),
    y: bounds.y + (bounds.height / 2)
  };
}


function delta(a, b) {
  return {
    x: a.x - b.x,
    y: a.y - b.y
  };
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/RenderUtil.js":
/*!********************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/RenderUtil.js ***!
  \********************************************************/
/*! exports provided: componentsToPath, toSVGPoints, createLine, updateLine */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "componentsToPath", function() { return componentsToPath; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "toSVGPoints", function() { return toSVGPoints; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "createLine", function() { return createLine; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "updateLine", function() { return updateLine; });
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");



function componentsToPath(elements) {
  return elements.join(',').replace(/,?([A-z]),?/g, '$1');
}

function toSVGPoints(points) {
  var result = '';

  for (var i = 0, p; (p = points[i]); i++) {
    result += p.x + ',' + p.y + ' ';
  }

  return result;
}

function createLine(points, attrs) {

  var line = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["create"])('polyline');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(line, { points: toSVGPoints(points) });

  if (attrs) {
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(line, attrs);
  }

  return line;
}

function updateLine(gfx, points) {
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["attr"])(gfx, { points: toSVGPoints(points) });

  return gfx;
}


/***/ }),

/***/ "./node_modules/diagram-js/lib/util/SvgTransformUtil.js":
/*!**************************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/SvgTransformUtil.js ***!
  \**************************************************************/
/*! exports provided: transform, translate, rotate, scale */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "transform", function() { return transform; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "translate", function() { return translate; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "rotate", function() { return rotate; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "scale", function() { return scale; });
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");



/**
 * @param {<SVGElement>} element
 * @param {number} x
 * @param {number} y
 * @param {number} angle
 * @param {number} amount
 */
function transform(gfx, x, y, angle, amount) {
  var translate = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  translate.setTranslate(x, y);

  var rotate = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  rotate.setRotate(angle || 0, 0, 0);

  var scale = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  scale.setScale(amount || 1, amount || 1);

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["transform"])(gfx, [ translate, rotate, scale ]);
}


/**
 * @param {SVGElement} element
 * @param {number} x
 * @param {number} y
 */
function translate(gfx, x, y) {
  var translate = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  translate.setTranslate(x, y);

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["transform"])(gfx, translate);
}


/**
 * @param {SVGElement} element
 * @param {number} angle
 */
function rotate(gfx, angle) {
  var rotate = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  rotate.setRotate(angle, 0, 0);

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["transform"])(gfx, rotate);
}


/**
 * @param {SVGElement} element
 * @param {number} amount
 */
function scale(gfx, amount) {
  var scale = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["createTransform"])();
  scale.setScale(amount, amount);

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_0__["transform"])(gfx, scale);
}

/***/ }),

/***/ "./node_modules/diagram-js/lib/util/Text.js":
/*!**************************************************!*\
  !*** ./node_modules/diagram-js/lib/util/Text.js ***!
  \**************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Text; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var tiny_svg__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! tiny-svg */ "./node_modules/tiny-svg/dist/index.esm.js");




var DEFAULT_BOX_PADDING = 0;

var DEFAULT_LABEL_SIZE = {
  width: 150,
  height: 50
};


function parseAlign(align) {

  var parts = align.split('-');

  return {
    horizontal: parts[0] || 'center',
    vertical: parts[1] || 'top'
  };
}

function parsePadding(padding) {

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isObject"])(padding)) {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ top: 0, left: 0, right: 0, bottom: 0 }, padding);
  } else {
    return {
      top: padding,
      left: padding,
      right: padding,
      bottom: padding
    };
  }
}

function getTextBBox(text, fakeText) {

  fakeText.textContent = text;

  var textBBox;

  try {
    var bbox,
        emptyLine = text === '';

    // add dummy text, when line is empty to
    // determine correct height
    fakeText.textContent = emptyLine ? 'dummy' : text;

    textBBox = fakeText.getBBox();

    // take text rendering related horizontal
    // padding into account
    bbox = {
      width: textBBox.width + textBBox.x * 2,
      height: textBBox.height
    };

    if (emptyLine) {

      // correct width
      bbox.width = 0;
    }

    return bbox;
  } catch (e) {
    return { width: 0, height: 0 };
  }
}


/**
 * Layout the next line and return the layouted element.
 *
 * Alters the lines passed.
 *
 * @param  {Array<string>} lines
 * @return {Object} the line descriptor, an object { width, height, text }
 */
function layoutNext(lines, maxWidth, fakeText) {

  var originalLine = lines.shift(),
      fitLine = originalLine;

  var textBBox;

  for (;;) {
    textBBox = getTextBBox(fitLine, fakeText);

    textBBox.width = fitLine ? textBBox.width : 0;

    // try to fit
    if (fitLine === ' ' || fitLine === '' || textBBox.width < Math.round(maxWidth) || fitLine.length < 2) {
      return fit(lines, fitLine, originalLine, textBBox);
    }

    fitLine = shortenLine(fitLine, textBBox.width, maxWidth);
  }
}

function fit(lines, fitLine, originalLine, textBBox) {
  if (fitLine.length < originalLine.length) {
    var remainder = originalLine.slice(fitLine.length).trim();

    lines.unshift(remainder);
  }

  return {
    width: textBBox.width,
    height: textBBox.height,
    text: fitLine
  };
}

var SOFT_BREAK = '\u00AD';


/**
 * Shortens a line based on spacing and hyphens.
 * Returns the shortened result on success.
 *
 * @param  {string} line
 * @param  {number} maxLength the maximum characters of the string
 * @return {string} the shortened string
 */
function semanticShorten(line, maxLength) {

  var parts = line.split(/(\s|-|\u00AD)/g),
      part,
      shortenedParts = [],
      length = 0;

  // try to shorten via break chars
  if (parts.length > 1) {

    while ((part = parts.shift())) {
      if (part.length + length < maxLength) {
        shortenedParts.push(part);
        length += part.length;
      } else {

        // remove previous part, too if hyphen does not fit anymore
        if (part === '-' || part === SOFT_BREAK) {
          shortenedParts.pop();
        }

        break;
      }
    }
  }

  var last = shortenedParts[shortenedParts.length - 1];

  // translate trailing soft break to actual hyphen
  if (last && last === SOFT_BREAK) {
    shortenedParts[shortenedParts.length - 1] = '-';
  }

  return shortenedParts.join('');
}


function shortenLine(line, width, maxWidth) {
  var length = Math.max(line.length * (maxWidth / width), 1);

  // try to shorten semantically (i.e. based on spaces and hyphens)
  var shortenedLine = semanticShorten(line, length);

  if (!shortenedLine) {

    // force shorten by cutting the long word
    shortenedLine = line.slice(0, Math.max(Math.round(length - 1), 1));
  }

  return shortenedLine;
}


function getHelperSvg() {
  var helperSvg = document.getElementById('helper-svg');

  if (!helperSvg) {
    helperSvg = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["create"])('svg');

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(helperSvg, {
      id: 'helper-svg',
      width: 0,
      height: 0,
      style: 'visibility: hidden; position: fixed'
    });

    document.body.appendChild(helperSvg);
  }

  return helperSvg;
}


/**
 * Creates a new label utility
 *
 * @param {Object} config
 * @param {Dimensions} config.size
 * @param {number} config.padding
 * @param {Object} config.style
 * @param {string} config.align
 */
function Text(config) {

  this._config = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, {
    size: DEFAULT_LABEL_SIZE,
    padding: DEFAULT_BOX_PADDING,
    style: {},
    align: 'center-top'
  }, config || {});
}

/**
 * Returns the layouted text as an SVG element.
 *
 * @param {string} text
 * @param {Object} options
 *
 * @return {SVGElement}
 */
Text.prototype.createText = function(text, options) {
  return this.layoutText(text, options).element;
};

/**
 * Returns a labels layouted dimensions.
 *
 * @param {string} text to layout
 * @param {Object} options
 *
 * @return {Dimensions}
 */
Text.prototype.getDimensions = function(text, options) {
  return this.layoutText(text, options).dimensions;
};

/**
 * Creates and returns a label and its bounding box.
 *
 * @method Text#createText
 *
 * @param {string} text the text to render on the label
 * @param {Object} options
 * @param {string} options.align how to align in the bounding box.
 *                               Any of { 'center-middle', 'center-top' },
 *                               defaults to 'center-top'.
 * @param {string} options.style style to be applied to the text
 * @param {boolean} options.fitBox indicates if box will be recalculated to
 *                                 fit text
 *
 * @return {Object} { element, dimensions }
 */
Text.prototype.layoutText = function(text, options) {
  var box = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, this._config.size, options.box),
      style = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, this._config.style, options.style),
      align = parseAlign(options.align || this._config.align),
      padding = parsePadding(options.padding !== undefined ? options.padding : this._config.padding),
      fitBox = options.fitBox || false;

  var lineHeight = getLineHeight(style);

  // we split text by lines and normalize
  // {soft break} + {line break} => { line break }
  var lines = text.split(/\u00AD?\r?\n/),
      layouted = [];

  var maxWidth = box.width - padding.left - padding.right;

  // ensure correct rendering by attaching helper text node to invisible SVG
  var helperText = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["create"])('text');
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(helperText, { x: 0, y: 0 });
  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(helperText, style);

  var helperSvg = getHelperSvg();

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["append"])(helperSvg, helperText);

  while (lines.length) {
    layouted.push(layoutNext(lines, maxWidth, helperText));
  }

  if (align.vertical === 'middle') {
    padding.top = padding.bottom = 0;
  }

  var totalHeight = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["reduce"])(layouted, function(sum, line, idx) {
    return sum + (lineHeight || line.height);
  }, 0) + padding.top + padding.bottom;

  var maxLineWidth = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["reduce"])(layouted, function(sum, line, idx) {
    return line.width > sum ? line.width : sum;
  }, 0);

  // the y position of the next line
  var y = padding.top;

  if (align.vertical === 'middle') {
    y += (box.height - totalHeight) / 2;
  }

  // magic number initial offset
  y -= (lineHeight || layouted[0].height) / 4;


  var textElement = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["create"])('text');

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(textElement, style);

  // layout each line taking into account that parent
  // shape might resize to fit text size
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(layouted, function(line) {

    var x;

    y += (lineHeight || line.height);

    switch (align.horizontal) {
    case 'left':
      x = padding.left;
      break;

    case 'right':
      x = ((fitBox ? maxLineWidth : maxWidth)
        - padding.right - line.width);
      break;

    default:

      // aka center
      x = Math.max((((fitBox ? maxLineWidth : maxWidth)
        - line.width) / 2 + padding.left), 0);
    }

    var tspan = Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["create"])('tspan');
    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["attr"])(tspan, { x: x, y: y });

    tspan.textContent = line.text;

    Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["append"])(textElement, tspan);
  });

  Object(tiny_svg__WEBPACK_IMPORTED_MODULE_1__["remove"])(helperText);

  var dimensions = {
    width: maxLineWidth,
    height: totalHeight
  };

  return {
    dimensions: dimensions,
    element: textElement
  };
};


function getLineHeight(style) {
  if ('fontSize' in style && 'lineHeight' in style) {
    return style.lineHeight * parseInt(style.fontSize, 10);
  }
}

/***/ }),

/***/ "./node_modules/didi/dist/index.esm.js":
/*!*********************************************!*\
  !*** ./node_modules/didi/dist/index.esm.js ***!
  \*********************************************/
/*! exports provided: annotate, parseAnnotations, Module, Injector */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "annotate", function() { return annotate; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "parseAnnotations", function() { return parseAnnotations; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Module", function() { return Module; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Injector", function() { return Injector; });
var CLASS_PATTERN = /^class /;

function isClass(fn) {
  return CLASS_PATTERN.test(fn.toString());
}

function isArray(obj) {
  return Object.prototype.toString.call(obj) === '[object Array]';
}

function hasOwnProp(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
}

function annotate() {
  var args = Array.prototype.slice.call(arguments);

  if (args.length === 1 && isArray(args[0])) {
    args = args[0];
  }

  var fn = args.pop();

  fn.$inject = args;

  return fn;
}


// Current limitations:
// - can't put into "function arg" comments
// function /* (no parenthesis like this) */ (){}
// function abc( /* xx (no parenthesis like this) */ a, b) {}
//
// Just put the comment before function or inside:
// /* (((this is fine))) */ function(a, b) {}
// function abc(a) { /* (((this is fine))) */}
//
// - can't reliably auto-annotate constructor; we'll match the
// first constructor(...) pattern found which may be the one
// of a nested class, too.

var CONSTRUCTOR_ARGS = /constructor\s*[^(]*\(\s*([^)]*)\)/m;
var FN_ARGS = /^(?:async )?(?:function\s*)?[^(]*\(\s*([^)]*)\)/m;
var FN_ARG = /\/\*([^*]*)\*\//m;

function parseAnnotations(fn) {

  if (typeof fn !== 'function') {
    throw new Error('Cannot annotate "' + fn + '". Expected a function!');
  }

  var match = fn.toString().match(isClass(fn) ? CONSTRUCTOR_ARGS : FN_ARGS);

  // may parse class without constructor
  if (!match) {
    return [];
  }

  return match[1] && match[1].split(',').map(function(arg) {
    match = arg.match(FN_ARG);
    return match ? match[1].trim() : arg.trim();
  }) || [];
}

function Module() {
  var providers = [];

  this.factory = function(name, factory) {
    providers.push([name, 'factory', factory]);
    return this;
  };

  this.value = function(name, value) {
    providers.push([name, 'value', value]);
    return this;
  };

  this.type = function(name, type) {
    providers.push([name, 'type', type]);
    return this;
  };

  this.forEach = function(iterator) {
    providers.forEach(iterator);
  };

}

function Injector(modules, parent) {
  parent = parent || {
    get: function(name, strict) {
      currentlyResolving.push(name);

      if (strict === false) {
        return null;
      } else {
        throw error('No provider for "' + name + '"!');
      }
    }
  };

  var currentlyResolving = [];
  var providers = this._providers = Object.create(parent._providers || null);
  var instances = this._instances = Object.create(null);

  var self = instances.injector = this;

  var error = function(msg) {
    var stack = currentlyResolving.join(' -> ');
    currentlyResolving.length = 0;
    return new Error(stack ? msg + ' (Resolving: ' + stack + ')' : msg);
  };

  /**
   * Return a named service.
   *
   * @param {String} name
   * @param {Boolean} [strict=true] if false, resolve missing services to null
   *
   * @return {Object}
   */
  var get = function(name, strict) {
    if (!providers[name] && name.indexOf('.') !== -1) {
      var parts = name.split('.');
      var pivot = get(parts.shift());

      while (parts.length) {
        pivot = pivot[parts.shift()];
      }

      return pivot;
    }

    if (hasOwnProp(instances, name)) {
      return instances[name];
    }

    if (hasOwnProp(providers, name)) {
      if (currentlyResolving.indexOf(name) !== -1) {
        currentlyResolving.push(name);
        throw error('Cannot resolve circular dependency!');
      }

      currentlyResolving.push(name);
      instances[name] = providers[name][0](providers[name][1]);
      currentlyResolving.pop();

      return instances[name];
    }

    return parent.get(name, strict);
  };

  var fnDef = function(fn, locals) {

    if (typeof locals === 'undefined') {
      locals = {};
    }

    if (typeof fn !== 'function') {
      if (isArray(fn)) {
        fn = annotate(fn.slice());
      } else {
        throw new Error('Cannot invoke "' + fn + '". Expected a function!');
      }
    }

    var inject = fn.$inject || parseAnnotations(fn);
    var dependencies = inject.map(function(dep) {
      if (hasOwnProp(locals, dep)) {
        return locals[dep];
      } else {
        return get(dep);
      }
    });

    return {
      fn: fn,
      dependencies: dependencies
    };
  };

  var instantiate = function(Type) {
    var def = fnDef(Type);

    var fn = def.fn,
        dependencies = def.dependencies;

    // instantiate var args constructor
    var Constructor = Function.prototype.bind.apply(fn, [ null ].concat(dependencies));

    return new Constructor();
  };

  var invoke = function(func, context, locals) {
    var def = fnDef(func, locals);

    var fn = def.fn,
        dependencies = def.dependencies;

    return fn.apply(context, dependencies);
  };


  var createPrivateInjectorFactory = function(privateChildInjector) {
    return annotate(function(key) {
      return privateChildInjector.get(key);
    });
  };

  var createChild = function(modules, forceNewInstances) {
    if (forceNewInstances && forceNewInstances.length) {
      var fromParentModule = Object.create(null);
      var matchedScopes = Object.create(null);

      var privateInjectorsCache = [];
      var privateChildInjectors = [];
      var privateChildFactories = [];

      var provider;
      var cacheIdx;
      var privateChildInjector;
      var privateChildInjectorFactory;
      for (var name in providers) {
        provider = providers[name];

        if (forceNewInstances.indexOf(name) !== -1) {
          if (provider[2] === 'private') {
            cacheIdx = privateInjectorsCache.indexOf(provider[3]);
            if (cacheIdx === -1) {
              privateChildInjector = provider[3].createChild([], forceNewInstances);
              privateChildInjectorFactory = createPrivateInjectorFactory(privateChildInjector);
              privateInjectorsCache.push(provider[3]);
              privateChildInjectors.push(privateChildInjector);
              privateChildFactories.push(privateChildInjectorFactory);
              fromParentModule[name] = [privateChildInjectorFactory, name, 'private', privateChildInjector];
            } else {
              fromParentModule[name] = [privateChildFactories[cacheIdx], name, 'private', privateChildInjectors[cacheIdx]];
            }
          } else {
            fromParentModule[name] = [provider[2], provider[1]];
          }
          matchedScopes[name] = true;
        }

        if ((provider[2] === 'factory' || provider[2] === 'type') && provider[1].$scope) {
          /* jshint -W083 */
          forceNewInstances.forEach(function(scope) {
            if (provider[1].$scope.indexOf(scope) !== -1) {
              fromParentModule[name] = [provider[2], provider[1]];
              matchedScopes[scope] = true;
            }
          });
        }
      }

      forceNewInstances.forEach(function(scope) {
        if (!matchedScopes[scope]) {
          throw new Error('No provider for "' + scope + '". Cannot use provider from the parent!');
        }
      });

      modules.unshift(fromParentModule);
    }

    return new Injector(modules, self);
  };

  var factoryMap = {
    factory: invoke,
    type: instantiate,
    value: function(value) {
      return value;
    }
  };

  modules.forEach(function(module) {

    function arrayUnwrap(type, value) {
      if (type !== 'value' && isArray(value)) {
        value = annotate(value.slice());
      }

      return value;
    }

    // TODO(vojta): handle wrong inputs (modules)
    if (module instanceof Module) {
      module.forEach(function(provider) {
        var name = provider[0];
        var type = provider[1];
        var value = provider[2];

        providers[name] = [factoryMap[type], arrayUnwrap(type, value), type];
      });
    } else if (typeof module === 'object') {
      if (module.__exports__) {
        var clonedModule = Object.keys(module).reduce(function(m, key) {
          if (key.substring(0, 2) !== '__') {
            m[key] = module[key];
          }
          return m;
        }, Object.create(null));

        var privateInjector = new Injector((module.__modules__ || []).concat([clonedModule]), self);
        var getFromPrivateInjector = annotate(function(key) {
          return privateInjector.get(key);
        });
        module.__exports__.forEach(function(key) {
          providers[key] = [getFromPrivateInjector, key, 'private', privateInjector];
        });
      } else {
        Object.keys(module).forEach(function(name) {
          if (module[name][2] === 'private') {
            providers[name] = module[name];
            return;
          }

          var type = module[name][0];
          var value = module[name][1];

          providers[name] = [factoryMap[type], arrayUnwrap(type, value), type];
        });
      }
    }
  });

  // public API
  this.get = get;
  this.invoke = invoke;
  this.instantiate = instantiate;
  this.createChild = createChild;
}




/***/ }),

/***/ "./node_modules/ids/dist/index.esm.js":
/*!********************************************!*\
  !*** ./node_modules/ids/dist/index.esm.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
function createCommonjsModule(fn, module) {
	return module = { exports: {} }, fn(module, module.exports), module.exports;
}

var hat_1 = createCommonjsModule(function (module) {
var hat = module.exports = function (bits, base) {
    if (!base) base = 16;
    if (bits === undefined) bits = 128;
    if (bits <= 0) return '0';
    
    var digits = Math.log(Math.pow(2, bits)) / Math.log(base);
    for (var i = 2; digits === Infinity; i *= 2) {
        digits = Math.log(Math.pow(2, bits / i)) / Math.log(base) * i;
    }
    
    var rem = digits - Math.floor(digits);
    
    var res = '';
    
    for (var i = 0; i < Math.floor(digits); i++) {
        var x = Math.floor(Math.random() * base).toString(base);
        res = x + res;
    }
    
    if (rem) {
        var b = Math.pow(base, rem);
        var x = Math.floor(Math.random() * b).toString(base);
        res = x + res;
    }
    
    var parsed = parseInt(res, base);
    if (parsed !== Infinity && parsed >= Math.pow(2, bits)) {
        return hat(bits, base)
    }
    else return res;
};

hat.rack = function (bits, base, expandBy) {
    var fn = function (data) {
        var iters = 0;
        do {
            if (iters ++ > 10) {
                if (expandBy) bits += expandBy;
                else throw new Error('too many ID collisions, use more bits')
            }
            
            var id = hat(bits, base);
        } while (Object.hasOwnProperty.call(hats, id));
        
        hats[id] = data;
        return id;
    };
    var hats = fn.hats = {};
    
    fn.get = function (id) {
        return fn.hats[id];
    };
    
    fn.set = function (id, value) {
        fn.hats[id] = value;
        return fn;
    };
    
    fn.bits = bits || 128;
    fn.base = base || 16;
    return fn;
};
});

/**
 * Create a new id generator / cache instance.
 *
 * You may optionally provide a seed that is used internally.
 *
 * @param {Seed} seed
 */

function Ids(seed) {
  if (!(this instanceof Ids)) {
    return new Ids(seed);
  }

  seed = seed || [128, 36, 1];
  this._seed = seed.length ? hat_1.rack(seed[0], seed[1], seed[2]) : seed;
}
/**
 * Generate a next id.
 *
 * @param {Object} [element] element to bind the id to
 *
 * @return {String} id
 */

Ids.prototype.next = function (element) {
  return this._seed(element || true);
};
/**
 * Generate a next id with a given prefix.
 *
 * @param {Object} [element] element to bind the id to
 *
 * @return {String} id
 */


Ids.prototype.nextPrefixed = function (prefix, element) {
  var id;

  do {
    id = prefix + this.next(true);
  } while (this.assigned(id)); // claim {prefix}{random}


  this.claim(id, element); // return

  return id;
};
/**
 * Manually claim an existing id.
 *
 * @param {String} id
 * @param {String} [element] element the id is claimed by
 */


Ids.prototype.claim = function (id, element) {
  this._seed.set(id, element || true);
};
/**
 * Returns true if the given id has already been assigned.
 *
 * @param  {String} id
 * @return {Boolean}
 */


Ids.prototype.assigned = function (id) {
  return this._seed.get(id) || false;
};
/**
 * Unclaim an id.
 *
 * @param  {String} id the id to unclaim
 */


Ids.prototype.unclaim = function (id) {
  delete this._seed.hats[id];
};
/**
 * Clear all claimed ids.
 */


Ids.prototype.clear = function () {
  var hats = this._seed.hats,
      id;

  for (id in hats) {
    this.unclaim(id);
  }
};

/* harmony default export */ __webpack_exports__["default"] = (Ids);
//# sourceMappingURL=index.esm.js.map


/***/ }),

/***/ "./node_modules/inherits/inherits_browser.js":
/*!***************************************************!*\
  !*** ./node_modules/inherits/inherits_browser.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

if (typeof Object.create === 'function') {
  // implementation from standard node.js 'util' module
  module.exports = function inherits(ctor, superCtor) {
    if (superCtor) {
      ctor.super_ = superCtor
      ctor.prototype = Object.create(superCtor.prototype, {
        constructor: {
          value: ctor,
          enumerable: false,
          writable: true,
          configurable: true
        }
      })
    }
  };
} else {
  // old school shim for old browsers
  module.exports = function inherits(ctor, superCtor) {
    if (superCtor) {
      ctor.super_ = superCtor
      var TempCtor = function () {}
      TempCtor.prototype = superCtor.prototype
      ctor.prototype = new TempCtor()
      ctor.prototype.constructor = ctor
    }
  }
}


/***/ }),

/***/ "./node_modules/min-dash/dist/index.esm.js":
/*!*************************************************!*\
  !*** ./node_modules/min-dash/dist/index.esm.js ***!
  \*************************************************/
/*! exports provided: assign, bind, debounce, ensureArray, every, filter, find, findIndex, flatten, forEach, get, groupBy, has, isArray, isDefined, isFunction, isNil, isNumber, isObject, isString, isUndefined, keys, map, matchPattern, merge, omit, pick, reduce, set, size, some, sortBy, throttle, unionBy, uniqueBy, values, without */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "assign", function() { return assign; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "bind", function() { return bind; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "debounce", function() { return debounce; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ensureArray", function() { return ensureArray; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "every", function() { return every; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "filter", function() { return filter; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "find", function() { return find; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "findIndex", function() { return findIndex; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "flatten", function() { return flatten; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "forEach", function() { return forEach; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "get", function() { return get; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "groupBy", function() { return groupBy; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "has", function() { return has; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isArray", function() { return isArray; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isDefined", function() { return isDefined; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isFunction", function() { return isFunction; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isNil", function() { return isNil; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isNumber", function() { return isNumber; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isObject", function() { return isObject; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isString", function() { return isString; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isUndefined", function() { return isUndefined; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "keys", function() { return keys; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "map", function() { return map; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "matchPattern", function() { return matchPattern; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "merge", function() { return merge; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "omit", function() { return omit; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "pick", function() { return pick; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "reduce", function() { return reduce; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "set", function() { return set; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "size", function() { return size; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "some", function() { return some; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "sortBy", function() { return sortBy; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "throttle", function() { return throttle; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "unionBy", function() { return unionBy; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "uniqueBy", function() { return uniqueBy; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "values", function() { return values; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "without", function() { return without; });
/**
 * Flatten array, one level deep.
 *
 * @param {Array<?>} arr
 *
 * @return {Array<?>}
 */
function flatten(arr) {
  return Array.prototype.concat.apply([], arr);
}

var nativeToString = Object.prototype.toString;
var nativeHasOwnProperty = Object.prototype.hasOwnProperty;
function isUndefined(obj) {
  return obj === undefined;
}
function isDefined(obj) {
  return obj !== undefined;
}
function isNil(obj) {
  return obj == null;
}
function isArray(obj) {
  return nativeToString.call(obj) === '[object Array]';
}
function isObject(obj) {
  return nativeToString.call(obj) === '[object Object]';
}
function isNumber(obj) {
  return nativeToString.call(obj) === '[object Number]';
}
function isFunction(obj) {
  var tag = nativeToString.call(obj);
  return tag === '[object Function]' || tag === '[object AsyncFunction]' || tag === '[object GeneratorFunction]' || tag === '[object AsyncGeneratorFunction]' || tag === '[object Proxy]';
}
function isString(obj) {
  return nativeToString.call(obj) === '[object String]';
}
/**
 * Ensure collection is an array.
 *
 * @param {Object} obj
 */

function ensureArray(obj) {
  if (isArray(obj)) {
    return;
  }

  throw new Error('must supply array');
}
/**
 * Return true, if target owns a property with the given key.
 *
 * @param {Object} target
 * @param {String} key
 *
 * @return {Boolean}
 */

function has(target, key) {
  return nativeHasOwnProperty.call(target, key);
}

/**
 * Find element in collection.
 *
 * @param  {Array|Object} collection
 * @param  {Function|Object} matcher
 *
 * @return {Object}
 */

function find(collection, matcher) {
  matcher = toMatcher(matcher);
  var match;
  forEach(collection, function (val, key) {
    if (matcher(val, key)) {
      match = val;
      return false;
    }
  });
  return match;
}
/**
 * Find element index in collection.
 *
 * @param  {Array|Object} collection
 * @param  {Function} matcher
 *
 * @return {Object}
 */

function findIndex(collection, matcher) {
  matcher = toMatcher(matcher);
  var idx = isArray(collection) ? -1 : undefined;
  forEach(collection, function (val, key) {
    if (matcher(val, key)) {
      idx = key;
      return false;
    }
  });
  return idx;
}
/**
 * Find element in collection.
 *
 * @param  {Array|Object} collection
 * @param  {Function} matcher
 *
 * @return {Array} result
 */

function filter(collection, matcher) {
  var result = [];
  forEach(collection, function (val, key) {
    if (matcher(val, key)) {
      result.push(val);
    }
  });
  return result;
}
/**
 * Iterate over collection; returning something
 * (non-undefined) will stop iteration.
 *
 * @param  {Array|Object} collection
 * @param  {Function} iterator
 *
 * @return {Object} return result that stopped the iteration
 */

function forEach(collection, iterator) {
  var val, result;

  if (isUndefined(collection)) {
    return;
  }

  var convertKey = isArray(collection) ? toNum : identity;

  for (var key in collection) {
    if (has(collection, key)) {
      val = collection[key];
      result = iterator(val, convertKey(key));

      if (result === false) {
        return val;
      }
    }
  }
}
/**
 * Return collection without element.
 *
 * @param  {Array} arr
 * @param  {Function} matcher
 *
 * @return {Array}
 */

function without(arr, matcher) {
  if (isUndefined(arr)) {
    return [];
  }

  ensureArray(arr);
  matcher = toMatcher(matcher);
  return arr.filter(function (el, idx) {
    return !matcher(el, idx);
  });
}
/**
 * Reduce collection, returning a single result.
 *
 * @param  {Object|Array} collection
 * @param  {Function} iterator
 * @param  {Any} result
 *
 * @return {Any} result returned from last iterator
 */

function reduce(collection, iterator, result) {
  forEach(collection, function (value, idx) {
    result = iterator(result, value, idx);
  });
  return result;
}
/**
 * Return true if every element in the collection
 * matches the criteria.
 *
 * @param  {Object|Array} collection
 * @param  {Function} matcher
 *
 * @return {Boolean}
 */

function every(collection, matcher) {
  return !!reduce(collection, function (matches, val, key) {
    return matches && matcher(val, key);
  }, true);
}
/**
 * Return true if some elements in the collection
 * match the criteria.
 *
 * @param  {Object|Array} collection
 * @param  {Function} matcher
 *
 * @return {Boolean}
 */

function some(collection, matcher) {
  return !!find(collection, matcher);
}
/**
 * Transform a collection into another collection
 * by piping each member through the given fn.
 *
 * @param  {Object|Array}   collection
 * @param  {Function} fn
 *
 * @return {Array} transformed collection
 */

function map(collection, fn) {
  var result = [];
  forEach(collection, function (val, key) {
    result.push(fn(val, key));
  });
  return result;
}
/**
 * Get the collections keys.
 *
 * @param  {Object|Array} collection
 *
 * @return {Array}
 */

function keys(collection) {
  return collection && Object.keys(collection) || [];
}
/**
 * Shorthand for `keys(o).length`.
 *
 * @param  {Object|Array} collection
 *
 * @return {Number}
 */

function size(collection) {
  return keys(collection).length;
}
/**
 * Get the values in the collection.
 *
 * @param  {Object|Array} collection
 *
 * @return {Array}
 */

function values(collection) {
  return map(collection, function (val) {
    return val;
  });
}
/**
 * Group collection members by attribute.
 *
 * @param  {Object|Array} collection
 * @param  {Function} extractor
 *
 * @return {Object} map with { attrValue => [ a, b, c ] }
 */

function groupBy(collection, extractor) {
  var grouped = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
  extractor = toExtractor(extractor);
  forEach(collection, function (val) {
    var discriminator = extractor(val) || '_';
    var group = grouped[discriminator];

    if (!group) {
      group = grouped[discriminator] = [];
    }

    group.push(val);
  });
  return grouped;
}
function uniqueBy(extractor) {
  extractor = toExtractor(extractor);
  var grouped = {};

  for (var _len = arguments.length, collections = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    collections[_key - 1] = arguments[_key];
  }

  forEach(collections, function (c) {
    return groupBy(c, extractor, grouped);
  });
  var result = map(grouped, function (val, key) {
    return val[0];
  });
  return result;
}
var unionBy = uniqueBy;
/**
 * Sort collection by criteria.
 *
 * @param  {Object|Array} collection
 * @param  {String|Function} extractor
 *
 * @return {Array}
 */

function sortBy(collection, extractor) {
  extractor = toExtractor(extractor);
  var sorted = [];
  forEach(collection, function (value, key) {
    var disc = extractor(value, key);
    var entry = {
      d: disc,
      v: value
    };

    for (var idx = 0; idx < sorted.length; idx++) {
      var d = sorted[idx].d;

      if (disc < d) {
        sorted.splice(idx, 0, entry);
        return;
      }
    } // not inserted, append (!)


    sorted.push(entry);
  });
  return map(sorted, function (e) {
    return e.v;
  });
}
/**
 * Create an object pattern matcher.
 *
 * @example
 *
 * const matcher = matchPattern({ id: 1 });
 *
 * var element = find(elements, matcher);
 *
 * @param  {Object} pattern
 *
 * @return {Function} matcherFn
 */

function matchPattern(pattern) {
  return function (el) {
    return every(pattern, function (val, key) {
      return el[key] === val;
    });
  };
}

function toExtractor(extractor) {
  return isFunction(extractor) ? extractor : function (e) {
    return e[extractor];
  };
}

function toMatcher(matcher) {
  return isFunction(matcher) ? matcher : function (e) {
    return e === matcher;
  };
}

function identity(arg) {
  return arg;
}

function toNum(arg) {
  return Number(arg);
}

/**
 * Debounce fn, calling it only once if
 * the given time elapsed between calls.
 *
 * @param  {Function} fn
 * @param  {Number} timeout
 *
 * @return {Function} debounced function
 */
function debounce(fn, timeout) {
  var timer;
  var lastArgs;
  var lastThis;
  var lastNow;

  function fire() {
    var now = Date.now();
    var scheduledDiff = lastNow + timeout - now;

    if (scheduledDiff > 0) {
      return schedule(scheduledDiff);
    }

    fn.apply(lastThis, lastArgs);
    timer = lastNow = lastArgs = lastThis = undefined;
  }

  function schedule(timeout) {
    timer = setTimeout(fire, timeout);
  }

  return function () {
    lastNow = Date.now();

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    lastArgs = args;
    lastThis = this; // ensure an execution is scheduled

    if (!timer) {
      schedule(timeout);
    }
  };
}
/**
 * Throttle fn, calling at most once
 * in the given interval.
 *
 * @param  {Function} fn
 * @param  {Number} interval
 *
 * @return {Function} throttled function
 */

function throttle(fn, interval) {
  var throttling = false;
  return function () {
    if (throttling) {
      return;
    }

    fn.apply(void 0, arguments);
    throttling = true;
    setTimeout(function () {
      throttling = false;
    }, interval);
  };
}
/**
 * Bind function against target <this>.
 *
 * @param  {Function} fn
 * @param  {Object}   target
 *
 * @return {Function} bound function
 */

function bind(fn, target) {
  return fn.bind(target);
}

function _extends() {
  _extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  return _extends.apply(this, arguments);
}

/**
 * Convenience wrapper for `Object.assign`.
 *
 * @param {Object} target
 * @param {...Object} others
 *
 * @return {Object} the target
 */

function assign(target) {
  for (var _len = arguments.length, others = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    others[_key - 1] = arguments[_key];
  }

  return _extends.apply(void 0, [target].concat(others));
}
/**
 * Sets a nested property of a given object to the specified value.
 *
 * This mutates the object and returns it.
 *
 * @param {Object} target The target of the set operation.
 * @param {(string|number)[]} path The path to the nested value.
 * @param {any} value The value to set.
 */

function set(target, path, value) {
  var currentTarget = target;
  forEach(path, function (key, idx) {
    if (key === '__proto__') {
      throw new Error('illegal key: __proto__');
    }

    var nextKey = path[idx + 1];
    var nextTarget = currentTarget[key];

    if (isDefined(nextKey) && isNil(nextTarget)) {
      nextTarget = currentTarget[key] = isNaN(+nextKey) ? {} : [];
    }

    if (isUndefined(nextKey)) {
      if (isUndefined(value)) {
        delete currentTarget[key];
      } else {
        currentTarget[key] = value;
      }
    } else {
      currentTarget = nextTarget;
    }
  });
  return target;
}
/**
 * Gets a nested property of a given object.
 *
 * @param {Object} target The target of the get operation.
 * @param {(string|number)[]} path The path to the nested value.
 * @param {any} [defaultValue] The value to return if no value exists.
 */

function get(target, path, defaultValue) {
  var currentTarget = target;
  forEach(path, function (key) {
    // accessing nil property yields <undefined>
    if (isNil(currentTarget)) {
      currentTarget = undefined;
      return false;
    }

    currentTarget = currentTarget[key];
  });
  return isUndefined(currentTarget) ? defaultValue : currentTarget;
}
/**
 * Pick given properties from the target object.
 *
 * @param {Object} target
 * @param {Array} properties
 *
 * @return {Object} target
 */

function pick(target, properties) {
  var result = {};
  var obj = Object(target);
  forEach(properties, function (prop) {
    if (prop in obj) {
      result[prop] = target[prop];
    }
  });
  return result;
}
/**
 * Pick all target properties, excluding the given ones.
 *
 * @param {Object} target
 * @param {Array} properties
 *
 * @return {Object} target
 */

function omit(target, properties) {
  var result = {};
  var obj = Object(target);
  forEach(obj, function (prop, key) {
    if (properties.indexOf(key) === -1) {
      result[key] = prop;
    }
  });
  return result;
}
/**
 * Recursively merge `...sources` into given target.
 *
 * Does support merging objects; does not support merging arrays.
 *
 * @param {Object} target
 * @param {...Object} sources
 *
 * @return {Object} the target
 */

function merge(target) {
  for (var _len2 = arguments.length, sources = new Array(_len2 > 1 ? _len2 - 1 : 0), _key2 = 1; _key2 < _len2; _key2++) {
    sources[_key2 - 1] = arguments[_key2];
  }

  if (!sources.length) {
    return target;
  }

  forEach(sources, function (source) {
    // skip non-obj sources, i.e. null
    if (!source || !isObject(source)) {
      return;
    }

    forEach(source, function (sourceVal, key) {
      if (key === '__proto__') {
        return;
      }

      var targetVal = target[key];

      if (isObject(sourceVal)) {
        if (!isObject(targetVal)) {
          // override target[key] with object
          targetVal = {};
        }

        target[key] = merge(targetVal, sourceVal);
      } else {
        target[key] = sourceVal;
      }
    });
  });
  return target;
}




/***/ }),

/***/ "./node_modules/min-dom/dist/index.esm.js":
/*!************************************************!*\
  !*** ./node_modules/min-dom/dist/index.esm.js ***!
  \************************************************/
/*! exports provided: attr, classes, clear, closest, delegate, domify, event, matches, query, queryAll, remove */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "attr", function() { return attr; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "classes", function() { return classes; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "clear", function() { return clear; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "closest", function() { return closest; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "delegate", function() { return delegate; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "domify", function() { return domify; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "event", function() { return componentEvent; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "matches", function() { return matchesSelector; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "query", function() { return query; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "queryAll", function() { return all; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "remove", function() { return remove; });
/**
 * Set attribute `name` to `val`, or get attr `name`.
 *
 * @param {Element} el
 * @param {String} name
 * @param {String} [val]
 * @api public
 */
function attr(el, name, val) {
  // get
  if (arguments.length == 2) {
    return el.getAttribute(name);
  }

  // remove
  if (val === null) {
    return el.removeAttribute(name);
  }

  // set
  el.setAttribute(name, val);

  return el;
}

var indexOf = [].indexOf;

var indexof = function(arr, obj){
  if (indexOf) return arr.indexOf(obj);
  for (var i = 0; i < arr.length; ++i) {
    if (arr[i] === obj) return i;
  }
  return -1;
};

/**
 * Taken from https://github.com/component/classes
 *
 * Without the component bits.
 */

/**
 * Whitespace regexp.
 */

var re = /\s+/;

/**
 * toString reference.
 */

var toString = Object.prototype.toString;

/**
 * Wrap `el` in a `ClassList`.
 *
 * @param {Element} el
 * @return {ClassList}
 * @api public
 */

function classes(el) {
  return new ClassList(el);
}

/**
 * Initialize a new ClassList for `el`.
 *
 * @param {Element} el
 * @api private
 */

function ClassList(el) {
  if (!el || !el.nodeType) {
    throw new Error('A DOM element reference is required');
  }
  this.el = el;
  this.list = el.classList;
}

/**
 * Add class `name` if not already present.
 *
 * @param {String} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.add = function (name) {
  // classList
  if (this.list) {
    this.list.add(name);
    return this;
  }

  // fallback
  var arr = this.array();
  var i = indexof(arr, name);
  if (!~i) arr.push(name);
  this.el.className = arr.join(' ');
  return this;
};

/**
 * Remove class `name` when present, or
 * pass a regular expression to remove
 * any which match.
 *
 * @param {String|RegExp} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.remove = function (name) {
  if ('[object RegExp]' == toString.call(name)) {
    return this.removeMatching(name);
  }

  // classList
  if (this.list) {
    this.list.remove(name);
    return this;
  }

  // fallback
  var arr = this.array();
  var i = indexof(arr, name);
  if (~i) arr.splice(i, 1);
  this.el.className = arr.join(' ');
  return this;
};

/**
 * Remove all classes matching `re`.
 *
 * @param {RegExp} re
 * @return {ClassList}
 * @api private
 */

ClassList.prototype.removeMatching = function (re) {
  var arr = this.array();
  for (var i = 0; i < arr.length; i++) {
    if (re.test(arr[i])) {
      this.remove(arr[i]);
    }
  }
  return this;
};

/**
 * Toggle class `name`, can force state via `force`.
 *
 * For browsers that support classList, but do not support `force` yet,
 * the mistake will be detected and corrected.
 *
 * @param {String} name
 * @param {Boolean} force
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.toggle = function (name, force) {
  // classList
  if (this.list) {
    if ('undefined' !== typeof force) {
      if (force !== this.list.toggle(name, force)) {
        this.list.toggle(name); // toggle again to correct
      }
    } else {
      this.list.toggle(name);
    }
    return this;
  }

  // fallback
  if ('undefined' !== typeof force) {
    if (!force) {
      this.remove(name);
    } else {
      this.add(name);
    }
  } else {
    if (this.has(name)) {
      this.remove(name);
    } else {
      this.add(name);
    }
  }

  return this;
};

/**
 * Return an array of classes.
 *
 * @return {Array}
 * @api public
 */

ClassList.prototype.array = function () {
  var className = this.el.getAttribute('class') || '';
  var str = className.replace(/^\s+|\s+$/g, '');
  var arr = str.split(re);
  if ('' === arr[0]) arr.shift();
  return arr;
};

/**
 * Check if class `name` is present.
 *
 * @param {String} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.has = ClassList.prototype.contains = function (name) {
  return this.list ? this.list.contains(name) : !!~indexof(this.array(), name);
};

/**
 * Remove all children from the given element.
 */
function clear(el) {

  var c;

  while (el.childNodes.length) {
    c = el.childNodes[0];
    el.removeChild(c);
  }

  return el;
}

var proto = typeof Element !== 'undefined' ? Element.prototype : {};
var vendor = proto.matches
  || proto.matchesSelector
  || proto.webkitMatchesSelector
  || proto.mozMatchesSelector
  || proto.msMatchesSelector
  || proto.oMatchesSelector;

var matchesSelector = match;

/**
 * Match `el` to `selector`.
 *
 * @param {Element} el
 * @param {String} selector
 * @return {Boolean}
 * @api public
 */

function match(el, selector) {
  if (!el || el.nodeType !== 1) return false;
  if (vendor) return vendor.call(el, selector);
  var nodes = el.parentNode.querySelectorAll(selector);
  for (var i = 0; i < nodes.length; i++) {
    if (nodes[i] == el) return true;
  }
  return false;
}

/**
 * Closest
 *
 * @param {Element} el
 * @param {String} selector
 * @param {Boolean} checkYourSelf (optional)
 */
function closest (element, selector, checkYourSelf) {
  var currentElem = checkYourSelf ? element : element.parentNode;

  while (currentElem && currentElem.nodeType !== document.DOCUMENT_NODE && currentElem.nodeType !== document.DOCUMENT_FRAGMENT_NODE) {

    if (matchesSelector(currentElem, selector)) {
      return currentElem;
    }

    currentElem = currentElem.parentNode;
  }

  return matchesSelector(currentElem, selector) ? currentElem : null;
}

var bind = window.addEventListener ? 'addEventListener' : 'attachEvent',
    unbind = window.removeEventListener ? 'removeEventListener' : 'detachEvent',
    prefix = bind !== 'addEventListener' ? 'on' : '';

/**
 * Bind `el` event `type` to `fn`.
 *
 * @param {Element} el
 * @param {String} type
 * @param {Function} fn
 * @param {Boolean} capture
 * @return {Function}
 * @api public
 */

var bind_1 = function(el, type, fn, capture){
  el[bind](prefix + type, fn, capture || false);
  return fn;
};

/**
 * Unbind `el` event `type`'s callback `fn`.
 *
 * @param {Element} el
 * @param {String} type
 * @param {Function} fn
 * @param {Boolean} capture
 * @return {Function}
 * @api public
 */

var unbind_1 = function(el, type, fn, capture){
  el[unbind](prefix + type, fn, capture || false);
  return fn;
};

var componentEvent = {
	bind: bind_1,
	unbind: unbind_1
};

/**
 * Module dependencies.
 */

/**
 * Delegate event `type` to `selector`
 * and invoke `fn(e)`. A callback function
 * is returned which may be passed to `.unbind()`.
 *
 * @param {Element} el
 * @param {String} selector
 * @param {String} type
 * @param {Function} fn
 * @param {Boolean} capture
 * @return {Function}
 * @api public
 */

// Some events don't bubble, so we want to bind to the capture phase instead
// when delegating.
var forceCaptureEvents = ['focus', 'blur'];

function bind$1(el, selector, type, fn, capture) {
  if (forceCaptureEvents.indexOf(type) !== -1) {
    capture = true;
  }

  return componentEvent.bind(el, type, function (e) {
    var target = e.target || e.srcElement;
    e.delegateTarget = closest(target, selector, true, el);
    if (e.delegateTarget) {
      fn.call(el, e);
    }
  }, capture);
}

/**
 * Unbind event `type`'s callback `fn`.
 *
 * @param {Element} el
 * @param {String} type
 * @param {Function} fn
 * @param {Boolean} capture
 * @api public
 */
function unbind$1(el, type, fn, capture) {
  if (forceCaptureEvents.indexOf(type) !== -1) {
    capture = true;
  }

  return componentEvent.unbind(el, type, fn, capture);
}

var delegate = {
  bind: bind$1,
  unbind: unbind$1
};

/**
 * Expose `parse`.
 */

var domify = parse;

/**
 * Tests for browser support.
 */

var innerHTMLBug = false;
var bugTestDiv;
if (typeof document !== 'undefined') {
  bugTestDiv = document.createElement('div');
  // Setup
  bugTestDiv.innerHTML = '  <link/><table></table><a href="/a">a</a><input type="checkbox"/>';
  // Make sure that link elements get serialized correctly by innerHTML
  // This requires a wrapper element in IE
  innerHTMLBug = !bugTestDiv.getElementsByTagName('link').length;
  bugTestDiv = undefined;
}

/**
 * Wrap map from jquery.
 */

var map = {
  legend: [1, '<fieldset>', '</fieldset>'],
  tr: [2, '<table><tbody>', '</tbody></table>'],
  col: [2, '<table><tbody></tbody><colgroup>', '</colgroup></table>'],
  // for script/link/style tags to work in IE6-8, you have to wrap
  // in a div with a non-whitespace character in front, ha!
  _default: innerHTMLBug ? [1, 'X<div>', '</div>'] : [0, '', '']
};

map.td =
map.th = [3, '<table><tbody><tr>', '</tr></tbody></table>'];

map.option =
map.optgroup = [1, '<select multiple="multiple">', '</select>'];

map.thead =
map.tbody =
map.colgroup =
map.caption =
map.tfoot = [1, '<table>', '</table>'];

map.polyline =
map.ellipse =
map.polygon =
map.circle =
map.text =
map.line =
map.path =
map.rect =
map.g = [1, '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">','</svg>'];

/**
 * Parse `html` and return a DOM Node instance, which could be a TextNode,
 * HTML DOM Node of some kind (<div> for example), or a DocumentFragment
 * instance, depending on the contents of the `html` string.
 *
 * @param {String} html - HTML string to "domify"
 * @param {Document} doc - The `document` instance to create the Node for
 * @return {DOMNode} the TextNode, DOM Node, or DocumentFragment instance
 * @api private
 */

function parse(html, doc) {
  if ('string' != typeof html) throw new TypeError('String expected');

  // default to the global `document` object
  if (!doc) doc = document;

  // tag name
  var m = /<([\w:]+)/.exec(html);
  if (!m) return doc.createTextNode(html);

  html = html.replace(/^\s+|\s+$/g, ''); // Remove leading/trailing whitespace

  var tag = m[1];

  // body support
  if (tag == 'body') {
    var el = doc.createElement('html');
    el.innerHTML = html;
    return el.removeChild(el.lastChild);
  }

  // wrap map
  var wrap = map[tag] || map._default;
  var depth = wrap[0];
  var prefix = wrap[1];
  var suffix = wrap[2];
  var el = doc.createElement('div');
  el.innerHTML = prefix + html + suffix;
  while (depth--) el = el.lastChild;

  // one element
  if (el.firstChild == el.lastChild) {
    return el.removeChild(el.firstChild);
  }

  // several elements
  var fragment = doc.createDocumentFragment();
  while (el.firstChild) {
    fragment.appendChild(el.removeChild(el.firstChild));
  }

  return fragment;
}

function query(selector, el) {
  el = el || document;

  return el.querySelector(selector);
}

function all(selector, el) {
  el = el || document;

  return el.querySelectorAll(selector);
}

function remove(el) {
  el.parentNode && el.parentNode.removeChild(el);
}




/***/ }),

/***/ "./node_modules/moddle-xml/dist/index.esm.js":
/*!***************************************************!*\
  !*** ./node_modules/moddle-xml/dist/index.esm.js ***!
  \***************************************************/
/*! exports provided: Reader, Writer */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Reader", function() { return Reader; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Writer", function() { return Writer; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");
/* harmony import */ var saxen__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! saxen */ "./node_modules/saxen/dist/index.esm.js");
/* harmony import */ var moddle__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! moddle */ "./node_modules/moddle/dist/index.esm.js");




function hasLowerCaseAlias(pkg) {
  return pkg.xml && pkg.xml.tagAlias === 'lowerCase';
}

var DEFAULT_NS_MAP = {
  'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
  'xml': 'http://www.w3.org/XML/1998/namespace'
};

var XSI_TYPE = 'xsi:type';

function serializeFormat(element) {
  return element.xml && element.xml.serialize;
}

function serializeAsType(element) {
  return serializeFormat(element) === XSI_TYPE;
}

function serializeAsProperty(element) {
  return serializeFormat(element) === 'property';
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function aliasToName(aliasNs, pkg) {

  if (!hasLowerCaseAlias(pkg)) {
    return aliasNs.name;
  }

  return aliasNs.prefix + ':' + capitalize(aliasNs.localName);
}

function prefixedToName(nameNs, pkg) {

  var name = nameNs.name,
      localName = nameNs.localName;

  var typePrefix = pkg.xml && pkg.xml.typePrefix;

  if (typePrefix && localName.indexOf(typePrefix) === 0) {
    return nameNs.prefix + ':' + localName.slice(typePrefix.length);
  } else {
    return name;
  }
}

function normalizeXsiTypeName(name, model) {

  var nameNs = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name);
  var pkg = model.getPackage(nameNs.prefix);

  return prefixedToName(nameNs, pkg);
}

function error(message) {
  return new Error(message);
}

/**
 * Get the moddle descriptor for a given instance or type.
 *
 * @param  {ModdleElement|Function} element
 *
 * @return {Object} the moddle descriptor
 */
function getModdleDescriptor(element) {
  return element.$descriptor;
}


/**
 * A parse context.
 *
 * @class
 *
 * @param {Object} options
 * @param {ElementHandler} options.rootHandler the root handler for parsing a document
 * @param {boolean} [options.lax=false] whether or not to ignore invalid elements
 */
function Context(options) {

  /**
   * @property {ElementHandler} rootHandler
   */

  /**
   * @property {Boolean} lax
   */

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(this, options);

  this.elementsById = {};
  this.references = [];
  this.warnings = [];

  /**
   * Add an unresolved reference.
   *
   * @param {Object} reference
   */
  this.addReference = function(reference) {
    this.references.push(reference);
  };

  /**
   * Add a processed element.
   *
   * @param {ModdleElement} element
   */
  this.addElement = function(element) {

    if (!element) {
      throw error('expected element');
    }

    var elementsById = this.elementsById;

    var descriptor = getModdleDescriptor(element);

    var idProperty = descriptor.idProperty,
        id;

    if (idProperty) {
      id = element.get(idProperty.name);

      if (id) {

        // for QName validation as per http://www.w3.org/TR/REC-xml/#NT-NameChar
        if (!/^([a-z][\w-.]*:)?[a-z_][\w-.]*$/i.test(id)) {
          throw new Error('illegal ID <' + id + '>');
        }

        if (elementsById[id]) {
          throw error('duplicate ID <' + id + '>');
        }

        elementsById[id] = element;
      }
    }
  };

  /**
   * Add an import warning.
   *
   * @param {Object} warning
   * @param {String} warning.message
   * @param {Error} [warning.error]
   */
  this.addWarning = function(warning) {
    this.warnings.push(warning);
  };
}

function BaseHandler() {}

BaseHandler.prototype.handleEnd = function() {};
BaseHandler.prototype.handleText = function() {};
BaseHandler.prototype.handleNode = function() {};


/**
 * A simple pass through handler that does nothing except for
 * ignoring all input it receives.
 *
 * This is used to ignore unknown elements and
 * attributes.
 */
function NoopHandler() { }

NoopHandler.prototype = Object.create(BaseHandler.prototype);

NoopHandler.prototype.handleNode = function() {
  return this;
};

function BodyHandler() {}

BodyHandler.prototype = Object.create(BaseHandler.prototype);

BodyHandler.prototype.handleText = function(text) {
  this.body = (this.body || '') + text;
};

function ReferenceHandler(property, context) {
  this.property = property;
  this.context = context;
}

ReferenceHandler.prototype = Object.create(BodyHandler.prototype);

ReferenceHandler.prototype.handleNode = function(node) {

  if (this.element) {
    throw error('expected no sub nodes');
  } else {
    this.element = this.createReference(node);
  }

  return this;
};

ReferenceHandler.prototype.handleEnd = function() {
  this.element.id = this.body;
};

ReferenceHandler.prototype.createReference = function(node) {
  return {
    property: this.property.ns.name,
    id: ''
  };
};

function ValueHandler(propertyDesc, element) {
  this.element = element;
  this.propertyDesc = propertyDesc;
}

ValueHandler.prototype = Object.create(BodyHandler.prototype);

ValueHandler.prototype.handleEnd = function() {

  var value = this.body || '',
      element = this.element,
      propertyDesc = this.propertyDesc;

  value = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["coerceType"])(propertyDesc.type, value);

  if (propertyDesc.isMany) {
    element.get(propertyDesc.name).push(value);
  } else {
    element.set(propertyDesc.name, value);
  }
};


function BaseElementHandler() {}

BaseElementHandler.prototype = Object.create(BodyHandler.prototype);

BaseElementHandler.prototype.handleNode = function(node) {
  var parser = this,
      element = this.element;

  if (!element) {
    element = this.element = this.createElement(node);

    this.context.addElement(element);
  } else {
    parser = this.handleChild(node);
  }

  return parser;
};

/**
 * @class Reader.ElementHandler
 *
 */
function ElementHandler(model, typeName, context) {
  this.model = model;
  this.type = model.getType(typeName);
  this.context = context;
}

ElementHandler.prototype = Object.create(BaseElementHandler.prototype);

ElementHandler.prototype.addReference = function(reference) {
  this.context.addReference(reference);
};

ElementHandler.prototype.handleText = function(text) {

  var element = this.element,
      descriptor = getModdleDescriptor(element),
      bodyProperty = descriptor.bodyProperty;

  if (!bodyProperty) {
    throw error('unexpected body text <' + text + '>');
  }

  BodyHandler.prototype.handleText.call(this, text);
};

ElementHandler.prototype.handleEnd = function() {

  var value = this.body,
      element = this.element,
      descriptor = getModdleDescriptor(element),
      bodyProperty = descriptor.bodyProperty;

  if (bodyProperty && value !== undefined) {
    value = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["coerceType"])(bodyProperty.type, value);
    element.set(bodyProperty.name, value);
  }
};

/**
 * Create an instance of the model from the given node.
 *
 * @param  {Element} node the xml node
 */
ElementHandler.prototype.createElement = function(node) {
  var attributes = node.attributes,
      Type = this.type,
      descriptor = getModdleDescriptor(Type),
      context = this.context,
      instance = new Type({}),
      model = this.model,
      propNameNs;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(attributes, function(value, name) {

    var prop = descriptor.propertiesByName[name],
        values;

    if (prop && prop.isReference) {

      if (!prop.isMany) {
        context.addReference({
          element: instance,
          property: prop.ns.name,
          id: value
        });
      } else {

        // IDREFS: parse references as whitespace-separated list
        values = value.split(' ');

        Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(values, function(v) {
          context.addReference({
            element: instance,
            property: prop.ns.name,
            id: v
          });
        });
      }

    } else {
      if (prop) {
        value = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["coerceType"])(prop.type, value);
      } else
      if (name !== 'xmlns') {
        propNameNs = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name, descriptor.ns.prefix);

        // check whether attribute is defined in a well-known namespace
        // if that is the case we emit a warning to indicate potential misuse
        if (model.getPackage(propNameNs.prefix)) {

          context.addWarning({
            message: 'unknown attribute <' + name + '>',
            element: instance,
            property: name,
            value: value
          });
        }
      }

      instance.set(name, value);
    }
  });

  return instance;
};

ElementHandler.prototype.getPropertyForNode = function(node) {

  var name = node.name;
  var nameNs = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name);

  var type = this.type,
      model = this.model,
      descriptor = getModdleDescriptor(type);

  var propertyName = nameNs.name,
      property = descriptor.propertiesByName[propertyName],
      elementTypeName,
      elementType;

  // search for properties by name first

  if (property && !property.isAttr) {

    if (serializeAsType(property)) {
      elementTypeName = node.attributes[XSI_TYPE];

      // xsi type is optional, if it does not exists the
      // default type is assumed
      if (elementTypeName) {

        // take possible type prefixes from XML
        // into account, i.e.: xsi:type="t{ActualType}"
        elementTypeName = normalizeXsiTypeName(elementTypeName, model);

        elementType = model.getType(elementTypeName);

        return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, property, {
          effectiveType: getModdleDescriptor(elementType).name
        });
      }
    }

    // search for properties by name first
    return property;
  }

  var pkg = model.getPackage(nameNs.prefix);

  if (pkg) {
    elementTypeName = aliasToName(nameNs, pkg);
    elementType = model.getType(elementTypeName);

    // search for collection members later
    property = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(descriptor.properties, function(p) {
      return !p.isVirtual && !p.isReference && !p.isAttribute && elementType.hasType(p.type);
    });

    if (property) {
      return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, property, {
        effectiveType: getModdleDescriptor(elementType).name
      });
    }
  } else {

    // parse unknown element (maybe extension)
    property = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["find"])(descriptor.properties, function(p) {
      return !p.isReference && !p.isAttribute && p.type === 'Element';
    });

    if (property) {
      return property;
    }
  }

  throw error('unrecognized element <' + nameNs.name + '>');
};

ElementHandler.prototype.toString = function() {
  return 'ElementDescriptor[' + getModdleDescriptor(this.type).name + ']';
};

ElementHandler.prototype.valueHandler = function(propertyDesc, element) {
  return new ValueHandler(propertyDesc, element);
};

ElementHandler.prototype.referenceHandler = function(propertyDesc) {
  return new ReferenceHandler(propertyDesc, this.context);
};

ElementHandler.prototype.handler = function(type) {
  if (type === 'Element') {
    return new GenericElementHandler(this.model, type, this.context);
  } else {
    return new ElementHandler(this.model, type, this.context);
  }
};

/**
 * Handle the child element parsing
 *
 * @param  {Element} node the xml node
 */
ElementHandler.prototype.handleChild = function(node) {
  var propertyDesc, type, element, childHandler;

  propertyDesc = this.getPropertyForNode(node);
  element = this.element;

  type = propertyDesc.effectiveType || propertyDesc.type;

  if (Object(moddle__WEBPACK_IMPORTED_MODULE_2__["isSimpleType"])(type)) {
    return this.valueHandler(propertyDesc, element);
  }

  if (propertyDesc.isReference) {
    childHandler = this.referenceHandler(propertyDesc).handleNode(node);
  } else {
    childHandler = this.handler(type).handleNode(node);
  }

  var newElement = childHandler.element;

  // child handles may decide to skip elements
  // by not returning anything
  if (newElement !== undefined) {

    if (propertyDesc.isMany) {
      element.get(propertyDesc.name).push(newElement);
    } else {
      element.set(propertyDesc.name, newElement);
    }

    if (propertyDesc.isReference) {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(newElement, {
        element: element
      });

      this.context.addReference(newElement);
    } else {

      // establish child -> parent relationship
      newElement.$parent = element;
    }
  }

  return childHandler;
};

/**
 * An element handler that performs special validation
 * to ensure the node it gets initialized with matches
 * the handlers type (namespace wise).
 *
 * @param {Moddle} model
 * @param {String} typeName
 * @param {Context} context
 */
function RootElementHandler(model, typeName, context) {
  ElementHandler.call(this, model, typeName, context);
}

RootElementHandler.prototype = Object.create(ElementHandler.prototype);

RootElementHandler.prototype.createElement = function(node) {

  var name = node.name,
      nameNs = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name),
      model = this.model,
      type = this.type,
      pkg = model.getPackage(nameNs.prefix),
      typeName = pkg && aliasToName(nameNs, pkg) || name;

  // verify the correct namespace if we parse
  // the first element in the handler tree
  //
  // this ensures we don't mistakenly import wrong namespace elements
  if (!type.hasType(typeName)) {
    throw error('unexpected element <' + node.originalName + '>');
  }

  return ElementHandler.prototype.createElement.call(this, node);
};


function GenericElementHandler(model, typeName, context) {
  this.model = model;
  this.context = context;
}

GenericElementHandler.prototype = Object.create(BaseElementHandler.prototype);

GenericElementHandler.prototype.createElement = function(node) {

  var name = node.name,
      ns = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name),
      prefix = ns.prefix,
      uri = node.ns[prefix + '$uri'],
      attributes = node.attributes;

  return this.model.createAny(name, uri, attributes);
};

GenericElementHandler.prototype.handleChild = function(node) {

  var handler = new GenericElementHandler(this.model, 'Element', this.context).handleNode(node),
      element = this.element;

  var newElement = handler.element,
      children;

  if (newElement !== undefined) {
    children = element.$children = element.$children || [];
    children.push(newElement);

    // establish child -> parent relationship
    newElement.$parent = element;
  }

  return handler;
};

GenericElementHandler.prototype.handleEnd = function() {
  if (this.body) {
    this.element.$body = this.body;
  }
};

/**
 * A reader for a meta-model
 *
 * @param {Object} options
 * @param {Model} options.model used to read xml files
 * @param {Boolean} options.lax whether to make parse errors warnings
 */
function Reader(options) {

  if (options instanceof moddle__WEBPACK_IMPORTED_MODULE_2__["Moddle"]) {
    options = {
      model: options
    };
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(this, { lax: false }, options);
}

/**
 * The fromXML result.
 *
 * @typedef {Object} ParseResult
 *
 * @property {ModdleElement} rootElement
 * @property {Array<Object>} references
 * @property {Array<Error>} warnings
 * @property {Object} elementsById - a mapping containing each ID -> ModdleElement
 */

/**
 * The fromXML result.
 *
 * @typedef {Error} ParseError
 *
 * @property {Array<Error>} warnings
 */

/**
 * Parse the given XML into a moddle document tree.
 *
 * @param {String} xml
 * @param {ElementHandler|Object} options or rootHandler
 *
 * @returns {Promise<ParseResult, ParseError>}
 */
Reader.prototype.fromXML = function(xml, options, done) {

  var rootHandler = options.rootHandler;

  if (options instanceof ElementHandler) {

    // root handler passed via (xml, { rootHandler: ElementHandler }, ...)
    rootHandler = options;
    options = {};
  } else {
    if (typeof options === 'string') {

      // rootHandler passed via (xml, 'someString', ...)
      rootHandler = this.handler(options);
      options = {};
    } else if (typeof rootHandler === 'string') {

      // rootHandler passed via (xml, { rootHandler: 'someString' }, ...)
      rootHandler = this.handler(rootHandler);
    }
  }

  var model = this.model,
      lax = this.lax;

  var context = new Context(Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, options, { rootHandler: rootHandler })),
      parser = new saxen__WEBPACK_IMPORTED_MODULE_1__["Parser"]({ proxy: true }),
      stack = createStack();

  rootHandler.context = context;

  // push root handler
  stack.push(rootHandler);


  /**
   * Handle error.
   *
   * @param  {Error} err
   * @param  {Function} getContext
   * @param  {boolean} lax
   *
   * @return {boolean} true if handled
   */
  function handleError(err, getContext, lax) {

    var ctx = getContext();

    var line = ctx.line,
        column = ctx.column,
        data = ctx.data;

    // we receive the full context data here,
    // for elements trim down the information
    // to the tag name, only
    if (data.charAt(0) === '<' && data.indexOf(' ') !== -1) {
      data = data.slice(0, data.indexOf(' ')) + '>';
    }

    var message =
      'unparsable content ' + (data ? data + ' ' : '') + 'detected\n\t' +
        'line: ' + line + '\n\t' +
        'column: ' + column + '\n\t' +
        'nested error: ' + err.message;

    if (lax) {
      context.addWarning({
        message: message,
        error: err
      });

      return true;
    } else {
      throw error(message);
    }
  }

  function handleWarning(err, getContext) {

    // just like handling errors in <lax=true> mode
    return handleError(err, getContext, true);
  }

  /**
   * Resolve collected references on parse end.
   */
  function resolveReferences() {

    var elementsById = context.elementsById;
    var references = context.references;

    var i, r;

    for (i = 0; (r = references[i]); i++) {
      var element = r.element;
      var reference = elementsById[r.id];
      var property = getModdleDescriptor(element).propertiesByName[r.property];

      if (!reference) {
        context.addWarning({
          message: 'unresolved reference <' + r.id + '>',
          element: r.element,
          property: r.property,
          value: r.id
        });
      }

      if (property.isMany) {
        var collection = element.get(property.name),
            idx = collection.indexOf(r);

        // we replace an existing place holder (idx != -1) or
        // append to the collection instead
        if (idx === -1) {
          idx = collection.length;
        }

        if (!reference) {

          // remove unresolvable reference
          collection.splice(idx, 1);
        } else {

          // add or update reference in collection
          collection[idx] = reference;
        }
      } else {
        element.set(property.name, reference);
      }
    }
  }

  function handleClose() {
    stack.pop().handleEnd();
  }

  var PREAMBLE_START_PATTERN = /^<\?xml /i;

  var ENCODING_PATTERN = / encoding="([^"]+)"/i;

  var UTF_8_PATTERN = /^utf-8$/i;

  function handleQuestion(question) {

    if (!PREAMBLE_START_PATTERN.test(question)) {
      return;
    }

    var match = ENCODING_PATTERN.exec(question);
    var encoding = match && match[1];

    if (!encoding || UTF_8_PATTERN.test(encoding)) {
      return;
    }

    context.addWarning({
      message:
        'unsupported document encoding <' + encoding + '>, ' +
        'falling back to UTF-8'
    });
  }

  function handleOpen(node, getContext) {
    var handler = stack.peek();

    try {
      stack.push(handler.handleNode(node));
    } catch (err) {

      if (handleError(err, getContext, lax)) {
        stack.push(new NoopHandler());
      }
    }
  }

  function handleCData(text, getContext) {

    try {
      stack.peek().handleText(text);
    } catch (err) {
      handleWarning(err, getContext);
    }
  }

  function handleText(text, getContext) {

    // strip whitespace only nodes, i.e. before
    // <!CDATA[ ... ]> sections and in between tags

    if (!text.trim()) {
      return;
    }

    handleCData(text, getContext);
  }

  var uriMap = model.getPackages().reduce(function(uriMap, p) {
    uriMap[p.uri] = p.prefix;

    return uriMap;
  }, {
    'http://www.w3.org/XML/1998/namespace': 'xml' // add default xml ns
  });
  parser
    .ns(uriMap)
    .on('openTag', function(obj, decodeStr, selfClosing, getContext) {

      // gracefully handle unparsable attributes (attrs=false)
      var attrs = obj.attrs || {};

      var decodedAttrs = Object.keys(attrs).reduce(function(d, key) {
        var value = decodeStr(attrs[key]);

        d[key] = value;

        return d;
      }, {});

      var node = {
        name: obj.name,
        originalName: obj.originalName,
        attributes: decodedAttrs,
        ns: obj.ns
      };

      handleOpen(node, getContext);
    })
    .on('question', handleQuestion)
    .on('closeTag', handleClose)
    .on('cdata', handleCData)
    .on('text', function(text, decodeEntities, getContext) {
      handleText(decodeEntities(text), getContext);
    })
    .on('error', handleError)
    .on('warn', handleWarning);

  // async XML parsing to make sure the execution environment
  // (node or brower) is kept responsive and that certain optimization
  // strategies can kick in.
  return new Promise(function(resolve, reject) {

    var err;

    try {
      parser.parse(xml);

      resolveReferences();
    } catch (e) {
      err = e;
    }

    var rootElement = rootHandler.element;

    if (!err && !rootElement) {
      err = error('failed to parse document as <' + rootHandler.type.$descriptor.name + '>');
    }

    var warnings = context.warnings;
    var references = context.references;
    var elementsById = context.elementsById;

    if (err) {
      err.warnings = warnings;

      return reject(err);
    } else {
      return resolve({
        rootElement: rootElement,
        elementsById: elementsById,
        references: references,
        warnings: warnings
      });
    }
  });
};

Reader.prototype.handler = function(name) {
  return new RootElementHandler(this.model, name);
};


// helpers //////////////////////////

function createStack() {
  var stack = [];

  Object.defineProperty(stack, 'peek', {
    value: function() {
      return this[this.length - 1];
    }
  });

  return stack;
}

var XML_PREAMBLE = '<?xml version="1.0" encoding="UTF-8"?>\n';

var ESCAPE_ATTR_CHARS = /<|>|'|"|&|\n\r|\n/g;
var ESCAPE_CHARS = /<|>|&/g;


function Namespaces(parent) {

  var prefixMap = {};
  var uriMap = {};
  var used = {};

  var wellknown = [];
  var custom = [];

  // API

  this.byUri = function(uri) {
    return uriMap[uri] || (
      parent && parent.byUri(uri)
    );
  };

  this.add = function(ns, isWellknown) {

    uriMap[ns.uri] = ns;

    if (isWellknown) {
      wellknown.push(ns);
    } else {
      custom.push(ns);
    }

    this.mapPrefix(ns.prefix, ns.uri);
  };

  this.uriByPrefix = function(prefix) {
    return prefixMap[prefix || 'xmlns'];
  };

  this.mapPrefix = function(prefix, uri) {
    prefixMap[prefix || 'xmlns'] = uri;
  };

  this.getNSKey = function(ns) {
    return (ns.prefix !== undefined) ? (ns.uri + '|' + ns.prefix) : ns.uri;
  };

  this.logUsed = function(ns) {

    var uri = ns.uri;
    var nsKey = this.getNSKey(ns);

    used[nsKey] = this.byUri(uri);

    // Inform parent recursively about the usage of this NS
    if (parent) {
      parent.logUsed(ns);
    }
  };

  this.getUsed = function(ns) {

    function isUsed(ns) {
      var nsKey = self.getNSKey(ns);

      return used[nsKey];
    }

    var self = this;

    var allNs = [].concat(wellknown, custom);

    return allNs.filter(isUsed);
  };

}

function lower(string) {
  return string.charAt(0).toLowerCase() + string.slice(1);
}

function nameToAlias(name, pkg) {
  if (hasLowerCaseAlias(pkg)) {
    return lower(name);
  } else {
    return name;
  }
}

function inherits(ctor, superCtor) {
  ctor.super_ = superCtor;
  ctor.prototype = Object.create(superCtor.prototype, {
    constructor: {
      value: ctor,
      enumerable: false,
      writable: true,
      configurable: true
    }
  });
}

function nsName(ns) {
  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(ns)) {
    return ns;
  } else {
    return (ns.prefix ? ns.prefix + ':' : '') + ns.localName;
  }
}

function getNsAttrs(namespaces) {

  return namespaces.getUsed().filter(function(ns) {

    // do not serialize built in <xml> namespace
    return ns.prefix !== 'xml';
  }).map(function(ns) {
    var name = 'xmlns' + (ns.prefix ? ':' + ns.prefix : '');
    return { name: name, value: ns.uri };
  });

}

function getElementNs(ns, descriptor) {
  if (descriptor.isGeneric) {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ localName: descriptor.ns.localName }, ns);
  } else {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ localName: nameToAlias(descriptor.ns.localName, descriptor.$pkg) }, ns);
  }
}

function getPropertyNs(ns, descriptor) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ localName: descriptor.ns.localName }, ns);
}

function getSerializableProperties(element) {
  var descriptor = element.$descriptor;

  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(descriptor.properties, function(p) {
    var name = p.name;

    if (p.isVirtual) {
      return false;
    }

    // do not serialize defaults
    if (!Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["has"])(element, name)) {
      return false;
    }

    var value = element[name];

    // do not serialize default equals
    if (value === p.default) {
      return false;
    }

    // do not serialize null properties
    if (value === null) {
      return false;
    }

    return p.isMany ? value.length : true;
  });
}

var ESCAPE_ATTR_MAP = {
  '\n': '#10',
  '\n\r': '#10',
  '"': '#34',
  '\'': '#39',
  '<': '#60',
  '>': '#62',
  '&': '#38'
};

var ESCAPE_MAP = {
  '<': 'lt',
  '>': 'gt',
  '&': 'amp'
};

function escape(str, charPattern, replaceMap) {

  // ensure we are handling strings here
  str = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(str) ? str : '' + str;

  return str.replace(charPattern, function(s) {
    return '&' + replaceMap[s] + ';';
  });
}

/**
 * Escape a string attribute to not contain any bad values (line breaks, '"', ...)
 *
 * @param {String} str the string to escape
 * @return {String} the escaped string
 */
function escapeAttr(str) {
  return escape(str, ESCAPE_ATTR_CHARS, ESCAPE_ATTR_MAP);
}

function escapeBody(str) {
  return escape(str, ESCAPE_CHARS, ESCAPE_MAP);
}

function filterAttributes(props) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(props, function(p) { return p.isAttr; });
}

function filterContained(props) {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["filter"])(props, function(p) { return !p.isAttr; });
}


function ReferenceSerializer(tagName) {
  this.tagName = tagName;
}

ReferenceSerializer.prototype.build = function(element) {
  this.element = element;
  return this;
};

ReferenceSerializer.prototype.serializeTo = function(writer) {
  writer
    .appendIndent()
    .append('<' + this.tagName + '>' + this.element.id + '</' + this.tagName + '>')
    .appendNewLine();
};

function BodySerializer() {}

BodySerializer.prototype.serializeValue =
BodySerializer.prototype.serializeTo = function(writer) {
  writer.append(
    this.escape
      ? escapeBody(this.value)
      : this.value
  );
};

BodySerializer.prototype.build = function(prop, value) {
  this.value = value;

  if (prop.type === 'String' && value.search(ESCAPE_CHARS) !== -1) {
    this.escape = true;
  }

  return this;
};

function ValueSerializer(tagName) {
  this.tagName = tagName;
}

inherits(ValueSerializer, BodySerializer);

ValueSerializer.prototype.serializeTo = function(writer) {

  writer
    .appendIndent()
    .append('<' + this.tagName + '>');

  this.serializeValue(writer);

  writer
    .append('</' + this.tagName + '>')
    .appendNewLine();
};

function ElementSerializer(parent, propertyDescriptor) {
  this.body = [];
  this.attrs = [];

  this.parent = parent;
  this.propertyDescriptor = propertyDescriptor;
}

ElementSerializer.prototype.build = function(element) {
  this.element = element;

  var elementDescriptor = element.$descriptor,
      propertyDescriptor = this.propertyDescriptor;

  var otherAttrs,
      properties;

  var isGeneric = elementDescriptor.isGeneric;

  if (isGeneric) {
    otherAttrs = this.parseGeneric(element);
  } else {
    otherAttrs = this.parseNsAttributes(element);
  }

  if (propertyDescriptor) {
    this.ns = this.nsPropertyTagName(propertyDescriptor);
  } else {
    this.ns = this.nsTagName(elementDescriptor);
  }

  // compute tag name
  this.tagName = this.addTagName(this.ns);

  if (!isGeneric) {
    properties = getSerializableProperties(element);

    this.parseAttributes(filterAttributes(properties));
    this.parseContainments(filterContained(properties));
  }

  this.parseGenericAttributes(element, otherAttrs);

  return this;
};

ElementSerializer.prototype.nsTagName = function(descriptor) {
  var effectiveNs = this.logNamespaceUsed(descriptor.ns);
  return getElementNs(effectiveNs, descriptor);
};

ElementSerializer.prototype.nsPropertyTagName = function(descriptor) {
  var effectiveNs = this.logNamespaceUsed(descriptor.ns);
  return getPropertyNs(effectiveNs, descriptor);
};

ElementSerializer.prototype.isLocalNs = function(ns) {
  return ns.uri === this.ns.uri;
};

/**
 * Get the actual ns attribute name for the given element.
 *
 * @param {Object} element
 * @param {Boolean} [element.inherited=false]
 *
 * @return {Object} nsName
 */
ElementSerializer.prototype.nsAttributeName = function(element) {

  var ns;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(element)) {
    ns = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(element);
  } else {
    ns = element.ns;
  }

  // return just local name for inherited attributes
  if (element.inherited) {
    return { localName: ns.localName };
  }

  // parse + log effective ns
  var effectiveNs = this.logNamespaceUsed(ns);

  // LOG ACTUAL namespace use
  this.getNamespaces().logUsed(effectiveNs);

  // strip prefix if same namespace like parent
  if (this.isLocalNs(effectiveNs)) {
    return { localName: ns.localName };
  } else {
    return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ localName: ns.localName }, effectiveNs);
  }
};

ElementSerializer.prototype.parseGeneric = function(element) {

  var self = this,
      body = this.body;

  var attributes = [];

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(element, function(val, key) {

    var nonNsAttr;

    if (key === '$body') {
      body.push(new BodySerializer().build({ type: 'String' }, val));
    } else
    if (key === '$children') {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(val, function(child) {
        body.push(new ElementSerializer(self).build(child));
      });
    } else
    if (key.indexOf('$') !== 0) {
      nonNsAttr = self.parseNsAttribute(element, key, val);

      if (nonNsAttr) {
        attributes.push({ name: key, value: val });
      }
    }
  });

  return attributes;
};

ElementSerializer.prototype.parseNsAttribute = function(element, name, value) {
  var model = element.$model;

  var nameNs = Object(moddle__WEBPACK_IMPORTED_MODULE_2__["parseNameNS"])(name);

  var ns;

  // parse xmlns:foo="http://foo.bar"
  if (nameNs.prefix === 'xmlns') {
    ns = { prefix: nameNs.localName, uri: value };
  }

  // parse xmlns="http://foo.bar"
  if (!nameNs.prefix && nameNs.localName === 'xmlns') {
    ns = { uri: value };
  }

  if (!ns) {
    return {
      name: name,
      value: value
    };
  }

  if (model && model.getPackage(value)) {

    // register well known namespace
    this.logNamespace(ns, true, true);
  } else {

    // log custom namespace directly as used
    var actualNs = this.logNamespaceUsed(ns, true);

    this.getNamespaces().logUsed(actualNs);
  }
};


/**
 * Parse namespaces and return a list of left over generic attributes
 *
 * @param  {Object} element
 * @return {Array<Object>}
 */
ElementSerializer.prototype.parseNsAttributes = function(element, attrs) {
  var self = this;

  var genericAttrs = element.$attrs;

  var attributes = [];

  // parse namespace attributes first
  // and log them. push non namespace attributes to a list
  // and process them later
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(genericAttrs, function(value, name) {

    var nonNsAttr = self.parseNsAttribute(element, name, value);

    if (nonNsAttr) {
      attributes.push(nonNsAttr);
    }
  });

  return attributes;
};

ElementSerializer.prototype.parseGenericAttributes = function(element, attributes) {

  var self = this;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(attributes, function(attr) {

    // do not serialize xsi:type attribute
    // it is set manually based on the actual implementation type
    if (attr.name === XSI_TYPE) {
      return;
    }

    try {
      self.addAttribute(self.nsAttributeName(attr.name), attr.value);
    } catch (e) {
      console.warn(
        'missing namespace information for ',
        attr.name, '=', attr.value, 'on', element,
        e);
    }
  });
};

ElementSerializer.prototype.parseContainments = function(properties) {

  var self = this,
      body = this.body,
      element = this.element;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(properties, function(p) {
    var value = element.get(p.name),
        isReference = p.isReference,
        isMany = p.isMany;

    if (!isMany) {
      value = [ value ];
    }

    if (p.isBody) {
      body.push(new BodySerializer().build(p, value[0]));
    } else
    if (Object(moddle__WEBPACK_IMPORTED_MODULE_2__["isSimpleType"])(p.type)) {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(value, function(v) {
        body.push(new ValueSerializer(self.addTagName(self.nsPropertyTagName(p))).build(p, v));
      });
    } else
    if (isReference) {
      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(value, function(v) {
        body.push(new ReferenceSerializer(self.addTagName(self.nsPropertyTagName(p))).build(v));
      });
    } else {

      // allow serialization via type
      // rather than element name
      var asType = serializeAsType(p),
          asProperty = serializeAsProperty(p);

      Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(value, function(v) {
        var serializer;

        if (asType) {
          serializer = new TypeSerializer(self, p);
        } else
        if (asProperty) {
          serializer = new ElementSerializer(self, p);
        } else {
          serializer = new ElementSerializer(self);
        }

        body.push(serializer.build(v));
      });
    }
  });
};

ElementSerializer.prototype.getNamespaces = function(local) {

  var namespaces = this.namespaces,
      parent = this.parent,
      parentNamespaces;

  if (!namespaces) {
    parentNamespaces = parent && parent.getNamespaces();

    if (local || !parentNamespaces) {
      this.namespaces = namespaces = new Namespaces(parentNamespaces);
    } else {
      namespaces = parentNamespaces;
    }
  }

  return namespaces;
};

ElementSerializer.prototype.logNamespace = function(ns, wellknown, local) {
  var namespaces = this.getNamespaces(local);

  var nsUri = ns.uri,
      nsPrefix = ns.prefix;

  var existing = namespaces.byUri(nsUri);

  if (!existing || local) {
    namespaces.add(ns, wellknown);
  }

  namespaces.mapPrefix(nsPrefix, nsUri);

  return ns;
};

ElementSerializer.prototype.logNamespaceUsed = function(ns, local) {
  var element = this.element,
      model = element.$model,
      namespaces = this.getNamespaces(local);

  // ns may be
  //
  //   * prefix only
  //   * prefix:uri
  //   * localName only

  var prefix = ns.prefix,
      uri = ns.uri,
      newPrefix, idx,
      wellknownUri;

  // handle anonymous namespaces (elementForm=unqualified), cf. #23
  if (!prefix && !uri) {
    return { localName: ns.localName };
  }

  wellknownUri = DEFAULT_NS_MAP[prefix] || model && (model.getPackage(prefix) || {}).uri;

  uri = uri || wellknownUri || namespaces.uriByPrefix(prefix);

  if (!uri) {
    throw new Error('no namespace uri given for prefix <' + prefix + '>');
  }

  ns = namespaces.byUri(uri);

  if (!ns) {
    newPrefix = prefix;
    idx = 1;

    // find a prefix that is not mapped yet
    while (namespaces.uriByPrefix(newPrefix)) {
      newPrefix = prefix + '_' + idx++;
    }

    ns = this.logNamespace({ prefix: newPrefix, uri: uri }, wellknownUri === uri);
  }

  if (prefix) {
    namespaces.mapPrefix(prefix, uri);
  }

  return ns;
};

ElementSerializer.prototype.parseAttributes = function(properties) {
  var self = this,
      element = this.element;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(properties, function(p) {

    var value = element.get(p.name);

    if (p.isReference) {

      if (!p.isMany) {
        value = value.id;
      }
      else {
        var values = [];
        Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(value, function(v) {
          values.push(v.id);
        });

        // IDREFS is a whitespace-separated list of references.
        value = values.join(' ');
      }

    }

    self.addAttribute(self.nsAttributeName(p), value);
  });
};

ElementSerializer.prototype.addTagName = function(nsTagName) {
  var actualNs = this.logNamespaceUsed(nsTagName);

  this.getNamespaces().logUsed(actualNs);

  return nsName(nsTagName);
};

ElementSerializer.prototype.addAttribute = function(name, value) {
  var attrs = this.attrs;

  if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(value)) {
    value = escapeAttr(value);
  }

  attrs.push({ name: name, value: value });
};

ElementSerializer.prototype.serializeAttributes = function(writer) {
  var attrs = this.attrs,
      namespaces = this.namespaces;

  if (namespaces) {
    attrs = getNsAttrs(namespaces).concat(attrs);
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(attrs, function(a) {
    writer
      .append(' ')
      .append(nsName(a.name)).append('="').append(a.value).append('"');
  });
};

ElementSerializer.prototype.serializeTo = function(writer) {
  var firstBody = this.body[0],
      indent = firstBody && firstBody.constructor !== BodySerializer;

  writer
    .appendIndent()
    .append('<' + this.tagName);

  this.serializeAttributes(writer);

  writer.append(firstBody ? '>' : ' />');

  if (firstBody) {

    if (indent) {
      writer
        .appendNewLine()
        .indent();
    }

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(this.body, function(b) {
      b.serializeTo(writer);
    });

    if (indent) {
      writer
        .unindent()
        .appendIndent();
    }

    writer.append('</' + this.tagName + '>');
  }

  writer.appendNewLine();
};

/**
 * A serializer for types that handles serialization of data types
 */
function TypeSerializer(parent, propertyDescriptor) {
  ElementSerializer.call(this, parent, propertyDescriptor);
}

inherits(TypeSerializer, ElementSerializer);

TypeSerializer.prototype.parseNsAttributes = function(element) {

  // extracted attributes
  var attributes = ElementSerializer.prototype.parseNsAttributes.call(this, element);

  var descriptor = element.$descriptor;

  // only serialize xsi:type if necessary
  if (descriptor.name === this.propertyDescriptor.type) {
    return attributes;
  }

  var typeNs = this.typeNs = this.nsTagName(descriptor);
  this.getNamespaces().logUsed(this.typeNs);

  // add xsi:type attribute to represent the elements
  // actual type

  var pkg = element.$model.getPackage(typeNs.uri),
      typePrefix = (pkg.xml && pkg.xml.typePrefix) || '';

  this.addAttribute(
    this.nsAttributeName(XSI_TYPE),
    (typeNs.prefix ? typeNs.prefix + ':' : '') + typePrefix + descriptor.ns.localName
  );

  return attributes;
};

TypeSerializer.prototype.isLocalNs = function(ns) {
  return ns.uri === (this.typeNs || this.ns).uri;
};

function SavingWriter() {
  this.value = '';

  this.write = function(str) {
    this.value += str;
  };
}

function FormatingWriter(out, format) {

  var indent = [''];

  this.append = function(str) {
    out.write(str);

    return this;
  };

  this.appendNewLine = function() {
    if (format) {
      out.write('\n');
    }

    return this;
  };

  this.appendIndent = function() {
    if (format) {
      out.write(indent.join('  '));
    }

    return this;
  };

  this.indent = function() {
    indent.push('');
    return this;
  };

  this.unindent = function() {
    indent.pop();
    return this;
  };
}

/**
 * A writer for meta-model backed document trees
 *
 * @param {Object} options output options to pass into the writer
 */
function Writer(options) {

  options = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({ format: false, preamble: true }, options || {});

  function toXML(tree, writer) {
    var internalWriter = writer || new SavingWriter();
    var formatingWriter = new FormatingWriter(internalWriter, options.format);

    if (options.preamble) {
      formatingWriter.append(XML_PREAMBLE);
    }

    new ElementSerializer().build(tree).serializeTo(formatingWriter);

    if (!writer) {
      return internalWriter.value;
    }
  }

  return {
    toXML: toXML
  };
}




/***/ }),

/***/ "./node_modules/moddle/dist/index.esm.js":
/*!***********************************************!*\
  !*** ./node_modules/moddle/dist/index.esm.js ***!
  \***********************************************/
/*! exports provided: Moddle, coerceType, isBuiltInType, isSimpleType, parseNameNS */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Moddle", function() { return Moddle; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "coerceType", function() { return coerceType; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isBuiltInType", function() { return isBuiltIn; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isSimpleType", function() { return isSimple; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "parseNameNS", function() { return parseName; });
/* harmony import */ var min_dash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! min-dash */ "./node_modules/min-dash/dist/index.esm.js");


/**
 * Moddle base element.
 */
function Base() { }

Base.prototype.get = function(name) {
  return this.$model.properties.get(this, name);
};

Base.prototype.set = function(name, value) {
  this.$model.properties.set(this, name, value);
};

/**
 * A model element factory.
 *
 * @param {Moddle} model
 * @param {Properties} properties
 */
function Factory(model, properties) {
  this.model = model;
  this.properties = properties;
}


Factory.prototype.createType = function(descriptor) {

  var model = this.model;

  var props = this.properties,
      prototype = Object.create(Base.prototype);

  // initialize default values
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(descriptor.properties, function(p) {
    if (!p.isMany && p.default !== undefined) {
      prototype[p.name] = p.default;
    }
  });

  props.defineModel(prototype, model);
  props.defineDescriptor(prototype, descriptor);

  var name = descriptor.ns.name;

  /**
   * The new type constructor
   */
  function ModdleElement(attrs) {
    props.define(this, '$type', { value: name, enumerable: true });
    props.define(this, '$attrs', { value: {} });
    props.define(this, '$parent', { writable: true });

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(attrs, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(function(val, key) {
      this.set(key, val);
    }, this));
  }

  ModdleElement.prototype = prototype;

  ModdleElement.hasType = prototype.$instanceOf = this.model.hasType;

  // static links
  props.defineModel(ModdleElement, model);
  props.defineDescriptor(ModdleElement, descriptor);

  return ModdleElement;
};

/**
 * Built-in moddle types
 */
var BUILTINS = {
  String: true,
  Boolean: true,
  Integer: true,
  Real: true,
  Element: true
};

/**
 * Converters for built in types from string representations
 */
var TYPE_CONVERTERS = {
  String: function(s) { return s; },
  Boolean: function(s) { return s === 'true'; },
  Integer: function(s) { return parseInt(s, 10); },
  Real: function(s) { return parseFloat(s); }
};

/**
 * Convert a type to its real representation
 */
function coerceType(type, value) {

  var converter = TYPE_CONVERTERS[type];

  if (converter) {
    return converter(value);
  } else {
    return value;
  }
}

/**
 * Return whether the given type is built-in
 */
function isBuiltIn(type) {
  return !!BUILTINS[type];
}

/**
 * Return whether the given type is simple
 */
function isSimple(type) {
  return !!TYPE_CONVERTERS[type];
}

/**
 * Parses a namespaced attribute name of the form (ns:)localName to an object,
 * given a default prefix to assume in case no explicit namespace is given.
 *
 * @param {String} name
 * @param {String} [defaultPrefix] the default prefix to take, if none is present.
 *
 * @return {Object} the parsed name
 */
function parseName(name, defaultPrefix) {
  var parts = name.split(/:/),
      localName, prefix;

  // no prefix (i.e. only local name)
  if (parts.length === 1) {
    localName = name;
    prefix = defaultPrefix;
  } else
  // prefix + local name
  if (parts.length === 2) {
    localName = parts[1];
    prefix = parts[0];
  } else {
    throw new Error('expected <prefix:localName> or <localName>, got ' + name);
  }

  name = (prefix ? prefix + ':' : '') + localName;

  return {
    name: name,
    prefix: prefix,
    localName: localName
  };
}

/**
 * A utility to build element descriptors.
 */
function DescriptorBuilder(nameNs) {
  this.ns = nameNs;
  this.name = nameNs.name;
  this.allTypes = [];
  this.allTypesByName = {};
  this.properties = [];
  this.propertiesByName = {};
}


DescriptorBuilder.prototype.build = function() {
  return Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["pick"])(this, [
    'ns',
    'name',
    'allTypes',
    'allTypesByName',
    'properties',
    'propertiesByName',
    'bodyProperty',
    'idProperty'
  ]);
};

/**
 * Add property at given index.
 *
 * @param {Object} p
 * @param {Number} [idx]
 * @param {Boolean} [validate=true]
 */
DescriptorBuilder.prototype.addProperty = function(p, idx, validate) {

  if (typeof idx === 'boolean') {
    validate = idx;
    idx = undefined;
  }

  this.addNamedProperty(p, validate !== false);

  var properties = this.properties;

  if (idx !== undefined) {
    properties.splice(idx, 0, p);
  } else {
    properties.push(p);
  }
};


DescriptorBuilder.prototype.replaceProperty = function(oldProperty, newProperty, replace) {
  var oldNameNs = oldProperty.ns;

  var props = this.properties,
      propertiesByName = this.propertiesByName,
      rename = oldProperty.name !== newProperty.name;

  if (oldProperty.isId) {
    if (!newProperty.isId) {
      throw new Error(
        'property <' + newProperty.ns.name + '> must be id property ' +
        'to refine <' + oldProperty.ns.name + '>');
    }

    this.setIdProperty(newProperty, false);
  }

  if (oldProperty.isBody) {

    if (!newProperty.isBody) {
      throw new Error(
        'property <' + newProperty.ns.name + '> must be body property ' +
        'to refine <' + oldProperty.ns.name + '>');
    }

    // TODO: Check compatibility
    this.setBodyProperty(newProperty, false);
  }

  // validate existence and get location of old property
  var idx = props.indexOf(oldProperty);
  if (idx === -1) {
    throw new Error('property <' + oldNameNs.name + '> not found in property list');
  }

  // remove old property
  props.splice(idx, 1);

  // replacing the named property is intentional
  //
  //  * validate only if this is a "rename" operation
  //  * add at specific index unless we "replace"
  //
  this.addProperty(newProperty, replace ? undefined : idx, rename);

  // make new property available under old name
  propertiesByName[oldNameNs.name] = propertiesByName[oldNameNs.localName] = newProperty;
};


DescriptorBuilder.prototype.redefineProperty = function(p, targetPropertyName, replace) {

  var nsPrefix = p.ns.prefix;
  var parts = targetPropertyName.split('#');

  var name = parseName(parts[0], nsPrefix);
  var attrName = parseName(parts[1], name.prefix).name;

  var redefinedProperty = this.propertiesByName[attrName];
  if (!redefinedProperty) {
    throw new Error('refined property <' + attrName + '> not found');
  } else {
    this.replaceProperty(redefinedProperty, p, replace);
  }

  delete p.redefines;
};

DescriptorBuilder.prototype.addNamedProperty = function(p, validate) {
  var ns = p.ns,
      propsByName = this.propertiesByName;

  if (validate) {
    this.assertNotDefined(p, ns.name);
    this.assertNotDefined(p, ns.localName);
  }

  propsByName[ns.name] = propsByName[ns.localName] = p;
};

DescriptorBuilder.prototype.removeNamedProperty = function(p) {
  var ns = p.ns,
      propsByName = this.propertiesByName;

  delete propsByName[ns.name];
  delete propsByName[ns.localName];
};

DescriptorBuilder.prototype.setBodyProperty = function(p, validate) {

  if (validate && this.bodyProperty) {
    throw new Error(
      'body property defined multiple times ' +
      '(<' + this.bodyProperty.ns.name + '>, <' + p.ns.name + '>)');
  }

  this.bodyProperty = p;
};

DescriptorBuilder.prototype.setIdProperty = function(p, validate) {

  if (validate && this.idProperty) {
    throw new Error(
      'id property defined multiple times ' +
      '(<' + this.idProperty.ns.name + '>, <' + p.ns.name + '>)');
  }

  this.idProperty = p;
};

DescriptorBuilder.prototype.assertNotDefined = function(p, name) {
  var propertyName = p.name,
      definedProperty = this.propertiesByName[propertyName];

  if (definedProperty) {
    throw new Error(
      'property <' + propertyName + '> already defined; ' +
      'override of <' + definedProperty.definedBy.ns.name + '#' + definedProperty.ns.name + '> by ' +
      '<' + p.definedBy.ns.name + '#' + p.ns.name + '> not allowed without redefines');
  }
};

DescriptorBuilder.prototype.hasProperty = function(name) {
  return this.propertiesByName[name];
};

DescriptorBuilder.prototype.addTrait = function(t, inherited) {

  var typesByName = this.allTypesByName,
      types = this.allTypes;

  var typeName = t.name;

  if (typeName in typesByName) {
    return;
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(t.properties, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(function(p) {

    // clone property to allow extensions
    p = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, p, {
      name: p.ns.localName,
      inherited: inherited
    });

    Object.defineProperty(p, 'definedBy', {
      value: t
    });

    var replaces = p.replaces,
        redefines = p.redefines;

    // add replace/redefine support
    if (replaces || redefines) {
      this.redefineProperty(p, replaces || redefines, replaces);
    } else {
      if (p.isBody) {
        this.setBodyProperty(p);
      }
      if (p.isId) {
        this.setIdProperty(p);
      }
      this.addProperty(p);
    }
  }, this));

  types.push(t);
  typesByName[typeName] = t;
};

/**
 * A registry of Moddle packages.
 *
 * @param {Array<Package>} packages
 * @param {Properties} properties
 */
function Registry(packages, properties) {
  this.packageMap = {};
  this.typeMap = {};

  this.packages = [];

  this.properties = properties;

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(packages, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(this.registerPackage, this));
}


Registry.prototype.getPackage = function(uriOrPrefix) {
  return this.packageMap[uriOrPrefix];
};

Registry.prototype.getPackages = function() {
  return this.packages;
};


Registry.prototype.registerPackage = function(pkg) {

  // copy package
  pkg = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, pkg);

  var pkgMap = this.packageMap;

  ensureAvailable(pkgMap, pkg, 'prefix');
  ensureAvailable(pkgMap, pkg, 'uri');

  // register types
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(pkg.types, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(function(descriptor) {
    this.registerType(descriptor, pkg);
  }, this));

  pkgMap[pkg.uri] = pkgMap[pkg.prefix] = pkg;
  this.packages.push(pkg);
};


/**
 * Register a type from a specific package with us
 */
Registry.prototype.registerType = function(type, pkg) {

  type = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])({}, type, {
    superClass: (type.superClass || []).slice(),
    extends: (type.extends || []).slice(),
    properties: (type.properties || []).slice(),
    meta: Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])((type.meta || {}))
  });

  var ns = parseName(type.name, pkg.prefix),
      name = ns.name,
      propertiesByName = {};

  // parse properties
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(type.properties, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(function(p) {

    // namespace property names
    var propertyNs = parseName(p.name, ns.prefix),
        propertyName = propertyNs.name;

    // namespace property types
    if (!isBuiltIn(p.type)) {
      p.type = parseName(p.type, propertyNs.prefix).name;
    }

    Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(p, {
      ns: propertyNs,
      name: propertyName
    });

    propertiesByName[propertyName] = p;
  }, this));

  // update ns + name
  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["assign"])(type, {
    ns: ns,
    name: name,
    propertiesByName: propertiesByName
  });

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(type.extends, Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["bind"])(function(extendsName) {
    var extended = this.typeMap[extendsName];

    extended.traits = extended.traits || [];
    extended.traits.push(name);
  }, this));

  // link to package
  this.definePackage(type, pkg);

  // register
  this.typeMap[name] = type;
};


/**
 * Traverse the type hierarchy from bottom to top,
 * calling iterator with (type, inherited) for all elements in
 * the inheritance chain.
 *
 * @param {Object} nsName
 * @param {Function} iterator
 * @param {Boolean} [trait=false]
 */
Registry.prototype.mapTypes = function(nsName, iterator, trait) {

  var type = isBuiltIn(nsName.name) ? { name: nsName.name } : this.typeMap[nsName.name];

  var self = this;

  /**
   * Traverse the selected trait.
   *
   * @param {String} cls
   */
  function traverseTrait(cls) {
    return traverseSuper(cls, true);
  }

  /**
   * Traverse the selected super type or trait
   *
   * @param {String} cls
   * @param {Boolean} [trait=false]
   */
  function traverseSuper(cls, trait) {
    var parentNs = parseName(cls, isBuiltIn(cls) ? '' : nsName.prefix);
    self.mapTypes(parentNs, iterator, trait);
  }

  if (!type) {
    throw new Error('unknown type <' + nsName.name + '>');
  }

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(type.superClass, trait ? traverseTrait : traverseSuper);

  // call iterator with (type, inherited=!trait)
  iterator(type, !trait);

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(type.traits, traverseTrait);
};


/**
 * Returns the effective descriptor for a type.
 *
 * @param  {String} type the namespaced name (ns:localName) of the type
 *
 * @return {Descriptor} the resulting effective descriptor
 */
Registry.prototype.getEffectiveDescriptor = function(name) {

  var nsName = parseName(name);

  var builder = new DescriptorBuilder(nsName);

  this.mapTypes(nsName, function(type, inherited) {
    builder.addTrait(type, inherited);
  });

  var descriptor = builder.build();

  // define package link
  this.definePackage(descriptor, descriptor.allTypes[descriptor.allTypes.length - 1].$pkg);

  return descriptor;
};


Registry.prototype.definePackage = function(target, pkg) {
  this.properties.define(target, '$pkg', { value: pkg });
};



///////// helpers ////////////////////////////

function ensureAvailable(packageMap, pkg, identifierKey) {

  var value = pkg[identifierKey];

  if (value in packageMap) {
    throw new Error('package with ' + identifierKey + ' <' + value + '> already defined');
  }
}

/**
 * A utility that gets and sets properties of model elements.
 *
 * @param {Model} model
 */
function Properties(model) {
  this.model = model;
}


/**
 * Sets a named property on the target element.
 * If the value is undefined, the property gets deleted.
 *
 * @param {Object} target
 * @param {String} name
 * @param {Object} value
 */
Properties.prototype.set = function(target, name, value) {

  var property = this.model.getPropertyDescriptor(target, name);

  var propertyName = property && property.name;

  if (isUndefined(value)) {
    // unset the property, if the specified value is undefined;
    // delete from $attrs (for extensions) or the target itself
    if (property) {
      delete target[propertyName];
    } else {
      delete target.$attrs[name];
    }
  } else {
    // set the property, defining well defined properties on the fly
    // or simply updating them in target.$attrs (for extensions)
    if (property) {
      if (propertyName in target) {
        target[propertyName] = value;
      } else {
        defineProperty(target, property, value);
      }
    } else {
      target.$attrs[name] = value;
    }
  }
};

/**
 * Returns the named property of the given element
 *
 * @param  {Object} target
 * @param  {String} name
 *
 * @return {Object}
 */
Properties.prototype.get = function(target, name) {

  var property = this.model.getPropertyDescriptor(target, name);

  if (!property) {
    return target.$attrs[name];
  }

  var propertyName = property.name;

  // check if access to collection property and lazily initialize it
  if (!target[propertyName] && property.isMany) {
    defineProperty(target, property, []);
  }

  return target[propertyName];
};


/**
 * Define a property on the target element
 *
 * @param  {Object} target
 * @param  {String} name
 * @param  {Object} options
 */
Properties.prototype.define = function(target, name, options) {
  Object.defineProperty(target, name, options);
};


/**
 * Define the descriptor for an element
 */
Properties.prototype.defineDescriptor = function(target, descriptor) {
  this.define(target, '$descriptor', { value: descriptor });
};

/**
 * Define the model for an element
 */
Properties.prototype.defineModel = function(target, model) {
  this.define(target, '$model', { value: model });
};


function isUndefined(val) {
  return typeof val === 'undefined';
}

function defineProperty(target, property, value) {
  Object.defineProperty(target, property.name, {
    enumerable: !property.isReference,
    writable: true,
    value: value,
    configurable: true
  });
}

//// Moddle implementation /////////////////////////////////////////////////

/**
 * @class Moddle
 *
 * A model that can be used to create elements of a specific type.
 *
 * @example
 *
 * var Moddle = require('moddle');
 *
 * var pkg = {
 *   name: 'mypackage',
 *   prefix: 'my',
 *   types: [
 *     { name: 'Root' }
 *   ]
 * };
 *
 * var moddle = new Moddle([pkg]);
 *
 * @param {Array<Package>} packages the packages to contain
 */
function Moddle(packages) {

  this.properties = new Properties(this);

  this.factory = new Factory(this, this.properties);
  this.registry = new Registry(packages, this.properties);

  this.typeCache = {};
}


/**
 * Create an instance of the specified type.
 *
 * @method Moddle#create
 *
 * @example
 *
 * var foo = moddle.create('my:Foo');
 * var bar = moddle.create('my:Bar', { id: 'BAR_1' });
 *
 * @param  {String|Object} descriptor the type descriptor or name know to the model
 * @param  {Object} attrs   a number of attributes to initialize the model instance with
 * @return {Object}         model instance
 */
Moddle.prototype.create = function(descriptor, attrs) {
  var Type = this.getType(descriptor);

  if (!Type) {
    throw new Error('unknown type <' + descriptor + '>');
  }

  return new Type(attrs);
};


/**
 * Returns the type representing a given descriptor
 *
 * @method Moddle#getType
 *
 * @example
 *
 * var Foo = moddle.getType('my:Foo');
 * var foo = new Foo({ 'id' : 'FOO_1' });
 *
 * @param  {String|Object} descriptor the type descriptor or name know to the model
 * @return {Object}         the type representing the descriptor
 */
Moddle.prototype.getType = function(descriptor) {

  var cache = this.typeCache;

  var name = Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isString"])(descriptor) ? descriptor : descriptor.ns.name;

  var type = cache[name];

  if (!type) {
    descriptor = this.registry.getEffectiveDescriptor(name);
    type = cache[name] = this.factory.createType(descriptor);
  }

  return type;
};


/**
 * Creates an any-element type to be used within model instances.
 *
 * This can be used to create custom elements that lie outside the meta-model.
 * The created element contains all the meta-data required to serialize it
 * as part of meta-model elements.
 *
 * @method Moddle#createAny
 *
 * @example
 *
 * var foo = moddle.createAny('vendor:Foo', 'http://vendor', {
 *   value: 'bar'
 * });
 *
 * var container = moddle.create('my:Container', 'http://my', {
 *   any: [ foo ]
 * });
 *
 * // go ahead and serialize the stuff
 *
 *
 * @param  {String} name  the name of the element
 * @param  {String} nsUri the namespace uri of the element
 * @param  {Object} [properties] a map of properties to initialize the instance with
 * @return {Object} the any type instance
 */
Moddle.prototype.createAny = function(name, nsUri, properties) {

  var nameNs = parseName(name);

  var element = {
    $type: name,
    $instanceOf: function(type) {
      return type === this.$type;
    }
  };

  var descriptor = {
    name: name,
    isGeneric: true,
    ns: {
      prefix: nameNs.prefix,
      localName: nameNs.localName,
      uri: nsUri
    }
  };

  this.properties.defineDescriptor(element, descriptor);
  this.properties.defineModel(element, this);
  this.properties.define(element, '$parent', { enumerable: false, writable: true });
  this.properties.define(element, '$instanceOf', { enumerable: false, writable: true });

  Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["forEach"])(properties, function(a, key) {
    if (Object(min_dash__WEBPACK_IMPORTED_MODULE_0__["isObject"])(a) && a.value !== undefined) {
      element[a.name] = a.value;
    } else {
      element[key] = a;
    }
  });

  return element;
};

/**
 * Returns a registered package by uri or prefix
 *
 * @return {Object} the package
 */
Moddle.prototype.getPackage = function(uriOrPrefix) {
  return this.registry.getPackage(uriOrPrefix);
};

/**
 * Returns a snapshot of all known packages
 *
 * @return {Object} the package
 */
Moddle.prototype.getPackages = function() {
  return this.registry.getPackages();
};

/**
 * Returns the descriptor for an element
 */
Moddle.prototype.getElementDescriptor = function(element) {
  return element.$descriptor;
};

/**
 * Returns true if the given descriptor or instance
 * represents the given type.
 *
 * May be applied to this, if element is omitted.
 */
Moddle.prototype.hasType = function(element, type) {
  if (type === undefined) {
    type = element;
    element = this;
  }

  var descriptor = element.$model.getElementDescriptor(element);

  return (type in descriptor.allTypesByName);
};

/**
 * Returns the descriptor of an elements named property
 */
Moddle.prototype.getPropertyDescriptor = function(element, property) {
  return this.getElementDescriptor(element).propertiesByName[property];
};

/**
 * Returns a mapped type's descriptor
 */
Moddle.prototype.getTypeDescriptor = function(type) {
  return this.registry.typeMap[type];
};




/***/ }),

/***/ "./node_modules/object-refs/index.js":
/*!*******************************************!*\
  !*** ./node_modules/object-refs/index.js ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! ./lib/refs */ "./node_modules/object-refs/lib/refs.js");

module.exports.Collection = __webpack_require__(/*! ./lib/collection */ "./node_modules/object-refs/lib/collection.js");

/***/ }),

/***/ "./node_modules/object-refs/lib/collection.js":
/*!****************************************************!*\
  !*** ./node_modules/object-refs/lib/collection.js ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/**
 * An empty collection stub. Use {@link RefsCollection.extend} to extend a
 * collection with ref semantics.
 *
 * @class RefsCollection
 */

/**
 * Extends a collection with {@link Refs} aware methods
 *
 * @memberof RefsCollection
 * @static
 *
 * @param  {Array<Object>} collection
 * @param  {Refs} refs instance
 * @param  {Object} property represented by the collection
 * @param  {Object} target object the collection is attached to
 *
 * @return {RefsCollection<Object>} the extended array
 */
function extend(collection, refs, property, target) {

  var inverseProperty = property.inverse;

  /**
   * Removes the given element from the array and returns it.
   *
   * @method RefsCollection#remove
   *
   * @param {Object} element the element to remove
   */
  Object.defineProperty(collection, 'remove', {
    value: function(element) {
      var idx = this.indexOf(element);
      if (idx !== -1) {
        this.splice(idx, 1);

        // unset inverse
        refs.unset(element, inverseProperty, target);
      }

      return element;
    }
  });

  /**
   * Returns true if the collection contains the given element
   *
   * @method RefsCollection#contains
   *
   * @param {Object} element the element to check for
   */
  Object.defineProperty(collection, 'contains', {
    value: function(element) {
      return this.indexOf(element) !== -1;
    }
  });

  /**
   * Adds an element to the array, unless it exists already (set semantics).
   *
   * @method RefsCollection#add
   *
   * @param {Object} element the element to add
   * @param {Number} optional index to add element to
   *                 (possibly moving other elements around)
   */
  Object.defineProperty(collection, 'add', {
    value: function(element, idx) {

      var currentIdx = this.indexOf(element);

      if (typeof idx === 'undefined') {

        if (currentIdx !== -1) {
          // element already in collection (!)
          return;
        }

        // add to end of array, as no idx is specified
        idx = this.length;
      }

      // handle already in collection
      if (currentIdx !== -1) {

        // remove element from currentIdx
        this.splice(currentIdx, 1);
      }

      // add element at idx
      this.splice(idx, 0, element);

      if (currentIdx === -1) {
        // set inverse, unless element was
        // in collection already
        refs.set(element, inverseProperty, target);
      }
    }
  });

  // a simple marker, identifying this element
  // as being a refs collection
  Object.defineProperty(collection, '__refs_collection', {
    value: true
  });

  return collection;
}


function isExtended(collection) {
  return collection.__refs_collection === true;
}

module.exports.extend = extend;

module.exports.isExtended = isExtended;

/***/ }),

/***/ "./node_modules/object-refs/lib/refs.js":
/*!**********************************************!*\
  !*** ./node_modules/object-refs/lib/refs.js ***!
  \**********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var Collection = __webpack_require__(/*! ./collection */ "./node_modules/object-refs/lib/collection.js");

function hasOwnProperty(e, property) {
  return Object.prototype.hasOwnProperty.call(e, property.name || property);
}

function defineCollectionProperty(ref, property, target) {

  var collection = Collection.extend(target[property.name] || [], ref, property, target);

  Object.defineProperty(target, property.name, {
    enumerable: property.enumerable,
    value: collection
  });

  if (collection.length) {

    collection.forEach(function(o) {
      ref.set(o, property.inverse, target);
    });
  }
}


function defineProperty(ref, property, target) {

  var inverseProperty = property.inverse;

  var _value = target[property.name];

  Object.defineProperty(target, property.name, {
    configurable: property.configurable,
    enumerable: property.enumerable,

    get: function() {
      return _value;
    },

    set: function(value) {

      // return if we already performed all changes
      if (value === _value) {
        return;
      }

      var old = _value;

      // temporary set null
      _value = null;

      if (old) {
        ref.unset(old, inverseProperty, target);
      }

      // set new value
      _value = value;

      // set inverse value
      ref.set(_value, inverseProperty, target);
    }
  });

}

/**
 * Creates a new references object defining two inversly related
 * attribute descriptors a and b.
 *
 * <p>
 *   When bound to an object using {@link Refs#bind} the references
 *   get activated and ensure that add and remove operations are applied
 *   reversely, too.
 * </p>
 *
 * <p>
 *   For attributes represented as collections {@link Refs} provides the
 *   {@link RefsCollection#add}, {@link RefsCollection#remove} and {@link RefsCollection#contains} extensions
 *   that must be used to properly hook into the inverse change mechanism.
 * </p>
 *
 * @class Refs
 *
 * @classdesc A bi-directional reference between two attributes.
 *
 * @param {Refs.AttributeDescriptor} a property descriptor
 * @param {Refs.AttributeDescriptor} b property descriptor
 *
 * @example
 *
 * var refs = Refs({ name: 'wheels', collection: true, enumerable: true }, { name: 'car' });
 *
 * var car = { name: 'toyota' };
 * var wheels = [{ pos: 'front-left' }, { pos: 'front-right' }];
 *
 * refs.bind(car, 'wheels');
 *
 * car.wheels // []
 * car.wheels.add(wheels[0]);
 * car.wheels.add(wheels[1]);
 *
 * car.wheels // [{ pos: 'front-left' }, { pos: 'front-right' }]
 *
 * wheels[0].car // { name: 'toyota' };
 * car.wheels.remove(wheels[0]);
 *
 * wheels[0].car // undefined
 */
function Refs(a, b) {

  if (!(this instanceof Refs)) {
    return new Refs(a, b);
  }

  // link
  a.inverse = b;
  b.inverse = a;

  this.props = {};
  this.props[a.name] = a;
  this.props[b.name] = b;
}

/**
 * Binds one side of a bi-directional reference to a
 * target object.
 *
 * @memberOf Refs
 *
 * @param  {Object} target
 * @param  {String} property
 */
Refs.prototype.bind = function(target, property) {
  if (typeof property === 'string') {
    if (!this.props[property]) {
      throw new Error('no property <' + property + '> in ref');
    }
    property = this.props[property];
  }

  if (property.collection) {
    defineCollectionProperty(this, property, target);
  } else {
    defineProperty(this, property, target);
  }
};

Refs.prototype.ensureRefsCollection = function(target, property) {

  var collection = target[property.name];

  if (!Collection.isExtended(collection)) {
    defineCollectionProperty(this, property, target);
  }

  return collection;
};

Refs.prototype.ensureBound = function(target, property) {
  if (!hasOwnProperty(target, property)) {
    this.bind(target, property);
  }
};

Refs.prototype.unset = function(target, property, value) {

  if (target) {
    this.ensureBound(target, property);

    if (property.collection) {
      this.ensureRefsCollection(target, property).remove(value);
    } else {
      target[property.name] = undefined;
    }
  }
};

Refs.prototype.set = function(target, property, value) {

  if (target) {
    this.ensureBound(target, property);

    if (property.collection) {
      this.ensureRefsCollection(target, property).add(value);
    } else {
      target[property.name] = value;
    }
  }
};

module.exports = Refs;


/**
 * An attribute descriptor to be used specify an attribute in a {@link Refs} instance
 *
 * @typedef {Object} Refs.AttributeDescriptor
 * @property {String} name
 * @property {boolean} [collection=false]
 * @property {boolean} [enumerable=false]
 */

/***/ }),

/***/ "./node_modules/path-intersection/intersect.js":
/*!*****************************************************!*\
  !*** ./node_modules/path-intersection/intersect.js ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/**
 * This file contains source code adapted from Snap.svg (licensed Apache-2.0).
 *
 * @see https://github.com/adobe-webplatform/Snap.svg/blob/master/src/path.js
 */

/* eslint no-fallthrough: "off" */

var p2s = /,?([a-z]),?/gi,
    toFloat = parseFloat,
    math = Math,
    PI = math.PI,
    mmin = math.min,
    mmax = math.max,
    pow = math.pow,
    abs = math.abs,
    pathCommand = /([a-z])[\s,]*((-?\d*\.?\d*(?:e[-+]?\d+)?[\s]*,?[\s]*)+)/ig,
    pathValues = /(-?\d*\.?\d*(?:e[-+]?\d+)?)[\s]*,?[\s]*/ig;

var isArray = Array.isArray || function(o) { return o instanceof Array; };

function hasProperty(obj, property) {
  return Object.prototype.hasOwnProperty.call(obj, property);
}

function clone(obj) {

  if (typeof obj == 'function' || Object(obj) !== obj) {
    return obj;
  }

  var res = new obj.constructor;

  for (var key in obj) {
    if (hasProperty(obj, key)) {
      res[key] = clone(obj[key]);
    }
  }

  return res;
}

function repush(array, item) {
  for (var i = 0, ii = array.length; i < ii; i++) if (array[i] === item) {
    return array.push(array.splice(i, 1)[0]);
  }
}

function cacher(f) {

  function newf() {

    var arg = Array.prototype.slice.call(arguments, 0),
        args = arg.join('\u2400'),
        cache = newf.cache = newf.cache || {},
        count = newf.count = newf.count || [];

    if (hasProperty(cache, args)) {
      repush(count, args);
      return cache[args];
    }

    count.length >= 1e3 && delete cache[count.shift()];
    count.push(args);
    cache[args] = f.apply(0, arg);

    return cache[args];
  }
  return newf;
}

function parsePathString(pathString) {

  if (!pathString) {
    return null;
  }

  var pth = paths(pathString);

  if (pth.arr) {
    return clone(pth.arr);
  }

  var paramCounts = { a: 7, c: 6, h: 1, l: 2, m: 2, q: 4, s: 4, t: 2, v: 1, z: 0 },
      data = [];

  if (isArray(pathString) && isArray(pathString[0])) { // rough assumption
    data = clone(pathString);
  }

  if (!data.length) {

    String(pathString).replace(pathCommand, function(a, b, c) {
      var params = [],
          name = b.toLowerCase();

      c.replace(pathValues, function(a, b) {
        b && params.push(+b);
      });

      if (name == 'm' && params.length > 2) {
        data.push([b].concat(params.splice(0, 2)));
        name = 'l';
        b = b == 'm' ? 'l' : 'L';
      }

      while (params.length >= paramCounts[name]) {
        data.push([b].concat(params.splice(0, paramCounts[name])));
        if (!paramCounts[name]) {
          break;
        }
      }
    });
  }

  data.toString = paths.toString;
  pth.arr = clone(data);

  return data;
}

function paths(ps) {
  var p = paths.ps = paths.ps || {};

  if (p[ps]) {
    p[ps].sleep = 100;
  } else {
    p[ps] = {
      sleep: 100
    };
  }

  setTimeout(function() {
    for (var key in p) {
      if (hasProperty(p, key) && key != ps) {
        p[key].sleep--;
        !p[key].sleep && delete p[key];
      }
    }
  });

  return p[ps];
}

function rectBBox(x, y, width, height) {

  if (arguments.length === 1) {
    y = x.y;
    width = x.width;
    height = x.height;
    x = x.x;
  }

  return {
    x: x,
    y: y,
    width: width,
    height: height,
    x2: x + width,
    y2: y + height
  };
}

function pathToString() {
  return this.join(',').replace(p2s, '$1');
}

function pathClone(pathArray) {
  var res = clone(pathArray);
  res.toString = pathToString;
  return res;
}

function findDotsAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t) {
  var t1 = 1 - t,
      t13 = pow(t1, 3),
      t12 = pow(t1, 2),
      t2 = t * t,
      t3 = t2 * t,
      x = t13 * p1x + t12 * 3 * t * c1x + t1 * 3 * t * t * c2x + t3 * p2x,
      y = t13 * p1y + t12 * 3 * t * c1y + t1 * 3 * t * t * c2y + t3 * p2y;

  return {
    x: fixError(x),
    y: fixError(y)
  };
}

function bezierBBox(points) {

  var bbox = curveBBox.apply(null, points);

  return rectBBox(
    bbox.x0,
    bbox.y0,
    bbox.x1 - bbox.x0,
    bbox.y1 - bbox.y0
  );
}

function isPointInsideBBox(bbox, x, y) {
  return x >= bbox.x &&
    x <= bbox.x + bbox.width &&
    y >= bbox.y &&
    y <= bbox.y + bbox.height;
}

function isBBoxIntersect(bbox1, bbox2) {
  bbox1 = rectBBox(bbox1);
  bbox2 = rectBBox(bbox2);
  return isPointInsideBBox(bbox2, bbox1.x, bbox1.y)
    || isPointInsideBBox(bbox2, bbox1.x2, bbox1.y)
    || isPointInsideBBox(bbox2, bbox1.x, bbox1.y2)
    || isPointInsideBBox(bbox2, bbox1.x2, bbox1.y2)
    || isPointInsideBBox(bbox1, bbox2.x, bbox2.y)
    || isPointInsideBBox(bbox1, bbox2.x2, bbox2.y)
    || isPointInsideBBox(bbox1, bbox2.x, bbox2.y2)
    || isPointInsideBBox(bbox1, bbox2.x2, bbox2.y2)
    || (bbox1.x < bbox2.x2 && bbox1.x > bbox2.x
        || bbox2.x < bbox1.x2 && bbox2.x > bbox1.x)
    && (bbox1.y < bbox2.y2 && bbox1.y > bbox2.y
        || bbox2.y < bbox1.y2 && bbox2.y > bbox1.y);
}

function base3(t, p1, p2, p3, p4) {
  var t1 = -3 * p1 + 9 * p2 - 9 * p3 + 3 * p4,
      t2 = t * t1 + 6 * p1 - 12 * p2 + 6 * p3;
  return t * t2 - 3 * p1 + 3 * p2;
}

function bezlen(x1, y1, x2, y2, x3, y3, x4, y4, z) {

  if (z == null) {
    z = 1;
  }

  z = z > 1 ? 1 : z < 0 ? 0 : z;

  var z2 = z / 2,
      n = 12,
      Tvalues = [-.1252,.1252,-.3678,.3678,-.5873,.5873,-.7699,.7699,-.9041,.9041,-.9816,.9816],
      Cvalues = [0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],
      sum = 0;

  for (var i = 0; i < n; i++) {
    var ct = z2 * Tvalues[i] + z2,
        xbase = base3(ct, x1, x2, x3, x4),
        ybase = base3(ct, y1, y2, y3, y4),
        comb = xbase * xbase + ybase * ybase;

    sum += Cvalues[i] * math.sqrt(comb);
  }

  return z2 * sum;
}


function intersectLines(x1, y1, x2, y2, x3, y3, x4, y4) {

  if (
    mmax(x1, x2) < mmin(x3, x4) ||
      mmin(x1, x2) > mmax(x3, x4) ||
      mmax(y1, y2) < mmin(y3, y4) ||
      mmin(y1, y2) > mmax(y3, y4)
  ) {
    return;
  }

  var nx = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4),
      ny = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4),
      denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

  if (!denominator) {
    return;
  }

  var px = fixError(nx / denominator),
      py = fixError(ny / denominator),
      px2 = +px.toFixed(2),
      py2 = +py.toFixed(2);

  if (
    px2 < +mmin(x1, x2).toFixed(2) ||
      px2 > +mmax(x1, x2).toFixed(2) ||
      px2 < +mmin(x3, x4).toFixed(2) ||
      px2 > +mmax(x3, x4).toFixed(2) ||
      py2 < +mmin(y1, y2).toFixed(2) ||
      py2 > +mmax(y1, y2).toFixed(2) ||
      py2 < +mmin(y3, y4).toFixed(2) ||
      py2 > +mmax(y3, y4).toFixed(2)
  ) {
    return;
  }

  return { x: px, y: py };
}

function fixError(number) {
  return Math.round(number * 100000000000) / 100000000000;
}

function findBezierIntersections(bez1, bez2, justCount) {
  var bbox1 = bezierBBox(bez1),
      bbox2 = bezierBBox(bez2);

  if (!isBBoxIntersect(bbox1, bbox2)) {
    return justCount ? 0 : [];
  }

  // As an optimization, lines will have only 1 segment

  var l1 = bezlen.apply(0, bez1),
      l2 = bezlen.apply(0, bez2),
      n1 = isLine(bez1) ? 1 : ~~(l1 / 5) || 1,
      n2 = isLine(bez2) ? 1 : ~~(l2 / 5) || 1,
      dots1 = [],
      dots2 = [],
      xy = {},
      res = justCount ? 0 : [];

  for (var i = 0; i < n1 + 1; i++) {
    var p = findDotsAtSegment.apply(0, bez1.concat(i / n1));
    dots1.push({ x: p.x, y: p.y, t: i / n1 });
  }

  for (i = 0; i < n2 + 1; i++) {
    p = findDotsAtSegment.apply(0, bez2.concat(i / n2));
    dots2.push({ x: p.x, y: p.y, t: i / n2 });
  }

  for (i = 0; i < n1; i++) {

    for (var j = 0; j < n2; j++) {
      var di = dots1[i],
          di1 = dots1[i + 1],
          dj = dots2[j],
          dj1 = dots2[j + 1],
          ci = abs(di1.x - di.x) < .01 ? 'y' : 'x',
          cj = abs(dj1.x - dj.x) < .01 ? 'y' : 'x',
          is = intersectLines(di.x, di.y, di1.x, di1.y, dj.x, dj.y, dj1.x, dj1.y),
          key;

      if (is) {
        key = is.x.toFixed(9) + '#' + is.y.toFixed(9);

        if (xy[key]) {
          continue;
        }

        xy[key] = true;

        var t1 = di.t + abs((is[ci] - di[ci]) / (di1[ci] - di[ci])) * (di1.t - di.t),
            t2 = dj.t + abs((is[cj] - dj[cj]) / (dj1[cj] - dj[cj])) * (dj1.t - dj.t);

        if (t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1) {

          if (justCount) {
            res++;
          } else {
            res.push({
              x: is.x,
              y: is.y,
              t1: t1,
              t2: t2
            });
          }
        }
      }
    }
  }

  return res;
}


/**
 * Find or counts the intersections between two SVG paths.
 *
 * Returns a number in counting mode and a list of intersections otherwise.
 *
 * A single intersection entry contains the intersection coordinates (x, y)
 * as well as additional information regarding the intersecting segments
 * on each path (segment1, segment2) and the relative location of the
 * intersection on these segments (t1, t2).
 *
 * The path may be an SVG path string or a list of path components
 * such as `[ [ 'M', 0, 10 ], [ 'L', 20, 0 ] ]`.
 *
 * @example
 *
 * var intersections = findPathIntersections(
 *   'M0,0L100,100',
 *   [ [ 'M', 0, 100 ], [ 'L', 100, 0 ] ]
 * );
 *
 * // intersections = [
 * //   { x: 50, y: 50, segment1: 1, segment2: 1, t1: 0.5, t2: 0.5 }
 * // ]
 *
 * @param {String|Array<PathDef>} path1
 * @param {String|Array<PathDef>} path2
 * @param {Boolean} [justCount=false]
 *
 * @return {Array<Intersection>|Number}
 */
function findPathIntersections(path1, path2, justCount) {
  path1 = pathToCurve(path1);
  path2 = pathToCurve(path2);

  var x1, y1, x2, y2, x1m, y1m, x2m, y2m, bez1, bez2,
      res = justCount ? 0 : [];

  for (var i = 0, ii = path1.length; i < ii; i++) {
    var pi = path1[i];

    if (pi[0] == 'M') {
      x1 = x1m = pi[1];
      y1 = y1m = pi[2];
    } else {

      if (pi[0] == 'C') {
        bez1 = [x1, y1].concat(pi.slice(1));
        x1 = bez1[6];
        y1 = bez1[7];
      } else {
        bez1 = [x1, y1, x1, y1, x1m, y1m, x1m, y1m];
        x1 = x1m;
        y1 = y1m;
      }

      for (var j = 0, jj = path2.length; j < jj; j++) {
        var pj = path2[j];

        if (pj[0] == 'M') {
          x2 = x2m = pj[1];
          y2 = y2m = pj[2];
        } else {

          if (pj[0] == 'C') {
            bez2 = [x2, y2].concat(pj.slice(1));
            x2 = bez2[6];
            y2 = bez2[7];
          } else {
            bez2 = [x2, y2, x2, y2, x2m, y2m, x2m, y2m];
            x2 = x2m;
            y2 = y2m;
          }

          var intr = findBezierIntersections(bez1, bez2, justCount);

          if (justCount) {
            res += intr;
          } else {

            for (var k = 0, kk = intr.length; k < kk; k++) {
              intr[k].segment1 = i;
              intr[k].segment2 = j;
              intr[k].bez1 = bez1;
              intr[k].bez2 = bez2;
            }

            res = res.concat(intr);
          }
        }
      }
    }
  }

  return res;
}


function pathToAbsolute(pathArray) {
  var pth = paths(pathArray);

  if (pth.abs) {
    return pathClone(pth.abs);
  }

  if (!isArray(pathArray) || !isArray(pathArray && pathArray[0])) { // rough assumption
    pathArray = parsePathString(pathArray);
  }

  if (!pathArray || !pathArray.length) {
    return [['M', 0, 0]];
  }

  var res = [],
      x = 0,
      y = 0,
      mx = 0,
      my = 0,
      start = 0,
      pa0;

  if (pathArray[0][0] == 'M') {
    x = +pathArray[0][1];
    y = +pathArray[0][2];
    mx = x;
    my = y;
    start++;
    res[0] = ['M', x, y];
  }

  for (var r, pa, i = start, ii = pathArray.length; i < ii; i++) {
    res.push(r = []);
    pa = pathArray[i];
    pa0 = pa[0];

    if (pa0 != pa0.toUpperCase()) {
      r[0] = pa0.toUpperCase();

      switch (r[0]) {
      case 'A':
        r[1] = pa[1];
        r[2] = pa[2];
        r[3] = pa[3];
        r[4] = pa[4];
        r[5] = pa[5];
        r[6] = +pa[6] + x;
        r[7] = +pa[7] + y;
        break;
      case 'V':
        r[1] = +pa[1] + y;
        break;
      case 'H':
        r[1] = +pa[1] + x;
        break;
      case 'M':
        mx = +pa[1] + x;
        my = +pa[2] + y;
      default:
        for (var j = 1, jj = pa.length; j < jj; j++) {
          r[j] = +pa[j] + ((j % 2) ? x : y);
        }
      }
    } else {
      for (var k = 0, kk = pa.length; k < kk; k++) {
        r[k] = pa[k];
      }
    }
    pa0 = pa0.toUpperCase();

    switch (r[0]) {
    case 'Z':
      x = +mx;
      y = +my;
      break;
    case 'H':
      x = r[1];
      break;
    case 'V':
      y = r[1];
      break;
    case 'M':
      mx = r[r.length - 2];
      my = r[r.length - 1];
    default:
      x = r[r.length - 2];
      y = r[r.length - 1];
    }
  }

  res.toString = pathToString;
  pth.abs = pathClone(res);

  return res;
}

function isLine(bez) {
  return (
    bez[0] === bez[2] &&
    bez[1] === bez[3] &&
    bez[4] === bez[6] &&
    bez[5] === bez[7]
  );
}

function lineToCurve(x1, y1, x2, y2) {
  return [
    x1, y1, x2,
    y2, x2, y2
  ];
}

function qubicToCurve(x1, y1, ax, ay, x2, y2) {
  var _13 = 1 / 3,
      _23 = 2 / 3;

  return [
    _13 * x1 + _23 * ax,
    _13 * y1 + _23 * ay,
    _13 * x2 + _23 * ax,
    _13 * y2 + _23 * ay,
    x2,
    y2
  ];
}

function arcToCurve(x1, y1, rx, ry, angle, large_arc_flag, sweep_flag, x2, y2, recursive) {

  // for more information of where this math came from visit:
  // http://www.w3.org/TR/SVG11/implnote.html#ArcImplementationNotes
  var _120 = PI * 120 / 180,
      rad = PI / 180 * (+angle || 0),
      res = [],
      xy,
      rotate = cacher(function(x, y, rad) {
        var X = x * math.cos(rad) - y * math.sin(rad),
            Y = x * math.sin(rad) + y * math.cos(rad);

        return { x: X, y: Y };
      });

  if (!recursive) {
    xy = rotate(x1, y1, -rad);
    x1 = xy.x;
    y1 = xy.y;
    xy = rotate(x2, y2, -rad);
    x2 = xy.x;
    y2 = xy.y;

    var x = (x1 - x2) / 2,
        y = (y1 - y2) / 2;

    var h = (x * x) / (rx * rx) + (y * y) / (ry * ry);

    if (h > 1) {
      h = math.sqrt(h);
      rx = h * rx;
      ry = h * ry;
    }

    var rx2 = rx * rx,
        ry2 = ry * ry,
        k = (large_arc_flag == sweep_flag ? -1 : 1) *
            math.sqrt(abs((rx2 * ry2 - rx2 * y * y - ry2 * x * x) / (rx2 * y * y + ry2 * x * x))),
        cx = k * rx * y / ry + (x1 + x2) / 2,
        cy = k * -ry * x / rx + (y1 + y2) / 2,
        f1 = math.asin(((y1 - cy) / ry).toFixed(9)),
        f2 = math.asin(((y2 - cy) / ry).toFixed(9));

    f1 = x1 < cx ? PI - f1 : f1;
    f2 = x2 < cx ? PI - f2 : f2;
    f1 < 0 && (f1 = PI * 2 + f1);
    f2 < 0 && (f2 = PI * 2 + f2);

    if (sweep_flag && f1 > f2) {
      f1 = f1 - PI * 2;
    }
    if (!sweep_flag && f2 > f1) {
      f2 = f2 - PI * 2;
    }
  } else {
    f1 = recursive[0];
    f2 = recursive[1];
    cx = recursive[2];
    cy = recursive[3];
  }

  var df = f2 - f1;

  if (abs(df) > _120) {
    var f2old = f2,
        x2old = x2,
        y2old = y2;

    f2 = f1 + _120 * (sweep_flag && f2 > f1 ? 1 : -1);
    x2 = cx + rx * math.cos(f2);
    y2 = cy + ry * math.sin(f2);
    res = arcToCurve(x2, y2, rx, ry, angle, 0, sweep_flag, x2old, y2old, [f2, f2old, cx, cy]);
  }

  df = f2 - f1;

  var c1 = math.cos(f1),
      s1 = math.sin(f1),
      c2 = math.cos(f2),
      s2 = math.sin(f2),
      t = math.tan(df / 4),
      hx = 4 / 3 * rx * t,
      hy = 4 / 3 * ry * t,
      m1 = [x1, y1],
      m2 = [x1 + hx * s1, y1 - hy * c1],
      m3 = [x2 + hx * s2, y2 - hy * c2],
      m4 = [x2, y2];

  m2[0] = 2 * m1[0] - m2[0];
  m2[1] = 2 * m1[1] - m2[1];

  if (recursive) {
    return [m2, m3, m4].concat(res);
  } else {
    res = [m2, m3, m4].concat(res).join().split(',');
    var newres = [];

    for (var i = 0, ii = res.length; i < ii; i++) {
      newres[i] = i % 2 ? rotate(res[i - 1], res[i], rad).y : rotate(res[i], res[i + 1], rad).x;
    }

    return newres;
  }
}

// Returns bounding box of cubic bezier curve.
// Source: http://blog.hackers-cafe.net/2009/06/how-to-calculate-bezier-curves-bounding.html
// Original version: NISHIO Hirokazu
// Modifications: https://github.com/timo22345
function curveBBox(x0, y0, x1, y1, x2, y2, x3, y3) {
  var tvalues = [],
      bounds = [[], []],
      a, b, c, t, t1, t2, b2ac, sqrtb2ac;

  for (var i = 0; i < 2; ++i) {

    if (i == 0) {
      b = 6 * x0 - 12 * x1 + 6 * x2;
      a = -3 * x0 + 9 * x1 - 9 * x2 + 3 * x3;
      c = 3 * x1 - 3 * x0;
    } else {
      b = 6 * y0 - 12 * y1 + 6 * y2;
      a = -3 * y0 + 9 * y1 - 9 * y2 + 3 * y3;
      c = 3 * y1 - 3 * y0;
    }

    if (abs(a) < 1e-12) {

      if (abs(b) < 1e-12) {
        continue;
      }

      t = -c / b;

      if (0 < t && t < 1) {
        tvalues.push(t);
      }

      continue;
    }

    b2ac = b * b - 4 * c * a;
    sqrtb2ac = math.sqrt(b2ac);

    if (b2ac < 0) {
      continue;
    }

    t1 = (-b + sqrtb2ac) / (2 * a);

    if (0 < t1 && t1 < 1) {
      tvalues.push(t1);
    }

    t2 = (-b - sqrtb2ac) / (2 * a);

    if (0 < t2 && t2 < 1) {
      tvalues.push(t2);
    }
  }

  var j = tvalues.length,
      jlen = j,
      mt;

  while (j--) {
    t = tvalues[j];
    mt = 1 - t;
    bounds[0][j] = (mt * mt * mt * x0) + (3 * mt * mt * t * x1) + (3 * mt * t * t * x2) + (t * t * t * x3);
    bounds[1][j] = (mt * mt * mt * y0) + (3 * mt * mt * t * y1) + (3 * mt * t * t * y2) + (t * t * t * y3);
  }

  bounds[0][jlen] = x0;
  bounds[1][jlen] = y0;
  bounds[0][jlen + 1] = x3;
  bounds[1][jlen + 1] = y3;
  bounds[0].length = bounds[1].length = jlen + 2;

  return {
    x0: mmin.apply(0, bounds[0]),
    y0: mmin.apply(0, bounds[1]),
    x1: mmax.apply(0, bounds[0]),
    y1: mmax.apply(0, bounds[1])
  };
}

function pathToCurve(path) {

  var pth = paths(path);

  // return cached curve, if existing
  if (pth.curve) {
    return pathClone(pth.curve);
  }

  var curvedPath = pathToAbsolute(path),
      attrs = { x: 0, y: 0, bx: 0, by: 0, X: 0, Y: 0, qx: null, qy: null },
      processPath = function(path, d, pathCommand) {
        var nx, ny;

        if (!path) {
          return ['C', d.x, d.y, d.x, d.y, d.x, d.y];
        }

        !(path[0] in { T: 1, Q: 1 }) && (d.qx = d.qy = null);

        switch (path[0]) {
        case 'M':
          d.X = path[1];
          d.Y = path[2];
          break;
        case 'A':
          path = ['C'].concat(arcToCurve.apply(0, [d.x, d.y].concat(path.slice(1))));
          break;
        case 'S':
          if (pathCommand == 'C' || pathCommand == 'S') {

            // In 'S' case we have to take into account, if the previous command is C/S.
            nx = d.x * 2 - d.bx;

            // And reflect the previous
            ny = d.y * 2 - d.by;

            // command's control point relative to the current point.
          }
          else {

            // or some else or nothing
            nx = d.x;
            ny = d.y;
          }
          path = ['C', nx, ny].concat(path.slice(1));
          break;
        case 'T':
          if (pathCommand == 'Q' || pathCommand == 'T') {

            // In 'T' case we have to take into account, if the previous command is Q/T.
            d.qx = d.x * 2 - d.qx;

            // And make a reflection similar
            d.qy = d.y * 2 - d.qy;

            // to case 'S'.
          }
          else {

            // or something else or nothing
            d.qx = d.x;
            d.qy = d.y;
          }
          path = ['C'].concat(qubicToCurve(d.x, d.y, d.qx, d.qy, path[1], path[2]));
          break;
        case 'Q':
          d.qx = path[1];
          d.qy = path[2];
          path = ['C'].concat(qubicToCurve(d.x, d.y, path[1], path[2], path[3], path[4]));
          break;
        case 'L':
          path = ['C'].concat(lineToCurve(d.x, d.y, path[1], path[2]));
          break;
        case 'H':
          path = ['C'].concat(lineToCurve(d.x, d.y, path[1], d.y));
          break;
        case 'V':
          path = ['C'].concat(lineToCurve(d.x, d.y, d.x, path[1]));
          break;
        case 'Z':
          path = ['C'].concat(lineToCurve(d.x, d.y, d.X, d.Y));
          break;
        }

        return path;
      },

      fixArc = function(pp, i) {

        if (pp[i].length > 7) {
          pp[i].shift();
          var pi = pp[i];

          while (pi.length) {
            pathCommands[i] = 'A'; // if created multiple C:s, their original seg is saved
            pp.splice(i++, 0, ['C'].concat(pi.splice(0, 6)));
          }

          pp.splice(i, 1);
          ii = curvedPath.length;
        }
      },

      pathCommands = [], // path commands of original path p
      pfirst = '', // temporary holder for original path command
      pathCommand = ''; // holder for previous path command of original path

  for (var i = 0, ii = curvedPath.length; i < ii; i++) {
    curvedPath[i] && (pfirst = curvedPath[i][0]); // save current path command

    if (pfirst != 'C') // C is not saved yet, because it may be result of conversion
    {
      pathCommands[i] = pfirst; // Save current path command
      i && (pathCommand = pathCommands[i - 1]); // Get previous path command pathCommand
    }
    curvedPath[i] = processPath(curvedPath[i], attrs, pathCommand); // Previous path command is inputted to processPath

    if (pathCommands[i] != 'A' && pfirst == 'C') pathCommands[i] = 'C'; // A is the only command
    // which may produce multiple C:s
    // so we have to make sure that C is also C in original path

    fixArc(curvedPath, i); // fixArc adds also the right amount of A:s to pathCommands

    var seg = curvedPath[i],
        seglen = seg.length;

    attrs.x = seg[seglen - 2];
    attrs.y = seg[seglen - 1];
    attrs.bx = toFloat(seg[seglen - 4]) || attrs.x;
    attrs.by = toFloat(seg[seglen - 3]) || attrs.y;
  }

  // cache curve
  pth.curve = pathClone(curvedPath);

  return curvedPath;
}

module.exports = findPathIntersections;


/***/ }),

/***/ "./node_modules/saxen/dist/index.esm.js":
/*!**********************************************!*\
  !*** ./node_modules/saxen/dist/index.esm.js ***!
  \**********************************************/
/*! exports provided: Parser, decode */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Parser", function() { return Parser; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "decode", function() { return decodeEntities; });
var fromCharCode = String.fromCharCode;

var hasOwnProperty = Object.prototype.hasOwnProperty;

var ENTITY_PATTERN = /&#(\d+);|&#x([0-9a-f]+);|&(\w+);/ig;

var ENTITY_MAPPING = {
  'amp': '&',
  'apos': '\'',
  'gt': '>',
  'lt': '<',
  'quot': '"'
};

// map UPPERCASE variants of supported special chars
Object.keys(ENTITY_MAPPING).forEach(function(k) {
  ENTITY_MAPPING[k.toUpperCase()] = ENTITY_MAPPING[k];
});


function replaceEntities(_, d, x, z) {

  // reserved names, i.e. &nbsp;
  if (z) {
    if (hasOwnProperty.call(ENTITY_MAPPING, z)) {
      return ENTITY_MAPPING[z];
    } else {

      // fall back to original value
      return '&' + z + ';';
    }
  }

  // decimal encoded char
  if (d) {
    return fromCharCode(d);
  }

  // hex encoded char
  return fromCharCode(parseInt(x, 16));
}


/**
 * A basic entity decoder that can decode a minimal
 * sub-set of reserved names (&amp;) as well as
 * hex (&#xaaf;) and decimal (&#1231;) encoded characters.
 *
 * @param {string} str
 *
 * @return {string} decoded string
 */
function decodeEntities(s) {
  if (s.length > 3 && s.indexOf('&') !== -1) {
    return s.replace(ENTITY_PATTERN, replaceEntities);
  }

  return s;
}

var XSI_URI = 'http://www.w3.org/2001/XMLSchema-instance';
var XSI_PREFIX = 'xsi';
var XSI_TYPE = 'xsi:type';

var NON_WHITESPACE_OUTSIDE_ROOT_NODE = 'non-whitespace outside of root node';

function error(msg) {
  return new Error(msg);
}

function missingNamespaceForPrefix(prefix) {
  return 'missing namespace for prefix <' + prefix + '>';
}

function getter(getFn) {
  return {
    'get': getFn,
    'enumerable': true
  };
}

function cloneNsMatrix(nsMatrix) {
  var clone = {}, key;
  for (key in nsMatrix) {
    clone[key] = nsMatrix[key];
  }
  return clone;
}

function uriPrefix(prefix) {
  return prefix + '$uri';
}

function buildNsMatrix(nsUriToPrefix) {
  var nsMatrix = {},
      uri,
      prefix;

  for (uri in nsUriToPrefix) {
    prefix = nsUriToPrefix[uri];
    nsMatrix[prefix] = prefix;
    nsMatrix[uriPrefix(prefix)] = uri;
  }

  return nsMatrix;
}

function noopGetContext() {
  return { 'line': 0, 'column': 0 };
}

function throwFunc(err) {
  throw err;
}

/**
 * Creates a new parser with the given options.
 *
 * @constructor
 *
 * @param  {!Object<string, ?>=} options
 */
function Parser(options) {

  if (!this) {
    return new Parser(options);
  }

  var proxy = options && options['proxy'];

  var onText,
      onOpenTag,
      onCloseTag,
      onCDATA,
      onError = throwFunc,
      onWarning,
      onComment,
      onQuestion,
      onAttention;

  var getContext = noopGetContext;

  /**
   * Do we need to parse the current elements attributes for namespaces?
   *
   * @type {boolean}
   */
  var maybeNS = false;

  /**
   * Do we process namespaces at all?
   *
   * @type {boolean}
   */
  var isNamespace = false;

  /**
   * The caught error returned on parse end
   *
   * @type {Error}
   */
  var returnError = null;

  /**
   * Should we stop parsing?
   *
   * @type {boolean}
   */
  var parseStop = false;

  /**
   * A map of { uri: prefix } used by the parser.
   *
   * This map will ensure we can normalize prefixes during processing;
   * for each uri, only one prefix will be exposed to the handlers.
   *
   * @type {!Object<string, string>}}
   */
  var nsUriToPrefix;

  /**
   * Handle parse error.
   *
   * @param  {string|Error} err
   */
  function handleError(err) {
    if (!(err instanceof Error)) {
      err = error(err);
    }

    returnError = err;

    onError(err, getContext);
  }

  /**
   * Handle parse error.
   *
   * @param  {string|Error} err
   */
  function handleWarning(err) {

    if (!onWarning) {
      return;
    }

    if (!(err instanceof Error)) {
      err = error(err);
    }

    onWarning(err, getContext);
  }

  /**
   * Register parse listener.
   *
   * @param  {string}   name
   * @param  {Function} cb
   *
   * @return {Parser}
   */
  this['on'] = function(name, cb) {

    if (typeof cb !== 'function') {
      throw error('required args <name, cb>');
    }

    switch (name) {
    case 'openTag': onOpenTag = cb; break;
    case 'text': onText = cb; break;
    case 'closeTag': onCloseTag = cb; break;
    case 'error': onError = cb; break;
    case 'warn': onWarning = cb; break;
    case 'cdata': onCDATA = cb; break;
    case 'attention': onAttention = cb; break; // <!XXXXX zzzz="eeee">
    case 'question': onQuestion = cb; break; // <? ....  ?>
    case 'comment': onComment = cb; break;
    default:
      throw error('unsupported event: ' + name);
    }

    return this;
  };

  /**
   * Set the namespace to prefix mapping.
   *
   * @example
   *
   * parser.ns({
   *   'http://foo': 'foo',
   *   'http://bar': 'bar'
   * });
   *
   * @param  {!Object<string, string>} nsMap
   *
   * @return {Parser}
   */
  this['ns'] = function(nsMap) {

    if (typeof nsMap === 'undefined') {
      nsMap = {};
    }

    if (typeof nsMap !== 'object') {
      throw error('required args <nsMap={}>');
    }

    var _nsUriToPrefix = {}, k;

    for (k in nsMap) {
      _nsUriToPrefix[k] = nsMap[k];
    }

    // FORCE default mapping for schema instance
    _nsUriToPrefix[XSI_URI] = XSI_PREFIX;

    isNamespace = true;
    nsUriToPrefix = _nsUriToPrefix;

    return this;
  };

  /**
   * Parse xml string.
   *
   * @param  {string} xml
   *
   * @return {Error} returnError, if not thrown
   */
  this['parse'] = function(xml) {
    if (typeof xml !== 'string') {
      throw error('required args <xml=string>');
    }

    returnError = null;

    parse(xml);

    getContext = noopGetContext;
    parseStop = false;

    return returnError;
  };

  /**
   * Stop parsing.
   */
  this['stop'] = function() {
    parseStop = true;
  };

  /**
   * Parse string, invoking configured listeners on element.
   *
   * @param  {string} xml
   */
  function parse(xml) {
    var nsMatrixStack = isNamespace ? [] : null,
        nsMatrix = isNamespace ? buildNsMatrix(nsUriToPrefix) : null,
        _nsMatrix,
        nodeStack = [],
        anonymousNsCount = 0,
        tagStart = false,
        tagEnd = false,
        i = 0, j = 0,
        x, y, q, w, v,
        xmlns,
        elementName,
        _elementName,
        elementProxy
        ;

    var attrsString = '',
        attrsStart = 0,
        cachedAttrs // false = parsed with errors, null = needs parsing
        ;

    /**
     * Parse attributes on demand and returns the parsed attributes.
     *
     * Return semantics: (1) `false` on attribute parse error,
     * (2) object hash on extracted attrs.
     *
     * @return {boolean|Object}
     */
    function getAttrs() {
      if (cachedAttrs !== null) {
        return cachedAttrs;
      }

      var nsUri,
          nsUriPrefix,
          nsName,
          defaultAlias = isNamespace && nsMatrix['xmlns'],
          attrList = isNamespace && maybeNS ? [] : null,
          i = attrsStart,
          s = attrsString,
          l = s.length,
          hasNewMatrix,
          newalias,
          value,
          alias,
          name,
          attrs = {},
          seenAttrs = {},
          skipAttr,
          w,
          j;

      parseAttr:
      for (; i < l; i++) {
        skipAttr = false;
        w = s.charCodeAt(i);

        if (w === 32 || (w < 14 && w > 8)) { // WHITESPACE={ \f\n\r\t\v}
          continue;
        }

        // wait for non whitespace character
        if (w < 65 || w > 122 || (w > 90 && w < 97)) {
          if (w !== 95 && w !== 58) { // char 95"_" 58":"
            handleWarning('illegal first char attribute name');
            skipAttr = true;
          }
        }

        // parse attribute name
        for (j = i + 1; j < l; j++) {
          w = s.charCodeAt(j);

          if (
            w > 96 && w < 123 ||
            w > 64 && w < 91 ||
            w > 47 && w < 59 ||
            w === 46 || // '.'
            w === 45 || // '-'
            w === 95 // '_'
          ) {
            continue;
          }

          // unexpected whitespace
          if (w === 32 || (w < 14 && w > 8)) { // WHITESPACE
            handleWarning('missing attribute value');
            i = j;

            continue parseAttr;
          }

          // expected "="
          if (w === 61) { // "=" == 61
            break;
          }

          handleWarning('illegal attribute name char');
          skipAttr = true;
        }

        name = s.substring(i, j);

        if (name === 'xmlns:xmlns') {
          handleWarning('illegal declaration of xmlns');
          skipAttr = true;
        }

        w = s.charCodeAt(j + 1);

        if (w === 34) { // '"'
          j = s.indexOf('"', i = j + 2);

          if (j === -1) {
            j = s.indexOf('\'', i);

            if (j !== -1) {
              handleWarning('attribute value quote missmatch');
              skipAttr = true;
            }
          }

        } else if (w === 39) { // "'"
          j = s.indexOf('\'', i = j + 2);

          if (j === -1) {
            j = s.indexOf('"', i);

            if (j !== -1) {
              handleWarning('attribute value quote missmatch');
              skipAttr = true;
            }
          }

        } else {
          handleWarning('missing attribute value quotes');
          skipAttr = true;

          // skip to next space
          for (j = j + 1; j < l; j++) {
            w = s.charCodeAt(j + 1);

            if (w === 32 || (w < 14 && w > 8)) { // WHITESPACE
              break;
            }
          }

        }

        if (j === -1) {
          handleWarning('missing closing quotes');

          j = l;
          skipAttr = true;
        }

        if (!skipAttr) {
          value = s.substring(i, j);
        }

        i = j;

        // ensure SPACE follows attribute
        // skip illegal content otherwise
        // example a="b"c
        for (; j + 1 < l; j++) {
          w = s.charCodeAt(j + 1);

          if (w === 32 || (w < 14 && w > 8)) { // WHITESPACE
            break;
          }

          // FIRST ILLEGAL CHAR
          if (i === j) {
            handleWarning('illegal character after attribute end');
            skipAttr = true;
          }
        }

        // advance cursor to next attribute
        i = j + 1;

        if (skipAttr) {
          continue parseAttr;
        }

        // check attribute re-declaration
        if (name in seenAttrs) {
          handleWarning('attribute <' + name + '> already defined');
          continue;
        }

        seenAttrs[name] = true;

        if (!isNamespace) {
          attrs[name] = value;
          continue;
        }

        // try to extract namespace information
        if (maybeNS) {
          newalias = (
            name === 'xmlns'
              ? 'xmlns'
              : (name.charCodeAt(0) === 120 && name.substr(0, 6) === 'xmlns:')
                ? name.substr(6)
                : null
          );

          // handle xmlns(:alias) assignment
          if (newalias !== null) {
            nsUri = decodeEntities(value);
            nsUriPrefix = uriPrefix(newalias);

            alias = nsUriToPrefix[nsUri];

            if (!alias) {

              // no prefix defined or prefix collision
              if (
                (newalias === 'xmlns') ||
                (nsUriPrefix in nsMatrix && nsMatrix[nsUriPrefix] !== nsUri)
              ) {

                // alocate free ns prefix
                do {
                  alias = 'ns' + (anonymousNsCount++);
                } while (typeof nsMatrix[alias] !== 'undefined');
              } else {
                alias = newalias;
              }

              nsUriToPrefix[nsUri] = alias;
            }

            if (nsMatrix[newalias] !== alias) {
              if (!hasNewMatrix) {
                nsMatrix = cloneNsMatrix(nsMatrix);
                hasNewMatrix = true;
              }

              nsMatrix[newalias] = alias;
              if (newalias === 'xmlns') {
                nsMatrix[uriPrefix(alias)] = nsUri;
                defaultAlias = alias;
              }

              nsMatrix[nsUriPrefix] = nsUri;
            }

            // expose xmlns(:asd)="..." in attributes
            attrs[name] = value;
            continue;
          }

          // collect attributes until all namespace
          // declarations are processed
          attrList.push(name, value);
          continue;

        } /** end if (maybeNs) */

        // handle attributes on element without
        // namespace declarations
        w = name.indexOf(':');
        if (w === -1) {
          attrs[name] = value;
          continue;
        }

        // normalize ns attribute name
        if (!(nsName = nsMatrix[name.substring(0, w)])) {
          handleWarning(missingNamespaceForPrefix(name.substring(0, w)));
          continue;
        }

        name = defaultAlias === nsName
          ? name.substr(w + 1)
          : nsName + name.substr(w);

        // end: normalize ns attribute name

        // normalize xsi:type ns attribute value
        if (name === XSI_TYPE) {
          w = value.indexOf(':');

          if (w !== -1) {
            nsName = value.substring(0, w);

            // handle default prefixes, i.e. xs:String gracefully
            nsName = nsMatrix[nsName] || nsName;
            value = nsName + value.substring(w);
          } else {
            value = defaultAlias + ':' + value;
          }
        }

        // end: normalize xsi:type ns attribute value

        attrs[name] = value;
      }


      // handle deferred, possibly namespaced attributes
      if (maybeNS) {

        // normalize captured attributes
        for (i = 0, l = attrList.length; i < l; i++) {

          name = attrList[i++];
          value = attrList[i];

          w = name.indexOf(':');

          if (w !== -1) {

            // normalize ns attribute name
            if (!(nsName = nsMatrix[name.substring(0, w)])) {
              handleWarning(missingNamespaceForPrefix(name.substring(0, w)));
              continue;
            }

            name = defaultAlias === nsName
              ? name.substr(w + 1)
              : nsName + name.substr(w);

            // end: normalize ns attribute name

            // normalize xsi:type ns attribute value
            if (name === XSI_TYPE) {
              w = value.indexOf(':');

              if (w !== -1) {
                nsName = value.substring(0, w);

                // handle default prefixes, i.e. xs:String gracefully
                nsName = nsMatrix[nsName] || nsName;
                value = nsName + value.substring(w);
              } else {
                value = defaultAlias + ':' + value;
              }
            }

            // end: normalize xsi:type ns attribute value
          }

          attrs[name] = value;
        }

        // end: normalize captured attributes
      }

      return cachedAttrs = attrs;
    }

    /**
     * Extract the parse context { line, column, part }
     * from the current parser position.
     *
     * @return {Object} parse context
     */
    function getParseContext() {
      var splitsRe = /(\r\n|\r|\n)/g;

      var line = 0;
      var column = 0;
      var startOfLine = 0;
      var endOfLine = j;
      var match;
      var data;

      while (i >= startOfLine) {

        match = splitsRe.exec(xml);

        if (!match) {
          break;
        }

        // end of line = (break idx + break chars)
        endOfLine = match[0].length + match.index;

        if (endOfLine > i) {
          break;
        }

        // advance to next line
        line += 1;

        startOfLine = endOfLine;
      }

      // EOF errors
      if (i == -1) {
        column = endOfLine;
        data = xml.substring(j);
      } else

      // start errors
      if (j === 0) {
        data = xml.substring(j, i);
      }

      // other errors
      else {
        column = i - startOfLine;
        data = (j == -1 ? xml.substring(i) : xml.substring(i, j + 1));
      }

      return {
        'data': data,
        'line': line,
        'column': column
      };
    }

    getContext = getParseContext;


    if (proxy) {
      elementProxy = Object.create({}, {
        'name': getter(function() {
          return elementName;
        }),
        'originalName': getter(function() {
          return _elementName;
        }),
        'attrs': getter(getAttrs),
        'ns': getter(function() {
          return nsMatrix;
        })
      });
    }

    // actual parse logic
    while (j !== -1) {

      if (xml.charCodeAt(j) === 60) { // "<"
        i = j;
      } else {
        i = xml.indexOf('<', j);
      }

      // parse end
      if (i === -1) {
        if (nodeStack.length) {
          return handleError('unexpected end of file');
        }

        if (j === 0) {
          return handleError('missing start tag');
        }

        if (j < xml.length) {
          if (xml.substring(j).trim()) {
            handleWarning(NON_WHITESPACE_OUTSIDE_ROOT_NODE);
          }
        }

        return;
      }

      // parse text
      if (j !== i) {

        if (nodeStack.length) {
          if (onText) {
            onText(xml.substring(j, i), decodeEntities, getContext);

            if (parseStop) {
              return;
            }
          }
        } else {
          if (xml.substring(j, i).trim()) {
            handleWarning(NON_WHITESPACE_OUTSIDE_ROOT_NODE);

            if (parseStop) {
              return;
            }
          }
        }
      }

      w = xml.charCodeAt(i+1);

      // parse comments + CDATA
      if (w === 33) { // "!"
        q = xml.charCodeAt(i+2);

        // CDATA section
        if (q === 91 && xml.substr(i + 3, 6) === 'CDATA[') { // 91 == "["
          j = xml.indexOf(']]>', i);
          if (j === -1) {
            return handleError('unclosed cdata');
          }

          if (onCDATA) {
            onCDATA(xml.substring(i + 9, j), getContext);
            if (parseStop) {
              return;
            }
          }

          j += 3;
          continue;
        }

        // comment
        if (q === 45 && xml.charCodeAt(i + 3) === 45) { // 45 == "-"
          j = xml.indexOf('-->', i);
          if (j === -1) {
            return handleError('unclosed comment');
          }


          if (onComment) {
            onComment(xml.substring(i + 4, j), decodeEntities, getContext);
            if (parseStop) {
              return;
            }
          }

          j += 3;
          continue;
        }
      }

      // parse question <? ... ?>
      if (w === 63) { // "?"
        j = xml.indexOf('?>', i);
        if (j === -1) {
          return handleError('unclosed question');
        }

        if (onQuestion) {
          onQuestion(xml.substring(i, j + 2), getContext);
          if (parseStop) {
            return;
          }
        }

        j += 2;
        continue;
      }

      // find matching closing tag for attention or standard tags
      // for that we must skip through attribute values
      // (enclosed in single or double quotes)
      for (x = i + 1; ; x++) {
        v = xml.charCodeAt(x);
        if (isNaN(v)) {
          j = -1;
          return handleError('unclosed tag');
        }

        // [10] AttValue ::= '"' ([^<&"] | Reference)* '"' | "'" ([^<&'] | Reference)* "'"
        // skips the quoted string
        // (double quotes) does not appear in a literal enclosed by (double quotes)
        // (single quote) does not appear in a literal enclosed by (single quote)
        if (v === 34) { //  '"'
          q = xml.indexOf('"', x + 1);
          x = q !== -1 ? q : x;
        } else if (v === 39) { // "'"
          q = xml.indexOf("'", x + 1);
          x = q !== -1 ? q : x;
        } else if (v === 62) { // '>'
          j = x;
          break;
        }
      }


      // parse attention <! ...>
      // previously comment and CDATA have already been parsed
      if (w === 33) { // "!"

        if (onAttention) {
          onAttention(xml.substring(i, j + 1), decodeEntities, getContext);
          if (parseStop) {
            return;
          }
        }

        j += 1;
        continue;
      }

      // don't process attributes;
      // there are none
      cachedAttrs = {};

      // if (xml.charCodeAt(i+1) === 47) { // </...
      if (w === 47) { // </...
        tagStart = false;
        tagEnd = true;

        if (!nodeStack.length) {
          return handleError('missing open tag');
        }

        // verify open <-> close tag match
        x = elementName = nodeStack.pop();
        q = i + 2 + x.length;

        if (xml.substring(i + 2, q) !== x) {
          return handleError('closing tag mismatch');
        }

        // verify chars in close tag
        for (; q < j; q++) {
          w = xml.charCodeAt(q);

          if (w === 32 || (w > 8 && w < 14)) { // \f\n\r\t\v space
            continue;
          }

          return handleError('close tag');
        }

      } else {
        if (xml.charCodeAt(j - 1) === 47) { // .../>
          x = elementName = xml.substring(i + 1, j - 1);

          tagStart = true;
          tagEnd = true;

        } else {
          x = elementName = xml.substring(i + 1, j);

          tagStart = true;
          tagEnd = false;
        }

        if (!(w > 96 && w < 123 || w > 64 && w < 91 || w === 95 || w === 58)) { // char 95"_" 58":"
          return handleError('illegal first char nodeName');
        }

        for (q = 1, y = x.length; q < y; q++) {
          w = x.charCodeAt(q);

          if (w > 96 && w < 123 || w > 64 && w < 91 || w > 47 && w < 59 || w === 45 || w === 95 || w == 46) {
            continue;
          }

          if (w === 32 || (w < 14 && w > 8)) { // \f\n\r\t\v space
            elementName = x.substring(0, q);

            // maybe there are attributes
            cachedAttrs = null;
            break;
          }

          return handleError('invalid nodeName');
        }

        if (!tagEnd) {
          nodeStack.push(elementName);
        }
      }

      if (isNamespace) {

        _nsMatrix = nsMatrix;

        if (tagStart) {

          // remember old namespace
          // unless we're self-closing
          if (!tagEnd) {
            nsMatrixStack.push(_nsMatrix);
          }

          if (cachedAttrs === null) {

            // quick check, whether there may be namespace
            // declarations on the node; if that is the case
            // we need to eagerly parse the node attributes
            if ((maybeNS = x.indexOf('xmlns', q) !== -1)) {
              attrsStart = q;
              attrsString = x;

              getAttrs();

              maybeNS = false;
            }
          }
        }

        _elementName = elementName;

        w = elementName.indexOf(':');
        if (w !== -1) {
          xmlns = nsMatrix[elementName.substring(0, w)];

          // prefix given; namespace must exist
          if (!xmlns) {
            return handleError('missing namespace on <' + _elementName + '>');
          }

          elementName = elementName.substr(w + 1);
        } else {
          xmlns = nsMatrix['xmlns'];

          // if no default namespace is defined,
          // we'll import the element as anonymous.
          //
          // it is up to users to correct that to the document defined
          // targetNamespace, or whatever their undersanding of the
          // XML spec mandates.
        }

        // adjust namespace prefixs as configured
        if (xmlns) {
          elementName = xmlns + ':' + elementName;
        }

      }

      if (tagStart) {
        attrsStart = q;
        attrsString = x;

        if (onOpenTag) {
          if (proxy) {
            onOpenTag(elementProxy, decodeEntities, tagEnd, getContext);
          } else {
            onOpenTag(elementName, getAttrs, decodeEntities, tagEnd, getContext);
          }

          if (parseStop) {
            return;
          }
        }

      }

      if (tagEnd) {

        if (onCloseTag) {
          onCloseTag(proxy ? elementProxy : elementName, decodeEntities, tagStart, getContext);

          if (parseStop) {
            return;
          }
        }

        // restore old namespace
        if (isNamespace) {
          if (!tagStart) {
            nsMatrix = nsMatrixStack.pop();
          } else {
            nsMatrix = _nsMatrix;
          }
        }
      }

      j += 1;
    }
  } /** end parse */

}




/***/ }),

/***/ "./node_modules/tiny-svg/dist/index.esm.js":
/*!*************************************************!*\
  !*** ./node_modules/tiny-svg/dist/index.esm.js ***!
  \*************************************************/
/*! exports provided: append, appendTo, attr, classes, clear, clone, create, innerSVG, prepend, prependTo, remove, replace, transform, on, off, createPoint, createMatrix, createTransform, select, selectAll */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "append", function() { return append; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "appendTo", function() { return appendTo; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "attr", function() { return attr; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "classes", function() { return classes; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "clear", function() { return clear; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "clone", function() { return clone; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "create", function() { return create; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "innerSVG", function() { return innerSVG; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "prepend", function() { return prepend; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "prependTo", function() { return prependTo; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "remove", function() { return remove; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "replace", function() { return replace; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "transform", function() { return transform; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "on", function() { return on; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "off", function() { return off; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "createPoint", function() { return createPoint; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "createMatrix", function() { return createMatrix; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "createTransform", function() { return createTransform; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "select", function() { return select; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "selectAll", function() { return selectAll; });
function ensureImported(element, target) {

  if (element.ownerDocument !== target.ownerDocument) {
    try {
      // may fail on webkit
      return target.ownerDocument.importNode(element, true);
    } catch (e) {
      // ignore
    }
  }

  return element;
}

/**
 * appendTo utility
 */

/**
 * Append a node to a target element and return the appended node.
 *
 * @param  {SVGElement} element
 * @param  {SVGElement} target
 *
 * @return {SVGElement} the appended node
 */
function appendTo(element, target) {
  return target.appendChild(ensureImported(element, target));
}

/**
 * append utility
 */

/**
 * Append a node to an element
 *
 * @param  {SVGElement} element
 * @param  {SVGElement} node
 *
 * @return {SVGElement} the element
 */
function append(target, node) {
  appendTo(node, target);
  return target;
}

/**
 * attribute accessor utility
 */

var LENGTH_ATTR = 2;

var CSS_PROPERTIES = {
  'alignment-baseline': 1,
  'baseline-shift': 1,
  'clip': 1,
  'clip-path': 1,
  'clip-rule': 1,
  'color': 1,
  'color-interpolation': 1,
  'color-interpolation-filters': 1,
  'color-profile': 1,
  'color-rendering': 1,
  'cursor': 1,
  'direction': 1,
  'display': 1,
  'dominant-baseline': 1,
  'enable-background': 1,
  'fill': 1,
  'fill-opacity': 1,
  'fill-rule': 1,
  'filter': 1,
  'flood-color': 1,
  'flood-opacity': 1,
  'font': 1,
  'font-family': 1,
  'font-size': LENGTH_ATTR,
  'font-size-adjust': 1,
  'font-stretch': 1,
  'font-style': 1,
  'font-variant': 1,
  'font-weight': 1,
  'glyph-orientation-horizontal': 1,
  'glyph-orientation-vertical': 1,
  'image-rendering': 1,
  'kerning': 1,
  'letter-spacing': 1,
  'lighting-color': 1,
  'marker': 1,
  'marker-end': 1,
  'marker-mid': 1,
  'marker-start': 1,
  'mask': 1,
  'opacity': 1,
  'overflow': 1,
  'pointer-events': 1,
  'shape-rendering': 1,
  'stop-color': 1,
  'stop-opacity': 1,
  'stroke': 1,
  'stroke-dasharray': 1,
  'stroke-dashoffset': 1,
  'stroke-linecap': 1,
  'stroke-linejoin': 1,
  'stroke-miterlimit': 1,
  'stroke-opacity': 1,
  'stroke-width': LENGTH_ATTR,
  'text-anchor': 1,
  'text-decoration': 1,
  'text-rendering': 1,
  'unicode-bidi': 1,
  'visibility': 1,
  'word-spacing': 1,
  'writing-mode': 1
};


function getAttribute(node, name) {
  if (CSS_PROPERTIES[name]) {
    return node.style[name];
  } else {
    return node.getAttributeNS(null, name);
  }
}

function setAttribute(node, name, value) {
  var hyphenated = name.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();

  var type = CSS_PROPERTIES[hyphenated];

  if (type) {
    // append pixel unit, unless present
    if (type === LENGTH_ATTR && typeof value === 'number') {
      value = String(value) + 'px';
    }

    node.style[hyphenated] = value;
  } else {
    node.setAttributeNS(null, name, value);
  }
}

function setAttributes(node, attrs) {

  var names = Object.keys(attrs), i, name;

  for (i = 0, name; (name = names[i]); i++) {
    setAttribute(node, name, attrs[name]);
  }
}

/**
 * Gets or sets raw attributes on a node.
 *
 * @param  {SVGElement} node
 * @param  {Object} [attrs]
 * @param  {String} [name]
 * @param  {String} [value]
 *
 * @return {String}
 */
function attr(node, name, value) {
  if (typeof name === 'string') {
    if (value !== undefined) {
      setAttribute(node, name, value);
    } else {
      return getAttribute(node, name);
    }
  } else {
    setAttributes(node, name);
  }

  return node;
}

/**
 * Clear utility
 */
function index(arr, obj) {
  if (arr.indexOf) {
    return arr.indexOf(obj);
  }


  for (var i = 0; i < arr.length; ++i) {
    if (arr[i] === obj) {
      return i;
    }
  }

  return -1;
}

var re = /\s+/;

var toString = Object.prototype.toString;

function defined(o) {
  return typeof o !== 'undefined';
}

/**
 * Wrap `el` in a `ClassList`.
 *
 * @param {Element} el
 * @return {ClassList}
 * @api public
 */

function classes(el) {
  return new ClassList(el);
}

function ClassList(el) {
  if (!el || !el.nodeType) {
    throw new Error('A DOM element reference is required');
  }
  this.el = el;
  this.list = el.classList;
}

/**
 * Add class `name` if not already present.
 *
 * @param {String} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.add = function(name) {

  // classList
  if (this.list) {
    this.list.add(name);
    return this;
  }

  // fallback
  var arr = this.array();
  var i = index(arr, name);
  if (!~i) {
    arr.push(name);
  }

  if (defined(this.el.className.baseVal)) {
    this.el.className.baseVal = arr.join(' ');
  } else {
    this.el.className = arr.join(' ');
  }

  return this;
};

/**
 * Remove class `name` when present, or
 * pass a regular expression to remove
 * any which match.
 *
 * @param {String|RegExp} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.remove = function(name) {
  if ('[object RegExp]' === toString.call(name)) {
    return this.removeMatching(name);
  }

  // classList
  if (this.list) {
    this.list.remove(name);
    return this;
  }

  // fallback
  var arr = this.array();
  var i = index(arr, name);
  if (~i) {
    arr.splice(i, 1);
  }
  this.el.className.baseVal = arr.join(' ');
  return this;
};

/**
 * Remove all classes matching `re`.
 *
 * @param {RegExp} re
 * @return {ClassList}
 * @api private
 */

ClassList.prototype.removeMatching = function(re) {
  var arr = this.array();
  for (var i = 0; i < arr.length; i++) {
    if (re.test(arr[i])) {
      this.remove(arr[i]);
    }
  }
  return this;
};

/**
 * Toggle class `name`, can force state via `force`.
 *
 * For browsers that support classList, but do not support `force` yet,
 * the mistake will be detected and corrected.
 *
 * @param {String} name
 * @param {Boolean} force
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.toggle = function(name, force) {
  // classList
  if (this.list) {
    if (defined(force)) {
      if (force !== this.list.toggle(name, force)) {
        this.list.toggle(name); // toggle again to correct
      }
    } else {
      this.list.toggle(name);
    }
    return this;
  }

  // fallback
  if (defined(force)) {
    if (!force) {
      this.remove(name);
    } else {
      this.add(name);
    }
  } else {
    if (this.has(name)) {
      this.remove(name);
    } else {
      this.add(name);
    }
  }

  return this;
};

/**
 * Return an array of classes.
 *
 * @return {Array}
 * @api public
 */

ClassList.prototype.array = function() {
  var className = this.el.getAttribute('class') || '';
  var str = className.replace(/^\s+|\s+$/g, '');
  var arr = str.split(re);
  if ('' === arr[0]) {
    arr.shift();
  }
  return arr;
};

/**
 * Check if class `name` is present.
 *
 * @param {String} name
 * @return {ClassList}
 * @api public
 */

ClassList.prototype.has =
ClassList.prototype.contains = function(name) {
  return (
    this.list ?
      this.list.contains(name) :
      !! ~index(this.array(), name)
  );
};

function remove(element) {
  var parent = element.parentNode;

  if (parent) {
    parent.removeChild(element);
  }

  return element;
}

/**
 * Clear utility
 */

/**
 * Removes all children from the given element
 *
 * @param  {DOMElement} element
 * @return {DOMElement} the element (for chaining)
 */
function clear(element) {
  var child;

  while ((child = element.firstChild)) {
    remove(child);
  }

  return element;
}

function clone(element) {
  return element.cloneNode(true);
}

var ns = {
  svg: 'http://www.w3.org/2000/svg'
};

/**
 * DOM parsing utility
 */

var SVG_START = '<svg xmlns="' + ns.svg + '"';

function parse(svg) {

  var unwrap = false;

  // ensure we import a valid svg document
  if (svg.substring(0, 4) === '<svg') {
    if (svg.indexOf(ns.svg) === -1) {
      svg = SVG_START + svg.substring(4);
    }
  } else {
    // namespace svg
    svg = SVG_START + '>' + svg + '</svg>';
    unwrap = true;
  }

  var parsed = parseDocument(svg);

  if (!unwrap) {
    return parsed;
  }

  var fragment = document.createDocumentFragment();

  var parent = parsed.firstChild;

  while (parent.firstChild) {
    fragment.appendChild(parent.firstChild);
  }

  return fragment;
}

function parseDocument(svg) {

  var parser;

  // parse
  parser = new DOMParser();
  parser.async = false;

  return parser.parseFromString(svg, 'text/xml');
}

/**
 * Create utility for SVG elements
 */


/**
 * Create a specific type from name or SVG markup.
 *
 * @param {String} name the name or markup of the element
 * @param {Object} [attrs] attributes to set on the element
 *
 * @returns {SVGElement}
 */
function create(name, attrs) {
  var element;

  if (name.charAt(0) === '<') {
    element = parse(name).firstChild;
    element = document.importNode(element, true);
  } else {
    element = document.createElementNS(ns.svg, name);
  }

  if (attrs) {
    attr(element, attrs);
  }

  return element;
}

/**
 * Events handling utility
 */

function on(node, event, listener, useCapture) {
  node.addEventListener(event, listener, useCapture);
}

function off(node, event, listener, useCapture) {
  node.removeEventListener(event, listener, useCapture);
}

/**
 * Geometry helpers
 */

// fake node used to instantiate svg geometry elements
var node = create('svg');

function extend(object, props) {
  var i, k, keys = Object.keys(props);

  for (i = 0; (k = keys[i]); i++) {
    object[k] = props[k];
  }

  return object;
}


function createPoint(x, y) {
  var point = node.createSVGPoint();

  switch (arguments.length) {
  case 0:
    return point;
  case 2:
    x = {
      x: x,
      y: y
    };
    break;
  }

  return extend(point, x);
}

/**
 * Create matrix via args.
 *
 * @example
 *
 * createMatrix({ a: 1, b: 1 });
 * createMatrix();
 * createMatrix(1, 2, 0, 0, 30, 20);
 *
 * @return {SVGMatrix}
 */
function createMatrix(a, b, c, d, e, f) {
  var matrix = node.createSVGMatrix();

  switch (arguments.length) {
  case 0:
    return matrix;
  case 1:
    return extend(matrix, a);
  case 6:
    return extend(matrix, {
      a: a,
      b: b,
      c: c,
      d: d,
      e: e,
      f: f
    });
  }
}

function createTransform(matrix) {
  if (matrix) {
    return node.createSVGTransformFromMatrix(matrix);
  } else {
    return node.createSVGTransform();
  }
}

/**
 * Serialization util
 */

var TEXT_ENTITIES = /([&<>]{1})/g;
var ATTR_ENTITIES = /([\n\r"]{1})/g;

var ENTITY_REPLACEMENT = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '\''
};

function escape(str, pattern) {

  function replaceFn(match, entity) {
    return ENTITY_REPLACEMENT[entity] || entity;
  }

  return str.replace(pattern, replaceFn);
}

function serialize(node, output) {

  var i, len, attrMap, attrNode, childNodes;

  switch (node.nodeType) {
  // TEXT
  case 3:
    // replace special XML characters
    output.push(escape(node.textContent, TEXT_ENTITIES));
    break;

  // ELEMENT
  case 1:
    output.push('<', node.tagName);

    if (node.hasAttributes()) {
      attrMap = node.attributes;
      for (i = 0, len = attrMap.length; i < len; ++i) {
        attrNode = attrMap.item(i);
        output.push(' ', attrNode.name, '="', escape(attrNode.value, ATTR_ENTITIES), '"');
      }
    }

    if (node.hasChildNodes()) {
      output.push('>');
      childNodes = node.childNodes;
      for (i = 0, len = childNodes.length; i < len; ++i) {
        serialize(childNodes.item(i), output);
      }
      output.push('</', node.tagName, '>');
    } else {
      output.push('/>');
    }
    break;

  // COMMENT
  case 8:
    output.push('<!--', escape(node.nodeValue, TEXT_ENTITIES), '-->');
    break;

  // CDATA
  case 4:
    output.push('<![CDATA[', node.nodeValue, ']]>');
    break;

  default:
    throw new Error('unable to handle node ' + node.nodeType);
  }

  return output;
}

/**
 * innerHTML like functionality for SVG elements.
 * based on innerSVG (https://code.google.com/p/innersvg)
 */


function set(element, svg) {

  var parsed = parse(svg);

  // clear element contents
  clear(element);

  if (!svg) {
    return;
  }

  if (!isFragment(parsed)) {
    // extract <svg> from parsed document
    parsed = parsed.documentElement;
  }

  var nodes = slice(parsed.childNodes);

  // import + append each node
  for (var i = 0; i < nodes.length; i++) {
    appendTo(nodes[i], element);
  }

}

function get(element) {
  var child = element.firstChild,
      output = [];

  while (child) {
    serialize(child, output);
    child = child.nextSibling;
  }

  return output.join('');
}

function isFragment(node) {
  return node.nodeName === '#document-fragment';
}

function innerSVG(element, svg) {

  if (svg !== undefined) {

    try {
      set(element, svg);
    } catch (e) {
      throw new Error('error parsing SVG: ' + e.message);
    }

    return element;
  } else {
    return get(element);
  }
}


function slice(arr) {
  return Array.prototype.slice.call(arr);
}

/**
 * Selection utilities
 */

function select(node, selector) {
  return node.querySelector(selector);
}

function selectAll(node, selector) {
  var nodes = node.querySelectorAll(selector);

  return [].map.call(nodes, function(element) {
    return element;
  });
}

/**
 * prependTo utility
 */

/**
 * Prepend a node to a target element and return the prepended node.
 *
 * @param  {SVGElement} node
 * @param  {SVGElement} target
 *
 * @return {SVGElement} the prepended node
 */
function prependTo(node, target) {
  return target.insertBefore(ensureImported(node, target), target.firstChild || null);
}

/**
 * prepend utility
 */

/**
 * Prepend a node to a target element
 *
 * @param  {SVGElement} target
 * @param  {SVGElement} node
 *
 * @return {SVGElement} the target element
 */
function prepend(target, node) {
  prependTo(node, target);
  return target;
}

/**
 * Replace utility
 */

function replace(element, replacement) {
  element.parentNode.replaceChild(ensureImported(replacement, element), element);
  return replacement;
}

/**
 * transform accessor utility
 */

function wrapMatrix(transformList, transform) {
  if (transform instanceof SVGMatrix) {
    return transformList.createSVGTransformFromMatrix(transform);
  }

  return transform;
}


function setTransforms(transformList, transforms) {
  var i, t;

  transformList.clear();

  for (i = 0; (t = transforms[i]); i++) {
    transformList.appendItem(wrapMatrix(transformList, t));
  }
}

/**
 * Get or set the transforms on the given node.
 *
 * @param {SVGElement} node
 * @param  {SVGTransform|SVGMatrix|Array<SVGTransform|SVGMatrix>} [transforms]
 *
 * @return {SVGTransform} the consolidated transform
 */
function transform(node, transforms) {
  var transformList = node.transform.baseVal;

  if (transforms) {

    if (!Array.isArray(transforms)) {
      transforms = [ transforms ];
    }

    setTransforms(transformList, transforms);
  }

  return transformList.consolidate();
}




/***/ }),

/***/ 0:
/*!************************!*\
  !*** multi ./index.js ***!
  \************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! C:\Users\damthor\Desktop\dev\bpmn-viewer\index.js */"./index.js");


/***/ })

/******/ })["default"];
//# sourceMappingURL=flows4apex.viewer.js.map
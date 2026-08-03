"use strict"

/*
 * JSON-region 0.9.8.2
 * Supports Oracle-APEX >=21.2 <=26.1
 * 
 * APEX JSON-region plugin
 * (c) Uwe Simon 2023, 2024, 2025, 2026
 * Apache License Version 2.0
*/


// for Oracle < 21.1
apex.libVersions = apex.libVersions || {oraclejet: "11.0.0"};
// apex.env does not not exists, apex.locale only partially
apex.locale.toNumber = apex.locale.toNumber || function(pValue, pFormat) { 
  pValue = ('' + pValue).replace(apex.locale.getCurrency(), '');           // remove currency $€...
  pValue = ('' + pValue).replace(apex.locale.getISOCurrency(), '');        // remove EUR/USD/...
  pValue = ('' + pValue).replace(apex.locale.getGroupSeparator(), '');     // remove Groupseperator
  pValue = ('' + pValue).replace(apex.locale.getDecimalSeparator(), '.');  // convert DecimalSeperator to .
  return Number(pValue)
}; 

apex.date = apex.date||{
  parse: function(pDate, pFormat) {
    let l_ret =null;
    if(pDate.includes(' ')){           // contains time
      pDate = pDate.replace('T', ' '); // except datetime with " " or "T" between date and time, APEX<22.1 " " delimiter
      l_ret = $.datepicker.parseDate(pFormat.match('[^ ]+')[0], pDate);
      l_ret = new Date(l_ret.getTime() - l_ret.getTimezoneOffset()*60000);
      l_ret = new Date(l_ret.toISOString().substring(0,10) + ' ' + pDate.match(/[\d]{2}:[\d]{2}(:[\d]{2})?/g)[0] + 'Z');
    } else { // date only
      l_ret = $.datepicker.parseDate(pFormat, pDate);
      l_ret = new Date(l_ret.getTime() - l_ret.getTimezoneOffset()*60000);
    }

    // console.warn('date.parse', pDate, pFormat, l_ret);
    return(l_ret);
    // (pDate.replace('T', ' '));
  },
  format: function(pDate, pFormat){
    // console.warn('format', pDate, pFormat);
  },
  toISOString: function(pDate) { 
    let l_date = new Date(pDate).toISOString().substring(0,19);
    // console.warn('ISO', pDate, l_date);
    return (l_date);
  }
};

"use strict";


/*
 * initialize the JSON-region plugin, call form inside PL/SQL when plugin ist initialized
*/
// async function initJsonRegion( pRegionId, pName, pAjaxIdentifier, pOptions) {
async function initJsonRegion( pRegionId, pName, pAjaxIdentifier, pOptions) {
  const C_APEX_VERSION_2001 = "20.1"
  const C_APEX_VERSION_2002 = "20.2"
  const C_APEX_VERSION_2101 = "21.1"
  const C_APEX_VERSION_2102 = "21.2"
  const C_APEX_VERSION_2201 = "22.1"
  const C_APEX_VERSION_2202 = "22.2"
  const C_APEX_VERSION_2301 = "23.1"
  const C_APEX_VERSION_2302 = "23.2"
  const C_APEX_VERSION_2401 = "24.1"
  const C_APEX_VERSION_2402 = "24.2"
  const C_APEX_VERSION_2601 = "26.1"

                                              // JSON "type": "..."
  const C_JSON_TYPE             = 'type';
  const C_JSON_OBJECT           = 'object';
  const C_JSON_ARRAY            = 'array';
  const C_JSON_PROPERTIES       = 'properties';
  const C_JSON_ITEMS            = 'items';
  const C_JSON_REQUIRED         = 'required';
  const C_JSON_REF              = '$ref';
  const C_JSON_STRING           = 'string';
  const C_JSON_INTEGER          = 'integer';
  const C_JSON_NUMBER           = 'number';
  const C_JSON_BOOLEAN          = 'boolean';
  const C_JSON_NULL             = 'null';
  const C_JSON_CONST            = 'const';
  const C_JSON_FORMAT_DATE      = 'date';
  const C_JSON_FORMAT_DATETIME  = 'date-time';
  const C_JSON_FORMAT_TIME      = 'time';
  const C_JSON_FORMAT_EMAIL     = 'email';
  const C_JSON_FORMAT_URI       = 'uri';
  const C_JSON_FORMAT_IPV4      = 'ipv4';
  const C_JSON_FORMAT_IPV6      = 'ipv6';
  const C_JSON_FORMAT_UUID      = 'uuid';

                                            // conditional keywords
  const C_JSON_COND_ALL_OF      = 'allOf';
  const C_JSON_COND_ANY_OF      = 'anyOf';
  const C_JSON_COND_ONE_OF      = 'oneOf';
  const C_JSON_COND_NOT         = 'not';
  const C_JSON_COND_IF          = 'if';
  const C_JSON_COND_ELSE        = 'else';
  const C_JSON_COND_THEN        = 'then';
                                                   // JSON encoded strings
  const C_JSON_IMAGE_PNG        = 'image/png';
  const C_JSON_IMAGE_JPG        = 'image/jpg';
  const C_JSON_IMAGE_GIF        = 'image/gif';
  const C_JSON_ENCODING_BASE64  = 'base64';

  const C_DELIMITER         = '_'                  // delimiter for path of nested objects
                                                   // "apex": {"itemtype": "...", ...} 
  const C_APEX_SWITCH       = 'switch';            // itemtype switch
  const C_APEX_RICHTEXT     = 'richtext';          // itemtype richtext editor
  const C_APEX_TEXTAREA     = 'textarea';
  const C_APEX_COMBO        = 'combobox';          // itemtype combobox
  const C_APEX_RADIO        = 'radio';
  const C_APEX_CHECKBOX     = 'checkbox';
  const C_APEX_SELECT       = 'select';            // itemtype select
  const C_APEX_PASSWORD     = 'password';
  const C_APEX_STARRATING   = 'starrating';
  const C_APEX_QRCODE       = 'qrcode';
  const C_APEX_CURRENCY     = 'currency';
  const C_APEX_HORIZONTAL   = 'horizontal';
  const C_APEX_VERTICAL     = 'vertical';
  const C_APEX_PCTGRAPH     = 'pctgraph';
  const C_APEX_SELECTONE    = 'selectone';
  const C_APEX_SELECTMANY   = 'selectmany';
  const C_APEX_SHUTTLE      = 'shuttle';
  const C_APEX_POPUPLOV     = 'popuplov';
  const C_APEX_COLOR        = 'color';
  const C_APEX_FILEUPLOAD   = 'fileupload';
  const C_APEX_IMAGEDISPLAY = 'image';
  const C_APEX_IMAGEUPLOAD  = 'imageupload';
  const C_APEX_UPLOAD       = 'upload';

  const C_APEX_HELP         = 'help';
  const C_APEX_INLINEHELP   = 'inlinehelp';

  const C_APEX_LEFT         = 'left';
  const C_APEX_CENTER       = 'center';
  const C_APEX_RIGHT        = 'right';
  const C_APEX_UPPER        = 'upper';
  const C_APEX_LOWER        = 'lower';
  const C_APEX_BEGiN        = 'begin';

  const C_APEX_NOW          = 'now';

  const C_APEX_TEMPLATE_LABEL_HIDDEN   = 'hidden';
  const C_APEX_TEMPLATE_LABEL_LEFT     = 'left';
  const C_APEX_TEMPLATE_LABEL_ABOVE    = 'above';
  const C_APEX_TEMPLATE_LABEL_FLOATING = 'floating';

  const C_APEX_ALIGN        = 'align';
  const C_APEX_COLORMODE    = 'colormode';
  const C_APEX_COLSPAN      = 'colSpan';
  const C_APEX_CSS          = 'css';
  const C_APEX_DEFAULT      = 'default';
  const C_APEX_DOWNLOAD     = 'download';
  const C_APEX_ENUM         = 'enum';
  const C_APEX_FORMAT       = 'format';
  const C_APEX_HASINSERT    = 'hasInsert';
  const C_APEX_ITEMTYPE     = 'itemtype';
  const C_APEX_LABEL        = 'label';
  const C_APEX_LINES        = 'lines';
  const C_APEX_MAXFILESIZE  = 'maxFilesize';
  const C_APEX_MAXIMUM      = 'maximum';
  const C_APEX_MIMETYPES    = 'mimetypes';
  const C_APEX_MINIMUM      = 'minimum';
  const C_APEX_NEWROW       = 'newRow';
  const C_APEX_NEWCOLUMN    = 'newColumn';
  const C_APEX_NEXTNEWCOLUMN= 'nextNewColumn';
  const C_APEX_PLACEHOLDER  = 'placeholder';
  const C_APEX_QUICKPICKS   = 'quickpicks';
  const C_APEX_READONLY     = 'readonly';
  const C_APEX_WRITEONLY    = 'writeonly';
  const C_APEX_TEXTBEFORE   = 'textBefore';
  const C_APEX_TEXTCASE     = 'textcase';
  const C_APEX_DIRECTION    = 'direction';
  const C_APEX_SHOWPASSWORD = 'showPassword';
  const C_APEX_DISPLAY      = 'display';
  const C_APEX_VALIDATE     = 'validate';

  const C_AJAX_GETSCHEMA    = 'getSchema';
  const C_AJAX_GETSUBSCHEMA = 'getSubschema';

  // Extended Oracle types
  const C_ORACLE_DATE       = 'date';
  const C_ORACLE_TIMESTAMP  = 'timestamp';      

 // delimiter between values for multiselect items
  const C_VALUESEPARATOR    = '|';

  const C_DATA_DOWNLOAD     = 'download';   // Key for download data in jquery
  const C_MAX_UPLOADSIZE    = 1024;
  
    // the valid values for some keys
  const validValues = {
    "type":             [C_JSON_OBJECT, C_JSON_ARRAY, C_JSON_STRING, C_JSON_NUMBER, C_JSON_INTEGER, C_JSON_BOOLEAN, C_JSON_NULL],
    "extendedType":     [C_JSON_STRING, C_JSON_NUMBER, C_ORACLE_DATE, C_ORACLE_TIMESTAMP, C_JSON_ARRAY, C_JSON_OBJECT],
    "contentMediaType": [C_JSON_IMAGE_GIF, C_JSON_IMAGE_JPG, C_JSON_IMAGE_PNG],
    "contentEncoding":  [C_JSON_ENCODING_BASE64],
    "apex": {
      "itemtype": [C_APEX_COMBO, C_APEX_CHECKBOX, C_APEX_COLOR, C_APEX_CURRENCY, C_APEX_QRCODE, C_APEX_PASSWORD, 
        C_APEX_PCTGRAPH, C_APEX_STARRATING, C_APEX_RADIO, C_APEX_TEXTAREA, C_APEX_RICHTEXT, 
        C_APEX_SELECT, C_APEX_SELECTMANY, C_APEX_SELECTONE, C_APEX_SHUTTLE, C_APEX_POPUPLOV, C_APEX_SWITCH, 
        C_APEX_FILEUPLOAD, C_APEX_IMAGEDISPLAY, C_APEX_IMAGEUPLOAD],
      "properties":  [C_APEX_ALIGN, C_APEX_COLORMODE, C_APEX_COLSPAN, C_APEX_CSS, C_APEX_DEFAULT, C_APEX_DOWNLOAD, 
                      C_APEX_ENUM, C_APEX_FORMAT, C_APEX_HASINSERT, C_APEX_ITEMTYPE, C_APEX_LABEL,
                      C_APEX_DIRECTION, C_APEX_SHOWPASSWORD, C_APEX_DISPLAY, C_APEX_HELP, C_APEX_INLINEHELP,
                      C_APEX_LINES, C_APEX_MAXFILESIZE, C_APEX_MAXIMUM, C_APEX_MIMETYPES, C_APEX_MINIMUM, C_APEX_VALIDATE,
                      C_APEX_NEXTNEWCOLUMN, C_APEX_NEWCOLUMN, C_APEX_NEWROW, C_APEX_PLACEHOLDER, C_APEX_QUICKPICKS, C_APEX_READONLY, C_APEX_WRITEONLY, C_APEX_TEXTBEFORE, C_APEX_TEXTCASE],
      "template": [C_APEX_TEMPLATE_LABEL_ABOVE, C_APEX_TEMPLATE_LABEL_FLOATING, C_APEX_TEMPLATE_LABEL_HIDDEN, C_APEX_TEMPLATE_LABEL_LEFT]
    }
  }

  pOptions.apex_full_version = pOptions.apex_version;
  pOptions.apex_version = pOptions.apex_version.match(/\d+\.\d+/)[0];  // only first 2 numbers of version


        // get the data-template-id for inline errors from another input field
// console.error(JSON.stringify(pOptions));
  let gData = null;  // holds the JSON-data as an object hierarchie
  let gDateFormat = apex.locale.getDateFormat?apex.locale.getDateFormat():null;
  let gHelpMessages = {};

  pOptions.nls_date_format = pOptions.nls_date_format.toLowerCase().replace(/rr/g,'yy');
  if(!gDateFormat) {
    gDateFormat = pOptions.nls_date_format.toLowerCase();
    if(pOptions.apex_version != C_APEX_VERSION_2101){
      gDateFormat = gDateFormat.replace(/yy/g,'y');
    }
  }

  if(pOptions.apex_version >= C_APEX_VERSION_2101 && pOptions.apex_version < C_APEX_VERSION_2201){
    gDateFormat = gDateFormat.toLowerCase().replace('mm', 'MM');
  }

  let gTimeFormat = null;
  if(pOptions.apex_version >= C_APEX_VERSION_2201) {
    gTimeFormat = 'HH24:MI';
  } else if(pOptions.apex_version >= C_APEX_VERSION_2101) {
    gTimeFormat = "HH:mm";
  } else {
    gTimeFormat = "HH:ii";
  }

  // console.warn(pOptions.apex_version, gDateFormat, gTimeFormat);

  // hack for apex.libVersions <21.1
  if(pOptions.apex_version>=C_APEX_VERSION_2101 && pOptions.apex_version<C_APEX_VERSION_2102){
      apex.libVersions.oraclejet = '10.0.0';
  }
  // gDateFormat = 'dd.MM.yyyy';
  // gTimeFormat = 'HH:mm';

  pOptions.datatemplateET = $($('.a-Form-error[data-template-id]')[0]).attr('data-template-id') || 'xx_ET';

// Helperfunction for File Upload/Download
function arrayBufferToBase64(buffer) {
    // Create a Uint8Array from the ArrayBuffer
    const byteArray = new Uint8Array(buffer);
    // Convert the byte array to a string
    let binaryString = '';
    for (let i = 0; i < byteArray.byteLength; i++) {
        binaryString += String.fromCharCode(byteArray[i]);
    }
    // Encode the binary string to Base64
    return btoa(binaryString);
}

function base64ToBlob(base64, type) {
    // Decode the Base64 string
    const binaryString = atob(base64);
    const len = binaryString.length;
    const bytes = new Uint8Array(len);

    // Convert binary string to byte array
    for (let i = 0; i < len; i++) {
        bytes[i] = binaryString.charCodeAt(i);
    }

    // Create a Blob from the byte array
    return new Blob([bytes], { type: type });
}


  const tempObjectAttributes = [C_JSON_ITEMS, C_JSON_PROPERTIES, C_JSON_REQUIRED, C_JSON_COND_IF, C_JSON_COND_ELSE, C_JSON_COND_THEN, C_JSON_COND_ALL_OF, C_JSON_COND_ANY_OF, C_JSON_COND_ONE_OF]

  /*  
   * create a temporary object by copying data
  */
  function createTempObject(type, obj){
    const l_obj = obj||{}
    let l_ret = {type: type}
    for(const l_prop of tempObjectAttributes){
        if(l_prop in l_obj){
          l_ret[l_prop] = l_obj[l_prop]
        }
    }
    return l_ret;
  }


  /*
   *  set boolean val1 wo val2 when val1 is not set
  */
  function booleanIfNotSet(val1, val2){
     return ((typeof val1 == 'boolean')?val1:val2)
  }

  /*
   * Log JSON-schema related errormessages
  */
  function logSchemaError(msg, ...args){
    if(Array.isArray(args) && args.length>0){
      apex.debug.error('JSON-schema invalid: '+ msg, ...args)
    } else {
      apex.debug.error('JSON-schema invalid: '+ msg)
    }
  }

  function logDataError(msg, ...args){
    if(Array.isArray(args) && args.length>0){
      apex.debug.error('JSON-data invalid: '+ msg, ...args)
    } else {
      apex.debug.error('JSON-data invalid: '+ msg)
    }
  }

  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));  
  }

  /*
   * Wait until the richtext-editor < APEX-24.2 is initialized
   */
  async function richtextHack(itemtypes){
    /*
     * Check whether the richtext-editor is initialized
    */
    if(pOptions.apex_version < C_APEX_VERSION_2402 && itemtypes[C_APEX_ITEMTYPE].richtext) {
      let editorElement = $('#' + pRegionId + ' a-rich-text-editor');;
      apex.debug.trace ('wait for richtext-editor initializing ...');
      while(editorElement && editorElement.length && !editorElement[0].getEditor()){  // wait until editor is created
        await sleep(10);
      }
      apex.debug.trace ('wait for richtext-editor initialized');
    }
  }


  /*
   * Wait until the richtext-editor >= APEX24.2 is initialized
   */
  async function richtextOrtlHack(itemtypes){
    if(pOptions.apex_version>= C_APEX_VERSION_2402 && itemtypes[C_APEX_ITEMTYPE].richtext){
      let editorElement = $('#' + pRegionId + ' .ck-content');
      apex.debug.trace ('wait for richtext-editor initializing ...');
      while(!editorElement.length){  // wait until editor is created
        await sleep(10);
        editorElement = $('#' + pRegionId + ' .ck-content');
      }
      apex.debug.trace ('wait for richtext-editor initialized');
      // console.dir(editorElement[0].ckeditorInstance);
    }
  }

  /*
   * Check whether an object is empty, contains no properties or all properties are null
  */
  function isObjectEmpty(data){
    let l_empty = true;
    apex.debug.trace('>>jsonRegion.isObjectEmpty', data);
    if(data && typeof data == 'object'){
      for(const [l_key, l_data] of Object.entries(data)){
        if(l_data){
          l_empty = false;
        }
      }
    } else if(data){
      l_empty = false;
    }
    apex.debug.trace('<<jsonRegion.isObjectEmpty', l_empty);
    return(l_empty);
  } 
  /*
   * some Hacks to make the plugin work
  */
  function apexHacks(){
    // Hack to attach all Handler to the fields in the json-region  
    apex.debug.trace('>>jsonRegion.apexHacks');
      // apex.item.attach($('#' + pRegionId));
      // hack to support floating lables for universal-thema 42
    if(apex.theme42){
      apex.debug.info('Theme42 patch');
      // apex.event.trigger(apex.gPageContext$, 'apexreadyend');

      // calc whether a floating label has to be shown in small
      function needsSmallLabel( item, closest){
        // console.log('SMALL:', closest, closest.querySelector('.a-Chip--applied'));
        return  item.val() ||
                item.attr( 'placeholder' ) ||
                item.children( 'option' ).first().text() ||
                closest.querySelector('.a-Switch') ||
                closest.querySelector('.a-Chip--applied');
      };

      // size the floating label depending on item content
      function sizeLabel(elem, closest){
        if(needsSmallLabel($(elem), closest)){
          $(closest).addClass('js-show-label');
        } else {
          $(closest).removeClass('js-show-label');
        }
      }

      // $('#' + pRegionId + ' .t-Form-fieldContainer--floatingLabel input, ' + '#' + pRegionId + ' .t-Form-fieldContainer--floatingLabel select').each(function(id, elem){
      const l_elems = ['input', 'select', 'textarea'].map( x=>{return '#' + pRegionId + ' .t-Form-fieldContainer--floatingLabel ' + x}).join(', ');
      apex.debug.trace('PATCH ', l_elems);
      $(l_elems).each(function(id, elem){
        const closest = elem.closest('.t-Form-fieldContainer');
        // console.log('PATCH ITEM:', id, elem.id, closest.id, $(elem).val());
        sizeLabel(elem, closest);  // set inizal labelsize
        $(elem).on('blur', function() {
          sizeLabel(elem, closest); // change labelsize
        });
      })
    }

    apex.debug.trace('<<jsonRegion.apexHacks');
  }

    // Hack to remove border from region
  $('#' + pRegionId).css("border", "none");


    // mapping from file-extionsions like .js to html-tags required to opad the file
  const cMapType = {
    "script": {tag: "script", rel: null,         attr: "src",  prefix: "?v=" + pOptions.apex_version, type: "text/javascript"},
    "css":    {tag: "link",   rel: "stylesheet", attr: "href", prefix: "",                            type: "text/css"}
  };

  const cAlign = {
      left: "u-textStart",
      center: "u-textCenter",
      right: "u-textEnd"
  }

  /*
   *  generate a JSON-schema from JSON-data
  */
  function generateSchema(schema, data){
      apex.debug.trace(">>jsonRegion.generateSchema", schema, data);
      if(data && typeof data == 'object'){  // must go down recursivly
        if(Array.isArray(data)){
          schema = {type: "array", items: {}};
          for(const l_data of data) {
            schema.items = generateSchema(schema.items, l_data);
          }
        } else {  // a simple object
          schema.type = "object";
          schema.properties = schema.properties ||{};
          for (const [l_key, l_data] of Object.entries(data)){
            schema.properties[l_key] = schema.properties[l_key] ||{};
            schema.properties[l_key] = generateSchema(schema.properties[l_key], l_data);
          }
        }
      } else {
        let l_type = null;
        let l_format = null;
        switch(typeof data){
          case 'boolean':
            l_type = C_JSON_BOOLEAN;
          break;
          case 'number':
            if(Number.isInteger(data)){
              l_type = C_JSON_INTEGER;
            } else {
              l_type = C_JSON_NUMBER
            }
          break;
          case 'string':
            l_type = C_JSON_STRING;
                // calc format too
            if(data.match(/^\d{4}\-\d{2}\-\d{2}$/)){
              l_format = 'date';
            } else if(data.match(/^\d{4}\-\d{2}\-\d{2}(T| )\d{2}(\:\d{2}){1,2}(\.\d+)?$/)){
              l_format = 'date-time';
            } else if(data.match(/^\d{2}(\:\d{2}){1,2}(\.\d+)?$/)){
              l_format = 'time';
            }
           break;
           default:
             if(data){  // null is OK
               logSchemaError('unknown datatype', typeof data, data);
             }
             l_type = C_JSON_STRING;  // continue as a string
        }
        schema = {type: l_type};
        if(l_format){
          schema.format = l_format;
        }
      }
      apex.debug.trace("<<jsonRegion.generateSchema", schema);
      return schema;
  }
  /*
   * build the name of an item in the JSON-region from tha 
  */
  function genItemname(dataitem, field){
      let l_name = '';
      if(dataitem) {
        l_name = dataitem;
        if(field != null){
          l_name += C_DELIMITER + ('' + field);
        }
      } else {
        l_name= '' +field;
      }
      l_name = l_name.replace(/\W+/g, "_")
      return l_name;
  }

  /* 
   * evaluates the if-expression of a conditional schema using the values of the JSON-data
  */
  function evalExpression(schema, data){
    let l_ret = true;
    schema = schema||{};
    apex.debug.trace(">>jsonRegion.evalExpression", schema, data);
            // check whether values are not empty
    for(const [l_field, l_comp] of Object.entries(schema)){
    // console.log('EVAL', l_field, l_comp);
    switch(l_field){
    case C_JSON_REQUIRED:
      apex.debug.trace('evalExpression: ', schema.required, 'not empty', data);
      if(Array.isArray(l_comp)){
        for(const l_field of l_comp){
          if((data[l_field]==null) || (data[l_field].length==0)){  // field is empty
            l_ret = false;
          }
        }
      } else {
        logSchemaError('conditional schema', l_field, 'must be an array'); 
      }
    break;
    case C_JSON_COND_ALL_OF:
      for(const l_entry of l_comp){
        l_ret = l_ret && evalExpression(l_entry, data);
      }
    break;
    case C_JSON_COND_ANY_OF:
      apex.debug.trace('evalExpression: ', l_field, l_comp, 'OR');
      let l_ret2 = false;
      for(const l_entry of l_comp){
        l_ret2 = l_ret2 || evalExpression(l_entry, data);
      }
      l_ret = l_ret && l_ret2;
    break;
    case C_JSON_COND_NOT:
      apex.debug.trace('evalExpression: ', l_comp, 'NOT');
      l_ret = !evalExpression(l_comp, data);
    break;
    case C_JSON_PROPERTIES:
      l_ret = evalExpression(schema.properties, data);
    break;
    default:  // a simpre property witch == or IN
      const l_data = data?data[l_field]:null;
      if(Array.isArray(l_comp.enum)){
        apex.debug.trace('evalExpression:', l_field, "in ", l_comp, l_data)
        if(!l_comp.enum.includes(data[l_field])){
            l_ret=false;
          }
        } else if(typeof l_comp != 'undefined'){
          apex.debug.trace('evalExpression:', l_field, "==", l_comp, l_data)
          if(l_comp.const!=l_data){
            l_ret=false;
          }
        }
      }
    break;
    }
    apex.debug.trace("<<jsonRegion.evalExpression", schema, l_ret);
    return(l_ret);
  }

  /*
   * fill a map with all itemtypes used in the JSON-Schema
  */
  function getItemtypes(schema, itemtypes){
    itemtypes = itemtypes || {type: {}, itemtype: {}, format: {}};
    apex.debug.trace(">>jsonRegion.getItemtypes", schema, itemtypes);

    itemtypes.type[schema.type]=true;
    switch(schema.type){
    case C_JSON_OBJECT:
      for(let [l_name, l_property] of Object.entries(schema.properties||{})){
        itemtypes = getItemtypes(l_property, itemtypes);
      }
    break;
    case C_JSON_ARRAY:
      itemtypes = getItemtypes(schema.items, itemtypes);
      if(schema.apex){
        itemtypes[C_APEX_ITEMTYPE][schema.apex[C_APEX_ITEMTYPE]] = true;
      }
    break;
    default:
      if(schema.format){
        itemtypes.format[schema.format] = true;
      }
    break;
    }

    if(schema.apex){
      itemtypes[C_APEX_ITEMTYPE][schema.apex[C_APEX_ITEMTYPE]] = true;
    }

    apex.debug.trace("<<jsonRegion.getItemtypes", itemtypes);
    return(itemtypes);
  }

  /*
   * set show/hide attribute by mode for all fiels in schema, to show/hide conditional parts of the UI
  */
  function propagateShow(dataitem, schema, mode){
    apex.debug.trace(">>jsonRegion.propagateShow", dataitem, schema, mode);
    switch(schema.type){
    case C_JSON_OBJECT:
      for(let [l_name, l_item] of Object.entries(schema.properties)){
        if(pOptions.headers || l_item.apex.textBefore){
            // console.log('switch headers', dataitem);
            if(mode==true)  { 
              $('#' + dataitem + '_heading').show(); 
            }
            if(mode==false) { 
              $('#' + dataitem + '_heading').hide(); 
            }
        }
        propagateShow(genItemname(dataitem, l_name), l_item, mode);
      }
    break;
    case C_JSON_ARRAY:{
        const l_items = $("#" + pRegionId + ' [id^="' + dataitem + '_"].row');
        l_items.each(function(i, l_item) {
          apex.debug.trace('ARRAY:', dataitem, 'propagateShow:', i, l_item)
          const l_name = l_item.id;
          const l_container = '#' + l_item.id; 
          if(mode==true)  { 
            $(l_container).show();      
          } else {
            $(l_container).hide();
          }
          if(i>0){  // row 0 is the header which has no items, so no propagate 
            propagateShow(l_name, createTempObject(C_JSON_OBJECT, schema.items), mode);
          }
        })

      }
    break;
    default:{
        const container = '#' + dataitem + '_CONTAINER'; 
        if(mode==true)  { 
          $(container).show(); 
          $(container).parent().attr('style', '');
          if(schema.apex.textBefore){          
            $('#' + dataitem + '_heading').show();
          }
          $('#' + dataitem).prop('required',schema.isRequired);
        }
        if(mode==false) { 
          $(container).hide();
          $(container).parent().attr('style', 'display:none'); 
          if(schema.apex.textBefore){          
            $('#' + dataitem + '_heading').hide();
          }
          $('#' + dataitem).prop('required',false);
        }
      }
    }

    if(schema.allOf){
console.error('propagateShow allOf: not implemented', schema.allOf)
    }
    if(schema.anyOf){
console.error('propagateShow anyOf: not implemented', schema.anyOf)
    }
    if(schema.oneOf){
console.error('propagateShow oneOf: not implemented', schema.oneOf)
    }
    if(schema.if){
console.error('propagateShow if: not implemented', schema.if)
    }

    if(mode==false){
      setObjectValues(dataitem, dataitem, schema, false, null);
    }

    apex.debug.trace("<<jsonRegion.propagateShow");
  }

  /*
  * set the required attribute and UI marker for a UI-item
  */
  function propagateRequired(dataitem, schema, mode){
    apex.debug.trace(">>jsonRegion.propagateRequired", dataitem, schema, mode);
    let item = $('#' + dataitem);
    item.prop("required",mode);
    if(pOptions.apex_version>=C_APEX_VERSION_2102) {   // always remove the required markers, will be added if nessessary
      $('#' + dataitem + '_CONTAINER .t-Form-itemRequired-marker').remove();
      $('#' + dataitem + '_CONTAINER .t-Form-itemRequired').remove();
    }
    if(mode==true){
      item.closest(".t-Form-fieldContainer").addClass("is-required");
      if(pOptions.apex_version>=C_APEX_VERSION_2102) { 
            // add div t-Form-itemRequired-marker
        $('#' + dataitem + '_CONTAINER .t-Form-inputContainer').prepend('<div class="t-Form-itemRequired-marker" aria-hidden="true"></div>');
            // add div t-Form-itemRequired
        $('#' + dataitem + '_CONTAINER .t-Form-itemAssistance').append('<div class="t-Form-itemRequired" aria-hidden="true">Required</div>');
      }
    } else {
      item.closest(".t-Form-fieldContainer").removeClass("is-required");
    }
    apex.debug.trace("<<jsonRegion.propagateRequired");
  }

  /*
  * set the readOnly attribute recursively
  */
  function propagateReadOnly(schema, readOnly){
    apex.debug.trace(">>jsonRegion.propagateReadOnly", schema, readOnly);
    schema[C_APEX_READONLY] = readOnly;

    if(schema.type==C_JSON_OBJECT){
      for(let [l_name, l_schema] of Object.entries(schema.properties||{})){
        propagateReadOnly(l_schema, readOnly);
      }
    }

    if(schema.type==C_JSON_ARRAY){
      propagateReadOnly(schema.items, readOnly);
    }

    apex.debug.trace("<<jsonRegion.propagateReadOnly");
  }

  /*
   * convert an item-value of the APEX-UI into json-value needed for storing it
  */
  function itemValue2Json(schema, value){
    if(value === "") { value=null; };
    apex.debug.trace(">>jsonRegion.itemValue2Json", schema, value);    
    let l_value = value;
    if(value!=null){
      try{
        switch(schema.type){
          case C_JSON_STRING:
            switch(schema.format){
              case C_JSON_FORMAT_DATE:
                if(pOptions.apex_version==C_APEX_VERSION_2101) {
                  l_value = apex.date.toISOString(apex.date.parse(value, gDateFormat.replace(/yy/g, 'y').toLowerCase())).substring(0,10);
                } else {
                  l_value = apex.date.toISOString(apex.date.parse(value, gDateFormat)).substring(0,10);
                }
              break;
              case C_JSON_FORMAT_DATETIME:
                if(pOptions.apex_version==C_APEX_VERSION_2101){
                  l_value = apex.date.toISOString(apex.date.parse(value, gDateFormat.replace(/yy/g, 'y').toLowerCase() + ' ' + gTimeFormat.replace('mm','MI').replace('HH24','HH').replace('HH','HH24')));
                } else {
                  l_value = apex.date.toISOString(apex.date.parse(value, gDateFormat + ' ' + gTimeFormat.replace('mm','MI').replace('HH24','HH').replace('HH','HH24')));
                }
              break;  
              case C_JSON_FORMAT_TIME:
                l_value = value;
              break;
            }
            l_value = l_value.length>0?l_value:null;
          break;  
          case C_JSON_BOOLEAN:
            l_value = (value=="Y");
          break;
          case C_JSON_INTEGER:
          case C_JSON_NUMBER:
            if(value!=null) {
              if(schema.apex.format){
                l_value = apex.locale.toNumber(value, schema.apex.format);
              } else {
                l_value = apex.locale.toNumber(value);
              }
            }
          break;  
        }
      } catch(e){
        apex.debug.error('Invalid input data', schema.apex.format, value, e);
      }
    }
    apex.debug.trace("<<jsonRegion.itemValue2Json", l_value);
    return l_value;
  }

  /*
   * get the Value of a constant "const": ...
   * used to convert the constant NOW/new int to current date/datetime
  */
  function getConstant(format, str, isDefault){
    apex.debug.trace(">>jsonRegion.getConstant", format, str, isDefault);
    let l_value = str;
    if((typeof(str)=='string') && (str.toLowerCase() == C_APEX_NOW)){
      let l_now = new Date();
      l_now = new Date(l_now - l_now.getTimezoneOffset()*60000).toISOString();
      switch(format){
      case C_JSON_FORMAT_DATE:
          l_value = l_now.substring(0,10); // apex.date.format(new Date(), 'YYYY-MM-DD');
      break;
      case C_JSON_FORMAT_DATETIME:
          l_value = l_now.substring(0,19); // apex.date.format(new Date(), 'YYYY-MM-DDTHH24:MI:SS');
      break;
      case C_JSON_FORMAT_TIME:
          l_value = l_now.substring(11,16); // apex.date.format(new Date(), 'HH24:MI');
      break;
      default:
          l_value = str;
      break;
      }
      if(!isDefault && format==C_JSON_FORMAT_DATE) {  
          // always add  hh:mm:ss to date when not default
        l_value += 'T00:00:00';
      }
 
    }
    apex.debug.trace("<<jsonRegion.getConstant", l_value);
    return (l_value);
  }

  /*
   * convert json-value into item-value required in the APEX-UI
  */
  function jsonValue2Item(schema, value, newItem){
    let l_value = value;
    apex.debug.trace(">>jsonRegion.jsonValue2Item", schema, value);
    if(newItem && typeof schema.default != 'undefined' && schema.default!=null) {
      // When a default is configured, use it for when a new item is in use
      value = getConstant(schema.format, schema.default, true);
    }

    if(schema[C_APEX_WRITEONLY]){   // do not show the current value when it is a writeOnly UI-item
      value = null;
      l_value =  null;
    }

    if(value || value==false || value==0 || value==0.0){
      l_value = value;
      try {   
        let l_type = schema.apex.enum?typeof value:schema.type;  // when enum use datatype of enum value, else schema datatype 
        switch(l_type){
          case C_JSON_INTEGER:
          case C_JSON_NUMBER:
            if(![C_APEX_STARRATING, C_APEX_PCTGRAPH].includes(schema.apex[C_APEX_ITEMTYPE])){
              if(schema.apex.format){
                l_value = apex.locale.formatNumber(l_value, schema.apex.format);
              } else {
                if(pOptions.apex_version<C_APEX_VERSION_2102){  // older than 21.2, than formatNumber does not excange seperators
                  l_value = (''+l_value).replace('.', apex.locale.getDecimalSeparator());
                } else {
                  l_value = apex.locale.formatNumber(l_value);
                }
              }
              if(l_value && l_value.startsWith(' ')) { l_value=l_value.substring(1)}  // when numeric string starts with ' ' remove it
            }
          break;
          case C_JSON_STRING:
            switch(schema.format){
              case C_JSON_FORMAT_DATE:
                switch(pOptions.apex_version){
                case C_APEX_VERSION_2001:
                case C_APEX_VERSION_2002:
                case C_APEX_VERSION_2101:
                  l_value = $.datepicker.formatDate(gDateFormat, new Date(value));
                break;
                case C_APEX_VERSION_2102:
                case C_APEX_VERSION_2202:
                case C_APEX_VERSION_2301:
                case C_APEX_VERSION_2302:
                default:
                  l_value = apex.date.format(apex.date.parse(value,'YYYY-MM-DD'), gDateFormat);
                break;
                case C_APEX_VERSION_2201:
                  // keep the ISO-format
                  l_value = value;
                break;
                }
              break;
              case C_JSON_FORMAT_DATETIME:
                switch(pOptions.apex_version){
                case C_APEX_VERSION_2001:
                case C_APEX_VERSION_2002:
                case C_APEX_VERSION_2101:
                  value = value.replace('T', ' '); // except datetime with " " or "T" between date and time, APEX<22.1 " " delimiter
                  l_value = $.datepicker.formatDate(gDateFormat, new Date(value)) + ' ' + value.match(/[\d]{2}:[\d]{2}(:[\d]{2})?/g);
                break;
                case C_APEX_VERSION_2102:
                  l_value = apex.date.format(new Date(value), gDateFormat + ' ' + gTimeFormat.replace('mm','MI').replace('HH24','').replace('HH','HH24'));
                break;
                case C_APEX_VERSION_2202:
                case C_APEX_VERSION_2301:
                case C_APEX_VERSION_2302:
                default:
                  l_value = apex.date.format(new Date(value), gDateFormat + ' ' + gTimeFormat);
                break;
                case C_APEX_VERSION_2201:
                    // keep the ISO-format
                  l_value = value;
                break;
                }
              break;
              case C_JSON_FORMAT_TIME:
                l_value = value.substring(0,5);
              break;
              default:
                if(schema[C_APEX_READONLY]){
                  switch(schema.apex[C_APEX_ITEMTYPE]){
                  case C_APEX_TEXTAREA:
                    l_value= l_value?l_value.replaceAll('<', '&lt;').replaceAll('\n', '<br/>'):'';
                  break;
                  case C_APEX_RICHTEXT:
                  break;    
                  }  
                }  else {
                  l_value = value
                }
            }
          break;  
          case C_JSON_BOOLEAN:
            l_value = (value?"Y":"N");
          break;
          case C_JSON_INTEGER:
          case C_JSON_NUMBER:
           l_value = apex.locale.formatNumber(value, schema.apex.format ||null);
          break;
        }
      } catch(e){
        apex.debug.error('Invalid JSON-data', value, e);
      }
    }  
    apex.debug.trace("<<jsonRegion.jsonValue2Item", l_value);
    return(l_value);
  }

  /*
   *
  */ 
  function jsonValue2Display(schema, value, newItem){
    let l_value = value;
    apex.debug.trace(">>jsonRegion.jsonValue2Display", schema, value);
    l_value = (schema.apex.enum && schema.apex.enum[l_value])?schema.apex.enum[l_value]:l_value;
    l_value = jsonValue2Item(schema, l_value);
    apex.debug.trace("<<jsonRegion.jsonValue2Display", l_value);
    return(l_value);
  }

  /*
   *  add a row to an array
  */
  function delArrayRow(dataitem){
    let l_rowid = (''+dataitem).replace(/DELETE$/, '')
    apex.debug.trace(">>jsonRegion.delArrayRow", dataitem, l_rowid);
    $('[id^='+l_rowid +']').remove()
    apex.debug.trace("<<jsonRegion.delArrayRow");
  }

  /*
   *  add a row in UI for an array
  */
  function addArrayRow(dataitem, schema, atLast){
    apex.debug.trace(">>jsonRegion.addArrayRow", dataitem, schema, atLast);
    let l_items = $("#" + pRegionId + ' [id^="' + dataitem + '_"].row');
    const l_id = Math.max(0, atLast?l_items.length-2:0);
    const l_item = l_items[l_id].id;

     // calc next ID for the new row, greater than MAX of the existing rows
    const l_newId = Math.max(...l_items.map( (id, item)=> {
        const val = item.id.replace(/.+_(\d+)_CONTAINER_0$/, '$1'); 
        return isNaN(val)?0:val
      }).toArray()
    )+1;    
    // console.error(dataitem, l_newId);
    propagateReadOnly(schema.items, false);  // when add is permitted, add row with 
    let l_generated = generateForArrayEntry(schema.items, null, genItemname(dataitem, l_newId), 0, true);

    if(atLast){  // l_item is not unique when Array is toplevel
      $('#' + l_items[0].id.replace('CONTAINER_0', 'END') +'.row').before(l_generated.html);
    } else {
      $('#' + l_items[0].id + '.row').after(l_generated.html);
    }
    attachObject(genItemname(dataitem, l_newId), null, schema.items, false, {}, true, schema.items, dataitem);
    apex.item.attach($('#' + pRegionId));
    attachPopupHelp('#' + pRegionId);
    addArrayDeleteEvent();
    apexHacks();
    apex.debug.trace("<<jsonRegion.addArrayRow");
  }


  /*
   * attach the generated fields of an array in the JSON-schema to APEX
  */
  function attachArray(dataitem, previtem, schema, readonly, data, newItem){ 
    apex.debug.trace(">>jsonRegion.attachArray", dataitem, schema, readonly, data);
    let l_value = jsonValue2Item(schema, data, newItem);
    schema = schema||{};
    schema.apex = schema.apex || {};
    let item = schema.items||{};
    if(Array.isArray(item.enum)){  //[C_JSON_STRING, C_JSON_INTEGER, C_JSON_NUMBER].includes(item.type)){
      if(schema.apex[C_APEX_ITEMTYPE]==C_APEX_SELECTMANY){
        apex.item.create(dataitem, {item_type: 'selectmany'});
      } else if(schema.apex[C_APEX_ITEMTYPE]==C_APEX_SHUTTLE){
        apex.widget.shuttle('#' + dataitem, {});
      } else {
        apex.widget.checkboxAndRadio('#'+ dataitem, C_APEX_CHECKBOX);
      };
    } else {
      data = data || [];
      if(Array.isArray(data)){
        if(schema.apex.hasInsert != 'none'){
          $('#' + dataitem + '_CREATE').on('click', function(ev){ addArrayRow(dataitem, schema, schema.apex.hasInsert!=C_APEX_BEGiN);});
        }
        for(const i in data){
          const l_item = genItemname(dataitem, i)
          attachObject(l_item, previtem, item, readonly, data[i], newItem, item, l_item) 
        }
      }
    }
    if(readonly) {
      apex.item(dataitem).disable(); 
    }
    apex.debug.trace("<<jsonRegion.attachArray");
  }

  /*
   * set the Values of an array in the JSON-schema
  */
  function setArrayValues(dataitem, previtem, schema, readonly, data){ 
    apex.debug.trace(">>jsonRegion.setArrayValues", dataitem, previtem, schema, readonly, data);
    let l_value = jsonValue2Item(schema, data, newItem);
    schema.apex = schema.apex || {};
    let item = schema.items||{};
    data = data||[];
    if(Array.isArray(data)){
      if( Array.isArray(item.enum)){  // when there is an enum, this array for a multiselection
        if([C_JSON_STRING, C_JSON_INTEGER, C_JSON_NUMBER].includes(item.type)){
          l_value = (l_value||[]).map(x=> ''+x);   //convert to string array
          apex.debug.trace('setArrayValues:', l_value);
          apex.item(dataitem).setValue(l_value||[]);
          if(readonly) {
            apex.item(dataitem).disable();
          } 
        }
      } else {
        for(const i in data){
          setObjectValues(genItemname(dataitem, i), previtem, item, readonly, data[i]);
        }
      }
    } else {
      logDataError('must be an array', schema.name);
    }

    apex.debug.trace("<<jsonRegion.setArrayValues");
  }

  /*
   * set the Values of a all fields in the JSON-schema
  */
  function setObjectValues(dataitem, previtem, schema, readonly, data){ 
    apex.debug.trace(">>jsonRegion.setObjectValues", dataitem, previtem, schema, readonly, data);
    schema.apex = schema.apex || {};
    let l_value = jsonValue2Item(schema, data, newItem);
    switch(schema.type){
    case null:
    case undefined:
      if(!C_JSON_CONST in schema) {  // const has no type
        logSchemaError('missing "type" at', dataitem);
      }
    break;
    case C_APEX_UPLOAD:
      if(pOptions.apex_version>=C_APEX_VERSION_2302){
        $('#' + dataitem).data(C_DATA_DOWNLOAD, l_value);
        if(l_value){
          $('#' + dataitem + ' .a-FileDrop-download').attr(C_DATA_DOWNLOAD, l_value.name); //APEX HACK, force download of file
        }
      }
    break;
    case C_JSON_OBJECT:
      if(typeof schema.properties == 'object'){
        data = data ||{};
        for(let [l_name, l_schema] of Object.entries(schema.properties)){
          if(!(''+l_name).startsWith('_')){   // ignore properties having names starting with "_"
            setObjectValues(genItemname(dataitem, l_name), dataitem, l_schema, schema[C_APEX_READONLY], data[l_name]);
          }
        }
      }
    break;
    case C_JSON_ARRAY:   
      setArrayValues(dataitem, dataitem, schema, schema[C_APEX_READONLY], data);
    break;
    case C_JSON_CONST: // a const value
    case C_JSON_NULL:  // empty object do nothing
    break;
    case C_JSON_BOOLEAN:
      apex.item(dataitem).setValue(l_value=='Y'?'Y':'N');
      if(schema[C_APEX_READONLY]) {
        apex.item(dataitem).disable(); 
      }
    break;
    default:
      if(schema[C_APEX_READONLY]){
        if([C_APEX_STARRATING].includes(schema.apex[C_APEX_ITEMTYPE])) {
          apex.item(dataitem).disable();
        }

        if(!apex.widget.pctGraph && [C_APEX_PCTGRAPH].includes(schema.apex[C_APEX_ITEMTYPE])){
          $('#' + dataitem).html(apex.item(dataitem).displayValueFor(l_value));
        }
        
        if([C_APEX_RICHTEXT].includes(schema.apex[C_APEX_ITEMTYPE])){
          l_value = window.marked.parse( l_value||'', {
                              gfm: true,
                              breaks: true,
                              tables: true,
                              mangle: false,
                              xhtml: false,
                              headerIds: false
                            });
          $('#' + dataitem + '_DISPLAY').html(l_value);
        }
      }

      if(!schema[C_APEX_READONLY] || [C_APEX_QRCODE].includes(schema.apex[C_APEX_ITEMTYPE])){
        if(pOptions.apex_version>=C_APEX_VERSION_2202 || ( 
             ![C_JSON_FORMAT_DATETIME, C_JSON_FORMAT_DATE].includes(schema.format) &&
             ![C_APEX_STARRATING].includes(schema.apex[C_APEX_ITEMTYPE])
           )
        ){  // hack for old jet-data-picker, starrating
          apex.item(dataitem).setValue(l_value||'');
        }
      }
    break;
    }

    if(Array.isArray(schema.allOf)){
      let nr = 0;
      for(const l_schema of schema.allOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        setObjectValues(genItemname(dataitem, nr++), dataitem, l_obj, schema[C_APEX_READONLY], data);
      }
    }

    if(Array.isArray(schema.anyOf)){
      let nr = 0;
      for(const l_schema of schema.anyOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        setObjectValues(genItemname(dataitem, nr++), dataitem, l_obj, schema[C_APEX_READONLY], data);
      }
    }

    if(Array.isArray(schema.oneOf)){
      let nr = 0;
      for(const l_schema of schema.oneOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        setObjectValues(genItemname(dataitem , nr++), dataitem, l_obj, schema[C_APEX_READONLY], data);
      }
    }

    if(schema.if){
      if(schema.then) {  // conditional schema then
        setObjectValues(genItemname(dataitem, 0), dataitem, createTempObject(C_JSON_OBJECT, schema.then), schema[C_APEX_READONLY], data);
      }

      if(schema.else) { // conditional schema else
        setObjectValues(genItemname(dataitem, 1), dataitem, createTempObject(C_JSON_OBJECT, schema.else), schema[C_APEX_READONLY], data);
      }
    }


    apex.debug.trace("<<jsonRegion.setObjectValues");
  }

  /*
   *  Build recusively a list of all items used in the schema.if property
  */
  function getConditionalItems(condition){
    apex.debug.trace(">>jsonRegion.getConditionalItems", condition);
    let l_items = [];
    for(const [l_field, l_comp] of Object.entries(condition)){
      switch(l_field){
      case C_JSON_REQUIRED:
        if(Array.isArray(l_comp)){
          l_items = l_comp;
        } else {
           logSchemaError('conditional schema', l_field, 'must be an array'); 
        }
      break;
      case C_JSON_COND_ALL_OF:
      case C_JSON_COND_ANY_OF:
      case C_JSON_COND_ONE_OF:
        let nr = 0;
        for(const l_schema of l_comp){
          l_items = l_items.concat(getConditionalItems(l_schema));
        }
      break;
      case C_JSON_COND_NOT:
      case C_JSON_PROPERTIES:
        l_items = l_items.concat(getConditionalItems(condition[l_field]));
      break;
      default:  // a simpre property witch == or IN
        l_items.push(l_field);
      break;
      }
    }

    l_items = Array.from(new Set(l_items)); // remove duplicates
    apex.debug.trace("<<jsonRegion.getConditionalItems", l_items);
    return(l_items);
  }

  /*
   * attach the generated fields of the JSON-schma to APEX
  */
  function attachObject(dataitem, previtem, schema, readonly, data, newItem, baseSchema, conditionalItem){ 
    apex.debug.trace(">>jsonRegion.attachObject", dataitem, previtem, schema, readonly, data, newItem, baseSchema, conditionalItem);
    schema = schema||{};
    schema.apex = schema.apex || {};

    switch(schema.type){
    case null:
    case undefined:
      if(!C_JSON_CONST in schema) {  // const has no type
        logSchemaError('missing "type" at', dataitem);
      }
    break;
    case C_APEX_UPLOAD:
      apex.item.create(dataitem, {});
      $('#' + dataitem).on("change", function(event){ 
        const l_file = this.files[0];
        if(l_file){
          var reader = new FileReader();      
          reader.onload = function(event){
            var contents = event.target.result;     
            const l_data =arrayBufferToBase64(event.target.result);
              // store file info in JQuery-object
            $('#' + dataitem).data(C_DATA_DOWNLOAD, {name: l_file.name, size: l_file.size, type: l_file.type, content: l_data});
            console.log('File: ', l_file);              
          };      
          reader.onerror = function(event){
            console.error("File could not be read! Code " + event.target.error.code);
          }
        } else {  // no files, so empty data in JQuery object 
          $('#' + dataitem).data(C_DATA_DOWNLOAD, null);
        };  
        if(l_file && l_file.size <= (schema.apex.maxFilesize||C_MAX_UPLOADSIZE) * 1024){    
          reader.readAsArrayBuffer(l_file);        
        }
      });
    break;
    case C_JSON_OBJECT:
      if(typeof schema.properties == 'object'){
        data = data ||{};
        for(let [l_name, l_schema] of Object.entries(schema.properties)){
          if(!(''+l_name).startsWith('_')){   // ignore properties having names starting with "_"
            const l_item = genItemname(dataitem, l_name)
            attachObject(l_item, dataitem, l_schema, schema[C_APEX_READONLY], data[l_name], newItem, l_schema, l_item);
          }
        }
      }
    break;
    case C_JSON_ARRAY:   
      attachArray(dataitem, dataitem, schema, schema[C_APEX_READONLY], data, newItem);
    break;
    case 'null':  // empty object do nothing
    break;
    case C_JSON_STRING:
      if(!schema[C_APEX_READONLY]){
        switch (schema.format){
        case C_JSON_FORMAT_DATE:
        case C_JSON_FORMAT_DATETIME:
          if(pOptions.apex_version <C_APEX_VERSION_2101){
            apex.widget.datepicker('#'+ dataitem, { 
                                                  "buttonImageOnly":false,
                                                  "buttonText":"\u003Cspan class=\u0022a-Icon icon-calendar\u0022\u003E\u003C\u002Fspan\u003E\u003Cspan class=\u0022u-VisuallyHidden\u0022\u003EPopup Calendar: Created At\u003Cspan\u003E",
                                                  "showTime":        schema.format== C_JSON_FORMAT_DATETIME,
                                                  "time24h":         true,
                                                  "defaultDate":     new Date(data),
                                                  "showOn":"button",
                                                  "showOtherMonths": true,
                                                  "changeMonth":     true,
                                                  "changeYear":      true,
                                                  "minDate": schema.minimum?new Date(schema.minimum):null,
                                                  "maxDate": schema.maximum?new Date(schema.maximum):null
                                                },
                                                schema.apex.format,
                                                apex.locale.getLanguage());
            apex.jQuery('#'+ dataitem,).next('button').addClass('a-Button a-Button--calendar');
          }
        break;  
        }

        switch (schema.apex[C_APEX_ITEMTYPE]){
        case C_APEX_RADIO:
          apex.widget.checkboxAndRadio('#'+ dataitem, C_APEX_RADIO);
        break;
        case C_APEX_IMAGEDISPLAY:  // display only
        case C_APEX_QRCODE: // display only
        break;
        case C_APEX_RICHTEXT:
          if(pOptions.apex_version >= C_APEX_VERSION_2402) {
            apex.widget.rte('#' + dataitem, {
                mode:             'markdown',
                allowCustomHtml:  false,
                minHeight:        180,
                maxHeight:        360,
                displayValueMode: "plain-text",
                editorOptions:    {language: apex.locale.getLanguage()},
                label:            schema.apex[C_APEX_LABEL],
                toolbar:          "intermediate",
                toolbarStyle:     "overflow"
            });
          } else {
            apex.item.create(dataitem, {});
          }
        break;
        default:
          apex.item.create(dataitem, {});
        break;
        }
      }
    break;
    case C_JSON_BOOLEAN:
      switch(schema.apex[C_APEX_ITEMTYPE]){
      case C_APEX_SWITCH:
        apex.widget.yesNo(dataitem, 'SWITCH_CB'); 
      break;
      case C_APEX_RADIO:
        apex.widget.checkboxAndRadio('#'+ dataitem, C_APEX_RADIO);
      break;
      case C_APEX_SELECT:
        apex.item.create(dataitem, {}); 
      break;
      default:
        apex.item.create(dataitem, {}); 
      break;
      }

      if(schema[C_APEX_READONLY]) {
        apex.item(dataitem).disable(); 
      }
    break;
    case C_JSON_NUMBER:
    case C_JSON_INTEGER:
      switch(schema.apex[C_APEX_ITEMTYPE]){
      case C_APEX_PCTGRAPH:
        if(apex.widget.pctGraph) {
          apex.widget.pctGraph(dataitem);
        } else {
//          apex.item.create(dataitem, {});
        }
      break;
      case C_APEX_STARRATING:
        apex.widget.starRating(dataitem, {showClearButton: false, numStars: schema.maximum}); 
      break;
      default:       
        if(!schema[C_APEX_READONLY]){
          apex.item.create(dataitem, {});
        }
      break;
      }
    break;
    default:
      if(!C_JSON_CONST in schema) {  // a const value does n't need a type, 
        apex.debug.error('item with undefined type', dataitem, schema.type);
      }
    break;
    }

    if(Array.isArray(schema.allOf)){
      apex.debug.trace('attach allOf', schema.allOf);
      let nr = 0;
      for(let l_schema of schema.allOf){
        attachObject(genItemname(dataitem, nr++), dataitem, l_schema, schema[C_APEX_READONLY], data, newItem, schema, dataitem);
      }
    }

    if(schema.if){
      apex.debug.trace('attach if', schema.if);
      let l_eval = evalExpression(schema.if, data);
      if(schema.then) {  // conditional schema then
      apex.debug.trace('attach then', schema.then);
        let properties = schema.then.properties||{};
        const l_item = genItemname(dataitem, 0)
        attachObject(l_item, null, createTempObject(C_JSON_OBJECT, schema.then), schema[C_APEX_READONLY], data, newItem, schema.then, l_item);
        for(const [l_name, l_item] of Object.entries(properties)){
          propagateShow(genItemname(dataitem, l_name), l_item, l_eval===true);
        }
      }

      if(schema.else) { // conditional schema else
        let properties = schema.else.properties||{};
        const l_item = genItemname(dataitem, 1);
        attachObject(l_item, null, createTempObject(C_JSON_OBJECT, schema.else), schema[C_APEX_READONLY], data, newItem, schema.else, l_item);
        for(const [l_name, l_item] of Object.entries(properties)){
          propagateShow(genItemname(dataitem, l_name), l_item, l_eval===false);
        }
      }
    }

    if(schema.if){  // conditional schema, add event on items
      let l_dependOn = getConditionalItems(schema.if);
      const l_item = conditionalItem||dataitem
      apex.debug.trace('attach dependsOn', l_item, l_dependOn, baseSchema, conditionalItem, dataitem, previtem);
      for(let l_name of l_dependOn){
        apex.debug.trace('onChange', l_item, l_name);
        $("#" + genItemname(l_item, l_name)).on('change', function(){
          apex.debug.trace('clicked on', l_item, l_name, schema, baseSchema);
          if(schema.if){  // click on a conditional item
            let l_json = getObjectValues(l_item, '', createTempObject(C_JSON_OBJECT, baseSchema), null, null);
            apex.debug.trace('EVAL', l_json);
            let l_eval = evalExpression(schema.if, l_json);
            if(schema.then){ 
              let properties = schema.then.properties||{};
              for(const [l_name,l_item] of Object.entries(properties)){
                propagateShow(genItemname(dataitem, '0_' + l_name), l_item, l_eval==true);
              }
            }

            if(schema.else){ 
              let properties = schema.else.properties||{};
              for(const [l_name, l_item] of Object.entries(properties)){
                propagateShow(genItemname(dataitem, '1_' + l_name), l_item, l_eval==false);
              }
            }                              
          }
        });
      }
    }

    if(Array.isArray(schema.dependentRequired)) { 
            // the item has dependent items, so add callback on data change
        for(const item of schema.dependentRequired) {
          let l_item = genItemname(previtem, item);
          let l_value = data;
          propagateRequired(l_item, schema[item], l_value && l_value.length>0);
        }
        apex.debug.trace('dependentRequired:', dataitem)
        $("#" + dataitem).on('change', function(){
          for(const item of schema.dependentRequired) {
            let l_item = genItemname(previtem||dataitem, item)
            let l_value = $(this).val();
            console.warn('depends', schema[item], l_value);
            propagateRequired(l_item, schema[item], l_value && l_value.length>0);
          };
        });
    }
    apex.debug.trace("<<jsonRegion.attachObject");
  }

  /*
    get the unique dataitems for an array from DOM
  */
  function getArrayDataitems(dataitem){
    apex.debug.trace(">>jsonRegion.getArrayDataitems", dataitem);
    const l_rows = $("#" + pRegionId + ' [id^="' + dataitem + '_"].row');
        // get all ids for entries (dataitem followd by _ and a number), remove doublicates
    const l_ids = [...new Set(l_rows.filter(function(id, elem){ const l_regexp = new RegExp("^"+dataitem + "_[0-9]+"); return elem.id.match(l_regexp)}).map((l_id, l_row)=> {const l_regexp = new RegExp("^("+dataitem + "_[0-9]+)"); return l_regexp.exec(l_row.id);}))]
    apex.debug.trace("<<jsonRegion.getArrayDataitems", l_ids);
    return(l_ids);
  }

  /*
   * retrieve data for UI-fields of JSON-schema and build JSON, oldJson is required to support fieldwise readonly
  */
  function getObjectValues(dataitem, name, schema, curJson, oldJson){ 
    apex.debug.trace(">>jsonRegion.getObjectValues", dataitem, name, schema, curJson, oldJson);
    let l_json = {};
    schema.apex = schema.apex||{};
    if(![C_JSON_ARRAY, C_JSON_OBJECT].includes(schema.type) && schema[C_APEX_READONLY]){ // when simple attribute and readonly no data could be read, keep the old data
      l_json = oldJson;
    } else {
      l_json = schema.additionalProperties?oldJson:{};  // when there are additionalProperties, keep there values
      if(typeof curJson == 'object'){
        l_json = {...curJson, ...l_json};
      }
      switch(schema.type){
      case C_APEX_UPLOAD:
          l_json = $('#' + dataitem).data(C_DATA_DOWNLOAD);
      break;
      case C_JSON_OBJECT:
        oldJson = oldJson||{};
        if(schema.properties){
          for(let [l_name, l_schema] of Object.entries(schema.properties)){
            const l_itemname = genItemname(dataitem, l_name);
            let l_propertyname = l_name;
            if(!C_JSON_CONST in l_schema && l_schema.type!=C_JSON_NULL && !(''+l_name).startsWith('_')){
                // no const, no type null and name does not start with _, there is a UI-item
              l_propertyname = $('#' + l_itemname + '_CONTAINER').attr('json-property');
            }
            l_json[l_propertyname]=getObjectValues(l_itemname, l_name, l_schema, null, oldJson[l_name]);
          }
        }
      break;
      case C_JSON_NULL:
        l_json = null;
      break;
      case C_JSON_ARRAY: { 
          schema.items = schema.items || {};
        if(Array.isArray(schema.items.enum)){  // array for multiple selection
          let l_data = apex.item(dataitem).getValue();
          l_json = itemValue2Json(schema, l_data);
          if([C_JSON_INTEGER, C_JSON_NUMBER].includes(schema.items.type)) { // when numeric, convert string to numeric
            l_json = (l_json||[]).map( x=> Number(x));
          }
        } else {
          l_json = [];
          oldJson = oldJson||[];
          const l_ids = getArrayDataitems(dataitem);
          for(const l_id of l_ids){
            const l_data = getObjectValues(l_id, '', schema.items, null, null);
            if(!isObjectEmpty(l_data)){  // don't add empty rows
              l_json.push(l_data);
            }
          }
          if(schema[C_APEX_READONLY]) {  // array is readOnly
            if(schema.apex.hasInsert == C_APEX_BEGiN) {  // inserts at the begin, so array = new + old
              l_json = l_json.concat(oldJson);
            } else { // inserts at the end, so array = old + new
              l_json = oldJson.concat(l_json);
            }
          }
        }
      }
      break;
      case C_JSON_STRING:
      case C_JSON_INTEGER:
      case C_JSON_NUMBER:
      case C_JSON_BOOLEAN:{
        let l_data = null;
        let l_value = null;
        l_data = apex.item(dataitem).getValue();
        l_value = itemValue2Json(schema, l_data);
        if(l_value!=null){
          l_json = l_value;
        } else {
          l_json = null;
        }
// ---- HACK  -------
        if((''+name).startsWith('_')){
          l_json = oldJson; 
        }
      }
      break;
      default:
        if(C_JSON_CONST in schema) {  // a const doesn't have a item in the UI
          l_json = schema.const;
        }
      break;
      }
    }

    if(Array.isArray(schema.allOf)){
      let nr = 0;
      for(const l_schema of schema.allOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        const l_newJson = getObjectValues(genItemname(dataitem, nr++), '', l_obj, l_json, oldJson);
        l_json = {...l_json, ...l_newJson};
      } 
    }

    if(Array.isArray(schema.anyOf)){
      let nr = 0;
      for(const l_schema of schema.anyOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        const l_newJson = getObjectValues(genItemname(dataitem, nr++), '', l_obk, l_json, oldJson);
        l_json = {...l_json, ...l_newJson};
      } 
    }

    if(Array.isArray(schema.oneOf)){
      let nr = 0;
      for(const l_schema of schema.allOf){
        const l_obj = {...l_schema};
        l_obj.type = C_JSON_OBJECT;
        const l_newJson = getObjectValues(genItemname(dataitem, nr++), '', l_obj, l_json, oldJson);
        l_json = {...l_json, ...l_newJson};
      } 
    }

    if(schema.if){  // there is a conditional schema
        // getting the data depends on the evaluation of the if clause.
      let l_eval = evalExpression(schema.if, l_json);
      if(schema.then && l_eval==true){
        let properties = schema.then.properties||{};
        let l_newJson = getObjectValues(genItemname(dataitem, 0), '', createTempObject(C_JSON_OBJECT, schema.then), l_json, oldJson);
        // console.dir(l_newJson);
        // merge conditional input into current result
        l_json = {...l_json, ...l_newJson};
      }

      if(schema.else && l_eval==false){
        let properties = schema.else.properties||{};
        let l_newJson = getObjectValues(genItemname(dataitem, 1), '', createTempObject(C_JSON_OBJECT, schema.else), l_json, oldJson);
        // console.dir(l_newJson);
        // merge conditional input into current result
        l_json = {...l_json, ...l_newJson};
      }

    }
    apex.debug.trace("<<jsonRegion.getObjectValues", l_json);
    return(l_json);
  }

  /*
   * generates the label from the objectname or use an existing label
  */
  function generateLabel(name, schema){
    let l_label='';
    if(schema.apex && C_APEX_LABEL in schema.apex){
      l_label = schema.apex[C_APEX_LABEL]||'';
    } else {  
      // for default label replace -_ by a blank and set first char of each word in uppercase
      name = name ||'';
      l_label = name.toLowerCase()
                     .split(/ |\-|_/)
                     .map((s) => s.charAt(0).toUpperCase() + s.substring(1))
                     .join(' ');
    }
    return(l_label);
  }

  /*
   * propagate the subschemas for "$ref"
  */
  async function propagateRefs(schema){
    apex.debug.trace(">>jsonRegion.propagateRefs", schema);
    if(schema && typeof schema == 'object'){
      if(schema[C_JSON_REF] && typeof schema[C_JSON_REF] == 'string'){
        let jsonpath=schema[C_JSON_REF];
        if(jsonpath.startsWith('#/')){  // reference in the current document
          apex.debug.trace('resolve local $ref', jsonpath);
          let getValue = (o, p) => p.replace('#/','').split('/').reduce((r, k) => r[k], o);
          try{
            let newSchema = getValue(pOptions.schema, jsonpath);
            if(newSchema){
//              Object.assign(schema, newSchema);
              schema = {...newSchema, ...schema}
              schema.apex = {...newSchema.apex, ...schema.apex}
              //Object.assign(newSchema, schema);
            } else {
              logSchemaError('unknown', C_JSON_REF, schema[C_JSON_REF])
            }
            delete(schema[C_JSON_REF]);
          } catch(e){
            logSchemaError('target of $ref not found: ', jsonpath);
            delete(schema[C_JSON_REF]);
          }
        }
        if(jsonpath.startsWith('/')){  // reference from APEX-application via callback
          apex.debug.trace('resolve external $ref', jsonpath);
          await apex.server.plugin ( 
            pAjaxIdentifier, 
            { pageItems: pOptions.queryitems,
              x04: C_AJAX_GETSUBSCHEMA,
              x05: jsonpath}
          )
          .then((data) =>{
            apex.debug.trace('AJAX-Callback $ref OK', jsonpath, data);
            // schema = data;
            schema = {...data, ...schema};
            schema.apex = {...data.apex, ...schema.apex};
            // console.dir(schema);
          })
          .catch((err) =>{
            apex.debug.error('CallbackError $ref ERROR', jsonpath, err);
          });
        }
      } else {
        // process recursively 
        if(Array.isArray(schema)){ 
          for(const i in schema){
            schema[i] = await propagateRefs(schema[i]);
          }   
        } else {
          for(const [l_key, l_schema] of Object.entries(schema)){
            schema[l_key] = await propagateRefs(l_schema);
          }
        }
      }
    }
    apex.debug.trace("<<jsonRegion.propagateRefs", JSON.stringify(schema));
    return schema;
  }

  /*
   * propagate values of JSON-schema properties recusive into properties/items
   * Set some properties depending on others
   * Set missing properties to reasonable values to avoid errors in later stages
   * Returns the hierarchie with all keys combining if/then/else/allOf/oneOf/anyOf
  */
  function propagateProperties(schema, level, readonly, writeonly, additionalProperties, conditional, name, prefix, nextNewColumn){ 
    schema = schema || {};
    schema.apex = schema.apex||{};
    // schema.apex.conditional = conditional;
    let l_allProperties = null;
    apex.debug.trace(">>jsonRegion.propagateProperties", level, schema, readonly, writeonly, additionalProperties, conditional, name, prefix);
      
    level++;
    if(level>20){  // break endless recursive calls
      apex.debug.error('propagateProperties recursion', level, 'to deep')
      return;
    }

      // harmonize schema.xxx and schema.apex.xxx, so that further check can be done on schema.xxx
    schema.apex[C_APEX_READONLY]  ??= readonly;
    schema.apex[C_APEX_WRITEONLY] ??= writeonly;
    schema[C_APEX_READONLY]       ??= schema.apex[C_APEX_READONLY];
    schema[C_APEX_WRITEONLY]      ??= schema.apex[C_APEX_WRITEONLY];

    if(schema.apex.format!=null)  { schema.format = schema.apex.format}
    if(schema.apex.minimum!=null) { schema.minimum = schema.apex.minimum}
    if(schema.apex.maximum!=null) { schema.maximum = schema.apex.maximum}
    if(schema.apex.default!=null) { schema.default = schema.apex.default}

    if(!schema.apex[C_APEX_LABEL] && schema.title) {schema.apex[C_APEX_LABEL] = schema.title}
    if(!schema.apex.placeholder && schema.description) {schema.apex.placeholder = schema.description}


    schema.apex[C_APEX_NEWROW]        ??= false;
    schema.apex[C_APEX_NEWCOLUMN]     ??= true;
    schema.apex[C_APEX_NEXTNEWCOLUMN] = nextNewColumn;

    if(schema.apex[C_APEX_NEWROW]){    // new row always new column
      schema.apex[C_APEX_NEWCOLUMN] = true;
    }
    
     // process Oracle's extendedTypes
        // Oracle's extendedType for >= 23.7
    if(Array.isArray(schema.oneOf) && schema.oneOf.length==2) {
      schema.oneOf = schema.oneOf.filter(item => item.extendedType!='null') 
      if(schema.oneOf.length==1){
        schema.extendedType = schema.oneOf[0].extendedType;
        delete(schema.oneOf);
      }
    }

    if(schema.extendedType) {   // Oracle specific datatype, could be a string or an array of string
      if(Array.isArray(schema.extendedType)){    // for nullable  properties it is ["type", null]
        const l_nullPos = schema.extendedType.indexOf('null'); 
        if(l_nullPos>=0){  // 
          console.warn('Remove null from', schema.extendedType, l_nullPos);
          schema.extendedType.splice(l_nullPos, l_nullPos);
        }
        if(schema.extendedType.length == 1){
          schema.extendedType = schema.extendedType[0];
        }
      }
    }

      // check for valid values
    Object.keys(schema.apex).every(l_entry => {if(!validValues.apex.properties.includes(l_entry)) { logSchemaError(name, 'invalid apex property', l_entry); return false;} else {return true;} });

    if(schema.extendedType && !validValues.extendedType.includes(schema.extendedType))    { logSchemaError(name, 'invalid extendedtype', schema.extendedType)}
    if(!C_JSON_CONST in schema && !conditional && !schema.extendedType && name && !name.startsWith('_') && !validValues.type.includes(schema.type)) {
      logSchemaError(name, 'invalid type', schema.type);
      schema.type = C_JSON_STRING;   // reset type to to string
    }
    if(schema.apex[C_APEX_ITEMTYPE] && !validValues.apex[C_APEX_ITEMTYPE].includes(schema.apex[C_APEX_ITEMTYPE])) { 
      logSchemaError(name, 'invalid itemtype', schema.apex[C_APEX_ITEMTYPE]);
      delete schema.apex[C_APEX_ITEMTYPE];
    }
    if(schema.apex.template && !validValues.apex.template.includes(schema.apex.template)) { 
      logSchemaError(name, 'invalid template', schema.apex.template);
      delete schema.apex.template;
    }

    if(C_JSON_TYPE in schema || 'extendedType' in schema || C_JSON_PROPERTIES in schema || C_JSON_ITEMS in schema){
      schema.name = name;
    }

    if([C_APEX_FILEUPLOAD, C_APEX_IMAGEUPLOAD].includes(schema.apex[C_APEX_ITEMTYPE])){
      schema.type = C_APEX_UPLOAD;
    }

    if(schema.dependentSchemas){ // convert dependent schemas to IF/ELSE, required property to dependentRequired
      let l_keys = Object.keys(schema.dependentSchemas);
      if(l_keys.length==1){
        schema.if = { "properties": {}};
        schema.if.properties[l_keys[0]] = {"const": null};
        schema.else = { "properties": {}};
        schema.else.properties = schema.dependentSchemas[l_keys[0]].properties;
        const l_required = schema.dependentSchemas[l_keys[0]].required;
        if(Array.isArray(l_required)){
          schema.dependentRequired=[];
          schema.dependentRequired[l_keys[0]] = l_required;
        }
        delete schema.dependentSchemas;
      } else {
        apex.debug.error('dependentSchemas: number of objects != 1');
      }
    }

        // propagate the dependentRequired directly to the properties 
    if(schema.type==C_JSON_ARRAY){ 
      if(schema.items){
         if(Object.keys(schema.items).length==0){  // items should have at least one entry
           apex.debug.warn('array should have at least 1 items')
         }
         schema.items.name = schema.name;
       } else {
        logSchemaError('missing "items" for "type": "array"')  
        schema.items={};
      }
    }

        // propagate the dependentRequired directly to the properties 
    if(schema.type==C_JSON_OBJECT){ 
      if(!schema.properties){
        logSchemaError('missing "properties" for "type": "object"');
        schema.properties={}; 
      }

      schema.additionalProperties = booleanIfNotSet(schema.additionalProperties, additionalProperties);
      if(schema.dependentRequired){
        for(let [l_name, l_schema] of Object.entries(schema.dependentRequired)){
          try{
            schema.properties[l_name].dependentRequired = l_schema;
          }catch(e){
            apex.debug.error('dependentRequired not found: ', l_name, e);            
          }
        }
      }  
    }

    // calc minimum/maximum
    if(schema.minimum){
      schema.minimum = getConstant(schema.format, schema.minimum, false);
    }
    if(schema.maximum){
      schema.maximum = getConstant(schema.format, schema.maximum, false);
    }
    
    if(schema.pattern &&!schema.type) {  // when pattern is set type the default is "type": "string"
      schema.type = C_JSON_STRING;
    }

    // handle special formats as pattern
    switch(schema.format){
    case C_JSON_FORMAT_IPV4:   // examples: 123.123.123.123 or 123.123.123.123/32
      schema.maxLength = 18;
      schema.pattern   = "(\\d{1,3}\\.){3}\\d{1,3}(/\\d{1,2})?";
    break;
    case C_JSON_FORMAT_IPV6:
      schema.maxLength = 43;
      schema.pattern   = "([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}(/\\d{1,3})?";
    break;
    case C_JSON_FORMAT_UUID:   // example: 12345678-abcd-abcd-abcd-1234567890ab
      schema.maxLength = 36;
      schema.pattern   = "[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}";
    break;
    }

    // Oracle specific SCHEMA extensions
    if(schema.properties && schema.properties.dbPrimaryKey){  // remove dbPrimaryKey, it's a property and would so be handled as en input item
      delete schema.properties.dbPrimaryKey;
    }

    if(schema.extendedType) {   // Oracle specific datatype
      switch (schema.extendedType) {   // Oracle-spcific extension, convert into json-schema repesentation
      case C_JSON_FORMAT_DATE:
        schema.type = C_JSON_STRING;
        schema.format= schema.format|| C_JSON_FORMAT_DATE; // do not overwrite existing formats
      break;
      case C_ORACLE_DATE:
      case C_ORACLE_TIMESTAMP:
        schema.type = C_JSON_STRING;
        schema.format=schema.format|| C_JSON_FORMAT_DATETIME;
      break;
      case C_JSON_ARRAY:
      case C_JSON_OBJECT:
      case C_JSON_STRING:
      case C_JSON_BOOLEAN:
        schema.type = schema.extendedType;
      break;
      case C_JSON_INTEGER:
      case C_JSON_NUMBER:
        if(schema.sqlScale==0){  // no digit behind ".", so integer
          schema.type = C_JSON_INTEGER;
        } else {
          schema.type = schema.extendedType;
        }
      break;
      default:
        apex.debug.error('Schema contains unsupport extendedType %s', schema.extendedType);
      }
    }

    switch(schema.type){
      case C_JSON_NUMBER:
        schema.apex.format = (schema.apex.format==C_APEX_CURRENCY)?'FML999G999G999G999G990D99':(schema.apex.format);
      break;
      case C_JSON_INTEGER:
        schema.apex.format = (schema.apex.format==C_APEX_CURRENCY)?'FML999G999G999G999G990':(schema.apex.format||'99999999999999999999990');
        if(schema.apex[C_APEX_ITEMTYPE]==C_APEX_PCTGRAPH){
          schema[C_APEX_READONLY] = true;
        }
      break;
      case C_JSON_STRING:
        if([C_APEX_QRCODE, C_APEX_IMAGEDISPLAY].includes(schema.apex[C_APEX_ITEMTYPE])){
          schema[C_APEX_READONLY]   = true;  // can not be changed
          schema.isRequired = false; // not required
        };

        if(schema.contentEncoding){   // encoded string
          if(schema.contentEncoding== C_JSON_ENCODING_BASE64){
            if([C_JSON_IMAGE_GIF, C_JSON_IMAGE_JPG, C_JSON_IMAGE_PNG].includes(schema.contentMediaType)){
              schema.apex.image=schema.contentMediaType;
              schema.apex[C_APEX_ITEMTYPE] = schema.apex[C_APEX_ITEMTYPE]==C_APEX_IMAGEUPLOAD?C_APEX_IMAGEUPLOAD:C_APEX_IMAGEDISPLAY;
              schema[C_APEX_READONLY] = schema.apex[C_APEX_ITEMTYPE]==C_APEX_IMAGEDISPLAY?true:schema[C_APEX_READONLY];
            } else {
              if(schema.type != C_APEX_UPLOAD){
                apex.debug.error('unknown string contentMediaType "%s"', schema.contentMediaType);
              // default is JPG
                schema.contentMediaType = C_JSON_IMAGE_JPG;
                schema.apex.image=schema.contentMediaType;
              }
            }
          } else {
            apex.debug.error('unknown string encoding "%s"', schema.contentEncoding);  
            schema.contentEncoding = C_JSON_ENCODING_BASE64;
          }
        } else {  // plain string, check formats
          switch(schema.format){
           case C_JSON_FORMAT_DATE:
             schema.apex.format = schema.apex.format || gDateFormat;
           break;
           case C_JSON_FORMAT_DATETIME:
             schema.apex.format = schema.apex.format || (gDateFormat + ' ' + gTimeFormat);
           break;
           case C_JSON_FORMAT_TIME:
             schema.apex.format = gTimeFormat;
           break;
           default:
             if(schema.maxLength && schema.maxLength>pOptions.textareawidth && schema.apex[C_APEX_ITEMTYPE] !=C_APEX_RICHTEXT){
               schema.apex[C_APEX_ITEMTYPE]=C_APEX_TEXTAREA;  
             }
           break;   
          }
        }
      break;    
    }

        // set apex.formats
    if(pOptions.apex_version <C_APEX_VERSION_2302){ // check for new itemtype
      if(schema.type == C_APEX_UPLOAD){
        logSchemaError('itemtype not supported in APEX-version', schema.apex[C_APEX_ITEMTYPE], pOptions.apex_version);
        delete schema.apex[C_APEX_ITEMTYPE];
      }
    }

        // set apex.formats
    if(pOptions.apex_version <C_APEX_VERSION_2301){ // check for new itemtype in old releases, remove them and log error
      if([C_APEX_COLOR].includes(schema.apex[C_APEX_ITEMTYPE])){
        logSchemaError('itemtype not supported in APEX-version', schema.apex[C_APEX_ITEMTYPE], pOptions.apex_version);
        delete schema.apex[C_APEX_ITEMTYPE];
      }
    }

        // set apex.formats
    if(pOptions.apex_version <C_APEX_VERSION_2401){ // check for new itemtype in old releases, remove them and log error
      if([C_APEX_SELECTONE, C_APEX_SELECTMANY, C_APEX_SHUTTLE].includes(schema.apex[C_APEX_ITEMTYPE])){
        logSchemaError('itemtype not supported in APEX-version', schema.apex[C_APEX_ITEMTYPE], pOptions.apex_version);
        delete schema.apex[C_APEX_ITEMTYPE];
      }
    }

        // set apex.formats
    if(pOptions.apex_version <C_APEX_VERSION_2302){ // check for new itemtype in old releases, remove them and log error
      if([C_APEX_QRCODE, C_APEX_RICHTEXT, C_APEX_COMBO, ].includes(schema.apex[C_APEX_ITEMTYPE])){
        logSchemaError('itemtype not supported in APEX-version', schema.apex[C_APEX_ITEMTYPE], pOptions.apex_version);
        if(schema.apex[C_APEX_ITEMTYPE] == C_APEX_RICHTEXT){  // use textarea
          schema.apex[C_APEX_ITEMTYPE] = C_APEX_TEXTAREA;
        } else {
          delete schema.apex[C_APEX_ITEMTYPE];
        }
      }
    }

      // default für "enum"
    if(schema.enum){
      schema.apex[C_APEX_ITEMTYPE] = schema.apex[C_APEX_ITEMTYPE]|| C_APEX_SELECT;
    }    
      
        // propagate required to each properties
    if(Array.isArray(schema.required)){
      for(let l_schema of schema.required){
        if(schema.properties && schema.properties[l_schema]){
          schema.properties[l_schema].isRequired=true;
        }
        if(schema.items && schema.items[l_schema]){
          schema.items[l_schema].isRequired=true;
        }
      }
    }

        // this is an object, process the properties
    if(typeof schema.properties == 'object'){
      l_allProperties = l_allProperties||{};
      const l_keys = Object.keys(schema.properties);
      for(const [i, l_name] of l_keys.entries()){
        const l_schema = schema.properties[l_name]; 
        let l_nextNewColumn = true;
        if(i>= l_keys.length-1) {
          l_nextNewColumn = true; // last property, close column in any case
        } else {
          l_nextNewColumn = (schema.properties[l_keys[i+1]].apex||[])[C_APEX_NEWCOLUMN]??true;  // next property is in new Column
        }
        l_allProperties[l_name] = propagateProperties(l_schema, level, schema[C_APEX_READONLY], schema[C_APEX_WRITEONLY], schema.additionalProperties, false, l_name, schema.id, l_nextNewColumn);
      }
    }

    if(schema.items){  // this is an array, process the items
      schema.items.additionalProperties = booleanIfNotSet(schema.items.additionalProperties, additionalProperties);
      l_allProperties = propagateProperties(schema.items, level, schema[C_APEX_READONLY], schema[C_APEX_WRITEONLY], schema.additionalProperties, false, schema.name, schema.id, true);
    }

    if(Array.isArray(schema.allOf)){
      let l_name = name;
      let nr     = 0;
      for(let l_schema of schema.allOf){
        const l_props = propagateProperties(l_schema, level, schema[C_APEX_READONLY], schema[C_APEX_WRITEONLY], schema.additionalProperties, true, l_name, genItemname(prefix, nr++), true);
        l_allProperties = {...l_allProperties, ...l_props}
      }
    }

    if(schema.then){
      const l_props = propagateProperties(createTempObject(C_JSON_OBJECT, schema.then), level, schema[C_APEX_READONLY], schema[C_APEX_WRITEONLY], schema.additionalProperties, true, 'then', schema.id, true);
      l_allProperties = {...l_allProperties, ...l_props}
    }

    if(schema.else){
      const l_props = propagateProperties(createTempObject(C_JSON_OBJECT, schema.else), level, schema[C_APEX_READONLY], schema[C_APEX_WRITEONLY], schema.additionalProperties, true, 'else', schema.id, true);
      l_allProperties = {...l_allProperties, ...l_props}
    }

    // no properties found here, so use the schema.type
    l_allProperties = l_allProperties||schema.type;

    schema.apex[C_APEX_LABEL] = generateLabel(schema.name, schema);
    
    // remove double helps
    if(schema.apex[C_APEX_INLINEHELP] && schema.apex[C_APEX_HELP]) {
      schema.apex[C_APEX_HELP] = null;
      logSchemaError('only one of inlinehelp and help is supported', schema.name);
    }

    apex.debug.trace("<<jsonRegion.propagateProperties", level, l_allProperties);
    return(l_allProperties)
  }

  /*
   * generate the UI HTML for Shuttle widget 
   * returns {items: 0, wrappertype: "apex-item-wrapper--shuttle", html: "xxx"}
  */
  function generateForShuttle(schema, data, itemtype, schemaApex){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    let l_values = (data||[]).join(C_VALUESEPARATOR);
    schema.apex.enum=[];
    apex.debug.trace(">>jsonRegion.generateForShuttle", schema, data, itemtype, schemaApex);
    if(schema[C_APEX_READONLY]){
      let l_html = `
<span class="display_only apex-item-display-only">
`;

      for(const l_option of data ||[]){
        l_html += apex.util.applyTemplate(`
  <div>#DISPLAYVALUE#</div>
`,                                                 {
                                                    placeholders: {
                                                      "DISPLAYVALUE": jsonValue2Display(schema, l_option, newItem)
                                                   }
                                                });
      }

      l_html += `
</span>
`;


      l_generated = {
        items:       1,
        wrappertype: 'apex-item-wrapper--text-field',
        html:        l_html
      };

    } else {
      l_generated = {
        items:       1,
        wrappertype: 'apex-item-wrapper--shuttle',
        html:        apex.util.applyTemplate(`
<div class="apex-item-group apex-item-group--shuttle" role="group" id="#ID#" aria-labelledby="#ID#_LABEL" tabindex="-1">
  <table cellpadding="0" cellspacing="0" border="0" role="presentation" class="shuttle">
    <tbody>
      <tr>
<td class="shuttleSelect1">
<select title="Move from" multiple="multiple" id="#ID#_LEFT" size="5" class="shuttle_left apex-item-select">
`,
                                                {
                                                    placeholders: {
                                                      "VALUES": l_values,
                                                      "VALUESEPARATOR": C_VALUESEPARATOR
                                                   }
                                                })
      };
      for(const l_option of schema.enum ||[]){
        l_generated.html += apex.util.applyTemplate(`
  <option value="#OPTION#">#DISPLAYVALUE#</option>
`,                                                 {
                                                    placeholders: {
                                                      "OPTION": apex.util.escapeHTML(''+l_option),
                                                      "DISPLAYVALUE": jsonValue2Display(schema, l_option, newItem)
                                                   }
                                                });
      }

      l_generated.html += apex.util.applyTemplate(`
</select></td>
<td align="center" class="shuttleControl">
  <button id="#ID#_RESET" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Reset" aria-label="Reset"> 
    <span class="a-Icon icon-shuttle-reset" aria-hidden="true"></span>
  </button>
  <button id="#ID#_MOVE_ALL" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Move All" aria-label="Move All"> 
    <span class="a-Icon icon-shuttle-move-all" aria-hidden="true"></span>
  </button>
  <button id="#ID#_MOVE" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Move" aria-label="Move"> 
    <span class="a-Icon icon-shuttle-move" aria-hidden="true"></span>
  </button>
  <button id="#ID#_REMOVE" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Remove" aria-label="Remove"> 
    <span class="a-Icon icon-shuttle-remove" aria-hidden="true"></span>
  </button>
  <button id="#ID#_REMOVE_ALL" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Remove All" aria-label="Remove All"> 
    <span class="a-Icon icon-shuttle-remove-all" aria-hidden="true"></span>
  </button>
</td>
<td class="shuttleSelect2">
<select title="Move to" multiple="multiple" id="#ID#_RIGHT" size="5" name="#ID#" #REQUIRED# class="shuttle_right apex-item-select">
`,
                                                {
                                                    placeholders: {
                                                      "VALUES": l_values,
                                                      "VALUESEPARATOR": C_VALUESEPARATOR
                                                   }
                                                });
      l_generated.html += apex.util.applyTemplate(`
</select></td>
<td align="center" class="shuttleSort2">
<button id="#ID#_TOP" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Top" aria-label="Top"> <span class="a-Icon icon-shuttle-top" aria-hidden="true"></span></button><button id="#ID#_UP" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Up" aria-label="Up"> <span class="a-Icon icon-shuttle-up" aria-hidden="true"></span></button><button id="#ID#_DOWN" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Down" aria-label="Down"> <span class="a-Icon icon-shuttle-down" aria-hidden="true"></span></button><button id="#ID#_BOTTOM" class="a-Button a-Button--noLabel a-Button--withIcon a-Button--small a-Button--noUI a-Button--shuttle" type="button" title="Bottom" aria-label="Bottom"> <span class="a-Icon icon-shuttle-bottom" aria-hidden="true"></span></button></td>
      </tr>
    </tbody>
  </table>
</div>`,
                                                {
                                                    placeholders: {
                                                      "VALUES": l_values,
                                                      "VALUESEPARATOR": C_VALUESEPARATOR
                                                   }
                                                });
    }
    apex.debug.trace("<<jsonRegion.generateForShuttle", l_generated);
    return(l_generated);
  }

  /*
   * generate the UI HTML for 23.2 Combobox 
   * returns {items: 0, wrappertype: "apex-item-wrapper--combobox apex-item-wrapper--combobox-many", html: "xxx"}
  */
  function generateForCombo(schema, data, itemtype, schemaApex){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    let l_values = (data||[]).join(C_VALUESEPARATOR);
    apex.debug.trace(">>jsonRegion.generateForCombo", schema, data, itemtype, schemaApex);
    l_generated = {
        items:       1,
        wrappertype: 'apex-item-wrapper--combobox apex-item-wrapper--combobox-many',
        html:        apex.util.applyTemplate(`
<a-combobox id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER# value="#VALUES#" multi-value="true" return-display="false" value-separators="#VALUESEPARATOR#" max-results="7" min-characters-search="0" match-type="contains" maxlength="100" multi-select="true" parents-required="true">
  <div class="apex-item-comboselect">
    <ul class="a-Chips a-Chips--applied a-Chips--wrap" role="presentation">
`,
                                                {
                                                    placeholders: {
                                                      "VALUES": l_values,
                                                      "VALUESEPARATOR": C_VALUESEPARATOR
                                                   }
                                                })
    };

    l_generated.html += apex.util.applyTemplate(`
      <li class="a-Chip a-Chip--input is-empty">
        <input type="text" class="apex-item-text" aria-labelledby="#ID#_LABEL" value="#VALUES#" #PLACEHOLDER# maxlength="100" role="combobox" aria-expanded="false" autocomplete="off" autocorrect="off" autocapitalize="none" spellcheck="false" aria-autocomplete="list" aria-describedby="#ID#_desc" aria-busy="false">
        <span class="a-Chip-clear js-clearInput"><span class="a-Icon icon-multi-remove" aria-hidden="true"></span></span>
      </li>
    </ul>
  </div>
  <a-column-metadata name="#ID#" searchable="true" index="0"></a-column-metadata>
`,
                                                {
                                                    placeholders: {
                                                      "VALUES": apex.util.escapeHTML(''+l_values)
                                                   }
                                                });
    for(const l_option of schema.enum ||[]){
      l_generated.html += apex.util.applyTemplate(`
  <a-option value="1">#OPTION#<a-option-column-value>#OPTION#</a-option-column-value></a-option>
`,                                                 {
                                                    placeholders: {
                                                      "OPTION": apex.util.escapeHTML(''+l_option)
                                                   }
                                                });
    }
    l_generated.html += `
</a-combobox>
`;
    apex.debug.trace("<<jsonRegion.generateForCombo", l_generated);
    return(l_generated);
  }


  /*
   * generate the UI-item for selectOne/selectMany items depending on itemtype
   * returns {items: 0, wrappertype: "apex-item-wrapper--select-one or -many", html: "xxx"}
  */
  function generateForSelectOneMany(schema, data, itemtype, schemaApex){
    let l_generated = { items:0, wrappertype: null, html: ''};
    schema.apex = schema.apex||{};
    schema.apex.enum = schema.apex.enum||{};
    apex.debug.trace(">>jsonRegion.generateForSelectOneMany", schema, data, itemtype, schemaApex);
    let l_values = (itemtype==C_APEX_SELECTMANY)?(data||[]).join(C_VALUESEPARATOR):data;
    l_generated = {
        items:       1,
        wrappertype: (itemtype==C_APEX_SELECTMANY)?'apex-item-wrapper--select-many':'apex-item-wrapper--select-one',
        html:        apex.util.applyTemplate(`
<a-select id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER# value="#VALUE#"return-display="true" multi-select="#MULTISELECT#" multi-value="#MULTIVALUE#" #VALUESEPARATOR#  max-results="250" min-characters-search="0" match-type="contains" parents-required="true" display-values-as="#DISPLAYAS#">
`,
                                                {
                                                    placeholders: {
                                                      "VALUESEPARATOR": 'multi-value-storage="separated" multi-value-separator="'+ C_VALUESEPARATOR+'"',
                                                      "MULTIVALUE":  (itemtype==C_APEX_SELECTMANY)?'true':'false',
                                                      "MULTISELECT": (itemtype==C_APEX_SELECTMANY)?'true':'false',
                                                      "DISPLAYAS":   schemaApex.asChips?'chips':'separated',
                                                      "VALUES":      l_values
                                                   }
                                                })
    };
    for(const l_value of schema.enum ||[]){
      l_generated.html += apex.util.applyTemplate(`
<a-option value="#VALUE#">
  #DISPLAYVALUE#
</a-option>
`,                                                 {
                                                    placeholders: {
                                                      "VALUE":        apex.util.escapeHTML(''+l_value),
                                                      "DISPLAYVALUE": jsonValue2Display(schema, l_value, newItem)
                                                   }
                                                });
    }

    l_generated.html += `
</a-select>
`;
    apex.debug.trace("<<jsonRegion.generateForSelectOneMany", l_generated);
    return(l_generated);
  }

  /*
   * generate the UI-item for a pulldown/radio/checkbox property depending on itemtype
   * returns {items: 0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForSelect(schema, data, itemtype, schemaApex){
    let l_generated = { items:0, wrappertype: null, html: ''};
    schema.apex = schema.apex||{};
    schema.apex.enum = schema.apex.enum||{};
    apex.debug.trace(">>jsonRegion.generateForSelect", schema, data, itemtype, schemaApex);
    switch (itemtype){
    case C_APEX_SELECT:
      l_generated = {
        items: 1,
        html: `
<select id="#ID#" name="#ID#" #REQUIRED# class="selectlist apex-item-select" data-native-menu="false" size="1">
`};           
      if(!schema.isRequired) {
        l_generated.html+='<option value=""></option>';
      }
      for(const l_value of schema.enum){
        l_generated.html += apex.util.applyTemplate(`
  <option value="#VALUE#">#DISPLAYVALUE#</option>
`,
                                                {
                                                    placeholders: {
                                                      "VALUE":        apex.util.escapeHTML(''+l_value),
                                                      "DISPLAYVALUE": jsonValue2Display(schema, l_value, newItem),
                                                   }
                                                });
      }
      l_generated.html +=
`
</select>
`;
    break;
    default:
      l_generated = {
        items: 1,
        html: apex.util.applyTemplate(`
<div tabindex="-1" id="#ID#" aria-labelledby="#ID#_LABEL" #REQUIRED# class=" #TYPE#_group apex-item-group apex-item-group--rc apex-item-#TYPE#" role="#TYPE#group">
`,
                                                {
                                                    placeholders: {
                                                      "TYPE":  itemtype
                                                   }
                                                })
      };
      let l_nr=0;
      
      for(const l_value of schema.enum){
        l_generated.html += apex.util.applyTemplate(`
  <div class="apex-item-option" #DIR#>
    <input type="#TYPE#" id="#ID#_#NR#" name="#ID#" data-display="#VALUE#" value="#VALUE#" #PLACEHOLDER# #REQUIRED# aria-label="#VALUE#" class="">
    <label class="u-#TYPE#" for="#ID#_#NR#" aria-hidden="true">#DISPLAYVALUE#</label>
  </div>
`,
                                                {
                                                    placeholders: {
                                                      "DIR":          (schemaApex.direction==C_APEX_HORIZONTAL)?'style="float: left"':"",
                                                      "TYPE":         itemtype,
                                                      "VALUE":        apex.util.escapeHTML(''+l_value),            
                                                      "DISPLAYVALUE": jsonValue2Display(schema, l_value, newItem), 
                                                      "NR":           l_nr++
                                                   }
                                                });
      }

      l_generated.html += `
</div>
`;
    break;
    }
    switch (itemtype){
    case C_APEX_SELECT: 
      l_generated.wrappertype = 'apex-item-wrapper--select-list';
    break;
    case C_APEX_RADIO:
      l_generated.wrappertype = 'apex-item-wrapper--radiogroup';
    break;
    case C_APEX_CHECKBOX:
      l_generated.wrappertype = 'apex-item-wrapper--checkbox';
    break;
    }
    apex.debug.trace("<<jsonRegion.generateForSelect", l_generated);
    return(l_generated);
  }

  function generateForReadOnlyEnum(schema, data){
    let l_generated = {items: 1, wrappertype: 'apex-item-wrapper--text-field', html: ''};
    apex.debug.trace(">>jsonRegion.generateForReadOnlyEnum", schema, data);

    if(typeof schema.apex.enum == 'object' && schema.apex.enum[data]) {
      l_generated.html = '<span id="#ID#_DISPLAY" #REQUIRED# class="display_only apex-item-display-only" data-escape="true">#MAPPEDVALUE#</span>'
      l_generated.html = apex.util.applyTemplate(l_generated.html, { placeholders: {"MAPPEDVALUE": schema.apex.enum[data]}});
    } else {
      l_generated.html = '<span id="#ID#_DISPLAY" #REQUIRED# class="display_only apex-item-display-only" data-escape="true">#VALUE#</span>'
    }

    apex.debug.trace("<<jsonRegion.generateForReadOnlyEnum", l_generated);
    return(l_generated);
  }

  /*
   * generate the UI-item for a string property depending on format, ...
   * returns {items: 0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForString(schema, data){
    let l_generated = {items:0, wrappertype: null, html: ''};
    schema.apex = schema.apex||{};
    schema.apex.enum = schema.apex.enum||{};
    apex.debug.trace(">>jsonRegion.generateForString", schema, data);
    if(schema[C_APEX_READONLY]){
      switch(schema.apex[C_APEX_ITEMTYPE]){
      case C_APEX_IMAGEDISPLAY:
        if(schema.format==C_JSON_FORMAT_URI){  //use url for the image
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: `
<span class="display_only apex-item-display-only">
  <img src="#VALUE#" alt="#VALUE#">
</span>
<input type="hidden" id="#ID#" value="#VALUE#"/>
`};
        } else {  // imagedata is included in JSON
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: `
<span class="display_only apex-item-display-only">
  <img src="data:#IMAGE#;base64,#VALUE#">
</span>
<input type="hidden" id="#ID#" value="#VALUE#"/>
`};
        }
      break;
      case C_APEX_QRCODE:
        l_generated = {
          items: 1,
          wrappertype: 'apex-item-wrapper--qrcode',
          html: `
<a-qrcode id="#ID#" class="a-QRCode" ajax-identifier="#AJAXIDENTIFIER#" value="#VALUE#"> </a-qrcode>
`};
      break;
      default:
        if(schema.enum) {
          l_generated = generateForReadOnlyEnum(schema, data);
        } else {
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: '<span id="#ID#_DISPLAY" #REQUIRED# class="display_only apex-item-display-only" data-escape="true">#VALUE#</span>'
          };
        }
      break;
      }
    } else {
      if(Array.isArray(schema.enum)){
        switch(schema.apex[C_APEX_ITEMTYPE]){
        case C_APEX_SELECTONE:
          l_generated = generateForSelectOneMany(schema, data, C_APEX_SELECTONE, schema.apex);
        break;
        case C_APEX_SELECT:
        case C_APEX_RADIO:
          l_generated = generateForSelect(schema, data, schema.apex[C_APEX_ITEMTYPE], schema.apex);
        break;
        default:
          logSchemaError('enum not supported for', schema.apex[C_APEX_ITEMTYPE]);  
        }
      } else {
        switch(schema.format){
        case C_JSON_FORMAT_IPV4:
        case C_JSON_FORMAT_IPV6:
        case C_JSON_FORMAT_UUID:
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper--text-field',
              html: `
  <input type="text" id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER#  value="#VALUE#" #PATTERN# #TEXTCASE# class="#ALIGN# text_field apex-item-text" size="32" #MINLENGTH# #MAXLENGTH# data-trim-spaces="#TRIMSPACES#" aria-describedby="#ID#_error">
  `};
        break;
        case C_JSON_FORMAT_EMAIL:
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: `
<input type="email" id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER#  value="#VALUE#" #PATTERN# #TEXTCASE# class="#ALIGN# text_field apex-item-text" size="32" #MINLENGTH# #MAXLENGTH# data-trim-spaces="#TRIMSPACES#" aria-describedby="#ID#_error">
`};
        break;
        case C_JSON_FORMAT_URI:
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: `
<input type="url" id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER#  value="#VALUE#" #PATTERN# #TEXTCASE# class="#ALIGN# text_field apex-item-text" size="32" #MINLENGTH# #MAXLENGTH# data-trim-spaces="#TRIMSPACES#" aria-describedby="#ID#_error">
`};
        break;
        case C_JSON_FORMAT_DATE:
          if(pOptions.apex_version >=C_APEX_VERSION_2202){
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper--date-picker-apex apex-item-wrapper--date-picker-apex-popup',
              html: `
<a-date-picker id="#ID#" #REQUIRED# change-month="true" change-year="true" display-as="popup" display-weeks="number"  #MIN# #MAX# previous-next-distance="one-month" show-days-outside-month="visible" show-on="focus" today-button="true" format="#FORMAT#" valid-example="#EXAMPLE#" year-selection-range="5" class="apex-item-datepicker--popup">
  <input aria-haspopup="dialog" class=" apex-item-text apex-item-datepicker" name="#ID#" size="20" maxlength="20" #PLACEHOLDER# type="text" id="#ID#_input" required="" aria-labelledby="#ID#_LABEL" maxlength="255" value="#VALUE#">
  <button aria-haspopup="dialog" aria-label="#INFO#" class="a-Button a-Button--calendar" tabindex="-1" type="button" aria-describedby="#ID#_LABEL" aria-controls="#ID#_input">
    <span class="a-Icon icon-calendar">
    </span>
  </button>
</a-date-picker>
`};
          } else if(pOptions.apex_version >=C_APEX_VERSION_2101){
            l_generated = {
              itmes: 1,
              wrappertype: 'apex-item-wrapper apex-item-wrapper--date-picker-jet',
              html: `
<oj-input-date id="#ID#" #REQUIRED# class="apex-jet-component apex-item-datepicker-jet oj-inputdatetime-date-only oj-component oj-inputdatetime oj-form-control oj-text-field"  #MIN# #MAX# data-format="#FORMAT#"  data-jet-pattern="#FORMAT#" data-maxlength="255" data-name="#ID#" data-oracle-date-value="#VALUE#" data-size="32" data-valid-example="#EXAMPLE#" date-picker.change-month="select" date-picker.change-year="select" date-picker.days-outside-month="visible" date-picker.show-on="focus" date-picker.week-display="none" display-options.converter-hint="none" display-options.messages="none" display-options.validator-hint="none" time-picker.time-increment="00:15:00:00" translations.next-text="Next" translations.prev-text="Previous" value="#VALUE#">
</oj-input-date>
`};
          } else {
            l_generated = {
              itmes: 1,
              wrappertype: 'apex-item-wrapper',
              html: `
  <input type="text" #REQUIRED# aria-describedby="#ID#_format_help" class="datepicker apex-item-text apex-item-datepicker" id="#ID#" name="#ID#" maxlength="255" size="32" value="#VALUE#" autocomplete="off">
  <span class="u-VisuallyHidden" id="#ID#_format_help">Expected format: #FORMAT#</span>
`};
          }
        break;
        case C_JSON_FORMAT_DATETIME:
          if(pOptions.apex_version >=C_APEX_VERSION_2202){
            l_generated = {
              itmes: 1,
              wrappertype: 'apex-item-wrapper--date-picker-apex apex-item-wrapper--date-picker-apex-popup',
              html: `
<a-date-picker id="#ID#" #REQUIRED# change-month="true" change-year="true" display-as="popup" display-weeks="number" #MIN# #MAX# previous-next-distance="one-month" show-days-outside-month="visible" show-on="focus" show-time="true" time-increment-minute="15" today-button="true" format="#FORMAT#" valid-example="#EXAMPLE#" year-selection-range="5" class="apex-item-datepicker--popup">
  <input aria-haspopup="dialog" class=" apex-item-text apex-item-datepicker" name="#ID#" size="30" maxlength="30" #PLACEHOLDER# type="text" id="#ID#_input" required="" aria-labelledby="#ID#_LABEL" maxlength="255" value="#VALUE#">
  <button aria-haspopup="dialog" aria-label="#INFO#" class="a-Button a-Button--calendar" tabindex="-1" type="button" aria-describedby="#ID#_LABEL" aria-controls="#ID#_input">
    <span class="a-Icon icon-calendar-time">
    </span>
  </button>
</a-date-picker>
`};
          } else if(pOptions.apex_version >=C_APEX_VERSION_2101){
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper apex-item-wrapper--date-picker-jet',
              html: `
<oj-input-date-time id="#ID#" #REQUIRED# class="apex-jet-component apex-item-datepicker-jet oj-inputdatetime-date-time oj-component oj-inputdatetime oj-form-control oj-text-field" #MIN# #MAX# data-format="#FORMAT#"  data-jet-pattern="#FORMAT#" data-maxlength="255" data-name="#ID#" data-oracle-date-value="#VALUE#" data-size="32" data-valid-example="#EXAMPLE#" date-picker.change-month="select" date-picker.change-year="select" date-picker.days-outside-month="visible" date-picker.show-on="focus" date-picker.week-display="none" display-options.converter-hint="none" display-options.messages="none" display-options.validator-hint="none" translations.next-text="Next" translations.prev-text="Previous" value="#VALUE#">
</oj-input-date-time>
`};
          } else {
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper apex-item-wrapper--date-picker-jet',
              html: `
  <input type="text" #REQUIRED# aria-describedby="#ID#_format_help" class="datepicker apex-item-text apex-item-datepicker" id="#ID#" name="#ID#" maxlength="255" size="32" value="#VALUE#" autocomplete="off">
  <span class="u-VisuallyHidden" id="#ID#_format_help">Expected format: #FORMAT#</span>
`};
          }
        break;
        case C_JSON_FORMAT_TIME:
          l_generated = {
            items: 1,
            wrappertype: 'apex-item-wrapper--text-field',
            html: `
<input type="time" id="#ID#" name="#ID#" #REQUIRED# #MIN# #MAX# value="#VALUE#" class="text_field apex-item-text"  #PLACEHOLDER# size="5" data-trim-spaces="#TRIMSPACES#" aria-describedby="#ID#_error"/>
`};
        break;
        default:
          l_generated = {
           items: 1,
           wrappertype: 'apex-item-wrapper--text-field',
           html: `
<input type="text" id="#ID#" name="#ID#" #REQUIRED# #MINLENGTH# #MAXLENGTH# value="#VALUE#" #PLACEHOLDER# #PATTERN# #TEXTCASE# class="#ALIGN# text_field apex-item-text" size="32" data-trim-spaces="#TRIMSPACES#" aria-describedby="#ID#_error">
`};
          switch (schema.apex[C_APEX_ITEMTYPE]){
          case C_APEX_COLOR:
            l_generated = {
              items: 1,                
              wrappertype: 'apex-item-wrapper--color-picker',
              html: `
<a-color-picker id="#ID#" name="#ID#" display-as="POPUP" return-value-as="#COLORMODE#" display-mode="FULL" value="#VALUE#"></a-color-picker>
`};
          break;
          case C_APEX_PASSWORD:
            if(pOptions.apex_version <C_APEX_VERSION_2402) {
              l_generated = {
                items: 1,                
                wrappertype: 'apex-item-wrapper--password',
                html: `
<input type="password" name="#ID#" size="30" #PLACEHOLDER# #PATTERN# #REQUIRED# #MINLENGTH# #MAXLENGTH# value="#VALUE#" id="#ID#" class="password apex-item-text apex-item-has-icon">
`}
            } else {
              l_generated = {
                items: 1,                
                wrappertype: 'apex-item-wrapper--password',
                html: `
<div class="apex-item-group apex-item-group--password">
  <input type="password" name="#ID#" size="30" #PLACEHOLDER# #PATTERN# #REQUIRED# #MINLENGTH# #MAXLENGTH# value="#VALUE#" id="#ID#" class="#PASSWORDVISIBILITY# password apex-item-text apex-item-password apex-item-has-icon" data-enter-submit="false">
</div>
`}
            }          break;    
          case C_APEX_RICHTEXT:
            if(pOptions.apex_version >=C_APEX_VERSION_2402) {
              l_generated = {
                items: 1,
                wrappertype: 'apex-item-wrapper--rich-text-editor',
                html: `
<textarea id="#ID#" name="#ID#" #REQUIRED#  style="resize: none; display: none;">#QUOTEVALUE#</textarea>
`};
            } else {
              l_generated = {
                items: 1,
                wrappertype: 'apex-item-wrapper--rich-text-editor',
                html: `
<a-rich-text-editor id="#ID#" name="#ID#" mode="markdown" #REQUIRED# read-only="#READONLY#" display-value-mode="plain-text" visual-mode="inline" value="#QUOTEVALUE#">
</a-rich-text-editor>
`};
            } 
         break;
          case C_APEX_TEXTAREA:
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper--textarea',
              html: `
<div class="apex-item-group apex-item-group--textarea">
  <textarea name="#NAME#" rows="#ROWS#" cols="100" id="#ID#" #REQUIRED# class="textarea apex-item-textarea" data-resizable="true" style="resize: both;">#QUOTEVALUE#</textarea>
</div>
 `};
          break;
          }
        break;
        }
      }
    }
    apex.debug.trace("<<jsonRegion.generateForString", l_generated);
    return(l_generated);
  };

  /*
   * generate the UI-item for a integer/number property depending on format, ...
   * returns {items: 0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForNumeric(schema, data){
    schema.apex = schema.apex||{};
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForNumeric", schema, data);
    if(Array.isArray(schema.enum)){  // numeric Pulldown
      if(schema[C_APEX_READONLY]) {
        l_generated = generateForReadOnlyEnum(schema, data);
      } else {
        l_generated = generateForSelect(schema, data, C_APEX_SELECT, schema.apex);
      }
    } else {
          if(schema.apex[C_APEX_ITEMTYPE]==C_APEX_PCTGRAPH){
            l_generated = {
              items: 1,
              wrappertype: 'apex-item-wrapper--pct-graph',
              html:`
<div class="apex-item-pct-graph" id="#ID#" data-show-value="true"">#VALUE#</div>
`};
          } else if(schema.apex[C_APEX_ITEMTYPE]==C_APEX_STARRATING){
              l_generated = {
                items: 1,
                wrappertype: 'apex-item-wrapper--star-rating',
                html: `
<div id="#ID#" class="a-StarRating apex-item-starrating">
  <div class="a-StarRating" value="#VALUE#">
    <input type="text" aria-labelledby="#ID#_LABEL" id="#ID#_INPUT" value="#VALUE#" name="#ID" class=" u-vh is-focusable" role="spinbutton" aria-valuenow="#VALUE#" aria-valuemax="#MAX#" aria-valuetext="#VALUE#"> 
    <div class="a-StarRating-stars"> 
    </div>
  </div>
</div>
`};
          } else {
            if(schema[C_APEX_READONLY]){
              l_generated = {
                items: 1,
                wrappertype: 'apex-item-wrapper--text-field',
                html: '<span id="#ID#_DISPLAY" #REQUIRED# class="display_only apex-item-display-only" data-escape="true">#VALUE#</span>'};
            } else {
              l_generated = {
                items: 1,
                wrappertype: 'apex-item-wrapper--number-field',
                html: `
<input type="text" id="#ID#" name="#ID#" #REQUIRED# #PLACEHOLDER# value="#VALUE#" class="#ALIGN# number_field apex-item-text apex-item-number" size="30" #MIN# #MAX# data-format="#FORMAT#" inputmode="decimal">
`};
          }
        }
    }
    apex.debug.trace("<<jsonRegion.generateForNumeric", l_generated);
    return(l_generated);
  };


  /*
   * generate the UI-item for a string property depending on itemtype.
   * returns {items: 0, wrappertype: "xxx", html: "xxx"}
  */    
  function generateForUpload(schema, data, id){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    schema.apex = schema.apex||{};
    apex.debug.trace(">>jsonRegion.generateForUpload", schema, data, id);
    l_generated = {
      items: 1,
      wrappertype: schema.apex[C_APEX_ITEMTYPE]==C_APEX_IMAGEUPLOAD?'apex-item-wrapper--image-upload':'apex-item-wrapper--file',
      html: `
<a-file-upload id="#ID#" #REQUIRED# upload-type="#UPLOADTYPE#" display-style="#DISPLAYSTYLE#" accept="#MIMETYPES#" size="30" label="Drop file" description="Select a file or drop one here." max-file-size="#MAXFILESIZE#" filename="#FILENAME#" file-size="#FILESIZE#" mimetype="#MIMETYPE#" show-clear-button="#CLEARBUTTON#" link="#URL#" download-link="#DOWNLOAD#" readonly="#READONLY#">
  <input id="#ID#_input"/>
</a-file-upload>
`};        
    apex.debug.trace("<<jsonRegion.generateForUpload", l_generated);
    return(l_generated);
  };

  /*
   * generate the UI-item for a string property depending on itemtype.
   * returns {items: 0, wrappertype: "xxx", html: "xxx"}
  */    
  function generateForBoolean(schema, data){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    schema.apex = schema.apex||{};
    apex.debug.trace(">>jsonRegion.generateForBoolean", schema, data);
    switch(schema.apex[C_APEX_ITEMTYPE]){
    case C_APEX_SWITCH:
      l_generated = {
        items: 1,
        wrappertype: 'apex-item-wrapper--yes-no',
        html: `
<span class="a-Switch">
  <input type="checkbox" id="#ID#" name="#ID#" value="Y" data-on-label="On" data-off-value="N" data-off-label="Off" placeholder="N">
  <span class="a-Switch-toggle"></span>
</span>
`};  
    break;
    case C_APEX_SELECT:
    case C_APEX_RADIO:
      let l_apex = {...schema.apex};
      l_apex.enum = {N: "No", Y: "Yes"};
      let l_gen = generateForString({type: "string", isRequired: schema.isRequired, enum: ["N", "Y"], id: schema.id, name: schema.name, apex: l_apex}, data);
      l_generated = {
        items: 1,
        wrappertype: (schema.apex[C_APEX_ITEMTYPE]==C_APEX_SELECT)?'apex-item-wrapper--single-checkbox':'apex-item-wrapper--radiogroup',
        html: l_gen.html
      };
    break;
    default:
      l_generated = {
        items: 1,
        wrappertype: 'apex-item-wrapper--single-checkbox',
        html: `
<div class="apex-item-single-checkbox">
  <input type="hidden" name="#ID#" class="" id="#ID#_HIDDENVALUE" value="#BOOLVALUE#">
  <input type="checkbox" #CHECKED# #REQUIRED# id="#ID#" aria-label="#LABEL#" data-unchecked-value="N" value="Y">
  <label for="#ID#" id="#ID#_LABEL" class=" u-checkbox" aria-hidden="true">#LABEL#</label>
</div>
`};    
    }
    apex.debug.trace("<<jsonRegion.generateForBoolean", l_generated);
    return (l_generated);
  }

  /*
   * generate the UI-item for a row in an array, if required with a delete button
   * returns {items: 0, wrappertype: "xxx", html: "xxx"} 
  */  
  function generateForArrayEntry(schema, data, id, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForArrayEntry", schema, data, id, startend, newItem);
    if(schema.type == C_JSON_OBJECT){
      l_generated = generateForItems(schema, data||{}, id, startend, newItem);
    } else {
      l_generated = generateForItem(schema, data, id, startend, newItem, 0, false);
    }
    if(!schema[C_APEX_READONLY] && !schema[C_APEX_WRITEONLY]){
      l_generated.html += generateArrayDeleteButton(id);
    }

          // add End of row
    l_generated.html = apex.util.applyTemplate(`
</div><div id="#ID#_CONTAINER_0" class="row jsonregion">
#HTML#
`,
                                      { 
                                        placeholders: {
                                          "ID":           id,
                                          "HTML":         l_generated.html
                                        }
                                      });


    apex.debug.trace("<<jsonRegion.generateForArrayEntry", l_generated);   
    return(l_generated);
  }


  /*
   * generate the UI-item for an array with enum - use multiple selection IU-items
   * returns {items: 0, wrappertype: "xxx", html: "xxx"} 
  */  
  function generateForMultipleSelect(item, data){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForMultipleSelect", item, data);
    switch(item.apex[C_APEX_ITEMTYPE]){
      case C_APEX_SHUTTLE:
        l_generated = generateForShuttle(item.items, data, item.apex[C_APEX_ITEMTYPE], item.apex);
      break;
      case C_APEX_COMBO:
        l_generated = generateForCombo(item.items, data, item.apex[C_APEX_ITEMTYPE], item.apex);
      break;  
      case C_APEX_SELECTMANY:
        l_generated = generateForSelectOneMany(item.items, data, item.apex[C_APEX_ITEMTYPE], item.apex);
      break;  
      default:
        l_generated =  generateForSelect(item.items, data, C_APEX_CHECKBOX, item.apex);
      break;  
    }
    apex.debug.trace("<<jsonRegion.generateForMultipleSelect", l_generated);   
    return(l_generated);
  }

  /*
    Afer array a Tag is required to connect the remaining itesm to the object for function like hide/show/...
  */
  function generateArrayMarker(id, prevId, itemNr){
    apex.debug.trace(">>jsonRegion.generateArrayMarker", id, prevId, itemNr);
    let l_html = `
        </div>
        <div id="#ID#_END" class="row jsonregion"></div>
        <div id="#PREV_ID#_CONTAINER_#ITEMNR#">
`;
    l_html = apex.util.applyTemplate(l_html, 
                                      { 
                                        placeholders: { "ID":      id,
                                                        "PREV_ID": prevId,
                                                        "ITEMNR":  itemNr}
                                      });
    apex.debug.trace("<<jsonRegion.generateArrayMarker", l_html);
    return(l_html);
  }



  /*
    Afer subopjects a Tag is required to connect the remaining itesm to the object for function like hide/show/...
  */
  function generateObjectMarker(id, prevId, itemNr){
    apex.debug.trace(">>jsonRegion.generateObjectMarker", id, prevId, itemNr);
    let l_html = `
        </div>
        <div id="#PREV_ID#_CONTAINER_#ITEMNR#" class="row jsonregion">
`;
    l_html = apex.util.applyTemplate(l_html, 
                                      { 
                                        placeholders: { "ID":      id,
                                                        "PREV_ID": prevId,
                                                        "ITEMNR":  itemNr}
                                      });
    apex.debug.trace("<<jsonRegion.generateObjectMarker", l_html);
    return(l_html);
  }

  /*
   * generate the UI-item for an array property depending on itemtype.
   * returns {items: 0, wrappertype: "xxx", html: "xxx"} 
  */  
  function generateForArray(schema, data, id, startend, newItem, itemNr){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForArray", schema, data, id, newItem, itemNr);
    let item = schema.items||{};
    data = data || [];
    if(Array.isArray(data)){
      l_generated.html = generateArraySeparator(schema, schema.apex[C_APEX_LABEL], id);
      for(const  i in data) {
        let l_item = {...item};
        l_item.name = i;
        const l_gen = generateForArrayEntry(l_item, data[i], genItemname(id, i), startend, newItem);
        l_generated.html += l_gen.html;
      }
      l_generated.html += generateArrayMarker(id, id.substring(0, id.length-(''+schema.name).length-1), itemNr);
      l_generated.isObject = true;
    } else {
      logDataError('must be an array', schema.name);
    }
    apex.debug.trace("<<jsonRegion.generateForArray", l_generated);   
    return(l_generated);
  }

  /*
   * generate UI for oneOf in schema
   * returns {items:0, wrappertype: "xxx", html: "xxx"} 
  */
  function generateForOneOf(schema, data, prefix, name, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForOneOf", schema, data, prefix, name, startend);
    logSchemaError('"oneOf" is not implemented yet');
    apex.debug.trace("<<jsonRegion.generateForOneOf", l_generated);
    return l_generated;
  }

  /*
   * generate UI for anyOf in schema
   * returns {items:0, wrappertype: "xxx", html: "xxx"} 
  */
  function generateForAnyOf(schema, data, prefix, name, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForAnyOf", schema, data, prefix, name, startend);
    logSchemaError('"anyOf" is not implemented yet');
    apex.debug.trace("<<jsonRegion.generateForAnyOf", l_generated);
    return l_generated;
  }


  /*
   * generate UI for allOf in schema
   * returns {items:0, wrappertype: "xxx", html: "xxx"} 
  */
  function generateForAllOf(allOf, data, prefix, name, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForAllOf", allOf, data, prefix, name, startend, newItem);
    let nr = 0;
    for(const l_schema of allOf){
      if(l_schema.properties){
        let l_gen = generateForItems(l_schema, data, genItemname(name, nr++), startend, newItem);
        l_generated.html += l_gen.html;
        l_generated.items += l_gen.items;
      }
    }

    apex.debug.trace("<<jsonRegion.generateForAllOf", l_generated);
    return l_generated;
  }

  /*
   * generate UI for conditional schema with if/then/else
   * returns {items:0, wrappertype: "xxx", html: "xxx"} 
  */
  function generateForConditional(schema, data, prefix, name, startend, inArray, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForConditional", schema, data, prefix, name, inArray, startend);

    if(Array.isArray(schema.allOf)){
      let nr = 0;
      for(const l_schema of schema.allOf){
        apex.debug.trace('Conditional: allOf', l_schema);
//        let l_gen = generateForConditional(createTempObject(C_JSON_OBJECT, l_schema), data, prefix, genItemname(name, nr++), startend, false, false, newItem);
        let l_gen = generateForItems(createTempObject(C_JSON_OBJECT, l_schema), data, genItemname(name, nr++), startend, newItem)
 
        l_generated.item ++;
        l_generated.html += l_gen.html;
      }
    }

    if(Array.isArray(schema.anyOf)){
      for(const l_condition  of schema.anyOf){
        apex.debug.trace('Conditional: anyOff', l_condition);
      }
    }

    if(Array.isArray(schema.oneOf)){
      for(const l_condition  of schema.oneOf){
        apex.debug.trace('Conditional: oneOf', l_condition);
      }
    }
    
    if(typeof schema.if == 'object'){  // there is a conditional schema
      apex.debug.trace('Conditional: if');
      // UI is generated for THEN and ELSE, set to hidden depending on if-clause
      if(schema.if){
        // xxxxxxx
        if(schema.then && schema.then.properties){
          let l_gen = generateForItems(createTempObject(C_JSON_OBJECT, schema.then), data, genItemname(name, 0), startend, newItem)
          //let l_gen = generateForObject(createTempObject(C_JSON_OBJECT, schema.then), data, prefix, genItemname(name, 0), startend, newItem);
          l_generated.html += l_gen.html;
          l_generated.items += l_gen.items;
        }

        if(schema.else && schema.else.properties){
          let l_gen = generateForItems(createTempObject(C_JSON_OBJECT, schema.else), data, genItemname(name, 1), startend, newItem)
          //let l_gen = generateForObject(createTempObject(C_JSON_OBJECT, schema.else), data, prefix, genItemname(name, 1), startend, newItem);
           l_generated.html += l_gen.html;
          l_generated.items += l_gen.items;
        }
      }
    }
    apex.debug.trace("<<jsonRegion.generateForConditional", l_generated); 
    return(l_generated);
  }

  /*
   * Generate a separator line (new row) in the APEX-UI
   * When a label is given add it to the line
   * The id is required to show/hide the content of the row for conditional schema
   * returns the html 
  */
  function generateSeparator(schema, label, id, isObjectHeader){
    apex.debug.trace(">>jsonRegion.generateSeparator", schema, label, id, isObjectHeader); 
    let l_html ='';
    if(label) {    // Not in array and hasa label, put a line with the text
      l_html += `
</div>
<div id="#ID#_heading" class="row jsonregion">
  <div class="t-Region-header">
    <div class="t-Region-headerItems t-Region-headerItems--title">
      <h2 class="t-Region-title" data-apex-heading="">#LABEL#</h2>
        {if HELP/}
          <button class="t-Form-helpButton js-itemHelp" data-itemhelp="#ITEMID#" helpId="#ID#" title="View help text for #LABEL#." aria-label="View help text for #LABEL#." tabindex="-1" type="button">
            <span class="a-Icon icon-help" aria-hidden="true"></span>
          </button>
        {endif/}
    </div>
  </div>
</div>
<div #DIVID# class="row jsonregion #CSS#" json-property="#JSONPROPERTY#">
 `;
    } else {
      if(isObjectHeader){  // 
        l_html +=`
<div #DIVID# json-property="#JSONPROPERTY#"></div>
`;

      } else {
        l_html +=`
</div>
<div class="row jsonregion" #DIVID#>
`;
      }
    }

    l_html = apex.util.applyTemplate(l_html, 
                                      { 
                                        placeholders: {
                                          "LABEL":        label,
                                          "ID":           id,
                                          "DIVID":        id?'id="'+id+'_CONTAINER_0"':'',
                                          "JSONPROPERTY": schema.name,
                                          "CSS":          (schema.type==C_JSON_OBJECT)?(schema.apex.css||''):'',
                                          "HELP":         pOptions.showhelp?schema.apex[C_APEX_HELP]||'':''
                                        }
                                      });

    apex.debug.trace("<<jsonRegion.generateSeparator", l_html); 
    return(l_html);
  }

  /*
   * Generate a separator line for an array (if required with a "create" button 
   * The id is required to show/hide the content of the row for conditional schema
   * returns the html 
  */
  function generateArraySeparator(schema, label, id){
    apex.debug.trace(">>jsonRegion.generateArraySeparator", schema, label, id); 
    let l_html = '';
    if(pOptions.headers){
      l_html =`
    </div>
<div id="#ID#_CONTAINER_0" class="row jsonregion" json-property="#JSONPROPERTY#">
  <div class="t-Region-header">
    <div class="t-Region-headerItems t-Region-headerItems--title">
      <h2 class="t-Region-title" id="#ID#_heading" data-apex-heading="">#LABEL#</h2>
    </div>
  {if HELP/}
    <button class="t-Form-helpButton js-itemHelp" data-itemhelp="#ITEMID#" helpId="#ID#" title="View help text for #LABEL#." aria-label="View help text for #LABEL#." tabindex="-1" type="button">
       <span class="a-Icon icon-help" aria-hidden="true"></span>
    </button>
  {endif/}
 `;
      if(schema.apex.hasInsert != 'none'){  // 
        l_html += `
    <div class="t-Region-headerItems t-Region-headerItems--buttons">
      <button id="#ID#_CREATE" type="button" class="t-Button t-Button--noLabel t-Button--icon js-ignoreChange lto#ITEMID#_0" title="Create" aria-label="Create">
        <span class="a-Icon icon-ig-add-row" aria-hidden="true"></span>
      </button>
    </div>
  </div>
`;
      } else {
        l_html += `
  </div>
`;
      }
    } else {  // no header, add a dummy diff, for storing the json-property with the propertyname 
      l_html += `
  <div id="#ID#_CONTAINER_0" json-property="#JSONPROPERTY#"></div>
`;
    }

    l_html = apex.util.applyTemplate(l_html, 
                                      { 
                                        placeholders: {
                                          "LABEL":        label,
                                          "ID":           id,
                                          "JSONPROPERTY": schema.name,
                                          "HELP":         pOptions.showhelp?schema.apex[C_APEX_HELP]||'':''
                                        }
                                      });
    apex.debug.trace("<<jsonRegion.generateArraySeparator"); 
    return(l_html);
  }



  function addArrayDeleteEvent(){
    $('button.json_region_del_row').on('click', function(ev){ delArrayRow($(this)[0].id); });
//    $('button.gen_delete_event').removeClass();
  }
   
  function generateArrayDeleteButton(dataitem){
    apex.debug.trace(">>jsonRegion.generateArrayDeleteButton", dataitem); 
    let l_html = `
<div class="t-Region-headerItems t-Region-headerItems--buttons">
  <button id="#ID#_DELETE" type="button" class="json_region_del_row t-Button t-Button--noLabel t-Button--icon js-ignoreChange lto#ITEMID#_0" title="Delete" aria-label="Delete">
    <span class="a-Icon icon-ig-delete" aria-hidden="true"></span>
  </button>
</div>
`;
    l_html = apex.util.applyTemplate(l_html, { placeholders: {"ID": dataitem} } );

    apex.debug.trace("<<jsonRegion.generateArrayDeleteButton"); 
    return l_html;
  }

  /*
   * generate for a taemplate the classes for stacked, floating, rel-col, hidden
   * Returns :{container: 'aaa', label: 'bbb', input: 'ccc'}
   * The classes for the item container, for label and input
  */
  function genTemplate(template, colwidth, schema){
    apex.debug.trace(">>jsonRegion.genTemplate", template, colwidth, schema); 
    let l_ret = {};
    switch(schema.apex.template||template){
    case C_APEX_TEMPLATE_LABEL_HIDDEN:
      l_ret = {
                container: 't-Form-fieldContainer--hiddenLabel rel-col',
                label: 't-Form-fieldContainer--hiddenLabel col col-2',
                input: 'col col-' + Math.max(1, colwidth-2),
                hidden: 'u-VisuallyHidden'
              };  
    break; 
    case C_APEX_TEMPLATE_LABEL_LEFT: 
      l_ret = {
                container: 'rel-col',
                label: 'col col-2',
                input: 'col col-' + Math.max(1, colwidth-2),
                hidden: ''
              };
    break;
    case C_APEX_TEMPLATE_LABEL_ABOVE: 
      l_ret = {
                container: 't-Form-fieldContainer--stacked',
                label: '',
                input: '',
                hidden: ''
              };
    break;
    case C_APEX_TEMPLATE_LABEL_FLOATING: 
    default: 
      l_ret = {
                container: 't-Form-fieldContainer--floatingLabel',
                label: '',
                input: '',
                hidden: ''
              };;
    break;
    }

    apex.debug.trace("<<jsonRegion.genTemplate", l_ret); 
    return l_ret;
  }

  /*
   * generates a quickpick, when configured in "apex": {"quickpicks": {"a": "A", "b": "B", ...}}
  */
  function generateQuickpicks(schema){
    let l_quickpicks = '';
    apex.debug.trace(">>jsonRegion.generateQuickpicks", schema);
    if(pOptions.apex_version >= C_APEX_VERSION_2402){
      if(schema.apex[C_APEX_QUICKPICKS]){
        if([C_JSON_STRING, C_JSON_NUMBER, C_JSON_INTEGER].includes(schema.type)){
          l_quickpicks = `
<span role="group" aria-label="Quick Picks for #LABEL#" class="apex-quick-picks">
`;
          let l_delimiter = '';
          for(const [l_display, l_value] of Object.entries(schema.apex[C_APEX_QUICKPICKS])){
            l_quickpicks += apex.util.applyTemplate(`#DELIMITER#
  <a href="#action$a-set-value?itemName=#ID#&amp;value=#VALUE#&amp;displayValue=#DISPLAYVALUE#" aria-roledescription="action link" aria-controls="#ID#">#DISPLAYVALUE#</a>`, 
              { placeholders: {  
                  "VALUE": apex.util.escapeHTML(''+l_value), 
                  "DISPLAYVALUE": jsonValue2Display(schema, l_value, newItem),
                  "DELIMITER": l_delimiter
                }
              });
            l_delimiter = ', ';
          }
          l_quickpicks += `
</span>`;
        } else {
          apex.debug.error('quickpicks not supported for', schema.name, 'with type', schema.type)  
        }
      }
    }
        // HACK: Theme 42 moves quickpicks to parent, when page is shown, but quickpicks must be below class="t-Form-inputContainer"
    l_quickpicks = '<div>' + l_quickpicks + '</div>';
    apex.debug.trace("<<jsonRegion.generateQuickpicks", l_quickpicks);
    return l_quickpicks;
  }

  /*
   * generate UI for a simple item of types string, int, number, bool 
   * returns {items:0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForItem(item, data, id, startend, newItem, itemNr, withHeader){
    let l_generated = {items: 1, wrappertype: null, html: ''};
    item = item ||{};

    apex.debug.trace(">>jsonRegion.generateForItem", item, data, id, startend, newItem, itemNr, withHeader);

    if((item.name||'').startsWith('_')){   // ignore properties having names starting with "_"
      apex.debug.trace("<<jsonRegion.generateForItem", l_generated);
      return l_generated;
    }

    switch(item.type){
    case C_JSON_ARRAY:
      if( item.items && Array.isArray(item.items.enum)){  // when there is an enum, this array is for multiselection
        if([C_JSON_BOOLEAN, C_JSON_STRING, C_JSON_INTEGER, C_JSON_NUMBER].includes(item.items.type)){
          l_generated = generateForMultipleSelect(item, data);
        } else {
          logSchemaError('"type": "array" simple type string/numeric with enum only', item, data);
        }
      } else {  // loop through the array and generate an object for each row
        l_generated = generateForArray(item, data, id, null, true, itemNr);
      }
    break;
    case C_APEX_UPLOAD:
      l_generated = generateForUpload(item, data, id);
    break;
    case C_JSON_OBJECT:
      l_generated = generateForObject(item, data, '', id, startend, newItem);
    break;
    case C_JSON_STRING:
      l_generated = generateForString(item, data, id);
    break;
    case C_JSON_BOOLEAN:
      l_generated = generateForBoolean(item, data, id);
    break;
    case C_JSON_INTEGER:
    case C_JSON_NUMBER:
      l_generated = generateForNumeric(item, data, id);
    break;
    case C_JSON_NULL:
      l_generated.items = 0;
    break;
    default:
      if(!C_JSON_CONST in item){
        logSchemaError('unknown type:', item.type);
      }
    break;    
    }

        // store helpmessage for item
    if(item.apex[C_APEX_INLINEHELP]|| item.apex[C_APEX_HELP]){
      gHelpMessages[id] = {title: item.apex[C_APEX_LABEL], helpText: item.apex[C_APEX_INLINEHELP]|| item.apex[C_APEX_HELP]}
    }

    if(l_generated.wrappertype){ // input items is generated
      let l_error = '';
      if(pOptions.apex_version>=C_APEX_VERSION_2102) { 
        l_error = `
<div class="t-Form-itemAssistance">
  <span id="#ID#_error_placeholder" class="a-Form-error u-visible" data-template-id="#DATATEMPLATE#"></span>
`
        if(item.isRequired){
          l_error = l_error + `
  <div class="t-Form-itemRequired" aria-hidden="true">Required</div>
`
        }
          l_error = l_error + `
</div>
` 
      } else {
          l_error = `
<span id="#ID#_error_placeholder" class="a-Form-error u-visible" data-template-id="#DATATEMPLATE#"></span>
`;
      }

      const l_value = jsonValue2Item(item, data, newItem)||'';
      const l_template = genTemplate(pOptions.template, pOptions.colwidth, item);
      const l_quickpick = generateQuickpicks(item);
        // console.log(data, schema)
      l_generated = {
          items:       l_generated.items,
          wrappertype: l_generated.wrappertype,
          html:        apex.util.applyTemplate(
`
{if NEWCOLUMN/}
  <div class="col col-#COLWIDTH# apex-col-auto #COLSTARTEND#">
{endif/}
    <div id="#ID#_CONTAINER" class="t-Form-fieldContainer #FIELDTEMPLATE# #ISREQUIRED# #CSS# lto#ITEMID#_0 apex-item-wrapper #WRAPPERTYPE#" json-property="#JSONPROPERTY#">
      <div class="t-Form-labelContainer #LABELTEMPLATE#">
        <label for="#ID#" id="#ID#_LABEL" class="t-Form-label #LABELHIDDEN#">#TOPLABEL#</label>
      </div>
      <div class="t-Form-inputContainer #INPUTTEMPLATE#">
        {if REQUIRED/}
          <div class="t-Form-itemRequired-marker" aria-hidden="true"></div>
        {endif/}
        <div class="t-Form-itemWrapper">
` + l_generated.html +  
` 
        </div>
` + l_quickpick + l_error  + `
        {if INLINEHELP/}
          <span id="#ID#_inline_help">#INLINEHELP#</span>
        {endif/}
        {if HELP/}
          <button class="t-Form-helpButton js-itemHelp" data-itemhelp="#ITEMID#" helpId="#ID#" title="View help text for #LABEL#." aria-label="View help text for #LABEL#." tabindex="-1" type="button">
            <span class="a-Icon icon-help" aria-hidden="true"></span>
          </button>
        {endif/}
      </div>
    </div>
{if NEXTNEWCOLUMN/}
  </div>
{endif/}
`,
                                    { placeholders: {
                                      "APEXVERSION":   pOptions.apex_version,
                                      "WRAPPERTYPE":   l_generated.wrappertype,
                                      "NEWCOLUMN":     item.apex[C_APEX_NEWCOLUMN]?"TRUE":"",
                                      "NEXTNEWCOLUMN": item.apex[C_APEX_NEXTNEWCOLUMN]?"TRUE":"", 
                                      "COLWIDTH":      (item.apex.colSpan?item.apex.colSpan:pOptions.colwidth),
                                      "ROWS":          (item.apex.lines?item.apex.lines:5),
                                      "COLS":          30,
                                      "COLSTARTEND":   startend<0?'col-start':(startend>0?'col-end':''),
                                      "ID":            id, 
                                      "ITEMID":        0,
                                      "NAME":          id,
                                      "LABEL":         item.apex[C_APEX_LABEL],
                                      "TEXTCASE":      item.apex.textcase?'data-text-case="' + (''+ item.apex.textcase).toUpperCase() +'"':'',
                                      "FIELDTEMPLATE": l_template.container,
                                      "LABELTEMPLATE": l_template.label,
                                      "LABELHIDDEN":   l_template.hidden,
                                      "INPUTTEMPLATE": l_template.input,
                                      "CSS":           item.apex.css||'',
                                      "ALIGN":         cAlign[item.apex.align]||'',
                                      "READONLY":      item[C_APEX_READONLY]?"true":"false",
                                      "TRIMSPACES":    'BOTH',
                                      "AJAXIDENTIFIER": pAjaxIdentifier,
                                      "DATATEMPLATE": pOptions.datatemplateET,
                                      "PLACEHOLDER":  item.apex.placeholder?'placeholder="'+item.apex.placeholder+'"':'',
                                      "FORMAT":       item.apex.format||'',
                                      "EXAMPLE":      ([C_JSON_FORMAT_DATE, C_JSON_FORMAT_DATETIME, C_JSON_FORMAT_TIME].includes(item.format)?jsonValue2Item(item, new Date().toISOString(), newItem):''), 
                                      "MINLENGTH":    item.minLength?'minlength=' + item.minLength:'',
                                      "MAXLENGTH":    item.maxLength?'maxlength=' + item.maxLength:'',
                                      "TOPLABEL":     (item.type== C_JSON_BOOLEAN && !([C_APEX_SELECT, C_APEX_RADIO, C_APEX_SWITCH].includes(item.apex[C_APEX_ITEMTYPE])))?"":item.apex[C_APEX_LABEL],
                                      "CHECKED":      item.type== C_JSON_BOOLEAN && (l_value=='Y')?"checked":"",
                                      "BOOLVALUE":    l_value=='Y'?'Y':'N',
                                      "PATTERN":      item.pattern?'pattern="'+item.pattern+'"':"",  
                                      "REQUIRED":     item.isRequired?'required=""':"",
                                      "ISREQUIRED":   item.isRequired?'is-required':"",
                                  //    "REQUIRED":     item.isRequired,
                                      "MIN":          ("minimum" in item)?([C_JSON_FORMAT_DATE, C_JSON_FORMAT_DATETIME, C_JSON_FORMAT_TIME].includes(item.format)?'min':'data-min')+'="'+item.minimum+'"':"",
                                      "MAX":          ("maximum" in item)?([C_JSON_FORMAT_DATE, C_JSON_FORMAT_DATETIME, C_JSON_FORMAT_TIME].includes(item.format)?'max':'data-max')+ '="'+item.maximum+'"':"",
                                      "VALUE":        l_value,
                                      "QUOTEVALUE":   (item.type== C_JSON_STRING)?apex.util.escapeHTML(''+l_value):l_value,
                                      "COLORMODE":    item.apex[C_APEX_COLORMODE]||'HEX',
                                      "IMAGE":        item.apex.image||"",
                                      "JSONPROPERTY": item.name,
                                      "INLINEHELP":   pOptions.showhelp?item.apex[C_APEX_INLINEHELP]||'':'',
                                      "HELP":         pOptions.showhelp?item.apex[C_APEX_HELP]||'':''
                                    }
                                    })
        }
        if(item.type == C_APEX_UPLOAD){
        //console.log('UPLOAD_TEMPLATE:', id, l_value);
        //console.dir(l_generated);
          l_generated.html = apex.util.applyTemplate( l_generated.html, {
            placeholders: {
                "UPLOADTYPE":   item.apex[C_APEX_ITEMTYPE]==C_APEX_FILEUPLOAD?'FILE':'IMAGE',
                "DISPLAYSTYLE": 'DROPZONE_INLINE',
                "CLEARBUTTON":  (item[C_APEX_READONLY] || item.isRequired)?"false":"true",
                "DOWNLOAD":     (l_value && item.apex.download)?"true":"false",
                "MAXFILESIZE":  item.apex.maxFilesize||C_MAX_UPLOADSIZE,
                "MIMETYPES":    item.apex.mimetypes,
                "URL":          l_value?URL.createObjectURL(base64ToBlob(l_value.content||``, l_value.type)):'',
                "FILENAME":     l_value.name||'',
                "MIMETYPE":     l_value.type||'',
                "FILESIZE":     l_value.size||0
        }});
      }
    }

    if(withHeader){  // add optional headers before
      if(item.apex[C_APEX_TEXTBEFORE] || item.apex[C_APEX_NEWROW]) {
        const l_html = generateSeparator(item, item.apex[C_APEX_TEXTBEFORE], id, false, 0);
        l_generated.html = l_html + l_generated.html;
      }
    }


    apex.debug.trace("<<jsonRegion.generateForItem", l_generated);
    return(l_generated);
  }


  /*
   * generate UI for a all items of "properties"
   * returns {items:0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForItems(schema, data, id, startend, newItem){
    schema.apex = schema.apex || {};
    apex.debug.trace(">>jsonRegion.generateForItems", schema, data, id, startend, newItem);
    let l_generated = {items: 0, wrappertype: null, html: ''};
    if([C_APEX_FILEUPLOAD, C_APEX_IMAGEUPLOAD].includes(schema.apex[C_APEX_ITEMTYPE])){ // file-/image-upload are special objects
      l_generated.html += generateForItem(schema, data, genItemname(id, schema.name), startend, newItem, 0, true);
      l_generated.items = 1;
      console.warn('could be removed');
    } else {
      const items = schema.properties ||{};
      let itemNr = 0;
      for(let [l_name, l_item] of Object.entries(items)){
        if(!(''+l_name).startsWith('_')){
          const l_gen = generateForItem(l_item, data[l_name], genItemname(id, l_name), startend, newItem, itemNr++, true);
          l_generated.html += l_gen.html;
          l_generated.items += l_gen.items;
          if(l_gen.isObject){  // HTML for object/array was generated, need class="row"
            l_generated.html += generateObjectMarker(id, id, itemNr);
//            l_generated.html += generateObjectMarker(id, id.substring(0, schema.name?id.length-schema.name.length-1:id), itemNr);
          }
        }
      }
    }
    let l_gen = generateForConditional(schema, data, '', id, startend, false, newItem);
    l_generated.html += l_gen.html;
    l_generated.items += l_gen.items;

/*
    if('allOf' in schema) {
      const l_gen = generateForAllOf(schema.allOf, data, '', id, startend, newItem)
      l_generated.html += l_gen.html;
      l_generated.items += l_gen.items;
    }

    if('anyOf' in schema) {
      const l_gen = generateForAnyOf(schema.anyOf, data, '', id, startend, newItem)
      l_generated.html += l_gen.html;
      l_generated.items += l_gen.items;
    }
      
    if('oneOf' in schema) {
      const l_gen = generateForOneOf(schema.oneOf, data, '', id, startend, newItem)
      l_generated.html += l_gen.html;
      l_generated.items += l_gen.items;
    }
*/
    apex.debug.trace("<<jsonRegion.generateForItems", l_generated);
    return(l_generated);
  }

 
  /* generate the HTML for a column */
  function generateForColumn(schema, data, prefix, name, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForColumn", schema, data, prefix, name, startend, newItem);

    apex.debug.trace("<<jsonRegion.generateForColumn", l_generated);
    return(l_generated);
  }

 
  /* generate the HTML for a row */
  function generateForRow(schema, data, prefix, name, startend, newItem){
    let l_generated = {items: 0, wrappertype: null, html: ''};
    apex.debug.trace(">>jsonRegion.generateForRow", schema, data, prefix, name, startend, newItem);

    apex.debug.trace("<<jsonRegion.generateForRow", l_generated);
    return(l_generated);
  }

  /*
   * generate UI for a schema with type "object", follow nested schemas 
   * returns {items:0, wrappertype: "xxx", html: "xxx"}
  */
  function generateForObject(schema, data, prefix, name, startend, newItem){
    schema.apex = schema.apex ||{};
    let l_generated = {items: 0, wrappertype: null, html: ''};

    apex.debug.trace(">>jsonRegion.generateForObject", schema, data, prefix, name, startend, newItem);

    switch(schema.type){
        case C_JSON_ARRAY:
          if( Array.isArray(schema.items.enum)){  // when there is an enum, this array is for multiselection
            if([C_JSON_BOOLEAN, C_JSON_STRING, C_JSON_INTEGER, C_JSON_NUMBER].includes(schema.items.type)){
              l_generated = generateForMultipleSelect(schema, data);
            } else {
              logSchemaError('"type": "array" simple type string/numeric with enum only', schema, data);
            }
          } else {  // loop through the array and generate an object for each row
            l_generated = generateForArray(schema, data, (prefix?prefix+C_DELIMITER:'')+name, name, startend, true, newItem, 0);
          }
        break;
        case C_JSON_OBJECT: // an object, so generate all of its properties

          data = data ||'{}';
          l_generated.html = generateSeparator(schema, schema.apex[C_APEX_LABEL], name, true);
          let l_gen = generateForItems(schema, data, name, startend, newItem);
          l_generated.html += l_gen.html;
          l_generated.items += l_gen.items;
          l_generated.isObject = true;
        break;
        case C_JSON_STRING:
          l_generated = generateForString(schema, data, startend);
        break;

        case C_JSON_INTEGER:
        case C_JSON_NUMBER:
          l_generated = generateForNumeric(schema, data, startend);
        break;
        case C_JSON_BOOLEAN:
          l_generated = generateForBoolean(schema, data, startend);
        break;
        case undefined:  // no type, so do nothing
          if(!C_JSON_CONST in schema){ // a const doesn't need a type
            logSchemaError('"type" is undefined');
          }
        break
        case 'null':
        break;    
        default:
          logSchemaError('"type": not implemented', schema.type);
        break;
    }
    apex.debug.trace("<<jsonRegion.generateForObject", l_generated);
    return(l_generated);
  }

  /*
   *
  */
  function generateForRegion(schema, data, prefix, name, startend, newItem){
    apex.debug.trace(">>jsonRegion.generateForRegion", schema, data, prefix, name, startend, newItem);
    let l_generated = generateForObject(schema, data, prefix, name, startend, newItem);
    l_generated.html = `
<div id="_CONTAINER_0" class="row jsonregion">
` + l_generated.html + `
</div>`;
    apex.debug.trace("<<jsonRegion.generateForRegion", l_generated);
    return(l_generated);
  }

  /*
   * get a file with an AJAX-request return a promise
  */
  function getFile(type, src) {
    return new Promise(function(resolve, reject) {
      apex.debug.trace('load file (%s): "%s"', type, src);
      const s = document.createElement(cMapType[type].tag);
      let r = false;
      s.type = cMapType[type].type;
      s[cMapType[type].attr] = src + '?v=' + pOptions.apex_full_version;
      s.rel = cMapType[type].rel;
      s.async = false;
      s.onerror = function(err) {
        reject(err, s);
      };

      s.onload = s.onreadystatechange = function() {
        if (!r && (!this.readyState || this.readyState == 'complete')) {
          r = true;
          resolve();
        } else {
          reject(null, s);
        }
      };
      // append script tag to body, so file will be loaded in background
      document.body.appendChild(s);
    });
  }


  /*
   * load all files from list filenames relative to basePath
  */
  function getFiles (filenames, basePath) {
    var l_arr = $.map(filenames, function(file) {
        return getFile( (file.endsWith(".js")?'script':'css'), (basePath||"") + file );
    });
        
    l_arr.push($.Deferred(function( deferred ){
        $( deferred.resolve );
    }));
        
    return $.when.apply($, l_arr);
  }

  // load the oraclejet for date-picker for APEX <=22.1
  function loadRequiredFiles221(itemtypes){
    let l_html ='';
    apex.debug.trace('>>jsonRegion.loadRequiredFiles221', itemtypes);
    if(itemtypes.format.date || itemtypes.format["date-time"]){  //HACK for APEX <22.2, here an old datepicker is used
      l_html += '<script src="' + pOptions.apex_files + 'libraries/apex/minified/jetCommonBundle.min.js"></script>';
      if(pOptions.apex_version>=C_APEX_VERSION_2101 && pOptions.apex_version<=C_APEX_VERSION_2201){ // apex <22.1 has even older datepicker
        l_html += '<link rel="stylesheet" href="' + pOptions.apex_files + 'libraries/oraclejet/' + apex.libVersions.oraclejet + '/css/libs/oj/v' + apex.libVersions.oraclejet + '/redwood/oj-redwood-notag-min.css" type="text/css"/>';
//        l_html += '<script src="' + pOptions.apex_files + 'libraries/apex/minified/jetDatePickerBundle.min.js"></script>';
      }
    }
    apex.debug.trace('<<jsonRegion.loadRequiredFiles221', l_html);
    return l_html;
  }

  /*
   * build a list of all missing files required by used wigets/items like richtxt-editor, ... 
   * Lod the files via ajax
  */
  async function loadRequiredFiles(itemtypes) {
      // get used itemtypes
    apex.debug.trace(">>jsonRegion.loadRequiredFiles", itemtypes);
    let l_scripts = [];

    if(pOptions.apex_version >=C_APEX_VERSION_2301){  // new Features for 23.1 
      if(!customElements.get('a-color-picker')  && itemtypes[C_APEX_ITEMTYPE].color){ // colorpicker is used, so load files for colorpicker
        l_scripts.push('libraries/apex/minified/item.Colorpicker.min.js');
      }
      if(!apex.widget.shuttle  && itemtypes[C_APEX_ITEMTYPE].shuttle){ // shuttle is used, so load files for shuttle
        l_scripts.push('libraries/apex/minified/widget.shuttle.min.js');
      }
    }


    if(pOptions.apex_version >=C_APEX_VERSION_2302){  // new Features for 23.2
      if(!customElements.get('a-combobox')  && itemtypes[C_APEX_ITEMTYPE].combobox){ // combobox is used, so load files for new combobox
        l_scripts.push('libraries/apex/minified/item.Combobox.min.js');
      }
      if(!customElements.get('a-qrcode')  && itemtypes[C_APEX_ITEMTYPE].qrcode){ // combobox is used, so load files for new combobox
        l_scripts.push('libraries/apex/minified/item.QRcode.min.js');
      }

      if(!customElements.get('a-file-upload')  && (itemtypes[C_APEX_ITEMTYPE].fileupload || itemtypes[C_APEX_ITEMTYPE].imageupload)){ // file-/image-upload is used, so load files for fileupload
        l_scripts.push('libraries/apex/minified/item.FileUpload.min.js');
      }

      if(itemtypes[C_APEX_ITEMTYPE].richtext){  // richtext is used, so load files for rich-text-editor
        if(!customElements.get('a-rich-text-editor')){  // Custom Element is not in use, load it

          l_scripts.push('libraries/purify/'  + apex.libVersions.domPurify + '/purify.min.js');
          l_scripts.push('libraries/prismjs/' + apex.libVersions.prismJs + '/prism.js');
          if( pOptions.apex_version >= C_APEX_VERSION_2601){
            l_scripts.push('libraries/markedjs/' + apex.libVersions.markedJs + '/marked.umd.js');
          } else {
            l_scripts.push('libraries/markedjs/' + apex.libVersions.markedJs + '/marked.min.js');
          }
          l_scripts.push('libraries/turndown/' + apex.libVersions.turndown + '/turndown.js');
          if(pOptions.apex_version ==C_APEX_VERSION_2402){  // richtext deitor with widget.rte for 24.2
            l_scripts.push('libraries/ortl/2.0.1/ckeditor5.umd.js');
            l_scripts.push('libraries/ortl/2.0.1/ckeditor5-editor.css');
            l_scripts.push('libraries/ortl/2.0.1/ckeditor5-content.css');
            l_scripts.push('libraries/apex/minified/widget.rte.min.js');
          } else if(pOptions.apex_version >=C_APEX_VERSION_2601){  // richtext deitor with widget.rte for 26.1
            l_scripts.push('libraries/ortl/2607.0.2/ortl.umd.js');
            l_scripts.push('libraries/ortl/2607.0.2/translations/' + apex.locale.getLanguage() + '.umd.js');
            l_scripts.push('libraries/ortl/2607.0.2/ortl-editor.css');
            l_scripts.push('libraries/ortl/2607.0.2/ortl-content.css');
            l_scripts.push('libraries/apex/minified/widget.rte.min.js');
          }else {
            l_scripts.push('libraries/tinymce/' + apex.libVersions.tinymce + '/skins/ui/oxide/skin.css');
            l_scripts.push('libraries/tinymce/' + apex.libVersions.tinymce + '/tinymce.min.js');
            l_scripts.push('libraries/apex/minified/item.RichTextEditor.min.js');
          }
        }
      }
    }

    apex.debug.trace("<<jsonRegion.loadRequiredFiles");
    return getFiles( l_scripts, pOptions.apex_files);
  }

  /*
   * show all in-/output-items for the JSON-region
  */
  function showFields(itemtypes, newItem){
    apex.debug.trace(">>jsonRegion.showFields");
    let l_generated = generateForRegion(pOptions.schema, gData, null, pOptions.dataitem, 0,  newItem);
    let l_html = l_generated.html;
    if(pOptions.apex_version <C_APEX_VERSION_2202){
      l_html += loadRequiredFiles221(itemtypes);
    }
        // attach HTML to region
    $("#"+pRegionId).html(l_html);
    // console.warn(l_html);
    apex.debug.trace("<<jsonRegion.showFields");
  }


  /*
   * refresh the JSON-region
  */
  async function refresh(newItem) {
    apex.debug.trace(">>jsonRegion.refresh");
    apex.debug.trace('jsonRegion.refresh', 'data', newItem, gData);
    let l_itemtypes = null;
    l_itemtypes = getItemtypes(pOptions.schema, l_itemtypes);
    await richtextHack(l_itemtypes);

        // attach the fields to the generated UI
    attachObject(pOptions.dataitem, null, pOptions.schema, pOptions[C_APEX_READONLY], gData, newItem, pOptions.schema, pOptions.dataitem);
    addArrayDeleteEvent();
    apexHacks();
    apex.debug.trace("<<jsonRegion.refresh");
  }

  /*
   * Remove all properties with value NULL to compact the generated JSON
  */
  function removeNulls(data){
    if(data) {
      if(Array.isArray(data)){
        data.forEach(function(value, idx){
          removeNulls(data[idx]); // keep array elements, because position could be meaningfull
        });
      } else if(typeof(data)==C_JSON_OBJECT){
        Object.keys(data).forEach(function(value, idx){
          if(removeNulls(data[value])===null){  // value is null, so remove the whole key
            delete(data[value]);
          }
        });
        if(!Object.keys(data).length){    // Object is empty now, remove it later
          data=null;
        }
      }
    }
    return(data);
  }

  /*
   * convert different data formats in the JSON-data into single formats
  */
  function reformatValues(schema, data, read){
    apex.debug.trace(">>reformatValues", schema); 
    if(schema && data){
      switch(schema.type){
      case "object":
        if(data instanceof Object) {
          for(const l_key in schema.properties){
             data[l_key] = reformatValues(schema.properties[l_key], data[l_key], read);
          }
        } else {
          apex.debug.error('can not display data:', data, 'must be an object');
        }
      break;
      case "array":
        if(Array.isArray(data)){
          for(var i = 0; i < schema.items.length; i++){
             data[i] = reformatValues(schema.items[i], data[i], read);
          }
        } else {
          apex.debug.error('can not display data:', data, 'must be an array');
        }     
      break;
      default:
      break;
      } 

      if(schema.if){  // conditional schema
        if(schema.then && schema.then.properties){ 
          for(const [l_name, l_item] of Object.entries(schema.then.properties)){
            reformatValues(l_item, data[l_name], read);
          }
        }

        if(schema.else && schema.else.properties){ 
          for(const [l_name, l_item] of Object.entries(schema.else.properties)){
            reformatValues(l_item, data[l_name], read);
          }
        }
      }      
    } 
    apex.debug.trace("<<reformatValues", data);   
    return(data);
  }

  /*
   * adjust the schema
  */
  function adjustOptions(options){
    apex.debug.trace(">>adjustOptions", options); 
    options.schema =            options.schema || {};
    if(!options.schema.type){  // type is mandatory, tho array then items exists, else object
      options.schema.type = options.schema.items?C_JSON_ARRAY:C_JSON_OBJECT;
    }
                            // missing type, use existence of properties/items to set it
 //   options.schema.type = options.schema.type || options.schema.items?C_JSON_ARRAY:null;
 //   options.schema.type = options.schema.type || options.schema.properties?C_JSON_OBJECT:null;
    options.schema.properties = options.schema.properties || {};
    options.schema.apex =       options.schema.apex || {};
    options.schema.apex[C_APEX_LABEL] = options.schema.apex[C_APEX_LABEL] || null;
    apex.debug.trace("<<adjustOptions", options); 
    return options;
  }

  /*
    merge to JSON-schema, so that the attributes of parameter staticSchema are preservered
   */
  function mergeSchema(staticSchema, genSchema){
    let l_schema = undefined;
    apex.debug.trace(">>mergeSchema", staticSchema, genSchema);
    if(typeof genSchema == 'object'){
      if(Array.isArray(genSchema)){
        staticSchema = staticSchema || [];
        l_schema = [ ...staticSchema ];
        for (const [idx, entry] of genSchema.entries()) { 
          l_schema[idx] = mergeSchema(staticSchema[idx], entry);
        }
      } else {
        staticSchema = staticSchema || {};
        l_schema = { ...staticSchema };
        for(let [l_name, l_item] of Object.entries(genSchema)){ 
          l_schema[l_name] = mergeSchema(staticSchema[l_name], genSchema[l_name]);
        }
      }
    } else {
      l_schema = staticSchema || genSchema;
    }
    apex.debug.trace("<<mergeSchema", l_schema); 
    return(l_schema);
  }

  function attachPopupHelp(id){
    $(id + ' button.t-Form-helpButton').on('click', function(){
      apex.debug.trace('CLICK HELP', $(this)[0].attributes.helpId);
      const l_helpId = $(this)[0].attributes.helpId.nodeValue;
      let l_help = gHelpMessages[l_helpId];
      apex.theme.popupFieldHelp( l_help||{title: l_helpId, helpText: "Helptext is missing"});
      return false;   
    });
  }


  /* -----------------------------------------------------------------
   * here the function code starts
  */
  apex.debug.trace(">>initJsonRegion", pRegionId, pName, pAjaxIdentifier, pOptions); 

  if(pOptions.hide) { // hide the related JSON-item
    apex.item(pOptions.dataitem).hide();
  }

  try{
    if(pOptions.schemaitem){  // schema is in page item, get it from there
      pOptions.schema = $v(pOptions.schemaitem);
      apex.debug.trace("schema from page item", pOptions.schemaitem, pOptions.schema);
    }
    pOptions.schema = JSON.parse(pOptions.schema||'{}');
  } catch(e) {
    apex.debug.error('json-region: schema', e, pOptions.schema);
    pOptions.schema = {};
  }

  if(pOptions.additionalschema) {
    try{
      pOptions.additionalschema = JSON.parse(pOptions.additionalschema);
    } catch(e) {
      apex.debug.error('json-region: additionalschema', e, pOptions.additionalschema);
      pOptions.additionalschema = {};
    }
  }

    // generate the JSON from dataitem-field
  try {
    const l_data = apex.item(pOptions.dataitem).getValue();
    gData = l_data?JSON.parse(l_data):null;
  } catch(e) {
    apex.debug.error('json-region: dataitem', pOptions.dataitem, e, pOptions.schema);
    gData = null;
  }

  apex.debug.trace('initJsonRegion: data', gData);
  let newItem = !(gData && Object.keys(gData).length);

  if(pOptions.generateSchema){  // generate JSON-schema based on JSON-data
    apex.debug.trace('static-schema', JSON.stringify(pOptions.schema));
    pOptions.schema = generateSchema(pOptions.schema, gData||{});
    console.info('+++JSON-schema+++', JSON.stringify(pOptions.schema));
  }

  if(pOptions.additionalschema){  // have to merge the JSON-schema
    pOptions.schema = mergeSchema(pOptions.additionalschema, pOptions.schema);
  }

  gHelpMessages = {};
  pOptions = adjustOptions(pOptions);

    // resolve all $refs
  pOptions.schema = await propagateRefs(pOptions.schema);
  propagateProperties(pOptions.schema, 0, pOptions[C_APEX_READONLY], false, pOptions.keepAttributes, false, null, pOptions.dataitem, true);
    // adjust differences in 
  gData = reformatValues(pOptions.schema, gData, true);

    // show the UI-fields

  let l_itemtypes = null;
  l_itemtypes = getItemtypes(pOptions.schema, l_itemtypes);

  showFields(l_itemtypes, false); 
  
    // start here all stuff which runs async
  (async function(){
     // do the refresh
    async function doRefresh(){
      apex.debug.trace(">>mergeSchema"); 
      const l_newitem =!(gData && (Object.keys(gData).length>0));

      gHelpMessages = {};
      pOptions = adjustOptions(pOptions);

      pOptions.schema = await propagateRefs(pOptions.schema);
      propagateProperties(pOptions.schema, 0, pOptions[C_APEX_READONLY], false, pOptions.keepAttributes, false, null, pOptions.dataitem, true);
      let l_itemtypes = null;
      l_itemtypes = getItemtypes(pOptions.schema, l_itemtypes);
      apex.debug.trace('pOptions:', pOptions);
      showFields(l_itemtypes, true);
      await loadRequiredFiles(l_itemtypes);
      await richtextHack(l_itemtypes);
      gData = null;
      attachObject(pOptions.dataitem, null, pOptions.schema, pOptions[C_APEX_READONLY], gData, l_newitem, pOptions.schema, pOptions.dataitem);
      await richtextOrtlHack(l_itemtypes);
      addArrayDeleteEvent();
      setObjectValues(pOptions.dataitem, '', pOptions.schema, pOptions[C_APEX_READONLY], gData);
      apexHacks();
      createRegion();
      apex.debug.trace("<<mergeSchema"); 
    }

  /*
   * create the region and attach default handlers
  */
    function createRegion(){
      apex.debug.trace(">>createRegion");
      // if region already exists destroy it first
      if(apex.region.isRegion(pRegionId)) {
        apex.debug.trace('DESTROY REGION', pRegionId);
        apex.region.destroy(pRegionId);
      }
      apex.region.create( pRegionId, callbacks);
      apex.item.attach($('#' + pRegionId));

      attachPopupHelp('#' + pRegionId);
      apex.debug.trace("<<createRegion");   
    }

    apex.debug.trace('required files loading...');
    await loadRequiredFiles(l_itemtypes);
    apex.debug.trace('required files loaded');
    await refresh(newItem);

    const callbacks = {
        // Callback for refreshing the JSON-region, is called by APEX-refresh
      refresh: function() {
        apex.debug.trace('>>jsonRegion.refresh callback: ', pRegionId, pAjaxIdentifier, pOptions, gData);
        if(pOptions.schemaitem){  // get current JSON-schema
          try {
            apex.debug.trace('Refresh JSON-schema from', pOptions.schemaitem);
            let l_schema = $v(pOptions.schemaitem);
            pOptions.schema = JSON.parse(l_schema.length?l_schema:null);
            doRefresh();
            apex.debug.trace('new schema', pOptions.schema);
          } catch(err){
            apex.debug.error('refresh JSON-schema from', pOptions.schemaitem, 'ERROR', err);
          }
        }
        if(pOptions.isDynamic){
           apex.debug.trace('Refresh from AJAX-Callback', pOptions.queryitems);
           apex.server.plugin ( 
            pAjaxIdentifier, 
            { x04: C_AJAX_GETSCHEMA,
              pageItems: pOptions.queryitems
            }
        ) 
        .then(async (schema)=> {  // the callback returns a new JSON-schema
                apex.debug.trace('Refresh from AJAX-Callback OK', schema);
                schema["$defs"]=schema['"$defs"']; // for some reason the $defs property is returned as "$defs"
                pOptions.schema = schema;
                
                doRefresh();
              }  
          )
          .catch((err) =>{
            apex.debug.error('AJAX-Callback read JSON-schema ERROR', err);
          });
        }
        apex.debug.trace('<<jsonRegion.refresh callback')
      },

        // Callback called by event "apexbeforepagesubmit"
      beforeSubmit: function (){
        apex.debug.trace(">>jsonRegion.beforeSubmit", pRegionId, pOptions.dataitem, pOptions.schema);
        if(!pOptions[C_APEX_READONLY]){  // do nothing for readonly json-region
          apex.debug.trace('jsonRegion', pOptions);
          let l_json=getObjectValues(pOptions.dataitem, '', pOptions.schema, null, gData);
          if(pOptions.removeNulls){ 
            l_json = removeNulls(l_json)||{};   // NULL as JSON not allowed for validation
            apex.debug.trace('removed NULLs', l_json);
          }
          apex.debug.trace('generated JSON', l_json);
          apex.item(pOptions.dataitem).setValue(JSON.stringify(l_json));
        }
        apex.debug.trace("<<jsonRegion.beforeSubmit");
      },

        // Callback called by event "apexpagesubmit"
      submit: function(){
        apex.debug.trace(">>jsonRegion.submit");
          // Hack to remove the dynamically generated item from client-response
        $('#' + pRegionId + ' [name]').removeAttr('name');
        apex.debug.trace("<<jsonRegion.submit");
      }
    };

    apex.jQuery(apex.gPageContext$).on( "apexbeforepagesubmit", function() {
      apex.debug.trace('EVENT:', 'apexbeforepagesubmit');
      callbacks.beforeSubmit();
    });
    apex.jQuery( apex.gPageContext$ ).on( "apexpagesubmit", function() {
      apex.debug.trace('EVENT:', 'apexpagesubmit');
      callbacks.submit();
    });
    apex.jQuery( window ).on( "apexbeforerefresh", function() {
      apex.debug.trace('EVENT:', 'apexbeforerefresh');
    });
    apex.jQuery( window ).on( "apexafterrefresh", function() {
      apex.debug.trace('EVENT:', 'apexafterrefresh');
    });

    apex.jQuery( window ).on( "apexreadyend", function( e ) {
      apex.debug.trace('EVENT:', 'apexreadyend');
    });

    apex.jQuery( window ).on( "apexwindowresized", function( event ) {
      apex.debug.trace('EVENT:', 'apexwindowresized');
    });

    $('#' + pRegionId).ready(function() {
      apex.debug.trace('EVENT:', 'JQuery ready');
      setObjectValues(pOptions.dataitem, '', pOptions.schema, pOptions[C_APEX_READONLY], gData);
      apexHacks();
    });
    createRegion();
  })();

  apex.debug.trace("<<initJsonRegion");  
}

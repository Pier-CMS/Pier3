"
A PRWysiwygFileLibrary is a library of javascript that is used to modify the text displayed in the Wysiwyg editory - converting it from HTML to wiki syntax.

"
Class {
	#name : #PRWysiwygFileLibrary,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Wysiwyg'
}

{ #category : #uploaded }
PRWysiwygFileLibrary >> modifiedjqueryui1812redmondCss [
	^ '/*
 * jQuery UI CSS Framework 1.8.12
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Theming/API
 */

/* 
based on Redmond theme - modified by nick.ager@gmail.com
so that preview in Pier Wysiwyg mode doesn''t have 
the Pier site''s css overridden by JQuery UI theme.
*/

/* Layout helpers
----------------------------------*/
.ui-helper-hidden { display: none; }
.ui-helper-hidden-accessible { position: absolute !important; clip: rect(1px 1px 1px 1px); clip: rect(1px,1px,1px,1px); }
.ui-helper-reset { margin: 0; padding: 0; border: 0; outline: 0; line-height: 1.3; text-decoration: none; font-size: 100%; list-style: none; }
.ui-helper-clearfix:after { content: "."; display: block; height: 0; clear: both; visibility: hidden; }
.ui-helper-clearfix { display: inline-block; }
/* required comment for clearfix to work in Opera \*/
* html .ui-helper-clearfix { height:1%; }
.ui-helper-clearfix { display:block; }
/* end clearfix */
.ui-helper-zfix { width: 100%; height: 100%; top: 0; left: 0; position: absolute; opacity: 0; filter:Alpha(Opacity=0); }


/* Interaction Cues
----------------------------------*/
.ui-state-disabled { cursor: default !important; }


/* Icons
----------------------------------*/

/* states and images */
.ui-icon { display: block; text-indent: -99999px; overflow: hidden; background-repeat: no-repeat; }


/* Misc visuals
----------------------------------*/

/* Overlays */
.ui-widget-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }


.ui-widget-header { border: 1px solid gray; background: white  50% 50% repeat-x; color: #ffffff; font-weight: bold; font-size: 11px}
.ui-widget-header a { color: #ffffff; }

/* Interaction states
----------------------------------*/
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { border: 1px solid #c5dbec; background: #dfeffc  50% 50% repeat-x; font-weight: bold; color: white; }
.ui-state-default a, .ui-state-default a:link, .ui-state-default a:visited { color: #2e6e9e; text-decoration: none; }
.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus { border: 1px solid #79b7e7; background: #d0e5f5  50% 50% repeat-x; font-weight: bold; color: #1d5987; }
.ui-state-hover a, .ui-state-hover a:hover { color: gray; text-decoration: none; }
.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active { border: 1px solid #79b7e7; background: white; font-weight: bold; color: #e17009; }
.ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited { color: #e17009; text-decoration: none; }
.ui-widget :active { outline: none; }

/* Interaction Cues
----------------------------------*/
.ui-state-highlight, .ui-widget-content .ui-state-highlight, .ui-widget-header .ui-state-highlight  {border: 1px solid #fad42e; background: #fbec88  50% 50% repeat-x; color: #363636; }
.ui-state-highlight a, .ui-widget-content .ui-state-highlight a,.ui-widget-header .ui-state-highlight a { color: #363636; }
.ui-state-error, .ui-widget-content .ui-state-error, .ui-widget-header .ui-state-error {border: 1px solid #cd0a0a; background: #fef1ec  50% 50% repeat-x; color: #cd0a0a; }
.ui-state-error a, .ui-widget-content .ui-state-error a, .ui-widget-header .ui-state-error a { color: #cd0a0a; }
.ui-state-error-text, .ui-widget-content .ui-state-error-text, .ui-widget-header .ui-state-error-text { color: #cd0a0a; }
.ui-priority-primary, .ui-widget-content .ui-priority-primary, .ui-widget-header .ui-priority-primary { font-weight: bold; }
.ui-priority-secondary, .ui-widget-content .ui-priority-secondary,  .ui-widget-header .ui-priority-secondary { opacity: .7; filter:Alpha(Opacity=70); font-weight: normal; }
.ui-state-disabled, .ui-widget-content .ui-state-disabled, .ui-widget-header .ui-state-disabled { opacity: .35; filter:Alpha(Opacity=35); background-image: none; }



/* Misc visuals
----------------------------------*/

/* Corner radius */
.ui-corner-tl { -moz-border-radius-topleft: 5px; -webkit-border-top-left-radius: 5px; border-top-left-radius: 5px; }
.ui-corner-tr { -moz-border-radius-topright: 5px; -webkit-border-top-right-radius: 5px; border-top-right-radius: 5px; }
.ui-corner-bl { -moz-border-radius-bottomleft: 5px; -webkit-border-bottom-left-radius: 5px; border-bottom-left-radius: 5px; }
.ui-corner-br { -moz-border-radius-bottomright: 5px; -webkit-border-bottom-right-radius: 5px; border-bottom-right-radius: 5px; }
.ui-corner-top { -moz-border-radius-topleft: 5px; -webkit-border-top-left-radius: 5px; border-top-left-radius: 5px; -moz-border-radius-topright: 5px; -webkit-border-top-right-radius: 5px; border-top-right-radius: 5px; }
.ui-corner-bottom { -moz-border-radius-bottomleft: 5px; -webkit-border-bottom-left-radius: 5px; border-bottom-left-radius: 5px; -moz-border-radius-bottomright: 5px; -webkit-border-bottom-right-radius: 5px; border-bottom-right-radius: 5px; }
.ui-corner-right {  -moz-border-radius-topright: 5px; -webkit-border-top-right-radius: 5px; border-top-right-radius: 5px; -moz-border-radius-bottomright: 5px; -webkit-border-bottom-right-radius: 5px; border-bottom-right-radius: 5px; }
.ui-corner-left { -moz-border-radius-topleft: 5px; -webkit-border-top-left-radius: 5px; border-top-left-radius: 5px; -moz-border-radius-bottomleft: 5px; -webkit-border-bottom-left-radius: 5px; border-bottom-left-radius: 5px; }
.ui-corner-all { -moz-border-radius: 5px; -webkit-border-radius: 5px; border-radius: 5px; }

/*
 * jQuery UI Tabs 1.8.12
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Tabs#theming
 */
.ui-tabs { position: relative; padding: .2em; zoom: 1; } /* position: relative prevents IE scroll bug (element with position: relative inside container with overflow: auto appear as "fixed") */
.ui-tabs  {padding-bottom: 0px;}
.ui-tabs .ui-tabs-nav { margin: 0; padding: .2em .2em 0; }
.ui-tabs .ui-tabs-nav li { list-style: none; float: left; position: relative; top: 1px; margin: 0 .2em 1px 0; border-bottom: 0 !important; padding: 0; white-space: nowrap; }
.ui-tabs .ui-tabs-nav li a { float: left; padding: .5em 1em; text-decoration: none; }
.ui-tabs .ui-tabs-nav li.ui-tabs-selected { margin-bottom: 0; padding-bottom: 1px; }
.ui-tabs .ui-tabs-nav li.ui-tabs-selected a, .ui-tabs .ui-tabs-nav li.ui-state-disabled a, .ui-tabs .ui-tabs-nav li.ui-state-processing a { cursor: text; }
.ui-tabs .ui-tabs-nav li a, .ui-tabs.ui-tabs-collapsible .ui-tabs-nav li.ui-tabs-selected a { cursor: pointer; } /* first selector in group seems obsolete, but required to overcome bug in Opera applying cursor: text overall if defined elsewhere... */
.ui-tabs .ui-tabs-panel { display: block; border-width: 0; padding: 0px; padding-top: 0.5em; background: none; }
.ui-tabs .ui-tabs-hide { display: none !important; }

 * jQuery UI Progressbar 1.8.12
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Progressbar#theming
 */
.ui-progressbar { height:2em; text-align: left; }
.ui-progressbar .ui-progressbar-value {margin: -1px; height:100%; }'
]

{ #category : #uploaded }
PRWysiwygFileLibrary >> parseHtmlToPierWikiSyntaxJs [
	"startNode = root node for the parser to start it's translation
	baseUrl = dispatcher location eg '/pier' - if the site serves directly from the root, pass an empty string (used by anchor and image  -> internal link translation)."
	
	^ 'var parseHtmlToPierWikiSyntax = function (startNode, baseUrl) {
	var wikiOutput = [];
	var newLine = "\n"
	var surroundingMarkupArray = [];
	var markupEscapes = [];
	var escapeText = true;
	var listMarkup = [];
	
	var surroundingMarkup = function(markup) {
		if (surroundingMarkupArray.indexOf(markup) == -1) {
			surroundingMarkupArray.push(markup);
		}
		
		return function(node) {
			if (recurseChildNodesToEnsureOnlyInlineElements(node.firstChild)) {
				wikiOutput.push(markup);
				walkTheDOM (node.firstChild);
				wikiOutput.push(markup);
			} else {
				walkTheDOM (node.firstChild);
			}
		}
	}
	
	var startLineMarkup = function(markup) {
		return function(node) {
			// if not at the start of the document
			if (wikiOutput.length) {
				wikiOutput.push(newLine);
			}
			if (markup.length) {
				wikiOutput.push(markup);
			}
			walkTheDOM (node.firstChild);
			wikiOutput.push(newLine);
		}
	}
	
	var paragraphMarkup = function() {
		return function(node) {
			// if not at the start of the document
			if (wikiOutput.length) {
				wikiOutput.push(newLine);
			}
			if (node.className && node.className.indexOf("annotated") != -1) {
				wikiOutput.push("@@");
				wikiOutput.push(node.className.substring(10, node.className.length));
				wikiOutput.push(" ");
			}
			walkTheDOM (node.firstChild);
			wikiOutput.push(newLine);
		}
	}
	
	var parseListType = function (node) {
		var listItemWikiMarkup = ''(unknown list type)'';
		var nodeName = node.nodeName.toLowerCase();

		if (nodeName == ''ul'') {
			listItemWikiMarkup = "-";
		}
		if (nodeName == ''ol'') {
			listItemWikiMarkup = "#";
		}
		if (nodeName == ''dl'') {
			// the dt or dd elements in a definition list define their
			// list element markup so no need to specify a list item 
			// character.
			listItemWikiMarkup = "";
		}
		return listItemWikiMarkup;
	}	
	
	var listWalk = function () {
		return function (node) {

			var startLength = wikiOutput.length;
			
			listMarkup.push(parseListType(node));
			walkTheDOM (node.firstChild);
			listMarkup.pop();
			
			var endLength = wikiOutput.length;

			// remove consecutive new lines. 
			var previousNewLineIndex = -1;
			for (var i = startLength - 1; i < endLength; ++i) {
				if (wikiOutput [i] == newLine) {
					// we have consecutive new lines.
					if (previousNewLineIndex == i - 1) {
						delete wikiOutput [i];
					}
				previousNewLineIndex = i;		
				}
			}
			
			// ensure we finish with a new line
			if (wikiOutput [wikiOutput.length - 1] && wikiOutput [wikiOutput.length - 1] != newLine) {
				wikiOutput.push(newLine);
			}
			
			// ensure there is only a single space between the list markup and the list contents
			for (var i = startLength - 1; i < endLength; ++i) {
				var firstCharacter = wikiOutput [i] && wikiOutput [i].length ? wikiOutput [i] [0]: '''';
				if ((firstCharacter == "#" || firstCharacter == "-" || firstCharacter == ":" || firstCharacter == ";") && (i + 1 < wikiOutput.length)) {
					var listElement = wikiOutput [i + 1];
					var firstNonSpaceIndex = 0;
					while (firstNonSpaceIndex < listElement.length && listElement [firstNonSpaceIndex] == " ") {
						++ firstNonSpaceIndex  ;
					}
					wikiOutput [i + 1] = listElement.substring (firstNonSpaceIndex, listElement.length);
				}
			}		
		}
	}
	
	var listElement = function () {
		return function (node) {
			startLineMarkup(listMarkup.join('''') + '' '')(node);
		}
	}
	
	var imageMarkup = function () {
		return function (node) {
			var filepath = node.getAttribute("src");
			if (filepath.substr(0, 4) === "http") {
				wikiOutput.push(" +");
				wikiOutput.push(filepath);
			} else {
				var lastSlashPosition = filepath.lastIndexOf("/");
				var filename = filepath.substring(lastSlashPosition + 1);
			
				var structureFilepath = (filepath.substring(0, baseUrl.length) == baseUrl) ? filepath.substring(baseUrl.length) : filepath;
				lastSlashPosition =  structureFilepath.lastIndexOf("/");
				wikiOutput.push(" +");
				wikiOutput.push(structureFilepath.substring(0, lastSlashPosition + 1) + filename);
			}

			var style= node.getAttribute("style");
			if (style) {
				if (style[style.length-1] == ";") {
					style = style.substr(0, style.length-1);
				}
				wikiOutput.push("|style=" + style);
			}

			var align = node.getAttribute("align");
			if (align) {
				wikiOutput.push("|align=" + align.split(" ").join(""));
			}
			wikiOutput.push("+ ");

		}
	}
	
	var preMarkup = function () {
		return function (node) {
			var isCode = true;
			escapeText = false;

			var markup = "= ";
			
			wikiOutput.push(markup);
			var startLength = wikiOutput.length;
			walkTheDOM (node.firstChild);
			var endLength = wikiOutput.length;
			// replace all new lines in text new-line and start of pre-markup
			for (var i = startLength; i < endLength; ++i) {
				wikiOutput [i] = wikiOutput [i].replace(new RegExp(newLine, "g"), newLine+markup);
			}
			wikiOutput.push(newLine);	
				
			if (isCode) {
				escapeText = true;
			}	
		}
	}
	
	var tableMarkup = function () {
		return function (node) {
			walkTheDOM (node.firstChild)
		}
	}
	
	var tableRowMarkup = function () {
		return function (node) {
			wikiOutput.push(newLine);
			walkTheDOM (node.firstChild)
		}
	}
	
	var tableCellMarkup = function (markup) {
		return function(node) {
			var cellMarkup = markup;
			if (node.getAttribute(''style'')) {
				var style = node.getAttribute(''style'');
				if (/text-align:\s*left/i.test(style)) {
					cellMarkup += ''{''
				}
				if (/text-align:\s*right/i.test(style)) {
					cellMarkup += ''}''
				}
				if (/text-align:\s*center/i.test(style)) {
					cellMarkup += ''|''
				}
			}
			wikiOutput.push(cellMarkup);
			walkTheDOM (node.firstChild);	
		}
	}
	
	var anchor = function() {
		return function(node) {
			if(node.getAttribute("href")) {
				var hostUrl = window.location.host;
				var anchorUrl = decodeURIComponent(node.getAttribute("href"));
				if (anchorUrl.substr(0, 4) !== "http") {
					anchorUrl = anchorUrl.split("?")[0];
				}
				var url = (anchorUrl.indexOf(hostUrl) == 0) ? anchorUrl.substr(hostUrl.length) : anchorUrl;
				if (url.indexOf(baseUrl) == 0) {
					url = url.substr(baseUrl.length);
					if (url.length == 0) {
						url = "\/";
					}
				}
				
				if (url.indexOf("mailto:") == 0) {
					url = url.substr("mailto:".length); 
				} else {
					if (url.substr(0, 4) !== "http") {
						/* Replace # with @ if it is the last word and if it is a non-external link */
						url = url.replace("#","@");
					}
				}

				wikiOutput.push("*");
				var startLength = wikiOutput.length;
				walkTheDOM(node.firstChild);
				wikiOutput.push(">");
				wikiOutput.push(url);
				wikiOutput.push("*");
				
				// if the url is the same as the caption, we dont need the caption
				if (wikiOutput.length == startLength + 4 && wikiOutput [startLength] == url) {
					delete wikiOutput [startLength];
					delete wikiOutput [startLength + 1];
				}
			}
			if (node.getAttribute("name")) {
				wikiOutput.push("@");
				wikiOutput.push(node.getAttribute("name"));
			}
		}
	}
	
	var spanMarkup = function() {
		return function(node) {
			if (node.className && node.className.indexOf("pierNonEditable") != -1) {
				escapeText = false;
				walkTheDOM (node.firstChild);
				escapeText = true;
			}
			else {
				walkTheDOM (node.firstChild);
			}
		}
	}

	var lineBreak = function() {
		return function(node) {
			wikiOutput.push(newLine);
		}
	}
	
	var handleText = function(node) {
		var escapeMarkup = function(text) {
			var initialiseMarkupEscapes = function () {
				var escapedMarkup = function (original) {
					var theEscapedMarkup = [];
					for (var i = 0; i < original.length; ++i) {
						theEscapedMarkup.push("\\");
						theEscapedMarkup.push(original[i]);
					}
					return theEscapedMarkup.join("");
				}
		
				for (var i = 0; i < surroundingMarkupArray.length; ++i) {
					markupEscapes.push({markup: surroundingMarkupArray[i], replacement: escapedMarkup (surroundingMarkupArray[i])})
				}	
				markupEscapes.push({markup: "*", replacement: "\\*"});
				markupEscapes.push({markup: "+", replacement: "\\+"});
			}
	
			if (markupEscapes.length == 0) {
				initialiseMarkupEscapes();
			}
			
			for (var i = 0; i < markupEscapes.length; ++i) {
				text = text.split(markupEscapes[i].markup).join(markupEscapes[i].replacement);		
			}
			return text;
		}	
	
		var text = node.nodeValue;

		// if the string starts with a newLine strip it.
		if (text.length && text [0] == newLine) {
			text = text.substr(1, text.length - 1); 
		}		
		
		// if the string ends with a newLine strip it.
		if (text.length && text [text.length - 1] == newLine) {
			text = text.substr(0, text.length - 1); 
		}
		
		if (escapeText) {
			text = escapeMarkup(text);
		}
		
		wikiOutput.push(text);
	}
	
	var elementToWikiMarkupMappingTable = {
		''b'': surroundingMarkup(''\"\"''),
		''strong'': surroundingMarkup(''\"\"''),
		''i'': surroundingMarkup("\''\''"),
		''em'': surroundingMarkup("\''\''"),
		''ins'': surroundingMarkup("__"),
		''u'': surroundingMarkup("__"),
		"del": surroundingMarkup("--"),
		''code'': surroundingMarkup("=="),
		''sub'': surroundingMarkup("@@"),
		''sup'': surroundingMarkup("^^"),
		"span": spanMarkup(),
		"div": startLineMarkup(''''),
		''a'': anchor(),
		''h1'': startLineMarkup (''!''),
		''h2'': startLineMarkup(''!!''), 
		''h3'': startLineMarkup(''!!!''),
		''h4'': startLineMarkup(''!!!!''), 
		''h5'': startLineMarkup(''!!!!!''), 
		''h6'': startLineMarkup(''!!!!!!''),
		''hr'': startLineMarkup(''_''),
		"br": lineBreak(),
		"p": paragraphMarkup(),
		"ul": listWalk(),
		"ol": listWalk(),	
		"dl": listWalk(),	
		''li'': listElement(),	
		''dt'': startLineMarkup('';''),
		''dd'': startLineMarkup('':''),
		''pre'': preMarkup(),
		''table'': tableMarkup(),
		''thead'': tableMarkup(),
		''tbody'': tableMarkup(),
		''tfoot'': tableMarkup(),
		''thead'': tableMarkup(),
		"tr": tableRowMarkup(),
		"td": tableCellMarkup("|"),
		"th": tableCellMarkup("|!"),		
		"img": imageMarkup()
	}

	// ensure we dont have lists inside other surrounding elements - Safari editing seems to cause this problem	
	var recurseChildNodesToEnsureOnlyInlineElements = function (node) {	
		if (node === null)
			return true;	

            if  (node.nodeType == nodeTypes.ELEMENT_NODE) {
			var nodeName = node.nodeName.toLowerCase();
			if (elementToWikiMarkupMappingTable.hasOwnProperty (nodeName)) {
				var functionToCall = elementToWikiMarkupMappingTable [nodeName];
				// arbitarily choose "b" as a surrounding element; but in fact we are checking that 
				// node is not any surrounding element markup
				if (functionToCall != elementToWikiMarkupMappingTable["b"] && functionToCall != anchor()) {
					return false;
				}
				else {
					if (! recurseChildNodesToEnsureOnlyInlineElements(node.firstChild)) {
						return false;
					}
				}
			}
		}
		return recurseChildNodesToEnsureOnlyInlineElements (node.nextSibling);
	}


    var nodeTypes = {
        ELEMENT_NODE: 1,
        ATTRIBUTE_NODE: 2,
        TEXT_NODE: 3,
        CDATA_SECTION_NODE: 4,
        ENTITY_REFERENCE_NODE: 5,
        ENTITY_NODE: 6,
        PROCESSING_INSTRUCTION_NODE: 7,
        COMMENT_NODE: 8,
        DOCUMENT_NODE: 9,
        DOCUMENT_TYPE_NODE: 10,
        DOCUMENT_FRAGMENT_NODE: 11,
        NOTATION_NODE: 12
    }
	
	// the recursive DOM walker
    var walkTheDOM = function (node) {
		if (node === null)
			return ;
			
		switch (node.nodeType) {
            case nodeTypes.ELEMENT_NODE:
			var nodeName = node.nodeName.toLowerCase();
			if (elementToWikiMarkupMappingTable.hasOwnProperty (nodeName)) {
				elementToWikiMarkupMappingTable [nodeName](node);
			}
			break;
                
            case nodeTypes.TEXT_NODE:
			handleText(node);
			break; 
                
            case nodeTypes.ATTRIBUTE_NODE:
            case nodeTypes.CDATA_SECTION_NODE:
            case nodeTypes.ENTITY_REFERENCE_NODE:
            case nodeTypes.ENTITY_NODE:
            case nodeTypes.PROCESSING_INSTRUCTION_NODE:
            case nodeTypes.COMMENT_NODE:
            case nodeTypes.DOCUMENT_NODE:
            case nodeTypes.DOCUMENT_TYPE_NODE:
            case nodeTypes.DOCUMENT_FRAGMENT_NODE:
            case nodeTypes.NOTATION_NODE:
                break;
			}

		walkTheDOM (node.nextSibling);
    }
    walkTheDOM (startNode.firstChild);
	
	return wikiOutput.join('''');
}'
]

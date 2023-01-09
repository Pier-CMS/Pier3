"
Base for Wywsiwyg editors using Pier's PRDocument syntax. 
See PRWysiwygEditorExample & PRWysiwygComponent as examples which use this class.
"
Class {
	#name : #PRWysiwygEditor,
	#superclass : #WAComponent,
	#instVars : [
		'tabs',
		'siteMapSelectCallback',
		'tabId',
		'configuration',
		'wikiText',
		'textId',
		'previewId',
		'structureOwner',
		'onFormSubmitCallback'
	],
	#category : #'Pier-Wysiwyg'
}

{ #category : #accessing }
PRWysiwygEditor >> configuration [
	^ configuration ifNil: [ configuration := PRWysiwygEditorConfiguration new ]
]

{ #category : #rendering }
PRWysiwygEditor >> defineElementIds: html [
	self previewId: html nextId.
	self tabId: html nextId.
	self textId ifNil: [ self textId: html nextId ]
]

{ #category : #private }
PRWysiwygEditor >> document [
	| document |
	"When there is a page that contains ${tag} this will raise a walkback, catching the exception does not actually run, it just is a work-around to present a 'Contents: Invalid input given' error. A real fix means replacing YUI with a supported editor"
	document := [ PRPillarParserMain documentParser parse: self wikiText ]
		on: PRSyntaxError
		do: [ :ex | self documentManagedFor: ex ].
	self structureOwner notNil
		ifTrue: [ document owner: self structureOwner ].
	^ document
]

{ #category : #private }
PRWysiwygEditor >> documentManagedFor: exception [
	| problemTag newWikiText |
	('Pillar doesn''t support this tag : ''*}*'
		match: exception messageText)
		ifTrue: [ problemTag := exception messageText
				withoutPrefix: 'Pillar doesn''t support this tag : '''.
			problemTag := problemTag copyFrom: 1 to: (problemTag indexOf: $}).
			newWikiText := self wikiText
				copyReplaceAll: '${' , problemTag
				with: '\${' , problemTag.
			^ PRPillarParserMain documentParser parse: newWikiText ]
		ifFalse: [ exception raise ]
]

{ #category : #rendering }
PRWysiwygEditor >> editorJs [ 
	"see: 
		* http://developer.yahoo.com/yui/editor/
		* http://developer.yahoo.com/yui/examples/editor/toolbar_editor.html
		* http://developer.yahoo.com/yui/docs/editor.js.html

		* http://developer.yahoo.com/yui/examples/editor/cal_editor.html
		* http://developer.yahoo.com/yui/examples/editor/flickr_editor.html"
	 
^ 'pierWysiwygEditor = new YAHOO.widget.Editor("', self textId, '", {
	height: "300px",
	width: "', self editorWidth, '",
	autoHeight: true,
	allowNoEdit: true,
	extracss: ".pierNonEditable { border: 1px dashed; display:inline-block;} .broken {color: #8A1F11;}', self configuration editorCss, '",
	toolbar: {
		focusAtStart: true,
		buttons: [ 
	    		{ group: "parastyle", label: "",
				buttons: [
					{ type: "select", label: "Normal", value: "heading", disabled: true,
						menu: [
							{ text: "Normal", value: "none", checked: true },
							{ text: "Header 1", value: "h1" },
							{ text: "Header 2", value: "h2" },
							{ text: "Header 3", value: "h3" },
							{ text: "Header 4", value: "h4" },
							{ text: "Header 5", value: "h5" },
							{ text: "Header 6", value: "h6" }
						]
					}
				]
			},
			{ type: "separator" },
			{ group: "indentlist", label: "",
			    buttons: [
			        { type: "push", label: "Create an Unordered List", value: "insertunorderedlist" },
			        { type: "push", label: "Create an Ordered List", value: "insertorderedlist" }
			    ]
			},
			{ type: "separator" },
			{ group: "textstyle" , label: "",
				buttons: [
            			{ type: "push", label: "Bold CTRL + SHIFT + B",  value: "bold" }, 
					{ type: "push", label: "Italic CTRL + SHIFT + I", value: "italic" }, 
					{ type: "push", label: "Underline CTRL + SHIFT + U", value: "underline" },
					{ type: "push", label: "Code", value: "code" },
					{ type: "push", label: "Strikeout", value: "strike" },
					{ type: "separator" },
					{ type: "push", label: "Subscript", value: "subscript", disabled: true },
					{ type: "push", label: "Superscript", value: "superscript", disabled: true },
				 ]
			 },
	    		{ type: "separator" },
			{ group: "insertitem", label: "",
			    buttons: [
				{ type: "push", label: "Horizontal Rule", value: "rule" },
			        { type: "push", label: "HTML Link CTRL + SHIFT + L", value: "createlink", disabled: true },
			        { type: "push", label: "Insert Image", value: "insertimage" }
			    ]
			}
		]
	}
} );

pierWysiwygEditor._renderCreateLinkWindow = function() {
var Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event,
    Lang = YAHOO.lang;

	var str = "<label for=''" + this.get("id") + "_createlink_url''><strong>" + this.STR_LINK_URL + ":</strong> <input type=''text'' name=''" + this.get("id") + "_createlink_url'' id=''" + this.get("id") + "_createlink_url'' value=''''></label>";
	str += ', self siteMapSelectHtml, ';
	str += "<label for=''" + this.get("id") + "_createlink_target''><strong>&nbsp;</strong><input type=''checkbox'' name=''" + this.get("id") + "_createlink_target'' id=''" + this.get("id") + "_createlink_target'' value=''_blank'' class=''createlink_target''> " + this.STR_LINK_NEW_WINDOW + "</label>";
	str += "<label for=''" + this.get("id") + "_createlink_title''><strong>" + this.STR_LINK_TITLE + ":</strong> <input type=''text'' name=''" + this.get("id") + "_createlink_title'' id=''" + this.get("id") + "_createlink_title'' value=''''></label>";

	var body = document.createElement("div");
	body.innerHTML = str;

	var unlinkCont = document.createElement("div");
	unlinkCont.className = "removeLink";
	var unlink = document.createElement("a");
	unlink.href = "#";
	unlink.innerHTML = this.STR_LINK_PROP_REMOVE;
	unlink.title = this.STR_LINK_PROP_REMOVE;
	Event.on(unlink, "click", function(ev) {
		Event.stopEvent(ev);
		this.unsubscribeAll("afterExecCommand");
		this.execCommand("unlink");
		this.closeWindow();
	}, this, true);
	unlinkCont.appendChild(unlink);
	body.appendChild(unlinkCont);

	this._windows.createlink = {};
	this._windows.createlink.body = body;
	//body.style.display = "none";
	Event.on(body, "keyup", function(e) {
		Event.stopPropagation(e);
	});
	this.get("panel").editor_form.appendChild(body);
	this.fireEvent("windowCreateLinkRender", { type: "windowCreateLinkRender", panel: this.get("panel"), body: body });
	
	$("#', self selectId, '").bind("change", function() {
		$("#', self textId, '_createlink_url").val($(this).val());
	});	
	return body;
}

pierWysiwygEditor.cmd_code = function (o) {
	this.execCommand("inserthtml", "<code>" + this._getSelection() + "</code>");
}
pierWysiwygEditor.cmd_rule = function (o) {
	this.execCommand("inserthtml", "<hr>");
}
pierWysiwygEditor.cmd_strike = function (o) {
	this.execCommand("inserthtml", "<del>" + this._getSelection() + "</del>");
} ', 
self configuration editorExtraJS, 
'

pierWysiwygEditor.render();',
"below is needed when the Wywsiwyg editor is loaded via Ajax"
'YAHOO.util.Event._load();'

"	
{ group: ''formatting'' , label: ''Formatting'',
  buttons: [
	{ type: ''separator'' },
	{ type: ''push'', label: ''Remove Formatting'', value: ''removeformat'', disabled: true },
	{ type: ''push'', label: ''Show/Hide Hidden Elements'', value: ''hiddenelements'' }
   ]
}
"

]

{ #category : #constants }
PRWysiwygEditor >> editorWidth [
	^ '100%'
]

{ #category : #updating }
PRWysiwygEditor >> jQueryTabsCustomisationUpdateRoot: anHtmlRoot [
		anHtmlRoot stylesheet add:  '
.ui-tabs-nav a:hover, .yui-toolbar-container a:hover {
	background:transparent;
}
'
]

{ #category : #callbacks }
PRWysiwygEditor >> onFormSubmit [
	^ onFormSubmitCallback
]

{ #category : #callbacks }
PRWysiwygEditor >> onFormSubmit: anObject [
	onFormSubmitCallback := anObject
]

{ #category : #rendering }
PRWysiwygEditor >> onSelectTabJSOn: html [
	| baseUrl |
	
	baseUrl := html application url.
	
	^ ((JSStream on: 
'if (ui.index == 0) {
	pierWysiwygEditor.setEditorHTML("<h1>loading...</h1>")'),
	(html jQuery ajax script: [ :s | 
		s << self renderSetEditorHtmlContentJS]; serialize: (html jQuery id: #wikiEditor)),
	(JSStream on: '}	
if (ui.index == 1 && ($("#', self tabId, '").tabs("option", "selected") == 0)) {
	pierWysiwygEditor.setEditorHTML(pierWysiwygEditor.cleanHTML())'),
	((html jQuery id: #wikiEditor) 
		value: (JSStream on: 
			'parseHtmlToPierWikiSyntax(pierWysiwygEditor._getDoc().body, "', 
				baseUrl greaseString, '")')),
	(JSStream on: '}',

"The pier wiki editor toolbar 'EditorEnh' is loaded on window.onload event. If the editor is loaded via Ajax 
the window.onload isn't fired. Test to see if the toolbar is present, if not add it."
'if (ui.index == 1 && ($(''#wikiEditor'').prev().length==0)) {
	new EditorEnh($(''#wikiEditor'')[0], { binding: true, toolbar: true});
}
if (ui.index == 2) {
	if ($("#', self tabId, '").tabs("option", "selected") == 0) {
		$("#wikiEditor").val(parseHtmlToPierWikiSyntax(pierWysiwygEditor._getDoc().body,"',
			baseUrl greaseString, '"))}
	$("#', self textId, '").val($("#wikiEditor").val());'),
	((html jQuery id: self previewId) append: [ :r | 
		r div 
			class: 'ui-widget-overlay';
			with: [
				r div
					style: 'position:absolute; top:40%; left:30%';
					with: [
						r heading
							level1;
							style: 'background:black; color:white; padding:20px;';
							with: 'loading...' ] ] ]),
	(html jQuery ajax script: [ :s |
		s << (s jQuery id: self previewId) 
			replaceWith: [ :r | 
				self renderPreviewOn: r ] ]; 
			serialize: (html jQuery id: #wikiEditor)),
	(JSStream on:
'}')) asFunction: #('event' 'ui')
]

{ #category : #'accessing ids' }
PRWysiwygEditor >> previewId [
	^ previewId
]

{ #category : #'accessing ids' }
PRWysiwygEditor >> previewId: anObject [
	^ previewId := anObject
]

{ #category : #rendering }
PRWysiwygEditor >> renderContentOn: html [
	self defineElementIds: html.
	html div 
		class: 'yui-skin-sam';
		with: [
			(self configuration allowWikiTextEditing and: [ self configuration allowWikiTextEditing ]) 
				ifTrue: [ self renderTabsOn: html ]
				ifFalse: [
					self configuration allowWikiTextEditing ifTrue: [ self renderWikiEditorOn: html ].
					self configuration allowWysiwygEditing ifTrue: [ self renderWysiwygEditorOn: html ] ] ].
	
	"a javascript hack to ensure that the editor occupies as much space as possible and the width doesn't alter 
	as the views are changed between tabs"		
	html document addLoadScript: 
		((html jQuery: '.yui-skin-sam') parent cssAt: 'width' put: '100%')
]

{ #category : #rendering }
PRWysiwygEditor >> renderPreviewOn: html [
	html div
		id: self previewId;
		style: 'height: 300px; width: ', self editorWidth;
		with: [	
			| renderer |
			renderer := PRViewRenderer new.
			renderer withinContentDo: [ 
				renderer start: self document in: self on: html ] ]
]

{ #category : #rendering }
PRWysiwygEditor >> renderSetEditorHtmlContentJS [
	| renderer wysiwygHtml jsStream |
		
	renderer := PRWysiwygEditorRenderer new.
	wysiwygHtml := WAHtmlCanvas builder	
		render: [ :r | 
			renderer withinContentDo: [ 
				renderer start: self document in: self on: r ] ].

	jsStream := JSStream new.
	jsStream nextPutAll: 'pierWysiwygEditor.setEditorHTML('.
	JSStream encodeString: wysiwygHtml on: jsStream stream.
	jsStream nextPutAll: ')'.
		
	^ jsStream
]

{ #category : #rendering }
PRWysiwygEditor >> renderTabsOn: html [
	html div
		id: self tabId;
		script: (html jQuery this tabs
			onActivate: (self onSelectTabJSOn: html));
		with: [
			html unorderedList: [
				self tabs do: [ :each | | id |
					id := html nextId.
					(each value) at: #id put: id.
					html listItem: [
						html anchor
							url: '#', id;
							with: each key ] ] ].
			self tabs do: [ :each | 
				html div
					id: ((each value) at: #id);
					with: [ ((each value) at: #renderer) value: html ] ] ]

]

{ #category : #rendering }
PRWysiwygEditor >> renderWikiEditorOn: html [
	"the standard pier editor toolbar 'EditorEnh' expects the textarea to be wrapped in a td - yuk"
	html table
		cellpadding: 0;
		cellspacing: 0;
		style: 'margin-bottom:0px;';
		with: [
			html tableRow: [
				html tableData
					class: 'wiki';
					with: [
						html textArea
							id: #wikiEditor;
							on: #wikiText of: self ] ] ]
]

{ #category : #rendering }
PRWysiwygEditor >> renderWysiwygEditorOn: html [
	| baseUrl |

	"extra div is necessary to avoid Pier's 'enhanced' editor script adding it's toolbar (when there are no tabs)"
	html div with: [
		html textArea
			id: self textId;
			callback: [ :value | self wikiText: value ];
			with: [ html heading level1; with: 'loading...' ] ].
		
	"note we could set the html directly in the text area above (instead of 'loading...') - however subsequently we use 
	pierWysiwygEditor.setEditorHTML('xxxxxx') generated by #setEditorHtmlContentJS and the editor interprets
	 the html subtly differently depending on it's origin - this was a particular problem with the rendering of the 
	verbatim output. 
	So instead we choose to set the editor's html using the same method initially as used on subsequent calls.
	
	We can't call pierWysiwygEditor.setEditorHTML('html here') directly - first, we have to wait for the editor to 
	load - so we hook into the 'editorContentLoaded' event "
	
	"global reference to the editor"
	html script: 'var pierWysiwygEditor=null;'.
	
	html script: (
		(
			(JSStream on: self editorJs),
			(JSStream on:  'pierWysiwygEditor.on("editorContentLoaded", function () {') , 
			(self renderSetEditorHtmlContentJS) , 
			(JSStream on: 'this.removeListener("editorContentLoaded", arguments.callee)}, null, null);')) 
		asFunction assignLocalTo: 'initialiseWysiwygEditor').

	"when the editor is loaded dynamically by pieradmin the scripts are loaded in an indeterminant order; here we retry
	until the YAHOO editor scripts are loaded. Retry 20 times then give up."
	html script: '$(
			(function (retryCount) {
				if (window.YAHOO) {
					initialiseWysiwygEditor();
				} else {
					if (retryCount > 0) {
						var callee = arguments.callee;
						window.setTimeout(function(){callee(retryCount - 1)}, 100);
					}
				}
			})(20))'.
			
	"ensure that we convert the html in the editor into wiki text and copy back into the text 
	area before the form is submitted.
	if both editors are rendered, we ensure that we receives updates from the visible view"
	baseUrl := html application url.
	self configuration allowWikiTextEditing 
		ifTrue: [
			"bind using 'mousedown' rather than 'click' so that we can ensure that we parse the html before any 
			other 'click' events are executed"
			html script: ('
			$(function(){
			$("input[type=submit], button[type=submit]").bind("mousedown", function(){
			if ($("#', self tabId, '").tabs("option", "selected") == 1) {
				$("#wikiEditor").val(parseHtmlToPierWikiSyntax(pierWysiwygEditor._getDoc().body, "', baseUrl greaseString, '"))}
			$("#', textId, '").val($("#wikiEditor").val())})})') ]
		ifFalse: [ 
			html script: '$(function(){$("input[type=submit], button[type=submit]").bind("mousedown", function(){$("#', textId, '").val(parseHtmlToPierWikiSyntax(pierWysiwygEditor._getDoc().body, "', baseUrl greaseString, '"))})})'].
]

{ #category : #'accessing ids' }
PRWysiwygEditor >> selectId [
	^ self textId, '_createlink_sitemap'
]

{ #category : #callbacks }
PRWysiwygEditor >> siteMapSelectCallback: anObject [
	siteMapSelectCallback := anObject
]

{ #category : #callbacks }
PRWysiwygEditor >> siteMapSelectHtml [
	| selectCallback |
	self configuration showSiteMapLinks ifFalse: [ ^ '""' ].
	
	selectCallback := siteMapSelectCallback isNil 
		ifTrue: [ [ :id | '<select id=''', id,'''><option>sitemap NOT configured</option></select>'] ]
		ifFalse: [ siteMapSelectCallback ].
	
	^ String streamContents: [ :stream | 
		stream <<
			'"<label for=''" + this.get("id") + "_createlink_sitemap''><strong>Sitemap:</strong>'  <<
			(selectCallback value: self selectId) << 
			'</label>"' ]
	
		

]

{ #category : #accessing }
PRWysiwygEditor >> structureOwner [
	^ structureOwner
]

{ #category : #accessing }
PRWysiwygEditor >> structureOwner: theStructureOwner [
	structureOwner := theStructureOwner
]

{ #category : #accessing }
PRWysiwygEditor >> tabId [
	^ tabId
]

{ #category : #accessing }
PRWysiwygEditor >> tabId: anObject [
	^ tabId := anObject
]

{ #category : #private }
PRWysiwygEditor >> tabs [
	^ tabs ifNil: [
		tabs := OrderedCollection new.
		tabs 
			add: (Association key: 'Wiki Editor' value: ((Dictionary new) 
				at: #renderer put: [ :r | self renderWikiEditorOn: r ];
				yourself));
			add: (Association key: 'Wysiwyg editor' value: ((Dictionary new) 
				at: #renderer put: [ :r | self renderWysiwygEditorOn: r ];
				yourself));
			add: (Association key: 'Preview' value: ((Dictionary new) 
				at: #renderer put: [ :r | self renderPreviewOn: r ];
				yourself));
			yourself ]
]

{ #category : #'accessing ids' }
PRWysiwygEditor >> textId [
	^ textId
]

{ #category : #'accessing ids' }
PRWysiwygEditor >> textId: anObject [
	^ textId := anObject
]

{ #category : #updating }
PRWysiwygEditor >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	self wysiwygEditorUpdateRoot: anHtmlRoot.
	self jQueryTabsCustomisationUpdateRoot: anHtmlRoot.
	self wikiEditorCustomisationUpdateRoot: anHtmlRoot
]

{ #category : #updating }
PRWysiwygEditor >> wikiEditorCustomisationUpdateRoot: anHtmlRoot [
	anHtmlRoot stylesheet add:  '
textarea#wikiEditor {
	width: ', self editorWidth,';
}

td.wiki {
	padding-left:0px;
	padding-right:0px;
	padding-bottom:0px;
}
'
]

{ #category : #accessing }
PRWysiwygEditor >> wikiText [
	^ wikiText ifNil: [ 
		wikiText := '!A Wysiwyg editor for Pier

Currently the editor supports:
# ""Bold""
# ''''Italic''''
# __Underline__
# ==code==
# --strikeout--
# Headings
# line-breaks and paragraphs
# ordered and unordered lists.
# super^^script^^ and sub@@script@@
# horizontal line

_
The translator also supports the following, although there are no editor buttons to support it:
- definition list and definitions
- preformated.
- named anchors
- email addresses: *mail me>nick.ager@gmail.com*
- annotated paragraphs
@ananchor

@@note an annotated paragraph

= Some preformed text
= more preformed stuff
= whats is going on

A Definition List:
;Wysiwyg
:What you see is what you get
;Editor
:A computer program enabling the user to alter or rearrange online text

Still to come support for tables. Support for internal links still needs to be expanded.

!!! Support verbatim, embedded links and value links
The editor attempts to support all the Pier Wiki markup, so the Wysiwyg editor can be used interchangeably with the standard editor without fear of loosing any markup so, for example, it should be possible to use for editing Pier book content. I''ve taken the approach of preserving verbatim, embedded and value links in the Wysiwyg editor, but not making them editable. The editor could be extended with custom dialogs in which the raw wiki syntax could be edited.

Some non-editable wiki content:
{{{html: <div class="pierIcon">verbatim test</div>}}}
*value:time*
_

!!! Thoughts and questions
Some features should only be enabled for users with sufficient permissions. For example you don''t want untrusted users to be able to insert verbatium html or edit the content in the wiki standard view. However, is it acceptable to make the Wysiwyg editor dependant on Pier-Security? 
I propose we enable/disable features based on the following permissions:
- ==PRVerbatiumMarkupPermission==
- ==PRWikiTextEditingPermission==
- ==PREmbeddedLinksPermission==
- ==PRValueLinksPermission==

!!!Useful links
- *http://developer.yahoo.com/yui/editor/*
- *http://yuiblog.com/assets/pdf/cheatsheets/editor.pdf*
- *http://developer.yahoo.com/yui/examples/editor/toolbar_editor.html*
- *http://developer.yahoo.com/yui/docs/editor.js.html*
- *http://developer.yahoo.com/yui/examples/editor/cal_editor.html*
- *http://developer.yahoo.com/yui/examples/editor/flickr_editor.html*']
]

{ #category : #accessing }
PRWysiwygEditor >> wikiText: theWikiText [
	wikiText := theWikiText.
	(self onFormSubmit notNil and: [ self requestContext request isPost ]) ifTrue: [
		"Magritte works out if the submission was saved or cancelled"
		self onFormSubmit value: theWikiText ]
]

{ #category : #updating }
PRWysiwygEditor >> wysiwygEditorCustomisationUpdateRoot: anHtmlRoot [
	| toolbarUrl |
	toolbarUrl :=  (PREditorScripts / #toolbarPng) greaseString.
	anHtmlRoot javascript url: PRWysiwygFileLibrary / #parseHtmlToPierWikiSyntaxJs.
	
	anHtmlRoot stylesheet add: '
.yui-toolbar-group {
	margin-top: 4px;
}
.yui-skin-sam .yui-toolbar-container .yui-toolbar-code span.yui-toolbar-icon {
	background-image: url( ', toolbarUrl, ');
	background-position: -64px 0px;
	margin-left: 5px;
	margin-top: 2px;
}

.yui-skin-sam .yui-toolbar-container .yui-toolbar-rule span.yui-toolbar-icon {
	background-image: url( ', toolbarUrl, ' );
	background-position: -208px 0px;
	margin-left: 5px;
	margin-top: 2px;
}

.yui-skin-sam .yui-toolbar-container .yui-toolbar-strike span.yui-toolbar-icon {
	background-image: url( ', toolbarUrl, ' );
	background-position: -48px 0px;
	margin-left: 5px;
	margin-top: 2px;
}

.yui-overlay {
	font: 13px/1.231 arial,  helvetica, clean, sans-serif;
}
'
	

]

{ #category : #updating }
PRWysiwygEditor >> wysiwygEditorStandardConfigUpdateRoot: anHtmlRoot [
	"see http://developer.yahoo.com/yui/articles/hosting/?editor#configure"

	PRYUIEditorDeploymentLibrary default updateRoot: anHtmlRoot
]

{ #category : #updating }
PRWysiwygEditor >> wysiwygEditorUpdateRoot: anHtmlRoot [
	"See YUI editor documentation: 
		* http://developer.yahoo.com/yui/editor/
		* http://yuiblog.com/assets/pdf/cheatsheets/editor.pdf"

	self wysiwygEditorStandardConfigUpdateRoot: anHtmlRoot.
	self wysiwygEditorCustomisationUpdateRoot: anHtmlRoot.

]

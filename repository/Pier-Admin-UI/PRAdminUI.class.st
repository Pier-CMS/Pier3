"
I render Pier's administration interface and manage the components contained within it. I manage anchor clicks and form submissions from the main frame component which are intercepted and packaged as Ajax requests and render a response. The response is split-up into:
- head scripts
- head styles
- body scripts
- body html

see also: +value:source|class=PRBookKernelDistribution|selector=bookEntryPierAdminInsideAjaxUpdates+
"
Class {
	#name : #PRAdminUI,
	#superclass : #PRAdminAnnouncingComponent,
	#instVars : [
		'commandsComponent',
		'tabsComponent',
		'navigatorComponent',
		'pierComponent'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #'instance creation' }
PRAdminUI class >> pierComponent: pierComponent [
	^ self new
		pierComponent: pierComponent;
		yourself
]

{ #category : #rendering }
PRAdminUI >> addHeadScriptsAndStyles: anHtmlRoot on: script [
	anHtmlRoot styles do: [ :each | 
		script << (JSStream on: ('addStyleIfNotAlreadyInstalled(', each asJavascript, ')')) ].

	anHtmlRoot scripts do: [ :each |
		each isString 
			ifTrue: [
				script << (JSStream on: ('addScriptIfNotAlreadyInstalled(', each asJavascript, ')')) ]
			ifFalse: [
				script << (JSStream on: ('addScriptUrlIfNotAlreadyInstalled(', each asJavascript, ')')) ] ]

]

{ #category : #'renderering hijax' }
PRAdminUI >> addIFrameHeadScriptsAndStyles: htmlRoot on: script [
	htmlRoot styles do: [ :each | 
		script << (JSStream on: ('addIFrameStyleIfNotAlreadyInstalled(',  each asJavascript, ')')) ].
	
	htmlRoot scripts do: [ :each |
		each isString
			ifTrue: [
				script << (JSStream on: ('addIFrameScriptIfNotAlreadyInstalled(', each asJavascript, ')')) ]
			ifFalse: [
				script <<  (JSStream on: ('addIFrameScriptUrlIfNotAlreadyInstalled(', each asJavascript, ')')) ] ]
		

]

{ #category : #javscript }
PRAdminUI >> addIFrameScriptIfNotAlreadyInstalledJS [
	^ '
var alreadyInstalledIFrameScripts = [];
var addIFrameScriptUrlIfNotAlreadyInstalled = function (url) {
	if ($.inArray(url, alreadyInstalledIFrameScripts) == -1) {
		/* set cache to true to ensure jQuery doesnt add random query parameters to end of request
		async is false to force the scripts to load in the order they are specified */
		$.ajax({"url":url,"async":false,"dataType":"script","cache":true, "success":function(script){evalScriptWithinIFrame(script)}});
		alreadyInstalledIFrameScripts.push(url);
	}
}
var addIFrameScriptIfNotAlreadyInstalled = function (script) {
	if ($.inArray(script, alreadyInstalledIFrameScripts) == -1) {
		evalScriptWithinIFrame (script);
		alreadyInstalledIFrameScripts.push(script);
	}
}

var evalScriptWithinIFrame = function(script) {
	try {
		jQuery("#iFrameView")[0].contentWindow.eval(script);
	} catch(e) {
		console.log("Error occurred: ");
		console.log(e);
		console.log("while evaluating");
		console.log(script);
		debugger;		
	}
}
'
]

{ #category : #javscript }
PRAdminUI >> addIFrameStyleIfNotAlreadyInstalledJS [
	^ '
var alreadyInstalledIFrameStyles = [];

var addIFrameStyleIfNotAlreadyInstalled = function (style) {
	if ($.inArray(style, alreadyInstalledIFrameStyles) == -1) {
		$("#iFrameView").contents().find("head").append(style);
		alreadyInstalledIFrameStyles.push(style);
	}
}
'
]

{ #category : #javscript }
PRAdminUI >> addScriptIfNotAlreadyInstalledJS [
	| initiallyLoadedHeadScripts installedScripts |
	initiallyLoadedHeadScripts := self requestContext headScripts asJavascript.
	installedScripts := 'var alreadyInstalledScripts = ', initiallyLoadedHeadScripts, ';'.
	
	^ installedScripts, '
var addScriptUrlIfNotAlreadyInstalled = function (url) {
	if ($.inArray(url, alreadyInstalledScripts) == -1) {
		/* set cache to true to ensure jQuery doesnt add random query parameters to end of request
		async is false to force the scripts to load in the order they are specified */
		$.ajax({"url":url,"async":false,"dataType":"script","cache":true, "success":function(script) {
			try {
				window.eval(script);
			} catch(e) {
				console.log("Error occurred: ");
				console.log(e);
				console.log("while evaluating");
				console.log(script);
				debugger;					
			}
		}});
		alreadyInstalledScripts.push(url);
	}
}
var addScriptIfNotAlreadyInstalled = function (script) {
	if ($.inArray(script, alreadyInstalledScripts) == -1) {
		window.eval(script);
		alreadyInstalledScripts.push(script);
	}
}
'
]

{ #category : #javscript }
PRAdminUI >> addStyleIfNotAlreadyInstalledJS [
	| initiallyLoadedHeadStyles installedStyles |
	initiallyLoadedHeadStyles := self requestContext headStyles asJavascript.
	installedStyles := 'var alreadyInstalledStyles = ',  initiallyLoadedHeadStyles, ';'.
	
	^ installedStyles, '
var addStyleIfNotAlreadyInstalled = function (style) {
	if ($.inArray(style, alreadyInstalledStyles) == -1) {
		$("head").append(style);
		alreadyInstalledStyles.push(style);
	}
}
'
]

{ #category : #announcing }
PRAdminUI >> announcementRegister [
	self session pierAdminAnnouncer on: PRAdminAjaxUpdate do: [ :ajaxUpdate |
		| s |
		s := ajaxUpdate script.
		self renderHeadScriptsAndStylesOn: s.
		
		"deliberately replace the contents of css '#content ' so that #delegate:on:do: anchors and 
		buttons will be reset and new ones redelegated (as those anchors and buttons are 
		delegated via '#content')"
		s << (s jQuery: #content) replaceWith:  [ :r | self renderViewContentOn: r ] ]
]

{ #category : #accessing }
PRAdminUI >> children [
	^ Array 
		with: self pierComponent
		with: self navigatorComponent
		with: self commandsComponent
		with: self tabsComponent
]

{ #category : #accessing }
PRAdminUI >> commandsComponent [
	^ commandsComponent ifNil: [ commandsComponent := PRAdminCommands contextGetCallback: [ self context ] contextSetCallback: [ :newContext | self context: newContext ] ]
]

{ #category : #accessing }
PRAdminUI >> context [
	^ self pierComponent context
]

{ #category : #accessing }
PRAdminUI >> context: newContext [
	^ self pierComponent context: newContext
]

{ #category : #private }
PRAdminUI >> ensureThatKeysOnMainPageAndPreviewIFrameDontClashOn: html [
	"why? iframe content (preview view) and the main site content share the same message loop (to 
	ensure that changes made to one effect the other). Need a way to ensure that callback keys 
	between the iframe and the wrapper don't clash' "
	html context callbacks key: 1000.
]

{ #category : #'renderering hijax' }
PRAdminUI >> generateRequestContextFor: callbackUrl requestType: requestType callbackId: callbackId [
	| requestContext newRequest newRequestContext postFields callbackUrlString |
	requestContext := self requestContext.
	callbackUrlString := callbackUrl greaseString.

	"ensure the action continuation directly renders a response rather than a redirect
	see: PRAdminActionPhaseContinuation"
	callbackUrl queryFields at: 'dontRedirect' put: 'true'.
	newRequest := WARequest method: requestType uri: callbackUrl.
	
	"purge the request of Seaside fields; _s _k
	these fields are associated with the Ajax request.
	The _k field we require is encoded in the callbackUrl"
	postFields := requestContext request postFields.
	postFields 
		removeKey: self application keyField ifAbsent: [ "do nothing" ];
		removeKey: self session actionField ifAbsent: [ "do nothing" ].
	
	"remove the key which has triggered this Ajax request - to avoid recursion"
	postFields removeKey: callbackId ifAbsent: [ "do nothing" ].
	
	"remove the key containing the url"
	postFields copy keysAndValuesDo: [ :key :value |
		value = callbackUrlString ifTrue: [
			postFields removeKey: key ] ].
	
	newRequest setPostFields: postFields.
	newRequestContext := PRAdminRequestContext 
		request: newRequest
		response: WABufferedResponse new
		codec: requestContext codec.
		
	newRequestContext handlers
		add: requestContext session;
		add: requestContext application.
		
	^ newRequestContext
]

{ #category : #rendering }
PRAdminUI >> houseKeepingOn: html [
	self ensureThatKeysOnMainPageAndPreviewIFrameDontClashOn: html.
	self renderKeepSessionAliveTimerOn: html
]

{ #category : #testing }
PRAdminUI >> isShowingPreview [
	^ self pierComponent isShowingPreview
]

{ #category : #accessing }
PRAdminUI >> kernel [
	^ self pierComponent kernel
]

{ #category : #private }
PRAdminUI >> logout [
	self context: (self context user: nil).
	self context: (self context structure: self context root).
	self session presenter home 
]

{ #category : #accessing }
PRAdminUI >> navigatorComponent [
	^ navigatorComponent ifNil: [ navigatorComponent := PRAdminNavigator contextGetCallback: [ self context ] contextSetCallback: [ :newContext | self context: newContext ] ]
]

{ #category : #rendering }
PRAdminUI >> onlyRenderPierComponent [
	"After the initial rendering, content is rendered via ajax updates.
	 When we re-render the view we only want to render the main content 
	not the complete admin UI.... so the #show: below ensures that 
	subsequent renderings never get here; only the main content 
	(pierFrame) is rendered - that is the Admin UI is never re-rendered
	directly"
	self home; show: self pierComponent.
]

{ #category : #accessing }
PRAdminUI >> pierComponent [
	^ pierComponent
]

{ #category : #accessing }
PRAdminUI >> pierComponent: thePierComponent [
	pierComponent := thePierComponent
]

{ #category : #rendering }
PRAdminUI >> renderAdminInterfaceOn: html [
	html div
		class: 'ui-layout-west';
		id: #sidebars;
		with: [ self renderSidebarOn: html ].
	
	html div
		class: 'pane ui-layout-center';
		id: 'center';
		with: [ 
			self renderMainPaneOn: html ].
		
	self renderLayoutOn: html
]

{ #category : #rendering }
PRAdminUI >> renderContentOn: html [
	self houseKeepingOn: html.
		
	self renderAdminInterfaceOn: html
]

{ #category : #rendering }
PRAdminUI >> renderHeadScriptsAndStylesOn: script [
	| anHtmlRoot |
	"if we're displaying preview the iframe contains a complete document including head scripts and styles"
	self isShowingPreview ifTrue: [ ^ self ].
	
	anHtmlRoot := PRAdminHtmlRoot context:  script renderContext.
	
	(WAVisiblePresenterGuide client:
		(WAUpdateRootVisitor root: anHtmlRoot))
		start: self pierComponent.
		
	self addHeadScriptsAndStyles: anHtmlRoot on: script
]

{ #category : #rendering }
PRAdminUI >> renderHeaderOn: html [
	html div
		id: #header;	
		class: 'title';	
		with: [ 
			html anchor
				url: self application url;
				with: [
					html heading: 'Pier Admin' ].
			
			html div
				id: #loggedInAs;
				with: [	
					html text: 'Logged in as '.
					html emphasis: self context user fullName.
					html space.
					html anchor
						callback: [ self logout ];
						with: 'logout' ] ]
]

{ #category : #'renderering hijax' }
PRAdminUI >> renderIFrameViewOn: html [
	| callbackUrl jqPost requestType |
	"valueholder for Gemstone 2.4.* compatibility see:
	- http://code.google.com/p/glassdb/issues/detail?id=221
	- http://forum.world.st/use-of-method-temporaries-in-callback-blocks-td2340788.html"
	callbackUrl := WAValueHolder new. 
	requestType := WAValueHolder new.
	
	html script: self addIFrameScriptIfNotAlreadyInstalledJS.
	html script: self addIFrameStyleIfNotAlreadyInstalledJS.

	jqPost := html jQuery post
		callback: [ :value | 
			| parameters |
			parameters := value substrings:  ','.
			self assert: parameters size = 2.
			callbackUrl contents: (WAUrl absolute: parameters first).
			requestType contents: parameters second ] 
		value: (JSStream on: '[url, (data==null) ? "GET" : "POST"]');
		addParameter: (JSStream on: 'data').
		
	jqPost script: [ :s | 
		self renderIFrameViewResponseForUrl: callbackUrl contents requestType: requestType contents callbackId: jqPost callbackId on: s.
		self announceAjaxUpdateWithoutSelfOn: s ].
		
	html script: ((jqPost asFunction: #('url' 'data')) assignLocalTo: 'handleIFrameViewClick').
	
	html iframe
		id: #iFrameView;
		callback: [ self session presenter show: 
			(self pierComponent addDecoration: PRAdminIFrameDecorator new; yourself) ].

	html document addLoadScript: 
		((html jQuery: #iFrameView) onLoad:
			(((html jQuery this contents find: 'body')
				on: 'click'
				selector: 'a'
				do: 
			'if (this.getAttribute("href")) {
				var urlParts = this.getAttribute("href").split("?");
				if (urlParts.length > 1 && (urlParts[1].substr(0, 2) == "_s" ||  urlParts[1].substr(0, 2) == "_k")) {
					handleIFrameViewClick(this.getAttribute("href"), null); return false;
				}
			}
			return true;'),
			((html jQuery this contents find: 'body')
				on: 'click'
				selector: 'input[type=submit], button[type=submit]'
				do: 'var form = $(this).closest("form"); 
					if(form.length == 1) {
						handleIFrameViewClick(form.attr("action"), form.find(":input").serialize() + "&" + $(this).attr("name")); 
						return false
					}')))
]

{ #category : #'renderering hijax' }
PRAdminUI >> renderIFrameViewResponseForUrl: callbackUrl requestType: requestType callbackId: callbackId on: script [
	| requestContext document |

	requestContext := self renderResponseForUrl: callbackUrl requestType: requestType callbackId: callbackId.
	document := requestContext document.
	
	document isNil 
		ifTrue: [ 
			"some views generate a response directly eg wikiview"
			script <<  
				((script jQuery: #iFrameView) contents find: 'body') html: [ :r |
					self renderNonDocumentResponse: requestContext response on: r ] ]
		ifFalse: [
			"the  rendering artifacts (head, body, scripts) have been separated"	
			self addIFrameHeadScriptsAndStyles: document htmlRoot on: script.
	
			script <<  ((script jQuery: #iFrameView) contents find: 'body') html: [ :r |
				r html: document bodyHtml ].
	
			document bodyScripts do: [ :each |
				script << (JSStream on: ('evalScriptWithinIFrame(', each asJavascript, ')')) ].	
	
			 document loadScripts do: [ :each |
				script << (JSStream on: ('evalScriptWithinIFrame(', each asJavascript asJavascript, ')')) ] ]
]

{ #category : #rendering }
PRAdminUI >> renderKeepSessionAliveTimerOn: html [
	| timeOutPeriodInSeconds |
	timeOutPeriodInSeconds := self application cache expiryPolicy configuration at: #cacheTimeout.
	 html document addLoadScript: (html jQuery ajax
               callback: [ "Do nothing" ];
               interval: (Duration seconds: timeOutPeriodInSeconds / 2)).
]

{ #category : #rendering }
PRAdminUI >> renderLayoutOn: html [
 	| myLayout |
	myLayout := (html jQuery: 'body') layout.
	myLayout west
		at: 'size' put: 200; 
		"at: 'maxSize' put: 280;"
		at: 'onresize' put: ((html jQuery: #sidebars) accordion resize) asFunction ; 
		at: 'togglerLength_open' put: 20; 
		at: 'togglerLength_closed' put: 20; 
		at: 'togglerAlign_open' put: 'top'; 
		at: 'togglerAlign_closed' put: 'top'; 
		at: 'togglerContent_closed' put: '&#8250';
		at: 'togglerContent_open' put: '&#8249'.
	myLayout east
		at: 'initClosed' put: true.
	html document addLoadScript: myLayout.
	
]

{ #category : #rendering }
PRAdminUI >> renderMainPaneOn: html [
	html div
		id: #main;
		with: [
			html render: self tabsComponent.
			
			html script: self addScriptIfNotAlreadyInstalledJS.
			html script: self addStyleIfNotAlreadyInstalledJS.
			self renderViewContentOn: html ]
]

{ #category : #rendering }
PRAdminUI >> renderNonDocumentResponse: response on: html [
	response contentType seasideMimeType = WAMimeType textHtml
		ifTrue: [ html html: response contents ]
		ifFalse: [ html text: response contents ]
]

{ #category : #'renderering hijax' }
PRAdminUI >> renderResponseForUrl: callbackUrl  requestType: requestType callbackId: callbackId [
	| newRequestContext |
	
	newRequestContext := self generateRequestContextFor: callbackUrl requestType: requestType callbackId: callbackId.
	[ self session handle: newRequestContext ] 
		on: WAResponseNotification
		do: [ :n | "we've rendered a response, drop through" ].

	^ newRequestContext
]

{ #category : #rendering }
PRAdminUI >> renderSidebarOn: html [
	html div
		id: #sidebar;
		with: [ 
			self renderHeaderOn: html.
			html render: self navigatorComponent.
			html render: self commandsComponent.
			PRAdminLogin renderAssociatedPierInstanceLinkFor: self kernel text: 'Associated instance: ' on: html ]
]

{ #category : #rendering }
PRAdminUI >> renderViewContentOn: html [
	html div
		id: #content;
			with: [
				self isShowingPreview
					ifTrue: [
						self renderIFrameViewOn: html ]
					ifFalse: [
						self onlyRenderPierComponent.
						self renderViewOn: html ]  ]
]

{ #category : #'renderering hijax' }
PRAdminUI >> renderViewOn: html [
	| callbackUrl jqPost requestType |
	"valueholder for Gemstone 2.4.* compatibility see:
	- http://code.google.com/p/glassdb/issues/detail?id=221
	- http://forum.world.st/use-of-method-temporaries-in-callback-blocks-td2340788.html"
	callbackUrl := WAValueHolder new. 
	requestType := WAValueHolder new.
	
	jqPost := html jQuery post
		callback: [ :value |
			| parameters |
			parameters := value substrings: ','.
			self assert: parameters size = 2.
			callbackUrl contents: (WAUrl absolute: parameters first).
			requestType contents: parameters second ] 
			value: (JSStream on: '[url, (data==null) ? "GET" : "POST"]');
		addParameter: (JSStream on: 'data').
		
	jqPost script: [ :s | 
		self renderViewResponseForUrl: callbackUrl contents requestType: requestType contents callbackId: jqPost callbackId on: s.
		self announceAjaxUpdateWithoutSelfOn: s ].
	
	html script: ((jqPost asFunction: #('url' 'data')) assignLocalTo: 'handleViewClick').

	html render: self pierComponent.
	
	html document addLoadScript: 
		((html jQuery: #content)
			on: 'click'
			selector: 'a'
			do: '
			if (this.getAttribute("href")) {
				var urlParts = this.getAttribute("href").split("?");
				if (urlParts.length > 1 && (urlParts[1].substr(0, 2) == "_s" ||  urlParts[1].substr(0, 2) == "_k")) {
					handleViewClick(this.getAttribute("href"), null); return false;
				}
			}
			return true;';
			on: 'click'
			selector: 'input[type=submit], button[type=submit]'
			do: 'var form = $(this).closest("form"); 
				if(form.length == 1) {
					handleViewClick(form.attr("action"), form.find(":input").serialize() + "&" + $(this).attr("name")); 
					return false
				}')
]

{ #category : #'renderering hijax' }
PRAdminUI >> renderViewResponseForUrl: callbackUrl requestType: requestType callbackId: callbackId on: script [
	| requestContext document |

	requestContext := self renderResponseForUrl: callbackUrl requestType: requestType  callbackId: callbackId.
	document := requestContext document.
	
	document isNil 
		ifTrue: [
			"some views generate a response directly eg wikiview"
			script <<  
				 (script jQuery: #content) html: [ :r | 
					self renderNonDocumentResponse: requestContext response on: r ] ]
		ifFalse: [
			"the  rendering artifacts (head, body, scripts) have been separated"
			self addHeadScriptsAndStyles: document htmlRoot on: script.

			script << (script jQuery: #content) html: [ :r | r html: document bodyHtml ].
	
			document bodyScripts do: [ :each |
				script << (JSStream on: each) ].	
	
			document loadScripts do: [ :each |
				script << (JSStream on: each asJavascript) ] ]

]

{ #category : #hooks }
PRAdminUI >> states [
	^ Array with: self pierComponent
]

{ #category : #accessing }
PRAdminUI >> tabsComponent [
	^ tabsComponent ifNil: [ tabsComponent := PRAdminTabs contextGetCallback: [ self context ] contextSetCallback: [ :newContext | self context: newContext ] ]
]

{ #category : #updating }
PRAdminUI >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.

	JSTreeFileLibrary default updateRoot: anHtmlRoot.
	anHtmlRoot javascript url: JQWidgetBoxDeploymentLibrary / #jquerylayoutminJs.
	
	anHtmlRoot stylesheet url: PRAdminFileLibrary / #pieradminCss.


	

]

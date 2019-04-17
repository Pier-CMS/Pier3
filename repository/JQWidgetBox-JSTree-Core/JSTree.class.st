Class {
	#name : #JSTree,
	#superclass : #JQWidget,
	#instVars : [
		'themes',
		'checkMoveCallback',
		'getChildrenCallback',
		'addNodeCallback',
		'createBlock',
		'createSuccessBlock',
		'createFailBlock',
		'events'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #options }
JSTree >> animation: aNumber [
	self core at: 'animation' put: aNumber
]

{ #category : #private }
JSTree >> bindEvent: eventString parameters: parameters eventHandlerBlock: anEventHandlerBlock [

	self events at: eventString put: anEventHandlerBlock.
	self
		call: 'bind'
		with: eventString
		with: (((((JQueryClass context: self renderContext) ajax)
			type: 'POST';
			addParameter: 'event' -> eventString;
			addParameters: parameters;
			onError: ((JQueryClass context: self renderContext)
						script: [:s | s << (JSStream on: '$.jstree.rollback(data.rlbk)')]);
			"onSuccess: ((JQuery.JQueryClass context: self renderContext)
						script: [:s | self renderOnSuccessScriptOn: s forEvent: eventString]);"
			callback: [self callbackResponse]),
			(JSStream on: '$.jstree.rollbackLast=function(){$.jstree.rollback(data.rlbk)}'))
			asFunction: #(e data))
]

{ #category : #private }
JSTree >> callbackResponse [

	| event |
	event := JSTreeEvent newFromWARequest: self requestContext request.
	^self requestContext respond: 
			[:response |
			response
				doNotCache;
				contentType: (WAMimeType textJavascript charset: self requestContext handler charSet).
			[self script: [:s | (events at: event event) value: event value: s] on: response stream] on: JSTreeError
				do: 
					[:ex |
					response badRequest.
					(response stream)
						nextPutAll: ex class name;
						nextPutAll: ': ';
						nextPutAll: ex messageText]]
]

{ #category : #options }
JSTree >> checkMoveBlock: aCheckMoveBlock [
	checkMoveCallback := aCheckMoveBlock.
	
	self dnd at: 'drop_check' put: (((JQueryClass context: self renderContext) ajax)
				type: 'POST';
				addParameter: 'object.id' -> (JSStream on: 'data.o.attr("id")');
				addParameter:  'object.metadata' -> (JSStream on: 'JSON.stringify(data.o.data("jstree"))');
				addParameter:  'target.id' -> (JSStream on: 'data.r.attr("id")');
				addParameter:  'target.metadata' -> (JSStream on: 'JSON.stringify(data.r.data("jstree"))');			
				onError: ((JQueryClass context: self renderContext)
							script: [:s | s << false]);
				callback: [self checkMoveCallbackResponse];
				asFunction: #(data)).
]

{ #category : #private }
JSTree >> checkMoveCallbackResponse [

	| event |
	event := JSTreeEvent newFromWARequest: self requestContext request.
	^self requestContext respond: 
			[:response |
			response
				doNotCache;
				contentType: (WAMimeType textJavascript charset: self requestContext handler charSet).
			[self script: [:s | (events at: event event) value: event value: s] on: response stream] on: JSTreeError
				do: 
					[:ex |
					response badRequest.
					(response stream)
						nextPutAll: ex class name;
						nextPutAll: ': ';
						nextPutAll: ex messageText]]
]

{ #category : #events }
JSTree >> childrenBlock: aGetChildrenCallback [

	self childrenBlock: aGetChildrenCallback rootNodes: nil.
]

{ #category : #events }
JSTree >> childrenBlock: aGetChildrenCallback rootNodes: rootNodes [

	| url |
	getChildrenCallback := aGetChildrenCallback.
	url := (self renderContext actionUrl copy)
				addField: (self renderContext callbacks
							store: (JSAjaxCallback on: [self processGetChildrenCallback]));
				yourself.
	rootNodes ifNotNil: [:root | self json at: 'data' put: root value].
	self json at: 'ajax'
		put: ((Dictionary new)
				at: 'url' put: url;
				at: 'data' put: ((JSStream on: self treeNodeData) asFunction: #(n));
				yourself)
]

{ #category : #private }
JSTree >> contextMenuAjaxRequest: contextMenuBlock [
	^ ((JQueryClass context: self renderContext) ajax text: [ :stream |
		| node menuItems |
		node := JSTreeNode newFromWARequest: self requestContext request.
		menuItems := JSTreeContextMenuItems new.
		contextMenuBlock value: node value: menuItems.
		menuItems renderContext: self renderContext.
		stream json: menuItems ];
		onSuccess: 
			"have to eval manually as valid json doesn't allow function references as values - hence transfer the json-like structure as
			text then eval to use it"
			('eval("jQuery.jstree[''downloadedContextMenu''] = " + data);
			var event = jQuery.Event(''contextmenu'');
			node.find(''a'').first().trigger(event)' asFunction: #(data));
		addParameters: self contextMenuEventParameters)
]

{ #category : #events }
JSTree >> contextMenuBlock: contextMenuBlock [
	self options at: 'contextmenu' put: 
		(Dictionary new
			at: 'select_node' put: false;
			at: 'show_at_node' put: true;
			at: 'items' put: 
				"display a loading menu, request new menu based on selected node, then trigger a 'selectmenu' event to display the downloaded menu"
				((JSStream on: 
					'if (jQuery.jstree[''downloadedContextMenu''] === undefined) {'),
						(self contextMenuAjaxRequest: contextMenuBlock),
						(JSStream on: 
						'return {loading:{label:''loading...'',icon:''', (JSTreeFileLibrary / #throbberGif) greaseString,'''}};
					} else {
						var downloadedContextMenu = jQuery.jstree[''downloadedContextMenu''];
						delete jQuery.jstree[''downloadedContextMenu''];
						return downloadedContextMenu;
					}') asFunction: #(node));
			yourself)
]

{ #category : #private }
JSTree >> contextMenuEventParameters [
	"to allow server-side identification of the node selected"
	^ GRSmallDictionary new
		at: 'id'  put:  (JSStream on: 'node.attr ? node.attr(''id'') : -1');
		at: 'type' put:  (JSStream on: 'node.attr ? node.attr(''rel'') : ''null''');
		at: 'metadata' put: (JSStream on: 'node.attr ? JSON.stringify(node.data()) : {}');
		yourself
]

{ #category : #options }
JSTree >> core [
	^ self options at: 'core' ifAbsentPut: [ GRSmallDictionary new ]
]

{ #category : #events }
JSTree >> createBlock: aCreateBlock [

	self
		bindEvent: 'create.jstree'
		parameters: self createEventParameters
		eventHandlerBlock: aCreateBlock
]

{ #category : #private }
JSTree >> createEventParameters [

	^(GRSmallDictionary new)
		at: 'id' put: (JSStream on: 'data.rslt.parent.attr("id")');
		at: 'metadata' put: (JSStream on: 'JSON.stringify(data.rslt.parent.data("jstree"))');
		at: 'position' put: (JSStream on: 'data.rslt.position');
		at: 'title' put: (JSStream on: 'data.rslt.name');
		at: 'type' put: (JSStream on: 'data.rslt.obj.attr("rel")');
		yourself
]

{ #category : #accessing }
JSTree >> createNode: aJQueryNodeRelativeReference position: position node: jsTreeNode jsCreationCallback: jsCreationCallback skipRename: skipRenameBoolean [
	"see http://www.jstree.com/documentation/crrm"
	self action: 'create' arguments: (Array with: aJQueryNodeRelativeReference with: position with: jsTreeNode with: jsCreationCallback with: skipRenameBoolean)
]

{ #category : #actions }
JSTree >> deselectAll [
	self action: 'deselect_all'
]

{ #category : #options }
JSTree >> dnd [
	^ self options at: 'dnd' ifAbsentPut: [ GRSmallDictionary new ]
]

{ #category : #private }
JSTree >> events [
	^events ifNil: [ events := Dictionary new ]
]

{ #category : #'initial state' }
JSTree >> initiallyOpen: anArrayOfElementIds [
	self core at: 'initially_open' put: anArrayOfElementIds
]

{ #category : #'initial state' }
JSTree >> initiallySelected: anArrayOfElementIds [
	self ui at: 'initially_select' put: anArrayOfElementIds
]

{ #category : #options }
JSTree >> json [
	^ self options at: 'json_data' ifAbsentPut: [ GRSmallDictionary new ]
]

{ #category : #actions }
JSTree >> loadNode: aJQueryNodeSelector [ 
	self action: 'load_node' arguments: (Array with: aJQueryNodeSelector)
]

{ #category : #accessing }
JSTree >> method [
	^'jstree'
]

{ #category : #accessing }
JSTree >> moveBlock: aMoveBlock [

	| eventString |
	eventString := 'move_node.jstree'.
	self events at: eventString put: aMoveBlock.
	self
		call: 'bind'
		with: eventString
		with: (((JQueryClass context: self renderContext) script: 
					[:s |
					s << ((s alias: 'data.rslt.o') call: 'each'
								with: ((((JQueryClass context: self renderContext) ajax)
										type: 'POST';
										addParameter: 'event' -> eventString;
										addParameters: self moveEventParameters;
										callback: [ self callbackResponse]) asFunction: #(i)))])
				asFunction: #(#e #data))
]

{ #category : #events }
JSTree >> moveCallbackResponse [

	| event |
	event := JSTreeEvent newFromWARequest: self requestContext request.
	^self requestContext respond: 
			[:response |
			response
				doNotCache;
				contentType: (WAMimeType textJavascript charset: self requestContext handler charSet).
			[self script: [:s | (events at: event event) value: event value: s] on: response stream] on: JSTreeError
				do: 
					[:ex |
					response badRequest.
					(response stream)
						nextPutAll: ex class name;
						nextPutAll: ': ';
						nextPutAll: ex messageText]]
]

{ #category : #events }
JSTree >> moveEventParameters [
	^ GRSmallDictionary new
		at: 'performcopy' put: (JSStream on: 'data.rslt.cy');	
		at: 'id' put: (JSStream on: '$(this).attr("id")');
		at: 'metadata' put: (JSStream on: 'JSON.stringify($(this).data("jstree"))');
		at: 'ref_id' put: (JSStream on:  'data.rslt.np.attr("id")');
		at: 'ref_metadata' put: (JSStream on:  'JSON.stringify(data.rslt.np.data("jstree"))');
		at: 'position' put: (JSStream on: 'data.rslt.cp + i');
		at: 'title' put: (JSStream on: 'data.rslt.name');		
		yourself
]

{ #category : #actions }
JSTree >> open: aJQueryNodeSelector [ 
	self action: 'open_node' arguments: (Array with:aJQueryNodeSelector)
]

{ #category : #options }
JSTree >> plugins: anArray [
	self optionAt: 'plugins' put: anArray
]

{ #category : #private }
JSTree >> processGetChildrenCallback [
	|  result| 

	result := getChildrenCallback value: (JSTreeNode newFromWARequest: self requestContext request).
	self requestContext respond: 
			[:response |
			response
				doNotCache;
				contentType: (WAMimeType applicationJson charset: self requestContext handler charSet).
			result jsonOn: response stream]
]

{ #category : #actions }
JSTree >> refresh: aJQueryNodeSelector [ 
	self action: 'refresh' arguments: (Array with:aJQueryNodeSelector)
]

{ #category : #accessing }
JSTree >> remove: aJQueryNodeReference [
	self action: 'remove' arguments: (Array with: aJQueryNodeReference)
]

{ #category : #accessing }
JSTree >> removeBlock: aRemoveBlock [
	| eventString |
	eventString := 'before.jstree'.
	self events at: eventString put: aRemoveBlock.
	self
		call: 'bind'
		with: eventString
		with: (((JQueryClass context: self renderContext) script: [:s |					
			s << ((s alias: 'data.inst._get_node(null, true)') call: 'each'
				with: (((JQueryClass context: self renderContext) ajax)
					type: 'POST';
					addParameter: 'event' -> eventString;
					addParameters: self removeEventParameters;
					callback: [self callbackResponse]) asFunction)
				condition: (JSStream on: 'data.func == "remove"')])
			asFunction: #(e data))
]

{ #category : #private }
JSTree >> removeEventParameters [

	^(GRSmallDictionary new)
		at: 'id' put: (JSStream on: 'this.id');
		at: 'metadata' put: (JSStream on: 'JSON.stringify($(this).data("jstree"))');
		yourself
]

{ #category : #events }
JSTree >> renameBlock: aRenameBlock [
	self
		bindEvent: 'rename.jstree'
		parameters: self renameEventParameters
		eventHandlerBlock: aRenameBlock
]

{ #category : #private }
JSTree >> renameEventParameters [
	^ (GRSmallDictionary new)
		at: 'id' put: (JSStream on: 'data.rslt.obj.attr("id")');
		at: 'title' put: (JSStream on: 'data.rslt.new_name');
		at: 'metadata' put: (JSStream on: 'JSON.stringify(data.rslt.obj.data())');
		yourself
]

{ #category : #actions }
JSTree >> select: aJQueryNodeSelector [ 
	self action: 'select_node' arguments: (Array with: aJQueryNodeSelector)
]

{ #category : #actions }
JSTree >> select: aJQueryNodeSelector check: checkRules [
	self action: 'select_node' arguments: (Array with: aJQueryNodeSelector with: checkRules)
]

{ #category : #events }
JSTree >> selectBlock: aSelectBlock [

	self
		bindEvent: 'select_node.jstree'
		parameters: self renameEventParameters
		eventHandlerBlock: aSelectBlock
]

{ #category : #'initial state' }
JSTree >> selectLimit: numberOfNodesSimulateouslySelected [
	self ui at: 'select_limit' put: numberOfNodesSimulateouslySelected
]

{ #category : #options }
JSTree >> theme: aThemeString [
	self themes at: 'theme' put: aThemeString.
]

{ #category : #options }
JSTree >> themes [
	^ self options at: 'themes' ifAbsentPut: [ GRSmallDictionary new ]
]

{ #category : #actions }
JSTree >> toggleNode: aNode [
	aNode ifNil: [^self].
	self action: 'toggle_node' arguments: (Array with:aNode)
]

{ #category : #options }
JSTree >> treeNodeData [
	^'return { "id" : n.attr ? n.attr("id") : -1, "type" : n.attr ? n.attr("rel") : "null", "metadata": n.attr ? JSON.stringify(n.data()) : {} }'
]

{ #category : #options }
JSTree >> types: aJSTreeTypeCollection [
	self optionAt: 'types' put: aJSTreeTypeCollection
]

{ #category : #options }
JSTree >> ui [
	^ self options at: 'ui' ifAbsentPut: [ GRSmallDictionary new ]
]

{ #category : #options }
JSTree >> validChildren: aNodeTypeString [
	self types at: 'valid_children' put: aNodeTypeString
]

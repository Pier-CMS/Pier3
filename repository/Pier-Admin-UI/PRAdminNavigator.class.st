"
I render the navigator on the left-hand-side of the Admin UI. I also provide a context sensitive right-click menu when a node is selected and respond to requests on the menu. 
"
Class {
	#name : #PRAdminNavigator,
	#superclass : #PRAdminUIChild,
	#instVars : [
		'displayedStructure',
		'dontUpdateOnSelect'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #commands }
PRAdminNavigator >> addableChildStructureClassesFor: aContext [
	| addableChildStructureClasses |
	addableChildStructureClasses := PRStructure withAllConcreteClasses select: [ :each |
		(aContext structure class canBeParentOf: each)
			and: [ each canBeChildOf: aContext structure class ] ].
	
	addableChildStructureClasses := addableChildStructureClasses select: [ :class |
		aContext structure securityDecoration
			hasPermission: (PUAddPermission
				on: PRAddCommand structure: class)
			for: aContext user ].
	
	"reject PRFile as file uploads dont work in the admin interface as ajax doesnt support
	multipart file uploads. Instead the WYSIWYG editor allows file uploads via hidden iframe"	
	^ addableChildStructureClasses reject: [ :each | each name = PRFile name ]
]

{ #category : #announcing }
PRAdminNavigator >> announcementRegister [
	self session pierAdminAnnouncer on: PRAdminAjaxUpdate do: [ :ajaxUpdate |
		self displayedStructure ~= self context structure ifTrue: [
			self setNavigatorSelectionToCurrentStructureOn: ajaxUpdate script.
			self displayedStructure: self context structure ] ]
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuAddSubmenuFor: structure populate: menuCollection [
	| menuItem |
	menuItem := JSTreeContextMenuItem label: 'Add'.
	(self addableChildStructureClassesFor: (self context structure: structure)) do: [ :each |
		| childMenuItem |
		childMenuItem := JSTreeContextMenuItem label:  each label.
		childMenuItem action: [ :s |
			| addCommand |
			"pier part; create the structure"
			addCommand := PRAddCommand new
				setContext: (self context structure: structure);
				type: each;
				doExecute;
				yourself.
			self context: addCommand successAnswer.
			
			"javascript part; create a new node in the tree"
			s << (s jQuery: #navigator) tree 
				createNode: (s jQuery id: (self convertStructureToId: structure)) 
				position: 'last' 
				node: (self createNodeFor: addCommand successAnswer structure)
				jsCreationCallback: nil 
				skipRename: true.
			self dontUpdateOnSelect: true.
			self announceAjaxUpdate: s ].
		menuItem submenu addMenuItem: childMenuItem ].
	menuCollection addMenuItem: menuItem.
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuCallbackFor: structure populate: menuCollection [
	self contextMenuItems do: [ :each |
		 self perform: each with: structure with: menuCollection ]
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuCommand: command for: structure populate: menuCollection [
	| commandMenu |
	(command isValidIn: self context) ifFalse: [ ^ self ].

	commandMenu := JSTreeContextMenuItem label: command label.
	commandMenu action: [ :s | 
		self context: (self context structure: structure command: command new).
		self announceAjaxUpdateWithoutSelfOn: s ].
	menuCollection addMenuItem: commandMenu.
	
	^ commandMenu

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuCopyFor: structure populate: menuCollection [
	self contextMenuCommand: PRCopyCommand for: structure populate: menuCollection

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuEditFor: structure populate: menuCollection [
	| menuItem |

	menuItem := self contextMenuCommand: PREditCommand for: structure populate: menuCollection.
	menuItem separatorAfter: true.

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuGroupFor: structure populate: menuCollection [
	self contextMenuCommand: PUChangeGroup for: structure populate: menuCollection

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuItems [
	^ #(contextMenuEditFor:populate:  contextMenuAddSubmenuFor:populate: contextMenuRenameFor:populate: contextMenuRemoveFor:populate:  contextMenuCopyFor:populate: contextMenuOrderFor:populate: contextMenuSettingsFor:populate: contextMenuOwnerFor:populate: contextMenuGroupFor:populate: contextMenuOtherFor:populate: )
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuOrderFor: structure populate: menuCollection [
	self contextMenuCommand: PROrderCommand for: structure populate: menuCollection

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuOtherFor: structure populate: menuCollection [
	self contextMenuCommand: PUChangeOther for: structure populate: menuCollection

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuOwnerFor: structure populate: menuCollection [
	
	self contextMenuCommand: PUChangeOwner for: structure populate: menuCollection

]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuRemoveFor: structure populate: menuCollection [
	| commandMenu |
	commandMenu := JSTreeContextMenuItem label: PRRemoveCommand label.
	commandMenu action: [ :s | 
		self context: (self context structure: structure command: 
			(PRAdminRemoveCommand 
				idOfTreeNodeToRemove: (self convertStructureToId: structure)
				pierAdminAnnouncer: self session pierAdminAnnouncer)).
		self announceAjaxUpdateWithoutSelfOn: s ].
	menuCollection addMenuItem: commandMenu.
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuRenameFor: structure populate: menuCollection [
	| menuItem |
	
	menuItem := JSTreeContextMenuItem label: 'Rename'.
	"equivalent to: '$(''#navigator'').jstree(''rename'', ''#''+node.attr(''id''))'   - perhaps it would be simpler to use the string directly!!"
	menuItem action: (((JQueryInstance new id: #navigator) tree action: 'rename' arguments: (Array with: ((JQueryInstance new alias: '"#" + node') attributeAt: 'id' ))) asFunction: #(node)). 
	menuCollection addMenuItem: menuItem.
]

{ #category : #'context menu' }
PRAdminNavigator >> contextMenuSettingsFor: structure populate: menuCollection [
	| menuItem |

	menuItem := self contextMenuCommand: PRSettingsCommand for: structure populate: menuCollection.
	menuItem separatorAfter: true.
	

]

{ #category : #private }
PRAdminNavigator >> convertStructureToId: structure [
	| path |
	path := structure absolutePath.
	"path slashes '/' arent allowed in html element ids. Convert '/' to '-_', use '-' in front of root to help uniqueness"
	^ String streamContents: [ :stream |
		stream nextPutAll: '-_'.
		(path subStrings: '/') do: [ :pathElement |
			stream nextPutAll: pathElement ]
			separatedBy: [ stream nextPutAll: '-_' ] ]
]

{ #category : #private }
PRAdminNavigator >> createNodeFor: aStructure [
	^ JSTreeNode new
		id: (self convertStructureToId: aStructure);
		title: (aStructure isRoot ifTrue: [ '/' ] ifFalse: [ aStructure name ]);
		attributes: (GRSmallDictionary new at: 'title' put:  aStructure title; yourself);
		metadata:
			(GRSmallDictionary new
				at: 'absolutePath' put: aStructure absolutePath;
				yourself);
		"If children isn't defined here, the tree will lazily load as nodes are opened via Ajax. 
		Instead the complete tree is initially defined and sent to the client. Why? It simplifies 
		highlighting arbitary nodes including opening intermediate parent nodes"
		children: (self createNodesFor: aStructure enumerator);
		yourself
]

{ #category : #private }
PRAdminNavigator >> createNodesFor: aStructureCollection [
	^ aStructureCollection collect: [ :each | self createNodeFor: each ]
]

{ #category : #accessing }
PRAdminNavigator >> displayedStructure [
	^ displayedStructure ifNil: [ displayedStructure := self root ]
]

{ #category : #accessing }
PRAdminNavigator >> displayedStructure: anObject [
	^ displayedStructure := anObject
]

{ #category : #accessing }
PRAdminNavigator >> dontUpdateOnSelect [
	^ dontUpdateOnSelect ifNil: [ dontUpdateOnSelect := false ]
]

{ #category : #accessing }
PRAdminNavigator >> dontUpdateOnSelect: anObject [
	dontUpdateOnSelect := anObject
]

{ #category : #private }
PRAdminNavigator >> initiallyOpen [
	^ Array with: (self convertStructureToId: self root)
]

{ #category : #testing }
PRAdminNavigator >> isSameStructureSelected: structure [
	^ self context structure = structure
]

{ #category : #rendering }
PRAdminNavigator >> nodeSelectedCallbackFor: structure on: script [
	self dontUpdateOnSelect ifTrue: [ 
		self dontUpdateOnSelect: false. 
		^ self ].
	
	(self isSameStructureSelected: structure) ifTrue: [	
		^ self ].
	
	self context: (self context structure: structure). 
	self announceAjaxUpdateWithoutSelfOn: script
]

{ #category : #'context menu' }
PRAdminNavigator >> renameCallbackNewName: newName structure: structure on: script [
	| oldjQueryNodeId newJQueryNodeId |
	newName = structure name ifTrue: [
		^ self ].
	
	(PRPath isValidName: newName) ifFalse: [ 
		script << 
			(JSStream on: 'renameError(''Rename failed. The new name: "', newName, '", contains invalid characters.'')').
		^ self ].
		
	structure parent childrenDecoration at: newName ifPresent: [ :childStructure |
		 script << 
			(JSStream on: 'renameError(''Renamed failed. The new name: "', newName, '", is the same name as an existing element.'')').
		^ self ].
		
	oldjQueryNodeId := self convertStructureToId: structure.
	
	structure name: newName.
	
	newJQueryNodeId := self convertStructureToId: structure.
	
	script << (script jQuery id: oldjQueryNodeId) attributeAt: 'id' put: newJQueryNodeId.
	script << (script jQuery id: newJQueryNodeId) dataAt: 'absolutePath'  put: structure absolutePath
]

{ #category : #rendering }
PRAdminNavigator >> renderContentOn: html [
	self renderNavigatorTreeOn: html.
	self renderRefreshButtonOn: html.
	self renderRenameJsSupportOn: html
]

{ #category : #rendering }
PRAdminNavigator >> renderNavigatorTreeOn: html [
	html div
		id: #navigator;
		script:
			((html jQuery this tree)
				plugins: #('json_data' 'types' 'themes' 'ui' 'contextmenu' 'crrm');
				childrenBlock: [ :node | 
					| aStructure |
					aStructure := self retrieveStructureFrom: node.
					self createNodesFor: aStructure enumerator ]
				rootNodes: [ self createNodeFor: self root ];
				selectBlock: [ :event :script | 
					self nodeSelectedCallbackFor: (self retrieveStructureFrom: event node) on: script ];
				contextMenuBlock: [ :node :menuCollection |
					self contextMenuCallbackFor: (self retrieveStructureFrom: node) populate: menuCollection ];
				renameBlock: [ :renameEvent :script |
					self renameCallbackNewName: renameEvent title structure: (self retrieveStructureFrom: renameEvent node) on: script ];
				selectLimit: 1;
				initiallyOpen: self initiallyOpen;
				initiallySelected: self initiallyOpen).
	
]

{ #category : #'context menu' }
PRAdminNavigator >> renderRefreshButtonOn: html [
	html form
		id: #refreshNavigator;
		with: [
			html button
				bePush;
				onClick: (html jQuery ajax script: [ :s | s << (s jQuery: #navigator) replaceWith: [ : r | self renderNavigatorTreeOn: r ] ]);
				with: 'Refresh Navigator' ]
]

{ #category : #rendering }
PRAdminNavigator >> renderRenameJsSupportOn: html [
	html script:
		((((html javascript alert: (JSStream on: 'message')),
		(JSStream on: '$.jstree.rollbackLast()'))
		asFunction: #(message elementId)) 
		assignLocalTo: 'renameError'). 
]

{ #category : #private }
PRAdminNavigator >> retrieveStructureFrom: aJSTreeNode [ 
	| absolutePath path |
	absolutePath := aJSTreeNode metadata at: 'absolutePath'.
	path := self root lookupPath: absolutePath ifAbsent: [ self error: 'cannot retrieve structure for path: "', absolutePath,  '"' ].
	^ path
]

{ #category : #private }
PRAdminNavigator >> root [
	^ self context root
]

{ #category : #'ajax update' }
PRAdminNavigator >> setNavigatorSelectionToCurrentStructureOn: s [
	"ensure the current structure's node is selected:"
	s << (s jQuery: #navigator) tree select: (s jQuery id: (self convertStructureToId: self context structure)) check: true.
	"unfortunately selecting a node causes a select event - which calls us back. Potentially this could cause an infinate callback-response loop.
	to avoid this the select block ajax update doesnt update the navigator ie avoid calling this method. Also if the selected node in the callback
	is the same contexts structure then no ajax updating is performed"
]

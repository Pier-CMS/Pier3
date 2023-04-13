"
I am an abstract structure, representing the model of a single page. I've got a name, that must be unique within the scope of my parent, and a title. A structure is identified with a path of structure names.
"
Class {
	#name : #PRStructure,
	#superclass : #PRDecorated,
	#instVars : [
		'parent',
		'name',
		'title',
		'tags'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #testing }
PRStructure class >> canBeChildOf: aStructureClass [
	^ true
]

{ #category : #testing }
PRStructure class >> canBeParentOf: aStructureClass [
	^ true
]

{ #category : #testing }
PRStructure class >> isAbstract [
	^false
]

{ #category : #'instance creation' }
PRStructure class >> named: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #comparing }
PRStructure >> = anotherPage [

	self == anotherPage ifTrue: [ ^ true ].
	self species = anotherPage species ifFalse: [ ^ false ].
	(self parent isNil or: [ anotherPage parent isNil ]) ifTrue: [ 
		^ self document = anotherPage document and: [ self name = anotherPage name ] ].
	^ self parent = anotherPage parent and: [ self name = anotherPage name ]
]

{ #category : #'querying-path' }
PRStructure >> absolutePath [
	"Answer an absolute path from the root to the receiver."

	^ PRPathReference to: self
]

{ #category : #visiting }
PRStructure >> accept: aVisitor [
	aVisitor visitStructure: self
]

{ #category : #actions }
PRStructure >> addChild: aStructure [
	"Add ==aStructure== as child to the receiver."

	^ self childrenDecoration add: aStructure
]

{ #category : #'querying-path' }
PRStructure >> applicationUrl [
	| url aRequestContext |
	aRequestContext := WACurrentRequestContext value.
	url := aRequestContext application url copy.
	url addToPath: self absolutePath.
	
	^ url
]

{ #category : #testing }
PRStructure >> canBeChildOf: aStructure [
	"Answer ==true== if the receiver can be a child of ==aStructure==."

	^ self class canBeChildOf: aStructure class
]

{ #category : #testing }
PRStructure >> canBeParentOf: aStructure [
	"Answer ==true== if the receiver can be a parent of ==aStructure==."

	^ self class canBeParentOf: aStructure class
]

{ #category : #decorations }
PRStructure >> childrenDecoration [
	"Answer a decoration with the children of the receiver. If no children exist, an empty children decoration is added to the receiver. Don't call this method directly to avoid empty children decorations."

	^ self
		decorationOfClass: self childrenDecorationClass
		ifAbsent: [ self addDecoration: self childrenDecorationClass new ]
]

{ #category : #decorations }
PRStructure >> childrenDecorationClass [
	^ PRChildren
]

{ #category : #'accessing-commands' }
PRStructure >> defaultChildClass [
	"Answer the class of the structure that should be selected by default when adding children."
	
	^ PRPage
]

{ #category : #'accessing-commands' }
PRStructure >> defaultChildName [
	^ 'untitled'
]

{ #category : #'accessing-commands' }
PRStructure >> defaultCommandClass [
	^ self viewCommandClass
]

{ #category : #'accessing-description' }
PRStructure >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		beSearchable;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PRStructure >> descriptionTags [
	<magritteDescription>
	^ MATokenDescription new
		parameterName: 'tags';
		accessor: #tags;
		beSearchable;
		label: 'Tags';
		priority: 30;
		yourself
]

{ #category : #'accessing-description' }
PRStructure >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'title';
		accessor: #title;
		beSearchable;
		priority: 100;
		label: 'Title';
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-dynamic' }
PRStructure >> document [
	"Answer a default document to represent the receiver, by default just embed itself."

	^ PRInternalLink new
		embedded: true;
		reference: '.';
		owner: self;
		target: self;
		yourself
]

{ #category : #'accessing-commands' }
PRStructure >> editCommandClass [
	"Answer an instance of the default edit command of the receiver."

	^ PREditCommand
]

{ #category : #'accessing-description' }
PRStructure >> editDescription [
	"Answer the descriptions that edit the receiver."

	^ self magritteDescription select: [ :each | each isEditable ]
]

{ #category : #'querying-relations' }
PRStructure >> enumerator [
	"Answer an enumerator on the children of the receiver."

	^ PRChildrenVisitor on: self
]

{ #category : #querying }
PRStructure >> findAncestor: aConditionBlock [
	"Find the first structure starting at the receiver going up the parent chain, that satisfies the condition in aConditionBlock. Answer nil, if not present."
	
	^ self findAncestor: aConditionBlock ifAbsent: [ nil ]
]

{ #category : #querying }
PRStructure >> findAncestor: aConditionBlock ifAbsent: anAbsentBlock [
	"Find the first structure starting at the receiver going up the parent chain, that satisfies the condition in aConditionBlock. Evaluate anAbsentBlock, if not present."
	
	| current |
	current := self.
	[ (aConditionBlock value: current)
		ifTrue: [ ^ current ].
	  (current := current parent) isNil ]
			whileFalse.
	^ anAbsentBlock value
]

{ #category : #'querying-relations' }
PRStructure >> fullTextSearch [
	"Answer a visitor searching for text starting at the receiver."

	^ PRFullTextSearch on: self
]

{ #category : #testing }
PRStructure >> hasChildren [
	"Answer ==true== if the receiver has got children, they might not be visible however."

	self enumerator 
		do: [ :each | ^ true ].
	^ false
]

{ #category : #testing }
PRStructure >> hasDocument [
	"Answer wether the receiver has a changable document."

	^ false
]

{ #category : #testing }
PRStructure >> hasParent [
	"Answer ==true== if the receiver has got a parent. This is the negation of ==#isRoot==."

	^ self parent notNil
]

{ #category : #'as yet unclassified' }
PRStructure >> hash [

	self parent isNil
		ifTrue: [ ^ super hash bitXor: self contents hash ]
		ifFalse: [ 
		^ (super hash bitXor: self parent hash) bitXor: self name hash ]
]

{ #category : #'querying-relations' }
PRStructure >> incomingReferences [
	"Answer a visitor on incoming references to structures being specified (using ==to:== and ==toAll:==) to the visitor before starting. The search will take off from the receiver."

	^ PRIncomingReferences on: self
]

{ #category : #testing }
PRStructure >> isAllowedCommand: aCommandClass in: aContext [
 	"Answer ==true== if the receiver accepts ==aCommandClass== as allowed in ==aContext== on the receiver. If a command class is allowed is a security question and should therefore only depend on the permissions in the current context. The default implementation delegates the decision to the decorations of the receiver. Therefor this method should never be overridden by subclasses."

	^ self decorations allSatisfy: [ :each |
		each
			isAllowedCommand: aCommandClass
			in: aContext ]
]

{ #category : #testing }
PRStructure >> isAncestorOf: aStructure [
	"Answer ==true== if the receiver is an ancestor of ==aStructure==."

	^ aStructure parents includes: self
]

{ #category : #testing }
PRStructure >> isApplyableCommand: aCommandClass in: aContext [
 	"Answer ==true== if the receiver accepts ==aCommandClass== as applyable in ==aContext== on the receiver. If a command class is applyable or not is a question of saneness and compatibility, not of security. This method should be overridden by subclasses who want to forbid some commands."

	^ self isKindOf: aCommandClass structureClass
]

{ #category : #testing }
PRStructure >> isFile [
	^ false
]

{ #category : #testing }
PRStructure >> isRoot [
	"Answer ==true== if the receiver is the root of the Pier model. This is the negation of ==#hasParent==."

	^ self parent isNil
]

{ #category : #testing }
PRStructure >> isValidCommand: aCommandClass in: aContext [
 	"Answer ==true== if the receiver accepts to execute ==aCommandClass== in ==aContext==. This message is the combination of ==#isApplyableCommand:in:== and ==#isAllowedCommand:in:==. It should not be overridden."

	^ (self isApplyableCommand: aCommandClass in: aContext)
		and: [ self isAllowedCommand: aCommandClass in: aContext ]
]

{ #category : #'accessing-dynamic' }
PRStructure >> kernel [
	"Answer the kernel of the receiver."

	| root |
	root := self root.
	^ PRKernel instances
		detect: [ :each | each root = root ]
		ifNone: [ self error: self title , ' is not part of a kernel.' ]
]

{ #category : #'accessing-dynamic' }
PRStructure >> level [
	"Answer the nesting level of the receiver, the root has a level of 1."

	| level current |
	level := 1.
	current := self.
	[ current isRoot ] whileFalse: [ 
		level := level + 1.
		current := current parent ].
	^ level
]

{ #category : #'querying-path' }
PRStructure >> lookupIncompletePath: aString [
	"Lookup the path ==aString== as far as possible and answer an association of the last structure and the failing path element."

	^ PRIncompletePathLookup start: self path: (aString ifNil: [ '.' ])
]

{ #category : #'querying-path' }
PRStructure >> lookupPath: aString [
	"Lookup the path ==aString== starting at the receiver, answer ==nil== in case the structure can't be found."
	
	^ self lookupPath: aString ifAbsent: [ nil ]
]

{ #category : #'querying-path' }
PRStructure >> lookupPath: aString ifAbsent: aBlock [
	"Lookup the path ==aString== starting at the receiver, evaluate ==aBlock== in case of an error."
	
	^ PRPathLookup start: self path: aString ifAbsent: aBlock
]

{ #category : #accessing }
PRStructure >> name [
	"Answer the name of the receiver. The name should be simple and only contain letters and numbers, since it is used as an identifier within restrictive protocols."

	^ name
]

{ #category : #accessing }
PRStructure >> name: aString [
	name := aString
]

{ #category : #'querying-relations' }
PRStructure >> outgoingReferences [
	"Answer a visitor on all outgoing references taking off at the receiver. The visited objects are instances of ==*PRInternalLink*==."

	^ PROutgoingReferences on: self
]

{ #category : #accessing }
PRStructure >> parent [
	"Answer the parent structure of the receiver."

	^ parent
]

{ #category : #accessing }
PRStructure >> parent: aStructure [
	parent := aStructure
]

{ #category : #'accessing-dynamic' }
PRStructure >> parents [
	"Answer an ordered collection of all the parents of the receiver up and including the receiver."
	
	| current result |
	current := self.
	result := OrderedCollection with: self.
	[ current isRoot ]
		whileFalse: [ result addFirst: (current := current parent) ].
	^ result
]

{ #category : #copying }
PRStructure >> postCopy [
	super postCopy.
	self parent: nil; tags: self tags copy.
	self magritteDescription do: [ :description |
		description isDocumentDescription ifTrue: [
			self
				write: (self readUsing: description) copy
				using: description ] ]
]

{ #category : #copying }
PRStructure >> postCopyTo: aStructure [
	self parent: aStructure
]

{ #category : #printing }
PRStructure >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' name: '; print: self name
]

{ #category : #'querying-path' }
PRStructure >> relativePathFrom: aStructure [
	"Answer a relative path from ==aStructure== to the receiver."
	
	^ aStructure relativePathTo: self
]

{ #category : #'querying-path' }
PRStructure >> relativePathTo: aStructure [
	"Answer a relative path from the receiver to ==aStructure==."
	
	^ PRPathReference from: self to: aStructure
]

{ #category : #actions }
PRStructure >> remove [
	"Remove the receiver from the parent structure."

	self parent childrenDecoration remove: self
]

{ #category : #'accessing-dynamic' }
PRStructure >> root [
	"Answer the root structure of the receiver."
	
	| current |
	current := self.
	[ current isRoot ]
		whileFalse: [ current := current parent ].
	^ current
]

{ #category : #deprecated }
PRStructure >> structDict [
	^ Dictionary new
]

{ #category : #deprecated }
PRStructure >> structDict: aDictionary [
	"Deprecated on 2017-Oct - structDict is no longer an instance variable."
]

{ #category : #deprecated }
PRStructure >> tag [
 ^ 	'default'
]

{ #category : #deprecated }
PRStructure >> tag: aTag [
	"Deprecated - tag is not an instance variable."
]

{ #category : #accessing }
PRStructure >> tags [
	"Answer a list of tags specific to the receiver."

	^ tags ifNil: [ tags := #() ]
]

{ #category : #accessing }
PRStructure >> tags: anArray [
	tags := anArray
]

{ #category : #accessing }
PRStructure >> title [
	"Answer the title of the receiver, essentially the name but starting uppercase."

	^ title ifNil: [ title := self name capitalized ]
]

{ #category : #accessing }
PRStructure >> title: aString [
	title := aString
]

{ #category : #testing }
PRStructure >> validateCommand: aCommand [
 	"Validates ==Command== to be executed within the context of the receiver. Throw an exception if there is something wrong with the command."

	self decorations do: [ :each | each validateCommand: aCommand ]
]

{ #category : #'accessing-commands' }
PRStructure >> viewCommandClass [
	"Answer the default view command of the receiver. Most likely you never need to change the default implementation."

	^ PRViewCommand
]

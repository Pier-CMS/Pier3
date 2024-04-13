"
I'm a command used to add new structures to your structures. My code is very interesting if you want to understand how Pier is designed.

Type is the class (subclass of PRStructure) for which a new instance will be created.
"
Class {
	#name : #PRAddCommand,
	#superclass : #PRCommand,
	#instVars : [
		'name',
		'type',
		'link',
		'title'
	],
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PRAddCommand class >> accessKey [
	^ $a
]

{ #category : #testing }
PRAddCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRAddCommand class >> label [
	^ 'Add'
]

{ #category : #private }
PRAddCommand >> child [
	"Create a new structure of the selected species, a subclass of PRStructure. Set the title if necessary, else it will be generated automatically."

	| child |
	child := self typeClass named: self name.
	(self title notNil and: [ self title notEmpty ]) ifTrue: [
		child title: self title ].
	^ child
]

{ #category : #'accessing-description' }
PRAddCommand >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		addCondition: (MACondition receiver: PRPath selector: #isValidName:) labelled: 'Invalid structure name';
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		priority: 100;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PRAddCommand >> descriptionType [

	<magritteDescription>
	^ MASingleOptionDescription new
		  options: (self structureClasses collect: [ :c | c name ]);
		  reference: MASymbolDescription new;
		  parameterName: 'type';
		  default: #PRPage;
		  accessor: #type;
		  label: 'Type';
		  priority: 110;
		  beRequired;
		  beSorted;
		  yourself
]

{ #category : #events }
PRAddCommand >> doExecute [
	"Create a new structure of requested type and add it to the children list of the current structure. If possible the following context will be set to an editor or a view onto the new structure."

	| structure |
	super doExecute.
	self structure
		addChild: (structure := self child).
	self link isNil
		ifFalse: [ self link target: structure; update ].
	structure editCommandClass isNil ifFalse: [ 
		self successAnswer: (self context
			structure: structure
			command: (structure editCommandClass new
				successAnswer: self successAnswer;
				cancelAnswer: self cancelAnswer;
				yourself)) ]
]

{ #category : #events }
PRAddCommand >> doValidate [
	"Verify that the new structure can be added before launching #doExecute. Basically, the name must be unique."

	super doValidate.
	self validateChild: self child in: self structure
]

{ #category : #accessing }
PRAddCommand >> link [
	^ link
]

{ #category : #accessing }
PRAddCommand >> link: aLink [
	link := aLink
]

{ #category : #accessing }
PRAddCommand >> name [
	^ name ifNil: [ name := self uniqueName: self structure defaultChildName in: self structure ]
]

{ #category : #accessing }
PRAddCommand >> name: aString [
	name := aString
]

{ #category : #private }
PRAddCommand >> structureClasses [
	| theContext |
	theContext := self context.
	^ PRStructure withAllConcreteClasses select: [ :each |
		(theContext structure class canBeParentOf: each)
			and: [ each canBeChildOf: theContext structure class ] ]
]

{ #category : #actions }
PRAddCommand >> suggestName: aString [
	"Suggest aString as the name and title of the newly created structure."

	self name: (aString collect: [ :char |
		(PRPath isValidCharacter: char)
			ifTrue: [ char asLowercase ]
			ifFalse: [
				Character space = char
					ifTrue: [ $- ]
					ifFalse: [ $_ ] ] ]).
	self title: aString capitalized
]

{ #category : #accessing }
PRAddCommand >> title [
	^ title
]

{ #category : #accessing }
PRAddCommand >> title: aString [
	title := aString
]

{ #category : #accessing }
PRAddCommand >> type [

	^ type ifNil: [ type := self structure defaultChildClass name ]


]

{ #category : #accessing }
PRAddCommand >> type: aSymbol [

	type := aSymbol
]

{ #category : #accessing }
PRAddCommand >> typeClass [

	^ Smalltalk at: self type
]

Class {
	#name : #PRComponent,
	#superclass : #PRStructure,
	#instVars : [
		'prototypeInstance',
		'link'
	],
	#category : #'Pier-Seaside-Model'
}

{ #category : #testing }
PRComponent class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRComponent class >> label [
	^ 'Component'
]

{ #category : #visiting }
PRComponent >> accept: aVisitor [
	aVisitor visitComponent: self
]

{ #category : #'accessing-dynamic' }
PRComponent >> component [
	"Answer a new instance of the Seaside component."

	^ self componentFor: self document
]

{ #category : #accessing }
PRComponent >> componentClass [
	"Answer the component class of the receiver. The default is an empty Seaside component to avoid any troubles."

	^ (self prototypeInstance isNil or: [ self prototypeInstance class isObsolete ])
		ifFalse: [ self prototypeInstance class ]
		ifTrue: [ WAComponent ]
]

{ #category : #accessing }
PRComponent >> componentClass: aComponentClass [
	self prototypeInstance class = aComponentClass ifTrue: [ ^ self ].
	self flush.
	
	self prototypeInstance: aComponentClass new.

]

{ #category : #accessing }
PRComponent >> componentClasses [
	| sortBlock |
	sortBlock := [ :a :b | 
		a groupLabel = b groupLabel
			ifTrue: [ a label < b label ]
			ifFalse: [ a groupLabel < b groupLabel ] ].
	^ ((PRWidget allSubclasses reject: [ :each | each isAbstract ]) asArray 
		sort: sortBlock;
		yourself) ,
	  ((WAComponent allSubclasses select: [ :each | each canBeRoot ]) asArray
		sort: sortBlock;
		yourself)
]

{ #category : #'accessing-description' }
PRComponent >> componentDescription [
	^ self componentDescription: self prototypeInstance

]

{ #category : #'accessing-description' }
PRComponent >> componentDescription: component [
	"Answer the description of the component."
	| description |
	description := component magritteDescription.
	description := description collect: [ :each | each copy ].
	description do: [ :each |
		each group isNil
			ifTrue: [ each group: 'Component' ] ].
	^ description
]

{ #category : #'accessing-dynamic' }
PRComponent >> componentFor: anInternalLink [
	"Answer a new instance of the Seaside component."

	^ self componentClass 
		owner: self link: anInternalLink
]

{ #category : #'magritte-description' }
PRComponent >> descriptionComponentClass [
	<magritteDescription>
	^ MASingleOptionDescription new
		options: self componentClasses;
		reference: MAClassDescription new;
		accessor: #componentClass;
		label: 'Component Class';
		groupBy: #groupLabel;
		priority: 200;
		beRequired;
		beEditable;
		yourself
]

{ #category : #accessing }
PRComponent >> document [
	^ link ifNil: [ link := super document ]
]

{ #category : #'accessing-description' }
PRComponent >> editDescription [
	^ self hasComponent
		ifFalse: [ super editDescription ]
		ifTrue: [
			MAContainer new
				addAll: ((self basicMagritteDescription
					copyWithout: self descriptionComponentClass)
					select: [ :each | each isEditable ]);
				add: (self descriptionComponentClass
					beReadonly;
					yourself);
				addAll: self componentDescription;
				yourself ]
]

{ #category : #'accessing-dynamic' }
PRComponent >> embeddedComponents [
	^ super embeddedComponents copyWith: self document
]

{ #category : #actions }
PRComponent >> flush [
	| context |
	context := PRCurrentContext value.
	context isNil ifFalse: [ context flushComponent: self ]
]

{ #category : #testing }
PRComponent >> hasComponent [
	^ self prototypeInstance notNil
]

{ #category : #accessing }
PRComponent >> initializeVisualComponentSettings: aComponent link: anInternalLink [
	"The components (or widgets) cannot carry their own configuration, because they are instantiated later on a per-session basis.
	 So the configuration is held within a generic model object - PRComponent - that takes a prototype instance  and uses the
	component's Magritte descriptions to copy the settings from the prototype into the session instantiated component. The settings
	can be overridden with the settings given in the link that embeds the component."
	
	(self componentDescription: aComponent) do: [ :description |
		| aValue |
		aValue := self prototypeInstance readUsing: description.
		aComponent initializeAttribute: description with: aValue overridWith: anInternalLink].

]

{ #category : #testing }
PRComponent >> isComponent [
	^ true
]

{ #category : #'accessing-description' }
PRComponent >> magritteDescription [
	^ (MAContainer withAll: super magritteDescription) 
		addAll: self componentDescription;
		yourself
]

{ #category : #copying }
PRComponent >> postCopy [
	super postCopy.
	prototypeInstance := prototypeInstance copy
]

{ #category : #accessing }
PRComponent >> prototypeInstance [
	^ prototypeInstance
]

{ #category : #accessing }
PRComponent >> prototypeInstance: anObject [
	prototypeInstance := anObject.
	
	self setOwnerOnPrototypeDocuments
]

{ #category : #private }
PRComponent >> readUsing: aDescription [
	"first check to see if ==aDescription== is a valid description on this PRComponent, if not
	check to see if ==aDescription== is a valid description on the prototypeInstance"
	^ (self basicMagritteDescription includes: aDescription)
		ifTrue: [ super readUsing: aDescription ]
		ifFalse: [ 
			(self prototypeInstance magritteDescription includes: aDescription) 
				ifTrue: [ self prototypeInstance readUsing: aDescription ] ]
]

{ #category : #accessing }
PRComponent >> setOwnerOnPrototypeDocuments [
	"Ensures that documents contained within the the prototype instance set  ==self== as the owner.
	This is the #prototypeInstance: equivalent of the #isDocumentDescription test in PRComponent>>#write:using:
	Setting the owner to ==self== appears to be important for links contained within the document."
	prototypeInstance magritteDescription do: [ :each |
		each isDocumentDescription ifTrue: [ 
			| document |
			document := (prototypeInstance readUsing: each).
			document isNil ifFalse: [
				document owner: self ] ] ]
]

{ #category : #'accessing-description' }
PRComponent >> settingsDescription [
	^ self hasComponent
		ifFalse: [ super settingsDescription ]
		ifTrue: [ 
			MAContainer new
				add: self descriptionComponentClass;
				addAll: (self basicMagritteDescription
					select: [ :each | each isSetting ]);
				yourself ]
]

{ #category : #private }
PRComponent >> write: anObject using: aDescription [
	(self basicMagritteDescription includes: aDescription)
		"the description is associated with PRComponent"
		ifTrue: [ super write: anObject using: aDescription ]
		ifFalse: [
			(anObject notNil and: [ aDescription isDocumentDescription ])
				ifTrue: [ anObject owner: self ].
				
			(self prototypeInstance magritteDescription includes: aDescription)
				ifTrue: [ self prototypeInstance write: anObject using: aDescription ]
				"if PRComponent and the prototypeInstance doesnt contain the description,
				perhaps a description has been injected into #magritteDescription
				that #basicMagritteDescription hasn't picked up."
				ifFalse: [ super write: anObject using: aDescription ] ]
]

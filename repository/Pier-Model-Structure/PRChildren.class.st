"
I hold the children of the decorated object.
"
Class {
	#name : #PRChildren,
	#superclass : #PRDecoration,
	#instVars : [
		'children'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #testing }
PRChildren class >> isAbstract [
	^ false
]

{ #category : #visiting }
PRChildren >> accept: aVisitor [
	aVisitor visitChildren: self
]

{ #category : #actions }
PRChildren >> add: aStructure [
	"Add ==aStructure== as a child to the receiver."
	
	(self isValidChild: aStructure)
		ifFalse: [ self error: aStructure title , ' is an invalid child in ' , self decorated title , '.' ].
	children := children 
		copyWith: (aStructure
			parent: self decorated;
			yourself).
	self triggerStructureAdded: aStructure.
	^ aStructure
]

{ #category : #'accessing-children' }
PRChildren >> at: aString [
	"Answer the child structure with the name ==aString==, raise an error if the child can't be found."

	^ self at: aString ifAbsent: [ self error: 'Child not found.' ]
]

{ #category : #'accessing-children' }
PRChildren >> at: aString ifAbsent: aBlock [
	"Answer the child structure with the name ==aString==, evaluate ==aBlock== if the child can't be found."

	^ children
		detect: [ :each | each name = aString ]
		ifNone: aBlock
]

{ #category : #'accessing-children' }
PRChildren >> at: aString ifPresent: aBlock [
	^ aBlock value: (self at: aString ifAbsent: [ ^ nil ])
]

{ #category : #'accessing-children' }
PRChildren >> children [
	"Answer an array of the receivers children."
	
	^ children
]

{ #category : #'accessing-children' }
PRChildren >> includes: aString [
	self at: aString ifAbsent: [ ^ false ].
	^ true
]

{ #category : #initialization }
PRChildren >> initialize [
	super initialize.
	self setChildren: OrderedCollection new
]

{ #category : #testing }
PRChildren >> isEmpty [
	^ children isEmpty
]

{ #category : #testing }
PRChildren >> isValidChild: aStructure [
	^ (PRPath isValidName: aStructure name)
		and: [ aStructure parent isNil
		and: [ (self includes: aStructure name) not
		and: [ (self decorated canBeParentOf: aStructure)
		and: [ (aStructure canBeChildOf: self decorated) ] ] ] ]
]

{ #category : #copying }
PRChildren >> postCopyTo: anObject [
	self setDecorated: anObject.
	children := children collect: [ :each | each copy postCopyTo: self decorated ]
]

{ #category : #accessing }
PRChildren >> priority [
	^ 200
]

{ #category : #actions }
PRChildren >> remove: aStructure [
	"Remove ==aStructure== from the receiver."

	| index |
	index := children 
		indexOf: aStructure 
		ifAbsent: [ ^ nil ].
	children := (children copyFrom: 1 to: index - 1) , 
		(children copyFrom: index + 1 to: children size).
	self triggerStructureRemoved: aStructure.
	self isEmpty
		ifTrue: [ self remove ].
	^ aStructure
		parent: nil;
		yourself
]

{ #category : #initialization }
PRChildren >> setChildren: anArray [
	children := anArray asArray
]

{ #category : #accessing }
PRChildren >> size [
	"Answer the number of children of the receiver."

	^ self children size
]

{ #category : #events }
PRChildren >> triggerStructureAdded: aStructure [
	PRDecoration withAllConcreteClassesDo: [ :each | each onStructureAdded: aStructure ]
]

{ #category : #events }
PRChildren >> triggerStructureRemoved: aStructure [
	PRDecoration withAllConcreteClassesDo: [ :each | each onStructureRemoved: aStructure ]
]

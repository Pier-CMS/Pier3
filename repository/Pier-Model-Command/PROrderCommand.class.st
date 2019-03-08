Class {
	#name : #PROrderCommand,
	#superclass : #PRCommand,
	#instVars : [
		'structures'
	],
	#category : #'Pier-Model-Command'
}

{ #category : #testing }
PROrderCommand class >> isAbstract [
	^ false
]

{ #category : #testing }
PROrderCommand class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure hasChildren ]
]

{ #category : #accessing }
PROrderCommand class >> label [
	^ 'Re-order children'
]

{ #category : #'accessing-description' }
PROrderCommand >> componentsOrStructures [
	| retVal |
	retVal := OrderedCollection new.
	retVal addAll: PRStructure withAllSubclasses.
	retVal addAll: PRWidget withAllSubclasses.
	^retVal
]

{ #category : #private }
PROrderCommand >> currentStructures [
	^ self structure enumerator contents
]

{ #category : #'accessing-description' }
PROrderCommand >> descriptionStructures [
	<magritteDescription>
	| aStructure |
	aStructure := self currentStructures anyOne.
	^ MAToManyRelationDescription new
		classes: self componentsOrStructures;
		reference:
				(MAContainer new
						add: aStructure descriptionTitle;
						add: aStructure descriptionName;
						yourself);
		accessor: #structures;
		label: 'Order';
		priority: 200;
		beDefinitive;
		beOrdered;
		yourself
]

{ #category : #events }
PROrderCommand >> doExecute [
	super doExecute.
	self structure childrenDecoration 
		setChildren: self structures
]

{ #category : #events }
PROrderCommand >> doValidate [
	"The order command needs to make sure that we don't loose added and that we don't reintroduce deleted structures. This code ensures that new structures are just a permutation of the existing ones."
	
	| prev next |
	super doValidate.
	prev := self currentStructures.
	next := structures copy.
	prev do: [ :each |
		(next includes: each)
			ifFalse: [ structures := structures copyWith: each ] ].
	next do: [ :each |
		(prev includes: each)
			ifFalse: [ structures := structures copyWithout: each ] ]
]

{ #category : #accessing }
PROrderCommand >> structures [
	^ structures ifNil: [ structures := self currentStructures ]
]

{ #category : #accessing }
PROrderCommand >> structures: aCollection [
	structures := aCollection
]

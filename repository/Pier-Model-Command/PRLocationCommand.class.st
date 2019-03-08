"
Abstract command to copy or move a structure.
"
Class {
	#name : #PRLocationCommand,
	#superclass : #PRCommand,
	#instVars : [
		'name',
		'target'
	],
	#category : #'Pier-Model-Command'
}

{ #category : #'accessing-defaults' }
PRLocationCommand >> defaultName [
	^ self structure name
]

{ #category : #'accessing-defaults' }
PRLocationCommand >> defaultTarget [
	^ self structure parent
]

{ #category : #'accessing-description' }
PRLocationCommand >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		addCondition: (MACondition receiver: PRPath selector: #isValidName:) labelled: 'Invalid structure name';
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		priority: 110;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PRLocationCommand >> descriptionTarget [
	<magritteDescription>
	^ PRStructureDescription new
		parameterName: 'target';
		accessor: #target;
		label: 'Target';
		priority: 100;
		beRequired;
		yourself
]

{ #category : #events }
PRLocationCommand >> doValidate [
	super doValidate.
	self validateChild: self structure named: self name in: self target
]

{ #category : #accessing }
PRLocationCommand >> name [
	^ name ifNil: [ name := self defaultName ]
]

{ #category : #accessing }
PRLocationCommand >> name: aString [
	name := aString
]

{ #category : #accessing }
PRLocationCommand >> target [
	^ target ifNil: [ target := self defaultTarget ]
]

{ #category : #accessing }
PRLocationCommand >> target: aStructure [
	target := aStructure
]

{ #category : #private }
PRLocationCommand >> updateLinksFor: aStructure [
	"Figure out all the structures that have a new location, then update all links pointing into the new location and update all links that go out of the new structures."
	
	| structures |
	structures := aStructure enumerator
		everything contents.
	aStructure root incomingReferences
		toAll: structures;
		do: [ :each | each update ].
	structures do: [ :structure |
		structure outgoingReferences
			do: [ :link | link update ] ]
]

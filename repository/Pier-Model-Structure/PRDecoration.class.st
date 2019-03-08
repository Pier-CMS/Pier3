"
I am an abstract decoration to add new behaviour and data to structures. Every decoration knows its owner, a subclass of *PRDecorated*. Decorations are considered to be equal if they are of the same species, but subclasses might want to refine this behaviour to be able to add multiple instances of the same class.

Within the owner decorations are ordered according to their priority. Decorations with a negative priority are visited before the owner, decorations with a positive one after the owner.
"
Class {
	#name : #PRDecoration,
	#superclass : #PRObject,
	#instVars : [
		'decorated'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #events }
PRDecoration class >> onStructureAdded: aStructure [
	"This event is called whenever a structure is added as a child to another structure."
]

{ #category : #events }
PRDecoration class >> onStructureRemoved: aStructure [
	"This event is called whenever a structure is removed as a child from another structure."
]

{ #category : #comparing }
PRDecoration >> <= aDecoration [
	^ self priority <= aDecoration priority
]

{ #category : #comparing }
PRDecoration >> = aDecoration [
	^ self species = aDecoration species
]

{ #category : #accessing }
PRDecoration >> decorated [
	"Answer the owner of the receiver, the decorated object."

	^ decorated
]

{ #category : #comparing }
PRDecoration >> hash [
	^ self species hash
]

{ #category : #testing }
PRDecoration >> isAllowedCommand: aCommandClass in: aContext [
 	"Answer ==true== if the receiver allows one to execute ==aCommandClass== in ==aContext==. The default decoration is fine with all the commands, subclasses might restrict to a selected set of commands within a given context. This method might be overridden by decorations that want to control the security."

	^ true
]

{ #category : #copying }
PRDecoration >> postCopy [
	super postCopy.
	self setDecorated: nil
]

{ #category : #copying }
PRDecoration >> postCopyTo: anObject [
	self setDecorated: anObject
]

{ #category : #accessing }
PRDecoration >> priority [
	"The default priority returns a number that defines in witch order the visitors will traverse through decorated objects. Negative numbers are visited before the decorated objects, positive numbers afterwards."

	^ self subclassResponsibility
]

{ #category : #utilities }
PRDecoration >> remove [
	self decorated notNil
		ifFalse: [ ^ self ].
	self decorated
		removeDecoration: self
		ifAbsent: [ ]
]

{ #category : #initialization }
PRDecoration >> setDecorated: aStructure [
	decorated := aStructure
]

{ #category : #testing }
PRDecoration >> validateCommand: aCommand [
 	"Validates ==Command== to be executed within the context of the receiver."
]

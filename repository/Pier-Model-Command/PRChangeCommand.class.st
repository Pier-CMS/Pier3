"
Abstract command to edit structures.
"
Class {
	#name : #PRChangeCommand,
	#superclass : #PRCommand,
	#instVars : [
		'fields'
	],
	#category : #'Pier-Model-Command'
}

{ #category : #events }
PRChangeCommand >> doExecute [
	super doExecute.
	self fields keysAndValuesDo: [ :desc :value | self target write: value using: desc ]
]

{ #category : #accessing }
PRChangeCommand >> fields [
	"Answer a dictionary mapping descriptions to their respective data fields."
	
	^ fields ifNil: [ fields := Dictionary new ]
]

{ #category : #copying }
PRChangeCommand >> postCopy [
	super postCopy.
	fields := fields copy
]

{ #category : #private }
PRChangeCommand >> readUsing: aDescription [
	^ self fields at: aDescription ifAbsent: [ self target readUsing: aDescription ]
]

{ #category : #accessing }
PRChangeCommand >> target [
	"The target where this edit operation is applied to."

	^ self structure
]

{ #category : #private }
PRChangeCommand >> write: anObject using: aDescription [
	self fields at: aDescription put: anObject
]

"
A simple persistency strategy remembering a configurable amount of the history.
"
Class {
	#name : #PRHistoryPersistency,
	#superclass : #PRPersistency,
	#instVars : [
		'history',
		'maxHistory'
	],
	#category : #'Pier-Model-Persistence'
}

{ #category : #actions }
PRHistoryPersistency >> add: aContext [
	history addLast: aContext copy sanitize.
	maxHistory isNil ifTrue: [ ^ self ].
	[ history size <= maxHistory ]
		whileFalse: [ history removeFirst ]
]

{ #category : #'accessing-descriptions' }
PRHistoryPersistency >> descriptionMaxHistory [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of history items to keep.';
		accessor: #maxHistory;
		label: 'Max History';
		default: 1024;
		priority: 100;
		beInteger;
		yourself
]

{ #category : #enumerating }
PRHistoryPersistency >> do: aBlock [
	history do: aBlock
]

{ #category : #actions }
PRHistoryPersistency >> execute: aCommand [
	self mutex critical: [
		self apply: aCommand.
		aCommand isLogged 
			ifTrue: [ self add: aCommand context ] ]
]

{ #category : #accessing }
PRHistoryPersistency >> maxHistory [
	^ maxHistory
]

{ #category : #accessing }
PRHistoryPersistency >> maxHistory: anInteger [
	"The maximum number of commands to keep."

	maxHistory := anInteger
]

{ #category : #enumerating }
PRHistoryPersistency >> reverseDo: aBlock [
	history reverseDo: aBlock
]

{ #category : #initialization }
PRHistoryPersistency >> setKernel: aKernel [
	super setKernel: aKernel.
	history := OrderedCollection new.
	(aKernel notNil and: [ aKernel persistency notNil ])
		ifTrue: [ aKernel persistency do: [ :each | self add: each ] ]
]

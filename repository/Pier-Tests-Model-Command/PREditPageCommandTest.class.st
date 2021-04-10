Class {
	#name : #PREditPageCommandTest,
	#superclass : #PREditCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PREditPageCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PREditPageCommandTest >> structureInstance [
	^ PRPage named: 'command'
]

{ #category : #'tests-contents' }
PREditPageCommandTest >> testContentsChanged [
	| document |
	document := PRPage new descriptionDocument
		fromString: '!foo'.
	self command
		write: document
		using: PRPage new descriptionDocument.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure document = document
]

{ #category : #'tests-contents' }
PREditPageCommandTest >> testContentsEscapeChanged [
	"This would fail if the fromString had a new line."

	| document |
	document := PRPage new descriptionDocument
		fromString: 'text $\{tag} text'.
	self command write: document using: PRPage new descriptionDocument.
	self shouldnt: [ self command execute ] raise: PRStructureError.
	self assert: self structure contents equals: 'text \$\{tag} text'
]

{ #category : #'tests-contents' }
PREditPageCommandTest >> testContentsInitialized [
	self assert: (self command readUsing: PRPage new descriptionDocument) = self structure document
]

{ #category : #'tests-contents' }
PREditPageCommandTest >> testContentsUnchanged [
	| document |
	document := self structure document.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure document = document
]

Class {
	#name : #PREditCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PREditCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PREditCommandTest >> actualClass [
	^ PREditCommand
]

{ #category : #'tests-testing' }
PREditCommandTest >> testIsEdit [
	self assert: self command isEdit
]

{ #category : #'tests-title' }
PREditCommandTest >> testTitleChanged [
	| title |
	self command
		write: (title := 'foo')
		using: PRPage new descriptionTitle.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure title = title
]

{ #category : #'tests-title' }
PREditCommandTest >> testTitleInitialized [
	self assert: (self command readUsing: PRPage new descriptionTitle) = self structure title
]

{ #category : #'tests-title' }
PREditCommandTest >> testTitleUnchanged [
	| title |
	title := self structure title.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure title = title
]

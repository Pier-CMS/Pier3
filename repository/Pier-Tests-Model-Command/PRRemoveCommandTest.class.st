Class {
	#name : #PRRemoveCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRRemoveCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRRemoveCommandTest >> actualClass [
	^ PRRemoveCommand
]

{ #category : #tests }
PRRemoveCommandTest >> testRemoveLeaf [
	self assert: (self kernel root childrenDecoration
		includes: self structure name).
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure parent isNil.
	self deny: (self kernel root childrenDecoration
		includes: self structure name)
]

{ #category : #tests }
PRRemoveCommandTest >> testRemoveNode [
	self structure
		addChild: (PRPage named: 'foo');
		addChild: (PRPage named: 'bar').
	self assert: (self kernel root childrenDecoration
		includes: self structure name).
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure parent isNil.
	self deny: (self kernel root childrenDecoration
		includes: self structure name)
]

{ #category : #tests }
PRRemoveCommandTest >> testRemoveRoot [
	context := self context
		structure: self kernel root
		command: self actualClass new.
	self
		should: [ context command execute ]
		raise: PRStructureError
]

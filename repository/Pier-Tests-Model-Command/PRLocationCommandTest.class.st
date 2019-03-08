Class {
	#name : #PRLocationCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRLocationCommandTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRLocationCommandTest >> actualClass [
	^ PRLocationCommand
]

{ #category : #tests }
PRLocationCommandTest >> testConflict [
	self command name: 'folder'.
	self
		should: [ self command execute ]
		raise: PRConflictingNameError
]

{ #category : #tests }
PRLocationCommandTest >> testInitialized [
	self assert: self command target = self structure parent
]

Class {
	#name : #PRViewCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRViewCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRViewCommandTest >> actualClass [
	^ PRViewCommand
]

{ #category : #'tests-testing' }
PRViewCommandTest >> testIsLogged [
	self deny: self command isLogged
]

{ #category : #'tests-testing' }
PRViewCommandTest >> testIsView [
	self assert: self command isView
]

{ #category : #tests }
PRViewCommandTest >> testSimple [
	self
		should: [ self command execute ]
		raise: Error
]

Class {
	#name : #PRAddTaskCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Todo'
}

{ #category : #testing }
PRAddTaskCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRAddTaskCommandTest >> actualClass [
	^ PRAddTaskCommand
]

{ #category : #tests }
PRAddTaskCommandTest >> testNameSuggestion [
	command := self command title: 'Title has Spaces'.
	self assert: self command nameFromTitle = 'title-has-spaces'.
	command := self command title: 'Title has an&Ampersand'.
	self assert: self command nameFromTitle = 'title-has-an-ampersand'
]

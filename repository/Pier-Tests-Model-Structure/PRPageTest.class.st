Class {
	#name : #PRPageTest,
	#superclass : #PRCaseTest,
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRPageTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRPageTest >> actualClass [
	^ PRPage
]

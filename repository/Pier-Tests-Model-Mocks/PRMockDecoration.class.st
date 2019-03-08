Class {
	#name : #PRMockDecoration,
	#superclass : #PRDecoration,
	#instVars : [
		'priority'
	],
	#category : #'Pier-Tests-Model-Mocks'
}

{ #category : #testing }
PRMockDecoration class >> isAbstract [
	^ false
]

{ #category : #comparing }
PRMockDecoration >> = aDecoration [
	^ super = aDecoration
		and: [ self priority = aDecoration priority ]
]

{ #category : #comparing }
PRMockDecoration >> hash [
	^ super hash bitXor: self priority hash
]

{ #category : #accessing }
PRMockDecoration >> priority [
	^ priority
]

{ #category : #accessing }
PRMockDecoration >> priority: anInteger [
	priority := anInteger
]

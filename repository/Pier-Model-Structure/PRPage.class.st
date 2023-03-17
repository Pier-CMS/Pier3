"
I am the most important class of the structure hierarchy.
"
Class {
	#name : #PRPage,
	#superclass : #PRCase,
	#category : #'Pier-Model-Structure'
}

{ #category : #testing }
PRPage class >> isAbstract [
	^ false
]

{ #category : #comparing }
PRPage >> = anotherPage [

	self == anotherPage ifTrue: [ ^ true ].
	self species = anotherPage species ifFalse: [ ^ false ].
	^ self contents = anotherPage contents
]

{ #category : #visiting }
PRPage >> accept: aVisitor [
	aVisitor visitPage: self
]

{ #category : #'accessing-configuration' }
PRPage >> defaultDocument [
	^ super defaultDocument
		add: (PRParagraph new
			add: (PRText content: 'Edit this page ...');
			yourself);
		yourself
]

{ #category : #comparing }
PRPage >> hash [

	^ super hash bitXor: self contents hash
]

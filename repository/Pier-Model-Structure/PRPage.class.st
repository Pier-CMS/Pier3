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
	(self parent isNil or: [ anotherPage parent isNil ]) ifTrue: [ 
		^ self document = anotherPage document and: [ self name = anotherPage name ] ].
	^ self parent = anotherPage parent and: [ self name = anotherPage name ]
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

	self parent isNil
		ifTrue: [ ^ super hash bitXor: self contents hash ]
		ifFalse: [ 
		^ (super hash bitXor: self parent hash) bitXor: self name hash ]
]

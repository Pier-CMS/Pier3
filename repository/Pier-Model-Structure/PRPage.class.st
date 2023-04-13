"
I am the most important class of the structure hierarchy.
"
Class {
	#name : #PRPage,
	#superclass : #PRCase,
	#category : #'Pier-Model-Structure'
}

{ #category : #comparing }
PRPage class >> = aPrPageClass [

	^ super = aPrPageClass or: [ 
		  self species = aPrPageClass species and: [ 
			  self name = aPrPageClass name ] ]
]

{ #category : #comparing }
PRPage class >> hash [

	^ super hash bitXor: self name hash
]

{ #category : #testing }
PRPage class >> isAbstract [
	^ false
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

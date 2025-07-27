"
I am an important class for Wikis - A page has a title and contents.
"
Class {
	#name : #PRPage,
	#superclass : #PRCase,
	#category : #'Pier-Model-Structure'
}

{ #category : #comparing }
PRPage class >> = aPrPageClass [
	"This is needed so PRPage is an option when creating an object from a link."

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

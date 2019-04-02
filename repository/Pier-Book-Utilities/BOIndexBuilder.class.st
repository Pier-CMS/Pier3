Class {
	#name : #BOIndexBuilder,
	#superclass : #PRVisitor,
	#instVars : [
		'index'
	],
	#category : #'Pier-Book-Utilities'
}

{ #category : #testing }
BOIndexBuilder class >> isAbstract [
	^ false
]

{ #category : #visiting }
BOIndexBuilder >> start: anObject [
	index := Dictionary new.
	super start: anObject.
	^ index
]

{ #category : #'visiting-structure' }
BOIndexBuilder >> visitChildren: aDecoration [
	self visitAll: aDecoration children
]

{ #category : #'visiting-document' }
BOIndexBuilder >> visitIndexLink: aLink [
	(index at: aLink entries first ifAbsentPut: [ OrderedCollection new ])
		addLast: aLink owner
]

{ #category : #'visiting-structure' }
BOIndexBuilder >> visitStructure: aStructure [
	aStructure magritteDescription do: [ :each |
		each isDocumentDescription
			ifTrue: [ self visit: (aStructure readUsing: each) ] ]
]

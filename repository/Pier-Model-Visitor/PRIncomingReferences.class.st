"
I am a pluggable visitor to detect incoming references.

!Example
The following example opens inspectors on all instances of ==*PRInternalLink*== that point ==aStructure==:
=aStructure incomingReferences 
=	from: aRootStructure
=	to: aStructure
=	do: [ :each | each inspect ]
"
Class {
	#name : #PRIncomingReferences,
	#superclass : #PREnumerableVisitor,
	#instVars : [
		'structures'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #testing }
PRIncomingReferences class >> isAbstract [
	^ false
]

{ #category : #initialization }
PRIncomingReferences >> initialize [
	super initialize.
	structures := Set new
]

{ #category : #accessing }
PRIncomingReferences >> to: aStructure [
	structures add: aStructure
]

{ #category : #accessing }
PRIncomingReferences >> toAll: aCollection [
	structures addAll: aCollection
]

{ #category : #'visiting-decoration' }
PRIncomingReferences >> visitChildren: anObject [
	self visitAll: anObject children
]

{ #category : #'visiting-document' }
PRIncomingReferences >> visitInternalLink: anObject [
	(structures includes: anObject target)
		ifTrue: [ block value: anObject ]
]

{ #category : #'visiting-structure' }
PRIncomingReferences >> visitStructure: aStructure [
	aStructure magritteDescription do: [ :each |
		each isDocumentDescription
			ifTrue: [ self visit: (aStructure readUsing: each) ] ]
]

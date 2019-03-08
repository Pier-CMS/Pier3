"
I am a pluggable visitor visiting and probably following outgoing references. To do so I visit all the links of the page and evaluate my pluggable block for each of them. If the ==continue== block answers ==true== I follow the link and continue visiting the references of the target structure. The default behavior of the ==continue== block is to follow the link only if it is embedded. I take care not to run into infinite recursion, so no structure will be visited more than once.

!Examples
The following example answers a collection of referenced pages from ==aStructure==:

=(aStructure outgoingReferences
=	collect: [ :each | each target ])
=		asSet
		
The following example answers a collection of all broken references that can be reached from ==aStructure==:

=aStructure outgoingReferences
=	continue: [ :each | each isBroken not ];
= 	collect: [ :each | each isBroken ]
"
Class {
	#name : #PROutgoingReferences,
	#superclass : #PREnumerableVisitor,
	#instVars : [
		'continue',
		'structures'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #testing }
PROutgoingReferences class >> isAbstract [
	^ false
]

{ #category : #accessing }
PROutgoingReferences >> continue: aBlock [
	"A block to decide if the visitor should visit the structure referenced by the link passed into aBlock or not."

	continue := aBlock
]

{ #category : #initialization }
PROutgoingReferences >> initialize [
	super initialize.
	continue := [ :each | each isEmbedded and: [ each isBroken not ] ]
]

{ #category : #visiting }
PROutgoingReferences >> start: anObject [
	structures := Set new.
	super start: anObject
]

{ #category : #'visiting-document' }
PROutgoingReferences >> visitInternalLink: anObject [
	super visitInternalLink: anObject.
	(anObject target isNil or: [ structures includes: anObject target ])
		ifTrue: [ ^ self ].
	(continue value: anObject)
		ifTrue: [ self visit: anObject target ]
]

{ #category : #'visiting-document' }
PROutgoingReferences >> visitLink: anObject [
	block value: anObject
]

{ #category : #'visiting-structure' }
PROutgoingReferences >> visitStructure: aStructure [
	structures add: aStructure.
	aStructure magritteDescription do: [ :each |
		each isDocumentDescription
			ifTrue: [ self visit: (aStructure readUsing: each) ] ]
]

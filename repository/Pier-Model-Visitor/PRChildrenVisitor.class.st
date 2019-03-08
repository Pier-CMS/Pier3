Class {
	#name : #PRChildrenVisitor,
	#superclass : #PREnumerableVisitor,
	#instVars : [
		'with',
		'all',
		'sortBlock'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #testing }
PRChildrenVisitor class >> isAbstract [
	^ false
]

{ #category : #actions }
PRChildrenVisitor >> all [
	"Tell the receiver to visit structures recursively."

	all := true
]

{ #category : #actions }
PRChildrenVisitor >> everything [
	"Tell the receiver to visit everything."

	with := all := true
]

{ #category : #initialization }
PRChildrenVisitor >> initialize [
	super initialize.
	with := all := false
]

{ #category : #accessing }
PRChildrenVisitor >> sortBlock: aBlock [
	sortBlock := aBlock
]

{ #category : #'visiting-decoration' }
PRChildrenVisitor >> visitChildren: aDecoration [
	(all or: [ structure = aDecoration decorated ])
		ifFalse: [ ^ self ].
	self visitAll: (sortBlock isNil 
		ifTrue: [ aDecoration children ]
		ifFalse: [ aDecoration children asSortedCollection: sortBlock ])
]

{ #category : #'visiting-structure' }
PRChildrenVisitor >> visitStructure: aStructure [
	(with or: [ structure ~= aStructure ])
		ifTrue: [ block value: aStructure ]
]

{ #category : #actions }
PRChildrenVisitor >> with [
	"Tell the receiver to visit the start structure as well."

	with := true
]

Class {
	#name : #BOReferenceLink,
	#superclass : #PRInternalLink,
	#category : #'Pier-Book-Utilities'
}

{ #category : #testing }
BOReferenceLink class >> isValidReference: aString [
	^ aString beginsWithSubCollection: 'ref:'
]

{ #category : #accessing }
BOReferenceLink class >> priority [
	^ 0
]

{ #category : #'instance creation' }
BOReferenceLink class >> reference: aString [
	^ super reference: (aString allButFirst: 4)
]

{ #category : #initialization }
BOReferenceLink class >> resetLinks [
	| link |
	"This used to be called on #initialize but caused problems on Gemstone
	I think it can probably be removed as it looks like a migration method
	from a previous version"
	PRValueLink allInstances do: [ :each |
		each selector = #bookReference: ifTrue: [ 
			link := self reference: 'ref:' , (each
				parameterAt: 'target'
				ifAbsent: [ '.' ]).
			link owner: each owner.
			each becomeForward: link ] ]
]

{ #category : #visiting }
BOReferenceLink >> accept: aVisitor [
	aVisitor visitReferenceLink: self
]

{ #category : #testing }
BOReferenceLink >> isEmbedded [
	^ false
]

{ #category : #accessing }
BOReferenceLink >> title [
	^ (self target notNil and: [ self target isFigure or: [ self target isPublication and: [ self target isBook not ] ] ])
		ifTrue: [ self target refLabel ]
		ifFalse: [ super title ]
]

Extension { #name : #WAUrl }

{ #category : #'*pier-seaside-mapping' }
WAUrl >> adaptToContext: aPierContext [
	path := aPierContext application url path copy.
	aPierContext structure parents allButFirst
		do: [ :each | self path add: each name ].
	aPierContext command updateUrl: self
]

{ #category : #'*pier-seaside-mapping' }
WAUrl >> purgeOtherFields [
	self queryFields keys do: [ :each |
		(self isSeasideField: each)
			ifFalse: [ self queryFields removeKey: each ifAbsent: [ ] ] ]
]

{ #category : #'*pier-seaside-mapping' }
WAUrl >> purgeSeasideFields [
	self queryFields keys do: [ :each |
		(self isSeasideField: each)
			ifTrue: [ self queryFields removeKey: each ifAbsent: [ ] ] ]
]

Extension { #name : #PRInternalLink }

{ #category : #'*pier-model' }
PRInternalLink >> isBroken [
	^ self target isNil
]

{ #category : #'*pier-model' }
PRInternalLink >> parameterAt: aName ifPresent: aBlock [
	"2015-Apr-25 - Not sure why this is missing, pier main page does not open without it."
	^ aBlock value: (self parameters at: aName ifAbsent: [ ^ nil ])
]

{ #category : #'*pier-model' }
PRInternalLink >> target [
	"Answer the referenced structure. Do a lookup, if we haven't cached a real object reference."

	(target isNil and: [ self owner notNil and: [ self reference notNil ] ])
		ifTrue: [ target := self owner lookupPath: self reference ifAbsent: [ nil ] ].
	^ target
]

{ #category : #'*pier-model' }
PRInternalLink >> target: aStructure [
	target := aStructure
]

{ #category : #'*pier-model' }
PRInternalLink >> title [
	^ self target isNil
		ifTrue: [ super title ]
		ifFalse: [ self target title ]
]

{ #category : #'*pier-model' }
PRInternalLink >> update [
	"This method will be sent to all the internal-links whenever the owner is renamed or moved to a different location in the structure tree. It automatically adjusts the receivers state, so that the reference still points to the right location and doesn't get broken. The method tries to keep relative and absolute links consistent, whenever possible."	

	| absolute |
	(self target isNil or: [ self owner isNil or: [ self target root ~~ self owner root ] ])
		ifTrue: [ ^ self ].
	absolute := self reference notNil
		and: [ self reference isEmpty not
		and: [ self reference first = PRPath pathDelimiter ] ].
	reference := absolute
		ifTrue: [ self target absolutePath ]
		ifFalse: [ self owner relativePathTo: self target ]
]

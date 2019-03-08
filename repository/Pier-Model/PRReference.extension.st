Extension { #name : #PRReference }

{ #category : #'*pier-model' }
PRReference >> embedded [
	^ #('True' 'TRUE' 'true' true) includes: (self parameters at: 'embedded' ifAbsent: [ ^ false ])
]

{ #category : #'*pier-model' }
PRReference >> embedded: aBoolean [
	aBoolean
		ifTrue: [ self parameters at: 'embedded' put: 'true' ]
		ifFalse: [ self parameters removeKey: 'embedded' ]
]

{ #category : #'*pier-model' }
PRReference >> isEmbedded [
	^ self embedded
]

{ #category : #'*pier-model' }
PRReference >> parameterAt: aStringValue ifAbsent: aBlock [
	^ parameters at: aStringValue ifAbsent: aBlock
]

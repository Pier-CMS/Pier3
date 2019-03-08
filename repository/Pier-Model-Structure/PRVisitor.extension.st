Extension { #name : #PRVisitor }

{ #category : #'*pier-model-structure' }
PRVisitor >> escape: anObject [
	(self propertyAt: 'escaper') value: anObject
]

{ #category : #'*pier-model-structure' }
PRVisitor >> hasEscaper [
	^ (self propertyAt: 'escaper' ifAbsent: [ nil ]) notNil
]

{ #category : #'*pier-model-structure' }
PRVisitor >> visitCase: anObject [
	self visitStructure: anObject
]

{ #category : #'*pier-model-structure' }
PRVisitor >> visitChildren: anObject [
]

{ #category : #'*pier-model-structure' }
PRVisitor >> visitFile: anObject [
	self visitStructure: anObject
]

{ #category : #'*pier-model-structure' }
PRVisitor >> visitPage: anObject [
	self visitCase: anObject
]

{ #category : #'*pier-model-structure' }
PRVisitor >> visitStructure: anObject [
]

{ #category : #'*pier-model-structure' }
PRVisitor >> withEscaper: aBlock [
	| old |
	old := self propertyAt: 'escaper' ifAbsent: [ nil ].
	self propertyAt: 'escaper' put: [ :value | ^ value ].
	^ aBlock
		ensure: [ self propertyAt: 'escaper' put: old ]
]

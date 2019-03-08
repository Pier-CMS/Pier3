Extension { #name : #MAVisitor }

{ #category : #'*pier-model-accessing' }
MAVisitor >> context [
	^ PRCurrentContext value
]

{ #category : #'*pier-model-accessing' }
MAVisitor >> context: aContext [
	PRCurrentContext value: aContext
]

{ #category : #'*pier-model-visiting-description' }
MAVisitor >> visitDocumentDescription: anObject [
	self visitMemoDescription: anObject
]

{ #category : #'*pier-model-visiting-description' }
MAVisitor >> visitStructureDescription: anObject [
	self visitElementDescription: anObject
]

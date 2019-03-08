Extension { #name : #MAStringWriter }

{ #category : #'*pier-model-visiting' }
MAStringWriter >> visitDocumentDescription: aDescription [
	aDescription writerClass 
		write: self object
		to: self stream
]

{ #category : #'*pier-model-visiting' }
MAStringWriter >> visitStructureDescription: aDescription [
	stream nextPutAll: self object absolutePath
]

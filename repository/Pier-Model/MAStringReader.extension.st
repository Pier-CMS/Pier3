Extension { #name : #MAStringReader }

{ #category : #'*pier-model-visiting' }
MAStringReader >> visitDocumentDescription: aDescription [
	self object: (aDescription parserClass parse: self stream)
]

{ #category : #'*pier-model-visiting' }
MAStringReader >> visitStructureDescription: aDescription [
	self object: (self context structure
		lookupPath: self contents
		ifAbsent: [ self error: 'Invalid path' ])
]

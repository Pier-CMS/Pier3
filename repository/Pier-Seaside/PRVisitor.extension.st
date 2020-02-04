Extension { #name : #PRVisitor }

{ #category : #'*Pier-Seaside-visiting-structure' }
PRVisitor >> visitComponent: anObject [
	self visitStructure: anObject
]

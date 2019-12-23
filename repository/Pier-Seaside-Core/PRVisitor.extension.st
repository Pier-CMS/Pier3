Extension { #name : #PRVisitor }

{ #category : #'*pier-seaside-visiting-structure' }
PRVisitor >> visitComponent: anObject [
	self visitStructure: anObject
]

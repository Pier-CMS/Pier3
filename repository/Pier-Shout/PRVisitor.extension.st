Extension { #name : #PRVisitor }

{ #category : #'*pier-shout' }
PRVisitor >> visitHighlightedCode: anObject [
	self visitPreformatted: anObject
]

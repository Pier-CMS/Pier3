Extension { #name : #PRVisitor }

{ #category : #'*pier-model-document' }
PRVisitor >> visitValueLink: anObject [
	"Visit value links as normal links, treating them as references causes them not to be displayed." 
	self visitLink: anObject
]

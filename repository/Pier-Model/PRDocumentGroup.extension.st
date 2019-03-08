Extension { #name : #PRDocumentGroup }

{ #category : #'*pier-model' }
PRDocumentGroup >> owner: anObject [
	super owner: anObject.
	self children do: [ :each | each owner: anObject ]
]

Extension { #name : #PRDocumentItem }

{ #category : #'*pier-model' }
PRDocumentItem >> owner [
	"Answer the object owning the receiver. The default implementation doesn't know about its owner and therefore always returns ==nil==."

	^ nil
]

{ #category : #'*pier-model' }
PRDocumentItem >> owner: anObject [
]

Extension { #name : #PRCase }

{ #category : #'*pier-tagcloud-descriptions' }
PRCase >> descriptionDocumentTagCloud: aDescription [
	<magritteDescription: #descriptionDocument>
	^ aDescription beTagCloud
]

{ #category : #'*pier-tagcloud-descriptions' }
PRCase >> descriptionPlainTextTagCloud: aDescription [
	<magritteDescription: #descriptionPlainText>
	^ aDescription beTagCloud
]

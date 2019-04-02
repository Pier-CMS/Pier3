Extension { #name : #PRDocumentItemTest }

{ #category : #'*pier-tests-model' }
PRDocumentItemTest >> testOwner [
	self assert: self instance owner isNil
]

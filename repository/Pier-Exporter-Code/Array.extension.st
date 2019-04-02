Extension { #name : #Array }

{ #category : #'*pier-exporter-code' }
Array >> codeOn: aStream [
	aStream nextPut: ${.
	self do: [ :each | each codeOn: aStream ] separatedBy: [ aStream nextPutAll: '. ' ].
	aStream nextPut: $}
]

Extension { #name : #Object }

{ #category : #'*pier-exporter-code' }
Object >> asCode [
	^ String streamContents: [ :stream | self codeOn: stream ]
]

{ #category : #'*pier-exporter-code' }
Object >> codeOn: aStream [
	self printOn: aStream
]

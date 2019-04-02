Extension { #name : #ByteArray }

{ #category : #'*pier-exporter-code' }
ByteArray >> codeOn: aStream [
	"have to replicate #printOn: code here as older images don't implement a sensible version of #printOn:"
	aStream nextPutAll: '(#('.
	self
		do: [ :each | each printOn: aStream ]
		separatedBy: [ aStream nextPut: $ ].
	aStream nextPutAll: ') asByteArray)'	
]

Extension { #name : #Symbol }

{ #category : #'*pier-exporter-code' }
Symbol >> codeOn: aStream [
	aStream << '#' << self
]

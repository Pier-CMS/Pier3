Extension { #name : #Collection }

{ #category : #'*pier-exporter-code' }
Collection >> codeOn: aStream [
	aStream << '#('.
	self do: [ :each | each codeOn: aStream ] separatedBy: [ aStream nextPutAll: ' '].
	aStream << ')'
]

Extension { #name : #GRCodecStream }

{ #category : #'*Pier-Seaside' }
GRCodecStream >> isEmpty [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	^ stream isEmpty
]

{ #category : #'*Pier-Seaside' }
GRCodecStream >> position [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	^ stream position
]

{ #category : #'*Pier-Seaside' }
GRCodecStream >> position: anInteger [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	stream position: anInteger
]

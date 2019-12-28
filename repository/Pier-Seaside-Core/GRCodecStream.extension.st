Extension { #name : #GRCodecStream }

{ #category : #'*pier-seaside' }
GRCodecStream >> isEmpty [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	^ stream isEmpty
]

{ #category : #'*pier-seaside' }
GRCodecStream >> position [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	^ stream position
]

{ #category : #'*pier-seaside' }
GRCodecStream >> position: anInteger [
	self flag: #todo. "Remove this method - used by PRDocumentWriter>>start:"
	stream position: anInteger
]

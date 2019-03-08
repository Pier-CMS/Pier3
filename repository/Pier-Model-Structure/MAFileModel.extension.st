Extension { #name : #MAFileModel }

{ #category : #'*pier-model-structure' }
MAFileModel >> urlFromFileStructure: fileStructure [
	^ fileStructure applicationUrl
]

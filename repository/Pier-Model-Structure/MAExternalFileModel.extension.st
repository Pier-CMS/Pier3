Extension { #name : #MAExternalFileModel }

{ #category : #'*pier-model-structure' }
MAExternalFileModel >> urlFromFileStructure: fileStructure [
	^ self baseUrl isNil
		ifTrue: [ super urlFromFileStructure: fileStructure ]
		ifFalse: [ self baseUrl , '/' , (self location reduce: [ :a :b | a , '/' , b ]) , '/' , self filename ]
]

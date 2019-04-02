Extension { #name : #PRFile }

{ #category : #'*pier-pharo-model' }
PRFile >> descriptionFilePharo: aDescription [
	<magritteDescription: #descriptionFile>
	^ aDescription
		kind: MAExternalFileModel;
		yourself
]

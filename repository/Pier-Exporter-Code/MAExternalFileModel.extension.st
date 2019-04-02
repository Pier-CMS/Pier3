Extension { #name : #MAExternalFileModel }

{ #category : #'*pier-exporter-code' }
MAExternalFileModel >> directory: anArray [
	(anArray isArray and: [ anArray size = 2 ])
		ifTrue: [ directory := self database baseDirectory / anArray first / anArray second ]
		ifFalse: [ directory := anArray ]
]

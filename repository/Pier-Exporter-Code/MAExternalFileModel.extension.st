Extension { #name : #MAExternalFileModel }

{ #category : #'*pier-exporter-code' }
MAExternalFileModel >> directory: anArray [
	anArray isArray
		ifTrue: [ (anArray size >= 2
				and: [ (self database baseDirectory / (anArray last: 2) first
						/ anArray last) exists ])
				ifTrue: [ directory := self database baseDirectory / (anArray last: 2) first
						/ anArray last ]
				ifFalse: [ directory := anArray
						inject: self database baseDirectory
						into: [ :dir :string | dir / string ] ] ]
		ifFalse: [ directory := anArray ]
]

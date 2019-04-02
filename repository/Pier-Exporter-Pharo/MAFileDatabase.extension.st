Extension { #name : #MAFileDatabase }

{ #category : #'*Pier-Exporter-Pharo' }
MAFileDatabase >> asLocation: aFileReference [ 
	^(aFileReference relativeTo: self baseDirectory) segments
]

{ #category : #'*Pier-Exporter-Pharo' }
MAFileDatabase >> locationFor: aStringArray [
	" return the folder that belongs to the relative path of aStringArray "
	^aStringArray inject: self baseDirectory ensureCreateDirectory into: [ :path :each |
		(path / each) ensureCreateDirectory ]
]

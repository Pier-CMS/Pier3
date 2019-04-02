Extension { #name : #PRDocument }

{ #category : #'*pier-exporter-code' }
PRDocument >> codeOn: aStream [
	aStream nextPut: $'; nextPutAll: (self writerClass write: self); nextPut: $'

	
]

{ #category : #'*pier-exporter-code' }
PRDocument >> writerClass [
	" old Pier has the Wiki writer, new Pier has the pillar writer "
	^Smalltalk at: #PRPillarWriter ifAbsent: [ Smalltalk at: #PRWikiWriter ]
]

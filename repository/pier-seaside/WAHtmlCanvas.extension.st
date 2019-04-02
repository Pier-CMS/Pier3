Extension { #name : #WAHtmlCanvas }

{ #category : #'*pier-seaside' }
WAHtmlCanvas >> rendererInstance [
	"Answer an instance of the current render visitor. This instance is only valid during the current rendering pass."
	
	^ context properties
		at: #rendererInstance
		ifAbsentPut: [
			PRCurrentContext value 
				command rendererInstance ]
]

Extension { #name : #WAScriptElement }

{ #category : #'*pier-admin' }
WAScriptElement >> scriptContents [
	| document |
	"if the script element is loading an external file, return the url (ensuring that it's a WAUrl)"
	self attributes at: 'src' ifPresent: [ :url | 
		^ url isString 
			ifTrue: [ WAUrl absolute: url ]
			ifFalse: [ url ] ].
	
	"otherwise just return the contents of the Url"
	document := WAHtmlDocument new.
	self childrenDo: [ :each | document nextPutAll: each greaseString ].

	^ document stream contents
]

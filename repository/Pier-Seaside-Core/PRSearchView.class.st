Class {
	#name : #PRSearchView,
	#superclass : #PRViewComponent,
	#instVars : [
		'query',
		'items',
		'root',
		'hideForm'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRSearchView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRSearchView class >> isRestful [
	^ true
]

{ #category : #accessing }
PRSearchView class >> label [
	^ 'Search'
]

{ #category : #actions }
PRSearchView >> addSearchString: aString to: aSearcher [
	aString isEmpty
		ifTrue: [ ^ self ].
	aString first = $+
		ifTrue: [ aSearcher acceptToken: aString allButFirst ]
		ifFalse: [ 
			aString first = $-
				ifTrue: [ aSearcher rejectToken: aString allButFirst ]
				ifFalse: [ aSearcher acceptToken: aString ] ]
]

{ #category : #testing }
PRSearchView >> hasSearchForm [
	^ hideForm not
]

{ #category : #testing }
PRSearchView >> hasSearchResults [
	^ self hasValidQuery and: [ self items notEmpty ]
]

{ #category : #testing }
PRSearchView >> hasValidQuery [
	^ self query notNil and: [ self query notEmpty ]
]

{ #category : #actions }
PRSearchView >> hideForm [
	hideForm := true
]

{ #category : #initialization }
PRSearchView >> initialRequest: aRequest [
	super initialRequest: aRequest.
	aRequest fields 
		at: self queryFieldName
		ifPresent: [ :value | self query: value ]
]

{ #category : #initialization }
PRSearchView >> initialize [
	super initialize.
	hideForm := false.
	items := OrderedCollection new
]

{ #category : #'accessing-readonly' }
PRSearchView >> items [
	^ items
]

{ #category : #accessing }
PRSearchView >> query [
	^ query
]

{ #category : #accessing }
PRSearchView >> query: aString [
	query := aString
]

{ #category : #configuration }
PRSearchView >> queryFieldName [
	^ 'query'
]

{ #category : #actions }
PRSearchView >> refresh [
	| searcher quotedString stringTokens |
	items := OrderedCollection new.
	self hasValidQuery
		ifFalse: [ ^ self ].
	searcher := self context structure fullTextSearch.
	quotedString := ''.
	stringTokens := self query findTokens: Character space.
	stringTokens first = '^'
		ifTrue: [ 
			stringTokens removeFirst.
			searcher caseSensitive: true ]
		ifFalse: [ searcher caseSensitive: false ].
	stringTokens
		do: [ :token | 
			token isEmpty
				ifFalse: [ 
					quotedString isEmpty
						ifTrue: [ 
							token first = $'
								ifTrue: [ quotedString := token allButFirst ]
								ifFalse: [ self addSearchString: token to: searcher ] ]
						ifFalse: [ 
							token last = $'
								ifTrue: [ 
									self addSearchString: quotedString , ' ' , token allButLast to: searcher.
									quotedString := '' ]
								ifFalse: [ quotedString := quotedString , ' ' , token ] ] ] ].
	(quotedString findTokens: Character space) do: [ :token | self addSearchString: token to: searcher ].
	self items
		addAll:
			(searcher select: [ :structure | structure parents allSatisfy: [ :parent | (self context structure: parent) isValid ] ])
]

{ #category : #rendering }
PRSearchView >> renderContentOn: html [
	self hasSearchForm
		ifTrue: [ self renderFormOn: html ].
	(self query isNil or: [ self items notEmpty ])
		ifTrue: [ self renderResultOn: html ]
		ifFalse: [ self renderNoResultOn: html ]
]

{ #category : #rendering }
PRSearchView >> renderFormOn: html [
	html form class: 'search-form'; with: [
		html label: [
			html span: 'Enter your keywords: '.
			html textInput
				value: self query;
				callback: [ :value | self query: value; refresh ].
			html submitButton: 'Search' ] ]
]

{ #category : #rendering }
PRSearchView >> renderNoResultOn: html [
	html paragraph: 'Your search for "' , self query , '" yielded no results.'.
	html
		unorderedList: [ html listItem: 'Check if your spelling is correct.'.
			html listItem: 'Consider loosening your query by removing words.' ]
]

{ #category : #rendering }
PRSearchView >> renderResultOn: html [
	| history |
	self items isEmpty
		ifTrue: [ ^ self ].
	html paragraph: 'Search for "' , self query , '" results:'.
	html definitionList
		class: 'search-result';
		with: [ self items
				do: [ :structure | 
					html
						definitionTerm: [ html anchor
								goto: (self context structure: structure);
								with: structure title.
							(history := self context kernel persistency historyFor: structure) isEmpty
								ifFalse: [ html text: ' updated on ' , history last command timestamp printString ] ].
					html definitionData: (self summaryOf: structure) ] ]
]

{ #category : #accessing }
PRSearchView >> root [
	^ root ifNil: [ root := self context root ]
]

{ #category : #accessing }
PRSearchView >> root: aStructure [
	root := aStructure
]

{ #category : #private }
PRSearchView >> summaryOf: aStructure [
	| input output |
	aStructure magritteDescription do: [ :description |
		description isDocumentDescription ifTrue: [
			output := WriteStream on: String new.
			input := (PRTextWriter write: (aStructure readUsing: description)) readStream.
			[ input atEnd ] whileFalse: [
				output nextPutAll: (input upTo: $<).
				input upTo: $> ].
			self summarySize isNil ifFalse: [
				output position: (output size min: self summarySize).
				output atEnd
					ifFalse: [ output nextPutAll: '...' ] ].
			^ output contents ] ].
	^ nil
]

{ #category : #configuration }
PRSearchView >> summarySize [
	^ 256
]

{ #category : #updating }
PRSearchView >> updateUrl: anUrl [ 
	super updateUrl: anUrl.
	self hasValidQuery 
		ifTrue: [ anUrl queryFields at: self queryFieldName put: self query ]
]

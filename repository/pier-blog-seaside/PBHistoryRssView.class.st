Class {
	#name : #PBHistoryRssView,
	#superclass : #PBRssView,
	#instVars : [
		'items'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBHistoryRssView class >> isAbstract [
	^ true
]

{ #category : #accessing }
PBHistoryRssView class >> label [
	^ 'Log (RSS)'
]

{ #category : #private }
PBHistoryRssView >> buildItems [
	| result |
	result := OrderedCollection new.
	self context kernel persistency reverseDo: [ :each |
		(self isVisible: each) ifTrue: [
			(self isFiltered not
				or: [ result isEmpty 
				or: [ result last structure ~= each structure 
				or: [ result last command class ~= each command class ] ] ]) ifTrue: [
					result addLast: each.
					result size < self maxSize
						ifFalse: [ ^ result ] ] ] ].
	^ result
]

{ #category : #testing }
PBHistoryRssView >> isFiltered [
	^ true
]

{ #category : #testing }
PBHistoryRssView >> isVisible: aContext [
	^ (aContext structure parents includes: self context structure) and: [ aContext isValidCommand: aContext structure viewCommandClass ]
]

{ #category : #accessing }
PBHistoryRssView >> items [
	^ items ifNil: [ items := self buildItems ]
]

{ #category : #accessing }
PBHistoryRssView >> maxSize [
	^ 25
]

{ #category : #'rendering-parts' }
PBHistoryRssView >> renderBasic: aContext on: rss [
	rss title: (self titleFor: aContext).
	rss link: (self urlFor: aContext).
	rss publicationDate: (RRRfc822DateTime
		newDateAndTime: aContext command timestamp).
	rss guid 
		beNoPermaLink;
		with: ((self urlFor: aContext)
			fragment: aContext command timestamp 
				asSeconds greaseString;
			yourself)
]

{ #category : #'rendering-parts' }
PBHistoryRssView >> renderBody: aContext on: rss [
	rss description: [
		rss html: '<![CDATA['.
		self 
			renderData: aContext
			on: (WAHtmlCanvas context: rss context).
		rss html: ']]>' ]
]

{ #category : #'rendering-parts' }
PBHistoryRssView >> renderData: aContext on: html [
	| data | 
	html definitionList: [
		aContext command magritteDescription do: [ :each |
			html definitionTerm: each label.
			html definitionData: [
				data := aContext command readUsing: each.
				each isDocumentDescription
					ifFalse: [ html render: (each toString: data) ]
					ifTrue: [
						PBRssRenderer new
							start: data in: self 
							on: html ] ] ] ]
]

{ #category : #rendering }
PBHistoryRssView >> renderItem: aContext on: rss [
	rss item: [
		self renderBasic: aContext on: rss.
		self renderUser: aContext on: rss.
		self renderTags: aContext on: rss.
		self renderBody: aContext on: rss ]
]

{ #category : #rendering }
PBHistoryRssView >> renderRssOn: rss [
	rss title: self title; description: self label; link: self url.
	self items do: [ :each | self renderItem: each on: rss ]
]

{ #category : #'rendering-parts' }
PBHistoryRssView >> renderTags: aContext on: rss [
	aContext structure tags
		do: [ :each | rss category: each ].
	rss category: aContext structure cssClass.
	rss category: aContext command cssClass
]

{ #category : #'rendering-parts' }
PBHistoryRssView >> renderUser: aContext on: rss [
	| user |
	user := aContext propertyAt: #user ifAbsent: [ ^ self ].
	user isNil ifFalse: [ ^ rss creator: user name ]
]

{ #category : #accessing }
PBHistoryRssView >> title [
	^ self titleFor: self context
]

{ #category : #accessing }
PBHistoryRssView >> titleFor: aContext [
	^ (aContext command label copyUpTo: $() trimBoth , ': ' , aContext structure title
]

{ #category : #accessing }
PBHistoryRssView >> url [
	^ self urlFor: self context
]

{ #category : #accessing }
PBHistoryRssView >> urlFor: aContext [
	^ (aContext view: aContext structure viewComponentClass) url
]

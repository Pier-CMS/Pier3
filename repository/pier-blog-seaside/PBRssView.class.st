Class {
	#name : #PBRssView,
	#superclass : #PRRawView,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #private }
PBRssView >> previousContextOf: aContext matching: aBlock [
	| current previous |
	current := self items
		indexOf: aContext
		ifAbsent: [ ^ nil ].
	current + 1 to: self items size do: [ :index |
		previous := self items at: index.
		(aBlock value: previous)
			ifTrue: [ ^ previous ] ].
	^ nil
]

{ #category : #rendering }
PBRssView >> renderRssOn: rss [
	self subclassResponsibility
]

{ #category : #responding }
PBRssView >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse
		contentType: (WAMimeType
			applicationRssXml
			charset: RRRssRoot defaultCharSet;
			yourself);
		doNotCache;
		nextPutAll: (RRRssRenderCanvas builder
			fullDocument: true;
			render: [ :canvas | self renderRssOn: canvas ])
]

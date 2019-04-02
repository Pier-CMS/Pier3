Class {
	#name : #PBEntriesRssView,
	#superclass : #PBBlogRssView,
	#instVars : [
		'posts'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBEntriesRssView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBEntriesRssView class >> label [
	^ 'Entries (RSS)'
]

{ #category : #private }
PBEntriesRssView >> findPosts [
	| items |
	items := self blog allPostsIn: self context.
	tags isEmptyOrNil
		ifFalse: [ items := items select: [ :post | post tags anySatisfy: [ :each | tags includes: each ] ] ].
	items := items last: (self blog itemCount min: items size).
	^ items reversed
]

{ #category : #responding }
PBEntriesRssView >> handle: aRequestContext [
	(self shouldForward: aRequestContext)
		ifFalse: [ super handle: aRequestContext ]
		ifTrue: [
			aRequestContext responseGenerator
				redirectTo: self blog feedForward;
				respond ]
]

{ #category : #accessing }
PBEntriesRssView >> posts [
	^ posts ifNil: [ posts := self findPosts ]
]

{ #category : #rendering }
PBEntriesRssView >> renderPost: aPost on: rss [
	| enclosure |
	rss title: aPost title.
	rss link: (self context structure: aPost) url.
	rss comments: (self context structure: aPost) url.
	rss commentRss: (self context
		structure: self blog
		view: PBCommentsRssView) url.
	rss publicationDate: (RRRfc822DateTime
		newDateAndTime: aPost publication).
	aPost tags
		do: [ :each | rss category: each ].
	self renderDescription: aPost document on: rss.
	aPost author isNil
		ifFalse: [ rss creator: aPost author ].
	rss guid
		beNoPermaLink;
		with: aPost uuid.
	(enclosure := aPost enclosure) isNil ifFalse: [
		rss enclosure
			url: enclosure file url;
			length: enclosure file filesize;
			type: enclosure file mimetype ].
	aPost sourceUrl isNil ifFalse: [
		rss source
			url: aPost sourceUrl;
			with: aPost sourceTitle ]
]

{ #category : #rendering }
PBEntriesRssView >> renderRssOn: rss [
	super renderRssOn: rss.
	self posts isEmpty ifTrue: [ ^ self ].
	rss lastBuildDate: (RRRfc822DateTime
		newDateAndTime: self posts last publication).
	self posts do: [ :each |
		rss item: [ self renderPost: each on: rss ] ]
]

{ #category : #private }
PBEntriesRssView >> shouldForward: aContext [
	(self blog feedForward isNil or: [ self blog feedForward isEmpty ])
		ifTrue: [ ^ false ].
	(self requestContext request fields includesKey: 'noforward')
		ifTrue: [ ^ false ].
	(self requestContext request userAgent notNil and: [ self requestContext request userAgent includesSubstring: 'FeedBurner' caseSensitive: true ])
		ifTrue: [ ^ false ].
	^ true
]

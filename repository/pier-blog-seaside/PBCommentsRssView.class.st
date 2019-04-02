Class {
	#name : #PBCommentsRssView,
	#superclass : #PBBlogRssView,
	#instVars : [
		'comments'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBCommentsRssView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBCommentsRssView class >> label [
	^ 'Comments (RSS)'
]

{ #category : #accessing }
PBCommentsRssView >> comments [
	^ comments ifNil: [ comments := self findComments ]
]

{ #category : #private }
PBCommentsRssView >> findComments [
	| items |
	items := self blog allCommentsIn: self context.
	tags isEmpty ifFalse: [
		items := items select: [ :comm | 
			| post |
			post := comm findAncestor: [ :each | each isKindOf: PBPost ].
			post notNil and: [ post tags anySatisfy: [ :each | tags includes: each ] ] ] ].
	items := items last: (self blog itemCount min: items size).
	^ items reversed
]

{ #category : #rendering }
PBCommentsRssView >> renderComment: aComment on: rss [
	| post |
	post := aComment parents reverse
		detect: [ :each | each isPost ].
	rss title: 'Comment on ' , post title.
	rss link: ((self context structure: post)
		url fragment: aComment uuid).
	aComment author isNil
		ifFalse: [ rss creator: aComment author ].
	rss publicationDate: (RRRfc822DateTime
		newDateAndTime: aComment publication).
	rss guid
		beNoPermaLink;
		with: aComment uuid.
	self renderDescription: aComment document on: rss
]

{ #category : #rendering }
PBCommentsRssView >> renderRssOn: rss [
	super renderRssOn: rss.
	self comments isEmpty ifTrue: [ ^ self ].
	rss lastBuildDate: (RRRfc822DateTime
		newDateAndTime: self comments last publication).
	self comments do: [ :each |
		rss item: [ self renderComment: each on: rss ] ]
]

{ #category : #'accessing-dynamic' }
PBCommentsRssView >> title [
	^ 'Comments for ' , super title
]

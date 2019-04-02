Class {
	#name : #PBBlogRssView,
	#superclass : #PBRssView,
	#instVars : [
		'blog',
		'tags'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBBlogRssView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isBlog ]
]

{ #category : #'instance creation' }
PBBlogRssView class >> new [
	"This is an ugly hack to make already bookmarked blogs work properly."

	^ self name = #PBRssView
		ifTrue: [ PBEntriesRssView new ]
		ifFalse: [ super new ]
]

{ #category : #accessing }
PBBlogRssView >> blog [
	^ blog ifNil: [ blog := self find: PBBlog ]
]

{ #category : #initialization }
PBBlogRssView >> initialRequest: aRequest [
	super initialRequest: aRequest.
	tags := (aRequest queryFields at: 'tags' ifAbsent: [ '' ])
		findTokens: $,
]

{ #category : #'accessing-dynamic' }
PBBlogRssView >> link [
	^ (self context structure: self blog) url
]

{ #category : #rendering }
PBBlogRssView >> renderDescription: aDocument on: rss [
	rss description: [
		rss html: '<![CDATA['.
		PBRssRenderer new
			start: aDocument in: self 
			on: (WAHtmlCanvas context: rss context).
		rss html: ']]>' ]
]

{ #category : #rendering }
PBBlogRssView >> renderRssOn: rss [
	"Generate some standard information that should be present in all the feeds."

	rss title: self title; link: self link.
	self renderDescription: self blog document on: rss.
	rss generator: 'Pier Blog'.
	rss language: self blog language.
	self blog tags do: [ :each | rss category: each ].
	self blog copyright isNil
		ifFalse: [ rss copyright: self blog copyright ].
	self blog managingEditor isNil
		ifFalse: [ rss managingEditor: self blog managingEditor ].
	self blog webMaster isNil
		ifFalse: [ rss webMaster: self blog webMaster ]
]

{ #category : #'accessing-dynamic' }
PBBlogRssView >> title [
	^ self blog feedTitle ifNil: [ self blog title ]
]

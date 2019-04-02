"
A PBHtmlView is a view for blogs.

Instance Variables
	blog:		<PBBlog>
	socialSharingWidget:		<Object>

blog
	- What is being displayed.

socialSharingWidget
	- xxxxx

"
Class {
	#name : #PBHtmlView,
	#superclass : #PRDefaultView,
	#instVars : [
		'blog',
		'socialSharingWidget'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #testing }
PBHtmlView class >> isAbstract [
	^ true
]

{ #category : #accessing }
PBHtmlView >> blog [
	^ blog ifNil: [ blog := self find: PBBlog ]
]

{ #category : #'as yet unclassified' }
PBHtmlView >> children [
	^ self socialSharingWidget isNil 
		ifTrue: [ #() ]
		ifFalse: [ Array with: self socialSharingWidget ]
]

{ #category : #actions }
PBHtmlView >> filter: aString [
	| newContext component |
	newContext := self context structure: self blog.
	component := newContext command viewComponent.
	component posts: (component posts
		select: [ :each | each tags includes: aString ]).
	self context: newContext
]

{ #category : #accessing }
PBHtmlView >> posts [
	"Answer the currently displayed blog posts."
	
	^ self blog allPostsIn: self context
]

{ #category : #'rendering-meta' }
PBHtmlView >> renderAuthor: anEntry on: html [
	anEntry author ifNil: [ ^ self ].
	html span
		class: 'author';
		with: 'by ' , anEntry author.
	html text: ' '
]

{ #category : #'rendering-meta' }
PBHtmlView >> renderComment: anEntry on: html [
	| comments |
	self context structure isBlog ifFalse: [ ^ self ].
	comments := anEntry allCommentsIn: self context.
	html anchor
		class: 'comment';
		goto: (self context
			structure: (self context structure isBlog
				ifTrue: [ anEntry ]
				ifFalse: [ anEntry parent ]));
		fragment: 'comments';
		with: (comments isEmpty ifTrue: [ '' ] ifFalse: [ comments size pluralize: ' comment' ]).
	html text: ' '
]

{ #category : #rendering }
PBHtmlView >> renderHeading: aPost on: html [ 
	html heading level: 1; with: [
		html anchor
			name: aPost uuid.
		html anchor
			goto: (self context structure: aPost);
			with: [ html html: aPost title ] ]
]

{ #category : #'rendering-meta' }
PBHtmlView >> renderLink: anEntry on: html [
	html anchor
		class: 'link';
		url: (anEntry isPost
			ifTrue: [ (self context structure: anEntry) url ]
			ifFalse: [
				(self context
					structure: (anEntry parents reverse
						detect: [ :each | each isPost ]))
					url fragment: anEntry uuid ]);
		with: 'link'.
	html text: ' '
]

{ #category : #rendering }
PBHtmlView >> renderMeta: anEntry on: html [
	html div class: 'meta'; with: [
		html text: 'Posted '.
		self renderAuthor: anEntry on: html.
		self renderPublication: anEntry on: html.
		self renderTags: anEntry on: html.
		self renderComment: anEntry on: html.
		self renderLink: anEntry on: html.
		self renderSocialSharing: anEntry on: html ]
]

{ #category : #rendering }
PBHtmlView >> renderPost: aPost on: html [ 
	html div class: 'post'; with: [ 
		self renderHeading: aPost on: html.
		self render: aPost on: html.
		self renderMeta: aPost on: html ]
]

{ #category : #rendering }
PBHtmlView >> renderPosts: aCollection on: html [
	html div class: 'posts'; with: [
		aCollection do: [ :each |
			self renderPost: each on: html ] ]
]

{ #category : #'rendering-meta' }
PBHtmlView >> renderPublication: anEntry on: html [
	anEntry publication ifNil: [ ^ self ].
	html span
		class: 'publication';
		with: 'at ' , anEntry publication asDate printString ,
			', ' , anEntry publication asTime printMinutes.
	html text: ' '
]

{ #category : #rendering }
PBHtmlView >> renderRssOn: html [
	"If you modify this method, please also modify PBPostTicker>>#renderRssOn:"
	html div class: 'subscribe'; with: [
		html anchor
			url: (self context
				structure: self blog
				view: PBEntriesRssView)
					url;
			with: 'Entries (RSS)'.
		html span class: 'rssComments'; with: [
			html text: ' and '.
				html anchor
					url: (self context
						structure: self blog
						view: PBCommentsRssView)
							url;
					with: 'Comments (RSS)' ]]
]

{ #category : #rendering }
PBHtmlView >> renderSocialSharing: anEntry on: html [
	self socialSharingWidget notNil ifTrue: [
		html div
			class: 'socialSharingWidget';
			with: [
				self socialSharingWidget renderWidgetForEntry: anEntry on: html ] ]
]

{ #category : #'rendering-meta' }
PBHtmlView >> renderTags: anEntry on: html [
	anEntry isPost ifFalse: [ ^ self ].
	anEntry tags isEmpty ifTrue: [ ^ self ].
	html span class: 'tags'; with: [
		html text: 'with tags '.
		anEntry tags
			do: [ :each |
				html anchor
					callback: [ self filter: each ];
					with: each ]
			separatedBy: [ html text: ', ' ] ].
	html text: ' '
]

{ #category : #accessing }
PBHtmlView >> socialSharingWidget [
	^ socialSharingWidget ifNil: [
		self blog socialSharingWidgetClassName notNil 
			ifTrue: [ socialSharingWidget :=  (GRPlatform current magritteClassNamed: self blog socialSharingWidgetClassName) new ]
			ifFalse: [ nil ] ]
]

{ #category : #updating }
PBHtmlView >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	aHtmlRoot rss
		title: self blog feedTitle;
		url: (self context
			structure: self blog
			view: PBEntriesRssView)
				url
]

Class {
	#name : #PBPostTicker,
	#superclass : #PRWidget,
	#instVars : [
		'numberOfCharacters',
		'numberOfPosts',
		'blog'
	],
	#category : #'Pier-Blog-Seaside'
}

{ #category : #accessing }
PBPostTicker class >> groupLabel [
	^ 'Pier Blog'
]

{ #category : #testing }
PBPostTicker class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBPostTicker class >> label [
	^ 'Ticker'
]

{ #category : #accessing }
PBPostTicker >> blog [
	^ blog
]

{ #category : #accessing }
PBPostTicker >> blog: anObject [
	blog := anObject
]

{ #category : #'accessing-description' }
PBPostTicker >> descriptionBlog [
	<magritteDescription>
	^ PRStructureDescription new
		addCondition: (MACondition selector: #isBlog) labelled: 'Select a blog as source';
		accessor: #blog;
		label: 'Source';
		priority: 100;
		yourself
]

{ #category : #'accessing-description' }
PBPostTicker >> descriptionNumberOfCharacters [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of characters to display of a post.';
		parameterName: 'number-of-characters';
		accessor: #numberOfCharacters;
		label: 'Number of Characters';
		priority: 110;
		default: 200;
		bePositive;
		beInteger;
		yourself
]

{ #category : #'accessing-description' }
PBPostTicker >> descriptionNumberOfPosts [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of posts to appear.';
		parameterName: 'number-of-posts';
		accessor: #numberOfPosts;
		label: 'Number of Posts';
		priority: 120;
		default: 3;
		bePositive;
		beInteger;
		yourself
]

{ #category : #accessing }
PBPostTicker >> numberOfCharacters [
	^ numberOfCharacters
]

{ #category : #accessing }
PBPostTicker >> numberOfCharacters: anObject [
	numberOfCharacters := anObject
]

{ #category : #accessing }
PBPostTicker >> numberOfPosts [
	^ numberOfPosts
]

{ #category : #accessing }
PBPostTicker >> numberOfPosts: anObject [
	numberOfPosts := anObject
]

{ #category : #'accessing-dynamic' }
PBPostTicker >> posts [
	| items |
	items := self blog allPostsIn: self context.
	self numberOfPosts isNil
		ifFalse: [ items := items last: (self numberOfPosts min: items size) ].
	^ items reversed
]

{ #category : #'rendering-parts' }
PBPostTicker >> renderAuthorForPost: aPost on: html [
	aPost author ifNil: [^ self].
	html space.
	html span
		class: 'author';
		with: 'by ', aPost author.

]

{ #category : #rendering }
PBPostTicker >> renderContentOn: html [
	self blog isNil
		ifTrue: [ ^ html div: '(no blog specified)' ].
	self posts isEmpty
		ifTrue: [ ^ html div: '(no posts available)' ].
	html unorderedList class: 'postticker'; with: [
		self posts do: [ :each |
			html listItem: [
				self renderPost: each on: html ] ] ].
	self renderRssOn: html.
]

{ #category : #'rendering-parts' }
PBPostTicker >> renderDateForPost: aPost on: html [
	html span class: 'date'; with: aPost publication asDate
]

{ #category : #rendering }
PBPostTicker >> renderPost: aPost on: html [
	html anchor
		goto: (self context structure: aPost);
		with: [ html html: aPost title ].
	html div class: 'timestamp'; with: [
		self renderDateForPost: aPost on: html.
		self renderTimeForPost: aPost on: html.
		self renderAuthorForPost: aPost on: html ].
	html div
		class: 'summary';
		with: [ html html: (self summaryOf: aPost) ]
]

{ #category : #rendering }
PBPostTicker >> renderRssOn: html [
	"Copy-pasted from PBHtmlView. I tried to refactor but it was not that easy."
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

{ #category : #'rendering-parts' }
PBPostTicker >> renderTimeForPost: aPost on: html [
	html span class: 'time'; with: aPost publication asTime
]

{ #category : #private }
PBPostTicker >> summaryOf: aPost [
	| input output emptyPosition |
	input := aPost plainText readStream.
	output := WriteStream on: String new.
	"Gemstone and Pharo use 1 based and 0 based stream positioning respectively
	work out what base of stream we have"
	emptyPosition := output position.

	[ input atEnd ] whileFalse: [
		output nextPutAll: (input upTo: $<).
		input upTo: $> ].
	
	self numberOfCharacters isNil ifFalse: [
		output position: (output size min: self numberOfCharacters) + emptyPosition.
		output atEnd
			ifFalse: [ output nextPutAll: '...' ] ].
	^ output contents
]

{ #category : #updating }
PBPostTicker >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	self blog isNil ifTrue: [ ^ self ].
	aHtmlRoot rss
		title: self blog feedTitle;
		url: (self context
			structure: self blog
			view: PBEntriesRssView)
				url
]

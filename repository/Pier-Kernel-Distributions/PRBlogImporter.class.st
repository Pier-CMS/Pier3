Class {
	#name : #PRBlogImporter,
	#superclass : #WAComponent,
	#instVars : [
		'blogStructure',
		'blogUrl',
		'errorMessage',
		'successMessage',
		'importedBlog'
	],
	#category : #'Pier-Kernel-Distributions'
}

{ #category : #'instance creation' }
PRBlogImporter class >> blogStructure: blogStructure blogUrl: blogUrl [
	^ self new
		blogStructure: blogStructure;
		blogUrl: blogUrl;
		yourself
]

{ #category : #accessing }
PRBlogImporter >> blogStructure [
	^ blogStructure
]

{ #category : #accessing }
PRBlogImporter >> blogStructure: anObject [
	blogStructure := anObject
]

{ #category : #accessing }
PRBlogImporter >> blogUrl [
	^ blogUrl
]

{ #category : #accessing }
PRBlogImporter >> blogUrl: anObject [
	blogUrl := anObject
]

{ #category : #accessing }
PRBlogImporter >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PRBlogImporter >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #helper }
PRBlogImporter >> errorTextFromException: exception [
	exception messageText isEmptyOrNil
		ifTrue: [ 
			| exceptionDescription |
			exceptionDescription := exception class label.
			(exceptionDescription beginsWith: 'Zn ' ) ifTrue: [
				exceptionDescription := exceptionDescription allButFirst: 3 ].
			self errorMessage: 'Error importing blog: ', exceptionDescription ]
		ifFalse: [ self errorMessage: 'Error importing blog: ', exception messageText ]
	
]

{ #category : #action }
PRBlogImporter >> extractFeedFromHtml: htmlContent [
	| matches hrefs lastStartIndex matcher response |
	
	matcher := 'href=["|''](.*)["|'']' asRegex.
	lastStartIndex := 1.
	matches := htmlContent allRegexMatches: '<link\s+rel=["|'']alternate["|'']\s+type=["|'']application/rss\+xml["|'']'.
	hrefs := matches inject: OrderedCollection new into: [ :result :each |
		| startIndex endIndex element |
		startIndex := htmlContent indexOfSubCollection: each startingAt: lastStartIndex ifAbsent: [ 0 ].
		endIndex := htmlContent findString: '>' startingAt: startIndex.
		element := htmlContent copyFrom: startIndex to: endIndex.
		lastStartIndex := endIndex.
		matcher search: element.
		matcher subexpressionCount = 2 ifTrue: [
			| aFeedUrl |
			aFeedUrl := matcher subexpression: 2.
			(aFeedUrl includesSubString: 'comment') ifFalse: [ result add: aFeedUrl ] ].
		result ].

	hrefs 
		detect: [ :each |
			[ response := ZnEasy get: each ]
				on: Error
				do: [ :ex | 
					self errorTextFromException: ex.
					response := nil ].
			response notNil and: [ response contentType sub includesSubString: 'xml' ] ]
		ifNone: [ response := nil ].
		
	^ response

]

{ #category : #action }
PRBlogImporter >> importBlog: theImportedBlog [
	theImportedBlog items do: [ :each | 
		self blogStructure addChild: ((PBPost named: (self nameFromTitle: each title))
			title: each title;
			publication: each pubDate asTimeStamp;
			author: each authorString;
			tags: each tags;
			contents: each content;
			yourself) ].
		
	self successMessage: 'Successfully imported blog. Continue to administration setup.'.
]

{ #category : #accessing }
PRBlogImporter >> isSuccessful [
	^ self successMessage notNil
]

{ #category : #helper }
PRBlogImporter >> nameFromTitle: title [
	| theTitle |
	theTitle := title collect: [ :char |
		(PRPath isValidCharacter: char)
			ifTrue: [ char asLowercase ]
			ifFalse: [
				Character space = char
					ifTrue: [ $- ]
					ifFalse: [ $_ ] ] ].
			
	^ theTitle reject: [ :each | each = $_ ]
		
]

{ #category : #rendering }
PRBlogImporter >> renderContentOn: html [
	self renderLoadingOverlayOn: html.
	self renderProcessingCallbackOn: html.
	self renderHiddenForTranslationOn: html
]

{ #category : #rendering }
PRBlogImporter >> renderHiddenForTranslationOn: html [
	html div
		id: #translationRoot;
		style: 'display:none'
]

{ #category : #rendering }
PRBlogImporter >> renderLoadingOverlayOn: html [
	html div
		id: #overlay;
		class: 'setupAdminOverBase';
		with: [ 
			html div
				class: 'alert alert-info';
				class: 'setupAdminOverlayMessage';
				with: [ 
					html image
						style: 'position: relative; margin-bottom: -1em;';
						url: PRKernelDistributionFileLibrary / #loadingGif.
					html span
						style: 'margin-left: 8px; margin-bottom: 40px';
						with: 'Loading blog: "' , self blogUrl , '"' ] ]
]

{ #category : #rendering }
PRBlogImporter >> renderProcessingCallbackOn: html [
	"use an ajax callback to allow us to parse the blog post html on the client"
	
	self renderTranslateBlogPostsJSOn: html.
	
	html document addLoadScript: 
		(html jQuery ajax script: [ :s |
			importedBlog := self retrieveBlogFromUrl: self blogUrl.
			importedBlog isNil
				ifTrue: [ s << (JSStream on: 'processingComplete()') ]
				ifFalse: [ 
					| blogItemsJS blogItemsContent |
					blogItemsContent := importedBlog items collect: [ :each | 
						(each content) isEmptyOrNil ifTrue: [ each textualDescription ] ifFalse: [ each content ] ].
					blogItemsJS := JSStream new
						nextPutAll: 'var translatedPosts = translateBlogPosts(';
						nextPutAll: blogItemsContent asJson;
						nextPutAll: ');';
						nextPutAll: 'postTranslatedPosts(translatedPosts);'.
					s << blogItemsJS ] ]).

	html script: 
		(((html jQuery post
			callback: [ :blogPosts |
				importedBlog items withIndexDo: [ :each :index |
					each content: (blogPosts at: index) ].
				self importBlog: importedBlog ]
			json: (JSStream on: 'translatedPosts');
			script: [ :s | s << (JSStream on: 'processingComplete()') ])
				asFunction: #('translatedPosts')) 
					assignLocalTo: 'postTranslatedPosts').

	html script: 
		((html javascript callback: [ 
			self isSuccessful
				ifTrue: [ self twbsInformSuccess: self successMessage ]
				ifFalse: [ self twbsInformError: self errorMessage ].
				
			self answer: self isSuccessful ] ) 
				asFunction assignLocalTo: 'processingComplete')
]

{ #category : #rendering }
PRBlogImporter >> renderTranslateBlogPostsJSOn: html [
	html script: '
var translateBlogPosts = function (blogPosts) {	
	for (var i = 0, length = blogPosts.length; i < length; ++i ) {
		var translationRoot = $("#translationRoot");
		translationRoot.html(blogPosts [ i ]);
		var parsedResult = parseHtmlToPierWikiSyntax (translationRoot[0], "");
		blogPosts [ i ] = parsedResult;
	}
	return blogPosts;
}'
]

{ #category : #action }
PRBlogImporter >> retrieveBlogFromUrl: aBlogUrl [
	| response |
	
	[ [ response := ZnEasy get: aBlogUrl ]
			on: ZnMissingHost
			do: [ :ex | response := ZnEasy get: 'http://', aBlogUrl  ] ]
		on: Error
		do: [ :ex | self errorTextFromException: ex.
		^ nil ].
		
	(#('xml' 'html') includes: response contentType sub) ifFalse: [
		self errorMessage: 'Didn''t receive an html or xml response from the url: "',  aBlogUrl, '"'.
		^ nil ].
	
	response contentType sub = 'html' ifTrue: [
		response := self extractFeedFromHtml: response contents ].
		
	response isNil ifTrue: [ 
		self errorMessage: 'Failed to find a blog feed from url: "',  aBlogUrl, '"'.
		^ nil ].
	
	^ TFRssReaderFactory fromXml: response contents
]

{ #category : #accessing }
PRBlogImporter >> successMessage [
	^ successMessage
]

{ #category : #accessing }
PRBlogImporter >> successMessage: anObject [
	successMessage := anObject
]

{ #category : #updating }
PRBlogImporter >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	 anHtmlRoot javascript url: PRWysiwygFileLibrary / #parseHtmlToPierWikiSyntaxJs
]

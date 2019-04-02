Class {
	#name : #PBBlog,
	#superclass : #PRCase,
	#instVars : [
		'managingEditor',
		'webMaster',
		'copyright',
		'language',
		'itemCount',
		'feedTitle',
		'commentTimeout',
		'feedForward',
		'socialSharingWidgetClassName'
	],
	#classVars : [
		'Languages'
	],
	#category : #'Pier-Blog-Model'
}

{ #category : #private }
PBBlog class >> buildLanguages [
	^ Dictionary new
		at: 'af' put: 'Afrikaans';
		at: 'sq' put: 'Albanian';
		at: 'eu' put: 'Basque';
		at: 'be' put: 'Belarusian';
		at: 'bg' put: 'Bulgarian';
		at: 'ca' put: 'Catalan';
		at: 'zh-cn' put: 'Chinese (Simplified)';
		at: 'zh-tw' put: 'Chinese (Traditional)';
		at: 'hr' put: 'Croatian';
		at: 'cs' put: 'Czech';
		at: 'da' put: 'Danish';
		at: 'nl' put: 'Dutch';
		at: 'nl-be' put: 'Dutch (Belgium)';
		at: 'nl-nl' put: 'Dutch (Netherlands)';
		at: 'en' put: 'English';
		at: 'en-au' put: 'English (Australia)';
		at: 'en-bz' put: 'English (Belize)';
		at: 'en-ca' put: 'English (Canada)';
		at: 'en-ie' put: 'English (Ireland)';
		at: 'en-jm' put: 'English (Jamaica)';
		at: 'en-nz' put: 'English (New Zealand)';
		at: 'en-ph' put: 'English (Phillipines)';
		at: 'en-za' put: 'English (South Africa)';
		at: 'en-tt' put: 'English (Trinidad)';
		at: 'en-gb' put: 'English (United Kingdom)';
		at: 'en-us' put: 'English (United States)';
		at: 'en-zw' put: 'English (Zimbabwe)';
		at: 'et' put: 'Estonian';
		at: 'fo' put: 'Faeroese';
		at: 'fi' put: 'Finnish';
		at: 'fr' put: 'French';
		at: 'fr-be' put: 'French (Belgium)';
		at: 'fr-ca' put: 'French (Canada)';
		at: 'fr-fr' put: 'French (France)';
		at: 'fr-lu' put: 'French (Luxembourg)';
		at: 'fr-mc' put: 'French (Monaco)';
		at: 'fr-ch' put: 'French (Switzerland)';
		at: 'gl' put: 'Galician';
		at: 'gd' put: 'Gaelic';
		at: 'de' put: 'German';
		at: 'de-at' put: 'German (Austria)';
		at: 'de-de' put: 'German (Germany)';
		at: 'de-li' put: 'German (Liechtenstein)';
		at: 'de-lu' put: 'German (Luxembourg)';
		at: 'de-ch' put: 'German (Switzerland)';
		at: 'el' put: 'Greek';
		at: 'haw' put: 'Hawaiian';
		at: 'hu' put: 'Hungarian';
		at: 'is' put: 'Icelandic';
		at: 'in' put: 'Indonesian';
		at: 'ga' put: 'Irish';
		at: 'it' put: 'Italian';
		at: 'it-it' put: 'Italian (Italy)';
		at: 'it-ch' put: 'Italian (Switzerland)';
		at: 'ja' put: 'Japanese';
		at: 'ko' put: 'Korean';
		at: 'mk' put: 'Macedonian';
		at: 'no' put: 'Norwegian';
		at: 'pl' put: 'Polish';
		at: 'pt' put: 'Portuguese';
		at: 'pt-br' put: 'Portuguese (Brazil)';
		at: 'pt-pt' put: 'Portuguese (Portugal)';
		at: 'ro' put: 'Romanian';
		at: 'ro-mo' put: 'Romanian (Moldova)';
		at: 'ro-ro' put: 'Romanian (Romania)';
		at: 'ru' put: 'Russian';
		at: 'ru-mo' put: 'Russian (Moldova)';
		at: 'ru-ru' put: 'Russian (Russia)';
		at: 'sr' put: 'Serbian';
		at: 'sk' put: 'Slovak';
		at: 'sl' put: 'Slovenian';
		at: 'es' put: 'Spanish';
		at: 'es-ar' put: 'Spanish (Argentina)';
		at: 'es-bo' put: 'Spanish (Bolivia)';
		at: 'es-cl' put: 'Spanish (Chile)';
		at: 'es-co' put: 'Spanish (Colombia)';
		at: 'es-cr' put: 'Spanish (Costa Rica)';
		at: 'es-do' put: 'Spanish (Dominican Republic)';
		at: 'es-ec' put: 'Spanish (Ecuador)';
		at: 'es-sv' put: 'Spanish (El Salvador)';
		at: 'es-gt' put: 'Spanish (Guatemala)';
		at: 'es-hn' put: 'Spanish (Honduras)';
		at: 'es-mx' put: 'Spanish (Mexico)';
		at: 'es-ni' put: 'Spanish (Nicaragua)';
		at: 'es-pa' put: 'Spanish (Panama)';
		at: 'es-py' put: 'Spanish (Paraguay)';
		at: 'es-pe' put: 'Spanish (Peru)';
		at: 'es-pr' put: 'Spanish (Puerto Rico)';
		at: 'es-es' put: 'Spanish (Spain)';
		at: 'es-uy' put: 'Spanish (Uruguay)';
		at: 'es-ve' put: 'Spanish (Venezuela)';
		at: 'sv' put: 'Swedish';
		at: 'sv-fi' put: 'Swedish (Finland)';
		at: 'sv-se' put: 'Swedish (Sweden)';
		at: 'tr' put: 'Turkish';
		at: 'uk' put: 'Ukranian';
		yourself
]

{ #category : #testing }
PBBlog class >> canBeParentOf: aClass [
	^ aClass includesBehavior: PBPost
]

{ #category : #testing }
PBBlog class >> isAbstract [
	^ false
]

{ #category : #accessing }
PBBlog class >> label [
	^ 'Blog'
]

{ #category : #'accessing-resources' }
PBBlog class >> languages [
	^ Languages ifNil: [ Languages := self buildLanguages ]
]

{ #category : #visiting }
PBBlog >> accept: aVisitor [
	aVisitor visitBlog: self
]

{ #category : #'accessing-dynamic' }
PBBlog >> allCommentsIn: aContext [
	"Answer all the comments in choronological order."

	^ ((aContext enumeratorFor: self) all
		select: [ :each |
			each isComment
				and: [ each publication notNil
				and: [ each publication <= GRPlatform current magritteTimeStampClass now ] ] ])
		sort: [ :a :b | a publication < b publication ];
		yourself
]

{ #category : #'accessing-dynamic' }
PBBlog >> allPostsIn: aContext [
	"Answer all the published posts in choronological order."

	^ ((aContext enumeratorFor: self)
		select: [ :each |
			each isPost
				and: [ each publication notNil
				and: [ each publication <= GRPlatform current magritteTimeStampClass now ] ] ])
		sort: [ :a :b | a publication < b publication ];
		yourself
]

{ #category : #accessing }
PBBlog >> commentTimeout [
	^ commentTimeout ifNil: [ commentTimeout := 14 days ]
]

{ #category : #accessing }
PBBlog >> commentTimeout: aDuration [
	commentTimeout := aDuration
]

{ #category : #accessing }
PBBlog >> copyright [
	^ copyright
]

{ #category : #accessing }
PBBlog >> copyright: aString [
	copyright := aString
]

{ #category : #'accessing-commands' }
PBBlog >> defaultChildName [
	| date code |
	date := Date today.
	code := #( year 4 $- monthIndex 2 $- dayOfMonth 2 ) readStream.
	^ String streamContents: [ :stream |
		[ code atEnd ] whileFalse: [
			stream nextPutAll: ((date perform: code next)
				printPaddedWith: $0 to: code next).
			code atEnd
				ifFalse: [ stream nextPut: code next ] ] ]
]

{ #category : #'accessing-description' }
PBBlog >> descriptionCommentTimeout [
	<magritteDescription>
	^ MADurationDescription new
		accessor: #commentTimeout;
		label: 'Comment Timeout';
		priority: 370;
		comment: 'How long should it be possible to post comments.';
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionCopyright [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #copyright;
		label: 'Copyright';
		priority: 350;
		comment: 'Copyright notice for content in the channel.';
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionDocument [
	<magritteDescription>
	^ super descriptionDocument
		label: 'Description';
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionFeedForward [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #feedForward;
		label: 'Feed Forward';
		priority: 315;
		comment:
				'The url to forward the feed to. This is useful when used together with services such as FeedBurner or Google AdSense. The original feed can be reached by concatenating the original URL with ''&noforward.''';
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionFeedTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #feedTitle;
		label: 'Feed Title';
		priority: 310;
		comment: 'The title of the channel.';
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionItemCount [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The number of items to appear in the feed.';
		accessor: #itemCount;
		label: 'Item Count';
		priority: 370;
		beRequired;
		beEditable;
		bePositive;
		beInteger;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionLanguage [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: #language;
		label: 'Language';
		priority: 360;
		comment: 'The language the channel is written in.';
		reference:
				(MAStringDescription new
						stringWriter: self;
						yourself);
		options: self class languages keys;
		default: 'en';
		beRequired;
		beEditable;
		beSorted;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionManagingEditor [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #managingEditor;
		label: 'Managing Editor';
		priority: 330;
		comment: 'Email address for person responsible for editorial content.';
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionSocialSharingWidgetClassName [
	<magritteDescription>
	^ MASymbolDescription new
		accessor: #socialSharingWidgetClassName;
		label: 'Social sharing class';
		priority: 330;
		comment: 'Class for social sharing widgets, that is a class which creates twitter, facebook widgets';
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PBBlog >> descriptionWebMaster [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #webMaster;
		label: 'Web Master';
		priority: 340;
		comment: 'Email address for person responsible for technical issues relating to channel.';
		beEditable;
		yourself
]

{ #category : #accessing }
PBBlog >> feedForward [
	^ feedForward
]

{ #category : #accessing }
PBBlog >> feedForward: aString [
	feedForward := aString
]

{ #category : #accessing }
PBBlog >> feedTitle [
	^ feedTitle
]

{ #category : #accessing }
PBBlog >> feedTitle: aString [
	feedTitle := aString
]

{ #category : #testing }
PBBlog >> isBlog [
	^ true
]

{ #category : #accessing }
PBBlog >> itemCount [
	^ itemCount ifNil: [ itemCount := 10 ]
]

{ #category : #accessing }
PBBlog >> itemCount: anInteger [
	itemCount := anInteger
]

{ #category : #accessing }
PBBlog >> language [
	^ language
]

{ #category : #accessing }
PBBlog >> language: aString [
	language := aString
]

{ #category : #accessing }
PBBlog >> managingEditor [
	^ managingEditor
]

{ #category : #accessing }
PBBlog >> managingEditor: anEditor [
	managingEditor := anEditor
]

{ #category : #accessing }
PBBlog >> socialSharingWidgetClass: aClassName [
	self greaseDeprecatedApi: 'PBBlog>>#socialSharingWidgetClass:' details: 'use PBBlog>>#socialSharingWidgetClassName: instead.'.
	
	self socialSharingWidgetClassName: aClassName
]

{ #category : #accessing }
PBBlog >> socialSharingWidgetClassName [
	^ socialSharingWidgetClassName
]

{ #category : #accessing }
PBBlog >> socialSharingWidgetClassName: anObjectName [
	socialSharingWidgetClassName := anObjectName
]

{ #category : #accessing }
PBBlog >> webMaster [
	^ webMaster
]

{ #category : #accessing }
PBBlog >> webMaster: aString [
	webMaster := aString
]

{ #category : #private }
PBBlog >> write: anObject description: aDescription [
	^ self class languages at: anObject ifAbsent: [ anObject ]
]

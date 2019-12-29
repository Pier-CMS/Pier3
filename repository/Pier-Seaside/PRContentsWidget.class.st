Class {
	#name : #PRContentsWidget,
	#superclass : #PRWidget,
	#instVars : [
		'component',
		'headAuthor',
		'headKeywords',
		'headTitle',
		'heading'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #testing }
PRContentsWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRContentsWidget class >> label [
	^ 'Contents'
]

{ #category : #private }
PRContentsWidget >> buildComponent: aContext [
	^ aContext command asComponent
		onAnswer: [ :value | self onAnswerContext: aContext command: value ];
		yourself
]

{ #category : #'accessing-dynamic' }
PRContentsWidget >> children [
	^ Array with: self component
]

{ #category : #accessing }
PRContentsWidget >> component [
	^ component ifNil: [ component := self buildComponent: self context ]
]

{ #category : #accessing }
PRContentsWidget >> component: aComponent [
	component := aComponent
]

{ #category : #descriptions }
PRContentsWidget >> descriptionHeadAuthor [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The author to appear in the html head.';
		accessor: #headAuthor;
		label: 'Head Author';
		priority: 220;
		beSetting;
		yourself
]

{ #category : #descriptions }
PRContentsWidget >> descriptionHeadKeywords [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The keywords to appear in the html head.';
		accessor: #headKeywords;
		label: 'Head Keywords';
		default: '%k %t';
		priority: 210;
		beSetting;
		yourself
]

{ #category : #descriptions }
PRContentsWidget >> descriptionHeadTitle [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The title to appear in the browser window.';
		accessor: #headTitle;
		label: 'Head Title';
		default: '%k: %t';
		priority: 200;
		beSetting;
		yourself
]

{ #category : #descriptions }
PRContentsWidget >> descriptionHeading [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The header to appear on before the page contents.';
		accessor: #heading;
		label: 'Heading';
		priority: 110;
		yourself
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headAuthor [
	^ self expand: headAuthor
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headAuthor: aHeadAuthor [
	headAuthor := aHeadAuthor
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headKeywords [
	^ self expand: headKeywords
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headKeywords: aHeadKeywords [
	headKeywords := aHeadKeywords
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headTitle [
	^ self expand: headTitle
]

{ #category : #'accessing-properties' }
PRContentsWidget >> headTitle: aHeadTitle [
	headTitle := aHeadTitle
]

{ #category : #'accessing-properties' }
PRContentsWidget >> heading [
	^ self expand: heading
]

{ #category : #'accessing-properties' }
PRContentsWidget >> heading: aHeading [
	heading := aHeading
]

{ #category : #events }
PRContentsWidget >> onAnswerContext: aContext command: aCommand [
	aCommand isNil
		ifTrue: [ ^ self context: aContext command cancelAnswer ].
	[ aCommand execute ]
		on: MAError
		do: [ :err | ^ self component errors add: err ].
	self context: aCommand successAnswer
]

{ #category : #events }
PRContentsWidget >> onChangeContext: aContext [
	super onChangeContext: aContext.
	aContext command isQuick
		ifTrue: [ self onAnswerContext: aContext command: aContext command ]
		ifFalse: [ self component: (self buildComponent: aContext) ]
]

{ #category : #rendering }
PRContentsWidget >> renderContentOn: html [
	PRContentsRendered value
		ifTrue: [ ^ self ].
	PRContentsRendered use: true during: [
		self heading isEmptyOrNil ifFalse: [
			html heading
				level: 1;
				class: 'heading';
				with: self heading ].
		html render: self component ]
]

{ #category : #'accessing-dynamic' }
PRContentsWidget >> states [
	^ Array with: self
]

{ #category : #updating }
PRContentsWidget >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	aHtmlRoot title: self headTitle.
	self context command updateRoot: aHtmlRoot.
	self headAuthor isEmptyOrNil ifFalse: [
		aHtmlRoot meta
			name: 'author';
			content: self headAuthor ].
	self headKeywords isEmptyOrNil ifFalse: [
		aHtmlRoot meta
			name: 'keywords';
			content: self headKeywords ]
]

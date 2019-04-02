Class {
	#name : #PRTagCloudWidget,
	#superclass : #PRWidget,
	#instVars : [
		'tags',
		'tagsByCount',
		'tagsByName',
		'focus',
		'mean',
		'deviation',
		'ignoredTags',
		'maxItems',
		'showExponential',
		'showFrequencies',
		'startAt',
		'dataDescriptions',
		'optionsAndLabels'
	],
	#classVars : [
		'StopWords'
	],
	#category : #'Pier-TagCloud'
}

{ #category : #initialization }
PRTagCloudWidget class >> initialize [
	StopWords := Set withAll: #('--' '---' 'about' 'after' 'all' 'also' 'always' 'am' 'an' 'and' 'any' 'are' 'as' 'at' 'before' 'be' 'been' 'being' 'but' 'by' 'can' 'com' 'could' 'de' 'default' 'do' 'each' 'en' 'etc' 'example' 'first' 'for' 'from' 'gif' 'go' 'googleusercontent' 'had' 'has' 'have' 'he' 'her' 'here' 'hers' 'herself' 'him' 'himself' 'how' 'http' 'https' 'if' 'in' 'into' 'is' 'it' 'its' 'itself' 'la' 'just' 'like' 'me' 'mine' 'more' 'my' 'myself' 'need' 'new' 'not' 'now' 'of' 'off' 'on' 'one' 'oneself' 'only' 'or' 'our' 'ours' 'ourselves' 'out' 'own' 'over' 'png' 'really' 'she' 'should' 'so' 'some' 'such' 'than' 'that' 'the' 'their' 'theirs' 'them' 'themselves' 'then' 'there' 'these' 'they' 'this' 'those' 'to' 'und' 'us' 'use' 'using' 'very' 'want' 'was' 'we' 'what' 'when' 'where' 'which' 'who' 'will' 'with' 'wordpress' 'would' 'wp' 'wp-includes' 'www' 'you' 'your' 'yours' 'yourself' 'yourselves')
]

{ #category : #testing }
PRTagCloudWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRTagCloudWidget class >> label [
	^ 'Tag Cloud'
]

{ #category : #private }
PRTagCloudWidget >> computeParameters [
	| count |
	count := self tagsByCount size max: 1.
	mean := 0.0.
	deviation := 0.0.
	self tagsByCount do: [ :each | mean := mean + each value size ].
	mean := mean / count.
	self tagsByCount do: [ :each | deviation := deviation + (mean - each value size) abs ].
	deviation := deviation / count.
	deviation = 0.0 ifTrue: [ deviation := 1.0 ]
]

{ #category : #accessing }
PRTagCloudWidget >> dataDescriptions [
	^ dataDescriptions ifNil: [ dataDescriptions := self descriptionDataDescriptions default ]
]

{ #category : #accessing }
PRTagCloudWidget >> dataDescriptions: anObject [
	dataDescriptions := anObject
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionDataDescriptions [
	<magritteDescription>

	^ MAMultipleOptionDescription new
		optionsAndLabels: self optionsAndLabels associations;
		reference: MADescription basicNew initialize magritteDescription;
		accessor: #dataDescriptions;
		default: self optionsAndLabels keys;
		priority: 220;
		label: 'Data';
		beDistinct;
		yourself
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionIgnoredTags [
	<magritteDescription>
	^ MAMemoDescription new
		accessor: #ignoredTags;
		label: 'Ignored tags';
		priority: 220;
		yourself
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionMaxItems [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #maxItems;
		label: 'Max Items';
		priority: 220;
		default: 50;
		beInteger;
		min: 1;
		yourself
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionShowExponential [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Exponential';
		accessor: #showExponential;
		default: false;
		priority: 235;
		yourself
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionShowFrequencies [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #showFrequencies;
		checkboxLabel: 'Frequencies';
		default: false;
		label: 'Show';
		priority: 230;
		yourself
]

{ #category : #'accessing-description' }
PRTagCloudWidget >> descriptionStructure [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: #startAt;
		label: 'Start At';
		priority: 200;
		yourself
]

{ #category : #accessing }
PRTagCloudWidget >> deviation [
	deviation isNil
		ifTrue: [ self computeParameters ].
	^ deviation
]

{ #category : #accessing }
PRTagCloudWidget >> enumerator [
	"Answer an enumerator to visit the necessary structures to collect the tags."
	
	^ (self context enumeratorFor: self structure) with all
]

{ #category : #actions }
PRTagCloudWidget >> focus: anAssocation [
	focus := anAssocation
]

{ #category : #accessing }
PRTagCloudWidget >> ignoredTags [
	^ ignoredTags
]

{ #category : #accessing }
PRTagCloudWidget >> ignoredTags: anObject [
	ignoredTags := anObject
]

{ #category : #accessing }
PRTagCloudWidget >> maxItems [
	^ maxItems
]

{ #category : #accessing }
PRTagCloudWidget >> maxItems: anObject [
	maxItems := anObject
]

{ #category : #accessing }
PRTagCloudWidget >> mean [
	mean isNil
		ifTrue: [ self computeParameters ].
	^ mean
]

{ #category : #'as yet unclassified' }
PRTagCloudWidget >> optionsAndLabels [
	^ optionsAndLabels ifNil: [ optionsAndLabels := Dictionary new.
		PRStructure
			withAllConcreteClassesDo: [ :class | 
				class new magritteDescription
					do: [ :each | 
						each isTagCloud
							ifTrue: [ optionsAndLabels at: each put: each label ] ] ].
		optionsAndLabels ]
]

{ #category : #rendering }
PRTagCloudWidget >> renderCloudOn: html [
	self tagsByName 
		do: [ :assoc | self renderTag: assoc on: html ]
		separatedBy: [ html text: ' ' ]
]

{ #category : #rendering }
PRTagCloudWidget >> renderContentOn: html [
	focus isNil
		ifTrue: [ self renderCloudOn: html ]
		ifFalse: [ self renderFocusOn: html ]
]

{ #category : #rendering }
PRTagCloudWidget >> renderFocusOn: html [
	| structures related |
	structures := focus value asSet
		asSortedCollection: [ :a :b | a title < b title ].
	html heading level: 1; with: [ 
		html anchor
			callback: [ focus := nil ];
			with: focus key ].
	html definitionList: [
		structures do: [ :each |
			html definitionTerm: [
				html anchor
					callback: [ 
						self context: (self context structure: each).
						focus := nil ];
					with: each title ].
			html definitionData: [
				related := self tagsByCount
					select: [ :assoc | assoc key ~= focus key and: [ assoc value includes: each ] ].
				((related last: (5 min: related size))
					asSortedCollection: [ :a :b | a key < b key ])
					do: [ :assoc | self renderTag: assoc on: html ]
					separatedBy: [ html text: ' ' ] ] ] ]
]

{ #category : #rendering }
PRTagCloudWidget >> renderTag: anAssociation on: html [
	| diff percent |
	(self showExponential)
		ifTrue: [
			| min max |
			min := self tagsByCount first value size.
			max := self tagsByCount last value size.
			(diff := max - min) isZero
				ifTrue: [ diff := 1 ].
			percent := ((anAssociation value size - min) * 100.0 / diff) + 100 ]
		ifFalse: [
			diff := ((anAssociation value size - self mean) / self deviation) exp.
			percent := ((diff - 1) / (diff + 1) * (1.8 ln)) exp * 100.0 ].
		
	self renderTag: anAssociation on: html fontSize: percent
]

{ #category : #rendering }
PRTagCloudWidget >> renderTag: anAssociation on: html fontSize: fontSize [
	html span class: 'tag'; with: [
		html anchor
			callback: [ self focus: anAssociation ];
			style: 'font-size: ' , fontSize truncated asString , '%';
			with: anAssociation key.
		(self showFrequencies) ifTrue: [
			html span
				class: 'freq';
				with: [ html space; text: '('; render: anAssociation value size; text: ')' ] ] ]
]

{ #category : #actions }
PRTagCloudWidget >> reset [
	tags := tagsByName := tagsByCount := focus := mean := deviation := nil
]

{ #category : #accessing }
PRTagCloudWidget >> showExponential [
	^ showExponential
]

{ #category : #accessing }
PRTagCloudWidget >> showExponential: anObject [
	showExponential := anObject
]

{ #category : #accessing }
PRTagCloudWidget >> showFrequencies [
	^ showFrequencies
]

{ #category : #accessing }
PRTagCloudWidget >> showFrequencies: anObject [
	showFrequencies := anObject
]

{ #category : #accessing }
PRTagCloudWidget >> startAt [
	^ startAt
]

{ #category : #accessing }
PRTagCloudWidget >> startAt: anObject [
	startAt := anObject
]

{ #category : #accessing }
PRTagCloudWidget >> structure [
	"Answer the structure where the search for the tag cloud should start from."
	
	^ self startAt ifNil: [ self startAt: self context root. self startAt ]
]

{ #category : #accessing }
PRTagCloudWidget >> tags [
	"Answer a dictionary mapping tags to structures."
	
	tags isNil
		ifFalse: [ ^ tags ].
	tags := Dictionary new.
	self enumerator do: [ :struct |
		(self dataDescriptions) do: [ :description |
			(self tokenize: struct using: description) do: [ :tag |
				(tags at: tag ifAbsentPut: [ OrderedCollection new ])
					add: struct ] ] ].
	^ tags
]

{ #category : #accessing }
PRTagCloudWidget >> tagsByCount [
	"Answer a dictionary mapping tags to structures. The tags are sorted by count and cut to a certain threshold."
	
	tagsByCount isNil
		ifFalse: [ ^ tagsByCount ].
	tagsByCount := SortedCollection
		sortBlock: [ :a :b | a value size < b value size ].
	self tags associationsDo: [ :assoc | tagsByCount add: assoc ].
	(self maxItems) isNil
		ifFalse: [ tagsByCount := tagsByCount last: (tagsByCount size min: (self maxItems)) ].
	^ tagsByCount
]

{ #category : #accessing }
PRTagCloudWidget >> tagsByName [
	"Answer the tags alphabetically sorted by name."
	
	tagsByName isNil
		ifFalse: [ ^ tagsByName ].
	^ tagsByName := self tagsByCount 
		asSortedCollection: [ :a :b | a key < b key ]
]

{ #category : #private }
PRTagCloudWidget >> tokenize: anObject using: aDescription [
	| string tokens ignoredTokens |
	(aDescription accessor canRead: anObject)
		ifFalse: [ ^ #() ].
	string := aDescription toString: (anObject readUsing: aDescription).
	string := string collect: [ :each | 
		each isLetter
			ifTrue: [ each asLowercase ]
			ifFalse: [ 
				each = $-
					ifTrue: [ each ]
					ifFalse: [ $  ] ] ].
	tokens := string findTokens: ' '.
	ignoredTokens := self ignoredTags findTokens: ' '.
	^ tokens reject: [ :each | each size = 1 or: [ (StopWords includes: each) or: [ignoredTokens includes: each] ] ]

]

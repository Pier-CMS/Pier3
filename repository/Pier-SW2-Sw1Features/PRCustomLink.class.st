"
A PRCustomLink is an external link which can be modified in code ad hoc.  It uses StringToUrlBlocks to hold a OrderedCollection of blocks that can either create a URL or return nil.
"
Class {
	#name : #PRCustomLink,
	#superclass : #PRExternalLink,
	#classVars : [
		'StringToUrlBlocks'
	],
	#category : #'Pier-SW2-Sw1Features'
}

{ #category : #accessing }
PRCustomLink class >> addConversion: aBlock [
	aBlock argumentCount = 1
		ifFalse: [ self error: 'This expects a one argument block' ].
	self stringToUrlBlocks add: aBlock
]

{ #category : #'private-testing' }
PRCustomLink class >> conversions: aCollection [
	aCollection isCollection
		ifFalse: [ self error: 'The argument must be a collection.' ].
	StringToUrlBlocks := aCollection
]

{ #category : #accessing }
PRCustomLink class >> example [
	"Change *google pharo smalltalk* => https://www.google.com/search?q=pharo+smalltalk"

	self
		addConversion: [ :aString | 
			('google *' match: aString)
				ifTrue: [ 'https://www.google.com/search?q='
						, (aString copyReplaceAll: ' ' with: '+') ] ]
]

{ #category : #testing }
PRCustomLink class >> isValidReference: aString [
	^ self stringToUrlBlocks contains: [ :block | (block value: aString) notNil ]
]

{ #category : #accessing }
PRCustomLink class >> stringToUrlBlocks [
	StringToUrlBlocks isNil
		ifTrue: [ StringToUrlBlocks := OrderedCollection new ].
	^ StringToUrlBlocks
]

{ #category : #'accessing-dynamic' }
PRCustomLink >> url [
	^ (self class stringToUrlBlocks detect: [ :e | (e value: self reference) notNil ]) value: self reference
]

"
I am syntax highlighted Smalltalk Code.  This is used with the == tag.
"
Class {
	#name : #SPHighlightedCode,
	#superclass : #PRPreformatted,
	#instVars : [
		'text',
		'ranges',
		'classOrMetaClass'
	],
	#category : #'Pier-Shout'
}

{ #category : #initialization }
SPHighlightedCode class >> initialize [
	PRPillarParser markups at: self markup put: self
]

{ #category : #accessing }
SPHighlightedCode class >> markup [
	^ '=='
]

{ #category : #initialization }
SPHighlightedCode class >> unload [
	PRDocumentParser lineMatcher removeKey: self markup
]

{ #category : #visiting }
SPHighlightedCode >> accept: aVisitor [
	aVisitor visitHighlightedCode: self
]

{ #category : #accessing }
SPHighlightedCode >> classOrMetaClass [
	^ classOrMetaClass
]

{ #category : #accessing }
SPHighlightedCode >> classOrMetaClass: anObject [
	classOrMetaClass := anObject
]

{ #category : #accessing }
SPHighlightedCode >> ranges [
	^ ranges ifNil: [ ranges := self rangesFor: self text ]
]

{ #category : #private }
SPHighlightedCode >> rangesFor: aString [
	"Try to find out if this is a method, maybe with a class declaration. Otherwise parse as expression."

	| parser index string |
	parser := SHParserST80 new.
	parser classOrMetaClass: classOrMetaClass.
	(index := aString indexOfSubCollection: '>>') = 0
		ifTrue: [ index := 1 ]
		ifFalse: [ (((aString first: index - 1) allSatisfy: [ :each | each isAlphaNumeric ])
				or: [ ((aString first: index - 1) endsWith: ' class')
						and: [ (aString first: index - 7) allSatisfy: [ :each | each isAlphaNumeric ] ] ])
				ifTrue: [ index := aString size min: index + 2 ]
				ifFalse: [ index := 1 ] ].
	string := aString copyFrom: index to: aString size.
	parser
		source: string;
		parse: 1 < index.
	(index = 1
		and: [ parser ranges notEmpty and: [ parser ranges last type = #excessCode ] ])
		ifTrue: [ parser parse: true ].
	(parser ranges notEmpty and: [ 1 < index ])
		ifTrue: [ parser ranges
				do: [ :each | 
					each start: each start + index - 1.
					each end: each end + index - 1 ].
			parser ranges first start: 1 ].
	^ parser ranges
]

{ #category : #rendering }
SPHighlightedCode >> renderOn: html [
	| stream next end lastEnd |
	lastEnd := 1.
	stream := self ranges readStream.
	[	end := stream atEnd 
			ifTrue: [ text size ] 
			ifFalse: [ stream peek start - 1 ].
		lastEnd <= end 
			ifTrue: [ self renderText: (text copyFrom: lastEnd to: end) on: html ].
		stream atEnd ifFalse: [
			next := stream next.
			html span
				class: next type;
				with: [ self renderText: (text copyFrom: (next start max: lastEnd) to: next end) on: html ].
			lastEnd := next end + 1 ].
		stream atEnd ] whileFalse.
	self renderText: (text copyFrom: lastEnd to: text size) on: html
]

{ #category : #rendering }
SPHighlightedCode >> renderText: aString on: html [
	| stream |
	aString isEmpty 
		ifTrue: [ ^ self ].
	stream := aString readStream.
	[ stream atEnd ] whileFalse: [
		html text: (stream upTo: Character cr).
		stream atEnd
			ifFalse: [ html break ] ].
	aString last = Character cr
		ifTrue: [ html break ]
]

{ #category : #initialization }
SPHighlightedCode >> setChildren: aCollection [
	super setChildren: aCollection.
	text := ranges := nil
]

{ #category : #accessing }
SPHighlightedCode >> text [
	^ text ifNil: [ text := self textFor: self children ]
]

{ #category : #accessing }
SPHighlightedCode >> text: aText [
	text := aText.

]

{ #category : #private }
SPHighlightedCode >> textFor: aCollection [
	^ String streamContents: [ :stream |
		aCollection
			do: [ :each | stream nextPutAll: each text ]
			separatedBy: [ stream cr ] ]
]

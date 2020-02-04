"
I am a parent of different lookup visitors. My main uses are validating page names, for example: 

 PRPath isValidName: 'Name with spaces is invalid'.
 PRPath isValidName: 'Name/with/slashes/is/invalid'.
 PRPath isValidName: 'Name-with-dashes-or_underscores_or.dots.is-valid'.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	escaper:		<Block>
	stream:		<Stream>

"
Class {
	#name : #PRPath,
	#superclass : #PRVisitor,
	#instVars : [
		'stream',
		'escaper'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #accessing }
PRPath class >> currentStructure [
	^ '.'
]

{ #category : #testing }
PRPath class >> isValidCharacter: aCharacter [
	^ aCharacter isAlphaNumeric or: [ '-._' includes: aCharacter ]
]

{ #category : #testing }
PRPath class >> isValidName: aString [
	^ aString isNil not
		and: [ aString isEmpty not
		and: [ aString ~= self parentStructure
		and: [ aString ~= self currentStructure
		and: [ aString allSatisfy: [ :char | self isValidCharacter: char ] ] ] ] ]
]

{ #category : #accessing }
PRPath class >> parentStructure [
	^ '..'
]

{ #category : #accessing }
PRPath class >> pathDelimiter [
	^ $/
]

{ #category : #accessing }
PRPath >> escape: anObject [
	escaper value: anObject
]

{ #category : #accessing }
PRPath >> hasEscaper [
	^ escaper notNil
]

{ #category : #accessing }
PRPath >> stream [
	^ stream
]

{ #category : #accessing }
PRPath >> stream: aStream [
	stream := aStream
]

{ #category : #accessing }
PRPath >> withEscaper: aBlock [
	| old |
	old := escaper.
	escaper := [ :value | ^ value ].
	^ aBlock
		ensure: [ escaper := old ]
]

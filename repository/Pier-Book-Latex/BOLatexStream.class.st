Class {
	#name : #BOLatexStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#classVars : [
		'LatexCharacters'
	],
	#category : #'Pier-Book-Latex'
}

{ #category : #initialization }
BOLatexStream class >> initialize [
	LatexCharacters := Dictionary new.
	LatexCharacters
		at: $# put: '\#';
		at: $& put: '\&';
		at: $% put: '\%';
		at: $$ put: '\$';
		at: ${ put: '\{';
		at: $} put: '\}';
		at: $_ put: '\_';
		at: $" put: '\symbol{34}';
		" -- "
		at: $[ put: '{[}';
		at: $] put: '{]}';
		at: $| put: '$|$';
		at: $< put: '$<$';
		at: $> put: '$>$';
		at: $/ put: '$/$';
		at: $\ put: '$\backslash$';
		at: $^ put: '$\uparrow$';
		" -- "
		at: $ä put: '\"{a}';
		at: $Ä put: '\"{A}';
		at: $ë put: '\"{e}';
		at: $Ë put: '\"{E}';
		at: $ï put: '\"{i}';
		at: $Ï put: '\"{I}';
		at: $ö put: '\"{o}';
		at: $Ö put: '\"{O}';
		at: $ü put: '\"{u}';
		at: $Ü put: '\"{U}';
		at: $ÿ put: '\"{y}';
		at: $ put: '\"{Y}';
		" -- "
		at: $â put: '\^{a}';
		at: $Â put: '\^{A}';
		at: $ê put: '\^{e}';
		at: $Ê put: '\^{E}';
		at: $î put: '\^{i}';
		at: $Î put: '\^{I}';
		at: $ô put: '\^{o}';
		at: $Ô put: '\^{O}';
		at: $û put: '\^{u}';
		at: $Û put: '\^{U}';
		" -- "
		at: $à put: '\`{a}';
		at: $À put: '\`{A}';
		at: $è put: '\`{e}';
		at: $È put: '\`{E}';
		at: $ì put: '\`{i}';
		at: $Ì put: '\`{I}';
		at: $ò put: '\`{o}';
		at: $Ò put: '\`{O}';
		at: $ù put: '\`{u}';
		at: $Ù put: '\`{U}';
		" -- "
		at: $á put: '\''{a}';
		at: $Á put: '\''{A}';
		at: $é put: '\''{e}';
		at: $í put: '\''{i}';
		at: $Í put: '\''{I}';
		at: $ó put: '\''{o}';
		at: $Ó put: '\''{O}';
		at: $ú put: '\''{u}';
		at: $Ú put: '\''{U}';
		" -- "
		at: $ç put: '\c{c}';
		at: $Ç put: '\c{C}';
		" -- "
		at: $~ put: '\~{}';
		at: $ñ put: '\~{n}';
		at: $Ñ put: '\~{N}'
]

{ #category : #'instance creation' }
BOLatexStream class >> on: aStream [
	^ self basicNew initializeOn: aStream
]

{ #category : #convenience }
BOLatexStream >> comment: anObject [
	stream
		nextPut: $%;
		space;
		nextPutAll: anObject greaseString;
		nextPut: Character lf
]

{ #category : #accessing }
BOLatexStream >> contents [
	^ stream contents
]

{ #category : #convenience }
BOLatexStream >> cr [
]

{ #category : #convenience }
BOLatexStream >> curly: anObject [
	stream nextPut: ${.
	self print: anObject.
	stream nextPut: $}
]

{ #category : #convenience }
BOLatexStream >> environment: aString do: anObject [
	self tag: 'begin'; curly: aString; lf.
	self print: anObject.
	self tag: 'end'; curly: aString; lf
]

{ #category : #initialization }
BOLatexStream >> initializeOn: aStream [
	stream := aStream
]

{ #category : #testing }
BOLatexStream >> isEmpty [
	^ stream isEmpty
]

{ #category : #streaming }
BOLatexStream >> lf [
	stream nextPut: Character lf
]

{ #category : #convenience }
BOLatexStream >> line: aString [
	self
		nextPutAll: aString;
		newLine
]

{ #category : #convenience }
BOLatexStream >> lineBreak [
	stream nextPutAll: '\\'
	
]

{ #category : #convenience }
BOLatexStream >> lines: aString [
	"Output aString and take care of line ending within aString."
	| str |
	str := aString readStream.
	[str atEnd] whileFalse: [ 
		self line: str nextLine.
	 ]
]

{ #category : #convenience }
BOLatexStream >> newLine [
	self lf
]

{ #category : #streaming }
BOLatexStream >> nextPut: aCharacter [
	| string |
	string := LatexCharacters at: aCharacter ifAbsent: nil.
	string isNil
		ifTrue: [ stream nextPut: aCharacter ]
		ifFalse: [ stream nextPutAll: string ]
]

{ #category : #streaming }
BOLatexStream >> nextPutAll: anObject [
	anObject greaseString do: [ :each | self nextPut: each ]
]

{ #category : #streaming }
BOLatexStream >> print: anObject [
	anObject isNil
		ifTrue: [ ^ self ].
	anObject isBlock
		ifTrue: [ anObject value ]
		ifFalse: [ self nextPutAll: anObject greaseString ]
]

{ #category : #'convenience-raw' }
BOLatexStream >> rawLine: aString [ 
	stream	nextPutAll: aString.
	self newLine

]

{ #category : #'convenience-raw' }
BOLatexStream >> rawLines: aString [
	"Output aString and take care of line ending within aString."
	| str |
	str := aString readStream.
	[str atEnd] whileFalse: [ 
		self rawLine: str nextLine.
	 ]
]

{ #category : #'as yet unclassified' }
BOLatexStream >> rawNextPutAll: aString [ 
	stream nextPutAll: aString
]

{ #category : #streaming }
BOLatexStream >> space [
	stream space
]

{ #category : #convenience }
BOLatexStream >> square: anObject [
	stream nextPut: $[.
	self print: anObject.
	stream nextPut: $]
]

{ #category : #convenience }
BOLatexStream >> star [
	stream nextPut: $*
]

{ #category : #accessing }
BOLatexStream >> stream [
	^ stream
]

{ #category : #streaming }
BOLatexStream >> tab [
	stream tab
]

{ #category : #convenience }
BOLatexStream >> tag: aString [
	stream nextPut: $\; nextPutAll: aString
]

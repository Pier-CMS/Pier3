Class {
	#name : #BOPortion,
	#superclass : #BOPublication,
	#instVars : [
		'type'
	],
	#category : #'Pier-Book-Structures'
}

{ #category : #testing }
BOPortion class >> canBeChildOf: aStructureClass [
	^ aStructureClass includesBehavior: BOPublication
]

{ #category : #initialization }
BOPortion class >> initialize [
	self migrateClasses
]

{ #category : #testing }
BOPortion class >> isAbstract [
	^ false
]

{ #category : #accessing }
BOPortion class >> label [
	^ 'Book Portion'
]

{ #category : #initialization }
BOPortion class >> migrateClasses [
	GRPlatform current magritteAllSubInstancesOf: BOSubsection do: [ :structure |
		structure become: (self basicNew
			copyFrom: structure;
			type: #subsection) ].
	GRPlatform current magritteAllSubInstancesOf: BOSection do: [ :structure |
		structure become: (self basicNew
			copyFrom: structure;
			type: #section) ].
	GRPlatform current magritteAllSubInstancesOf: BOChapter do: [ :structure |
		structure become: (self basicNew
			copyFrom: structure;
			type: #chapter) ].
	GRPlatform current magritteAllSubInstancesOf: BOPart do: [ :structure |
		structure become: (self basicNew
			copyFrom: structure;
			type: #part) ].
	GRPlatform current magritteAllSubInstancesOf: BOPublication do: [ :structure |
		structure parent: structure parent ]
]

{ #category : #visiting }
BOPortion >> accept: aVisitor [
	aVisitor visitPortion: self
]

{ #category : #private }
BOPortion >> arabicToRoman: anInteger [
	"Convert an arabic integer to a roman string."
	
	| number roman |
	number := anInteger.
	roman := WriteStream on: String new.
	#((1000 'M') (900 'CM') (500 'D') (400 'CD') (100 'C') (90 'XC') (50 'L') (40 'XL') (10 'X') (9 'IX') (5 'V') (4 'IV') (1 'I')) do: [ :pair |
		[ number >= pair first ] whileTrue: [
			roman nextPutAll: pair second.
			number := number - pair first ] ].
	^ roman contents
]

{ #category : #accessing }
BOPortion >> cssClass [
	^ super cssClass ,  ' ' , self type greaseString
]

{ #category : #descriptions }
BOPortion >> descriptionLabel [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'label';
		accessor: #label;
		priority: 50;
		beReadonly;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOPortion >> descriptionNumber [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'number';
		accessor: #number;
		beReadonly;
		yourself
]

{ #category : #private }
BOPortion >> descriptionType [
	"no pragma here as we don't want to automatically include this description, instead 
	BOPortion>>#magritteDescription conditional adds this description"
	^ MASingleOptionDescription new
		optionsAndLabels: (self class typeSymbolsAndLabels
			copyFrom: 2 to: 3);
		accessor: #type;
		priority: 50;
		label: 'Type';
		beEditable;
		beRequired;
		yourself
]

{ #category : #accessing }
BOPortion >> index [
	"Answer the index number of this publication, for example the chapter or section number."
	
	| enumerator siblings |
	self parent ifNil: [ ^ nil ].
	enumerator := self isChapter
		ifFalse: [ self parent enumerator ]
		ifTrue: [
			| root |
			root := self
				findAncestor: [ :each | each isPublication and: [ each isBook ] ]
				ifAbsent: [ ^ nil ].
			root enumerator everything ].
	siblings := enumerator select: [ :each | 
		each isPublication 
			and: [ each isNumberedTitle
			and: [ each type = self type ] ] ].
	^ siblings indexOf: self ifAbsent: [ nil ]
]

{ #category : #accessing }
BOPortion >> label [
	^ super label , ' ' , (self number ifNil: [ '' ])
]

{ #category : #'acessing-magritte' }
BOPortion >> magritteDescription [
	"Direct descendents of a book can be a part or a chapter, that's why we needs an additional setting."

	^ (self parent isNil or: [ self parent isBook not ])
		ifTrue: [ super magritteDescription ]
		ifFalse: [ 
			super magritteDescription copy
				add: self descriptionType;
				yourself ]
]

{ #category : #accessing }
BOPortion >> number [
	"Answer the composed numbers."

	| root parents |
	self isParagraph
		ifTrue: [ ^ nil ].
	self isPart
		ifTrue: [ ^ self arabicToRoman: (self index ifNil: [ ^ nil ]) ].
	root := self 
		findAncestor: [ :each | each isPublication and: [ each isBook or: [ each isPart ] ] ]
		ifAbsent: [ ^ nil ].
	parents := (((self parents 
		copyAfter: root)
		collect: [ :each | each index ])
		reject: [ :each | each isNil ])
		collect: [ :each | each greaseString ].
	^ parents isEmpty
		ifFalse: [ parents reduce: [ :a :b | a , '.' , b ] ]
]

{ #category : #accessing }
BOPortion >> parent: aStructure [
	"This is pretty ugly code that ensures a consistent labeling of book, part, chapter, section, subsection, subsubsection and paragraph. It is complicated because parts are optional. If this overflows just make a paragraph out of everything."

	super parent: aStructure.
	self parent ifNil: [ ^ self ].
	self type: (self parent isBook
		ifTrue: [
			(self isPart or: [ self isChapter ])
				ifTrue: [ ^ self ]
				ifFalse: [ #chapter ] ]
		ifFalse: [
			self class typeSymbols
				at: (self class typeSymbols 
					indexOf: self parent type
					ifAbsent: [ ^ self error: 'Interal Error' ]) + 1
				ifAbsent: [ self class typeSymbols last ] ])
]

{ #category : #printing }
BOPortion >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' type: '; print: self type
]

{ #category : #accessing }
BOPortion >> refLabel [
	^ super refLabel , ' ' , (self number ifNil: [ '' ])
]

{ #category : #accessing }
BOPortion >> type [
	^ type
]

{ #category : #accessing }
BOPortion >> type: aSymbol [
	"Update the type of the receiver if necessary. Also update the children."
	
	(self type = aSymbol)
		ifTrue: [ ^ self ].
	(self class typeSymbols includes: aSymbol)
		ifFalse: [ self error: 'Invalid type: ' , aSymbol printString ].
	type := aSymbol.
	self enumerator
		do: [ :each | each parent: self ]
]

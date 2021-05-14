Class {
	#name : #BOLatexWriter,
	#superclass : #PRDocumentWriter,
	#instVars : [
		'items',
		'latex'
	],
	#category : #'Pier-Book-Latex'
}

{ #category : #accessing }
BOLatexWriter class >> writerName [
	^ #latex
]

{ #category : #queries }
BOLatexWriter >> convertHtmlEntities: aString [
	^ ((((aString 
		copyReplaceAll: '&lt;' with: '<')
		copyReplaceAll: '&gt;' with: '>')
		copyReplaceAll: '&amp;' with: '&')
		copyReplaceAll: '&larr;' with: '<-')
		copyReplaceAll: '&rarr;' with: '->'

]

{ #category : #queries }
BOLatexWriter >> findItem: aBlock ifAbsent: anAbsentBlock [
	items size to: 1 by: -1 do: [ :index |
		(aBlock value: (items at: index))
			ifTrue: [ ^ items at: index ] ].
	^ anAbsentBlock value
]

{ #category : #generating }
BOLatexWriter >> generateBookPdf: aBook [
	latex comment: 'hypersetup'.
	latex tag: 'hypersetup'; curly: [
		latex lf; tab; print: 'pdftitle='; curly: aBook title trimBoth; print: ','.
		aBook authors isNil 
			ifFalse: [ latex lf; tab; print: 'pdfauthor='; curly: aBook authors trimBoth; lf ] ].
	latex lf
]

{ #category : #generating }
BOLatexWriter >> generateBookTitle: aBook [
	latex comment: 'title'.
	latex tag: 'label'; curly: (self structureLabelFor: aBook); lf.
	latex tag: 'title'; curly: aBook title trimBoth; lf.
	aBook authors isNil ifFalse: [
		latex tag: 'author'; curly: [
			(aBook authors findTokens: ',')
				do: [ :each | latex nextPutAll: each trimBoth; lf ]
				separatedBy: [ latex tag: 'and'; nextPutAll: ' ' ].
			aBook additionalAuthors isNil ifFalse: [
				latex stream nextPutAll: '\\[4ex]'; lf.
				latex nextPutAll: 'with '; nextPutAll: aBook additionalAuthors trimBoth; lf ] ] ].
	latex tag: 'date'; curly: Date today; lf.
	latex lf
]

{ #category : #generating }
BOLatexWriter >> generatePublication: aStructure type: aString [
	latex lf; lf.
	latex comment: aStructure absolutePath.
	aStructure isIgnoredTitle
		ifTrue: [ ^ self ].
	latex
		tag: aString;
		print: (aStructure isNumberedTitle
			ifFalse: [ '*' ]);
		curly: aStructure title trimBoth;
		lf.
	latex
		tag: 'label';
		curly: (self structureLabelFor: aStructure);
		lf; lf
]

{ #category : #accessing }
BOLatexWriter >> newLineSize [
	^ 2
]

{ #category : #queries }
BOLatexWriter >> publication [
	^ self 
		findItem: [ :each | (each isKindOf: PRStructure) and: [ each isPublication ] ]
		ifAbsent: [ ^ self ].
]

{ #category : #accessing }
BOLatexWriter >> stream: aStream [
	super stream: aStream.
	latex := BOLatexStream on: aStream.
	items := OrderedCollection new: 1000
]

{ #category : #queries }
BOLatexWriter >> stringLabelFor: aString [
	^ aString greaseString select: [ :each | each isAlphaNumeric ]
]

{ #category : #queries }
BOLatexWriter >> structureLabelFor: aStructure [
	^ self structureLabelFor: aStructure with: nil
]

{ #category : #queries }
BOLatexWriter >> structureLabelFor: aStructure with: aString [
	| parents |
	parents := aStructure parents asOrderedCollection.
	[ parents isEmpty or: [ parents first isPublication ] ]
		whileFalse: [ parents removeFirst ].
	parents := parents 
		collect: [ :each | self stringLabelFor: each name ].
	aString isNil
		ifFalse: [ parents addLast: (self stringLabelFor: aString) ].
	^ parents isEmpty
		ifFalse: [ parents reduce: [ :a :b | a , ':' , b ] ]
]

{ #category : #visiting }
BOLatexWriter >> visit: anObject [
	| result |
	items addLast: anObject.
	result := super visit: anObject.
	items removeLast.
	^ result
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitAnchor: anAnchor [
	latex 
		tag: 'label'; 
		curly: [ stream nextPutAll: (self structureLabelFor: self publication with: anAnchor name) ];
		lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitAnnotatedParagraph: aParagraph [
	latex
		environment: aParagraph annotation
		do: [ super visitAnnotatedParagraph: aParagraph ]
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitBoldFormat: anObject [
	latex tag: 'textbf'; curly: [ super visitBoldFormat: anObject ]
]

{ #category : #'visiting-structure' }
BOLatexWriter >> visitBook: aStructure [
	latex comment: 'This is an automatically generated file, do not modify manually!'.
	latex comment: 'This book is published using Seaside, Magritte and the Pier book publishing engine.'.
	latex comment: DateAndTime now greaseString.
	latex lf.
	
	stream nextPutAll: aStructure latexHeader; nextPut: Character lf.
	latex lf.
	
	self generateBookPdf: aStructure.
	self generateBookTitle: aStructure.
	
	latex comment: 'document'.
	latex tag: 'begin'; curly: 'document'; lf.
	latex lf.
	
	latex tag: 'frontmatter'; lf.
	latex tag: 'maketitle'; lf.
	latex tag: 'tableofcontents'; lf.
	latex tag: 'sloppy'; lf.
	latex lf.
	
	latex tag: 'mainmatter'; lf.
	latex lf.

	super visitBook: aStructure.
	
	latex lf.
	latex tag: 'backmatter'; lf.
	
	stream nextPutAll: aStructure latexFooter; nextPut: Character lf.
	latex tag: 'end'; curly: 'document'; lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitDefinitionList: aDefinitionList [
	latex tag: 'begin'; curly: 'list'; curly: nil; curly: nil; lf.
	super visitDefinitionList: aDefinitionList.
	latex tag: 'end'; curly: 'list'; lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitEmptyParagraph: anObject [
	latex lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitExternalLink: anExternalLink [
	latex
		tag: 'href';
		curly: [ stream nextPutAll: anExternalLink url ];
		curly: [ super visitExternalLink: anExternalLink ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitHeader: aHeader [
	| kind |
	kind := #('subsubsection' 'paragraph' 'subparagraph')
		at: (aHeader level max: 3).
	latex tag: kind; star; curly: aHeader text; lf.
	latex tag: 'label'; curly: [ stream nextPutAll: (self structureLabelFor: self publication with: aHeader hash) ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitIndexLink: anIndexLink [
	latex tag: 'index'; curly: anIndexLink title trimBoth
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitInternalLink: anInternalLink [
	(anInternalLink isBroken)
		ifTrue: [ ^ latex tag: 'textcolor'; curly: 'red'; curly: [ super visitInternalLink: anInternalLink ] ].
	(anInternalLink isEmbedded and: [ anInternalLink target isFigure ]) ifTrue: [
		latex tag: 'begin'; curly: 'figure'; square: 'h!tbp'; lf.
		latex tab; tag: 'begin'; curly: 'center'; lf.
		latex tab; tab; tag: 'includegraphics'; square: [ stream nextPutAll: 'width='; print: ((anInternalLink parameterAt: 'width' ifAbsent: [ 100 ]) asNumber / 100.0); nextPutAll: '\textwidth' ]; curly: [ stream nextPutAll: (anInternalLink target file directory fullNameFor: anInternalLink target file filename) ]; lf.
		latex tab; tab; tag: 'caption'; curly: [
			latex nextPutAll: anInternalLink target title.
			(anInternalLink target title endsWithSubCollection: '.')
				ifFalse: [ latex nextPutAll: '.' ].
			latex tag: 'label'; curly: [ stream nextPutAll: (self structureLabelFor: anInternalLink target) ] ]; lf.
		latex tab; tag: 'end'; curly: 'center'; lf.
		^ latex tag: 'end'; curly: 'figure'; lf ].
	(anInternalLink isEmbedded)
		ifTrue: [ ^ self visit: anInternalLink target document ].
	latex
		tag: 'hyperref';
		square: [ stream nextPutAll: (self structureLabelFor: anInternalLink target with: anInternalLink anchor) ];
		curly: [ 
			anInternalLink hasChildren
				ifTrue: [ super visitInternalLink: anInternalLink ]
				ifFalse: [ latex nextPutAll: anInternalLink target title trimBoth ] ]
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitItalicFormat: anObject [
	latex tag: 'textit'; curly: [ super visitItalicFormat: anObject ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitLineBreak: aLineBreak [
	latex lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitLink: aLink [
	aLink hasChildren
		ifTrue: [ super visitLink: aLink ]
		ifFalse: [ latex print: aLink reference ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitListItem: anObject [
	latex tag: 'item'; space.
	super visitListItem: anObject.
	latex lf
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitMonospaceFormat: anObject [
	latex tag: 'ct'; curly: (self convertHtmlEntities: anObject text)
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitOrderedList: anOrderedList [
	latex environment: 'enumerate' do: [ super visitOrderedList: anOrderedList ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitParagraph: aParagraph [
	super visitParagraph: aParagraph.
	latex lf
]

{ #category : #'visiting-structure' }
BOLatexWriter >> visitPortion: aStructure [
	self generatePublication: aStructure type: aStructure type.
	super visitPortion: aStructure
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitPreformatted: aPreformatted [
	latex tag: 'Needspace'; curly: [ latex print: (aPreformatted children size min: 3); tag: 'baselineskip' ]; lf.
	latex environment: 'lstlisting' do: [
		aPreformatted children 
			do: [ :each | stream nextPutAll: (self convertHtmlEntities: each text); nextPut: Character lf ] ]
]

{ #category : #'visiting-structure' }
BOLatexWriter >> visitPublication: aStructure [
	aStructure isIgnoredBody
		ifFalse: [ self visit: aStructure document ].
	aStructure enumerator do: [ :structure |
		structure isPublication
			ifTrue: [ self visit: structure ] ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitReferenceLink: aReferenceLink [
	aReferenceLink isBroken ifFalse: [
		(aReferenceLink target isFigure or: [ aReferenceLink target isPublication ])
			ifTrue: [ ^ latex tag: 'autoref'; curly: (self structureLabelFor: aReferenceLink target) ] ].
	^ super visitReferenceLink: aReferenceLink
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitStrikethroughFormat: anObject [
	latex tag: 'sout'; curly: [ super visitStrikethroughFormat: anObject ]
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitSubscriptFormat: anObject [
	latex tag: 'raisebox'; curly: '-0.25em'; curly: [ super visitSubscriptFormat: anObject ]
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitSuperscriptFormat: anObject [
	latex tag: 'raisebox'; curly: '0.25em'; curly: [ super visitSuperscriptFormat: anObject ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitTable: aTable [
	latex tag: 'begin'; curly: 'tabularx'; curly: [ latex tag: 'textwidth' ].
	latex curly: (String streamContents: [ :spec | 
		aTable children first children do: [ :cell |
			spec nextPut: (cell isAlignedLeft
				ifTrue: [ $l ]
				ifFalse: [
					cell isAlignedCenter
						ifTrue: [ $c ]
						ifFalse: [ 
							cell isAlignedRight
								ifTrue: [ $r ]
								ifFalse: [ $X ] ] ]) ] ]); lf.
	aTable children do: [ :row |
		self visit: row.
		(row children allSatisfy: [ :cell | cell isHeading ])
			ifTrue: [ stream nextPutAll: '\\ \hline'; nextPut: Character lf ]
			ifFalse: [ stream nextPutAll: '\\'; nextPut: Character lf ] ].
	latex tag: 'end'; curly: 'tabularx'
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitTableCell: aTableCell [
	aTableCell isHeading
		ifFalse: [ super visitTableCell: aTableCell ]
		ifTrue: [ latex tag: 'textbf'; curly: [ super visitTableCell: aTableCell ] ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitTableRow: aTableRow [
	self visitAll: aTableRow children separatedBy: [ stream nextPut: $& ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitTermItem: aTermObject [
	latex tag: 'item'; tag: 'hspace'; curly: [ latex stream nextPutAll: '-\labelwidth' ].
	latex tag: 'textbf'; curly: [ self visitAll: aTermObject children ]; lf
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitText: aText [
	latex nextPutAll: aText text
]

{ #category : #'visiting-formatting' }
BOLatexWriter >> visitUnderlineFormat: anObject [
	latex tag: 'uline'; curly: [ super visitUnderlineFormat: anObject ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitUnorderedList: anUnorderedList [
	latex environment: 'itemize' do: [ super visitUnorderedList: anUnorderedList ]
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitValueLink: aValueLink [
	| value |
	value := aValueLink valueIn: PRCurrentContext value.
	value isNil
		ifTrue: [ ^ self visitLink: aValueLink ].
	(value isCollection and: [ value isString not ])
		ifTrue: [ ^ self visitAll: value ].
	(value isKindOf: PRDocumentItem)
		ifTrue: [ ^ self visit: value ].
	latex print: value
]

{ #category : #'visiting-document' }
BOLatexWriter >> visitVerbatim: anObject [
	(anObject type isNil or: [ anObject type = 'latex' ])
		ifTrue: [ stream nextPutAll: anObject text ]
]

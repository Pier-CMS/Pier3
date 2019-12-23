Class {
	#name : #PRViewRenderer,
	#superclass : #PRDeepRenderer,
	#instVars : [
		'withinContent'
	],
	#classVars : [
		'TextEntities'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #initialization }
PRViewRenderer class >> initialize [
	TextEntities := OrderedCollection new.
	TextEntities
		add: '(r)' -> '&reg;';
		add: '(R)' -> '&reg;';
		add: '(c)' -> '&copy;';
		add: '(C)' -> '&copy;';
		add: '--' -> '&mdash;';
		add: '''''' -> '&rdquo;';
		add: '''' -> '&rsquo;';
		add: '``' -> '&ldquo;';
		add: '`' -> '&lsquo;'
]

{ #category : #initialization }
PRViewRenderer >> initialize [
	super initialize.
	withinContent := false
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitAnchor: anObject [
	html anchor name: (anObject name
		select: [ :each | each isAlphaNumeric ])
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitAnnotatedParagraph: anObject [
	html paragraph
		class: 'annotated';
		class: anObject annotation;
		with: [ self visitAll: anObject children ]
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitBoldFormat: anObject [
	html strong: [ super visitBoldFormat: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitDataItem: anObject [
	html definitionData: [ self visitAll: anObject children ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitDefinitionList: anObject [
	html definitionList: [ super visitDefinitionList: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitEmptyParagraph: anObject [
	"This is simple."
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitHeader: anObject [
	html heading level: anObject level; with: [
		html anchor name: anObject hash.
		super visitHeader: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitHorizontalRule: anObject [
	html horizontalRule
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitItalicFormat: anObject [
	html emphasis: [ super visitItalicFormat: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitLineBreak: anObject [
	html text: ' '
]

{ #category : #'visiting-links' }
PRViewRenderer >> visitLink: anObject [
	(self linkRendererFor: anObject)
		start: anObject 
		in: component
		on: html
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitListItem: anObject [
	html listItem: [ super visitListItem: anObject ]
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitMonospaceFormat: anObject [
	html code: anObject text
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitOrderedList: anObject [
	html orderedList: [ super visitOrderedList: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitParagraph: anObject [
	"Rendering paragraphs is tricky, when requiring (mostly) valid XHTML and full accessibility.	
# Paragraphs appearing within the environment are ignored alltogether.
# Other paragraphs are created using the normal XHTML paragraph markup."

	withinContent
		ifFalse: [ ^ super visitParagraph: anObject ].
	html paragraph: [ super visitParagraph: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitPreformatted: anObject [ 
	html preformatted: 
		[ anObject children 
			do: [ :each | html text: each text ]
			separatedBy: 
				[ html text: (String 
						with: Character cr
						with: Character lf) ] ]
]

{ #category : #'as yet unclassified' }
PRViewRenderer >> visitRaw: anObject [
	(anObject type isNil or: [ anObject type = 'html' ])
		ifTrue: [ html html: anObject text ]
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitStrikethroughFormat: anObject [
	html deleted: [ super visitStrikethroughFormat: anObject ]
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitSubscriptFormat: anObject [
	html subscript: [ super visitSubscriptFormat: anObject ]
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitSuperscriptFormat: anObject [
	html superscript: [ super visitSuperscriptFormat: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitTable: anObject [
	html table: [ super visitTable: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitTableCell: anObject [
	(anObject isHeading ifTrue: [ html tableHeading ] ifFalse: [ html tableData ])
		style: (anObject align isNil ifFalse: [ 'text-align: ' , anObject align ]);
		with: [ super visitTableCell: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitTableRow: anObject [
	html tableRow: [ super visitTableRow: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitTermItem: anObject [
	html definitionTerm: [ self visitAll: anObject children ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitText: anObject [
	html text: anObject text
]

{ #category : #'visiting-formats' }
PRViewRenderer >> visitUnderlineFormat: anObject [
	html inserted: [ super visitUnderlineFormat: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitUnorderedList: anObject [
	html unorderedList: [ super visitUnorderedList: anObject ]
]

{ #category : #'visiting-document' }
PRViewRenderer >> visitVerbatim: anObject [
	(anObject type isNil or: [ anObject type = 'html' ])
		ifTrue: [ html html: anObject text ]
]

{ #category : #accessing }
PRViewRenderer >> withinContentDo: aBlock [
	"Change to the contents mode, e.g. paragraphs are no longer rendered as div but as meaningful XHTML paragraphs."
	
	| previous |
	previous := withinContent. withinContent := true.
	^ aBlock ensure: [ withinContent := previous ]
]

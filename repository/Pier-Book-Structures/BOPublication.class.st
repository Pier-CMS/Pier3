Class {
	#name : #BOPublication,
	#superclass : #PRCase,
	#instVars : [
		'numberedTitle',
		'ignoredTitle',
		'ignoredBody'
	],
	#category : #'Pier-Book-Structures'
}

{ #category : #testing }
BOPublication class >> canBeParentOf: aStructureClass [
	^ self childClasses anySatisfy: [ :class | aStructureClass includesBehavior: class ]
]

{ #category : #accessing }
BOPublication class >> childClasses [
	^ Array with: BOPublication with: BONote with: BOFigure
]

{ #category : #accessing }
BOPublication class >> refLabels [
	^ #('Book' 'Part' 'Chapter' 'Section' 'Section' 'Section' 'Section')
]

{ #category : #accessing }
BOPublication class >> typeLabels [
	^ #('Book' 'Part' 'Chapter' 'Section' 'Subsection' 'Subsubsection' 'Paragraph')
]

{ #category : #accessing }
BOPublication class >> typeSymbols [
	^ #(book part chapter section subsection subsubsection paragraph)
]

{ #category : #accessing }
BOPublication class >> typeSymbolsAndLabels [
	^ ((1 to: self typeSymbols size) collect: [ :index |	(self typeSymbols at: index) -> (self typeLabels at: index) ])
]

{ #category : #visiting }
BOPublication >> accept: aVisitor [
	aVisitor visitPublication: self
]

{ #category : #'accessing-commands' }
BOPublication >> defaultChildClass [
	^ BOPortion
]

{ #category : #descriptions }
BOPublication >> descriptionIgnoredBody [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Ignore body';
		accessor: #ignoredBody;
		default: false;
		priority: 162;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOPublication >> descriptionIgnoredTitle [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Ignore title';
		accessor: #ignoredTitle;
		label: 'Export';
		default: false;
		priority: 160;
		beEditable;
		yourself
]

{ #category : #descriptions }
BOPublication >> descriptionNumberedTitle [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Numbered title';
		accessor: #numberedTitle;
		label: 'Display';
		default: true;
		priority: 150;
		beEditable;
		yourself
]

{ #category : #'accessing-settings' }
BOPublication >> ignoredBody [
	^ ignoredBody
]

{ #category : #'accessing-settings' }
BOPublication >> ignoredBody: aBoolean [
	ignoredBody := aBoolean
]

{ #category : #'accessing-settings' }
BOPublication >> ignoredTitle [
	^ ignoredTitle
]

{ #category : #'accessing-settings' }
BOPublication >> ignoredTitle: aBoolean [
	ignoredTitle := aBoolean
]

{ #category : #'testing-type' }
BOPublication >> isBook [
	^ self type = #book
]

{ #category : #'testing-type' }
BOPublication >> isChapter [
	^ self type = #chapter
]

{ #category : #testing }
BOPublication >> isIgnoredBody [
	^ self ignoredBody ifNil: [ false ]
]

{ #category : #testing }
BOPublication >> isIgnoredTitle [
	^ self ignoredTitle ifNil: [ false ]
]

{ #category : #testing }
BOPublication >> isNumberedTitle [
	^ self numberedTitle ifNil: [ true ]
]

{ #category : #'testing-type' }
BOPublication >> isParagraph [
	^ self type = #paragraph
]

{ #category : #'testing-type' }
BOPublication >> isPart [
	^ self type = #part
]

{ #category : #testing }
BOPublication >> isPublication [
	^ true
]

{ #category : #'testing-type' }
BOPublication >> isSection [
	^ self type = #section
]

{ #category : #'testing-type' }
BOPublication >> isSubsection [
	^ self type = #subsection
]

{ #category : #'testing-type' }
BOPublication >> isSubsubsection [
	^ self type = #subsubsection
]

{ #category : #accessing }
BOPublication >> label [
	"Answer a label for the type of the receiver, like Book, Part, Chapter, Section, ..."

	^ self class typeLabels
		at: (self class typeSymbols 
			indexOf: self type)
		ifAbsent: [ String new ]
]

{ #category : #accessing }
BOPublication >> number [
	^ nil
]

{ #category : #'accessing-settings' }
BOPublication >> numberedTitle [
	^ numberedTitle
]

{ #category : #'accessing-settings' }
BOPublication >> numberedTitle: aBoolean [
	numberedTitle := aBoolean
]

{ #category : #accessing }
BOPublication >> refLabel [
	"Answer a reference label for the type of the receiver, like Book, Part, Chapter, Section, ..."

	^ self class refLabels
		at: (self class typeSymbols
			indexOf: self type)
		ifAbsent: [ String new ]
]

{ #category : #accessing }
BOPublication >> type [
	"Answer the type of the receiver, such as #book, #part, #chapter, #section, ..."

	self subclassResponsibility
]

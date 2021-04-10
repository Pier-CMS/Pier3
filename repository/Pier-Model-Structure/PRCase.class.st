"
I am an abstract class holding onto a document definition representing the contents of the receiver. Most of my subclasses will allow user to edit myself using the Wiki syntax.
"
Class {
	#name : #PRCase,
	#superclass : #PRStructure,
	#instVars : [
		'document'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #visiting }
PRCase >> accept: aVisitor [
	aVisitor visitCase: self
]

{ #category : #'accessing-dynamic' }
PRCase >> contents [
	"Answer a wiki string representation of the receiving document."
	
	^ self descriptionDocument toString: (self readUsing: self descriptionDocument)
]

{ #category : #'accessing-dynamic' }
PRCase >> contents: aString [
	self 
		write: (self descriptionDocument 
			fromString: (aString ifNil: [ String new ]))
		using: self descriptionDocument
]

{ #category : #'accessing-defaults' }
PRCase >> defaultDocument [
	"Answer the default document of the receiver."

	^ PRDocument new

]

{ #category : #'accessing-description' }
PRCase >> descriptionDocument [
	<magritteDescription>
	^ PRDocumentDescription new
		accessor: #document;
		label: 'Contents';
		stringAccessor: #contents;
		beSearchable;
		priority: 500;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRCase >> descriptionPlainText [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #plainText;
		label: 'Plain Text';
		priority: 510;
		beReadOnly;
		yourself
]

{ #category : #accessing }
PRCase >> document [
	"Answer the document of the receiver."

	^ document
]

{ #category : #accessing }
PRCase >> document: aDocument [
	document := aDocument.
	document isNil
		ifFalse: [ document owner: self ]
]

{ #category : #testing }
PRCase >> hasDocument [
	^ self document notNil
]

{ #category : #initialization }
PRCase >> initialize [
	super initialize.
	self document: self defaultDocument
]

{ #category : #'accessing-dynamic' }
PRCase >> plainText [
	"Answer a plain text representation of the receiver's document."
	
	^ PRTextWriter write: self document
]

{ #category : #copying }
PRCase >> postCopy [
	super postCopy.
	self document: self document copy
]

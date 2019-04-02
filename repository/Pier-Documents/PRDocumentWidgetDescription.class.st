"
I am similar to PRDocumentDescription but I don't redefine #accessor: as I don't want PRDocumentAccessor in the accessor chain as PRDocumentAccessor>>write:to: sets the document #owner: which sets the owner to a PRDocumentWidget rather than the containing PRComponent.
"
Class {
	#name : #PRDocumentWidgetDescription,
	#superclass : #MAMemoDescription,
	#category : #'Pier-Documents'
}

{ #category : #defaults }
PRDocumentWidgetDescription class >> defaultComponentClasses [
	^ Array with: PRDocumentComponent
]

{ #category : #defaults }
PRDocumentWidgetDescription class >> defaultCssClasses [
	^ super defaultCssClasses add: 'wiki'; yourself
]

{ #category : #defaults }
PRDocumentWidgetDescription class >> defaultKind [
	^ PRDocument
]

{ #category : #accessing }
PRDocumentWidgetDescription class >> label [
	^ 'Document'
]

{ #category : #visiting }
PRDocumentWidgetDescription >> acceptMagritte: aVisitor [
	aVisitor visitDocumentDescription: self
]

{ #category : #testing }
PRDocumentWidgetDescription >> isDocumentDescription [
	^ true
]

{ #category : #accessing }
PRDocumentWidgetDescription >> parserClass [
	"Answer the default document parser for the receiver."

	^ PRPillarParser
]

{ #category : #accessing }
PRDocumentWidgetDescription >> writerClass [
	"Answer the default document writer for the receiver."

	^ PRPillarWriter
]

Class {
	#name : #PRDocumentDescription,
	#superclass : #MAMemoDescription,
	#category : #'Pier-Model-Magritte'
}

{ #category : #'accessing-defaults' }
PRDocumentDescription class >> defaultKind [
	^ PRDocument
]

{ #category : #accessing }
PRDocumentDescription class >> label [
	^ 'Document'
]

{ #category : #visiting }
PRDocumentDescription >> acceptMagritte: aVisitor [
	aVisitor visitDocumentDescription: self
]

{ #category : #accessing }
PRDocumentDescription >> accessor: anAccessor [
	super accessor: (PRDocumentAccessor on: anAccessor asAccessor)
]

{ #category : #testing }
PRDocumentDescription >> isDocumentDescription [
	^ true
]

{ #category : #accessing }
PRDocumentDescription >> parserClass [
	"Answer the default document parser for the receiver."

	^ PRPillarParser 
]

{ #category : #accessing }
PRDocumentDescription >> writerClass [
	"Answer the default document writer for the receiver."

	^ PRPillarWriter 
]

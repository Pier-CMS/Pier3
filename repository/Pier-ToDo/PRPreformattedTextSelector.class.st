"
A PRPreformattedTextSelector is used for pulling the preformatted text out of a given page.

Instance Variables
	textStream:	<WriteStream> The contents of preformatted text.

"
Class {
	#name : #PRPreformattedTextSelector,
	#superclass : #PREnumerableVisitor,
	#instVars : [
		'textStream'
	],
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRPreformattedTextSelector class >> isAbstract [
	^false
]

{ #category : #initialization }
PRPreformattedTextSelector >> initialize [
	super initialize.
	textStream := WriteStream on: String new
]

{ #category : #accessing }
PRPreformattedTextSelector >> text [
	^ textStream contents
]

{ #category : #'visiting-document' }
PRPreformattedTextSelector >> visitPreformatted: aPreformatted [
	textStream nextPutAll: aPreformatted text asString
]

"
PRAdminHtmlDocumentSeparateBodyHeadElements only directly renders the body during a response. The head elements are stored but not rendered. Scripts within the body are also stored separately. The head elements and body scripts can then be treated separately to ensure that, for example, scripts and styles are only ever loaded once into an ajax updated page.
"
Class {
	#name : #PRAdminHtmlDocumentSeparateBodyHeadElements,
	#superclass : #WAHtmlDocument,
	#instVars : [
		'bodyHtml',
		'currentStream',
		'bodyScripts',
		'htmlRoot'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #accessing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> bodyHtml [
	^ bodyHtml
]

{ #category : #accessing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> bodyHtml: anObject [
	bodyHtml := anObject
]

{ #category : #accessing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> bodyScripts [
	^ bodyScripts ifNil: [ bodyScripts := OrderedCollection new ].
]

{ #category : #actions }
PRAdminHtmlDocumentSeparateBodyHeadElements >> close [
	self bodyHtml: self stream contents
	
]

{ #category : #writing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> closeTag: aString [
	aString = 'script'
		ifTrue: [
			self bodyScripts add: currentStream contents.
			currentStream := stream ]
		ifFalse: [
			super closeTag: aString	]
]

{ #category : #accessing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> htmlRoot [
	^ htmlRoot
]

{ #category : #initialization }
PRAdminHtmlDocumentSeparateBodyHeadElements >> initializeWithStream: aStream codec: aCodec [
	currentStream := aStream.
	super initializeWithStream: aStream codec: aCodec
]

{ #category : #writing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> nextPut: aCharacter [
	currentStream nextPut: aCharacter
]

{ #category : #writing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> nextPutAll: aString [
	currentStream nextPutAll: aString
]

{ #category : #actions }
PRAdminHtmlDocumentSeparateBodyHeadElements >> open: aRoot [
	htmlRoot := aRoot
	
	"
	deliberately don't call:
	
	super open: aRoot 
	
	so that the rendered document stream only contains
	the contents of the rendered body.
	"
		
]

{ #category : #writing }
PRAdminHtmlDocumentSeparateBodyHeadElements >> openTag: aString attributes: anAttributes closed: aBoolean [
	"switch the stream if we're opening a script tag, so that we can store script tag contents separately"
	aString = 'script'
		ifTrue: [
			currentStream := WriteStream on: (String new: 100) ]
		ifFalse: [
			super openTag: aString attributes: anAttributes closed: aBoolean ]
]

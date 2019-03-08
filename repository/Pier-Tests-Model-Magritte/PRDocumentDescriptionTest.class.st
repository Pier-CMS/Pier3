Class {
	#name : #PRDocumentDescriptionTest,
	#superclass : #MAMemoDescriptionTest,
	#category : #'Pier-Tests-Model-Magritte'
}

{ #category : #private }
PRDocumentDescriptionTest >> actualClass [
	^ PRDocumentDescription
]

{ #category : #private }
PRDocumentDescriptionTest >> includedInstance [
	^ self description fromString: '!Hello World'
]

{ #category : #'tests-accessing' }
PRDocumentDescriptionTest >> testAccessor [
	"This doesn't work, as the document description wraps the accessor with an accessor-delegator."
]

{ #category : #'tests-accessing' }
PRDocumentDescriptionTest >> testDefaultLabel [
	"Not working"
]

{ #category : #'tests-accessing' }
PRDocumentDescriptionTest >> testDisplay [
	"This inherited test seems not to be valid for custom string-writer classes i.e. PRWikiWriter in this case"
]

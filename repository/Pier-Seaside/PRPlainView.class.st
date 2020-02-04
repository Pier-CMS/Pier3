Class {
	#name : #PRPlainView,
	#superclass : #PRRawView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRPlainView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRPlainView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure hasDocument ]
]

{ #category : #converting }
PRPlainView class >> label [
	^ 'Text'
]

{ #category : #responding }
PRPlainView >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse contentType: 'text/plain'.
	PRTextWriter
		write: self context structure document
		to: aResponse stream
]

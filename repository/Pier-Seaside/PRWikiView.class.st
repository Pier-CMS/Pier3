Class {
	#name : #PRWikiView,
	#superclass : #PRRawView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRWikiView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRWikiView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure hasDocument ]
]

{ #category : #converting }
PRWikiView class >> label [
	^ 'Wiki'
]

{ #category : #responding }
PRWikiView >> respondUsing: aResponse [
	| structure |
	super respondUsing: aResponse.
	structure := self context structure.
	aResponse contentType: 'text/plain'.
	aResponse stream nextPutAll:
		(structure descriptionDocument 
			toString: structure document)
]

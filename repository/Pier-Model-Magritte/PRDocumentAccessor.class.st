Class {
	#name : #PRDocumentAccessor,
	#superclass : #MADelegatorAccessor,
	#category : #'Pier-Model-Magritte'
}

{ #category : #model }
PRDocumentAccessor >> write: anObject to: aModel [
	super write: anObject to: aModel.
	anObject isNil
		ifFalse: [ anObject owner: aModel ]
]

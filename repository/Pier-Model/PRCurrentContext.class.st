"
I am a dynamic variable. I answer the current context when being raised.
"
Class {
	#name : #PRCurrentContext,
	#superclass : #Object,
	#category : #'Pier-Model-Kernel'
}

{ #category : #accessing }
PRCurrentContext class >> value [
	"This is the read accessor of the current context."

	| holder |
	holder := PRCurrentContextHolder value.
	^ holder isNil ifFalse: [ holder context ]
]

{ #category : #accessing }
PRCurrentContext class >> value: aContext [
	"This is the write accessor of the current context."

	PRCurrentContextHolder value context: aContext
]

Class {
	#name : #PRHaloShine,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'Pier-EditorEnh'
}

{ #category : #accessing }
PRHaloShine >> id [
	^ id
]

{ #category : #accessing }
PRHaloShine >> id: anObject [
	id := anObject
]

{ #category : #printing }
PRHaloShine >> printOn: aStream [
	aStream nextPutAll: 'new PierHalo('; print: self id; nextPut: $)
]

{ #category : #'accessing-dynamic' }
PRHaloShine >> session [
	^ WACurrentRequestContext value session
]

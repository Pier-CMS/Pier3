Class {
	#name : #PRStructureError,
	#superclass : #MAValidationError,
	#instVars : [
		'structure'
	],
	#category : #'Pier-Model-Exception'
}

{ #category : #'instance creation' }
PRStructureError class >> structure: aStructure [
	^ self new
		setStructure: aStructure;
		yourself
]

{ #category : #initialization }
PRStructureError >> setStructure: aStructure [
	structure := aStructure
]

{ #category : #accessing }
PRStructureError >> structure [
	^ structure
]

Class {
	#name : #PRStructureDescription,
	#superclass : #MAElementDescription,
	#category : #'Pier-Model-Magritte'
}

{ #category : #'accessing-defaults' }
PRStructureDescription class >> defaultKind [
	^ PRStructure
]

{ #category : #testing }
PRStructureDescription class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRStructureDescription class >> label [
	^ 'Structure'
]

{ #category : #visiting }
PRStructureDescription >> acceptMagritte: aVisitor [
	aVisitor visitStructureDescription: self
]

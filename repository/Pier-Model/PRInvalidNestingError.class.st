Class {
	#name : #PRInvalidNestingError,
	#superclass : #PRStructureError,
	#category : #'Pier-Model-Exception'
}

{ #category : #'instance creation' }
PRInvalidNestingError class >> of: aChildStructure in: aParentStructure [
	^ (self structure: aParentStructure)
		signal: aChildStructure title printString , ' can not be a child of ' , aParentStructure title printString
]

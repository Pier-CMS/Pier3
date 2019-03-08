Class {
	#name : #PRIncompletePathLookup,
	#superclass : #PRPathLookup,
	#category : #'Pier-Model-Visitor'
}

{ #category : #private }
PRIncompletePathLookup >> childNotFound: aStructure [
	self escape: aStructure
]

{ #category : #actions }
PRIncompletePathLookup >> lookup: aStructure [
	^ Association 
		key: (super lookup: aStructure)
		value: self pathElement
]

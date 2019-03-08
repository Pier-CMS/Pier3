Class {
	#name : #PRLineDiffAlgorithm,
	#superclass : #PRDiffAlgorithm,
	#category : #'Pier-Model-Utilities'
}

{ #category : #accessing }
PRLineDiffAlgorithm >> source: aString [
	super source: (aString ifNil: [ String new ]) lines
]

{ #category : #accessing }
PRLineDiffAlgorithm >> target: aString [
	super target: (aString ifNil: [ String new ]) lines
]

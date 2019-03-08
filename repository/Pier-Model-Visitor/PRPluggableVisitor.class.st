Class {
	#name : #PRPluggableVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'block'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #initialization }
PRPluggableVisitor >> setBlock: aBlock [
	block := aBlock
]

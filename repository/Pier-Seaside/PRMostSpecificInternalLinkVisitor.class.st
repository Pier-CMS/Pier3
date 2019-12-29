Class {
	#name : #PRMostSpecificInternalLinkVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'target'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #testing }
PRMostSpecificInternalLinkVisitor class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRMostSpecificInternalLinkVisitor >> target [
	^ target
]

{ #category : #visiting }
PRMostSpecificInternalLinkVisitor >> visitInternalLink: anObject [
	| context structure targetStructure |
	context := PRCurrentContext value.
	structure := context structure.
	targetStructure := anObject target.
	((structure parents includes: targetStructure) 
		and: [ target isNil or: [ targetStructure parents includes: target ] ])
			ifTrue: [ target := targetStructure ]
]

Class {
	#name : #PRStructureDescriptionTest,
	#superclass : #MAElementDescriptionTest,
	#instVars : [
		'page'
	],
	#category : #'Pier-Tests-Model-Magritte'
}

{ #category : #testing }
PRStructureDescriptionTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRStructureDescriptionTest >> actualClass [
	^ PRStructureDescription
]

{ #category : #private }
PRStructureDescriptionTest >> context [
	^ PRContext kernel: PRKernel new structure: self includedInstance
]

{ #category : #private }
PRStructureDescriptionTest >> includedInstance [
	^ page ifNil: [ page := PRPage new ]
]

{ #category : #running }
PRStructureDescriptionTest >> runCase [
	PRCurrentContextHolder use: self during: [ super runCase ]
]

Class {
	#name : #PRFileTest,
	#superclass : #PRStructureTest,
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRFileTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRFileTest >> actualClass [
	^ PRFile
]

{ #category : #tests }
PRFileTest >> testFile [
	| model |
	model := MAMemoryFileModel new.
	self structure file: model.
	self assert: self structure file = model
]

{ #category : #'tests-testing' }
PRFileTest >> testIsFile [
	self assert: self instance isFile
]

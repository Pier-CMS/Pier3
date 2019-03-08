Class {
	#name : #PRDecorationTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'decorated',
		'decoration'
	],
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRDecorationTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRDecorationTest >> actualClass [
	^ PRDecoration
]

{ #category : #private }
PRDecorationTest >> actualInstance [
	^ self actualClass new
]

{ #category : #accessing }
PRDecorationTest >> decorated [
	^ decorated
]

{ #category : #private }
PRDecorationTest >> decoratedInstance [
	^ PRPage new
]

{ #category : #accessing }
PRDecorationTest >> decoration [
	^ decoration
]

{ #category : #accessing }
PRDecorationTest >> instance [
	^ decoration
]

{ #category : #running }
PRDecorationTest >> setUp [
	decorated := self decoratedInstance.
	decoration := self actualInstance.
	decorated addDecoration: decoration
]

{ #category : #'tests-copying' }
PRDecorationTest >> testCopyDecorated [
	| ownerCopy decorationCopy |
	ownerCopy := self decorated copy.
	decorationCopy := ownerCopy decorations first.

	self deny: self decorated == ownerCopy.
	self deny: self decorated == decorationCopy.

	self assert: self decorated decorations size = 1.
	self assert: self decorated decorations first = self decoration.
	self assert: self decorated = self decoration decorated.

	self assert: ownerCopy decorations size = 1.
	self assert: ownerCopy decorations first = decorationCopy.
	self assert: ownerCopy = decorationCopy decorated
]

{ #category : #'tests-copying' }
PRDecorationTest >> testCopyDecoration [
	| decorationCopy |
	decorationCopy := self decoration copy.

	self deny: self decoration == decorationCopy.
	self assert: self decoration = decorationCopy.
	self assert: self decoration decorated = self decorated.
	self assert: decorationCopy decorated isNil
]

{ #category : #'tests-accessing' }
PRDecorationTest >> testDecorated [
	self assert: self decoration decorated = self decorated
]

{ #category : #'tests-accessing' }
PRDecorationTest >> testPriority [
	self assert: self decoration priority isNumber
]

{ #category : #'tests-utilities' }
PRDecorationTest >> testRemove [
	self decoration remove.
	self assert: self decoration decorated isNil.
	self decorated
		decorationOfClass: self actualClass
		ifAbsent: [ ^ self ].
	self assert: false
]

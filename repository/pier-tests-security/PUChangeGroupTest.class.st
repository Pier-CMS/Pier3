Class {
	#name : #PUChangeGroupTest,
	#superclass : #PUChangeSecurityTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PUChangeGroupTest class >> isAbstract [
	^ false
]

{ #category : #private }
PUChangeGroupTest >> actualClass [
	^ PUChangeGroup
]

{ #category : #tests }
PUChangeGroupTest >> testGroup [
	self command
		with: true; all: true;
		group: self bloggerGroup.
	self command execute.

	self assert: self structure group = self bloggerGroup.
	self assert: self child group = self bloggerGroup
]

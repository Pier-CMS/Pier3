Class {
	#name : #PUChangeOwnerTest,
	#superclass : #PUChangeSecurityTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PUChangeOwnerTest class >> isAbstract [
	^ false
]

{ #category : #private }
PUChangeOwnerTest >> actualClass [
	^ PUChangeOwner
]

{ #category : #tests }
PUChangeOwnerTest >> testOwner [
	self command
		with: true; all: true;
		owner: self bloggerUser.
	self command execute.

	self assert: self structure owner = self bloggerUser.
	self assert: self child owner = self bloggerUser
]

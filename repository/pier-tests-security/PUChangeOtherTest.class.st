Class {
	#name : #PUChangeOtherTest,
	#superclass : #PUChangeSecurityTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PUChangeOtherTest class >> isAbstract [
	^ false
]

{ #category : #private }
PUChangeOtherTest >> actualClass [
	^ PUChangeOther
]

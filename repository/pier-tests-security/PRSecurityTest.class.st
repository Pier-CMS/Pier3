Class {
	#name : #PRSecurityTest,
	#superclass : #PRDecorationTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PRSecurityTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRSecurityTest >> actualClass [
	^ PUSecurity
]

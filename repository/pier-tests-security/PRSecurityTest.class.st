Class {
	#name : 'PRSecurityTest',
	#superclass : 'PRDecorationTest',
	#category : 'pier-tests-security',
	#package : 'pier-tests-security'
}

{ #category : 'testing' }
PRSecurityTest class >> isAbstract [
	^ false
]

{ #category : 'private' }
PRSecurityTest >> actualClass [
	^ PUSecurity
]

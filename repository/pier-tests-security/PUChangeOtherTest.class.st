Class {
	#name : 'PUChangeOtherTest',
	#superclass : 'PUChangeSecurityTest',
	#category : 'pier-tests-security',
	#package : 'pier-tests-security'
}

{ #category : 'testing' }
PUChangeOtherTest class >> isAbstract [
	^ false
]

{ #category : 'private' }
PUChangeOtherTest >> actualClass [
	^ PUChangeOther
]

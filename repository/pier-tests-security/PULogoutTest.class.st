Class {
	#name : #PULogoutTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PULogoutTest class >> isAbstract [
	^ false
]

{ #category : #private }
PULogoutTest >> actualClass [
	^ PULogout
]

{ #category : #private }
PULogoutTest >> contextInstance [
	^ super contextInstance user: self bloggerUser
]

{ #category : #'tests-testing' }
PULogoutTest >> testIsLogged [
	self deny: self command isLogged
]

{ #category : #'tests-testing' }
PULogoutTest >> testIsQuick [
	self assert: self command isQuick
]

{ #category : #tests }
PULogoutTest >> testingLogout [
	self assert: self context user = self bloggerUser.
	self command execute.
	self assert: self command successAnswer user isNil.
	self assert: self command successAnswer command class = PRViewCommand.
	self assert: self context user = self bloggerUser
]

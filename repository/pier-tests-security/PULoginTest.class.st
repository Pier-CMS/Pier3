Class {
	#name : #PULoginTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PULoginTest class >> isAbstract [
	^ false
]

{ #category : #private }
PULoginTest >> actualClass [
	^ PULogin
]

{ #category : #'tests-testing' }
PULoginTest >> testIsLogged [
	self deny: self command isLogged
]

{ #category : #tests }
PULoginTest >> testLoginAdmin [
	self assert: self context user isNil.
	self command
		username: self adminUser name;
		password: 'pier'.
	self
		shouldnt: [ self command execute ]
		raise: PUInvalidLogin.
	self assert: self command user = self adminUser.
	self assert: self command successAnswer user = self adminUser.
	self assert: self command successAnswer command class = PRViewCommand.
	self assert: self command cancelAnswer user isNil.
	self assert: self command cancelAnswer command class = PRViewCommand.
	self assert: self context user isNil
]

{ #category : #tests }
PULoginTest >> testLoginBlogger [
	self assert: self context user isNil.
	self command
		username: self bloggerUser name;
		password: 'bottom'.
	self
		shouldnt: [ self command execute ]
		raise: PUInvalidLogin.
	self assert: self command user = self bloggerUser.
	self assert: self command successAnswer user = self bloggerUser.
	self assert: self command successAnswer command class = PRViewCommand.
	self assert: self command cancelAnswer user isNil.
	self assert: self command cancelAnswer command class = PRViewCommand.
	self assert: self context user isNil
]

{ #category : #tests }
PULoginTest >> testLoginInvalidPassword [
	self assert: self context user isNil.
	self command username: self bloggerUser name.
	self should: [ self command execute ] raise: PUInvalidLogin.
	self assert: self context user isNil
]

{ #category : #tests }
PULoginTest >> testLoginInvalidUsername [
	self assert: self context user isNil.
	self should: [ self command execute ] raise: PUInvalidLogin.
	self assert: self context user isNil
]

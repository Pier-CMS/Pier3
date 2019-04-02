Class {
	#name : #PUEditUserTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Security'
}

{ #category : #testing }
PUEditUserTest class >> isAbstract [
	^ false
]

{ #category : #private }
PUEditUserTest >> actualClass [
	^ PUEditUser
]

{ #category : #tests }
PUEditUserTest >> testInformation [
	self context setUser: self adminUser.
	self command write: 'Lukas' using: PUUser new descriptionFirstName.
	self command write: 'Renggli' using: PUUser new descriptionLastName.
	self command write: 'admin@piercms.com' using: PUUser new descriptionEmail.
	self command execute.
	self assert: self adminUser firstName = 'Lukas'.
	self assert: self adminUser lastName = 'Renggli'.
	self assert: self adminUser email = 'admin@piercms.com'.
]

{ #category : #tests }
PUEditUserTest >> testPassword [
	self context setUser: self adminUser.
	self command write: 'foo' using: PUUser new descriptionPassword.
	self command execute.
	self assert: (self adminUser validatePassword: 'foo')
]

{ #category : #tests }
PUEditUserTest >> testValid [
	self deny: self context isValid.
	context := self context user: self adminUser.
	self assert: self context isValid.
	context := self context user: self bloggerUser.
	self assert: self context isValid
]

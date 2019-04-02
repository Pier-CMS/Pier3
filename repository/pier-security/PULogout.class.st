Class {
	#name : #PULogout,
	#superclass : #PUChangeUser,
	#category : #'Pier-Security-Command'
}

{ #category : #testing }
PULogout class >> isAbstract [
	^ false
]

{ #category : #testing }
PULogout class >> isValidIn: aContext [
	^ aContext isLoggedIn
]

{ #category : #accessing }
PULogout class >> label [
	^ 'Logout'
]

{ #category : #events }
PULogout >> doAnswer [
	super doAnswer.
	self successAnswer: (self successAnswer user: nil)
]

{ #category : #events }
PULogout >> doExecute [
	super doExecute.
	self context user isNil 
		ifFalse: [ self context user newToken ]
]

{ #category : #testing }
PULogout >> isQuick [
	^ true
]

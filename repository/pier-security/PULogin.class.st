Class {
	#name : #PULogin,
	#superclass : #PUChangeUser,
	#instVars : [
		'username',
		'password',
		'user'
	],
	#category : #'Pier-Security-Command'
}

{ #category : #testing }
PULogin class >> isAbstract [
	^ false
]

{ #category : #testing }
PULogin class >> isValidIn: aContext [
	^ aContext isLoggedIn not
]

{ #category : #accessing }
PULogin class >> label [
	^ 'Login'
]

{ #category : #'accessing-description' }
PULogin >> descriptionPassword [
	<magritteDescription>
	^ MAPasswordDescription new
		parameterName: 'password';
		accessor: #password;
		label: 'Password';
		priority: 200;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PULogin >> descriptionUsername [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'username';
		accessor: #username;
		label: 'Username';
		priority: 100;
		beRequired;
		yourself
]

{ #category : #events }
PULogin >> doAnswer [
	super doAnswer.
	self successAnswer: (self successAnswer user: self user)
]

{ #category : #events }
PULogin >> doValidate [
	super doValidate.
	self user: (self kernel users
		detect: [ :each |
			each name = self username
				and: [ each validatePassword: self password ] ]
		ifNone: [ self invalidLogin ])
]

{ #category : #private }
PULogin >> invalidLogin [
	PUInvalidLogin
		description: self magritteDescription
		signal: 'Invalid username or password.'
]

{ #category : #configuration }
PULogin >> mementoClass [
	^ MACachedMemento
]

{ #category : #accessing }
PULogin >> password [
	^ password ifNil: [ password := String new ]
]

{ #category : #accessing }
PULogin >> password: aString [
	password := aString
]

{ #category : #configuration }
PULogin >> saveButton [
	^ super saveButton value: self class label
]

{ #category : #accessing }
PULogin >> user [
	^ user
]

{ #category : #accessing }
PULogin >> user: aUser [
	user := aUser
]

{ #category : #accessing }
PULogin >> username [
	^ username ifNil: [ username := String new ]
]

{ #category : #accessing }
PULogin >> username: aString [
	username := aString
]

Extension { #name : #PRContext }

{ #category : #'*pier-security' }
PRContext >> descriptionUser [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: (MASelectorAccessor read: #user write: #setUser:);
		reference: PUUser new magritteDescription;
		parameterName: 'user';
		priority: 500;
		label: 'User';
		yourself
]

{ #category : #'*pier-security-accessing' }
PRContext >> group [
	^ self user group
]

{ #category : #'*pier-security-testing' }
PRContext >> isLoggedIn [
	^ self user notNil
]

{ #category : #'*pier-security-private' }
PRContext >> rememberUserInCookie: aUser [
	| cookie requestContext |
	requestContext := self requestContextIfNilDo: [ ^ nil ].
	
	cookie := requestContext newCookie
		key: 'pr_token'.
		
	aUser isNil
		ifTrue: [ cookie value: ''; expireIn: -356 days ]
		ifFalse: [ cookie value: aUser token; expireIn: 7 days ].		
	
	requestContext response addCookie: cookie
]

{ #category : #'*pier-security-private' }
PRContext >> retrieveUserFromCookie [
	| cookie |
	cookie := ((self requestContextIfNilDo: [ ^ nil ]) request
		cookieAt: 'pr_token')
			ifNil: [ ^ nil ].
	^ self kernel users
		detect: [ :each | each token = cookie value ]
		ifNone: [ nil ]
]

{ #category : #'*pier-security-initialization' }
PRContext >> setUser: aUser [
	self propertyAt: #user put: aUser.
	self rememberUserInCookie: aUser
]

{ #category : #'*pier-security-accessing' }
PRContext >> user [
	^ self propertyAt: #user ifAbsentPut: [ self retrieveUserFromCookie ]
]

{ #category : #'*pier-security-navigation' }
PRContext >> user: anUser [
	"Create a copy of the current context with the current user replaced by anUser."

	^ self copy
		setUser: anUser;
		yourself
]

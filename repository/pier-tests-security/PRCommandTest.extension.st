Extension { #name : #PRCommandTest }

{ #category : #'*pier-tests-security-accessing' }
PRCommandTest >> adminGroup [
	^ self kernel adminGroup
]

{ #category : #'*pier-tests-security-accessing' }
PRCommandTest >> adminUser [
	^ self kernel adminUser
]

{ #category : #'*pier-tests-security-accessing' }
PRCommandTest >> bloggerGroup [
	^ self kernel 
		groupNamed: 'blogger'
		ifNone: [ self kernel groups add: self bloggerGroupInstance ]
]

{ #category : #'*pier-tests-security-private' }
PRCommandTest >> bloggerGroupInstance [
	^ PUGroup named: 'blogger'
]

{ #category : #'*pier-tests-security-accessing' }
PRCommandTest >> bloggerUser [
	^ self kernel 
		userNamed: 'james'
		ifNone: [ self kernel users add: self bloggerUserInstance ]
]

{ #category : #'*pier-tests-security-private' }
PRCommandTest >> bloggerUserInstance [
	^ (PUUser named: 'james')
		addGroup: self bloggerGroup;
		password: 'bottom';
		yourself
]

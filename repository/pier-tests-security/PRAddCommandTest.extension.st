Extension { #name : #PRAddCommandTest }

{ #category : #'*pier-tests-security' }
PRAddCommandTest >> testGroup [
	| parentDecoration childDecoration |
	parentDecoration := self context structure
		securityDecoration.
	parentDecoration
		owner: self bloggerUser;
		ownerPermissions: PUChangeSecurity permissionInstances;
		group: self adminGroup;
		groupPermissions: PRAddCommand permissions;
		otherPermissions: #().
	self context
		setUser: self bloggerUser.
	PRCurrentContextHolder
		use: self
		during: [ self command execute ].

	childDecoration := self command successAnswer structure
		securityDecoration.
	self assert: childDecoration owner = self bloggerUser.
	self assert: childDecoration ownerPermissions equalElements: PUChangeSecurity permissionInstances.
	self assert: childDecoration group = self adminGroup.
	self assert: childDecoration groupPermissions equalElements: PRAddCommand permissions.
	self assert: childDecoration otherPermissions equalElements: #()
]

{ #category : #'*pier-tests-security' }
PRAddCommandTest >> testOwner [
	| parentDecoration childDecoration |
	parentDecoration := self context structure
		securityDecoration.
	parentDecoration
		owner: self adminUser;
		ownerPermissions: PRAddCommand permissions;
		group: self bloggerGroup;
		groupPermissions: PUChangeSecurity permissionInstances;
		otherPermissions: #().
	self context
		setUser: self bloggerUser.
	PRCurrentContextHolder
		use: self
		during: [ self command execute ].

	childDecoration := self command successAnswer structure
		securityDecoration.
	self assert: childDecoration owner = self bloggerUser.
	self assert: childDecoration ownerPermissions equalElements: PRAddCommand permissions.
	self assert: childDecoration group = self bloggerGroup.
	self assert: childDecoration groupPermissions equalElements: PUChangeSecurity permissionInstances.
	self assert: childDecoration otherPermissions equalElements: #()
]

{ #category : #'*pier-tests-security' }
PRAddCommandTest >> testWorld [
	| parentDecoration childDecoration |
	parentDecoration := self context structure
		securityDecoration.
	parentDecoration
		owner: self adminUser;
		ownerPermissions: PUChangeSecurity permissionInstances;
		group: self adminGroup;
		groupPermissions: PUChangeSecurity permissionInstances;
		otherPermissions: PRAddCommand permissions.
	self context
		setUser: nil.
	PRCurrentContextHolder
		use: self
		during: [ self command execute ].

	childDecoration := self command successAnswer structure
		securityDecoration.
	self assert: childDecoration owner = self adminUser.
	self assert: childDecoration ownerPermissions equalElements: PUChangeSecurity permissionInstances.
	self assert: childDecoration group = self adminGroup.
	self assert: childDecoration groupPermissions equalElements: PUChangeSecurity permissionInstances.
	self assert: childDecoration otherPermissions equalElements: PRAddCommand permissions
]

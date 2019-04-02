Class {
	#name : #PUMemberTest,
	#superclass : #TestCase,
	#instVars : [
		'group1',
		'group2',
		'user1',
		'user2',
		'user3'
	],
	#category : #'Pier-Tests-Security'
}

{ #category : #running }
PUMemberTest >> setUp [
	group1 := PUGroup named: 'group 1'.
	group2 := PUGroup named: 'group 2'.

	user1 := PUUser named: 'user 1'.
	user2 := PUUser named: 'user 2'.
	user3 := PUUser named: 'user 3'
]

{ #category : #tests }
PUMemberTest >> testEqualitiy [
	self assert: group1 = group1.
	self assert: group2 = group2.

	self assert: user1 = user1.
	self assert: user2 = user2.
	self assert: user3 = user3.

	self deny: group1 = group2.
	self deny: group2 = group1.

	self deny: user1 = user2.
	self deny: user2 = user3.
	self deny: user3 = user1.

	self deny: group1 = user1.
	self deny: group2 = user1.
	self deny: user1 = group1.
	self deny: user2 = group1.
	self deny: user3 = group1
]

{ #category : #'tests-groups' }
PUMemberTest >> testGroupUsers [
	group1 users: (Array with: user1 with: user2).
	self assert: group1 users equalElements: (Set with: user1 with: user2).
	self assert: user1 groups = (OrderedCollection with: group1).
	self assert: user2 groups = (OrderedCollection with: group1).
	self assert: user3 groups = (OrderedCollection new).

	group1 users: (Array with: user2 with: user3).
	self assert: group1 users equalElements: (Set with: user2 with: user3).
	self assert: user1 groups = (OrderedCollection new).
	self assert: user2 groups = (OrderedCollection with: group1).
	self assert: user3 groups = (OrderedCollection with: group1)
]

{ #category : #tests }
PUMemberTest >> testName [
	self assert: group1 name = 'group 1'.
	self assert: group2 name = 'group 2'.

	self assert: user1 name = 'user 1'.
	self assert: user2 name = 'user 2'.
	self assert: user3 name = 'user 3'
]

{ #category : #'tests-user' }
PUMemberTest >> testUserAddGroups [
	user1 addGroup: group1; addGroup: group2.
	self assert: user1 group = group1.
	self assert: user1 groups = (OrderedCollection with: group1 with: group2).
	self assert: group1 users equalElements: (Set with: user1).
	self assert: group2 users equalElements: (Set with: user1)
]

{ #category : #'tests-user' }
PUMemberTest >> testUserGroups [
	user1 groups: (Array with: group1 with: group2).
	self assert: user1 groups = (OrderedCollection with: group1 with: group2).
	self assert: group1 users equalElements: (Set with: user1).
	self assert: group2 users equalElements: (Set with: user1).

	user1 groups: (Array with: group1).
	self assert: user1 groups = (OrderedCollection with: group1).
	self assert: group1 users equalElements: (Set with: user1).
	self assert: group2 users equalElements: (Set new)
]

{ #category : #'tests-user' }
PUMemberTest >> testUserPassword [
	user1 password: 'foo'.
	self deny: user1 password = 'foo'.
	self assert: (user1 validatePassword: 'foo').
	
	user1 password: user1 password.
	self assert: (user1 validatePassword: 'foo')
]

{ #category : #'tests-user' }
PUMemberTest >> testUserRemoveGroups [
	user1 addGroup: group1; addGroup: group2; removeGroup: group2.
	self assert: user1 groups = (OrderedCollection with: group1).
	self assert: group1 users equalElements: (Set with: user1).
	self assert: group2 users equalElements: (Set new)
]

{ #category : #'tests-user' }
PUMemberTest >> testUserSuperuser [
	self deny: user1 superuser.
	self deny: user1 isSuperuser.

	user1 superuser: true.
	self assert: user1 superuser.
	self assert: user1 isSuperuser
]

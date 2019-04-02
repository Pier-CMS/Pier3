Class {
	#name : #PUChangeSecurityTest,
	#superclass : #PRCommandTest,
	#instVars : [
		'child'
	],
	#category : #'Pier-Tests-Security'
}

{ #category : #private }
PUChangeSecurityTest >> actualClass [
	^ PUChangeSecurity
]

{ #category : #accessing }
PUChangeSecurityTest >> child [
	^ child ifNil: [ child := self childInstance ]
]

{ #category : #private }
PUChangeSecurityTest >> childInstance [
	^ PRPage named: 'child'
]

{ #category : #accessing }
PUChangeSecurityTest >> permissions [
	^ Set new
		addAll: PRAddCommand permissions;
		addAll: PRRemoveCommand permissions;
		yourself
]

{ #category : #private }
PUChangeSecurityTest >> structureInstance [
	^ super structureInstance
		addChild: self child;
		yourself
]

{ #category : #'tests-operations' }
PUChangeSecurityTest >> testOperationAdd [
	self command
		with: true;
		all: true;
		operator: #add;
		permissions: self permissions.
	self command execute.
	self
		assert:
			((self command accessor read: self structure)
				includesAll: self permissions).
	self
		assert:
			((self command accessor read: self child)
				includesAll: self permissions)
]

{ #category : #'tests-operations' }
PUChangeSecurityTest >> testOperationRemove [
	| permissions |
	self command
		with: true; all: true;
		operator: #remove; permissions: self permissions.
	self command execute.
	
	permissions := self permissions.
	(self command accessor read: self structure) do:
		[ :each | self deny: (permissions includes: each) ].
	(self command accessor read: self child)do:
		[ :each | self deny: (permissions includes: each) ]
]

{ #category : #'tests-operations' }
PUChangeSecurityTest >> testOperationSet [
	self command
		with: true; all: true;
		operator: #set; permissions: self permissions.
	self command execute.

	self assert: (self command accessor read: self structure) equalElements: self permissions.
	self assert: (self command accessor read: self child) equalElements: self permissions
]

{ #category : #'tests-operations' }
PUChangeSecurityTest >> testOperationUnchanged [
	| structurePermission childPermissions |
	structurePermission := (self command accessor read: self structure)
		copy.
	childPermissions := (self command accessor read: self child)
		copy.

	self command
		with: true; all: true;
		operator: nil; permissions: self permissions.
	self command execute.

	self assert: (self command accessor
		read: self structure) equalElements: structurePermission.
	self assert: (self command accessor
		read: self child) equalElements: childPermissions
]

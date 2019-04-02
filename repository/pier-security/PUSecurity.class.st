"
Every structure is owned by a specific user. The owner of an object comprises its user class. Permissions assigned to the user class only apply to that specific user. A structure is also assigned a group, which comprises its group class. Permissions assigned to the group class only apply to members of that group. Users who are not otherwise represented by the other two classes comprise a file's others class.

The effective permissions that have applied to a specific user in relation to a file are determined in logical precedence. For example, the user who owns the file will have the effective permissions given to the user class regardless of those assigned to the group or others class.
"
Class {
	#name : #PUSecurity,
	#superclass : #PRDecoration,
	#instVars : [
		'owner',
		'ownerPermissions',
		'group',
		'groupPermissions',
		'otherPermissions'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #testing }
PUSecurity class >> isAbstract [
	^ false
]

{ #category : #events }
PUSecurity class >> onStructureAdded: aStructure [ 
	| decoration context user |
	decoration := aStructure isRoot 
		ifTrue: [ aStructure securityDecorationClass new ]
		ifFalse: [ aStructure parent securityDecoration copy ].
	(context := PRCurrentContext value) isNil ifFalse: [
		(user := context user) isNil ifFalse: [
			decoration owner: user.
			decoration group ifNil: [ decoration group: user group ] ] ].
	^ aStructure 
		addDecoration: decoration
		ifPresent: [ :value | value ]
]

{ #category : #visiting }
PUSecurity >> accept: aVisitor [
	aVisitor visitSecurity: self
]

{ #category : #accessing }
PUSecurity >> group [
	^ group
]

{ #category : #accessing }
PUSecurity >> group: aGroup [
	group := aGroup
]

{ #category : #'accessing-permissions' }
PUSecurity >> groupPermissions [
	^ groupPermissions ifNil: [ groupPermissions := self ownerPermissions copy ]
]

{ #category : #'accessing-permissions' }
PUSecurity >> groupPermissions: aSet [
	groupPermissions := aSet asSet
]

{ #category : #testing }
PUSecurity >> hasPermission: aPermission for: aUser [
	"Test if the user aUser has the permission aPermission. This is the central method to test for permissions in Pier."

	(aUser notNil and: [ aUser isSuperuser ])
		ifTrue: [ ^ true ].
	(self owner = aUser and: [ self ownerPermissions includes: aPermission ])
		ifTrue: [ ^ true ].
	(self group notNil and: [ (self group includes: aUser) and: [ (self groupPermissions includes: aPermission) ] ])
		ifTrue: [ ^ true ].
	(self otherPermissions includes: aPermission)
		ifTrue: [ ^ true ].
	^ false
]

{ #category : #initialization }
PUSecurity >> initialize [
	super initialize.
	self ownerPermissions; groupPermissions; otherPermissions
]

{ #category : #testing }
PUSecurity >> isAllowedCommand: aCommandClass in: aContext [
	"Answer if aCommandClass has any permissions in the current context."

	^ aCommandClass permissions
		anySatisfy: [ :permission | self hasPermission: permission for: aContext user ]
]

{ #category : #'accessing-permissions' }
PUSecurity >> otherPermissions [
	^ otherPermissions ifNil: [ otherPermissions := Set withAll: PRViewCommand permissions ]
]

{ #category : #'accessing-permissions' }
PUSecurity >> otherPermissions: aSet [
	otherPermissions := aSet asSet
]

{ #category : #accessing }
PUSecurity >> owner [
	^ owner
]

{ #category : #accessing }
PUSecurity >> owner: anUser [
	owner := anUser
]

{ #category : #'accessing-permissions' }
PUSecurity >> ownerPermissions [
	^ ownerPermissions ifNil: [ ownerPermissions := PUChangeSecurity permissionInstances asSet ]
]

{ #category : #'accessing-permissions' }
PUSecurity >> ownerPermissions: aSet [
	ownerPermissions := aSet asSet
]

{ #category : #copying }
PUSecurity >> postCopy [
	super postCopy.
	self ownerPermissions: self ownerPermissions copy.
	self groupPermissions: self groupPermissions copy.
	self otherPermissions: self otherPermissions copy
]

{ #category : #configuration }
PUSecurity >> priority [
	^ -200
]

{ #category : #testing }
PUSecurity >> validateCommand: aCommand [
	"Validate the evaluation of aCommand on the owning structure. Throws an error if this violates ther current permissions."

	(self hasPermission: aCommand permission for: aCommand context user)
		ifFalse: [ MAConditionError description: self magritteDescription signal: 'Insufficient permissions' ]
]

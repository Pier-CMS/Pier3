Class {
	#name : #PUUser,
	#superclass : #PUMember,
	#instVars : [
		'password',
		'token',
		'groups',
		'superuser',
		'firstName',
		'lastName',
		'email'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #testing }
PUUser class >> isAbstract [
	^ false
]

{ #category : #utilties }
PUUser >> addGroup: aGroup [
	(self groups includes: aGroup)
		ifFalse: [ self groups add: aGroup ].
	aGroup users add: self
]

{ #category : #'accessing-defaults' }
PUUser >> defaultGroups [
	^ PRCurrentContext value kernel groups
]

{ #category : #'accessing-description' }
PUUser >> descriptionEmail [
	<magritteDescription>
	^ MAStringDescription new
		group: 'Additional Information';
		propertyAt: #public put: true;
		propertyAt: #report put: true;
		parameterName: 'email';
		accessor: #email;
		label: 'Email';
		priority: 920;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionFirstName [
	<magritteDescription>
	^ MAStringDescription new
		group: 'Additional Information';
		propertyAt: #public put: true;
		propertyAt: #report put: true;
		parameterName: 'first-name';
		accessor: #firstName;
		label: 'First Name';
		priority: 900;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionFullName [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'full-name';
		accessor: #fullName;
		beReadonly;
		beHidden;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionGroups [
	<magritteDescription>
	| defaultGroups |
	defaultGroups := self defaultGroups.
	
	^ MAMultipleOptionDescription new
		addCondition: (MACondition selector: #notEmpty) labelled: 'A user has to belong to at least one group';
		options: self defaultGroups;
		componentClass: MAListCompositonComponent;
		reference:
				(defaultGroups anyOne descriptionContainer
						add: defaultGroups anyOne descriptionName;
						yourself);
		propertyAt: #report put: true;
		accessor: #groups;
		label: 'Groups';
		priority: 300;
		beDistinct;
		beOrdered;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionLastName [
	<magritteDescription>
	^ MAStringDescription new
		group: 'Additional Information';
		propertyAt: #public put: true;
		propertyAt: #report put: true;
		parameterName: 'last-name';
		accessor: #lastName;
		label: 'Last Name';
		priority: 910;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionPassword [
	<magritteDescription>
	^ MAPasswordDescription new
		accessor: #password;
		label: 'Password';
		priority: 200;
		propertyAt: #public put: true;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PUUser >> descriptionSuperuser [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Superusers have unrestricted rights, they can also edit users and groups.';
		propertyAt: #report put: true;
		accessor: #superuser;
		label: 'Superuser';
		priority: 400;
		yourself
]

{ #category : #accessing }
PUUser >> email [
	^ email
]

{ #category : #accessing }
PUUser >> email: aString [
	email := aString
]

{ #category : #accessing }
PUUser >> firstName [
	^ firstName
]

{ #category : #accessing }
PUUser >> firstName: aString [
	firstName := aString
]

{ #category : #'accessing-readonly' }
PUUser >> fullName [
	"Answer a human readable name of the user."
	
	| full |
	full := String new.
	self firstName notNil
		ifTrue: [ full := full , self firstName , ' ' ].
	self lastName notNil
		ifTrue: [ full := full , self lastName ].
	^ full isEmpty
		ifTrue: [ self name ]
		ifFalse: [ full ]
]

{ #category : #'accessing-readonly' }
PUUser >> group [
	^ self groups first
]

{ #category : #'accessing-readonly' }
PUUser >> groups [
	^ groups
]

{ #category : #'accessing-readonly' }
PUUser >> groups: aCollection [
	self groups do: [ :each | each users remove: self ifAbsent: [ ] ].
	aCollection do: [ :each | each users add: self ].
	groups := aCollection asOrderedCollection
]

{ #category : #initialization }
PUUser >> initialize [
	super initialize.
	groups := OrderedCollection new.
	superuser := false
]

{ #category : #testing }
PUUser >> isSuperuser [
	^ self superuser
]

{ #category : #accessing }
PUUser >> lastName [
	^ lastName
]

{ #category : #accessing }
PUUser >> lastName: aString [
	lastName := aString
]

{ #category : #tokens }
PUUser >> newToken [
	"Creates a new token for cookie authentication."

	^ token := (WAKeyGenerator current keyOfLength: 64) printString
]

{ #category : #accessing }
PUUser >> password [
	^ password isNil ifFalse: [ String new: 8 withAll: $* ]
]

{ #category : #accessing }
PUUser >> password: aString [
	(aString isNil or: [ aString isEmpty or: [ self password = aString ] ])
		ifTrue: [ ^ self ].
	password := GRPlatform current secureHashFor: aString
]

{ #category : #utilties }
PUUser >> removeGroup: aGroup [
	self groups remove: aGroup.
	aGroup users remove: self
]

{ #category : #accessing }
PUUser >> superuser [
	^ superuser
]

{ #category : #accessing }
PUUser >> superuser: aBoolean [
	superuser := aBoolean
]

{ #category : #'accessing-readonly' }
PUUser >> token [
	"Answer a token used for cookie authentication."

	^ token ifNil: [ self newToken ]
]

{ #category : #validating }
PUUser >> validatePassword: aString [
	^ aString isNil not and: [ aString isEmpty not and: [ (GRPlatform current secureHashFor: aString) = password ] ]
]

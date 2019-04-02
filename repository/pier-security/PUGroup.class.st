Class {
	#name : #PUGroup,
	#superclass : #PUMember,
	#instVars : [
		'users'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #testing }
PUGroup class >> isAbstract [
	^ false
]

{ #category : #'accessing-defaults' }
PUGroup >> defaultUsers [
	^ PRCurrentContext value kernel users
]

{ #category : #'accessing-description' }
PUGroup >> descriptionUsers [
	<magritteDescription>
	
	| defaultUsers |
	defaultUsers := self defaultUsers.
	
	^ MAMultipleOptionDescription new
		options: defaultUsers;
		componentClass: MAListCompositonComponent;
		reference:
				(defaultUsers anyOne descriptionContainer
						add: defaultUsers anyOne descriptionName;
						yourself);
		propertyAt: #report put: true;
		accessor: #users;
		label: 'Users';
		priority: 200;
		beDistinct;
		yourself
]

{ #category : #testing }
PUGroup >> includes: anUser [
	^ self users includes: anUser
]

{ #category : #initialization }
PUGroup >> initialize [
	super initialize.
	users := Set new
]

{ #category : #accessing }
PUGroup >> users [
	^ users
]

{ #category : #accessing }
PUGroup >> users: aCollection [
	(aCollection copyWithoutAll: self users) do: [ :user |
		(user groups includes: self)
			ifFalse: [ user groups add: self ] ].
	(self users copyWithoutAll: aCollection) do: [ :user |
		(user groups includes: self)
			ifTrue: [ user groups remove: self ] ].
	users := aCollection asSet
]

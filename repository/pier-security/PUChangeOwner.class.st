Class {
	#name : #PUChangeOwner,
	#superclass : #PUChangeSecurity,
	#instVars : [
		'owner'
	],
	#category : #'Pier-Security-Command'
}

{ #category : #testing }
PUChangeOwner class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUChangeOwner class >> label [
	^ 'Change Owner'
]

{ #category : #accessing }
PUChangeOwner >> accessor [
	^ #(securityDecoration ownerPermissions) asAccessor
]

{ #category : #'accessing-description' }
PUChangeOwner >> descriptionOwner [
	<magritteDescription>
	
	| userInstances |
	userInstances := self userInstances.
	^ MASingleOptionDescription new
		comment: 'Changes the ownership to the selected user.';
		options: userInstances;
		reference: userInstances anyOne magritteDescription;
		undefined: '(unchanged)';
		parameterName: 'group';
		accessor: #owner;
		label: 'Owner';
		priority: 200;
		beSorted;
		yourself
]

{ #category : #events }
PUChangeOwner >> doExecuteFor: aStructure [
	self owner notNil
		ifTrue: [ aStructure securityDecoration owner: self owner ].
	super doExecuteFor: aStructure
]

{ #category : #accessing }
PUChangeOwner >> owner [
	^ owner ifNil: [ owner := self structure owner ]
]

{ #category : #accessing }
PUChangeOwner >> owner: anUser [
	owner := anUser
]

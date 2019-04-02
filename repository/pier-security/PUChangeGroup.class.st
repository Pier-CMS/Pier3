Class {
	#name : #PUChangeGroup,
	#superclass : #PUChangeSecurity,
	#instVars : [
		'group'
	],
	#category : #'Pier-Security-Command'
}

{ #category : #accessing }
PUChangeGroup class >> accessKey [
	^ $g
]

{ #category : #testing }
PUChangeGroup class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUChangeGroup class >> label [
	^ 'Change Group'
]

{ #category : #configuration }
PUChangeGroup >> accessor [
	^ #(securityDecoration groupPermissions) asAccessor
]

{ #category : #'accessing-description' }
PUChangeGroup >> descriptionGroup [
	<magritteDescription>
	
	| groupInstances |
	groupInstances := self groupInstances.
	^ MASingleOptionDescription new
		comment: 'Changes the group ownership to the selected group.';
		options: groupInstances;
		reference: groupInstances anyOne magritteDescription;
		undefined: '(unchanged)';
		parameterName: 'group';
		accessor: #group;
		label: 'Group';
		priority: 200;
		beSorted;
		yourself
]

{ #category : #events }
PUChangeGroup >> doExecuteFor: aStructure [
	self group notNil
		ifTrue: [ aStructure securityDecoration group: self group ].
	super doExecuteFor: aStructure
]

{ #category : #accessing }
PUChangeGroup >> group [
	^ group ifNil: [ group := self structure group ]
]

{ #category : #accessing }
PUChangeGroup >> group: aGroup [
	group := aGroup
]

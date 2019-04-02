Extension { #name : #PRStructure }

{ #category : #'*pier-security-descriptions' }
PRStructure >> descriptionGroup [
	<magritteDescription>
	^ MAToOneRelationDescription new
		classes: (Array with: PUGroup);
		parameterName: 'group';
		accessor: #group;
		label: 'Group';
		priority: 210;
		yourself
]

{ #category : #'*pier-security-descriptions' }
PRStructure >> descriptionOwner [
	<magritteDescription>
	^ MAToOneRelationDescription new
		classes: (Array with: PUUser);
		parameterName: 'owner';
		accessor: #owner;
		label: 'Owner';
		priority: 200;
		yourself
]

{ #category : #'*pier-security-accessing' }
PRStructure >> group [
	"Answer the owning-group of the file."

	| decoration |
	^ (decoration := self securityDecoration) isNil ifFalse: [ decoration group ]
]

{ #category : #'*pier-security-accessing' }
PRStructure >> owner [
	"Answer the owning-user of the receiver."

	| decoration |
	^ (decoration := self securityDecoration) isNil ifFalse: [ decoration owner ]
]

{ #category : #'*pier-security-decorations' }
PRStructure >> securityDecoration [
	^ self
		decorationOfClass: self securityDecorationClass
		ifAbsent: [ self securityDecorationClass onStructureAdded: self ]
]

{ #category : #'*pier-security-decorations' }
PRStructure >> securityDecorationClass [
	^ PUSecurity
]

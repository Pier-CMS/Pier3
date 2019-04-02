Class {
	#name : #PUChangeSecurity,
	#superclass : #PRCommand,
	#instVars : [
		'with',
		'all',
		'operator',
		'permissions'
	],
	#category : #'Pier-Security-Command'
}

{ #category : #'accessing-defaults' }
PUChangeSecurity class >> defaultAll [
	^ false
]

{ #category : #'accessing-defaults' }
PUChangeSecurity class >> defaultOperator [
	^ self defaultOperators first
]

{ #category : #'accessing-defaults' }
PUChangeSecurity class >> defaultOperators [
	^ #( set add remove )
]

{ #category : #'accessing-defaults' }
PUChangeSecurity class >> defaultWith [
	^ true
]

{ #category : #private }
PUChangeSecurity class >> permissionInstances [
	^ PRCommand withAllConcreteClasses gather: [ :each | each permissions ]
]

{ #category : #accessing }
PUChangeSecurity >> accessor [
	self subclassResponsibility
]

{ #category : #'accessing-scope' }
PUChangeSecurity >> all [
	^ all ifNil: [ all := self class defaultAll ]
]

{ #category : #'accessing-scope' }
PUChangeSecurity >> all: aBoolean [
	all := aBoolean
]

{ #category : #'accessing-description' }
PUChangeSecurity >> descriptionAll [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Apply changes recursively to all children.';
		parameterName: 'recursive';
		default: self class defaultAll;
		label: 'Recursive';
		accessor: #all;
		priority: 110;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PUChangeSecurity >> descriptionOperator [
	<magritteDescription>
	^ MASingleOptionDescription new
		comment:
				'Defines if the permissions should remain unchanged, be set to the selected ones, or be added/removed from the current selection.';
		reference: MASymbolDescription new;
		options: self class defaultOperators;
		default: self class defaultOperator;
		parameterName: 'operator';
		undefined: '(unchanged)';
		accessor: #operator;
		label: 'Operator';
		priority: 300;
		yourself
]

{ #category : #'accessing-description' }
PUChangeSecurity >> descriptionPermissions [
	<magritteDescription>
	^ MAMultipleOptionDescription new
		comment: 'Defines the set of permissions used together with the selected operation.';
		options: self class permissionInstances;
		reference: PUPermission new magritteDescription;
		parameterName: 'permissions';
		accessor: #permissions;
		label: 'Permissions';
		priority: 310;
		beSorted;
		yourself
]

{ #category : #'accessing-description' }
PUChangeSecurity >> descriptionWith [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Apply changes to the current structure.';
		parameterName: 'current';
		default: self class defaultWith;
		accessor: #with;
		label: 'Current';
		priority: 100;
		beRequired;
		yourself
]

{ #category : #events }
PUChangeSecurity >> doExecute [
	| enumerator |
	super doExecute.
	enumerator := self structure enumerator.
	self with ifTrue: [ enumerator with ].
	self all ifTrue: [ enumerator all ].
	enumerator do: [ :each |
		(self all or: [ self structure = each ])
			ifTrue: [ self doExecuteFor: each ] ]
]

{ #category : #events }
PUChangeSecurity >> doExecuteFor: aStructure [
	"Apply the changes to aStructure. Override this method to further modify aStructure. This method is automatically called by #doExecute for all the requested structure."

	self accessor
		write: (self operator = #set
			ifTrue: [ self permissions copy ]
			ifFalse: [
				self operator = #add
					ifTrue: [
						(self accessor read: aStructure)
							copyWithAll: self permissions ]
					ifFalse: [
						self operator = #remove
							ifTrue: [
								(self accessor read: aStructure)
									copyWithoutAll: self permissions ]
							ifFalse: [ ^ self ] ] ])
		to: aStructure
]

{ #category : #private }
PUChangeSecurity >> groupInstances [
	^ self context kernel groups
]

{ #category : #'accessing-operation' }
PUChangeSecurity >> operator [
	^ operator
]

{ #category : #'accessing-operation' }
PUChangeSecurity >> operator: aSymbol [
	operator := aSymbol
]

{ #category : #'accessing-operation' }
PUChangeSecurity >> permissions [
	^ permissions ifNil: [ permissions := self accessor read: self structure ]
]

{ #category : #'accessing-operation' }
PUChangeSecurity >> permissions: aCollectionOfCommands [
	permissions := aCollectionOfCommands asSet
]

{ #category : #accessing }
PUChangeSecurity >> saveButton [
	^ super saveButton value: 'Apply'
]

{ #category : #private }
PUChangeSecurity >> userInstances [
	^ self context kernel users
]

{ #category : #'accessing-scope' }
PUChangeSecurity >> with [
	^ with ifNil: [ with := self class defaultWith ]
]

{ #category : #'accessing-scope' }
PUChangeSecurity >> with: aBoolean [
	with := aBoolean
]

Class {
	#name : #PRDynamicChildrenWidget,
	#superclass : #PRChildrenWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRDynamicChildrenWidget class >> defaultLevel [
	^ nil
]

{ #category : #testing }
PRDynamicChildrenWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRDynamicChildrenWidget class >> label [
	^ 'Children (context)'
]

{ #category : #'accessing-description' }
PRDynamicChildrenWidget >> descriptionExpanded [
	<magritteDescription>
	^ MABooleanDescription new
		default: self class defaultExpanded;
		parameterName: 'expand';
		accessor: #expanded;
		label: 'Expand';
		priority: 310;
		yourself
]

{ #category : #'accessing-description' }
PRDynamicChildrenWidget >> descriptionLevel [
	<magritteDescription>
	^ MANumberDescription new
		default: self class defaultLevel;
		parameterName: 'level';
		accessor: #level;
		label: 'Level';
		priority: 300;
		beInteger;
		min: 0;
		yourself
]

{ #category : #accessing }
PRDynamicChildrenWidget >> expanded [
	^ self readUsing: self descriptionExpanded
]

{ #category : #accessing }
PRDynamicChildrenWidget >> expanded: expand [
	self write: expand using: self descriptionExpanded
]

{ #category : #accessing }
PRDynamicChildrenWidget >> level [
	^ self readUsing: self descriptionLevel
]

{ #category : #accessing }
PRDynamicChildrenWidget >> level: level [
	self write: level using: self descriptionLevel
]

{ #category : #rendering }
PRDynamicChildrenWidget >> renderItem: aStructure on: html [
	| children |
	super renderItem: aStructure on: html.
	self expanded ifFalse: [ ^ self ].
	children := self childrenOf: aStructure.
	children isEmpty
		ifFalse: [ self renderItems: children on: html ]
]

{ #category : #accessing }
PRDynamicChildrenWidget >> unfilteredItems [
	| structure children |
	structure :=  self context structure.
	self level isNil ifFalse: [
		^ self childrenOf: (structure parents
			at: self level
			ifAbsent: [ ^ #() ]) ].
	children := self childrenOf: structure.
	^ (children isEmpty and: [ structure isRoot not ])
		ifTrue: [ self childrenOf: structure parent ]
		ifFalse: [ children ]
]

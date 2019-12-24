Class {
	#name : #PRStaticChildrenWidget,
	#superclass : #PRChildrenWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #testing }
PRStaticChildrenWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRStaticChildrenWidget class >> label [
	^ 'Children (static)'
]

{ #category : #accessing }
PRStaticChildrenWidget >> addAll: aStructure to: aCollection [
	| children |
	children := self childrenOf: aStructure.
	children ifNotEmpty: [ 
		aCollection add: aStructure.
		children do: [:each | self addAll: each to: aCollection  ] ]
]

{ #category : #'accessing-description' }
PRStaticChildrenWidget >> descriptionExpandActive [
	<magritteDescription>
	^ MABooleanDescription new
		default: self class defaultExpanded;
		parameterName: 'expand';
		accessor: #expandActive;
		label: 'Expand active';
		priority: 310;
		yourself
]

{ #category : #'accessing-description' }
PRStaticChildrenWidget >> descriptionNode [
	<magritteDescription>
	| defaultValue |
	self context
		ifNil: [ defaultValue := nil ]
		ifNotNil: [ defaultValue := self context structure parents at:  1 ifAbsent: [ nil ] ].
	^ MASingleOptionDescription new
		default: defaultValue;
		accessor: #node;
		label: 'Node';
		beRequired;
		priority: 300;
		yourself
]

{ #category : #'accessing-description' }
PRStaticChildrenWidget >> descriptionOptionsNode: aDescription [
	<magritteDescription: #descriptionNode>
	^aDescription
		options: self possibleParents;
		yourself
]

{ #category : #accessing }
PRStaticChildrenWidget >> expandActive [
	^self readUsing: self descriptionExpandActive
]

{ #category : #accessing }
PRStaticChildrenWidget >> expandActive: aBoolean [
	^self write: aBoolean using: self descriptionExpandActive
]

{ #category : #accessing }
PRStaticChildrenWidget >> node [
	^self readUsing: self descriptionNode
]

{ #category : #accessing }
PRStaticChildrenWidget >> node: aValue [
	^self write: aValue using: self descriptionNode
]

{ #category : #accessing }
PRStaticChildrenWidget >> possibleParents [
	| retVal |
	self context ifNil: [ ^#() ].
	retVal := OrderedCollection new.
	self addAll: (self context structure parents at: 1 ifAbsent: [ ^#() ]) to: retVal.
	^retVal
]

{ #category : #rendering }
PRStaticChildrenWidget >> renderItem: aStructure on: html [
	| children |
	super renderItem: aStructure on: html.
	self expandActive ifFalse: [ ^self ].
	(self isActive: aStructure) ifFalse: [ ^ self ].
	children := self childrenOf: aStructure.
	children isEmpty
		ifFalse: [ self renderItems: children on: html ]
]

{ #category : #accessing }
PRStaticChildrenWidget >> unfilteredItems [
	self node ifNil: [ ^#() ].
	^self childrenOf: self node
]

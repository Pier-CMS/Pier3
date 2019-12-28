Class {
	#name : #PRChildrenWidget,
	#superclass : #PRStructuresWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRChildrenWidget class >> defaultExpanded [
	^ false
]

{ #category : #accessing }
PRChildrenWidget class >> isAbstract [
	^true
]

{ #category : #accessing }
PRChildrenWidget class >> label [
	^ 'Children'
]

{ #category : #'accessing-description' }
PRChildrenWidget >> descriptionExpand [
	" deprecated. Please use expanded "
	^ MABooleanDescription new
		default: self class defaultExpanded;
		parameterName: 'expand';
		accessor: #expand;
		label: 'Expand';
		priority: 310;
		yourself
]

{ #category : #accessing }
PRChildrenWidget >> expand [
	self deprecated: 'Replaced by expanded, as expand is overloaded.'.
	^(self readUsing: self descriptionExpand)
]

{ #category : #accessing }
PRChildrenWidget >> expand: expand [
	self deprecated: 'Replaced by expanded, as expand is overloaded.'.
	self expanded: expand
]

{ #category : #accessing }
PRChildrenWidget >> unfilteredItems [
	| structure children |
	structure :=  self context structure.
	children := self childrenOf: structure.
	^ (children isEmpty and: [ structure isRoot not ])
		ifTrue: [ self childrenOf: structure parent ]
		ifFalse: [ children ]
]

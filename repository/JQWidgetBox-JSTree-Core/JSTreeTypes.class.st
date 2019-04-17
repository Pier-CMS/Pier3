Class {
	#name : #JSTreeTypes,
	#superclass : #GRObject,
	#instVars : [
		'maxDepth',
		'maxChildren',
		'types',
		'validChildrenTypes'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #accessing }
JSTreeTypes >> addType: aJSTreeType [
	self types at: (JSStream on: (aJSTreeType name)) put: aJSTreeType.
]

{ #category : #'initialize-release' }
JSTreeTypes >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	maxDepth:= -2.
	maxChildren := -2.
	validChildrenTypes := OrderedCollection new.
	types := Dictionary new.

	

	^self
]

{ #category : #accessing }
JSTreeTypes >> maxChildren [
	^maxChildren
]

{ #category : #accessing }
JSTreeTypes >> maxChildren: anObject [
	maxChildren := anObject
]

{ #category : #accessing }
JSTreeTypes >> maxDepth [
	^maxDepth
]

{ #category : #accessing }
JSTreeTypes >> maxDepth: anObject [
	maxDepth := anObject
]

{ #category : #accessing }
JSTreeTypes >> types [
	^types
]

{ #category : #accessing }
JSTreeTypes >> types: anObject [
	types := anObject
]

{ #category : #accessing }
JSTreeTypes >> validChildrenTypes [
	^validChildrenTypes
]

{ #category : #accessing }
JSTreeTypes >> validChildrenTypes: anObject [
	validChildrenTypes := anObject
]

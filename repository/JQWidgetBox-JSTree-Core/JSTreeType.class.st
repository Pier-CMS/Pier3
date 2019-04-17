"
The types enables node types - each node can have a type, and you can define rules on how that type should behave - maximum children count, maximum depth, valid children types, selectable or not, etc.
"
Class {
	#name : #JSTreeType,
	#superclass : #GRObject,
	#instVars : [
		'name',
		'icon',
		'maxChildren',
		'maxDepth',
		'validChildren',
		'selectNode',
		'openNode',
		'closeNode',
		'createNode',
		'deleteNode',
		'contextMenuItems'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #'instance creation' }
JSTreeType class >> newForModelClass: aModelClass [
	^(self new) 
		name: aModelClass type;
		validChildren: (aModelClass validChildren ifNotNil: [:types | types collect: [:each | each type]]);
		icon: (aModelClass icon ifNotNil: [:icon | (JSTreeTypeIcon new) image: icon]);
		yourself
]

{ #category : #accessing }
JSTreeType >> closeNode [
	^closeNode
]

{ #category : #accessing }
JSTreeType >> closeNode: anObject [
	closeNode := anObject
]

{ #category : #accessing }
JSTreeType >> contextMenuItems [
	^contextMenuItems
]

{ #category : #accessing }
JSTreeType >> contextMenuItems: anObject [
	contextMenuItems := anObject
]

{ #category : #accessing }
JSTreeType >> createNode [
	^createNode
]

{ #category : #accessing }
JSTreeType >> createNode: anObject [
	createNode := anObject
]

{ #category : #accessing }
JSTreeType >> deleteNode [
	^deleteNode
]

{ #category : #accessing }
JSTreeType >> deleteNode: anObject [
	deleteNode := anObject
]

{ #category : #accessing }
JSTreeType >> icon [
	^icon
]

{ #category : #accessing }
JSTreeType >> icon: anObject [
	icon := anObject
]

{ #category : #'initialize-release' }
JSTreeType >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Edit the following to properly initialize instance variables ***"
	name := nil.
	maxChildren := nil.
	maxDepth := nil.
	validChildren := nil.
	selectNode := nil.
	openNode := nil.
	closeNode := nil.
	createNode := nil.
	deleteNode := nil.
	" *** And replace this comment with additional initialization code *** "
	^self
]

{ #category : #accessing }
JSTreeType >> maxChildren [
	^maxChildren
]

{ #category : #accessing }
JSTreeType >> maxChildren: anObject [
	maxChildren := anObject
]

{ #category : #accessing }
JSTreeType >> maxDepth [
	^maxDepth
]

{ #category : #accessing }
JSTreeType >> maxDepth: anObject [
	maxDepth := anObject
]

{ #category : #accessing }
JSTreeType >> name [
	^name
]

{ #category : #accessing }
JSTreeType >> name: anObject [
	name := anObject
]

{ #category : #accessing }
JSTreeType >> openNode [
	^openNode
]

{ #category : #accessing }
JSTreeType >> openNode: anObject [
	openNode := anObject
]

{ #category : #accessing }
JSTreeType >> selectNode [
	^selectNode
]

{ #category : #accessing }
JSTreeType >> selectNode: anObject [
	selectNode := anObject
]

{ #category : #accessing }
JSTreeType >> validChildren [
	^validChildren
]

{ #category : #accessing }
JSTreeType >> validChildren: anObject [
	validChildren := anObject
]

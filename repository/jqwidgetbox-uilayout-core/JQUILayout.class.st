"
JQuery wrapper for the UI layout plugin

see http://layout.jquery-dev.net
"
Class {
	#name : #JQUILayout,
	#superclass : #JQWidget,
	#instVars : [
		'north',
		'south',
		'east',
		'west',
		'center'
	],
	#category : #'JQWidgetBox-UILayout-Core'
}

{ #category : #accessing }
JQUILayout >> applyDefaultStyles [
	self optionAt: 'applyDefaultStyles' put: true
]

{ #category : #accessing }
JQUILayout >> center [
	center isNil
		ifTrue: [ self center: (center := GRSmallDictionary new) ].
	^ center
]

{ #category : #accessing }
JQUILayout >> center: anObject [
	self optionAt: 'center' put: anObject
]

{ #category : #accessing }
JQUILayout >> east [
	east isNil
		ifTrue: [ self east: (east := GRSmallDictionary new) ].
	^ east
]

{ #category : #accessing }
JQUILayout >> east: anObject [
	self optionAt: 'east' put: anObject
]

{ #category : #accessing }
JQUILayout >> method [
 
	^'layout'
]

{ #category : #accessing }
JQUILayout >> north [
	north isNil
		ifTrue: [ self north: (north := GRSmallDictionary new) ].
	^ north
]

{ #category : #accessing }
JQUILayout >> north: anObject [
	self optionAt: 'north' put: anObject
]

{ #category : #accessing }
JQUILayout >> south [
	south isNil
		ifTrue: [ self south: (south := GRSmallDictionary new) ].
	^ south
]

{ #category : #accessing }
JQUILayout >> south: anObject [
	self optionAt: 'south' put: anObject
]

{ #category : #accessing }
JQUILayout >> west [
	west isNil
		ifTrue: [ self west: (west := GRSmallDictionary new) ].
	^ west
]

{ #category : #accessing }
JQUILayout >> west: anObject [
	self optionAt: 'west' put: anObject
]

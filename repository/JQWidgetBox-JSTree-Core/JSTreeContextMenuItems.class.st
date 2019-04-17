Class {
	#name : #JSTreeContextMenuItems,
	#superclass : #GRObject,
	#instVars : [
		'menuItems',
		'renderContext'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #accessing }
JSTreeContextMenuItems >> addMenuItem: menuItem [
	self menuItems add: menuItem
]

{ #category : #testing }
JSTreeContextMenuItems >> isEmpty [
	^ self menuItems isEmpty
]

{ #category : #json }
JSTreeContextMenuItems >> jsonOn: aStream [
	aStream nextPut: ${.
		
	self menuItems 
		do: [ :each |
			each renderContext: self renderContext.
			aStream json: each ]
		separatedBy: [ aStream nextPut: $, ].
	
	aStream nextPut: $}.

]

{ #category : #accessing }
JSTreeContextMenuItems >> menuItems [
	^ menuItems ifNil: [ menuItems := OrderedCollection new ]
]

{ #category : #accessing }
JSTreeContextMenuItems >> renderContext [
	^ renderContext
]

{ #category : #accessing }
JSTreeContextMenuItems >> renderContext: anObject [
	renderContext := anObject
]

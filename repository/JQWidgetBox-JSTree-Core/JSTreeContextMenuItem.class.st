Class {
	#name : #JSTreeContextMenuItem,
	#superclass : #GRObject,
	#instVars : [
		'key',
		'label',
		'action',
		'disabled',
		'styleClass',
		'separatorBefore',
		'separatorAfter',
		'icon',
		'submenu',
		'renderContext'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #'instance creation' }
JSTreeContextMenuItem class >> label: label [
	^ self new
		label: label;
		yourself
]

{ #category : #accessing }
JSTreeContextMenuItem >> action [
	^ action
]

{ #category : #accessing }
JSTreeContextMenuItem >> action: anObject [
	action := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> disabled [
	^ disabled ifNil: [ disabled := false ]
]

{ #category : #accessing }
JSTreeContextMenuItem >> disabled: anObject [
	disabled := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> icon [
	^ icon
]

{ #category : #accessing }
JSTreeContextMenuItem >> icon: anObject [
	icon := anObject
]

{ #category : #json }
JSTreeContextMenuItem >> jsonOn: aStream [
	aStream
		json: self label asLowercase;
		nextPut: $:;
		nextPut: ${;
		json: 'label';
		nextPut: $:;
		json: self label.
		
	self submenu isEmpty not ifTrue: [
		self submenu renderContext: self renderContext.
		aStream
			nextPut: $,;
			json: 'submenu';
			nextPut: $:;
			json: self submenu ].
			
	aStream
			nextPut: $,;
			json: 'separator_before';
			nextPut: $:;
			json: self separatorBefore; 
			nextPut: $,;
			json: 'separator_after';
			nextPut: $:;
			json: self separatorAfter;
			nextPut: $,;
			json: 'disabled';
			nextPut: $:;
			json: self disabled.
			
	self styleClass notNil ifTrue: [
		aStream
			nextPut: $,;
			json: 'style_class';
			nextPut: $:;
			json: self styleClass ].
		
	self icon notNil ifTrue: [
		aStream
			nextPut: $,;
			json: 'icon';
			nextPut: $:;
			json: self icon ].
		
	self action notNil ifTrue: [
		aStream
			nextPut: $,;
			json: 'action';
			nextPut: $:.
		self action isBlock 
			ifTrue: [
				aStream javascript: 
					((JQueryClass context: self renderContext) ajax script: [ :s |
						self action value: s ]) asFunction ]
			ifFalse: [
				aStream javascript: self action ] ].
	aStream 
		nextPut: $}.

]

{ #category : #accessing }
JSTreeContextMenuItem >> key [
	^ key
]

{ #category : #accessing }
JSTreeContextMenuItem >> key: anObject [
	key := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> label [
	^ label
]

{ #category : #accessing }
JSTreeContextMenuItem >> label: anObject [
	label := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> renderContext [
	^ renderContext
]

{ #category : #accessing }
JSTreeContextMenuItem >> renderContext: anObject [
	renderContext := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> separatorAfter [
	^ separatorAfter ifNil: [ separatorAfter := false ]
]

{ #category : #accessing }
JSTreeContextMenuItem >> separatorAfter: anObject [
	separatorAfter := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> separatorBefore [
	^ separatorBefore ifNil: [ separatorBefore := false ]
]

{ #category : #accessing }
JSTreeContextMenuItem >> separatorBefore: anObject [
	separatorBefore := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> styleClass [
	^ styleClass
]

{ #category : #accessing }
JSTreeContextMenuItem >> styleClass: anObject [
	styleClass := anObject
]

{ #category : #accessing }
JSTreeContextMenuItem >> submenu [
	^ submenu ifNil: [ 
		submenu := JSTreeContextMenuItems new ]
]

Class {
	#name : #JSTreeEvent,
	#superclass : #GRObject,
	#instVars : [
		'event',
		'node',
		'ref',
		'position',
		'title',
		'type',
		'isCopy'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #'instance creation' }
JSTreeEvent class >> newFromWARequest: aWARequest [

	^(self new)
		node: (JSTreeNode newFromWARequest: aWARequest);
		ref: (JSTreeNode newFromWARequest:aWARequest prefix: 'ref_'); 
		event: (aWARequest at: 'event' ifAbsent: [nil] );
		position: (aWARequest at: 'position' ifAbsent: [nil]);
		title: (aWARequest at: 'title' ifAbsent: [nil]);
		type: (aWARequest at: 'type' ifAbsent: [nil]);
		isCopy: (aWARequest at: 'performcopy' ifAbsent: [nil])
		yourself
]

{ #category : #accessing }
JSTreeEvent >> event [
	^event
]

{ #category : #accessing }
JSTreeEvent >> event: anObject [
	event := anObject
]

{ #category : #accessing }
JSTreeEvent >> isCopy [
	^ isCopy == true
]

{ #category : #accessing }
JSTreeEvent >> isCopy: anObject [
	isCopy := anObject
]

{ #category : #accessing }
JSTreeEvent >> node [
	^node
]

{ #category : #accessing }
JSTreeEvent >> node: anObject [
	node := anObject
]

{ #category : #accessing }
JSTreeEvent >> position [
	^position
]

{ #category : #accessing }
JSTreeEvent >> position: anObject [
	position := anObject
]

{ #category : #accessing }
JSTreeEvent >> ref [
	^ref
]

{ #category : #accessing }
JSTreeEvent >> ref: anObject [
	ref := anObject
]

{ #category : #accessing }
JSTreeEvent >> title [
	^title
]

{ #category : #accessing }
JSTreeEvent >> title: anObject [
	title := anObject
]

{ #category : #accessing }
JSTreeEvent >> type [
	^type
]

{ #category : #accessing }
JSTreeEvent >> type: anObject [
	type := anObject
]

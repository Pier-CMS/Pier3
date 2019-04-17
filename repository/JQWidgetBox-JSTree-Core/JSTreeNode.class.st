Class {
	#name : #JSTreeNode,
	#superclass : #GRObject,
	#instVars : [
		'title',
		'id',
		'type',
		'children',
		'attributes',
		'icon',
		'metadata',
		'state'
	],
	#category : #'JQWidgetBox-JSTree-Core'
}

{ #category : #'instance creation' }
JSTreeNode class >> newFromWARequest: aWARequest [
	^self newFromWARequest: aWARequest prefix: ''
]

{ #category : #'instance creation' }
JSTreeNode class >> newFromWARequest: aWARequest prefix: aPrefixString [
	^ self new
		id: (aWARequest at: aPrefixString , 'id' ifAbsent: [ nil ]);
		title: (aWARequest at: aPrefixString , 'title' ifAbsent: [ nil ]);
		type: (aWARequest at: aPrefixString , 'type' ifAbsent: [ nil ]);
		metadata: ((aWARequest at: aPrefixString , 'metadata' ifAbsent: [ nil ])
					ifNotNil: [ :value | 
						(value isEmptyOrNil not)
							ifTrue: [JSJsonParser parse: value ] ]);
		yourself
]

{ #category : #accessing }
JSTreeNode >> attributes [
	^ attributes ifNil: [ attributes := GRSmallDictionary ]
]

{ #category : #accessing }
JSTreeNode >> attributes: anObject [
	attributes := anObject
]

{ #category : #accessing }
JSTreeNode >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #accessing }
JSTreeNode >> children: anObject [
	children := anObject
]

{ #category : #accessing }
JSTreeNode >> icon [
	^icon
]

{ #category : #accessing }
JSTreeNode >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
JSTreeNode >> id [
	^id
]

{ #category : #accessing }
JSTreeNode >> id: anObject [
	id := anObject
]

{ #category : #testing }
JSTreeNode >> isRoot [
	^self id = '-1'
]

{ #category : #'as yet unclassified' }
JSTreeNode >> javascriptContentOn:  aStream [

	self jsonOn: aStream
]

{ #category : #'as yet unclassified' }
JSTreeNode >> javascriptOn:  aStream [

	self jsonOn: aStream
]

{ #category : #'as yet unclassified' }
JSTreeNode >> jsonOn: aStream [
	GRSmallDictionary new
		at: 'data'
			put: (GRSmallDictionary new
					at: 'title' put: self title;
					yourself);
		at: 'children' put: self children;
		at: 'attr'
			put: (self attributes
				at: 'id' put: self id;
				at: 'rel' put: self type;
				yourself);
		at: 'state' put: self state;
		at: 'metadata' put: self metadata;
		jsonOn: aStream
]

{ #category : #accessing }
JSTreeNode >> metadata [
	^metadata
]

{ #category : #accessing }
JSTreeNode >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
JSTreeNode >> state [
	^state ifNil: [state := 'closed']
]

{ #category : #accessing }
JSTreeNode >> state: anObject [
	state := anObject
]

{ #category : #accessing }
JSTreeNode >> title [
	^title
]

{ #category : #accessing }
JSTreeNode >> title: anObject [
	title := anObject
]

{ #category : #accessing }
JSTreeNode >> type [
	^type
]

{ #category : #accessing }
JSTreeNode >> type: anObject [
	type := anObject
]

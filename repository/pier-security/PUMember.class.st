Class {
	#name : #PUMember,
	#superclass : #PRObject,
	#instVars : [
		'name',
		'comment'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #'instance creation' }
PUMember class >> named: aString [
	^ self new
		setName: aString;
		yourself
]

{ #category : #comparing }
PUMember >> = anObject [
	^ self class = anObject class
		and: [ self name = anObject name ]
]

{ #category : #accessing }
PUMember >> comment [
	^ comment
]

{ #category : #accessing }
PUMember >> comment: aString [
	comment := aString
]

{ #category : #'accessing-description' }
PUMember >> descriptionComment [
	<magritteDescription>
	^ MAMemoDescription new
		group: 'Additional Information';
		propertyAt: #public put: true;
		accessor: #comment;
		label: 'Comment';
		priority: 990;
		lineCount: 3;
		yourself
]

{ #category : #'accessing-description' }
PUMember >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		propertyAt: #public put: true;
		propertyAt: #report put: true;
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		priority: 100;
		beReadonly;
		beRequired;
		yourself
]

{ #category : #comparing }
PUMember >> hash [
	^ self class hash bitXor: self name hash
]

{ #category : #accessing }
PUMember >> name [
	^ name
]

{ #category : #printing }
PUMember >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' name: '; print: self name
]

{ #category : #initialization }
PUMember >> setName: aString [
	name := aString
]

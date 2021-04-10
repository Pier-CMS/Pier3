Class {
	#name : #PBEntry,
	#superclass : #PRCase,
	#instVars : [
		'uuid',
		'author',
		'publication'
	],
	#category : #'Pier-Blog-Model'
}

{ #category : #testing }
PBEntry class >> isAbstract [
	^ self name = #PBEntry
]

{ #category : #visiting }
PBEntry >> accept: aVisitor [
	aVisitor visitEntry: self
]

{ #category : #'accessing-dynamic' }
PBEntry >> allCommentsIn: aContext [
	"Answer all the published comments in choronological order."

	^ ((aContext enumeratorFor: self) all
		select: [ :each |
			each isComment
				and: [ each publication notNil
				and: [ each publication <= GRPlatform current magritteTimeStampClass now ] ] ])
		sort: [ :a :b | a publication < b publication ];
		yourself
]

{ #category : #accessing }
PBEntry >> author [
	^ author ifNil: [ author := self findAuthor ]
]

{ #category : #accessing }
PBEntry >> author: aString [
	author := aString
]

{ #category : #'accessing-descriptions' }
PBEntry >> descriptionAuthor [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #author;
		comment: 'The author of the entry.';
		label: 'Author';
		priority: 300;
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-descriptions' }
PBEntry >> descriptionPublication [
	<magritteDescription>
	^ MADateAndTimeDescription new
		accessor: #publication;
		comment: 'The publication date of the entry.';
		label: 'Publication';
		priority: 310;
		beEditable;
		yourself
]

{ #category : #private }
PBEntry >> findAuthor [
	| context user |
	context := PRCurrentContext value
		ifNil: [ ^ nil ].
	user := (context
		propertyAt: #user
		ifAbsent: [ ^ nil ])
			ifNil: [ ^ nil ].
	^ user fullName
]

{ #category : #copying }
PBEntry >> postCopy [
	super postCopy.
	uuid := nil
]

{ #category : #accessing }
PBEntry >> publication [
	^ publication
]

{ #category : #accessing }
PBEntry >> publication: aTimeStamp [
	publication := aTimeStamp
]

{ #category : #accessing }
PBEntry >> uuid [
	^ uuid ifNil: [ uuid := SmallInteger maxVal atRandom greaseString ]
]

{ #category : #accessing }
PBEntry >> uuid: anObject [
	uuid := anObject
]

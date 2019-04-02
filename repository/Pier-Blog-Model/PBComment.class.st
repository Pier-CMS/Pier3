Class {
	#name : #PBComment,
	#superclass : #PBEntry,
	#instVars : [
		'website'
	],
	#category : #'Pier-Blog-Model'
}

{ #category : #testing }
PBComment class >> canBeChildOf: aClass [
	^ aClass includesBehavior: PBPost
]

{ #category : #testing }
PBComment class >> canBeParentOf: aClass [
	^ false
]

{ #category : #accessing }
PBComment class >> label [
	^ 'Blog Comment'
]

{ #category : #visiting }
PBComment >> accept: aVisitor [
	aVisitor visitComment: self
]

{ #category : #private }
PBComment >> confirmation [
	^ false
]

{ #category : #private }
PBComment >> confirmation: aBoolean [
]

{ #category : #'accessing-descriptions' }
PBComment >> descriptionAuthor [
	<magritteDescription>
	^ super descriptionAuthor
		propertyAt: #public put: true;
		yourself
]

{ #category : #'accessing-descriptions' }
PBComment >> descriptionConfirmation [
	<magritteDescription>
	^ MABooleanDescription new
		addCondition: (MACondition selector: #yourself) labelled: 'Please, confirm submission by clicking the checkbox';
		checkboxLabel: 'Confirm submission by clicking the checkbox';
		propertyAt: #public put: true;
		accessor: #confirmation;
		label: 'Confirmation';
		priority: 600;
		beEditable;
		yourself
]

{ #category : #'accessing-descriptions' }
PBComment >> descriptionDocument [
	<magritteDescription>
	^ super descriptionDocument
		propertyAt: #public put: true;
		beRequired;
		yourself
]

{ #category : #'accessing-descriptions' }
PBComment >> descriptionWebsite [
	<magritteDescription>
	^ MAStringDescription new
		addCondition: (MACondition selector: #matches: argument: '#*.##*') labelled: 'Please make sure to enter a valid URL';
		comment: 'The URL to the blog or personal website of the author';
		propertyAt: #public put: true;
		accessor: #website;
		label: 'Website';
		priority: 340;
		beEditable;
		yourself
]

{ #category : #initialization }
PBComment >> initialize [
	super initialize.
	self publication: GRPlatform current magritteTimeStampClass now
]

{ #category : #testing }
PBComment >> isComment [
	^ true
]

{ #category : #accessing }
PBComment >> website [
	^ website
]

{ #category : #accessing }
PBComment >> website: aString [
	website := (aString isEmptyOrNil or: [ aString includesSubstring: '://' caseSensitive: true ])
		ifFalse: [ website := 'http://' , aString ]
		ifTrue: [ aString ]
]

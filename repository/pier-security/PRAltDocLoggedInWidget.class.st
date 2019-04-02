"
A PRLoginView is a widget that shows a different page when logged in.

Instance Variables
	alternate:		The document that is shown when logged in.
	default:		The document that is shown when not logged in.
	inherited:		<Object>
	specification:		<Object>

alternate
	- xxxxx

default
	- xxxxx

inherited
	- xxxxx

specification
	- xxxxx

"
Class {
	#name : #PRAltDocLoggedInWidget,
	#superclass : #PRWidget,
	#instVars : [
		'specification',
		'default',
		'inherited',
		'alternate'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #testing }
PRAltDocLoggedInWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRAltDocLoggedInWidget class >> label [
	^ 'AltDoc logged in'
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> alternate [
	^alternate ifNil: [ PRDocument new ]
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> alternate: aString [
	alternate := aString
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> alternateContents [
	"Answer a wiki string representation of the receiving document."
	
	^ self descriptionAlternate toString: (self readUsing: self descriptionAlternate)
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> alternateContents: aString [
	"Write the document using the description."
	
	self write: (aString
		ifNil: [ nil ]
		ifNotNil: [ self descriptionAlternate fromString: aString ]) using: self descriptionAlternate
]

{ #category : #accessing }
PRAltDocLoggedInWidget >> buildSpecification [
	^ self descriptionDefault
		accessor: (PRDocumentWidgetAccessor on: #documents key: self owner name);
		yourself
]

{ #category : #'accessing-descriptions' }
PRAltDocLoggedInWidget >> children [
	^ (PROutgoingReferences on: self document) embeddedComponents
		collect: [ :each | self context componentFor: each ]
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> contents [
	"Answer a wiki string representation of the receiving document."
	
	^ self descriptionDefault toString: (self readUsing: self descriptionDefault)
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> contents: aString [
	"Write the document using the description."
	self write: (aString
		ifNil: [ nil ]
		ifNotNil: [ self descriptionDefault fromString: aString ]) using: self descriptionDefault
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> default [
	^default ifNil: [ PRDocument new ]
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> default: aString [
	default := aString
]

{ #category : #'accessing-descriptions' }
PRAltDocLoggedInWidget >> descriptionAlternate [
	<magritteDescription>
	^ PRDocumentWidgetDescription new
		parameterName: 'alternate';
		accessor: #alternate;
		stringAccessor: #alternateContents;
		label: 'Alternate';
		priority: 130;
		yourself
]

{ #category : #'accessing-descriptions' }
PRAltDocLoggedInWidget >> descriptionDefault [
	<magritteDescription>
	^ PRDocumentWidgetDescription new
		parameterName: 'default';
		accessor: #default;
		stringAccessor: #contents;
		label: 'Default';
		priority: 120;
		yourself
]

{ #category : #'accessing-descriptions' }
PRAltDocLoggedInWidget >> descriptionInherited [
	<magritteDescription>
	^ MABooleanDescription new
		parameterName: 'inherited';
		accessor: #inherited;
		label: 'Inherited';
		default: false;
		priority: 110;
		beRequired;
		yourself
]

{ #category : #accessing }
PRAltDocLoggedInWidget >> document [
	self context isLoggedIn
		ifTrue: [ ^self alternate ].
	^self default
]

{ #category : #accessing }
PRAltDocLoggedInWidget >> documentFrom: aString [
	^self specification fromString: aString
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> inherited [
	^inherited
]

{ #category : #'accessing - properties' }
PRAltDocLoggedInWidget >> inherited: aBoolean [
	inherited := aBoolean
]

{ #category : #rendering }
PRAltDocLoggedInWidget >> renderContentOn: canvas [
	canvas rendererInstance withinContentDo: [ 
		canvas rendererInstance
			continue: self document
			in: self on: canvas ]
]

{ #category : #accessing }
PRAltDocLoggedInWidget >> specification [
	"Answer a description representing the receiving document."
	
	^ specification ifNil: [ specification := self buildSpecification ]
]

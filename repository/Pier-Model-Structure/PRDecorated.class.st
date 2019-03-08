"
I am an abstract decorated object. My decorations are subclasses of *PRDecoration*. I provide all the tools to add, remove, query and visit my decorations.
"
Class {
	#name : #PRDecorated,
	#superclass : #PRObject,
	#instVars : [
		'decorations'
	],
	#category : #'Pier-Model-Structure'
}

{ #category : #visiting }
PRDecorated >> acceptDecorated: aVisitor [
	self
		decorationsDo: [ :each | aVisitor visit: each ]
		ownerDo: [ :each | super acceptDecorated: aVisitor ]
]

{ #category : #adding }
PRDecorated >> addDecoration: aDecoration [
	"Add ==aDecoration== to the receiver. This message ensures that ==aDecoration== is only added once and that the decorations remain properly sorted."

	^ self
		addDecoration: aDecoration
		ifPresent: [ :value | PRDecorationError signal: 'Decoration is already part of receiver.' ]
]

{ #category : #adding }
PRDecorated >> addDecoration: aDecoration ifPresent: aBlock [
	"Add ==aDecoration== to the receiver. This message ensures that the decorations remain properly sorted and that there are no duplicates. In case ==aDecoration== is already within the receiver, the existing decoration is passed into ==aBlock==."

	| decoration |
	decoration := self decorations
		detect: [ :each | aDecoration = each ]
		ifNone: [ nil ].
	^ decoration isNil
		ifFalse: [ aBlock value: decoration ]
		ifTrue: [
			self setDecorations: ((decorations
				copyWith: (aDecoration
					setDecorated: self;
					yourself)) sort; yourself).
			aDecoration ]
]

{ #category : #querying }
PRDecorated >> decorationOfClass: aClass [
	"Answer the first decoration of ==aClass==, raise an error if none could be found."

	^ self
		decorationOfClass: aClass
		ifAbsent: [ PRDecorationError signal: 'Decoration not found.' ]
]

{ #category : #querying }
PRDecorated >> decorationOfClass: aClass ifAbsent: aBlock [
	"Answer the first decoration of ==aClass==, evaluate ==aBlock== if none could be found."

	^ self decorations
		detect: [ :each | aClass = each species ]
		ifNone: aBlock
]

{ #category : #accessing }
PRDecorated >> decorations [
	"Answer the sorted decorations of the receiver."

	^ decorations
]

{ #category : #enumerating }
PRDecorated >> decorationsDo: aBlock [
	"Evaluate ==aBlock== in the right order with each of the receiver's decorations as the argument."

	self decorations do: aBlock
]

{ #category : #enumerating }
PRDecorated >> decorationsDo: aBlock ownerDo: anOwnerBlock [
	"Evaluate ==aBlock== and ==anOwnerBlock== in the right order with each of the receiver's decorations and the receiver as the argument."

	self decorations do: [ :each |
		each priority negative
			ifTrue: [ aBlock value: each ] ].
	anOwnerBlock value: self.
	self decorations do: [ :each |
		each priority positive
			ifTrue: [ aBlock value: each ] ]
]

{ #category : #initialization }
PRDecorated >> initialize [
	super initialize.
	self setDecorations: #()
]

{ #category : #copying }
PRDecorated >> postCopy [
	super postCopy.
	self setDecorations: (self decorations collect: [ :each |
		each copy postCopyTo: self ])
]

{ #category : #removing }
PRDecorated >> removeDecoration: aDecoration [
	"Remove ==aDecoration== from the receiver, an error is raised if ==aDecoration== is not part of the receiver."

	^ self
		removeDecoration: aDecoration
		ifAbsent: [ PRDecorationError signal: 'Decoration is not part of receiver.' ]
]

{ #category : #removing }
PRDecorated >> removeDecoration: aDecoration ifAbsent: aBlock [
	"Remove ==aDecoration== from the receiver, ==aBlock== is evaluated if ==aDecoration== is not part of the receiver."

	| decoration |
	decoration := self decorations
		detect: [ :each | aDecoration = each ]
		ifNone: [ ^ aBlock value ].
	self setDecorations: (self decorations
		copyWithout: (decoration
			setDecorated: nil;
			yourself)).
	^ decoration
]

{ #category : #initialization }
PRDecorated >> setDecorations: anArray [
	decorations := anArray
]

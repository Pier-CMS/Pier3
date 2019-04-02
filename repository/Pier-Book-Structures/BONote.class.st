Class {
	#name : #BONote,
	#superclass : #PRStructure,
	#instVars : [
		'email',
		'note',
		'timestamp'
	],
	#category : #'Pier-Book-Structures'
}

{ #category : #testing }
BONote class >> canBeChildOf: aStructureClass [
	^ aStructureClass includesBehavior: BOPublication
]

{ #category : #testing }
BONote class >> canBeParentOf: aStructureClass [
	^ aStructureClass includesBehavior: self
]

{ #category : #testing }
BONote class >> isAbstract [
	^ false
]

{ #category : #accessing }
BONote class >> label [
	^ 'Book Note'
]

{ #category : #'accessing-dynamic' }
BONote >> author [
	^ self email copyUpTo: $@
]

{ #category : #accessing }
BONote >> confirmation [
	^ false
]

{ #category : #accessing }
BONote >> confirmation: aBoolean [
]

{ #category : #descriptions }
BONote >> descriptionConfirmation [
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

{ #category : #descriptions }
BONote >> descriptionDocument [
	<magritteDescription>
	^ PRDocumentDescription new
		accessor: #document;
		label: 'Contents';
		priority: 600;
		beReadonly;
		beEditable;
		beHidden;
		yourself
]

{ #category : #descriptions }
BONote >> descriptionEmail [
	<magritteDescription>
	^ MAStringDescription new
		addCondition: (MACondition selector: #matches: argument: '#*@#*.#*')
			labelled: 'Please make sure to enter a valid E-Mail';
		propertyAt: #public put: true;
		accessor: #email;
		label: 'E-Mail';
		priority: 500;
		beRequired;
		beEditable;
		yourself
]

{ #category : #descriptions }
BONote >> descriptionNote [
	<magritteDescription>
	^ MAMemoDescription new
		propertyAt: #public put: true;
		accessor: #note;
		priority: 550;
		label: 'Note';
		lineCount: 5;
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-dynamic' }
BONote >> document [
	^ PRDocument new
		add: (PRParagraph with: (PRText content: self author));
		add: (PRPreformatted withAll: (self note lines
			collect: [ :each | PRText content: each ]));
		yourself
]

{ #category : #accessing }
BONote >> email [
	^ email
]

{ #category : #accessing }
BONote >> email: aString [ 
	email := aString
]

{ #category : #initialization }
BONote >> initialize [
	super initialize.
	email := String new.
	note := String new.
	timestamp := GRPlatform current magritteTimeStampClass now
]

{ #category : #testing }
BONote >> isNote [
	^ true
]

{ #category : #accessing }
BONote >> note [
	^ note
]

{ #category : #accessing }
BONote >> note: aString [
	note := aString.
	note isNil ifTrue: [ ^ self ].
	note := ((note trimBoth
		copyReplaceAll: (String with: Character cr with: Character lf) with: (String with: Character cr)) 
		copyReplaceAll: (String with: Character lf) with: '')
		reject: [ :each | each asciiValue > 255 ]
]

{ #category : #'accessing-dynamic' }
BONote >> refLabel [
	^ 'Note'
]

{ #category : #'accessing-dynamic' }
BONote >> timestamp [
	^ timestamp
]

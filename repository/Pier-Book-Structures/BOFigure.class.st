Class {
	#name : #BOFigure,
	#superclass : #PRFile,
	#instVars : [
		'numberedTitle'
	],
	#category : #'Pier-Book-Structures'
}

{ #category : #testing }
BOFigure class >> canBeChildOf: aStructureClass [
	^ aStructureClass includesBehavior: BOPublication
]

{ #category : #testing }
BOFigure class >> canBeParentOf: aStructureClass [
	^ false
]

{ #category : #accessing }
BOFigure class >> label [
	^ 'Book Figure'
]

{ #category : #initialization }
BOFigure class >> resetFilesToFigures [
	"This used to be called on #initialize but caused problems on Gemstone
	I think it can probably be removed as it looks like a migration method
	from a previous version"
	PRFile allInstances do: [ :structure |
		(structure findAncestor: [ :each | each isPublication ]) notNil
			ifTrue: [ structure primitiveChangeClassTo: self basicNew ] ]
]

{ #category : #visiting }
BOFigure >> accept: aVisitor [
	aVisitor visitBOFigure: self
]

{ #category : #'accessing-description' }
BOFigure >> descriptionFile [
	<magritteDescription>
	^ super descriptionFile
		addCondition: (MACondition selector: #isImage) labelled: 'Select an image';
		yourself
]

{ #category : #descriptions }
BOFigure >> descriptionNumber [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'number';
		accessor: #number;
		beReadonly;
		yourself
]

{ #category : #descriptions }
BOFigure >> descriptionNumberedTitle [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Numbered title';
		accessor: #numberedTitle;
		label: 'Display';
		default: true;
		priority: 150;
		beEditable;
		yourself
]

{ #category : #accessing }
BOFigure >> index [
	"Answer the index number of this figure."

	| root siblings |
	self parent isNil
		ifTrue: [ ^ nil ].
	root := self parent
		findAncestor: [ :each | each isPublication and: [ each isBook ] ]
		ifAbsent: [ ^ nil ].
	siblings := root enumerator everything
		select: [ :each | each isFigure ].
	^ siblings indexOf: self ifAbsent: [ nil ]
]

{ #category : #testing }
BOFigure >> isFigure [
	^ true
]

{ #category : #testing }
BOFigure >> isNumberedTitle [
	^ self numberedTitle ifNil: [ true ]
]

{ #category : #accessing }
BOFigure >> label [
	^ 'Figure ' , self number
]

{ #category : #accessing }
BOFigure >> number [
	^ self index greaseString
]

{ #category : #'accessing-settings' }
BOFigure >> numberedTitle [
	^ numberedTitle
]

{ #category : #'accessing-settings' }
BOFigure >> numberedTitle: aBoolean [
	numberedTitle := aBoolean
]

{ #category : #accessing }
BOFigure >> refLabel [
	^ self label
]

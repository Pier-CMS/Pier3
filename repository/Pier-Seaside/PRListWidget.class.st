Class {
	#name : #PRListWidget,
	#superclass : #PRWidgetPropertyBase,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #accessing }
PRListWidget class >> groupLabel [
	^ 'Pier List'
]

{ #category : #accessing }
PRListWidget >> activeClass [
	^self readUsing: self descriptionActiveCssClass
]

{ #category : #accessing }
PRListWidget >> activeClass: aValue [
	^self write: aValue using: self descriptionActiveCssClass
]

{ #category : #'accessing-description' }
PRListWidget >> descriptionActiveCssClass [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The css class that is added to the items in the list when the item is active.';
		accessor: #activeClass;
		label: 'Active class';
		priority: 140;
		default: '';
		yourself
]

{ #category : #'accessing-description' }
PRListWidget >> descriptionItemCssClass [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The css class that is set to the items in the list.';
		accessor: #itemClass;
		label: 'Item class';
		priority: 120;
		default: '';
		yourself
]

{ #category : #'accessing-description' }
PRListWidget >> descriptionListCssClass [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'The css class that is set to the unordered list.';
		accessor: #listClass;
		label: 'List class';
		priority: 100;
		default: '';
		yourself
]

{ #category : #testing }
PRListWidget >> isActive: anObject [
	^ self selected = anObject
]

{ #category : #accessing }
PRListWidget >> itemClass [
	^self readUsing: self descriptionItemCssClass
]

{ #category : #accessing }
PRListWidget >> itemClass: aValue [
	^self write: aValue using: self descriptionItemCssClass
]

{ #category : #accessing }
PRListWidget >> items [
	"Answer the list items."

	self subclassResponsibility
]

{ #category : #accessing }
PRListWidget >> labelFor: anObject [
	^ anObject
]

{ #category : #accessing }
PRListWidget >> listClass [
	^self readUsing: self descriptionListCssClass
]

{ #category : #accessing }
PRListWidget >> listClass: aValue [
	^self write: aValue using: self descriptionListCssClass
]

{ #category : #rendering }
PRListWidget >> renderContentOn: html [
	| items |
	items := self items.
	items isEmpty
		ifFalse: [ self renderItems: items on: html ]
]

{ #category : #rendering }
PRListWidget >> renderItem: anObject on: html [
	html render: (self labelFor: anObject)
]

{ #category : #rendering }
PRListWidget >> renderItems: aCollection on: html [
	| listTag |
	listTag := html unorderedList.
	self listClass ifNotEmpty: [ listTag class: self listClass ].
	listTag with: [
		aCollection do: [ :each |
			self renderListItem: each on: html ] ]
]

{ #category : #rendering }
PRListWidget >> renderListItem: anItem on: html [
	| itemTag |
	itemTag := html listItem.
	self itemClass ifNotEmpty: [ itemTag class: self itemClass ].
	(self isActive: anItem) ifTrue: [ self activeClass ifNotEmpty: [ itemTag class: self activeClass ] ].
	itemTag with: [ self renderItem: anItem on: html ]
]

{ #category : #accessing }
PRListWidget >> selected [
	"Answer the selected list item."

	self subclassResponsibility
]

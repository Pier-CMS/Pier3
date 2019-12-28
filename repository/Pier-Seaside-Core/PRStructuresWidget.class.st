Class {
	#name : #PRStructuresWidget,
	#superclass : #PRListWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRStructuresWidget class >> defaultDropdownList [
	^ false
]

{ #category : #'accessing-defaults' }
PRStructuresWidget class >> defaultFilter [
	^ Array new
]

{ #category : #'accessing-defaults' }
PRStructuresWidget class >> defaultLabel [
	^ self defaultLabels first
]

{ #category : #'accessing-defaults' }
PRStructuresWidget class >> defaultLabels [
	^ #( menu title name )
]

{ #category : #'accessing-defaults' }
PRStructuresWidget class >> defaultMaxItems [
	^ nil
]

{ #category : #private }
PRStructuresWidget >> childrenOf: aStructure [
	^ (self context enumeratorFor: aStructure) reject: [ :each | self isFiltered: each ]
]

{ #category : #'accessing-description' }
PRStructuresWidget >> descriptionDropdownList [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Displays the structures as a dropdown list';
		default: self class defaultDropdownList;
		parameterName: 'dropdown-list';
		accessor: #dropdownList;
		label: 'Dropdown List';
		priority: 270;
		yourself
]

{ #category : #'accessing-description' }
PRStructuresWidget >> descriptionFilter [
	<magritteDescription>
	^ MAMultipleOptionDescription new
		default: PRStructure withAllConcreteClasses;
		options: PRStructure withAllConcreteClasses;
		comment: 'The types of structures not to display.';
		componentClass: MAMultiselectListComponent;
		reference: MAClassDescription new;
		default: self class defaultFilter;
		accessor: #filter;
		label: 'Filter';
		priority: 210;
		beSorted;
		yourself
]

{ #category : #'accessing-description' }
PRStructuresWidget >> descriptionLabel [
	<magritteDescription>
	^ MASingleOptionDescription new
		comment: 'The label to be used to name structures.';
		options: self class defaultLabels;
		default: self class defaultLabel;
		accessor: #label;
		label: 'Label';
		priority: 200;
		beRequired;
		beSorted;
		yourself
]

{ #category : #'accessing-description' }
PRStructuresWidget >> descriptionMaxItems [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The maximum number of items to be displayed.';
		default: self class defaultMaxItems;
		parameterName: 'max-items';
		accessor: #maxItems;
		label: 'Max Items';
		priority: 230;
		beInteger;
		min: 1;
		yourself
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> dropdownList [
	^ self readUsing: self descriptionDropdownList
]

{ #category : #accessing }
PRStructuresWidget >> dropdownList: aBoolean [ 
	self write: aBoolean using: self descriptionDropdownList
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> filter [
	^ self readUsing: self descriptionFilter
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> filter: filter [
	self write: filter using: self descriptionFilter
]

{ #category : #testing }
PRStructuresWidget >> isFiltered: aStructure [
	"Test if aStructure should be filtered from the widget:
	
	(1) Do not display if it is hidden from the menus.
	(2) Do not display if itself or one of the parents has an invalid view.
	(3) Do not display if it is one of the filtered classes."

	aStructure hideFromMenus
		ifTrue: [ ^ true ].
	aStructure parents do: [ :parent |
		(self context structure: parent) isValid
			ifFalse: [ ^ true ] ].
	^ self filter 
		anySatisfy: [ :each | aStructure class = each ]
]

{ #category : #testing }
PRStructuresWidget >> isPath: aStructure [
	"Test if aStructure is within the path of the currently active structure."
	
	^ (self isActive: aStructure) not and: [ self selected parents includes: aStructure ]
]

{ #category : #accessing }
PRStructuresWidget >> items [
	| items |
	items := self unfilteredItems asArray
		reject: [ :each | self isFiltered: each ].
	self maxItems isNil
		ifFalse: [ items := items first: (items size min: self maxItems) ].
	^ items
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> label [
	^ self readUsing: self descriptionLabel
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> label: label [
	self write: label using: self descriptionLabel
]

{ #category : #accessing }
PRStructuresWidget >> labelFor: aStructure [
	^ aStructure perform: self label
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> maxItems [
	^ self readUsing: self descriptionMaxItems
]

{ #category : #'accessing-settings' }
PRStructuresWidget >> maxItems: maxItems [
	self write: maxItems using: self descriptionMaxItems
]

{ #category : #rendering }
PRStructuresWidget >> renderContentOn: html [
	self dropdownList
		ifTrue: [ self renderSelect: self items on: html ]
		ifFalse: [ super renderContentOn: html ]
]

{ #category : #rendering }
PRStructuresWidget >> renderItem: aStructure on: html [
	html anchor
		class: 'path' if: (self isPath: aStructure);
		class: 'active' if: (self isActive: aStructure);
		goto: (self context structure: aStructure);
		with: [ html html: (self labelFor: aStructure) ]
]

{ #category : #rendering }
PRStructuresWidget >> renderSelect: aCollection on: html [
	html form: [
		html select
			list: aCollection;
			beSubmitOnChange;
			selected: self selected;
			labels: [ :each | self labelFor: each ];
			callback: [ :each | self context: (self context structure: each) ] ]
]

{ #category : #accessing }
PRStructuresWidget >> selected [
	^ self context structure
]

{ #category : #accessing }
PRStructuresWidget >> unfilteredItems [
	^ self subclassResponsibility
]

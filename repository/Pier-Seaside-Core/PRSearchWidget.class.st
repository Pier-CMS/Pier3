Class {
	#name : #PRSearchWidget,
	#superclass : #PRWidget,
	#instVars : [
		'query',
		'exampleText',
		'searchButton',
		'searchRoot'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #accessing }
PRSearchWidget class >> groupLabel [
	^ 'Pier Search'
]

{ #category : #testing }
PRSearchWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRSearchWidget class >> label [
	^ 'Search Field'
]

{ #category : #'accessing-descriptions' }
PRSearchWidget >> descriptionExampleText [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'example';
		accessor: #exampleText;
		label: 'Example';
		priority: 310;
		yourself
]

{ #category : #'accessing-description' }
PRSearchWidget >> descriptionSearchButton [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'search-button';
		accessor: #searchButton;
		label: 'Button';
		priority: 300;
		yourself
]

{ #category : #'accessing-description' }
PRSearchWidget >> descriptionSearchRoot [
	<magritteDescription>
	^ PRStructureDescription new
		parameterName: 'search-root';
		accessor: #searchRoot;
		label: 'Root';
		priority: 320;
		yourself
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> exampleText [
	^ exampleText
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> exampleText: aExampleText [
	exampleText := aExampleText
]

{ #category : #accessing }
PRSearchWidget >> query [
	^ query
]

{ #category : #accessing }
PRSearchWidget >> query: aString [
	query := aString.
	context := self context 
		structure: self context structure
		view: PRSearchView.
	context command viewComponent 
		root: self searchRoot;
		query: aString;
		hideForm;
		refresh.
	self context: context
]

{ #category : #rendering }
PRSearchWidget >> renderContentOn: html [
	html form class: 'search-widget'; with: [
		html textInput
			type: 'search';
			value: self query;
			attributeAt: 'placeholder' put: self exampleText;
			callback: [ :value | self query: value ].
		self searchButton isEmptyOrNil
			ifFalse: [ html submitButton: self searchButton ] ]
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> searchButton [
	^ searchButton
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> searchButton: aSearchButton [
	searchButton := aSearchButton
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> searchRoot [
	^ searchRoot
]

{ #category : #'accessing-dynamic' }
PRSearchWidget >> searchRoot: aSearchRoot [
	searchRoot := aSearchRoot
]

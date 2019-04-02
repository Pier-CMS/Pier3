Class {
	#name : #PRAjaxSearchWidget,
	#superclass : #PRStructuresWidget,
	#instVars : [
		'structure',
		'exampleText'
	],
	#category : #'Pier-JQuery-Widgets'
}

{ #category : #'accessing-defaults' }
PRAjaxSearchWidget class >> defaultMaxItems [
	^ 10
]

{ #category : #accessing }
PRAjaxSearchWidget class >> groupLabel [
	^ 'Pier Search'
]

{ #category : #testing }
PRAjaxSearchWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRAjaxSearchWidget class >> label [
	^ 'Search Field (jQuery)'
]

{ #category : #'accessing-description' }
PRAjaxSearchWidget >> descriptionDropdownList [
	<magritteDescription>
	^ nil
]

{ #category : #'accessing-description' }
PRAjaxSearchWidget >> descriptionExampleText [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #exampleText;
		default: 'Search';
		label: 'Example';
		priority: 400;
		yourself
]

{ #category : #'accessing-description' }
PRAjaxSearchWidget >> descriptionStructure [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: #structure;
		label: 'Search From';
		priority: 390;
		yourself
]

{ #category : #accessing }
PRAjaxSearchWidget >> dropdownList [
	^ false
]

{ #category : #'accessing-convenience' }
PRAjaxSearchWidget >> exampleText [
	^ exampleText
]

{ #category : #'accessing-convenience' }
PRAjaxSearchWidget >> exampleText: anExampleText [
	exampleText := anExampleText
]

{ #category : #rendering }
PRAjaxSearchWidget >> renderContentOn: html [
	html textInput
		script: (html jQuery this autocomplete
			search: [ :value | self structuresFor: value ]
			labels: [ :value | value menu ]
			callback: [ :value :script |
				script goto: ((self context
					structure: value) 
					urlOn: html) ]);
		script: (html jQuery this example: self exampleText class: 'PRAjaxSearchWidgetExampleTextCss')
]

{ #category : #'accessing-convenience' }
PRAjaxSearchWidget >> structure [
	"Answer the structure from where the widget should begin it's recursive search"
	^ structure ifNil: [ structure := self context root ]
]

{ #category : #'accessing-convenience' }
PRAjaxSearchWidget >> structure: aStructure [
	structure := aStructure
]

{ #category : #private }
PRAjaxSearchWidget >> structuresFor: aString [
	| matches |
	matches := (self structure fullTextSearch subString: aString)
		reject: [ :each | self isFiltered: each ].
	self maxItems isNil
		ifFalse: [ matches := matches first: (matches size min: self maxItems) ].
	^ matches sorted: [ :a :b | (self labelFor: a) <= (self labelFor: b) ]
]

{ #category : #updating }
PRAjaxSearchWidget >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.	 
			
	"assume that jQuery libraries are already loaded"
	anHtmlRoot javascript url: JQWidgetBoxDeploymentLibrary / #jqueryexampleminJs.
	anHtmlRoot stylesheet add: '.PRAjaxSearchWidgetExampleTextCss {color: gray;}'
]

Class {
	#name : #PUStructuresWidget,
	#superclass : #PUReportWidget,
	#instVars : [
		'query'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #testing }
PUStructuresWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUStructuresWidget class >> label [
	^ 'Structures'
]

{ #category : #private }
PUStructuresWidget >> buildReport [
	| component |
	component := super buildReport.
	component addColumn: (MAColumn new
		accessor: #title;
		label: 'Title';
		yourself).
	component addColumn: (MAColumn new
		renderer: [ :value :html | self renderStructure: value on: html ];
		formatter: [ :value | value absolutePath ];
		accessor: #yourself;
		label: 'Location';
		yourself).
	component addColumn: (MAColumn new
		accessor: #(class label);
		label: 'Kind';
		filter: true;
		yourself).
	component addColumn: (MAColumn new
		accessor: #(owner name);
		label: 'Owner';
		filter: true;
		yourself).
	component addColumn: (MAColumn new
		accessor: #(group name);
		label: 'Group';
		filter: true;
		yourself).
	^ component
]

{ #category : #accessing }
PUStructuresWidget >> query: aString [ 
	| tokens |
	(query := aString) isNil ifTrue: [ ^ self report rowFilter: nil ].
	tokens := aString findTokens: Character space.
	tokens isEmpty ifTrue: [ ^ self report rowFilter: nil ].
	self report rowFilter: [ :row | 
		| values string |
		values := row magritteDescription children
			collect: [ :description | description toString: (row readUsing: description) ].
		values isEmpty 
			ifTrue: [ false ]
			ifFalse: [ 
				string := values reduce: [ :a :b | a , (String with: Character cr) , b ].
				tokens allSatisfy: [ :token | 
					token first = $- 
						ifTrue: [ (string includesSubstring: token allButFirst caseSensitive: false) not ]
						ifFalse: [ string includesSubstring: token caseSensitive: false ] ] ] ]
]

{ #category : #rendering }
PUStructuresWidget >> renderContentOn: html [
	self renderFilterOn: html.
	super renderContentOn: html
]

{ #category : #rendering }
PUStructuresWidget >> renderFilterOn: html [
	html form class: 'magritte'; with: [
		html table: [ 
			html tableRow: [
				html tableHeading
					title: 'Separate different terms by spaces. To exclude terms prefix with a minus.';
					with: 'Search Query:'.
				html tableData: [
					html textInput
						value: query;
						callback: [ :value | self query: value ].
					html space; submitButton: 'Filter' ] ] ] ]
]

{ #category : #accessing }
PUStructuresWidget >> rows [
	^ (self context enumeratorFor: self context root) 
		everything contents
]

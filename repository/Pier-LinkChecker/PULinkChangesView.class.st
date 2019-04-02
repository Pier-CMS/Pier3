Class {
	#name : #PULinkChangesView,
	#superclass : #WAComponent,
	#instVars : [
		'changes'
	],
	#category : #'Pier-LinkChecker'
}

{ #category : #'instance creation' }
PULinkChangesView class >> on: aCollection [
	^ self new initializeOn: aCollection
]

{ #category : #actions }
PULinkChangesView >> apply: aChange [
	self inform: 'Not implemented, yet.'
]

{ #category : #accessing }
PULinkChangesView >> changes [
	^ changes
]

{ #category : #initialization }
PULinkChangesView >> initializeOn: aCollection [
	self initialize.
	changes := aCollection
]

{ #category : #rendering }
PULinkChangesView >> renderButtonsOn: html [
	html submitButton
		with: 'Refresh'.
	html submitButton
		callback: [ self answer ];
		with: 'Close'
]

{ #category : #rendering }
PULinkChangesView >> renderContentOn: html [
	html form: [
		self renderTableOn: html.
		self renderButtonsOn: html ]
]

{ #category : #rendering }
PULinkChangesView >> renderTableHeadOn: html [
	html tableHeading: 'Owner'.
	html tableHeading: 'Old'.
	html tableHeading: 'New'.
	html tableHeading: 'Status'.
	html tableHeading
]

{ #category : #rendering }
PULinkChangesView >> renderTableOn: html [
	changes isEmpty
		ifTrue: [ ^ html paragraph: 'No broken links detected.' ].
	html table: [
		html tableRow: [ self renderTableHeadOn: html ].
		changes keysAndValuesDo: [ :key :value |
			html tableRow
				class: 'even' if: key even;
				with: [ self renderTableRow: value on: html ] ] ]
]

{ #category : #rendering }
PULinkChangesView >> renderTableRow: aChange on: html [
	html tableData: [
		html anchor
			goto: (self context structure: aChange owner);
			with: aChange owner absolutePath ].
	html tableData: aChange sourceString.
	html tableData: [
		html textInput
			value: aChange targetString;
			style: 'background-color: ' , aChange status second;
			callback: [ :value | aChange targetString: value ] ].
	html tableData: aChange status first.
	html tableData: [ 
		html submitButton
			disabled: aChange isEnabled not;
			callback: [ self apply: aChange ];
			with: 'Apply' ]
]

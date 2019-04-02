Class {
	#name : #PUBrowseComponent,
	#superclass : #PRViewComponent,
	#instVars : [
		'permissions',
		'structure'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #testing }
PUBrowseComponent class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUBrowseComponent class >> label [
	^ 'Browse'
]

{ #category : #configuration }
PUBrowseComponent >> defaultPermissions [
	^ (Array streamContents: [ :stream |
		PRCommand allSubclasses do: [ :each |
			each isAbstract
				ifFalse: [ stream nextPutAll: each permissions ] ] ])
		asSortedCollection: [ :a :b | a label < b label ]
]

{ #category : #initialization }
PUBrowseComponent >> initialize [
	super initialize.
	permissions := self defaultPermissions
]

{ #category : #accessing }
PUBrowseComponent >> permissions [
	^ permissions
]

{ #category : #rendering }
PUBrowseComponent >> renderContentOn: html [
	self renderPathOn: html.
	self renderTableOn: html
]

{ #category : #rendering }
PUBrowseComponent >> renderPathOn: html [
	html div: [
		self structure parents do: [ :each |
			html text: '/ '.
			html anchor
				callback: [ self structure: each ];
				title: each title;
				with: each name.
			html text: ' ' ] ].
	html break
]

{ #category : #rendering }
PUBrowseComponent >> renderPermissions: aStructure permissions: aCollection on: html [
	| current short |
	current := self context structure: aStructure.
	self permissions do: [ :each |
		short := (aCollection includes: each)
			ifTrue: [ each label first asLowercase ]
			ifFalse: [ $- ].
		(each command isValidIn: current)
			ifFalse: [ 
				html span 
					title: each label; 
					with: short ]
			ifTrue: [
				html anchor
					goto: (self context
						structure: aStructure
						command: (each command new
							successAnswer: self context;
							cancelAnswer: self context;
							yourself));
					title: each label;
					with: short ] ]
]

{ #category : #rendering }
PUBrowseComponent >> renderTableHeadOn: html [
	html tableRow: [
		html tableHeading: 'name'.
		html tableHeading: 'type'.
		html tableHeading: 'owner mode'.
		html tableHeading: 'group mode'.
		html tableHeading: 'other mode'.
		html tableHeading: 'owner'.
		html tableHeading: 'group' ]
]

{ #category : #rendering }
PUBrowseComponent >> renderTableOn: html [
	html table: [
		html tableHead: [
			self renderTableHeadOn: html ].
		html tableBody: [
			self structure parent isNil
				ifFalse: [ self renderTableRow: self structure parent named: '..' on: html ].
			self renderTableRow: self structure named: '.' on: html.
			self structure enumerator do: [ :each |
				(each isValidCommand: each viewCommandClass in: (self context structure: structure))
					ifTrue: [ self renderTableRow: each named: each name on: html ] ] ] ]
]

{ #category : #rendering }
PUBrowseComponent >> renderTableRow: aStructure named: aString on: html [
	| security |
	security := aStructure securityDecoration.
	html tableRow attributeAt: 'title' put: aStructure title; with: [
		html tableData: [
			html anchor
				callback: [ self structure: aStructure ];
				title: aStructure title;
				with: aString ].
		html tableData: aStructure class label.
		html tableData: [
			self
				renderPermissions: aStructure
				permissions: security ownerPermissions
				on: html ].
		html tableData: [
			self
				renderPermissions: aStructure
				permissions:security groupPermissions
				on: html ].
		html tableData: [
			self
				renderPermissions: aStructure
				permissions: security otherPermissions
				on: html ].
		html tableData: (security owner isNil
			ifFalse: [ security owner name ]).
		html tableData: (security group isNil
			ifFalse: [ security group name ]) ]
]

{ #category : #accessing }
PUBrowseComponent >> structure [
	^ structure ifNil: [ structure := self context structure ]
]

{ #category : #accessing }
PUBrowseComponent >> structure: aStructure [
	structure := aStructure
]

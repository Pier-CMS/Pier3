Class {
	#name : #PULinksWidget,
	#superclass : #PUReportWidget,
	#category : #'Pier-LinkChecker'
}

{ #category : #testing }
PULinksWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PULinksWidget class >> label [
	^ 'Links'
]

{ #category : #private }
PULinksWidget >> buildReport [
	| component |
	component := super buildReport.
	component addColumn: (MAColumn new
		renderer: [ :value :html | self renderLink: value on: html ];
		formatter: [ :value | value reference ];
		accessor: #yourself;
		label: 'Link';
		yourself).
	component addColumn: (MAColumn new
		accessor: #(class label);
		label: 'Kind';
		filter: true;
		yourself).
	component addColumn: (MAColumn new
		renderer: [ :value :html | self renderStructure: value owner on: html ];
		formatter: [ :value | value absolutePath ];
		accessor: #owner;
		label: 'Owner';
		filter: true;
		yourself).
	component addColumn: (MAColumn new
		accessor: #isEmbedded;
		label: 'Embedded';
		filter: true;
		yourself).
	component addColumn: (MAColumn new
		accessor: #isBroken;
		label: 'Broken';
		filter: true;
		yourself).
	^ component
]

{ #category : #actions }
PULinksWidget >> check [
	"Checks the currently displayed links."
	
	| changes change |
	changes := OrderedCollection new.
	self report cache do: [ :link |
		change := PULinkChange on: link.
		change isValid
			ifFalse: [ changes add: change repair ] ].
	self 
		show: (PULinkChangesView on: changes)
		onAnswer: [ :answer | self refresh ]
]

{ #category : #rendering }
PULinksWidget >> renderButtonsOn: html [
	super renderButtonsOn: html.
	html submitButton
		callback: [ self check ];
		with: 'Check'
]

{ #category : #rendering }
PULinksWidget >> renderLink: aLink on: html [
	| document |
	(aLink isKindOf: PRValueLink)
		ifTrue: [ document := PRText content: aLink text ]
		ifFalse: [
			document := aLink copy.
			document setChildren: #(); parameters: #(); embedded: false.
			document add: (PRText content: aLink reference).
			document propertyAt: 'title' put: aLink text ].
	html rendererInstance
		continue: document
		in: self report on: html
]

{ #category : #accessing }
PULinksWidget >> rows [
	| links |
	links := OrderedCollection new: 1024.
	(self context enumeratorFor: self context root) everything do: [ :structure |
		structure outgoingReferences
			continue: [ :link | false ];
			do: [ :each | 
				each owner isNil 
					ifFalse: [ links addLast: each ] ] ].
	^ links
]

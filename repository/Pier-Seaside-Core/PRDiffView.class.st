Class {
	#name : #PRDiffView,
	#superclass : #PRHistoryView,
	#instVars : [
		'contexts',
		'sourceContext',
		'targetContext'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRDiffView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRDiffView class >> label [
	^ 'Diff'
]

{ #category : #private }
PRDiffView >> buildList [
	"Answer a list of all edit contexts in the receiver that are visible."

	^ ((self context kernel persistency historyFor: self context structure) 
		select: [ :each | self isVisible: each ])
		reverse
]

{ #category : #accessing }
PRDiffView >> children [
	^ #()
]

{ #category : #accessing }
PRDiffView >> contexts [
	^ contexts ifNil: [ contexts := self buildList ]
]

{ #category : #testing }
PRDiffView >> isVisible: aContext [
	^ aContext command isEdit and: [ super isVisible: aContext ]
]

{ #category : #private }
PRDiffView >> labelFor: aContext [
	^ String streamContents: [ :stream |
		stream print: aContext command date; space.
		stream print: aContext command time; space.
		(aContext respondsTo: #user)
			ifTrue: [ stream nextPut: $(; nextPutAll: aContext user name; nextPut: $) ] ]
]

{ #category : #rendering }
PRDiffView >> renderContentOn: html [
	self renderSelectorOn: html.
	self renderDiffOn: html
]

{ #category : #rendering }
PRDiffView >> renderDiffOn: html [
	| someContext sourceString targetString |
	(sourceContext isNil and: [ targetContext isNil ])
		ifTrue: [ ^ self ].
	someContext := sourceContext isNil
		ifTrue: [ targetContext ]
		ifFalse: [ sourceContext ].
	html table: [
		someContext command magritteDescription do: [ :desc |
			html tableRow: [
				html tableHeading: desc label.
				html tableData: [
					sourceString := sourceContext isNil
						ifFalse: [ desc toString: (sourceContext command readUsing: desc) ].
					targetString := targetContext isNil
						ifFalse: [ desc toString: (targetContext command readUsing: desc) ].
					html render: (PRWordDiffAlgorithm from: sourceString to: targetString) ] ] ] ]
]

{ #category : #rendering }
PRDiffView >> renderSelectorOn: html [
	html form: [
		html table: [
			html tableRow: [
				html tableHeading: 'Source'.
				html tableHeading: 'Target'.
				html tableHeading ].
			html tableRow: [
				html tableData: [
					html select
						list: self contexts;
						selected: self sourceContext;
						labels: [ :value | self labelFor: value ];
						callback: [ :value | sourceContext := value ] ].
				html tableData: [
					html select
						list: self contexts;
						selected: self targetContext;
						labels: [ :value | self labelFor: value ];
						callback: [ :value | targetContext := value ] ].
				html tableData: [
					html submitButton: 'update' ] ] ] ]
]

{ #category : #accessing }
PRDiffView >> sourceContext [
	^ sourceContext ifNil: [ sourceContext := self contexts at: 2 ifAbsent: [ nil ] ]
]

{ #category : #accessing }
PRDiffView >> targetContext [
	^ targetContext ifNil: [ targetContext := self contexts at: 1 ifAbsent: [ nil ] ]
]

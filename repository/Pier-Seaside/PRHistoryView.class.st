Class {
	#name : #PRHistoryView,
	#superclass : #PRViewComponent,
	#instVars : [
		'report'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #actions }
PRHistoryView >> apply: aContext [
	aContext command execute
]

{ #category : #private }
PRHistoryView >> buildDescription [
	^ self context magritteDescription
]

{ #category : #private }
PRHistoryView >> buildList [
	^ Array streamContents: [ :stream |
		self context kernel persistency reverseDo: [ :each | 
			(self isVisible: each)
				ifTrue: [ stream nextPut: each ] ] ]
]

{ #category : #private }
PRHistoryView >> buildReport [
	^ (MAReport rows: self buildList description: self buildDescription)
		sortEnabled: false;
		batchSize: 20;
		yourself
]

{ #category : #accessing }
PRHistoryView >> children [
	^ Array with: self report
]

{ #category : #testing }
PRHistoryView >> isVisible: aContext [
	^ (aContext structure parents includes: self context structure)
		and: [ (aContext isValidCommand: aContext structure viewCommandClass)
		and: [ aContext structure parents allSatisfy: [ :each | (self context structure: each) isValid ] ] ]
]

{ #category : #actions }
PRHistoryView >> open: aContext [
	(self context isValidCommand: aContext command class)
		ifFalse: [ self inform: 'Unable to open ' , aContext command label printString , ' in the current context.' ]
		ifTrue: [ self context: aContext ]
]

{ #category : #rendering }
PRHistoryView >> renderContentOn: html [
	html render: self report
]

{ #category : #accessing }
PRHistoryView >> report [
	^ report ifNil: [ report := self buildReport ]
]

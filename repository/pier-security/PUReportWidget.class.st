Class {
	#name : #PUReportWidget,
	#superclass : #PRWidget,
	#instVars : [
		'report'
	],
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PUReportWidget class >> groupLabel [
	^ 'Pier System'
]

{ #category : #private }
PUReportWidget >> buildReport [
	^ (MAReport rows: self rows)
		showFilter: true;
		batchSize: 25;
		yourself
]

{ #category : #accessing }
PUReportWidget >> children [
	^ Array with: self report
]

{ #category : #actions }
PUReportWidget >> export [
	self requestContext response
		document: self report export
			mimeType: 'application/excel'
			fileName: self context structure name , '.xls';
		respond
]

{ #category : #actions }
PUReportWidget >> refresh [
	self report rows: self rows
]

{ #category : #rendering }
PUReportWidget >> renderActionsOn: html [ 
	html form: [ self renderButtonsOn: html ]
]

{ #category : #rendering }
PUReportWidget >> renderButtonsOn: html [
	html submitButton
		callback: [ self refresh ];
		with: 'Refresh'.
	html submitButton
		callback: [ self export ];
		with: 'Export'
]

{ #category : #rendering }
PUReportWidget >> renderContentOn: html [
	self renderReportOn: html.
	self renderActionsOn: html
]

{ #category : #rendering }
PUReportWidget >> renderReportOn: html [
	html render: self report
]

{ #category : #rendering }
PUReportWidget >> renderStructure: aStructure on: html [
	html anchor
		goto: (self context structure: aStructure);
		with: aStructure absolutePath
]

{ #category : #accessing }
PUReportWidget >> report [
	^ report ifNil: [ report := self buildReport ]
]

{ #category : #accessing }
PUReportWidget >> rows [
	self subclassResponsibility
]

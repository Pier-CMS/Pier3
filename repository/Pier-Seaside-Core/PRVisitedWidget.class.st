Class {
	#name : #PRVisitedWidget,
	#superclass : #PRStructuresWidget,
	#instVars : [
		'structures'
	],
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #defaults }
PRVisitedWidget class >> defaultMaxItems [
	^ 10
]

{ #category : #testing }
PRVisitedWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRVisitedWidget class >> label [
	^ 'Visited Pages'
]

{ #category : #'accessing-description' }
PRVisitedWidget >> descriptionRemoveDuplicates [
	<magritteDescription>
	^ MABooleanDescription new
		comment: 'Avoid duplicates in the list';
		parameterName: 'remove-duplicates';
		accessor: #removeDuplicates;
		label: 'Remove Duplicates';
		default: true;
		priority: 260;
		yourself
]

{ #category : #initialization }
PRVisitedWidget >> initialize [
	super initialize.
	structures := OrderedCollection new
]

{ #category : #accessing }
PRVisitedWidget >> items [
	^ structures
]

{ #category : #events }
PRVisitedWidget >> onChangeContext: aContext [
	super onChangeContext: aContext.
	(structures isEmpty or: [ structures last ~= aContext structure ]) ifTrue: [
		(self isFiltered: aContext structure) ifFalse: [ 
			self removeDuplicates
				ifTrue: [ structures remove: aContext structure ifAbsent: [ ] ].
			structures addLast: aContext structure ] ].
	self maxItems isNil ifFalse: [
		[ self maxItems < structures size ]
			whileTrue: [ structures removeFirst ] ]
]

{ #category : #'accessing-settings' }
PRVisitedWidget >> removeDuplicates [
	^ self readUsing: self descriptionRemoveDuplicates
]

{ #category : #'accessing-settings' }
PRVisitedWidget >> removeDuplicates: removeDuplicates [
	self write: removeDuplicates using: self descriptionRemoveDuplicates
]

{ #category : #accessing }
PRVisitedWidget >> unfilteredItems [
	self shouldNotImplement
]

"
A PRToDoTaskTest is for testing the UI aspects - see #testDescription - this should help keep PRToDoView in synch with PRToDoTask. It is somewhat difficult to test PRScheduledTaskExamples because there is no kernel.

"
Class {
	#name : #PRToDoTaskTest,
	#superclass : #PRStructureTest,
	#category : #'Pier-Tests-Todo'
}

{ #category : #testing }
PRToDoTaskTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRToDoTaskTest >> actualClass [
	^ PRToDoTask
]

{ #category : #private }
PRToDoTaskTest >> childInstance [
	^ PRToDoTask named: 'child'
]

{ #category : #private }
PRToDoTaskTest >> folderInstance [
	^ PRToDo named: 'folder'
]

{ #category : #tests }
PRToDoTaskTest >> testAutomate [
	[ self child
		contents:
			'This is does have preformatted
= Transcript show: ''Test auotmated ran.''
'.
	self child automate.
	self
		assert: self folder scheduler isNotNil;
		assert: self folder scheduler taskCount equals: 1.
	self should: [ self child automate ] raise: Error.
	self child remove.
	self assert: self folder scheduler taskCount equals: 0 ]
		ensure: [ self folder scheduler ifNotNil: [ self folder scheduler stop ] ]
]

{ #category : #tests }
PRToDoTaskTest >> testComplete [
	self
		deny: self instance completed;
		assert: self folder totalPoints = 0.
	self instance complete.
	self
		assert: self instance completed;
		deny: self folder totalPoints = 0.
	self instance completed: false.
	self deny: self instance completed.
	self instance
		repeatingDuration: 1 day;
		due: GRPlatform current magritteTimeStampClass current - 1 day - 10 minutes.
	self instance complete.
	self
		deny: self instance completed;
		assert: self instance due asDate = Date tomorrow.
	self instance
		repeatingDuration: 7 days;
		due: GRPlatform current magritteTimeStampClass current - 6 days.
	self instance complete.
	self
		deny: self instance completed;
		assert: self instance due asDate = Date tomorrow
]

{ #category : #tests }
PRToDoTaskTest >> testDescription [
	"This confirms that the labels expected to be displayed are present.  Any time PRToDoTask descriptions are changed, PRToDoView>>buildDescription should also be checked.	"

	self
		assert:
			(self instance magritteDescription
				select: [ :description | #('Title' 'Due Date' 'Completed' 'Points') includes: description label ]) size = 4
]

{ #category : #tests }
PRToDoTaskTest >> testNameAsTitle [
	self assert: self child nameAsTitle isString.
	self child name: '2014-Aug-7'.
	self assert: self child nameAsTitle = '2014-Aug-7'.
	self child name: 'long-name'.
	self assert: self child nameAsTitle = 'Long Name'
]

{ #category : #tests }
PRToDoTaskTest >> testPreformattedText [
	self
		assert:
			((PRPreformattedTextSelector on: self child)
				start: self child document;
				text) isEmpty.
	self child
		contents: 'This is not preformatted ==text==, it is inline'.
	self
		assert:
			((PRPreformattedTextSelector on: self child)
				start: self child document;
				text) isEmpty.
	self child
		contents:
			'This is does have preformatted
= text
It should be able to find "text"'.
	self
		assert:
			((PRPreformattedTextSelector on: self child)
				start: self child document;
				text) equals: 'text'
]

{ #category : #tests }
PRToDoTaskTest >> testTimeChange [
	self assert: self instance displayDue > Time now.
	self folder timeZoneDifference:  -25 hours.
	self assert: self instance displayDue < Time now.

]

{ #category : #tests }
PRToDoTaskTest >> testUpdateDueDateToCurrent [
	self folder timeZoneDifference: -25 hours.
	self instance
		due: GRPlatform current magritteTimeStampClass now - 10 days;
		repeatingDuration: 2 days.
	self
		assert: GRPlatform current magritteTimeStampClass now - self instance displayDue > 8 days.
	self instance updateDueDateToCurrent.
	self
		assert: GRPlatform current magritteTimeStampClass now - self instance displayDue < 4 days;
		assert: self instance displayDue < GRPlatform current magritteTimeStampClass now
]

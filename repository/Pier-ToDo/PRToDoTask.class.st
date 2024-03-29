"
A PRToDoTask is a task in a ToDo List.

      Instance variables:
	due		<TimeStamp>	 - deadline for the task, uses lazy initialization so the parent's timeZoneDifference can be added.
	completed		<Boolean>	 - Whether the task is done or 	not
	repeatingDuration	<Duration>	- nil if the task is a one-timer, set to a duration if the task repeates
	points	<Integer>	 - Incentive

This does not yet support complicated scheduling, like the third Tuesday of each month.

When updating from an older version, it may be necessary to update the existing data:
	PRToDoTask allInstances do: [ :e | e points ifNil: [ e points: 1 ] ].
"
Class {
	#name : #PRToDoTask,
	#superclass : #PRCase,
	#instVars : [
		'due',
		'completed',
		'repeatingDuration',
		'points'
	],
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRToDoTask class >> canBeChildOf: aClass [
	^ aClass includesBehavior: PRToDo
]

{ #category : #testing }
PRToDoTask class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRToDoTask class >> label [
	^ 'Task'
]

{ #category : #visiting }
PRToDoTask >> accept: aVisitor [
	aVisitor visitToDoItem: self
]

{ #category : #actions }
PRToDoTask >> automate [

	"Turn this into a scheduled task based on the text being a block.  Syntax errors in the preformatted text show up in the image as popup windows."

	| hasDuplicate task block |
	hasDuplicate := false.
	self parent scheduler taskCount to: 1 by: -1 do: [ :index | 
		hasDuplicate := hasDuplicate or:
			                (self parent scheduler taskAt: index) description
			                = self title ].
	hasDuplicate ifTrue: [ 
		Error signal: 'Duplicate task names: ' , self title ].
	block := [ 
	         self class compiler
		         failBlock: [ 
			         'If there is an error in the page, then it is ignored.' ];
		         evaluate: ((PRPreformattedTextSelector on: self)
				          start: self document;
				          text) ].
	completed := true.
	task := self repeatingDuration isNil
		        ifTrue: [ self parent scheduler doOnce: block at: self due ]
		        ifFalse: [ 
			        self parent scheduler
				        do: block
				        at: self due
				        every: self repeatingDuration ].
	task description: self title.
	self parent scheduler start
]

{ #category : #private }
PRToDoTask >> complete [
	self completed
		ifFalse: [ self parent ifNotNil: [ self parent addToTotalPoints: self points ] ].
	self repeatingDuration ifNil: [ ^ completed := true ].
	[ self due: self due + self repeatingDuration.
	self due < GRPlatform current magritteTimeStampClass tomorrow ] whileTrue.
	^ self completed: false
]

{ #category : #accessing }
PRToDoTask >> completed [
	^ completed
]

{ #category : #accessing }
PRToDoTask >> completed: aBoolean [
	aBoolean
		ifTrue: [ self complete ]
		ifFalse: [ completed := aBoolean ]
]

{ #category : #actions }
PRToDoTask >> deautomate [
	"Remove the automation for this task"

	completed := true.
	self hideFromMenus: false.
	self parent scheduler
		removeTask:
			(self parent scheduler tasks
				detect: [ :task | task description = self title ]
				ifNone: [ ^ nil ])
]

{ #category : #'accessing-description' }
PRToDoTask >> descriptionCompleted [
	<magritteDescription>
	^ MABooleanDescription new
		checkboxLabel: 'Is Done';
		accessor: #completed;
		label: 'Completed';
		default: false;
		priority: 310;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRToDoTask >> descriptionDue [
	<magritteDescription>
	^ MADateAndTimeDescription new
		accessor: #displayDue;
		priority: 300;
		comment: 'When this task must be done by.';
		label: 'Due Date';
		beEditable;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PRToDoTask >> descriptionPoints [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #points;
		comment: 'The number of points awarded for completing this.';
		label: 'Points';
		parameterName: 'points';
		priority: 340;
		beRequired;
		beInteger;
		bePositive;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRToDoTask >> descriptionRepeatingDuration [
	<magritteDescription>
	^ MADurationDescription new
		accessor: #repeatingDuration;
		label: 'Repeat in (DD:hh:mm:ss)';
		priority: 320;
		comment: 'How long between task is done again.';
		beEditable;
		yourself
]

{ #category : #accessing }
PRToDoTask >> displayDue [
	^ self due + self parent timeZoneDifference 
]

{ #category : #accessing }
PRToDoTask >> displayDue: aTimeStamp [
	self due: aTimeStamp - (self parent isNil ifTrue: [0] ifFalse: [self parent timeZoneDifference])
]

{ #category : #accessing }
PRToDoTask >> due [
	due isNil
		ifTrue:
			[ self
				due:
					(self parent isNil
						ifTrue: [ GRPlatform current magritteTimeStampClass midnight - 1 minute ]
						ifFalse:
							[ GRPlatform current magritteTimeStampClass midnight - 1 minute
								- self parent timeZoneDifference ]) ].
	^ due
]

{ #category : #accessing }
PRToDoTask >> due: aDateAndTime [
	due := aDateAndTime
]

{ #category : #initialization }
PRToDoTask >> initialize [
	super initialize.
	self completed: false.
	self due: nil.
	self repeatingDuration: nil.
	self points: 1
]

{ #category : #testing }
PRToDoTask >> isRepeating [
	^ self completed not and: [ self repeatingDuration isNotNil ]
]

{ #category : #accessing }
PRToDoTask >> nameAsTitle [
	"Allow smart titles to be created, like changing: 
		do-this-task => Do This Task "

	| shouldCapitalize |
	(self name isEmpty or: [ self name startsWithDigit ])
		ifTrue: [ ^ self name ].
	^ String
		streamContents: [ :stream | 
			shouldCapitalize := true.
			name
				do: [ :c | 
					shouldCapitalize
						ifTrue: [ 
							shouldCapitalize := false.
							stream nextPut: c asUppercase ]
						ifFalse: [ 
							c = $-
								ifTrue: [ 
									stream nextPut: Character space.
									shouldCapitalize := true ]
								ifFalse: [ stream nextPut: c ] ] ] ]
]

{ #category : #accessing }
PRToDoTask >> points [
	^ points
]

{ #category : #accessing }
PRToDoTask >> points: anObject [
	points := anObject
]

{ #category : #actions }
PRToDoTask >> remove [
	self parent scheduler ifNotNil: [ self deautomate ].
	^ super remove
]

{ #category : #accessing }
PRToDoTask >> repeatingDuration [
	^ repeatingDuration
]

{ #category : #accessing }
PRToDoTask >> repeatingDuration: aDuration [
	repeatingDuration := aDuration ifNotNil: [ aDuration max: 1 second]
]

{ #category : #accessing }
PRToDoTask >> shortDueDate [
	"Need to use due instead of self due so the parent time is not added."
	^ self parent displayDateWithTimeZoneDifference: due
	
]

{ #category : #accessing }
PRToDoTask >> title [
	"Answer the title of the receiver, essentially the name but starting uppercase."

	^ title ifNil: [ title := self nameAsTitle ]
]

{ #category : #actions }
PRToDoTask >> updateDueDateToCurrent [
	"For repeating tasks, move the due date to as near as today without going over."

	| now nextDue |
	self isRepeating
		ifFalse: [ ^ self ].
	self displayDue > (now := GRPlatform current magritteTimeStampClass now)
		ifTrue: [ ^ self ].
	[ (nextDue := self displayDue + self repeatingDuration) > now ]
		whileFalse: [ self displayDue: nextDue ]
]

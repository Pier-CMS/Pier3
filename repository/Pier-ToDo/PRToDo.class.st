"
A PRToDo is a task list.  It allows customized todo lists to be created.

Instance Variables
	totalPoints:	<Integer>
	pointsName:	<String>
	scheduler:		<TaskScheduler>
	timeZoneDifference:		<Difference betwen local time and the users time>

Tasks to be done:
- Easier to view which are immediate, which are planned, which are done
- Replace the title with a link to the task - then the edit button is not needed.
- Add a way for tasks to be automated - such as finding all of the broken links or image links that have changed

Currently, re-occurring items do not have any indication that they are repeated - it may be a good idea to add this.  It would also be good to add a score tally.  Task classification may also help, but could also be a waste of time.

The scheduler is used for making automated tasks.
"
Class {
	#name : #PRToDo,
	#superclass : #PRStructure,
	#instVars : [
		'totalPoints',
		'pointsName',
		'scheduler',
		'timeZoneDifference',
		'smallGroupSize'
	],
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRToDo class >> canBeParentOf: aClass [
	^ aClass includesBehavior: PRToDoTask
]

{ #category : #testing }
PRToDo class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRToDo class >> label [
	^ 'ToDo'
]

{ #category : #visiting }
PRToDo >> accept: aVisitor [
	aVisitor visitToDo: self
]

{ #category : #accessing }
PRToDo >> addToTotalPoints: anInteger [
	self totalPoints: self totalPoints + anInteger
]

{ #category : #'accessing-description' }
PRToDo >> descriptionPointsName [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #pointsName;
		label: 'Name of Point System';
		priority: 310;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRToDo >> descriptionSmallGroupSize [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The number number of tasks to display on a page.';
		accessor: #smallGroupSize;
		label: 'Tasks displayed per page';
		priority: 340;
		beInteger;
		bePositive;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRToDo >> descriptionTimeZoneDifference [
	<magritteDescription>
	^ MADurationDescription new
		comment: 'The difference between the server time (' , Time now asString , ') and the users local time';
		accessor: #timeZoneDifference;
		label:
				'Difference between the server time ('
						, (String streamContents: [ :stream | Time now print24: false showSeconds: false on: stream ])
						, ') - 0 to use the same timezone';
		priority: 330;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRToDo >> descriptionTotalPoints [
	<magritteDescription>
	^ MANumberDescription new
		comment: 'The number of points achieved';
		accessor: #totalPoints;
		label: 'Points accrued so far';
		priority: 320;
		beInteger;
		beEditable;
		yourself
]

{ #category : #printing }
PRToDo >> displayDateWithTimeZoneDifference: aDateAndTime [
	| updatedDate dateString |
	aDateAndTime ifNil: [ ^ '' ].
	updatedDate := aDateAndTime + self timeZoneDifference.
	dateString := String
		streamContents: [ :aStream | (updatedDate + 15 minutes) asDate printOn: aStream format: #(3 2 1 $- 2 1 2) ].
	(dateString copyFrom: 1 to: 4) asInteger
		= (GRPlatform current magritteTimeStampClass now + self timeZoneDifference) year
		ifTrue: [ dateString := dateString copyFrom: 6 to: dateString size ].
	^ updatedDate asDateAndTime midnight + 1 day - updatedDate < 15 minutes
		ifTrue: [ dateString ]
		ifFalse: [ dateString , ' ' , updatedDate asTime printMinutes ]
]

{ #category : #testing }
PRToDo >> hasDocument [
	^ true
]

{ #category : #testing }
PRToDo >> isToDo [
	^ true
]

{ #category : #testing }
PRToDo >> isValidView: aComponentClass in: aContext [
	^ super viewComponentClass ~= aComponentClass
]

{ #category : #accessing }
PRToDo >> pointsName [
	pointsName ifNil: [ self pointsName: 'Total Points:' ].
	^ pointsName
]

{ #category : #accessing }
PRToDo >> pointsName: aString [
	pointsName := aString
]

{ #category : #accessing }
PRToDo >> scheduler [
	scheduler ifNil: [ self scheduler: TaskScheduler new start ].
	^ scheduler
]

{ #category : #accessing }
PRToDo >> scheduler: aTaskScheduler [
	scheduler := aTaskScheduler
]

{ #category : #accessing }
PRToDo >> smallGroupSize [
	smallGroupSize isNil
		ifTrue: [ self smallGroupSize: 10 ].
	^ smallGroupSize
]

{ #category : #accessing }
PRToDo >> smallGroupSize: aNumber [
	smallGroupSize := aNumber
]

{ #category : #accessing }
PRToDo >> tasks [
	^ self childrenDecoration children
		reject: [ :task | task hideFromMenus ]
]

{ #category : #accessing }
PRToDo >> tasksDone [
	^ self tasks select: [ :item | item completed ]
]

{ #category : #accessing }
PRToDo >> tasksDue [
	^ (self tasks reject: [ :item | item completed ]) sorted: [ :a :b | a due < b due ]
]

{ #category : #accessing }
PRToDo >> tasksUnDoneAsGroups [
	"Return a collection of the tasks that are not yet complete, grouped for optimal display (not too many in a group, not too many groups)."

	| tasks numberOfGroups results previousDisplayedDate lastDisplayDate |
	tasks := self tasksDue.
	tasks size <= self smallGroupSize
		ifTrue: [ ^ Array with: 'Tasks to be done' -> tasks ].
	previousDisplayedDate := tasks first shortDueDate.
	numberOfGroups := (tasks size / self smallGroupSize) ceiling.
	results := OrderedCollection new.
	1 to: numberOfGroups - 1 do: [ :index | 
		| pageOfTasks |
		pageOfTasks := tasks
			copyFrom: (index - 1) * self smallGroupSize + 1
			to: index * self smallGroupSize.
		lastDisplayDate := pageOfTasks last shortDueDate.
		lastDisplayDate = (previousDisplayedDate copyUpTo: $ )
			ifTrue: [ lastDisplayDate := lastDisplayDate , ' '
					, pageOfTasks last displayDue asTime printMinutes ].
		results add: ('Tasks to be done before ' , lastDisplayDate) -> pageOfTasks.
		previousDisplayedDate := lastDisplayDate ].
	results
		add:
			('Tasks to be done after ' , lastDisplayDate)
				->
					(tasks
						copyFrom: (numberOfGroups - 1) * self smallGroupSize + 1
						to: (numberOfGroups * self smallGroupSize min: tasks size)).
	^ results
]

{ #category : #accessing }
PRToDo >> timeZoneDifference [
	timeZoneDifference ifNil: [self timeZoneDifference: 0 seconds].
	^ timeZoneDifference
]

{ #category : #accessing }
PRToDo >> timeZoneDifference: aDuration [
	timeZoneDifference := aDuration
]

{ #category : #accessing }
PRToDo >> totalPoints [
	totalPoints ifNil: [ self totalPoints: 0 ].
	^ totalPoints
]

{ #category : #accessing }
PRToDo >> totalPoints: anInteger [
	totalPoints := anInteger
]

{ #category : #configuration }
PRToDo >> viewComponentClass [
	^ PRToDoView
]

Class {
	#name : #PRToDoTest,
	#superclass : #PRStructureTest,
	#category : #'Pier-Tests-Todo'
}

{ #category : #testing }
PRToDoTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRToDoTest >> actualClass [
	^ PRToDo
]

{ #category : #tests }
PRToDoTest >> testAdding [
	self
		assert: (self instance canBeParentOf: PRToDoTask new);
		deny: (self instance canBeParentOf: PRPage new).
	self
		assert: (self instance canBeChildOf: PRPage new)
]

{ #category : #tests }
PRToDoTest >> testDisplayDate [
	self
		assert: (self instance displayDateWithTimeZoneDifference: nil) isEmpty;
		deny: (self instance displayDateWithTimeZoneDifference: DateAndTime now) isEmpty

]

{ #category : #tests }
PRToDoTest >> testDisplayDateWithTimeZoneDifference [
	self instance timeZoneDifference: 12 hours.
	self
		deny: ((self instance displayDateWithTimeZoneDifference: DateAndTime today noon - 1 minute) includes: $:)
]

{ #category : #tests }
PRToDoTest >> testIsToDo [
	self assert: self instance isToDo
]

{ #category : #tests }
PRToDoTest >> testTasks [
	self assert: self instance tasks isEmpty.
	self instance
		addChild:
			(PRToDoTask new
				name: 'task';
				due: GRPlatform current magritteTimeStampClass yesterday).
	self assert: self instance tasks size = 1
]

{ #category : #tests }
PRToDoTest >> testTasksDone [
	| task |
	self assert: self instance tasksDone isEmpty.
	self instance
		addChild:
			(task := PRToDoTask new
				name: 'task1';
				due: GRPlatform current magritteTimeStampClass yesterday).
	self assert: self instance tasksDone isEmpty.
	task complete.
	self assert: self instance tasksDone size = 1
]

{ #category : #tests }
PRToDoTest >> testTasksDue [
	| task |
	self assert: self instance tasksDue isEmpty.
	self instance
		addChild:
			(task := PRToDoTask new
				name: 'task1';
				due: GRPlatform current magritteTimeStampClass yesterday).
	self assert: self instance tasksDue size = 1.
	task complete.
	self assert: self instance tasksDue isEmpty
]

{ #category : #tests }
PRToDoTest >> testTasksUnDoneAsGroups [
	self
		assert: self instance tasksUnDoneAsGroups size = 1;
		assert: self instance tasksUnDoneAsGroups anyOne value isEmpty.
	1 to: self instance smallGroupSize do: [ :index | 
		self instance
			addChild:
				(PRToDoTask new
					name: 'task' , index asString;
					due: GRPlatform current magritteTimeStampClass yesterday + index minutes) ].
	self assert: self instance tasksUnDoneAsGroups anyOne value size = self instance smallGroupSize.
	1 to: self instance smallGroupSize do: [ :index | 
		self instance
			addChild:
				(PRToDoTask new
					name: 'new-task' , index asString;
					due: GRPlatform current magritteTimeStampClass tomorrow + index minutes) ].
	self
		assert: self instance tasksUnDoneAsGroups size = 2;
		assert: self instance tasksUnDoneAsGroups first value size = self instance smallGroupSize;
		assert: self instance tasksUnDoneAsGroups last value size = self instance smallGroupSize.
	self instance
		addChild:
			(PRToDoTask new
				name: 'one-more-task';
				due: GRPlatform current magritteTimeStampClass tomorrow + 1 hour).
	self
		assert: self instance tasksUnDoneAsGroups size = 3;
		assert: self instance tasksUnDoneAsGroups first value size = self instance smallGroupSize;
		assert: self instance tasksUnDoneAsGroups second value size = self instance smallGroupSize;
		assert: self instance tasksUnDoneAsGroups last value size = 1
]

{ #category : #tests }
PRToDoTest >> testTotalPoints [
	self assert: self instance totalPoints = 0.
	self instance addToTotalPoints: 1.
	self assert: self instance totalPoints = 1.
]

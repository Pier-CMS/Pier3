"
I represent a workout as a set of exercises performed on a specific date.

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	date:		<Object>
	exercies:		<Object>


    Implementation Points
"
Class {
	#name : #PRWorkout,
	#superclass : #Object,
	#instVars : [
		'date',
		'exercises'
	],
	#category : #'Pier-Workout'
}

{ #category : #accessing }
PRWorkout >> addExerciseEntries: aCollectionOfExerciseEntries [
	exercises addAll: aCollectionOfExerciseEntries
]

{ #category : #accessing }
PRWorkout >> addExerciseEntry: anExerciseEntry [
	exercises add: anExerciseEntry
]

{ #category : #accessing }
PRWorkout >> addFirstExerciseEntry: anExerciseEntry [
	"Necessary for testing and importing data."
	exercises addFirst: anExerciseEntry
]

{ #category : #accessing }
PRWorkout >> addLastExerciseEntry: anExerciseEntry [
	exercises addLast: anExerciseEntry
]

{ #category : #accessing }
PRWorkout >> addWorkout: anotherWorkout [
	anotherWorkout
		exercisesWithDateDo: [ :exerciseEntry :aDate | self addExerciseEntry: exerciseEntry ]
]

{ #category : #action }
PRWorkout >> cleanRecommendedWorkoutForEntry: aPRExerciseEntry [
	exercises withIndexDo: [ :e :index | 
		e exercise = aPRExerciseEntry exercise
			ifTrue: [ ^ exercises removeFirst: index ] ]
]

{ #category : #accessing }
PRWorkout >> columnNames [
	^ self exercises
		inject: #()
		into: [ :array :exercise | array union: exercise columnNames ]
]

{ #category : #testing }
PRWorkout >> containsAnyExerciseOf: anotherWorkout [
	^ self exercises anySatisfy: [ :entry | anotherWorkout containsExercise: entry exercise ]
]

{ #category : #testing }
PRWorkout >> containsExercise: aPRExercise [
	^ self exercises contains: [ :entry | entry exercise = aPRExercise ]
]

{ #category : #accessing }
PRWorkout >> date [
	^ date
]

{ #category : #accessing }
PRWorkout >> date: aDate [
	date := aDate
]

{ #category : #descriptions }
PRWorkout >> descriptionDate [
	<magritteDescription>
	^ MADateDescription new
		accessor: #date;
		parameterName: 'date';
		priority: 300;
		label: 'Date';
		yourself
]

{ #category : #accessing }
PRWorkout >> exercises [
	^ exercises copy
]

{ #category : #accessing }
PRWorkout >> exercises: aCollection [
	exercises := aCollection
]

{ #category : #accessing }
PRWorkout >> exercisesEntriesOf: anExercise [
	^ exercises select: [ :entry | entry exercise = anExercise ]
]

{ #category : #accessing }
PRWorkout >> exercisesThatDontMatch: collectionOfExercises withDateDo: anExerciseDateBlock [
	exercises
		reverseDo: [ :e | 
			(collectionOfExercises includes: e exercise)
				ifFalse: [ anExerciseDateBlock value: e value: self date ] ]
]

{ #category : #accessing }
PRWorkout >> exercisesThatMatch: collectionOfExercises withDateDo: anExerciseDateBlock [
	exercises
		reverseDo: [ :e | 
			(collectionOfExercises includes: e exercise)
				ifTrue: [ anExerciseDateBlock value: e value: self date ] ]
]

{ #category : #accessing }
PRWorkout >> exercisesWithDateDo: anExerciseDateBlock [
	exercises reverseDo: [ :e | anExerciseDateBlock value: e value: self date ]
]

{ #category : #action }
PRWorkout >> increaseWeightForMatches: anExerciseEntry [
	1 to: exercises size
		do: [ :index | | e |
			e := exercises at: index. 
			e exercise = anExerciseEntry exercise
				ifTrue: [ exercises at: index put: (e increaseWeightToAtLeast: anExerciseEntry weight) ] ]
]

{ #category : #initialization }
PRWorkout >> initialize [
	super initialize.
	self date: Date today.
	self exercises: OrderedCollection new
]

{ #category : #testing }
PRWorkout >> isEmpty [
	^ exercises isEmpty
]

{ #category : #testing }
PRWorkout >> isWorkout [
	^ true
]

{ #category : #accessing }
PRWorkout >> numberOfSets [
	^ exercises size
]

{ #category : #accessing }
PRWorkout >> numberOfSetsOf: anExercise [
	^ exercises count: [ :anEntry | anEntry exercise = anExercise ]
]

{ #category : #printing }
PRWorkout >> printOn: aStream [
	aStream
		nextPutAll: (self exercises size) asString;
		nextPutAll: ' sets on ';
		nextPutAll: self date printString
]

{ #category : #accessing }
PRWorkout >> removeExerciseEntry: anExerciseEntry [
	^ exercises remove: anExerciseEntry ifAbsent: [ nil ]
]

{ #category : #accessing }
PRWorkout >> setOfExercises [
	^ (exercises collect: [ :e | e exercise ]) asSet
]

{ #category : #action }
PRWorkout >> withExerciseFirst: anExercise [
	| entries |
	entries := OrderedCollection new: self numberOfSets.
	entries addAll: (self exercisesEntriesOf: anExercise).
	entries addAll: (exercises reject: [ :entry | entry exercise = anExercise ]).
	^ self class new
		date: self date;
		exercises: entries;
		yourself
]

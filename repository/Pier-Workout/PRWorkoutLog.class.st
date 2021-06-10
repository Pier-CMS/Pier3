"
I represent a collection of workouts displayed in Pier.  The main purpose is to display progress while data entry.  I'm aware of the current date compared to the dates  of the workouts, and the exercises in the workout.

recommendedEntries is a list of what I recommend to do, this is private.  Recommendations always increase weight, the number of reps may decrease.

This uses timeZoneDifference in the opposite manner of PRToDo - It stores the workouts with the user's timezone, and displays them as such.  The ToDo app stores DateAndTimes for each task with the server time, and displays them on the users time.

For the recommended workout, a PRWorkout replaced an ordered collection of exercises so it would have the date of the recommendation (recommendations from yesterday aren't that useful).  It may be necessary to use the TZD like:
  (DateAndTime now - self timeZoneDifference) asDate
but testing is required to figure out if its needed.

An example of conversion code is 

| wos wo n exercise |
wos := OrderedCollection new.
wo := nil.
n := ''.
exercise := nil.
'|2016-Mar-13|Dumbbell Incline Bench|65|4
| | |60|11
| |Cable Tricep Overhead Extensions|145|5
| | |140|7
|2016-Mar-9|Dumbbell Flye|50|12
| | |47.5|14
| | |45|13
| |Back Squats|180|9
| | |160|7
| | |100|12' linesDo: [ :str || substrings |
	(substrings := str substrings: '|') second size > 2 ifTrue: [ n := substrings second].
	substrings first size > 3 ifTrue: [ 
		wo ifNotNil: [ wos add: wo ].
		wo := PRWorkout new.
		wo date: substrings first asDate ].
	exercise := PRExercise name: n weightUnits: 'lb' details: ''.
	(substrings size > 4 and: [exercise details isEmpty]) ifTrue: [ exercise details: substrings fifth ].
	wo addExerciseEntry: (PRExerciseEntry newOf: exercise weight: substrings third trim times: substrings fourth trim) ].
wos add: wo.
wos reverseDo: [ :e | self addWorkout: e ].

TODO:  Need to find a way to make the Pier importer work with workouts - not being exported properly.

Maybe a simple-minded backup would be better - inspect the below and import the workouts:

PRWorkoutLog allInstances detect: [ :e | e title = 'Weight-lifting' ].

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
	workouts:		<OrderedCollection of PRWorkout>
	recommendedEntries:		<PRWorkout>
	timeZoneDifference:	<Duration>
	
    Implementation Points
"
Class {
	#name : #PRWorkoutLog,
	#superclass : #PRStructure,
	#instVars : [
		'workouts',
		'recommendedEntries',
		'timeZoneDifference'
	],
	#category : #'Pier-Workout'
}

{ #category : #testing }
PRWorkoutLog class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRWorkoutLog class >> label [
	^ 'Workout Log'
]

{ #category : #actions }
PRWorkoutLog class >> workoutsBasedOnString: aString [
	| workouts aWorkout n exercise |
	workouts := OrderedCollection new.
	aWorkout := nil.
	n := ''.
	exercise := nil.
	aString
		linesDo: [ :str | 
			| substrings |
			(substrings := str trim substrings: '|') isEmpty
				ifFalse: [ substrings second trim size > 2
						ifTrue: [ n := substrings second ].
					substrings first trim size > 3
						ifTrue: [ aWorkout ifNotNil: [ workouts add: aWorkout ].
							aWorkout := PRWorkout new.
							aWorkout date: substrings first asDate ].
					exercise := PRExercise name: n weightUnits: 'lb' details: ''.
					(substrings size > 4 and: [ exercise details isEmpty ])
						ifTrue: [ exercise details: substrings fifth ].
					aWorkout
						addFirstExerciseEntry:
							(PRExerciseEntry
								newOf: exercise
								weight: substrings third trim
								times: substrings fourth trim) ] ].
	workouts add: aWorkout.
	^ workouts reverse
]

{ #category : #accessing }
PRWorkoutLog >> addExerciseEntry: anExerciseEntry [
	(self workouts isEmpty or: [ self isWorkoutInProgress not ])
		ifTrue: [ self
				setRecommendedWorkout: (self lastWorkoutFor: anExerciseEntry exercise).
			self
				addWorkout:
					(PRWorkout new
						addExerciseEntry: anExerciseEntry;
						date: (DateAndTime now - self timeZoneDifference) asDate;
						yourself) ]
		ifFalse: [ workouts last addExerciseEntry: anExerciseEntry ].
	self updateRecomendationsForLast.
	self cleanRecommendedEntry: anExerciseEntry
]

{ #category : #accessing }
PRWorkoutLog >> addWorkout: aPRWorkout [
	workouts add: aPRWorkout.
	self isWorkoutInProgress ifTrue: [ self updateRecommendedEntries  ]
]

{ #category : #accessing }
PRWorkoutLog >> allExercises [
	| set |
	set := Set new.
	self exercisesWithDateDo: [ :e :ignore | set add: e exercise ].
	^ set
]

{ #category : #private }
PRWorkoutLog >> cleanRecommendedEntry: aPRExerciseEntry [
	"Clean upto the first recommendation that matches"

	recommendedEntries cleanRecommendedWorkoutForEntry: aPRExerciseEntry.
	recommendedEntries isEmpty
		ifTrue: [ self updateRecommendedEntries ]
]

{ #category : #accessing }
PRWorkoutLog >> columnNames [
	^ self workouts inject: #() into: [ :array :workout | array union: workout columnNames ]
]

{ #category : #'for testing' }
PRWorkoutLog >> dayPassesForTesting [
	recommendedEntries date: (recommendedEntries date subtractDays: 1)
]

{ #category : #accessing }
PRWorkoutLog >> defaultExerciseEntry [
	^ PRExerciseEntry
		newOf:
			(PRExercise
				name: 'Bench Press'
				weightUnits: 'kg'
				details: 'Flat bench with bar')
		weight: 100
		times: 12
]

{ #category : #'accessing-description' }
PRWorkoutLog >> descriptionTimeZoneDifference [
	<magritteDescription>
	^ MADurationDescription new
		parameterName: 'timeZoneDifference';
		accessor: #timeZoneDifference;
		priority: 200;
		label:
			'Difference between the server time ('
				,
					(String
						streamContents: [ :stream | Time now print24: false showSeconds: false on: stream ])
				, ') and your local time';
		beRequired;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRWorkoutLog >> descriptionWorkouts [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #workouts;
		label: 'Workouts';
		priority: 300;
		beOrdered;
		yourself
]

{ #category : #actions }
PRWorkoutLog >> exercisesBasedOnRecommendationsWithDateDo: anExerciseDateBlock [
	| recommendedExercises |
	recommendedEntries isEmpty
		ifTrue: [ recommendedExercises := Set new ]
		ifFalse: [ recommendedExercises := recommendedEntries setOfExercises.
			recommendedExercises add: self lastExerciseEntry exercise ].
	workouts reverseDo: [ :w | w exercisesThatMatch: recommendedExercises withDateDo: anExerciseDateBlock ].
	workouts reverseDo: [ :w | w exercisesThatDontMatch: recommendedExercises withDateDo: anExerciseDateBlock ]
]

{ #category : #actions }
PRWorkoutLog >> exercisesWithDateDo: anExerciseDateBlock [
	workouts reverseDo: [ :w | w exercisesWithDateDo: anExerciseDateBlock ]
]

{ #category : #accessing }
PRWorkoutLog >> furthestReasonableExerciseEntry [
	| furthest lookedAt foundInCurrent |
	workouts isEmpty
		ifTrue: [ ^ self defaultExerciseEntry ].
	furthest := OrderedCollection new.
	((workouts size / 2) ceiling max: workouts size - 31) to: workouts size do: [ :index | 
		lookedAt := Set new.
		foundInCurrent := Set new.
		(workouts at: index)
			exercisesWithDateDo: [ :entry :ignore | 
				(foundInCurrent includes: entry exercise)
					ifFalse: [ foundInCurrent add: entry exercise.
						lookedAt add: entry ] ].
		furthest removeAllSuchThat: [ :entry | foundInCurrent includes: entry exercise ].
		furthest addAll: lookedAt ].
	^ furthest first copy
]

{ #category : #initialization }
PRWorkoutLog >> initialize [
	super initialize.
	workouts := OrderedCollection new.
	recommendedEntries := PRWorkout new
]

{ #category : #testing }
PRWorkoutLog >> isNewRecomendation [
	^ recommendedEntries isEmpty
]

{ #category : #testing }
PRWorkoutLog >> isSingleSetExercise: anExercise [
	"There may be once or twice that this exercise was only done more than once, but generally it is a single shot"
	^ ((self workouts collect: [ :wo | wo numberOfSetsOf: anExercise ])
		reject: [ :count | count = 0 ]) average < 1.1
]

{ #category : #testing }
PRWorkoutLog >> isWorkoutInProgress [
	^ self workouts last date yyyymmdd
		= (DateAndTime now - self timeZoneDifference) asDate yyyymmdd
]

{ #category : #accessing }
PRWorkoutLog >> lastEntriesFor: anExercise [
	"Return the latest exercise entries of anExercise"

	workouts
		reverseDo: [ :workout | 
			(workout containsExercise: anExercise)
				ifTrue: [ ^ workout exercisesEntriesOf: anExercise ] ].
	^ #()
]

{ #category : #accessing }
PRWorkoutLog >> lastExerciseEntry [
	^ self workouts last exercises last
]

{ #category : #accessing }
PRWorkoutLog >> lastWorkoutFor: anExercise [
	"Return a workout that has the latest exercises that were in a workout of anExercise"

	| viewedExercises newWorkout |
	workouts size to: 1 by: -1 do: [ :index | 
		| w |
		w := workouts at: index.
		(w date yyyymmdd ~= (DateAndTime now - self timeZoneDifference) asDate yyyymmdd
			and: [ w containsExercise: anExercise ])
			ifTrue: [ viewedExercises := Set with: anExercise.
				newWorkout := PRWorkout new.
				newWorkout addExerciseEntries: (w exercisesEntriesOf: anExercise).
				w exercises
					do: [ :entry | 
						(viewedExercises includes: entry exercise)
							ifFalse: [ viewedExercises add: entry exercise.
								newWorkout addExerciseEntries: (self lastEntriesFor: entry exercise) ] ].
				^ newWorkout ] ].
	^ nil
]

{ #category : #actions }
PRWorkoutLog >> mergeWorkouts [
	"Combine all workouts that have the same date"

	| mergeIndices doOnce |
	mergeIndices := OrderedCollection new.
	workouts size - 1 to: 1 by: -1 do: [ :smallerIndex | 
		doOnce := true.
		smallerIndex + 1 to: workouts size do: [ :largerIndex | 
			(doOnce
				and: [ (workouts at: smallerIndex) date yyyymmdd = (workouts at: largerIndex) date yyyymmdd ])
				ifTrue: [ doOnce := false.
					mergeIndices add: smallerIndex @ largerIndex ] ] ].
	mergeIndices
		do: [ :smallerAtLarger | 
			(workouts at: smallerAtLarger x) addWorkout: (workouts at: smallerAtLarger y).
			workouts removeAt: smallerAtLarger y ]
]

{ #category : #actions }
PRWorkoutLog >> nextExerciseEntry [
	"Determine what the user should do next based on time and what has been done"

	recommendedEntries date = Date today
		ifFalse: [ recommendedEntries := PRWorkout new ].
	recommendedEntries isEmpty
		ifTrue: [ ^ self furthestReasonableExerciseEntry ]
		ifFalse: [ ^ recommendedEntries exercises first ]
]

{ #category : #accessing }
PRWorkoutLog >> numberOfSets [
	^ self workouts sum: #numberOfSets
]

{ #category : #accessing }
PRWorkoutLog >> removeExerciseEntry: anExerciseEntry [
	self workouts
		do:
			[ :workout | 
			workout removeExerciseEntry: anExerciseEntry.
			workout exercises isEmpty
				ifTrue: [ ^ workouts remove: workout ] ]
]

{ #category : #private }
PRWorkoutLog >> setRecommendedWorkout: aPRWorkout [
	recommendedEntries := PRWorkout new.
	aPRWorkout
		ifNotNil: [ self isWorkoutInProgress
				ifTrue: [ (aPRWorkout exercises reject: [ :anEntry | workouts last containsExercise: anEntry exercise ])
						do: [ :exerciseEntry | recommendedEntries addExerciseEntry: exerciseEntry copy ] ]
				ifFalse: [ aPRWorkout exercises do: [ :exerciseEntry | recommendedEntries addExerciseEntry: exerciseEntry copy ] ] ]
]

{ #category : #accessing }
PRWorkoutLog >> timeZoneDifference [
	timeZoneDifference ifNil: [ self timeZoneDifference: 0 seconds ].
	^ timeZoneDifference
]

{ #category : #accessing }
PRWorkoutLog >> timeZoneDifference: aDuration [
	timeZoneDifference := aDuration
]

{ #category : #private }
PRWorkoutLog >> updateRecomendationsForLast [
	((recommendedEntries containsExercise: self lastExerciseEntry exercise)
		or: [ (self workouts allButLast anySatisfy: [ :wo | wo containsExercise: self lastExerciseEntry exercise ]) not
				or: [ self isSingleSetExercise: self lastExerciseEntry exercise ] ])
		ifFalse: [ (self lastWorkoutFor: self lastExerciseEntry exercise) exercises
				reverseDo: [ :e | recommendedEntries addFirstExerciseEntry: e copy ] ].
	recommendedEntries increaseWeightForMatches: self lastExerciseEntry
]

{ #category : #private }
PRWorkoutLog >> updateRecommendedEntries [
	| newEntry |
	recommendedEntries isEmpty
		ifTrue: [ self workouts isEmpty
				ifTrue: [ recommendedEntries addExerciseEntry: self defaultExerciseEntry ]
				ifFalse: [ (self isWorkoutInProgress
						and: [ (workouts allButLast anySatisfy: [ :e | e containsExercise: self lastExerciseEntry exercise ]) not ])
						ifTrue: [ newEntry := self lastExerciseEntry increaseWeight.
							recommendedEntries addExerciseEntry: newEntry ]
						ifFalse: [ self workouts size < 3
								ifTrue: [ self setRecommendedWorkout: self workouts first ]
								ifFalse: [ self workouts size - 1 to: 1 by: -1 do: [ :index | 
										(((self workouts at: index) containsAnyExerciseOf: self workouts last)
											and: [ ((self workouts at: index + 1) containsAnyExerciseOf: self workouts last) not ])
											ifTrue: [ ^ self setRecommendedWorkout: (self workouts at: index + 1) ] ].
									self setRecommendedWorkout: self workouts first ] ] ] ]
]

{ #category : #'accessing-seaside-configuration' }
PRWorkoutLog >> viewComponentClass [
	^ PRWorkoutLogView
]

{ #category : #accessing }
PRWorkoutLog >> workouts [
	^ workouts copy
]

{ #category : #accessing }
PRWorkoutLog >> workouts: aCollectionOfPRWorkouts [
	workouts := (aCollectionOfPRWorkouts asOrderedCollection
		collectAll: [ :e | 
			e isString
				ifTrue: [ self class workoutsBasedOnString: e ]
				ifFalse: [ OrderedCollection with: e ] ])
		sorted: [ :a :b | a date < b date ]
]

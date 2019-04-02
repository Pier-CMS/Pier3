"
I am a test suite for the classes in Pier-Workout.

"
Class {
	#name : #PRWorkoutTest,
	#superclass : #PRStructureTest,
	#category : #'Pier-Test-Workout'
}

{ #category : #testing }
PRWorkoutTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRWorkoutTest >> actualClass [
	^ PRWorkoutLog
]

{ #category : #private }
PRWorkoutTest >> addWorkoutsBasedOnString: aString [
	(self workoutsBasedOnString: aString) do: [ :e | self instance addWorkout: e ]
]

{ #category : #private }
PRWorkoutTest >> doChinupsOnFirstDayAndSquatsAndBenchOnSecondAndChinupsOnThirdReturnSquatsExercise [
	"Data is:
	|  Yesterday |Chinups     |10kg|14
	|            |Chinups     |12kg|13
	| 6 Days ago |Back Squats |200kg|10
	|            |            |201kg|9
	|            |Bench Presss|110kg|12
	|            |            |111kg|11
	| 7 Days ago |Chinups     |15kg |15
	|            |            |20kg |13 "

	| workout exercise |
	workout := PRWorkout new.
	workout date: Date today - 7 days.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf:
					(PRExercise
						name: 'Chinups'
						details: 'Also known as pullups, 0 weight starts with body weight')
				weight: 15
				times: 15);
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Chinups' weightUnits: 'kg' details: 'Also known as chinups')
				weight: 20
				times: 13).
	self instance addWorkout: workout.
	workout := PRWorkout new.
	workout date: Date today - 6 days.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (exercise := PRExercise name: 'Back Squats' details: 'Bend at the knees')
				weight: 200
				times: 10);
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Back Squats' weightUnits: 'kg' details: 'Bend at the knees')
				weight: 201
				times: 9);
		addExerciseEntry:
			(PRExerciseEntry
				newOf:
					(PRExercise name: 'Bench Press' details: 'Back flat on the bench w/ a barbell')
				weight: 110
				times: 12);
		addExerciseEntry:
			(PRExerciseEntry
				newOf:
					(PRExercise
						name: 'Bench Press'
						weightUnits: 'kg'
						details: 'Back flat on the bench w/ a barbell')
				weight: 111
				times: 11).
	self instance addWorkout: workout.
	workout := PRWorkout new.
	workout date: Date yesterday.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Chinups' details: 'Also known as pullups')
				weight: 10
				times: 14);
		addExerciseEntry:
			(PRExerciseEntry newOf: (PRExercise name: 'Chinups' details: '') weight: 12 times: 13).
	self instance addWorkout: workout.
	^ exercise
]

{ #category : #private }
PRWorkoutTest >> doChinupsOnFirstDayAndSquatsOnSecondAndReturnChinupExercise [
	"Data is:
	| 8 Days ago   |Back Squats|300lb|10
	|              |           |301lb|9
	| 9 Days ago   |Chinups    |25lb |15
	|              |           |30lb |13
	"

	| workout exercise |
	workout := PRWorkout new.
	workout date: Date today - 9 days.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf:
					(exercise := PRExercise
						name: 'Chinups'
						weightUnits: 'lb'
						details: 'Also known as pullups, 0 weight starts with body weight')
				weight: 25
				times: 15);
		addExerciseEntry:
			(PRExerciseEntry
				newOf:
					(PRExercise
						name: 'Chinups'
						weightUnits: 'lb'
						details: 'Also known as pullups, weight starts with body weight')
				weight: 30
				times: 13).
	self instance addWorkout: workout.
	workout := PRWorkout new.
	workout date: Date today - 8 days.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Back Squats' weightUnits: 'lb' details: 'Bend at the knees')
				weight: 300
				times: 10);
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Back Squats' weightUnits: 'lb' details: 'Bend at the knees')
				weight: 310
				times: 9).
	self instance addWorkout: workout.
	^ exercise
]

{ #category : #tests }
PRWorkoutTest >> testAddExerciseEntry [
	self assert: self instance allExercises isEmpty.
	self instance
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Bench Press' details: 'Flat bench with bar')
				weight: 100
				times: 12).
	self deny: self instance allExercises isEmpty.
	self instance
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Chinups' details: 'Body weight + additional weight')
				weight: 10
				times: 22).
	self
		assert: self instance workouts size = 1 description: 'Should insert to the same workout.';
		assert: self instance workouts anyOne exercises size = 2
]

{ #category : #tests }
PRWorkoutTest >> testAllExercises [
	self assert: self instance allExercises isEmpty.
	self instance
		addWorkout:
			(PRWorkout new
				addExerciseEntry:
					(PRExerciseEntry
						newOf: (PRExercise name: 'Bench Press' details: 'Flat bench with bar')
						weight: 100
						times: 12)).
	self deny: self instance allExercises isEmpty
]

{ #category : #tests }
PRWorkoutTest >> testColumnNames [
	| workout |
	workout := PRWorkout new.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Bench Press' weightUnits: 'kg' details: 'Flat bench with bar')
				weight: 200.5
				times: 12).
	self assert: workout columnNames size > 1
]

{ #category : #tests }
PRWorkoutTest >> testExercisesBasedOnRecommendationsWithDateDo [
	| count |
	count := 0.
	self doChinupsOnFirstDayAndSquatsOnSecondAndReturnChinupExercise.
	self instance exercisesBasedOnRecommendationsWithDateDo: [ :e :d | count := count + 1 ].
	self assert: count = 4.
	count := 0.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self instance exercisesBasedOnRecommendationsWithDateDo: [ :e :d | count := count + 1 ].
	self assert: count = 5
]

{ #category : #tests }
PRWorkoutTest >> testExercisesWithDateDo [
	| workout count |
	workout := PRWorkout new.
	count := 0.
	workout exercisesWithDateDo: [ :e :d | count := count + 1 ].
	self assert: count = 0.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Bench Press' weightUnits: 'kg' details: 'Flat bench with bar')
				weight: 200.5
				times: 12).
	count := 0.
	workout exercisesWithDateDo: [ :e :d | count := count + 1 ].
	self assert: count = 1
]

{ #category : #tests }
PRWorkoutTest >> testIsNewRecomendation [
	self assert: self instance isNewRecomendation.
	self instance addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Bench Press' weightUnits: 'kg' details: 'Flat bench with bar')
				weight: 200.5
				times: 12).
	self deny: self instance isNewRecomendation.

]

{ #category : #tests }
PRWorkoutTest >> testMergeWorkoutsOneDay [
	1 to: 5 do: [ :index | 
		| workout |
		workout := PRWorkout new.
		workout
			addExerciseEntry:
				(PRExerciseEntry
					newOf:
						(PRExercise
							name: 'Chinups'
							details: 'Also known as pullups, 0 weight starts with body weight')
					weight: (1 to: index + 3) atRandom
					times: (2 * index to: 3 * index) atRandom).
		self instance addWorkout: workout ].
	self instance mergeWorkouts.
	self assert: self instance workouts size = 1
]

{ #category : #tests }
PRWorkoutTest >> testMergeWorkoutsTwoDays [
	self doChinupsOnFirstDayAndSquatsOnSecondAndReturnChinupExercise.
	self instance mergeWorkouts.
	self assert: self instance workouts size = 2.
	self instance workouts first date: self instance workouts second date.
	self instance mergeWorkouts.
	self assert: self instance workouts size = 1
]

{ #category : #tests }
PRWorkoutTest >> testMidworkoutSwitchToDifferentDaysExercises [
	| exercise |
	self
		addWorkoutsBasedOnString:
			'
|16 October 2016|Single-Leg Standing Calf Raises|45|10
| |Single-Leg Standing Calf Raises|45|7
| |Trap Deadlift|150|11
| |Trap Deadlift|150|9
| |Trap Deadlift|100|12
| |Wrist Rolls|25|4
| |Wrist Rolls|35|2
|14 October 2016|Drag Curls|55|11
| |Drag Curls|50|12
| |Drag Curls|45|12
| |Dumbbell Flye|40|15
| |Dumbbell Flye|40|12
| |Dumbbell Flye|25|15
|10 October 2016|Cable Tricep Overhead Extensions|125|12
| |Cable Tricep Overhead Extensions|140|7
| |Cable Tricep Overhead Extensions|140|2
| |Back Squats|90|7
| |Back Squats|110|7
|8 October 2016|Dumbbell Incline Bench|55|12
| |Dumbbell Incline Bench|60|10
'.
	self instance
		addExerciseEntry: (PRExerciseEntry newOf: (exercise := PRExercise name: 'Dumbbell Flye' details: '') weight: 40 times: 13);
		addExerciseEntry: (PRExerciseEntry newOf: exercise weight: 45 times: 11);
		addExerciseEntry: (PRExerciseEntry newOf: (exercise := PRExercise name: 'Trap Deadlift' details: '') weight: 120 times: 11).
	self
		assert: self instance nextExerciseEntry exercise = exercise
		description: 'Recommendation should match the last exercise'
]

{ #category : #tests }
PRWorkoutTest >> testMidworkoutSwitchToNext [
	| exercise |
	self
		addWorkoutsBasedOnString:
			'
|14-April-2016 |Deadlift   |145|5
|              |           |120 |9
|19-April-2016 |Back Squats|301|10
|              |           |300|11
|              |Seated Calf Raises|200|9
|              |           |180|10
|              |           |178|11
|              |           |175|11
|              |Chinups    |35 |8
|              |           |32 |9
|              |           |30 |10
|              |           |25 |15
'.
	self instance
		addExerciseEntry: (PRExerciseEntry newOf: (PRExercise name: 'Chinups' details: '') weight: 25 times: 12);
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (exercise := PRExercise name: 'Seated Calf Raises' details: '')
				weight: 190
				times: 11);
		addExerciseEntry:
			(PRExerciseEntry
				newOf: exercise
				weight: 200
				times: 10).
	self
		assert: self instance nextExerciseEntry exercise = exercise
		description: 'Recommendation should match the last exercise'
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryEmpty [
	| exerciseEntry |
	self deny: self instance nextExerciseEntry isNil.
	self instance
		addWorkout: (PRWorkout new addExerciseEntry: (exerciseEntry := self instance defaultExerciseEntry)).
	self assert: self instance nextExerciseEntry exercise = exerciseEntry exercise
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryInWorkout [
	| exerciseEntry |
	self
		addWorkoutsBasedOnString:
			'
| 2016-Jan-7   |Back Squats|300lb|10
|              |Back Squats|301lb|9
| 2016-Jan-3   |Chinups    |25lb |15
|              |Chinups    |30lb |13
'.
	self instance
		addWorkout: (PRWorkout new addExerciseEntry: (exerciseEntry := self instance defaultExerciseEntry)).
	self
		assert: self instance nextExerciseEntry exercise = exerciseEntry exercise;
		deny:
			(self instance nextExerciseEntry reps = exerciseEntry reps
				and: [ self instance nextExerciseEntry weight = exerciseEntry weight ])
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryIncreasesAfterHeavySet [
	| entry weight |
	self doChinupsOnFirstDayAndSquatsAndBenchOnSecondAndChinupsOnThirdReturnSquatsExercise.
	entry := self instance nextExerciseEntry copy.
	weight := entry weight * 2.
	entry weight: weight.
	self instance addExerciseEntry: entry.
	self
		assert: self instance nextExerciseEntry weight >= weight
		description: 'Recommended weight for the second set of squats should be heavy'
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryRepeatFirst [
	| exerciseEntry |
	self doChinupsOnFirstDayAndSquatsOnSecondAndReturnChinupExercise.
	exerciseEntry := self instance lastExerciseEntry increaseWeight.
	self instance addExerciseEntry: exerciseEntry.
	self
		assert: self instance nextExerciseEntry exercise = exerciseEntry exercise
		description: 'Should be squats since that was just performed'.
	self instance addExerciseEntry: exerciseEntry increaseWeight.
	self
		deny: self instance nextExerciseEntry exercise = exerciseEntry exercise
		description: 'Two sets are done.'
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryThreeDays [
	| exercise entry weight |
	exercise := self
		doChinupsOnFirstDayAndSquatsAndBenchOnSecondAndChinupsOnThirdReturnSquatsExercise.
	self assert: (#('Back Squats' 'Bench Press') includes: (entry := self instance nextExerciseEntry) exercise name).
	weight := entry weight.
	self instance addExerciseEntry: entry increaseWeight.
	self
		assert: self instance nextExerciseEntry exercise = entry exercise
			description: 'Should recommend second set';
		assert: self instance nextExerciseEntry weight > weight
			description: 'Weight should also increase'.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self
		assert: (#('Back Squats' 'Bench Press') includes: self instance nextExerciseEntry exercise name)
		description: 'Next exercise is either squat or bench'.
	self instance
		addExerciseEntry: self instance workouts first exercises first increaseWeight.
	self
		assert:
			self instance nextExerciseEntry exercise
				= self instance workouts first exercises first exercise
		description: 'Next exercise should be chinups since it was slipped in.'
]

{ #category : #tests }
PRWorkoutTest >> testNextExerciseEntryTwoDays [
	| exercise |
	exercise := self doChinupsOnFirstDayAndSquatsOnSecondAndReturnChinupExercise.
	self
		assert: self instance furthestReasonableExerciseEntry exercise
		= exercise;
		assert: self instance nextExerciseEntry exercise = exercise
		description: 'Should be chinups since that was the longest ago'.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self assert: self instance nextExerciseEntry weight = 30
]

{ #category : #tests }
PRWorkoutTest >> testNextWorkoutProgressAfterOldExercise [
	self
		addWorkoutsBasedOnString:
			'
| 2016-Jan-20  |Back Squats|301|10
|              |Back Squats|300|9
|              |Bench Press|245|8
|              |Bench Press|240|12
| 2016-Jan-3   |Bench Press|190|15
|              |Bench Press|185|13
|              |Chinups    |35 |12
|              |Chinups    |30 |13
'.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self
		assert: self instance nextExerciseEntry weight ~= 185
		description: 'The weight should be 240'
]

{ #category : #tests }
PRWorkoutTest >> testNumberOfSets [
	| workout |
	workout := PRWorkout new.
	self assert: workout numberOfSets = 0.
	workout
		addExerciseEntry:
			(PRExerciseEntry
				newOf: (PRExercise name: 'Bench Press' weightUnits: 'kg' details: 'Flat bench with bar')
				weight: 200.5
				times: 12).
	self assert: workout numberOfSets = 1
]

{ #category : #tests }
PRWorkoutTest >> testRecommendedWorkoutFromYesterday [
	"If the recommended workout is stale, then discard it."

	self
		addWorkoutsBasedOnString:
			'
| 2016-Jan-20  |Back Squats|301|10
|              |Back Squats|300|9
|              |Bench Press|245|8
|              |Bench Press|240|12
| 2016-Jan-3   |Bench Press|190|15
|              |Bench Press|185|13
|              |Chinups    |35 |12
|              |Chinups    |30 |13
'.
	self instance addExerciseEntry: self instance nextExerciseEntry.
	self instance dayPassesForTesting.
	self
		assert: self instance nextExerciseEntry exercise name ~= #Chinups
		description: 'Since a day has past, chinups are not the next recommendation.'
]

{ #category : #tests }
PRWorkoutTest >> testRemoveExerciseEntry [
	| exerciseEntry |
	self deny: self instance nextExerciseEntry isNil.
	self instance
		addWorkout: (PRWorkout new addExerciseEntry: (exerciseEntry := self instance defaultExerciseEntry)).
	self assert: self instance nextExerciseEntry exercise = exerciseEntry exercise.
	self instance removeExerciseEntry: exerciseEntry.
	self assert: self instance workouts isEmpty
]

{ #category : #actions }
PRWorkoutTest >> workoutsBasedOnString: aString [
	| wos wo n exercise |
	wos := OrderedCollection new.
	wo := nil.
	n := ''.
	exercise := nil.
	aString
		linesDo: [ :str | 
			| substrings |
			(substrings := str trim substrings: '|') isEmpty
				ifFalse: [ substrings second trim size > 2
						ifTrue: [ n := substrings second ].
					substrings first trim size > 3
						ifTrue: [ wo ifNotNil: [ wos add: wo ].
							wo := PRWorkout new.
							wo date: substrings first asDate ].
					exercise := PRExercise name: n weightUnits: 'lb' details: ''.
					(substrings size > 4 and: [ exercise details isEmpty ])
						ifTrue: [ exercise details: substrings fifth ].
					wo
						addFirstExerciseEntry:
							(PRExerciseEntry
								newOf: exercise
								weight: substrings third trim
								times: substrings fourth trim) ] ].
	wos add: wo.
	^ wos reverse
]

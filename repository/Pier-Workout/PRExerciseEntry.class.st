"
I am an individually exercise created in a workout, one set of a sequence of a PRExercise.

Seems I need to use a MAToOneRelationDescription to describe the exercise.

All of the printing protocol are used for simplifing debugging.

One should really not modify an existing exercise entry, they should instead create a new object that has the values needed - this is why the two increase messages return new instances of this class.

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
	exercise:		<Object>
	notes:		<Object>
	reps:		<Object>
	weight:		<Object>


    Implementation Points
"
Class {
	#name : #PRExerciseEntry,
	#superclass : #Object,
	#instVars : [
		'exercise',
		'weight',
		'reps'
	],
	#category : #'Pier-Workout'
}

{ #category : #'instance creation' }
PRExerciseEntry class >> newOf: anExercise weight: aWeightFloat times: aRepInteger [
	^ self new
		exercise: anExercise;
		weight: aWeightFloat;
		reps: aRepInteger;
		yourself
]

{ #category : #accessing }
PRExerciseEntry >> columnNames [
	^ #(#exercise #weight #reps)
]

{ #category : #'accessing-description' }
PRExerciseEntry >> descriptionDetails [
	<magritteDescription>
	^ MAMemoDescription new
		propertyAt: #public put: true;
		accessor: #details;
		label: 'Exercise Details';
		lineCount: 2;
		beReadOnly;
		priority: 170;
		yourself
]

{ #category : #'accessing-description' }
PRExerciseEntry >> descriptionExercise [
	<magritteDescription>
	^ MASingleOptionDescription new
		options: (PRExercise instancesWithFirst: self exercise);
		default: self exercise;
		accessor: #exercise;
		label: 'Exercise';
		beEditable;
		beRequired;
		priority: 110;
		yourself
]

{ #category : #'accessing-description' }
PRExerciseEntry >> descriptionReps [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #reps;
		label: 'Repetitions';
		beInteger;
		default: 8;
		min: 0;
		priority: 150;
		yourself
]

{ #category : #'accessing-description' }
PRExerciseEntry >> descriptionWeight [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'weight';
		accessor: #weight;
		label: 'Weight (' , self exercise weightUnits , ')';
		beRequired;
		priority: 130;
		yourself
]

{ #category : #accessing }
PRExerciseEntry >> details [
	^ self exercise details
]

{ #category : #accessing }
PRExerciseEntry >> exercise [
	^ exercise
]

{ #category : #accessing }
PRExerciseEntry >> exercise: anObject [
	exercise := anObject
]

{ #category : #accessing }
PRExerciseEntry >> increaseWeight [
	^ self class newOf: self exercise weight: self weight asNumber + 5 times: self reps
]

{ #category : #accessing }
PRExerciseEntry >> increaseWeightToAtLeast: aNumber [
	^ self weight asNumber < aNumber
		ifTrue: [ self class newOf: self exercise weight: aNumber times: self reps ]
		ifFalse: [ self ]
]

{ #category : #initialization }
PRExerciseEntry >> initialize [
	super initialize.
	^ self
		exercise: PRExercise new;
		weight: 234.5;
		reps: 12;
		yourself
]

{ #category : #printing }
PRExerciseEntry >> printOn: aStream [
	aStream
		nextPutAll: (self reps ifNil: [ '?' ]) asString;
		nextPutAll: ' reps of ';
		nextPutAll: self exercise printString;
		nextPutAll: ' at ';
		nextPutAll: (self weight ifNil: [ '?' ]) asString;
		nextPutAll: self exercise weightUnits
]

{ #category : #accessing }
PRExerciseEntry >> reps [
	^ reps
]

{ #category : #accessing }
PRExerciseEntry >> reps: anObject [
	reps := anObject
]

{ #category : #accessing }
PRExerciseEntry >> weight [
	^ weight
]

{ #category : #accessing }
PRExerciseEntry >> weight: aString [
	aString isNumber
		ifTrue: [ ^ weight := aString ].
	((aString
		allSatisfy: [ :char | '1234567890.' includes: char ])
		and: [ (aString select: [ :char | char = $. ]) size < 2 ])
		ifTrue: [ ^ weight := aString asNumber ].
	(self exercise weightUnits = 'kg'
		and:
			[ ('#*lb' match: aString)
				or: [ '#*pounds' match: aString ] ])
		ifTrue:
			[ ^ weight := aString asNumber * 0.453592
				round: 1 ].
	(self exercise weightUnits = 'lb'
		and:
			[ ('#*kg' match: aString)
				or: [ '#*kilograms' match: aString ] ])
		ifTrue:
			[ ^ weight := aString asNumber * 2.20462 round: 1 ].
	weight := aString asNumber
]

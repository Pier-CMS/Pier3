"
I represent the name of an exercise, and have a description, and a measurement unit for that exercise.  Each exercise should have a unique name.  A list of exercises can be found with: 
	PRExercise  instances
	
One item is  choosen from this list when creating a workout, not necessarily created during the workout.

It may be a good idea to add a type instance variable, so exercise entries can be grouped together.

The WeightUnits variable is either kilograms or pounds.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	details:		<Object>
	name:		<Object>
	weightUnits:		<Object>


    Implementation Points
"
Class {
	#name : #PRExercise,
	#superclass : #Object,
	#instVars : [
		'name',
		'weightUnits',
		'details'
	],
	#classVars : [
		'instances'
	],
	#category : #'Pier-Workout'
}

{ #category : #accessing }
PRExercise class >> addInstance: aPRExercise [
	(self instances contains: [ :e | e name = aPRExercise name ])
		ifFalse: [ instances add: aPRExercise ]
]

{ #category : #accessing }
PRExercise class >> instances [
	instances ifNil: [ instances := OrderedCollection new ].
	^ instances
]

{ #category : #accessing }
PRExercise class >> instancesWithFirst: aPrExercise [
	| instancesCopy |
	(instancesCopy := instances copy) remove: aPrExercise ifAbsent: [  ].
	"instancesCopy := (instancesCopy asSortedCollection: [ :a :b | a name < b name ]) asOrderedCollection."
	instancesCopy := instancesCopy sort: [ :a :b | a name < b name ].
	instancesCopy addFirst: aPrExercise.
	^ instancesCopy
]

{ #category : #'instance-creation' }
PRExercise class >> name: aNameString details: aDescriptionString [
	^ self name: aNameString weightUnits: 'kg' details: aDescriptionString

]

{ #category : #'instance-creation' }
PRExercise class >> name: aNameString weightUnits: kgLb details: aDescriptionString [
	| new |
	aNameString trim isEmpty
		ifTrue: [ self error: 'Can not create an exercise from an empty string' ].
	^ self instances
		detect: [ :exercise | exercise name = aNameString trim asSymbol ]
		ifNone: [ self instances
				add:
					(new := self new
						name: aNameString;
						weightUnits: kgLb;
						details: aDescriptionString;
						yourself).
			new ]
]

{ #category : #comparing }
PRExercise >> = anExercise [
	self == anExercise ifTrue: [ ^ true ].
	self species = anExercise species ifFalse: [ ^ false ].
	^ self name = anExercise name
]

{ #category : #'accessing-description' }
PRExercise >> descriptionDetails [
	<magritteDescription>
	^ MAMemoDescription new
		propertyAt: #public put: true;
		accessor: #details;
		label: 'Exercise Details';
		lineCount: 2;
		beEditable;
		yourself
]

{ #category : #'accessing-description' }
PRExercise >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		beSearchable;
		beRequired;
		yourself
]

{ #category : #'accessing-description' }
PRExercise >> descriptionWeightUnits [
	<magritteDescription>
	^ MASingleOptionDescription new
		options: #('kg' 'lb');
		accessor: #weightUnits;
		label: 'Measurement';
		beRequired;
		yourself

]

{ #category : #accessing }
PRExercise >> details [
	^ details
]

{ #category : #accessing }
PRExercise >> details: aMultiLineString [
	details := aMultiLineString
]

{ #category : #comparing }
PRExercise >> hash [
	^ self name hash
]

{ #category : #initialization }
PRExercise >> initialize [
	super initialize.
	^ self
		name: '';
		weightUnits: 'kg';
		details: '';
		yourself
]

{ #category : #accessing }
PRExercise >> name [
	^ name
]

{ #category : #accessing }
PRExercise >> name: aShortString [
	name := aShortString trim asSymbol
]

{ #category : #accessing }
PRExercise >> notes [
	^ details
]

{ #category : #printing }
PRExercise >> printOn: aStream [
	aStream nextPutAll: self name

]

{ #category : #accessing }
PRExercise >> weightUnits [
	^ weightUnits
]

{ #category : #accessing }
PRExercise >> weightUnits: aString [
	weightUnits := aString
]

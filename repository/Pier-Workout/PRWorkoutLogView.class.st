"
This is the display for the PRWorkoutLog, it is based off of PRToDoView.

The instance variable daysToDisplay is the number of days to display, if there are more than 5k, it get rather slow.
"
Class {
	#name : #PRWorkoutLogView,
	#superclass : #PRViewComponent,
	#instVars : [
		'daysToDisplay'
	],
	#category : #'Pier-Workout'
}

{ #category : #testing }
PRWorkoutLogView class >> isAbstract [
	^ false
]

{ #category : #testing }
PRWorkoutLogView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isWorkout ]
]

{ #category : #accessing }
PRWorkoutLogView class >> label [
	^ 'Workout'
]

{ #category : #accessing }
PRWorkoutLogView >> daysToDisplay [
	^ daysToDisplay ifNil: [ daysToDisplay := 40 ]
]

{ #category : #'as yet unclassified' }
PRWorkoutLogView >> doubleDaysToDisplay [
	daysToDisplay := daysToDisplay * 2
]

{ #category : #rendering }
PRWorkoutLogView >> renderAddOn: html [
	| selectList nextEntry |
	selectList := (nextEntry := context structure nextExerciseEntry) exercise.
	self
		renderAddOnLabel: 'Exercise: '
		control:
			[ :id :script | 
			html select
				id: id;
				list: context structure allExercises;
				selected: selectList;
				callback: [ :value | selectList := value ];
				onChange: (script html: [ :h | h render: selectList ]) ]
		model: nextEntry
		on: html
]

{ #category : #rendering }
PRWorkoutLogView >> renderAddOnLabel: aString control: aBlock model: anObject on: html [
	| component |
	html
		form: [ html render: (component := anObject asComponent).
			html submitButton
				callback: [ component save.
					context structure addExerciseEntry: component model copy ];
				with: 'Add'.
			context structure isNewRecomendation
				ifFalse: [ html submitButton
						callback: [ daysToDisplay := 40.
							context structure setRecommendedWorkout: nil ];
						with: 'Reset Recommendation' ].
			self daysToDisplay < context structure workouts size
				ifTrue: [ html submitButton
						callback: [ self doubleDaysToDisplay ];
						with: 'Double Days Listed' ] ]
]

{ #category : #rendering }
PRWorkoutLogView >> renderContentOn: html [
	(self context isValidCommand: PREditCommand)
		ifTrue: [ self renderAddOn: html ].
	self renderTableOn: html
]

{ #category : #rendering }
PRWorkoutLogView >> renderTableBodyOn: html [
	| index lastDate displayDays |
	displayDays := self daysToDisplay + 1.
	html
		tableBody: [ index := 1.
			lastDate := nil.
			context structure
				exercisesBasedOnRecommendationsWithDateDo: [ :e :d | 
					displayDays isZero
						ifFalse: [ html tableRow
								class:
									(index odd
										ifTrue: [ 'odd' ]
										ifFalse: [ 'even' ]);
								with: [ lastDate = d
										ifTrue: [ html tableData: ' ' ]
										ifFalse: [ displayDays := displayDays - 1.
											displayDays isZero
												ifFalse: [ html tableData: d.
													lastDate := d ] ].
									displayDays isZero
										ifFalse: [ context structure columnNames = #(#weight #exercise #reps)
												ifTrue: [ html
														tableData: e exercise;
														tableData: e weight;
														tableData: e reps ]
												ifFalse: [ self
														sortColumns: context structure columnNames
														andDo: [ :exerciseSymb | html tableData: (e perform: exerciseSymb) ] ].
											((self context isValidCommand: PREditCommand)
												and: [ d > Date yesterday previous ])
												ifTrue: [ html tableData
														with: [ html anchor
																callback: [ context structure removeExerciseEntry: e ];
																with: 'remove' ] ].
											index := index + 1 ] ] ] ] ]
]

{ #category : #rendering }
PRWorkoutLogView >> renderTableHeaderOn: html [
	html
		tableHead:
			[ html
				tableRow:
					[ html tableHeading: 'Date'.
					self
						sortColumns: context structure columnNames
						andDo: [ :symbol | html tableHeading: symbol asCamelCase ] ] ]
]

{ #category : #rendering }
PRWorkoutLogView >> renderTableOn: html [
	context structure numberOfSets > 0
		ifTrue:
			[ html
				table:
					[ self renderTableHeaderOn: html.
					self renderTableBodyOn: html ] ]
]

{ #category : #actions }
PRWorkoutLogView >> sortColumns: aCollectionOfSymbols andDo: aBlock [
	"I don't know what the column names are, but I know what order I want them in"

	| arrayOfSymboxes firstIndex |
	arrayOfSymboxes := Array withAll: aCollectionOfSymbols.
	firstIndex := 1.
	(aCollectionOfSymbols includes: #exercise)
		ifTrue: [ arrayOfSymboxes at: 1 put: #exercise.
			firstIndex := 2 ].
	(aCollectionOfSymbols includes: #notes)
		ifTrue: [ arrayOfSymboxes at: 1 put: #notes ].
	(aCollectionOfSymbols reject: [ :e | #(#exercise #notes) includes: e ])
		do:
			[ :sym | 
			arrayOfSymboxes at: firstIndex put: sym.
			firstIndex := firstIndex + 1 ].
	arrayOfSymboxes do: aBlock
]

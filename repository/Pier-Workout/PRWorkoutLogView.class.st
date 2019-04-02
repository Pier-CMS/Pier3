"
This is the display for the PRWorkoutLog, it is based off of PRToDoView.

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


    Implementation Points
"
Class {
	#name : #PRWorkoutLogView,
	#superclass : #PRViewComponent,
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
						callback: [ context structure setRecommendedWorkout: nil ];
						with: 'Reset Recommendation' ] ]
]

{ #category : #rendering }
PRWorkoutLogView >> renderContentOn: html [
	(self context isValidCommand: PREditCommand)
		ifTrue: [ self renderAddOn: html ].
	self renderTableOn: html
]

{ #category : #rendering }
PRWorkoutLogView >> renderTableBodyOn: html [
	| index lastDate |
	html
		tableBody: [ index := 1.
			lastDate := nil.
			context structure
				exercisesBasedOnRecommendationsWithDateDo: [ :e :d | 
					html tableRow
						class:
							(index odd
								ifTrue: [ 'odd' ]
								ifFalse: [ 'even' ]);
						with: [ lastDate = d
								ifTrue: [ html tableData: ' ' ]
								ifFalse: [ html tableData: d.
									lastDate := d ].
							self
								sortColumns: context structure columnNames
								andDo: [ :exerciseSymb | html tableData: (e perform: exerciseSymb) ].
							((self context isValidCommand: PREditCommand) and: [ d > Date yesterday ])
								ifTrue: [ html tableData
										with: [ html anchor
												callback: [ context structure removeExerciseEntry: e ];
												with: 'remove' ] ].
							index := index + 1 ] ] ]
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

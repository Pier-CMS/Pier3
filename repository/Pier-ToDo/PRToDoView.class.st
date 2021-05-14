"
A PRToDoView is modeled after PRChangesView, it uses JQuery accordion to display the list.

Instance variables - see #setReports:
	report		<OrderedCollection of MAReport>	 - Tasks to be displayed
	names		<OrderedCollection of Strings>	 - Labels for each page of the accordion

"
Class {
	#name : #PRToDoView,
	#superclass : #PRViewComponent,
	#instVars : [
		'reports',
		'names'
	],
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRToDoView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRToDoView class >> label [
	^ 'ToDo'
]

{ #category : #actions }
PRToDoView >> addTaskIn: aContext [
	(self context isValidCommand: aContext command class)
		ifFalse: [ self inform: 'Unable to add a task ' , aContext command label printString , ' in the current context.' ]
		ifTrue: [ self context: aContext ]
]

{ #category : #private }
PRToDoView >> buildDescriptionFrom: tasks [
	^ (tasks detect: [ :e | true ] ifNone: [ PRToDoTask new ]) magritteDescription
		select: [ :each | #('Title' 'Points') includes: each label ]
]

{ #category : #hooks }
PRToDoView >> children [
	^ self reports
]

{ #category : #testing }
PRToDoView >> isVisible: aContext [
	^ aContext command isEdit and: [ super isVisible: aContext ]
]

{ #category : #actions }
PRToDoView >> markComplete: aTask [
	| editCommand |
	self context structure: aTask command: (editCommand := PRCompleteToDoTaskCommand new).
	editCommand write: true using: aTask descriptionCompleted.
	editCommand execute
]

{ #category : #actions }
PRToDoView >> open: aContext [
	(self context isValidCommand: aContext command class)
		ifFalse: [ self
				inform:
					'Unable to open ' , aContext command label printString
						, ' in the current context.' ]
		ifTrue: [ self context: aContext ]
]

{ #category : #rendering }
PRToDoView >> renderAccordionOn: html [
	html div
		script: html jQuery new accordion;
		with: [ self reports isEmpty
				ifFalse: [ self reports
						with: names
						do: [ :report :name | 
							html div: [ html anchor: name ].
							html div: [ self renderReport: report on: html ] ] ] ]
]

{ #category : #rendering }
PRToDoView >> renderContentOn: html [
	self context structure isToDo
		ifTrue: [ 
			self renderHeaderOn: html.
			self renderAccordionOn: html ]
		ifFalse: [ html render: 'Select "Add" then "ToDo" to create a ToDo list.' ]
]

{ #category : #rendering }
PRToDoView >> renderHeaderOn: html [
	html render: self context structure pointsName , ' ' , self context structure totalPoints asString.
	(self context isValidCommand: PREditCommand)
		ifTrue: [ 
			html render: ' - '.
			html span
				with: [ 
					html anchor
						callback: [ self addTaskIn: (self context command: PRAddTaskCommand new) ];
						with: 'Add a task' ] ]
]

{ #category : #rendering }
PRToDoView >> renderReport: aReport on: html [
	html table
		with:
			[ aReport renderTableHeadOn: html.
			aReport rows
				withIndexDo:
					[ :aTask :index | 
					html tableRow
						class:
							(index odd
								ifTrue: [ 'odd' ]
								ifFalse: [ 'even' ]);
						with:
								[ html
								tableData:
									[ html anchor
										goto: (self context structure: aTask);
										with: aTask title.
									html tableData: aTask points asString.
									html tableData: aTask shortDueDate asString.
									(aTask completed not and: [ self context isValidCommand: PREditCommand ])
										ifTrue:
											[ html
												tableData: [ html anchor
														callback: [ self markComplete: aTask ];
														with: 'Complete' ] ] ] ] ] ]
]

{ #category : #accessing }
PRToDoView >> reports [
	^ reports ifNil: [ self setReports ]
]

{ #category : #private }
PRToDoView >> setReports [
	"Display the open button if the user has edit permissions."

	| tasks |
	self context structure isToDo
		ifFalse: [ ^ #() ].
	reports := OrderedCollection new.
	names := OrderedCollection new.
	self context structure tasksUnDoneAsGroups
		do: [ :association | 
			names add: association key.
			tasks := association value.
			reports
				add:
					((MAReport rows: tasks description: (self buildDescriptionFrom: tasks))
						sortEnabled: true;
						batchSize: tasks size;
						yourself).
			reports last
				addColumn:
					(MAColumn new
						label: 'Due Date';
						accessor: #shortDueDate).
			(self context isValidCommand: PREditCommand)
				ifTrue: [ 
					reports last
						addColumn:
								(MACommandColumn new
										label: 'is done?';
										addCommand: [ :toDoItem | 
													self markComplete: toDoItem.
													self setReports ]
											text: 'Complete';
										yourself);
						addColumn:
								(MACommandColumn new
										addCommand: [ :value | self open: (self context structure: value command: PRViewCommand new) ] text: 'open';
										yourself) ] ].
	(tasks := self context structure tasksDone sort: [ :a :b | a due < b due ]) isEmpty
		ifFalse: [ 
			names add: 'Completed tasks'.
			reports
				add:
					((MAReport rows: tasks description: (self buildDescriptionFrom: tasks))
						sortEnabled: true;
						batchSize: self context structure smallGroupSize - 2;
						yourself).
			reports last
				addColumn:
					(MAColumn new
						label: 'Due Date';
						accessor: #shortDueDate).
			(self context isValidCommand: PREditCommand)
				ifTrue: [ 
					reports last
						addColumn:
							(MACommandColumn new
								addCommand: [ :value | self open: (self context structure: value command: PRViewCommand new) ] text: 'open';
								yourself) ] ].
	^ reports
]

"
A PRAddTaskCommand is used for adding tasks.  This makes it easier to enter the title (since that is what is displayed).  A task name is relatively irrelevant.
"
Class {
	#name : #PRAddTaskCommand,
	#superclass : #PRAddCommand,
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRAddTaskCommand class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isToDo ]
]

{ #category : #accessing }
PRAddTaskCommand class >> label [
	^ 'Add Task'
]

{ #category : #'acessing-magritte' }
PRAddTaskCommand >> descriptionName [
	"Removed #beRequired and added beHidden so this would not be displayed."

	<magritteDescription>
	^ MAStringDescription new
		addCondition: (MACondition receiver: PRPath selector: #isValidName:) labelled: 'Invalid structure name';
		parameterName: 'name';
		accessor: #name;
		label: 'Name';
		priority: 100;
		beHidden;
		yourself
]

{ #category : #'acessing-magritte' }
PRAddTaskCommand >> descriptionNameAsTitle: aDescription [
	"List the title, not the name"

	<magritteDescription: #descriptionName>
	^ aDescription
		beOptional;
		yourself
]

{ #category : #'acessing-magritte' }
PRAddTaskCommand >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		parameterName: 'title';
		accessor: #title;
		label: 'Title';
		priority: 105;
		beRequired;
		yourself
]

{ #category : #accessing }
PRAddTaskCommand >> name [
	"Based the name on the title if possible - this seems like the best option:"

	^ (self title isNil or: [ self title isEmpty ])
		ifTrue: [ super name ]
		ifFalse: [ self uniqueName: self nameFromTitle in: self structure ]
]

{ #category : #accessing }
PRAddTaskCommand >> nameFromTitle [
	^ String
		streamContents: [ :stream | 
			self title
				do: [ :c | 
					c isAlphaNumeric
						ifTrue: [ stream nextPut: c asLowercase ]
						ifFalse: [ stream nextPut: $- ] ] ]
]

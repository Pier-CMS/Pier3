"
A PRCompleteToDoTaskCommand is an edit command that has the label 'Complete' - it makes it easier to tell when a task was complete in the changes.
"
Class {
	#name : #PRCompleteToDoTaskCommand,
	#superclass : #PREditCommand,
	#category : #'Pier-ToDo'
}

{ #category : #testing }
PRCompleteToDoTaskCommand class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isRoot not and: [ aContext structure parent isToDo ] ]
]

{ #category : #accessing }
PRCompleteToDoTaskCommand class >> label [
	^ 'Complete'
]

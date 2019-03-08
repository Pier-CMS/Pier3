"
Command to edit a structure, e.g. all the descriptions that are tagged as ==#beEditable==.
"
Class {
	#name : #PREditCommand,
	#superclass : #PRChangeCommand,
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PREditCommand class >> accessKey [
	^ $e
]

{ #category : #testing }
PREditCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PREditCommand class >> label [
	^ 'Edit'
]

{ #category : #testing }
PREditCommand >> isEdit [
	^ true
]

{ #category : #accessing }
PREditCommand >> magritteDescription [
	^ self structure editDescription
]

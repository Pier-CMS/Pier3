"
Command to move a structure.
"
Class {
	#name : #PRMoveCommand,
	#superclass : #PRLocationCommand,
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PRMoveCommand class >> accessKey [
	^ $m
]

{ #category : #testing }
PRMoveCommand class >> isAbstract [
	^ false
]

{ #category : #testing }
PRMoveCommand class >> isValidIn: aContext [
	^ (super isValidIn: aContext)
		and: [ aContext structure isRoot not ]
]

{ #category : #accessing }
PRMoveCommand class >> label [
	^ 'Move'
]

{ #category : #events }
PRMoveCommand >> doExecute [
	super doExecute.
	self structure name: self name.
	self structure parent = self target ifFalse: [
		self target 
			addChild: self structure remove ].
	self updateLinksFor: self structure
]

{ #category : #events }
PRMoveCommand >> doValidate [
	super doValidate.
	(self structure isAncestorOf: self target)
		ifFalse: [ ^ self ].
	PRInvalidNestingError
		description: self magritteDescription
		signal: self structure title printString , ' can not be moved into itself'
]

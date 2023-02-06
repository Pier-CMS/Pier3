"
Command to remove a structure.
"
Class {
	#name : #PRRemoveCommand,
	#superclass : #PRCommand,
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PRRemoveCommand class >> accessKey [
	^ $r
]

{ #category : #testing }
PRRemoveCommand class >> isAbstract [
	^ false
]

{ #category : #testing }
PRRemoveCommand class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isRoot not ]
]

{ #category : #accessing }
PRRemoveCommand class >> label [
	^ 'Remove'
]

{ #category : #accessing }
PRRemoveCommand >> confirmation [
	^ self propertyAt: #confirmation ifAbsentPut: [
		| document structures |
		document := PRDocument new.
		document add: (PRHeader withAll: (Array with: (PRText content: 'Do you really want to remove ' , self structure title , '?')) level: 1).
		structures := self structure enumerator all contents.
		structures isEmpty ifFalse: [
			document add: (PRParagraph with: (PRText content: 'There ' , (structures size > 1 ifTrue: [ 'are ' ] ifFalse: [ 'is ' ]) , structures size greaseString , ' child ' , (structures size > 1 ifTrue: [ 'structures' ] ifFalse: [ 'structure' ]) , ':')).
			document add: (PROrderedList withAll: (structures collect: [ :each |
				PRListItem with: (PRInternalLink reference: each absolutePath) ])) ].
		structures := self root incomingReferences to: self structure; collect: [ :each | each owner ].
		structures isEmpty ifFalse: [
			document add: (PRParagraph with: (PRText content: 'There ' , (structures size > 1 ifTrue: [ 'are ' ] ifFalse: [ 'is ' ]) , structures size greaseString , ' incoming ' , (structures size > 1 ifTrue: [ 'references' ] ifFalse: [ 'reference' ]) , ':')).
			document add: (PROrderedList withAll: (structures collect: [ :each |
				PRListItem with: (PRInternalLink reference: each absolutePath) ])) ].
		document owner: self structure ]
]

{ #category : #'accessing-description' }
PRRemoveCommand >> descriptionConfirmation [

	<magritteDescription>
	^ PRDocumentDescription new
		  accessor: #confirmation;
		  priority: 100;
		  beReadOnly;
		  yourself
]

{ #category : #events }
PRRemoveCommand >> doExecute [
	| parent |
	super doExecute.
	self root incomingReferences
		toAll: (self structure enumerator
			everything contents);
		do: [ :each | each target: nil ].
	parent := self structure parent.
	self structure remove.
	self successAnswer: (self context
		structure: parent)
]

{ #category : #events }
PRRemoveCommand >> doValidate [
	super doValidate.
	self structure isRoot
		ifFalse: [ ^ self ].
	(PRStructureError structure: self structure)
		signal: 'Unable to remove root node.'
]

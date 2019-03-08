"
Command to copy a structure.
"
Class {
	#name : #PRCopyCommand,
	#superclass : #PRLocationCommand,
	#category : #'Pier-Model-Command'
}

{ #category : #testing }
PRCopyCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRCopyCommand class >> label [
	^ 'Copy'
]

{ #category : #'accessing-defaults' }
PRCopyCommand >> defaultName [
	^ self uniqueName: self structure name in: self target
]

{ #category : #events }
PRCopyCommand >> doExecute [
	| structure |
	super doExecute.
	self target childrenDecoration
		add: (structure := self structure copy
			name: self name;
			title: nil;
			yourself).
	self updateLinksFor: structure.
	self successAnswer: (self context
		structure: structure)
]

{ #category : #private }
PRCopyCommand >> updateLinksFor: aStructure [
	"When copying we need to update links pointing from the copied structures to the original structures."
	
	| copiedStructures originalStructures |
	copiedStructures := aStructure enumerator
		everything contents.
	originalStructures := self structure enumerator
		everything contents.
	copiedStructures do: [ :structure |
		structure outgoingReferences do: [ :link |
			link isInternal ifTrue: [
				| index copied |
				index := originalStructures indexOf: link target.
				copied := copiedStructures at: index ifAbsent: [ nil ].
				copied isNil ifFalse: [ link target: copied ] ] ] ].
	super updateLinksFor: aStructure
]

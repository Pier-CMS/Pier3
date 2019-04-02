Class {
	#name : #BONoteWidget,
	#superclass : #PRWidget,
	#instVars : [
		'component',
		'command',
		'note'
	],
	#category : #'Pier-Book-Utilities'
}

{ #category : #testing }
BONoteWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
BONoteWidget class >> label [
	^ 'Book Notes'
]

{ #category : #private }
BONoteWidget >> buildCommand [
	^ (self context
		structure: self note
		command: self note editCommandClass new)
			command
]

{ #category : #private }
BONoteWidget >> buildComponent [
	^ (self buildDescription asComponentOn: self command)
		onAnswer: [ :result | self execute: result ];
		addValidatedForm;
		yourself
]

{ #category : #private }
BONoteWidget >> buildDescription [
	^ self command magritteDescription select: [ :each | each propertyAt: #public ifAbsent: [ false ] ]
]

{ #category : #private }
BONoteWidget >> buildNote [
	^ BONote new
		title: self context structure title;
		yourself
]

{ #category : #accessing }
BONoteWidget >> children [
	^ Array with: self component
]

{ #category : #accessing }
BONoteWidget >> command [
	^ command ifNil: [ command := self buildCommand ]
]

{ #category : #accessing }
BONoteWidget >> component [
	^ component ifNil: [ component := self buildComponent ]
]

{ #category : #actions }
BONoteWidget >> execute: anEditCommand [
	| addCommand |
	note := component := command := nil.
	anEditCommand ifNil: [ ^ self ].
	addCommand := PRAddCommand new.
	self context command: addCommand.
	addCommand
		name: (addCommand
			uniqueName: 'note'
			in: self context structure);
		type: BONote;
		beUnchecked;
		execute.
	self context
		structure: addCommand successAnswer structure
		command: anEditCommand.
	anEditCommand
		beUnchecked;
		execute
]

{ #category : #accessing }
BONoteWidget >> note [
	^ note ifNil: [ note := self buildNote ]
]

{ #category : #accessing }
BONoteWidget >> notes [
	^ (self context enumerator
		select: [ :each | each isNote ])
		asSortedCollection: [ :a :b | a timestamp > b timestamp ]
]

{ #category : #'rendering-adding' }
BONoteWidget >> renderAddOn: html [
	html div class: 'addnote'; with: [
		html heading: 'Add a Note'.
		html render: self component ]
]

{ #category : #rendering }
BONoteWidget >> renderContentOn: html [
	self context structure isPublication
		ifFalse: [ ^ self ].
	html div class: 'notes'; with: [
		self renderNotes: self notes on: html.
		self renderAddOn: html ]
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNote: aNote on: html [
	html div class: 'note'; with: [ 
		self renderNoteMeta: aNote on: html.
		self renderNoteBody: aNote on: html ]
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNoteBody: aNote on: html [
	| line |
	html div class: 'body'; with: [
		aNote note lines do: [ :string |
			line := string.
			html paragraph: [
				line isEmpty
					ifTrue: [ html space ]
					ifFalse: [
						[ line notEmpty and: [ line first = $ ] ]
							whileTrue: [ html space. line := line copyWithoutFirst ].
						html text: line ] ] ] ]
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNoteMeta: aNote on: html [ 
	html div class: 'meta'; with: [
		self renderNoteMetaAuthor: aNote on: html.
		self renderNoteMetaPublication: aNote on: html.
		self renderNoteMetaCommands: aNote on: html ]
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNoteMetaAuthor: aNote on: html [
	html span
		class: 'author';
		with: aNote author.
	html text: ' '
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNoteMetaCommands: aNote on: html [
	| commands contexts |
	commands := Array with: PREditCommand with: PRMoveCommand with: PRRemoveCommand.
	contexts := (commands
		collect: [ :class | self context structure: aNote command: class new ])
		select: [ :each | each isValid ].
	contexts isEmpty ifTrue: [ ^ self ].
	html span class: 'commands'; with: [
		contexts
			do: [ :each | html anchor goto: each; with: each command label ]
			separatedBy: [ html text: ', ' ] ].
	html text: ' '
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNoteMetaPublication: aNote on: html [ 
	html span
		class: 'publication';
		with: '(' , aNote timestamp asDate printString , 
			', ' , aNote timestamp asTime printMinutes ,
			')'.
	html text: ' '
]

{ #category : #'rendering-listing' }
BONoteWidget >> renderNotes: aCollection on: html [
	aCollection isEmpty
		ifTrue: [ ^ self ].
	html div class: 'listing'; with: [
		html heading: 'User Contributed Notes'.
		aCollection do: [ :each |
			self renderNote: each on: html ] ]
]

"
I am an abstract superclass of the command pattern in Pier. All modifications to the model have to be done through subclasses of myself, else they do not get properly logged with the persistency mechanism. I hold the context in which the receiver is executed in the instance variable context. To modify the resulting context, create a copy of the current context and store it in the instance variable answer.

The following event-handlers are called when executing an action in the given order. Do override these messages to customize the command, never override the other internal methods:
- Override the message ==#doValidate== to check the valid setup of the command and to raise exceptions in case any precondition isn't met. Speak here or forever have your peace! Don't change the model in there.
- Override the message ==#doExecute== to execute the actual command. Do not raise exceptions in there, catch all the problems in ==#doValidate==.
- Override the message ==#doPersistency== to save the command that has been just executed with the current persistency strategy. Most commands don't need to override this message and just stick with the default behavior.
- Override the message ==#doAnswer== to create the answer context. Most commands don't need to override this message and just stick with the default behavior.

Do not play with funny jumpy things, such as resumable exceptions or continuations, inside the code of the command hierarchy or you will very likely run into severe problems.
"
Class {
	#name : #PRCommand,
	#superclass : #PRObject,
	#instVars : [
		'timestamp',
		'context',
		'checked',
		'successAnswer',
		'cancelAnswer'
	],
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PRCommand class >> accessKey [
	^ nil
]

{ #category : #'instance creation' }
PRCommand class >> context: aContext [
	(self isValidIn: aContext)
		ifFalse: [ self error: self label , ' is not useable in the given context.' ].
	^ self new
		setContext: aContext;
		yourself
]

{ #category : #testing }
PRCommand class >> isValidIn: aContext [
	"Verify that a command as a meaning for the context aContext. Override this command to add new constraints that are static to the command."

	^ aContext structure isValidCommand: self in: aContext
]

{ #category : #accessing }
PRCommand class >> shortLabel [
	^ self label
]

{ #category : #accessing }
PRCommand class >> structureClass [
	^ PRStructure
]

{ #category : #deprecated }
PRCommand >> answer [
	self
		greaseDeprecatedApi: 'PRCommand>>#answer'
		details: 'Use PRCommand>>#successAnswer instead.'.
	^ self successAnswer
]

{ #category : #deprecated }
PRCommand >> answer: aContext [
	self
		greaseDeprecatedApi: 'PRCommand>>#answer:'
		details: 'Use PRCommand>>#successAnswer: instead.'.
	self successAnswer: aContext
]

{ #category : #toggling }
PRCommand >> beChecked [
	"Enable checks when executing the receiver. This is the default."

	checked := true
]

{ #category : #toggling }
PRCommand >> beUnchecked [
	"Disable checks when executing the receiver. Do this only in a trusted environment and if you are absolutely sure that the execution will cause no conflicts."

	checked := false
]

{ #category : #'accessing-answering' }
PRCommand >> cancelAnswer [
	"Return a new context that should be activated after canceling this action. Since the answer might get modified afterwards, this should always be a copy."

	^ cancelAnswer isNil
		ifFalse: [ cancelAnswer copy ]
		ifTrue: [ self defaultCancelAnswer ]
]

{ #category : #'accessing-answering' }
PRCommand >> cancelAnswer: aContext [
	"Set the context to be used next after cancelling of the action."
	
	cancelAnswer := aContext
]

{ #category : #'accessing-readonly' }
PRCommand >> context [
	"Return the current context of the receiver."

	^ context
]

{ #category : #'accessing-readonly' }
PRCommand >> date [
	"Answer the date when the command was executed."

	^ self timestamp isNil ifFalse: [ self timestamp asDate ]
]

{ #category : #'accessing-defaults' }
PRCommand >> defaultCancelAnswer [
	"Answer the default context to be returned to after cancelling this command."
	
	^ self context structure: self context structure
]

{ #category : #'accessing-defaults' }
PRCommand >> defaultSuccessAnswer [
	"Answer the default context to be returned to after executing this command."
	
	^ self context structure: self context structure
]

{ #category : #events }
PRCommand >> doAnswer [
	"Override this message to create the success answer context. Most commands don't need to override this message and just stick with the default behavior."
]

{ #category : #events }
PRCommand >> doExecute [
	"Override this message to execute the actual command. Do not raise exceptions in there, catch all the problems in ==#doValidate==."
]

{ #category : #events }
PRCommand >> doValidate [
	"Override this message to check the valid setup of the command and to raise exceptions in case any precondition isn't met. Speak here or forever have your peace! Don't change the model in there."

	self structure validateCommand: self
]

{ #category : #actions }
PRCommand >> execute [
	"Execute the command of the receiver. To implement your action in the code of one of my subclasses. Never override this message, but instead have a look at the different template methods (==#doValidate==, ==#doExecute==, ==#doAnswer==) available in the events protocol."
	
	self context command == self 
		ifFalse: [ self error: 'Attempt to execute command outside its context.' ].
	self isView
		ifTrue: [ self error: 'Attempt to execute view.' ].
	self timestamp: GRPlatform current magritteTimeStampClass now.
	self kernel persistency execute: self.
	self doAnswer
]

{ #category : #testing }
PRCommand >> isChecked [
	"Answer ==true== if the command should be checked before execution, e.g. the method ==#doValidate== should be executed at all."

	^ checked ifNil: [ checked := true ]
]

{ #category : #testing }
PRCommand >> isEdit [
	^ false
]

{ #category : #testing }
PRCommand >> isLogged [
	"Most commands are logged. This means they do modify the model and are therefore preserved in the history. However there are some that just display something or change the state of the current context and neither change the model nor need to be logged."

	^ true
]

{ #category : #testing }
PRCommand >> isQuick [
	"Quick commands do not have a configuration interface (probably not even Magritte descriptions) and therefore should not be presented to the user but simply executed."

	^ false
]

{ #category : #testing }
PRCommand >> isView [
	"Most commands are not a view. This means they override ==#doExecute== to do something meaningful on the context or the model."

	^ false
]

{ #category : #'accessing-readonly' }
PRCommand >> kernel [
	"Answer the kernel the receiver is working on."

	^ self context kernel
]

{ #category : #'accessing-readonly' }
PRCommand >> label [
	^ self class label
]

{ #category : #'accessing-readonly' }
PRCommand >> root [
	^ self context kernel root
]

{ #category : #private }
PRCommand >> sanitizeAnswers [
	<sanitize>
	
	successAnswer := cancelAnswer := nil
]

{ #category : #initialization }
PRCommand >> setContext: aContext [
	context := aContext
]

{ #category : #'accessing-readonly' }
PRCommand >> structure [
	^ self context structure
]

{ #category : #'accessing-answering' }
PRCommand >> successAnswer [
	"Return a new context that should be activated after successfully executing this action. Since the answer might get modified afterwards, this should always be a copy."
	
	^ successAnswer isNil
		ifFalse: [ successAnswer copy ]
		ifTrue: [ self defaultSuccessAnswer ]
]

{ #category : #'accessing-answering' }
PRCommand >> successAnswer: aContext [
	"Set the context to be used next after successful execution of the action."

	successAnswer := aContext
]

{ #category : #'accessing-readonly' }
PRCommand >> time [
	"Answer the date when the command was executed."

	^ self timestamp isNil ifFalse: [ self timestamp asTime ]
]

{ #category : #accessing }
PRCommand >> timestamp [
	^ timestamp
]

{ #category : #accessing }
PRCommand >> timestamp: aTimeStamp [
	timestamp := aTimeStamp
]

{ #category : #private }
PRCommand >> uniqueName: aString in: aStructure [
	"Answer an unique structure name with the prefix aString within the parent aStructure."

	| index name |
	(aStructure isNil or: [ aStructure hasChildren not ])
		ifTrue: [ ^ aString ].
	(aStructure childrenDecoration includes: aString)
		ifFalse: [ ^ aString ].
	index := 1.
	[ aStructure childrenDecoration includes: (name := aString , '-' , (index := index + 1) greaseString) ] 
		whileTrue.
	^ name
]

{ #category : #validating }
PRCommand >> validateChild: aChildStructure in: aStructure [
	"Make sure that ==aChildStructure== can be added as child or replace an existing child in a ==aStructure==."

	self validateChild: aChildStructure named: aChildStructure name in: aStructure
]

{ #category : #validating }
PRCommand >> validateChild: aChildStructure named: aString in: aStructure [
	self validateName: aString of: aChildStructure in: aStructure.
	self validateNestingOf: aChildStructure in: aStructure
]

{ #category : #validating }
PRCommand >> validateName: aString of: aChildStructure in: aStructure [
	"Make sure that ==aChildStructure== with the title ==aString== can be added as child or replace an existing child in a ==aStructure==."

	| child |
	(aStructure isNil or: [ aStructure hasChildren not ])
		ifTrue: [ ^ self ].
	child := aStructure childrenDecoration
		at: aString
		ifAbsent: [ ^ self ].
	child == aChildStructure
		ifFalse: [ PRConflictingNameError description: self magritteDescription signal: aString printString , ' conflicts in ' , aStructure title printString ]
]

{ #category : #validating }
PRCommand >> validateNestingOf: aChildStructure in: aStructure [
	"Make sure that ==aChildStructure== can be added as child to ==aStructure== and that ==aStructure== can have ==aChildStructure== as a child."

	aStructure isNil
		ifTrue: [ ^ self ].
	((aStructure canBeParentOf: aChildStructure)
		and: [ aChildStructure canBeChildOf: aStructure ])
			ifTrue: [ ^ self ].
	PRInvalidNestingError
		description: self magritteDescription
		signal: aChildStructure title printString , ' can not be a child of ' , aStructure title printString
]

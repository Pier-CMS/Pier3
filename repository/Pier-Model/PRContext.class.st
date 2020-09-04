"
I am the context in which a user is browsing the system. I hold all the information any part of Pier might be interested in: the currently used kernel, the structure that is currently displayed, the command that is being executed and the user currently logged in.

I am an immutable object. Users should never try to modify me. Instead use the modification methods that return a copy of myself.
"
Class {
	#name : #PRContext,
	#superclass : #PRObject,
	#instVars : [
		'kernel',
		'structure',
		'command'
	],
	#category : #'Pier-Model-Kernel'
}

{ #category : #testing }
PRContext class >> isAbstract [
	^ false
]

{ #category : #'instance creation' }
PRContext class >> kernel: aKernel [
	^ self kernel: aKernel structure: aKernel root
]

{ #category : #'instance creation' }
PRContext class >> kernel: aKernel structure: aStructure [
	^ self kernel: aKernel structure: aStructure command: aStructure viewCommandClass new
]

{ #category : #'instance creation' }
PRContext class >> kernel: aKernel structure: aStructure command: aCommand [
	^ self new
		setKernel: aKernel;
		setStructure: aStructure;
		setCommand: aCommand;
		yourself
]

{ #category : #accessing }
PRContext >> command [
	"Answer the active command of this context."

	^ command
]

{ #category : #navigation }
PRContext >> command: aCommand [
	"Create a copy of the current context with the current command replaced by ==aCommand==."

	^ self structure: self structure command: aCommand
]

{ #category : #'accessing-convenience' }
PRContext >> commands [
	"Answer a list of possible commands, dispatching through the command class."

	^ PRCommand withAllConcreteClasses
		select: [ :each | each isValidIn: self ]
]

{ #category : #descriptions }
PRContext >> descriptionCommand [
	<magritteDescription>
	^ MAStringDescription new
		chainAccessor: #(#command #label);
		label: 'Command';
		priority: 200;
		beReadOnly;
		yourself
]

{ #category : #descriptions }
PRContext >> descriptionDate [
	<magritteDescription>
	^ MADateDescription new
		accessor: #(#command #date);
		parameterName: 'date';
		priority: 300;
		label: 'Date';
		beReadOnly;
		yourself
]

{ #category : #descriptions }
PRContext >> descriptionStructure [
	<magritteDescription>
	^ PRStructureDescription new
		accessor: (MASelectorAccessor read: #structure write: #setStructure:);
		label: 'Structure';
		priority: 100;
		yourself
]

{ #category : #descriptions }
PRContext >> descriptionTime [
	<magritteDescription>
	^ MATimeDescription new
		accessor: #(#command #time);
		parameterName: 'time';
		priority: 400;
		label: 'Time';
		beReadOnly;
		yourself
]

{ #category : #enumerating }
PRContext >> enumerator [
	"Answer an enumerator on the current context."

	^ self enumeratorFor: self structure
]

{ #category : #enumerating }
PRContext >> enumeratorFor: aStructure [
	"Answer an enumerator on ==aStructure==."

	^ PRChildrenVisitor on: aStructure
]

{ #category : #testing }
PRContext >> isValid [
	"Answer ==true== if the receiver is a valid context."

	^ self isValidCommand: self command class
]

{ #category : #testing }
PRContext >> isValidCommand: aCommandClass [
	"Answer ==true== if the receiver is a valid context with the current command replaced by ==aCommandClass==."

	^ aCommandClass isValidIn: self
]

{ #category : #accessing }
PRContext >> kernel [
	"Answer the underlying kernel of this context."

	^ kernel
]

{ #category : #'accessing-convenience' }
PRContext >> parent [
	"Answer the parent structure of the current structure or nil."

	^ self structure parent
]

{ #category : #copying }
PRContext >> postCopy [
	super postCopy.
	self setCommand: command copy
]

{ #category : #printing }
PRContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' structure: '; print: self structure title.
	aStream nextPutAll: ' command: '; print: self command class label
]

{ #category : #'accessing-convenience' }
PRContext >> root [
	"Answer the current root node of the structure-tree."

	^ self kernel root
]

{ #category : #copying }
PRContext >> sanitize [
	"This method is used to prepare the receiver for persistent storage. Use it to clear temporal caches or references to UI objects."

	(Pragma allNamed: #sanitize from: self class to: PRContext)
		do: [ :pragma | self perform: pragma methodSelector ].
	(Pragma allNamed: #sanitize from: self command class to: PRCommand)
		do: [ :pragma | self command perform: pragma methodSelector ]
]

{ #category : #initialization }
PRContext >> setCommand: aCommand [
	command := aCommand.
	command setContext: self
]

{ #category : #initialization }
PRContext >> setKernel: aKernel [
	kernel := aKernel
]

{ #category : #initialization }
PRContext >> setStructure: aStructure [
	structure := aStructure
]

{ #category : #'accessing-convenience' }
PRContext >> siblings [
	"Answer a collection of siblings including the current structure."

	^ self parent isNil 
		ifTrue: [ Array with: self structure ]
		ifFalse: [
			(self enumeratorFor: self parent)
				contents ]
]

{ #category : #accessing }
PRContext >> structure [
	"Answer the currently browsed structure of this context."

	^ structure
]

{ #category : #navigation }
PRContext >> structure: aStructure [
	"Create a copy of the current context with the current structure replaced by ==aStructure== and the current command replaced by the default view."

	^ self structure: aStructure command: aStructure viewCommandClass new
]

{ #category : #navigation }
PRContext >> structure: aStructure command: aCommand [
	"Create a copy of the current context with the current structure replaced by ==aStructure== and the current command by ==aCommand==."

	^ self copy
		setStructure: aStructure;
		setCommand: aCommand;
		yourself
]

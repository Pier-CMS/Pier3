"
An abstract persistency strategy. To use assign to a kernel by evaluating:

= aKernel persistency: PRNullPersistency new
"
Class {
	#name : #PRPersistency,
	#superclass : #PRObject,
	#instVars : [
		'kernel',
		'mutex'
	],
	#category : #'Pier-Model-Persistence'
}

{ #category : #testing }
PRPersistency class >> isAbstract [
	^ self name = #PRPersistency
]

{ #category : #protected }
PRPersistency >> apply: aCommand [
	"This method should not be called directly. It performs the basic execution of aCommand in the context of the receiver."

	aCommand isChecked
		ifTrue: [ aCommand doValidate ].
	aCommand doExecute
]

{ #category : #configuration }
PRPersistency >> defaultMutex [
	^ GRPlatform current semaphoreClass forMutualExclusion
]

{ #category : #enumerating }
PRPersistency >> do: aBlock [
	"Evaluates aBlock in chronological order for every item in the history of the kernel."

	self subclassResponsibility
]

{ #category : #enumerating }
PRPersistency >> do: aBlock for: aStructure [
	"Evaluates aBlock in chronological order for every item in the history of aStructure. Subclasses might want to override the default implementation for efficiency."

	self do: [ :each |
		each structure = aStructure
			ifTrue: [ aBlock value: each ] ]
]

{ #category : #actions }
PRPersistency >> execute: aCommand [
	"Execute aCommand using the persistency of the receiver. Subclasses might override this method, e.g. to create a transitional logic or to commit changes after execution. Make sure that you always perform the method ==#apply:== when overriding this code."

	self mutex critical: [ self apply: aCommand ]
]

{ #category : #convenience }
PRPersistency >> history [
	^ Array streamContents: [ :stream |
		self do: [ :each |
			stream nextPut: each ] ]
]

{ #category : #convenience }
PRPersistency >> historyFor: aStructure [
	^ Array streamContents: [ :stream |
		self
			do: [ :each | stream nextPut: each ]
			for: aStructure ]
]

{ #category : #initialization }
PRPersistency >> initialize [
	super initialize.
	self initializeMagritte.
	mutex := self defaultMutex
]

{ #category : #accessing }
PRPersistency >> kernel [
	^ kernel
]

{ #category : #accessing }
PRPersistency >> mutex [
	"Return a mutex (an object that understands #critical:) to ensure that only one process is modifying the model at once. This is needed to make certain that the model remains in a consistent state. All write access must go through this mutex."

	^ mutex
]

{ #category : #enumerating }
PRPersistency >> reverseDo: aBlock [
	"Evaluates aBlock in inverse chronological order for every item in the history of a structure. Subclasses might want to override the default implementation for efficiency."

	self history reverseDo: aBlock
]

{ #category : #enumerating }
PRPersistency >> reverseDo: aBlock for: aStructure [
	"Evaluates aBlock in inverse chronological order for every item in the history of aStructure. Subclasses might want to override the default implementation for efficiency."

	(self historyFor: aStructure)
		reverseDo: aBlock
]

{ #category : #initialization }
PRPersistency >> setKernel: aKernel [
	"Set the kernel the receiver is supposed to run on."

	kernel := aKernel
]

"
I am an abstract parent of persistencies that save every now and again.

    Instance Variables
	duration:		<Duragion>
	message:		<String>
	process:		<Object>


"
Class {
	#name : #PRDelayedPersistency,
	#superclass : #PRHistoryPersistency,
	#instVars : [
		'duration',
		'process',
		'message'
	],
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #testing }
PRDelayedPersistency class >> isAbstract [
	^ self name = #PRDelayedPersistency
]

{ #category : #descriptions }
PRDelayedPersistency >> descriptionDuration [
	<magritteDescription>
	^ MADurationDescription new
		comment: 'The minimum interval between two snapshots.';
		accessor: #duration;
		label: 'Duration';
		default: 1 hour;
		priority: 100;
		beRequired;
		yourself
]

{ #category : #descriptions }
PRDelayedPersistency >> descriptionMessage [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #message;
		label: 'Message';
		group: 'Status';
		priority: 200;
		beReadOnly;
		yourself
]

{ #category : #accessing }
PRDelayedPersistency >> duration [
	^ duration
]

{ #category : #accessing }
PRDelayedPersistency >> duration: aDuration [
	"The minimum interval between two snapshots."

	duration := aDuration
]

{ #category : #actions }
PRDelayedPersistency >> execute: aCommand [
	self mutex critical: [
		self apply: aCommand.
		aCommand isLogged ifTrue: [
			self add: aCommand context.
			self log: aCommand context.
			self start ] ]
]

{ #category : #testing }
PRDelayedPersistency >> isScheduled [
	^ process notNil and: [ process isTerminated not ] 
]

{ #category : #private }
PRDelayedPersistency >> log: aContext [
	| stream |
	stream := (FileSystem disk workingDirectory / 'transactions.txt') writeStream.
	[ self log: aContext on: stream setToEnd ]
		ensure: [ stream close ]
]

{ #category : #private }
PRDelayedPersistency >> log: aContext on: aStream [
	aStream nextPutAll: ' == '; nextPutAll: aContext command class label; nextPutAll: ' == '; cr.
	aStream nextPutAll: ' -- context -- '; cr.
	aContext magritteDescription do: [ :each |
		aStream
			nextPutAll: each label; nextPutAll: ': ';
			nextPutAll: (each toString: (aContext
				readUsing: each)); cr ].
	aStream nextPutAll: ' -- command -- '; cr.
	aContext command magritteDescription do: [ :each |
		aStream
			nextPutAll: each label; nextPutAll: ': ';
			nextPutAll: (each toString: (aContext command
				readUsing: each)); cr ].
	aStream cr; cr
]

{ #category : #accessing }
PRDelayedPersistency >> message [
	^ message
]

{ #category : #accessing }
PRDelayedPersistency >> message: aString [
	message := aString
]

{ #category : #private }
PRDelayedPersistency >> process [
	(Delay forDuration: self duration)
		wait.
	Processor activeProcess
		priority: Processor highestPriority.
	process := nil.
	self snapshot
]

{ #category : #actions }
PRDelayedPersistency >> sanitize [
	super sanitize.
	self stop
]

{ #category : #initialization }
PRDelayedPersistency >> setKernel: aKernel [
	super setKernel: aKernel.
	self stop
]

{ #category : #actions }
PRDelayedPersistency >> snapshot [
	"Take a snapshot and perform cleanup tasks."

	self subclassResponsibility
]

{ #category : #actions }
PRDelayedPersistency >> start [
	"Schedule the receiver to take a snapshot after the configured duration."

	self isScheduled
		ifTrue: [ ^ self ].
	process := [ self process ]
		newProcess.
	process 
		priority: Processor userBackgroundPriority;
		name: 'pier'.
	process resume
]

{ #category : #actions }
PRDelayedPersistency >> stop [
	"Stop the configured snapshot."

	self isScheduled
		ifTrue: [ process terminate ].
	process := nil 
]

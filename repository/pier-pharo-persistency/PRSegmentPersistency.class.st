Class {
	#name : #PRSegmentPersistency,
	#superclass : #PRDelayedPersistency,
	#instVars : [
		'namePrefix'
	],
	#category : #'Pier-Pharo-Persistency'
}

{ #category : #testing }
PRSegmentPersistency class >> isAbstract [
	^ true 
]

{ #category : #private }
PRSegmentPersistency >> cleanup [
	"Execute all the registered cleanup code. Do not execute this code within an image you intend to continue using. This is a non-reversible operation and pretty much destroys your complete environment."

	(Pragma allNamed: #cleanup from: self class to: PRSegmentPersistency)
		do: [ :pragma | self perform: pragma selector ].
	Smalltalk garbageCollect
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupKom [
	"Stop all the server adaptors, they just get into our way."
	<cleanup>
	
	WAServerManager shutDown
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupMonticello [
	"Clear monticello caches, they might reference some of our blocks in obscure ways."
	<cleanup>
	
	MCMethodDefinition shutDown.
	MCFileBasedRepository flushAllCaches 
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupPier [
	"Clear all registered kernels. We don't want references to our model from outside."
	<cleanup>
	
	PRKernel instVarNamed: 'Instances' put: nil
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupProcesses [
	"Get rid of pocesses that potentialy still hang somewhere and reference our model. Take care not to kill any of the vital processes."
	<cleanup>

	| protected |
	protected := IdentitySet new.
	protected
		add: Project uiProcess;
		add: Processor activeProcess;
		add: Processor backgroundProcess;
		add: Smalltalk lowSpaceWatcherProcess;
		add: WeakArray runningFinalizationProcess.
	Process allInstances do: [ :each |
		(each isTerminated or: [ Processor highestPriority = each priority or: [ protected includes: each ] ])
			ifFalse: [ each terminate ] ]
	.
	
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupSeaside [
	"Cleanup all the Seaside related objects such as dispatchers, sessions and configurations."
	<cleanup>
	
	WAAdmin clearAll
]

{ #category : #cleanup }
PRSegmentPersistency >> cleanupWorld [
	"Close all windows, just in case we have some workspaces or pier browsers open that reference our model."
	<cleanup>

	World submorphs do: [ :morph | morph delete ].
	World releaseCachedState
]

{ #category : #'accessing-descriptions' }
PRSegmentPersistency >> descriptionNamePrefix [
	<magritteDescription>
	^ MAStringDescription new
		comment: 'Defines the prefix for snapshot files.';
		label: 'Snapshot Prefix';
		accessor: #namePrefix;
		default: 'snapshot_';
		priority: 120;
		beRequired;
		yourself
]

{ #category : #accessing }
PRSegmentPersistency >> directory [
	^ (FileSystem disk workingDirectory / 'snapshots') exists
		ifFalse: [ (FileSystem disk workingDirectory / 'snapshots') createDirectory ]
]

{ #category : #accessing }
PRSegmentPersistency >> namePrefix [
	^ namePrefix
]

{ #category : #accessing }
PRSegmentPersistency >> namePrefix: aString [
	namePrefix := aString
]

{ #category : #private }
PRSegmentPersistency >> serialize: aString [
	| stream pointers |
	stream := self directory forceNewFileNamed: aString.
	pointers := [ [ ImageSegment new writeKernel: self kernel on: stream ]
		ensure: [ stream close ] ]
		on: Exception
		do: [ :error | nil ].
	(pointers isNil
		or: [ pointers anySatisfy: [ :each | (each isLiteral or: [ each isVariableBinding ]) not ] ])
		ifTrue: [ self directory / aString deleteIfAbsent: [  ] ]
]

{ #category : #actions }
PRSegmentPersistency >> snapshot [
	| os filename |
	(os := Smalltalk classNamed: #OSProcess) isNil
		ifTrue: [ ^ self message: 'OSProcess not installed.' ].
	os thisOSProcess pid
		ifTrue: [ ^ self message: 'OSProcess does not support this platform.' ].
	filename := self namePrefix , DateAndTime now asSortableString , '.obj'.
	os thisOSProcess forkHeadlessSqueakAndDo: [
		[ self cleanup; serialize: filename ]
			ensure: [ Smalltalk quitPrimitive ] ].
	self message: 'Last snapshot ' , filename printString , ' at ' , GRPlatform current magritteTimeStampClass now greaseString
]

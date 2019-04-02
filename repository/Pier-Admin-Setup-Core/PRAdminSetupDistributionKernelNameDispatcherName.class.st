Class {
	#name : #PRAdminSetupDistributionKernelNameDispatcherName,
	#superclass : #Object,
	#instVars : [
		'distribution',
		'kernelName',
		'dispatcherName'
	],
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #'as yet unclassified' }
PRAdminSetupDistributionKernelNameDispatcherName class >> kernelName: kernelName dispatcherName: dispatcherName [
	^ self new
		kernelName: kernelName;
		dispatcherName: dispatcherName;
		yourself
]

{ #category : #comparing }
PRAdminSetupDistributionKernelNameDispatcherName >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ kernelName = anObject kernelName
		and: [ dispatcherName = anObject dispatcherName and: [ distribution = anObject distribution ] ]
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> dispatcherName [
	^ dispatcherName
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> dispatcherName: anObject [
	dispatcherName := anObject
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> distribution [
	^ distribution
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> distribution: anObject [
	distribution := anObject
]

{ #category : #comparing }
PRAdminSetupDistributionKernelNameDispatcherName >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ kernelName hash bitXor: (dispatcherName hash bitXor: distribution hash)
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> kernelName [
	^ kernelName
]

{ #category : #accessing }
PRAdminSetupDistributionKernelNameDispatcherName >> kernelName: anObject [
	kernelName := anObject
]

{ #category : #printing }
PRAdminSetupDistributionKernelNameDispatcherName >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' kernelName: ';
		print: kernelName.
	aStream
		nextPutAll: ' dispatcherName: ';
		print: dispatcherName.
	aStream
		nextPutAll: ' distribution: ';
		print: distribution
]

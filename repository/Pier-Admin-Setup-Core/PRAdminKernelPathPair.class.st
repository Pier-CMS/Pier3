Class {
	#name : #PRAdminKernelPathPair,
	#superclass : #Object,
	#instVars : [
		'kernel',
		'path'
	],
	#category : #'Pier-Admin-Setup-Core'
}

{ #category : #'instance creation' }
PRAdminKernelPathPair class >> kernel: kernel path: path [ 
	^ self new
		kernel: kernel;
		path: path;
		yourself
]

{ #category : #'collection creation' }
PRAdminKernelPathPair class >> kernelPathPairs [
	| kernelPathPairs |
	kernelPathPairs := OrderedCollection new.
	
	PRAdminSetup recursiveDispatcherHandersDo: [ :handler :handlerPath |
		| kernel |
		
		[ (handler isApplication and: [ (kernel := handler preferenceAt: #kernel) notNil ]) ifTrue: [
			kernelPathPairs add: (self kernel: kernel path: handlerPath) ]
		 ] 
		"no
		      WARequestHandler>>#preferenceAt:ifAbsent: 
	 	so have to handle the exception"
		on: WAAttributeNotFound do: [ :err | "do nothing" ] ].
	
	^ kernelPathPairs

]

{ #category : #comparing }
PRAdminKernelPathPair >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ path = anObject path and: [ kernel = anObject kernel ]
]

{ #category : #comparing }
PRAdminKernelPathPair >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ path hash bitXor: kernel hash
]

{ #category : #accessing }
PRAdminKernelPathPair >> kernel [
	^ kernel
]

{ #category : #accessing }
PRAdminKernelPathPair >> kernel: anObject [
	kernel := anObject
]

{ #category : #accessing }
PRAdminKernelPathPair >> path [
	^ path
]

{ #category : #accessing }
PRAdminKernelPathPair >> path: anObject [
	path := anObject
]

{ #category : #printing }
PRAdminKernelPathPair >> printOn: aStream [
	aStream 
		nextPutAll: 'kernel (';
		nextPutAll: self kernel name;
		nextPutAll: '), path (';
		nextPutAll: self path;
		nextPut: $)
]

"
I am a visitor used to print a short path from a structure to another one.

!Example
=(PRPathReference
=	from: aFirstStructure
=	to: aSecondStructure)
=		inspect
"
Class {
	#name : #PRPathReference,
	#superclass : #PRPath,
	#instVars : [
		'source',
		'sourcePath',
		'target',
		'targetPath'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #'instance creation' }
PRPathReference class >> from: aFirstStructure to: aSecondStructure [
	^ self new
		setSource: aFirstStructure;
		setTarget: aSecondStructure;
		relativeReference
]

{ #category : #testing }
PRPathReference class >> isAbstract [
	^ false
]

{ #category : #'instance creation' }
PRPathReference class >> to: aStructure [
	^ self new
		setTarget: aStructure;
		absoluteReference
]

{ #category : #actions }
PRPathReference >> absoluteReference [
	self targetPath removeFirst.
	self writeDelimiter.
	self targetPath 	
		do: [ :each | self visit: each ]
		separatedBy: [ self writeDelimiter ].
	^ self stream contents
]

{ #category : #private }
PRPathReference >> hasCommonPath [
	"Answer true if the source and target path start with the same structure."
	
	 ^ self sourcePath notEmpty
		and: [ self targetPath notEmpty
		and: [ self sourcePath first = self targetPath first ] ]
]

{ #category : #initialization }
PRPathReference >> initialize [
	super initialize.
	stream := WriteStream on: String new
]

{ #category : #actions }
PRPathReference >> relativeReference [
	self validateKernel.
	self removeCommonPath.
	self source = self target 
		ifTrue: [ ^ self class currentStructure ].
	self sourcePath reverseDo: [ :each |
		self writeParent; writeDelimiter ].
	self targetPath 	
		do: [ :each | self visit: each; writeDelimiter ].
	^ self stream skip: -1; contents

]

{ #category : #private }
PRPathReference >> removeCommonPath [
	"Remove all common path elements from the source and target path."
	
	[ self hasCommonPath ] whileTrue: [ 
		self sourcePath removeFirst.
		self targetPath removeFirst ]
]

{ #category : #initialization }
PRPathReference >> setSource: aStructure [
	source := aStructure.
	sourcePath := aStructure parents
]

{ #category : #initialization }
PRPathReference >> setTarget: aStructure [
	target := aStructure.
	targetPath := aStructure parents
]

{ #category : #accessing }
PRPathReference >> source [
	^ source
]

{ #category : #accessing }
PRPathReference >> sourcePath [
	^ sourcePath
]

{ #category : #accessing }
PRPathReference >> target [
	^ target
]

{ #category : #accessing }
PRPathReference >> targetPath [
	^ targetPath
]

{ #category : #private }
PRPathReference >> validateKernel [
	"Validate that the source and target are contained within the same kernel. This is done by comparing the root structure."
	
	self hasCommonPath
		ifFalse: [ PRInvalidKernelError signal: 'Unable to reference external wiki.' ]
]

{ #category : #visiting }
PRPathReference >> visitStructure: aStructure [
	stream nextPutAll: aStructure name
]

{ #category : #'private-writing' }
PRPathReference >> writeDelimiter [
	stream nextPut: self class pathDelimiter
]

{ #category : #'private-writing' }
PRPathReference >> writeParent [
	stream nextPutAll: self class parentStructure
]

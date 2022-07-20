Class {
	#name : #PRKernelCreatorBase,
	#superclass : #GRObject,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-Exporter-Code'
}

{ #category : #'instance creation' }
PRKernelCreatorBase class >> register [
	^ self new register
]

{ #category : #helpers }
PRKernelCreatorBase >> clearInternalLinkTargetsStartingAt: startingStructure [
	"PRDocumentItem content is created before all the parents and children have
	been wired together, resulting in incorrectly realised internal links. Here we clear
	the links target which will be reinitialised when the link is first visited."
	startingStructure enumerator with; all; do: [ :each |
		each outgoingReferences do: [ :link |
			(link isKindOf: PRInternalLink) ifTrue: [ link target: nil ] ] ]
]

{ #category : #creation }
PRKernelCreatorBase >> createKernel [
	" building the kernel takes time and may fail. We start doing so in a local variable "

	| retVal |
	retVal := PRKernel new
		name: self kernelName;
		yourself.
	self addGroupsToKernel: retVal.
	self addUsersToKernel: retVal.
	retVal root: (self root: retVal).
	self clearInternalLinkTargetsStartingAt: retVal root.
	self postExportKernel: retVal root.
	" and register this kernel. Make sure we do not create a new one, if there already was one. "
	^ kernel := (PRKernel instanceNamed: self kernelName)
		root: retVal root;
		groups: retVal groups andUsers: retVal users;
		yourself
]

{ #category : #constants }
PRKernelCreatorBase >> dispatcherPathName [
	self subclassResponsibility
]

{ #category : #creation }
PRKernelCreatorBase >> kernel [
	^ kernel
]

{ #category : #constants }
PRKernelCreatorBase >> kernelName [
	self subclassResponsibility
]

{ #category : #helpers }
PRKernelCreatorBase >> postExportKernel: aKernel [
	"This is the reverse of: PRKernelCodeExporter>>#preExportKernel: "
	aKernel root enumerator
		all;
		do: [ :page | 
			page outgoingReferences
				do: [ :link | 
					(link isInternal
						and: [ link reference first = $/
								and: [ page parents includes: link target ] ])
						ifTrue: [ link reference: (page relativePathTo: link target) ] ] ]
]

{ #category : #creation }
PRKernelCreatorBase >> register [ 
	^ PRPierFrame registerAsApplication: self dispatcherPathName kernel: self createKernel
]

Class {
	#name : #PRKernelTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-Tests-Model-Kernel'
}

{ #category : #testing }
PRKernelTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRKernelTest >> actualClass [
	^ PRKernel
]

{ #category : #accessing }
PRKernelTest >> instance [
	^ self kernel
]

{ #category : #accessing }
PRKernelTest >> kernel [
	^ kernel ifNil: [ kernel := self kernelInstance ]
]

{ #category : #tests }
PRKernelTest >> testInitialState [
	self deny: self kernel name isNil.
	self deny: self kernel root isNil.
	self deny: self kernel persistency isNil
]

{ #category : #'tests-accessing' }
PRKernelTest >> testName [
	self kernel name: 'kernel'.
	self assert: self kernel name = 'kernel'
]

{ #category : #'tests-accessing' }
PRKernelTest >> testPersistency [
	| persistency1 persistency2 |
	self kernel persistency: (persistency1 := PRHistoryPersistency new).
	self assert: self kernel persistency = persistency1.
	self assert: self kernel = persistency1 kernel.

	self kernel persistency: (persistency2 := PRNullPersistency new).
	self assert: persistency1 kernel isNil.
	self assert: self kernel persistency = persistency2.
	self assert: self kernel = persistency2 kernel.
		
	self kernel persistency: nil.
	self assert: persistency2 kernel isNil.
	self assert: self kernel persistency kernel = self kernel
]

{ #category : #'tests-accessing' }
PRKernelTest >> testRoot [
	| structure |
	self kernel root: (structure := PRPage new).
	self assert: self kernel root = structure
]

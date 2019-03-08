"
For persistency tests we do not bypass PRKernel instances, 
instead we use kernels prefixed with '####'.
"
Class {
	#name : #PRPersistencyTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-Tests-Model-Persistence'
}

{ #category : #testing }
PRPersistencyTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRPersistencyTest >> actualClass [
	^ PRPersistency
]

{ #category : #running }
PRPersistencyTest >> editTitle: aString [
	| context |
	context := PRContext 
		kernel: self kernel 
		structure: self kernel root
		command: (PREditCommand new
			write: aString
			using: PRPage new descriptionTitle).
	^ context command
]

{ #category : #accessing }
PRPersistencyTest >> instance [
	^ self persistency
]

{ #category : #accessing }
PRPersistencyTest >> kernel [
	^ kernel ifNil: [ kernel := self kernelInstance ]
]

{ #category : #accessing }
PRPersistencyTest >> mutex [
	^ self persistency mutex
]

{ #category : #accessing }
PRPersistencyTest >> persistency [
	^ self kernel persistency
]

{ #category : #private }
PRPersistencyTest >> persistencyInstance [
	^ self actualClass new
]

{ #category : #running }
PRPersistencyTest >> tearDown [
	self kernel persistency: PRNullPersistency new
]

{ #category : #'tests-smoke' }
PRPersistencyTest >> testConveniance [
	self assert: (self persistency history) isCollection.
	self assert: (self persistency historyFor: self kernel root) isCollection
]

{ #category : #'tests-smoke' }
PRPersistencyTest >> testEnumeration [
	self persistency do: [ :each | ].
	self persistency do: [ :each | ] for: self kernel root.
	
	self persistency reverseDo: [ :each | ].
	self persistency reverseDo: [ :each | ] for: self kernel root
]

{ #category : #'tests-mutex' }
PRPersistencyTest >> testMutexError [
	"An error inside the critical section should properly unlock it for others to enter."

	| marker |
	marker := nil.
	self
		should: [ self mutex critical: [ 1 / 0 ] ]
		raise: ZeroDivide.

	self mutex critical: [ marker := 1 ].
	self assert: marker = 1
]

{ #category : #'tests-mutex' }
PRPersistencyTest >> testMutexSimple [
	| marker |
	marker := nil.
	self mutex critical: [ marker := 1 ].
	self assert: marker = 1
]

{ #category : #tests }
PRPersistencyTest >> testSetup [
	self assert: self persistency kernel = self kernel.
	self assert: self kernel persistency = self persistency
]

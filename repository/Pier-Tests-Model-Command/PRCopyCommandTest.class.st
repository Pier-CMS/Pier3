Class {
	#name : #PRCopyCommandTest,
	#superclass : #PRLocationCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRCopyCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRCopyCommandTest >> actualClass [
	^ PRCopyCommand
]

{ #category : #tests }
PRCopyCommandTest >> testCopy [
	self command name: 'foo'.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: (self structure parent childrenDecoration
		includes: 'foo').
	self assert: (self structure parent childrenDecoration
		at: 'foo') = self command successAnswer structure
]

{ #category : #tests }
PRCopyCommandTest >> testCopyIntoChild [
	self command
		name: 'foo';
		target: self structure.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: (self structure childrenDecoration
		includes: 'foo').
	self assert: (self structure childrenDecoration
		at: 'foo') = self command successAnswer structure
]

{ #category : #tests }
PRCopyCommandTest >> testCopyIntoRoot [
	self command
		name: 'foo';
		target: self command root.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: (self command root childrenDecoration
		includes: 'foo').
	self assert: (self command root childrenDecoration
		at: 'foo') = self command successAnswer structure
]

{ #category : #tests }
PRCopyCommandTest >> testCopyTitle [
	self command name: 'foo'; execute.
	self assert: (self structure title) = 'Command'.
	self assert: (self structure parent childrenDecoration
		at: 'foo') title = 'Foo'
]

{ #category : #tests }
PRCopyCommandTest >> testInitialized [
	super testInitialized.
	self assert: self structure name , '-2' = self command name
]

{ #category : #tests }
PRCopyCommandTest >> testLinkInside [
	| inner |
	inner := PRPage named: 'child'.
	self command structure addChild: inner.
	inner contents: '*/command/child*'.
	self command structure contents: '*child*'.
	self command target: self command root.
	self command execute.
	self assert: self command structure contents =  '*child*'.
	self assert: inner contents = '*/command/child*'.
	self assert: (self command root lookupPath: self command name) contents =  '*child*'.
	self assert: (self command root lookupPath: self command name , '/child') contents = ('*/' ,  self command name , '/child*')
]

{ #category : #tests }
PRCopyCommandTest >> testLinkOutside [
	self command root contents: '*/command*'.
	self command target: self command root.
	self command name: 'other'.
	self command execute.
	self assert: self command root contents = '*/command*'
]

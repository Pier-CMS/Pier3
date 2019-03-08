Class {
	#name : #PRContextTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'context'
	],
	#category : #'Pier-Tests-Model-Kernel'
}

{ #category : #testing }
PRContextTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRContextTest >> actualClass [
	^ PRContext
]

{ #category : #accessing }
PRContextTest >> context [
	^ context ifNil: [ context := self contextInstance ]
]

{ #category : #accessing }
PRContextTest >> instance [
	^ self context
]

{ #category : #'tests-conveniance' }
PRContextTest >> testCommands [
	self assert: (self context commands notEmpty).
	self assert: (self context commands includes: PRViewCommand).
	self assert: (self context commands includes: PRRemoveCommand) not.
	
	context := self context structure: (self context structure childrenDecoration at: 'folder').
	self assert: (self context commands notEmpty).
	self assert: (self context commands includes: PRViewCommand).
	self assert: (self context commands includes: PRRemoveCommand)

]

{ #category : #tests }
PRContextTest >> testCopy [
	| copy |
	copy := self context copy.
	self assert: self context command context == self context.
	self assert: copy command context == copy
]

{ #category : #tests }
PRContextTest >> testEnumerator [
	| array |
	array := self context enumerator contents.
	self assert: array first name = 'folder'.
	self assert: array size = 1
]

{ #category : #'tests-navigation' }
PRContextTest >> testGotoCommand [
	| current currentStructure currentCommand next nextCommand |
	currentStructure := self context structure.
	currentCommand := self context command.
	current := self context.

	nextCommand := self context structure editCommandClass new.
	next := self context command: nextCommand.
	self deny: current = next.

	self assert: current structure = currentStructure.
	self assert: current command = currentCommand.

	self assert: next structure = currentStructure.
	self assert: next command = nextCommand
]

{ #category : #'tests-navigation' }
PRContextTest >> testGotoStructure [
	| current currentStructure currentCommand next nextStructure |
	currentStructure := self context structure.
	currentCommand := self context command.
	current := self context.

	nextStructure := self context structure childrenDecoration at: 'folder'.
	next := self context structure: nextStructure.
	self deny: current = next.

	self assert: current structure = currentStructure.
	self assert: current command = currentCommand.

	self assert: next structure = nextStructure.
	self assert: next command isView
]

{ #category : #'tests-navigation' }
PRContextTest >> testGotoStructureCommand [
	| current currentStructure currentCommand next nextStructure nextCommand |
	currentStructure := self context structure.
	currentCommand := self context command.
	current := self context.

	nextStructure := self context structure childrenDecoration at: 'folder'.
	nextCommand := nextStructure editCommandClass new.
	next := self context structure: nextStructure command: nextCommand.
	self deny: current = next.

	self assert: current structure = currentStructure.
	self assert: current command = currentCommand.

	self assert: next structure = nextStructure.
	self assert: next command = nextCommand
]

{ #category : #tests }
PRContextTest >> testInitialState [
	self assert: self context structure = self context root.
	self assert: self context command isView
]

{ #category : #'tests-conveniance' }
PRContextTest >> testParent [
	self assert: self context parent isNil.
	
	context := self context structure: (self context structure childrenDecoration at: 'folder').
	self assert: self context root == self context parent.

	context := self context structure: (self context structure childrenDecoration at: 'child').
	self assert: (self context root childrenDecoration at: 'folder') == context parent
]

{ #category : #'tests-conveniance' }
PRContextTest >> testRoot [
	self assert: self context root == self context structure.
	
	context := self context structure: (self context structure childrenDecoration at: 'folder').
	self assert: self context root == self context parent.

	context := self context structure: (self context structure childrenDecoration at: 'child').
	self assert: self context root == self context parent parent
]

{ #category : #'tests-conveniance' }
PRContextTest >> testSiblings [
	self assert: self context siblings = (Array with: self context root).
	
	context := self context structure: (self context structure childrenDecoration at: 'folder').
	self assert: self context siblings = (Array with: self context structure).

	context := self context structure: (self context structure childrenDecoration at: 'child').
	self assert: (self context siblings includes: self context structure).
	self assert: self context siblings size = 2
]
